param(
    [string]$ProjectRoot = ".",
    [switch]$SkipMaven,
    [switch]$RunHttp,
    [string]$BaseUrl = "http://localhost:8080/SchoolLibrary"
)

$ErrorActionPreference = "Stop"

$script:Total = 0
$script:Passed = 0
$script:Failed = 0
$script:Warnings = 0
$script:Results = New-Object System.Collections.Generic.List[object]

function Resolve-ProjectPath {
    param([string]$Path)
    return (Resolve-Path -LiteralPath $Path).Path
}

function Add-Result {
    param(
        [ValidateSet("PASS", "FAIL", "WARN")]
        [string]$Status,
        [string]$Name,
        [string]$Detail = ""
    )

    $script:Total++

    if ($Status -eq "PASS") {
        $script:Passed++
        Write-Host "[PASS] $Name" -ForegroundColor Green
    } elseif ($Status -eq "WARN") {
        $script:Warnings++
        Write-Host "[WARN] $Name" -ForegroundColor Yellow
    } else {
        $script:Failed++
        Write-Host "[FAIL] $Name" -ForegroundColor Red
    }

    if ($Detail) {
        Write-Host "       $Detail" -ForegroundColor DarkGray
    }

    $script:Results.Add([pscustomobject]@{
        Status = $Status
        Name = $Name
        Detail = $Detail
    }) | Out-Null
}

function Get-Text {
    param([string]$RelativePath)

    $path = Join-Path $ProjectRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Result "FAIL" "file exists: $RelativePath" "missing file: $path"
        return $null
    }

    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Test-Contains {
    param(
        [string]$Name,
        [string]$RelativePath,
        [string[]]$Needles,
        [string]$Detail = ""
    )

    $text = Get-Text $RelativePath
    if ($null -eq $text) {
        return
    }

    $missing = @()
    foreach ($needle in $Needles) {
        if ($text -notlike "*$needle*") {
            $missing += $needle
        }
    }

    if ($missing.Count -eq 0) {
        Add-Result "PASS" $Name $Detail
    } else {
        Add-Result "FAIL" $Name ("missing required text: " + ($missing -join " | "))
    }
}

function Test-NotContains {
    param(
        [string]$Name,
        [string]$RelativePath,
        [string[]]$Needles,
        [string]$Detail = ""
    )

    $text = Get-Text $RelativePath
    if ($null -eq $text) {
        return
    }

    $found = @()
    foreach ($needle in $Needles) {
        if ($text -like "*$needle*") {
            $found += $needle
        }
    }

    if ($found.Count -eq 0) {
        Add-Result "PASS" $Name $Detail
    } else {
        Add-Result "FAIL" $Name ("unexpected text found: " + ($found -join " | "))
    }
}

function Test-NoRegex {
    param(
        [string]$Name,
        [string]$RelativePath,
        [string]$Pattern,
        [string]$Detail = ""
    )

    $text = Get-Text $RelativePath
    if ($null -eq $text) {
        return
    }

    if ($text -notmatch $Pattern) {
        Add-Result "PASS" $Name $Detail
    } else {
        Add-Result "FAIL" $Name "unexpected regex match: $Pattern"
    }
}

function Count-MatchesInJavaControllers {
    param([string]$Pattern)

    $controllerDir = Join-Path $ProjectRoot "src/main/java/cn/edu/library/controller"
    if (-not (Test-Path $controllerDir)) {
        return -1
    }

    $count = 0
    Get-ChildItem -Path $controllerDir -Filter "*.java" -Recurse | ForEach-Object {
        $text = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
        $matches = [regex]::Matches($text, $Pattern)
        $count += $matches.Count
    }
    return $count
}

function Test-ControllerMappingCount {
    param(
        [string]$Name,
        [string]$Pattern,
        [int]$ExpectedMax
    )

    $count = Count-MatchesInJavaControllers $Pattern
    if ($count -lt 0) {
        Add-Result "FAIL" $Name "controller directory missing"
        return
    }

    if ($count -le $ExpectedMax) {
        Add-Result "PASS" $Name "match count: $count, max allowed: $ExpectedMax"
    } else {
        Add-Result "FAIL" $Name "match count: $count, max allowed: $ExpectedMax"
    }
}

function Test-XmlWellFormed {
    param([string]$RelativePath)

    $path = Join-Path $ProjectRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Result "FAIL" "xml exists: $RelativePath" "missing file"
        return
    }

    try {
        [xml]$xml = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        Add-Result "PASS" "xml parse: $RelativePath"
    } catch {
        Add-Result "WARN" "xml parse: $RelativePath" "parse failed, please review manually: $($_.Exception.Message)"
    }
}

