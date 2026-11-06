<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ quản lý · RestMan</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/restman.css">
    </head>
    <body>
        <header class="site-header">
            <div class="header-inner">
                <a class="brand" href="${pageContext.request.contextPath}/manager/ManagerHomeView9.jsp">
                    <span class="brand-mark" aria-hidden="true">R</span>
                    <span>
                        RestMan
                        <small>RESTAURANT & MORE</small>
                    </span>
                </a>
                <nav class="nav" aria-label="Điều hướng chính">
                    <a class="active" href="${pageContext.request.contextPath}/manager/ManagerHomeView9.jsp">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/manager/statistic/StatisticMainView9.jsp">Thống kê</a>
                    <span class="nav-label">Quản lý</span>
                    <form class="logout-form" method="post" action="${pageContext.request.contextPath}/logout">
                        <input type="hidden" name="token" value="<c:out value='${sessionScope.logoutToken}'/>">
                        <button class="btn secondary" type="submit">Đăng xuất</button>
                    </form>
                </nav>
            </div>
        </header>
        <main class="page">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">← Nhà hàng</a>
                <span>/</span>
                Trang chủ quản lý
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        KHÔNG GIAN QUẢN LÝ
                    </div>
                    <h1>Chào bạn, quản lý.</h1>
                    <p>Theo dõi hoạt động nhập hàng và tra cứu thông tin nhà cung cấp tại một nơi.</p>
                </div>
                <span class="banner-number" aria-hidden="true">R</span>
            </section>
            <div class="section-head">
                <h2>Công việc của bạn</h2>
                <span class="caption">Báo cáo & tra cứu</span>
            </div>
            <a class="menu-card" href="${pageContext.request.contextPath}/manager/statistic/StatisticMainView9.jsp">
                <span class="menu-icon" aria-hidden="true">▥</span>
                <div>
                    <h3>Xem thống kê nhà hàng</h3>
                    <p>Chọn báo cáo, theo dõi lượng nhập và xem chi tiết từng phiếu nhập.</p>
                </div>
                <span class="arrow" aria-hidden="true">→</span>
            </a>
        </main>
        <footer class="site-footer">
            <strong>RestMan · Quản lý nhà hàng</strong>
            <span>Chăm chút từng trải nghiệm.</span>
        </footer>
    </body>
</html>
