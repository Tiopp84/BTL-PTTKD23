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
        <title>Trang chủ nhà hàng · RestMan</title>
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
                <nav class="nav" aria-label="Điều hướng chính">
                    <a class="active" href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/customer/search-dish">Thực đơn</a>
                    <span class="nav-label">Nhà hàng</span>
                </nav>
            </div>
        </header>
        <main class="page">
            <div class="breadcrumb">
                Nhà hàng
                <span>/</span>
                Trang chủ
            </div>
            <section class="hero">
                <div>
                    <div class="eyebrow">
                        CHÀO MỪNG ĐẾN VỚI RESTMAN
                    </div>
                    <h1>
                        Mỗi bữa ăn,
                        <br>
                        một niềm vui.
                    </h1>
                    <p>Khám phá món ngon và những combo kết hợp trọn vị. Bắt đầu từ món ăn bạn yêu thích.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/customer/search-dish">
                        Tìm món ăn
                        <span aria-hidden="true">→</span>
                    </a>
                </div>
                <div class="hero-visual" aria-hidden="true">
                    <div class="plate">
                        <svg viewBox="0 0 200 200" fill="none">
                            <circle cx="100" cy="100" r="83" fill="#eaf3ff"/>
                            <circle cx="100" cy="100" r="62" stroke="#b5d0ef"/>
                            <path d="M61 112c5-32 59-45 78-9-7 26-59 37-78 9Z" fill="#7fa9d4"/>
                            <path
                                d="M72 106c21-16 38-16 54-4M78 119c16-11 33-13 42-9"
                                stroke="#fff"
                                stroke-width="4"
                                stroke-linecap="round"/>
                            <path
                                d="M93 74c-11-25 8-34 17-14-2 14-9 19-17 14ZM117 73c9-23 30-18 24-2-8 10-17 10-24 2Z"
                                fill="#a5c8de"/>
                            <circle cx="65" cy="83" r="8" fill="#c0d9ed"/>
                            <circle cx="135" cy="127" r="7" fill="#c0d9ed"/>
                        </svg>
                    </div>
                    <div class="hero-note">
                        <strong>Món ngon, lựa chọn dễ dàng</strong>
                        Tìm món yêu thích của bạn
                    </div>
                </div>
            </section>
            <div class="intro-row">
                <div class="intro-item">
                    <span class="step">01</span>
                    <div>
                        <h3>Tìm món yêu thích</h3>
                        <p>Tra cứu món ăn và combo theo tên.</p>
                    </div>
                </div>
                <div class="intro-item">
                    <span class="step">02</span>
                    <div>
                        <h3>Khám phá thực đơn</h3>
                        <p>Xem thông tin và giá món rõ ràng.</p>
                    </div>
                </div>
                <div class="intro-item">
                    <span class="step">03</span>
                    <div>
                        <h3>Chọn combo trọn vị</h3>
                        <p>Xem các món thành phần trong combo.</p>
                    </div>
                </div>
            </div>
            <p class="caption">
                Khu vực nhân viên:
                <a href="${pageContext.request.contextPath}/login">Đăng nhập quản lý →</a>
            </p>
        </main>
        <footer class="site-footer">
            <strong>RestMan · Quản lý nhà hàng</strong>
            <span>Chăm chút từng trải nghiệm.</span>
        </footer>
    </body>
</html>