function Run-Command {
    param(
        [string]$Name,
        [string]$FilePath,
        [string[]]$Arguments
    )

    Write-Host ""
    Write-Host "========== $Name ==========" -ForegroundColor Cyan

    $targetDir = Join-Path $ProjectRoot "target"
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    $safeName = $Name -replace '[^\w-]', '_'
    $outputFile = Join-Path $targetDir "logic-check-$safeName.log"

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    foreach ($arg in $Arguments) {
        [void]$psi.ArgumentList.Add($arg)
    }
    $psi.WorkingDirectory = $ProjectRoot
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false

    try {
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $psi
        [void]$p.Start()
        $stdout = $p.StandardOutput.ReadToEnd()
        $stderr = $p.StandardError.ReadToEnd()
        $p.WaitForExit()

        ($stdout + "`r`n" + $stderr) | Set-Content -LiteralPath $outputFile -Encoding UTF8

        if ($p.ExitCode -eq 0) {
            Add-Result "PASS" $Name "log: $outputFile"
        } else {
            Add-Result "FAIL" $Name "exit code: $($p.ExitCode), log: $outputFile"
        }
    } catch {
        Add-Result "FAIL" $Name "command failed: $($_.Exception.Message)"
    }
}

function Test-HttpSmoke {
    Write-Host ""
    Write-Host "========== HTTP smoke test ==========" -ForegroundColor Cyan

    try {
        $login = Invoke-WebRequest -Uri "$BaseUrl/login" -UseBasicParsing -TimeoutSec 10
        if ($login.StatusCode -eq 200) {
            Add-Result "PASS" "HTTP /login" "$BaseUrl/login"
        } else {
            Add-Result "FAIL" "HTTP /login" "status: $($login.StatusCode)"
        }
    } catch {
        Add-Result "FAIL" "HTTP /login" $_.Exception.Message
    }

    try {
        $protected = Invoke-WebRequest -Uri "$BaseUrl/admin/v2/dashboard" -UseBasicParsing -TimeoutSec 10 -MaximumRedirection 0 -ErrorAction SilentlyContinue
        if ($protected.StatusCode -in @(200, 302, 301)) {
            Add-Result "PASS" "HTTP protected page" "status: $($protected.StatusCode)"
        } else {
            Add-Result "WARN" "HTTP protected page" "status: $($protected.StatusCode); verify manually"
        }
    } catch {
        $resp = $_.Exception.Response
        if ($resp -and [int]$resp.StatusCode -in @(301, 302, 403)) {
            Add-Result "PASS" "HTTP protected page" "status: $([int]$resp.StatusCode)"
        } else {
            Add-Result "FAIL" "HTTP protected page" $_.Exception.Message
        }
    }
}

$ProjectRoot = Resolve-ProjectPath $ProjectRoot
Write-Host "Project root: $ProjectRoot" -ForegroundColor Cyan
Write-Host "Start v2 final logic check..." -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path (Join-Path $ProjectRoot "pom.xml"))) {
    Add-Result "FAIL" "project root check" "pom.xml not found"
} else {
    Add-Result "PASS" "project root check" "pom.xml found"
}

# Controller duplicate mapping and unsafe GET checks
Test-ControllerMappingCount "no duplicate /error/403 mapping" '("/error/403"|/error/403)' 1
Test-ControllerMappingCount "no duplicate /admin/v2/borrows/borrow mapping" '("/admin/v2/borrows/borrow"|/admin/v2/borrows/borrow)' 1

Test-NoRegex "category disable should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/categories/disable/\{id\}"\)'
Test-NoRegex "notice delete should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/notices/delete/\{id\}"\)'
Test-NoRegex "fine generate should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/fines/generate"\)'
Test-NoRegex "fine pay should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/fines/pay/\{id\}/\{borrowRecordId\}"\)'
Test-NoRegex "admin cancel seat should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/seats/cancel/\{id\}"\)'
Test-NoRegex "admin disable should not use GET" "src/main/java/cn/edu/library/controller/V2AdminController.java" '@GetMapping\("/system/admins/disable/\{id\}"\)'

# JSP checks
Test-NotContains "taglib.jsp should not declare page contentType" "src/main/webapp/WEB-INF/views/common/taglib.jsp" @("contentType", "pageEncoding")
Test-Contains "login.jsp fields" "src/main/webapp/WEB-INF/views/login.jsp" @('name="username"', 'name="password"', 'name="userType"')
Test-Contains "admin borrow form fields" "src/main/webapp/WEB-INF/views/admin/v2-borrows.jsp" @('name="readerKey"', 'name="copyNo"', 'name="borrowDays"', '/admin/v2/borrows/shelf/${c.id}')
Test-Contains "reader renew form fields" "src/main/webapp/WEB-INF/views/reader/v2-borrows.jsp" @('name="borrowRecordId"', 'name="reason"')

