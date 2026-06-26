chcp 65001

cd E:\SchoolLibrary

mvn clean package -DskipTests

$TOMCAT_HOME="C:\apache-tomcat-8.5.58"

Remove-Item "$TOMCAT_HOME\webapps\SchoolLibrary.war" -Force -ErrorAction SilentlyContinue
Remove-Item "$TOMCAT_HOME\webapps\SchoolLibrary" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$TOMCAT_HOME\work\Catalina\localhost\SchoolLibrary" -Recurse -Force -ErrorAction SilentlyContinue

Copy-Item "E:\SchoolLibrary\target\SchoolLibrary.war" "$TOMCAT_HOME\webapps\SchoolLibrary.war"

cd "$TOMCAT_HOME\bin"
.\catalina.bat run