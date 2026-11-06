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
        <title>Tìm kiếm món ăn · RestMan</title>
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
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/customer/HomeCustomerView9.jsp">← Trang chủ</a>
                <span>/</span>
                Tìm kiếm món ăn
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        KHÁM PHÁ THỰC ĐƠN
                    </div>
                    <h1>Hôm nay, bạn muốn ăn gì?</h1>
                    <p>Tìm món ăn hoặc combo yêu thích trong thực đơn của nhà hàng.</p>
                </div>
                <span class="banner-number" aria-hidden="true">01</span>
            </section>
            <section class="panel">
                <form class="form-row" method="get" action="${pageContext.request.contextPath}/customer/search-dish">
                    <div class="field grow">
                        <label for="keyword">Tên món ăn / Combo</label>
                        <input
                            id="keyword"
                            name="keyword"
                            type="search"
                            value="<c:out value='${param.keyword}'/>"
                            placeholder="Nhập tên món ăn, ví dụ: gà, cơm…">
                    </div>
                    <button type="submit">
                        Tìm kiếm
                        <span aria-hidden="true">⌕</span>
                    </button>
                    <a class="btn secondary" href="${pageContext.request.contextPath}/customer/search-dish">Đặt lại</a>
                </form>
            </section>
            <c:if test="${not empty message}">
                <p class="notice" role="alert">
                    <c:out value="${message}" />
                </p>
            </c:if>
            <c:choose>
                <c:when test="${searched}">
                    <div class="section-head">
                        <div>
                            <h2>Kết quả tìm kiếm</h2>
                            <p>
                                Từ khóa: “
                                <c:out value="${param.keyword}" />
                                ”
                            </p>
                        </div>
                        <span class="badge">${fn:length(listDish) + fn:length(listCombo)} kết quả</span>
                    </div>
                    <c:if test="${empty listDish and empty listCombo}">
                        <div class="empty">
                            <div class="empty-symbol" aria-hidden="true">
                                ⌕
                            </div>
                            <h3>Chưa tìm thấy món phù hợp</h3>
                            <p>Bạn thử một tên món khác hoặc từ khóa ngắn hơn nhé.</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty listDish}">
                        <div class="section-head">
                            <h3>Món ăn</h3>
                            <span class="caption">${fn:length(listDish)} lựa chọn</span>
                        </div>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Món ăn</th>
                                        <th>Đơn vị</th>
                                        <th class="numeric">Giá bán</th>
                                        <th>
                                            <span class="caption">Chi tiết</span>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDish}" var="dish">
                                        <tr>
                                            <td>
                                                <div class="row-item">
                                                    <span class="thumb">
                                                        <c:choose>
                                                            <c:when test="${not empty dish.imageUrl}">
                                                                <img
                                                                    loading="lazy"
                                                                    src="<c:out value='${dish.imageUrl}'/>"
                                                                    alt="<c:out value='${dish.name}'/>"
                                                                    onerror="this.style.display='none'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa có ảnh
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div>
                                                        <strong>
                                                            <c:out value="${dish.name}" />
                                                        </strong>
                                                        <p>
                                                            <c:out value="${dish.description}" />
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:out value="${dish.unit}" />
                                            </td>
                                            <td class="numeric">
                                                <strong>
                                                    <fmt:formatNumber
                                                        value="${dish.price}"
                                                        type="number"
                                                        maxFractionDigits="0"
                                                        />
                                                    đ
                                                </strong>
                                            </td>
                                            <td class="numeric">
                                                <c:url value="/customer/search-dish" var="detailUrl">
                                                    <c:param name="action" value="detail" />
                                                    <c:param name="type" value="dish" />
                                                    <c:param name="id" value="${dish.id}" />
                                                    <c:param name="keyword" value="${param.keyword}" />
                                                </c:url>
                                                <a class="detail" href="<c:out value='${detailUrl}'/>">Xem chi tiết →</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <c:if test="${not empty listCombo}">
                        <div class="section-head">
                            <h3>Combo</h3>
                            <span class="caption">${fn:length(listCombo)} lựa chọn</span>
                        </div>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Combo</th>
                                        <th>Loại</th>
                                        <th class="numeric">Giá bán</th>
                                        <th>
                                            <span class="caption">Chi tiết</span>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listCombo}" var="combo">
                                        <tr>
                                            <td>
                                                <div class="row-item">
                                                    <span class="thumb">
                                                        <c:choose>
                                                            <c:when test="${not empty combo.imageUrl}">
                                                                <img
                                                                    loading="lazy"
                                                                    src="<c:out value='${combo.imageUrl}'/>"
                                                                    alt="<c:out value='${combo.name}'/>"
                                                                    onerror="this.style.display='none'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa có ảnh
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div>
                                                        <strong>
                                                            <c:out value="${combo.name}" />
                                                        </strong>
                                                        <p>
                                                            <c:out value="${combo.description}" />
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge">Combo</span>
                                            </td>
                                            <td class="numeric">
                                                <strong>
                                                    <fmt:formatNumber
                                                        value="${combo.price}"
                                                        type="number"
                                                        maxFractionDigits="0"
                                                        />
                                                    đ
                                                </strong>
                                            </td>
                                            <td class="numeric">
                                                <c:url value="/customer/search-dish" var="detailUrl">
                                                    <c:param name="action" value="detail" />
                                                    <c:param name="type" value="combo" />
                                                    <c:param name="id" value="${combo.id}" />
                                                    <c:param name="keyword" value="${param.keyword}" />
                                                </c:url>
                                                <a class="detail" href="<c:out value='${detailUrl}'/>">Xem chi tiết →</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="empty">
                        <div class="empty-symbol" aria-hidden="true">
                            ⌕
                        </div>
                        <h3>Món ngon đang chờ bạn</h3>
                        <p>Nhập tên món ăn hoặc combo ở trên để bắt đầu tìm kiếm.</p>
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