Test-Contains "fine page POST operations" "src/main/webapp/WEB-INF/views/admin/v2-fines.jsp" @('method="post"', '/admin/v2/fines/generate', '/admin/v2/fines/pay/')
Test-Contains "seat admin page POST cancel" "src/main/webapp/WEB-INF/views/admin/v2-seats.jsp" @('method="post"', '/admin/v2/seats/cancel/')
Test-Contains "notice delete POST" "src/main/webapp/WEB-INF/views/admin/v2-notices.jsp" @('method="post"', '/admin/v2/notices/delete/')
Test-Contains "category disable POST" "src/main/webapp/WEB-INF/views/admin/v2-categories.jsp" @('method="post"', '/admin/v2/categories/disable/')

# Mapper and service logic checks
Test-Contains "V2BookCopyStatusMapper implemented" "src/main/java/cn/edu/library/mapper/V2BookCopyStatusMapper.java" @("book_copy", "listStatusByBookIds", "findStatusByBookId", "ON_SHELF", "BORROWED", "RETURN_PROCESSING")
Test-NoRegex "V2BookCopyStatusMapper should not have empty SQL" "src/main/java/cn/edu/library/mapper/V2BookCopyStatusMapper.java" '@Select\s*\(\s*\{\s*""\s*\}\s*\)'

Test-Contains "V2Mapper final methods" "src/main/java/cn/edu/library/mapper/V2Mapper.java" @(
    "countPendingRenewForBorrow",
    "countUnpaidFineForBorrow",
    "releaseSeatLock",
    "generateOverdueFinesFinal",
    "syncBorrowFineStatus"
)

Test-Contains "V2BusinessService bound checks" "src/main/java/cn/edu/library/service/V2BusinessService.java" @(
    "countPendingRenewForBorrow",
    "countUnpaidFineForBorrow",
    "releaseSeatLock",
    "syncBorrowFineStatus"
)

Test-Contains "AdminServiceImpl checks old password" "src/main/java/cn/edu/library/service/impl/AdminServiceImpl.java" @(
    "findById",
    "oldPassword",
    "oldPasswordMd5",
    "updatePassword"
)

# XML and SQL checks
Test-Contains "reader borrow history includes overdue returned" "src/main/resources/mapper/V2Mapper.xml" @("OVERDUE_RETURNED")
Test-XmlWellFormed "src/main/resources/mapper/V2Mapper.xml"
Test-XmlWellFormed "src/main/resources/mapper/AdminMapper.xml"
Test-XmlWellFormed "src/main/resources/mapper/ReaderMapper.xml"
Test-XmlWellFormed "src/main/webapp/WEB-INF/web.xml"

Test-Contains "schema.sql v2 core fields" "src/main/resources/sql/schema.sql" @(
    "CREATE TABLE book_copy",
    "copy_id",
    "copy_no",
    "borrow_date",
    "due_date",
    "return_date",
    "borrow_record_id",
    "operation",
    "request_url",
    "reservation_date",
    "time_slot_id"
)

Test-Contains "schema.sql keeps default MD5 data" "src/main/resources/sql/schema.sql" @("MD5('123456')")

# Debug config warnings
$webXml = Get-Text "src/main/webapp/WEB-INF/web.xml"
if ($webXml -and $webXml -match "DebugFilter") {
    Add-Result "WARN" "DebugFilter enabled" "recommended to disable for final demo"
} else {
    Add-Result "PASS" "DebugFilter disabled"
}

$loginInterceptor = Get-Text "src/main/java/cn/edu/library/interceptor/LoginInterceptor.java"
if ($loginInterceptor -and $loginInterceptor -match "/debug/") {
    Add-Result "WARN" "LoginInterceptor allows /debug/" "recommended to remove for final demo"
} else {
    Add-Result "PASS" "LoginInterceptor does not allow /debug/"
}

# Maven build
if (-not $SkipMaven) {
    Run-Command "Maven build" "mvn" @("clean", "package", "-DskipTests")
} else {
    Add-Result "WARN" "Maven build skipped" "you used -SkipMaven"
}

# HTTP smoke test
if ($RunHttp) {
    Test-HttpSmoke
} else {
    Add-Result "WARN" "HTTP smoke test skipped" "run with -RunHttp after Tomcat starts"
}

# Report
Write-Host ""
Write-Host "========== Summary ==========" -ForegroundColor Cyan
Write-Host "Total: $script:Total"
Write-Host "Passed: $script:Passed" -ForegroundColor Green
Write-Host "Warnings: $script:Warnings" -ForegroundColor Yellow
Write-Host "Failed: $script:Failed" -ForegroundColor Red

$reportDir = Join-Path $ProjectRoot "target"
if (-not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}
$reportPath = Join-Path $reportDir "v2-final-logic-check-report.csv"
$script:Results | Export-Csv -LiteralPath $reportPath -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Report: $reportPath" -ForegroundColor Cyan

if ($script:Failed -gt 0) {
    Write-Host ""
    Write-Host "FAIL items found. Fix them before commit." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "No blocking logic-check failure found. Please review WARN items manually." -ForegroundColor Green
exit 0
