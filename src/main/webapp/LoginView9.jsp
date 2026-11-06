<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập quản lý · RestMan</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/restman.css">
    </head>
    <body>
        <header class="site-header">
            <div class="header-inner">
                <a class="brand" href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">
                    <span class="brand-mark" aria-hidden="true">R</span>
                    <span>
                        RestMan
                        <small>RESTAURANT & MORE</small>
                    </span>
                </a>
                <a class="back" href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">← Nhà hàng</a>
            </div>
        </header>
        <main class="auth-page">
            <section class="auth-card">
                <div class="eyebrow">
                    KHÔNG GIAN QUẢN LÝ
                </div>
                <h1>Chào mừng trở lại.</h1>
                <p>Đăng nhập để xem báo cáo và quản lý nhà hàng.</p>
                <c:if test="${not empty message}">
                    <div class="notice" role="alert">
                        <c:out value="${message}"/>
                    </div>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/login">
                    <div class="field">
                        <label for="username">Tên đăng nhập</label>
                        <input
                            id="username"
                            name="username"
                            maxlength="255"
                            required
                            value="<c:out value='${username}'/>"
                            autocomplete="username"
                            autofocus>
                    </div>
                    <div class="field">
                        <label for="password">Mật khẩu</label>
                        <input
                            id="password"
                            name="password"
                            type="password"
                            maxlength="1024"
                            required
                            autocomplete="current-password">
                    </div>
                    <button type="submit">Đăng nhập →</button>
                </form>
            </section>
        </main>
    </body>
</html>
