<%-- 
    【本次修改】公共 JSP 标签库文件

    注意：
    1. 这个文件只放 taglib 指令
    2. 不要在这里写 page contentType / pageEncoding
    3. 否则其他 JSP include 它时，可能导致 JSP 编译冲突
--%>

<%-- JSTL 核心标签库：用于 c:if、c:forEach、c:choose 等 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- JSTL 格式化标签库：用于日期、数字格式化 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 【本次修改】新增 JSTL 函数标签库：用于 fn:length、fn:contains、fn:substring 等 --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>