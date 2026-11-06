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
        <title>Chọn thống kê · RestMan</title>
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
                    <a href="${pageContext.request.contextPath}/manager/ManagerHomeView9.jsp">Trang chủ</a>
                    <a class="active" href="${pageContext.request.contextPath}/manager/statistic/StatisticMainView9.jsp">Thống kê</a>
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
                <a href="${pageContext.request.contextPath}/manager/ManagerHomeView9.jsp">← Trang chủ quản lý</a>
                <span>/</span>
                Thống kê nhà hàng
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        BÁO CÁO & THỐNG KÊ
                    </div>
                    <h1>Thống kê nhà hàng</h1>
                    <p>Chọn loại báo cáo bạn muốn theo dõi.</p>
                </div>
                <span class="banner-number" aria-hidden="true">01</span>
            </section>
            <div class="menu-grid">
                <div class="menu-card unavailable">
                    <span class="menu-icon" aria-hidden="true">♙</span>
                    <div>
                        <h3>Thống kê khách hàng</h3>
                        <p>Theo dõi thông tin sử dụng dịch vụ.</p>
                        <span class="status-tag">Chưa triển khai</span>
                    </div>
                </div>
                <div class="menu-card unavailable">
                    <span class="menu-icon" aria-hidden="true">≡</span>
                    <div>
                        <h3>Thống kê món ăn</h3>
                        <p>Tổng hợp thông tin món ăn tại nhà hàng.</p>
                        <span class="status-tag">Chưa triển khai</span>
                    </div>
                </div>
                <div class="menu-card unavailable">
                    <span class="menu-icon" aria-hidden="true">▦</span>
                    <div>
                        <h3>Thống kê nguyên liệu</h3>
                        <p>Theo dõi nguyên liệu trong nhà hàng.</p>
                        <span class="status-tag">Chưa triển khai</span>
                    </div>
                </div>
                <a class="menu-card" href="${pageContext.request.contextPath}/stat-supplier">
                    <span class="menu-icon" aria-hidden="true">▥</span>
                    <div>
                        <h3>Thống kê nhà cung cấp</h3>
                        <p>Xếp hạng theo lượng hàng nhập và tra cứu từng phiếu nhập.</p>
                        <span class="status-tag" style="color:var(--blue)">Xem báo cáo →</span>
                    </div>
                </a>
            </div>
        </main>
        <footer class="site-footer">
            <strong>RestMan · Quản lý nhà hàng</strong>
            <span>Chăm chút từng trải nghiệm.</span>
        </footer>
    </body>
</html>
