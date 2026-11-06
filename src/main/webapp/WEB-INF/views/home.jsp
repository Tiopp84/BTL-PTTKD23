<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ</title>
    </head>
    <body>
        <h1>${message}</h1>
        <p>Project Servlet + JSP chạy thành công.</p>
        <a href="${pageContext.request.contextPath}/hello">Đi tới trang Hello</a>
    </body>
</html>
