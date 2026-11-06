<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết món ăn / Combo · RestMan</title>
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
                    <a href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">Trang chủ</a>
                    <a class="active" href="${pageContext.request.contextPath}/customer/search-dish">Thực đơn</a>
                    <span class="nav-label">Nhà hàng</span>
                </nav>
            </div>
        </header>
        <main class="page">
            <c:url value="/customer/search-dish" var="backUrl">
                <c:param name="keyword" value="${param.keyword}" />
            </c:url>
            <div class="breadcrumb">
                <a href="<c:out value='${backUrl}'/>">← Kết quả tìm kiếm</a>
                <span>/</span>
                Chi tiết món ăn / Combo
            </div>
            <c:choose>
                <c:when test="${not empty dish}">
                    <section class="item-summary">
                        <div class="item-photo">
                            <c:choose>
                                <c:when test="${not empty dish.imageUrl}">
                                    <img
                                        src="<c:out value='${dish.imageUrl}'/>"
                                        alt="<c:out value='${dish.name}'/>"
                                        onerror="this.style.display='none'">
                                </c:when>
                                <c:otherwise>
                                    Chưa có hình ảnh
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="item-copy">
                            <span class="badge">Món ăn</span>
                            <h1>
                                <c:out value="${dish.name}" />
                            </h1>
                            <div class="meta-line">
                                Mã món ăn: #
                                <c:out value="${dish.id}" />
                            </div>
                            <p>
                                <c:out value="${dish.description}" />
                            </p>
                            <div class="item-price">
                                <fmt:formatNumber value="${dish.price}" type="number" maxFractionDigits="0" />
                                đ
                                <span class="item-unit">
                                    /
                                    <c:out value="${dish.unit}" />
                                </span>
                            </div>
                        </div>
                    </section>
                </c:when>
                <c:when test="${not empty combo}">
                    <section class="item-summary">
                        <div class="item-photo">
                            <c:choose>
                                <c:when test="${not empty combo.imageUrl}">
                                    <img
                                        src="<c:out value='${combo.imageUrl}'/>"
                                        alt="<c:out value='${combo.name}'/>"
                                        onerror="this.style.display='none'">
                                </c:when>
                                <c:otherwise>
                                    Chưa có hình ảnh
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="item-copy">
                            <span class="badge">Combo</span>
                            <h1>
                                <c:out value="${combo.name}" />
                            </h1>
                            <div class="meta-line">
                                Mã combo: #
                                <c:out value="${combo.id}" />
                            </div>
                            <p>
                                <c:out value="${combo.description}" />
                            </p>
                            <div class="item-price">
                                <fmt:formatNumber value="${combo.price}" type="number" maxFractionDigits="0" />
                                đ
                            </div>
                        </div>
                    </section>
                    <div class="section-head">
                        <div>
                            <h2>Danh sách món trong Combo</h2>
                            <p>Những món ăn kết hợp trong lựa chọn của bạn.</p>
                        </div>
                        <span class="badge">${fn:length(combo.listDish)} món</span>
                    </div>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Món ăn</th>
                                    <th>Đơn vị</th>
                                    <th class="numeric">Số lượng</th>
                                    <th class="numeric">Giá món lẻ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${combo.listDish}" var="detail">
                                    <tr>
                                        <td>
                                            <div class="row-item">
                                                <span class="thumb">
                                                    <c:choose>
                                                        <c:when test="${not empty detail.dish.imageUrl}">
                                                            <img
                                                                loading="lazy"
                                                                src="<c:out value='${detail.dish.imageUrl}'/>"
                                                                alt="<c:out value='${detail.dish.name}'/>"
                                                                onerror="this.style.display='none'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa có ảnh
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <strong>
                                                    <c:out value="${detail.dish.name}" />
                                                </strong>
                                            </div>
                                        </td>
                                        <td>
                                            <c:out value="${detail.dish.unit}" />
                                        </td>
                                        <td class="numeric">
                                            <c:out value="${detail.qty}" />
                                        </td>
                                        <td class="numeric">
                                            <fmt:formatNumber
                                                value="${detail.dish.price}"
                                                type="number"
                                                maxFractionDigits="0"
                                                />
                                            đ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <p class="caption">Giá combo được áp dụng cho cả bộ món; giá món lẻ chỉ để tham khảo.</p>
                </c:when>
                <c:otherwise>
                    <div class="empty">
                        <div class="empty-symbol" aria-hidden="true">
                            ⌕
                        </div>
                        <h3>Chưa có thông tin món ăn</h3>
                        <p>Quay lại tìm kiếm và chọn một món ăn hoặc combo để xem chi tiết.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
        <footer class="site-footer">
            <strong>RestMan · Quản lý nhà hàng</strong>
            <span>Chăm chút từng trải nghiệm.</span>
        </footer>
    </body>
</html>
