<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hello</title>
    </head>
    <body>
        <h1>
            Xin chào,
            <c:out value="${empty name ? 'bạn' : name}"/>
            !
        </h1>
        <form action="${pageContext.request.contextPath}/hello" method="post">
            <label>Nhập tên của bạn:</label>
            <input type="text" name="name" />
            <button type="submit">Gửi</button>
        </form>
        <c:if test="${not empty ans}">
            <h2>Kết quả tìm món:</h2>
            <ul>
                <c:forEach var="d" items="${ans}">
                    <li>
                        <c:out value="${d.name}"/>
                        -
                        <c:out value="${d.price}"/>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <br/>
        <a href="${pageContext.request.contextPath}/home">Về trang chủ</a>
    </body>
</html>
