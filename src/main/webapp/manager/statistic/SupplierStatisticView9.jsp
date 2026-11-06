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
        <title>Thống kê nhà cung cấp · RestMan</title>
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
                <a href="${pageContext.request.contextPath}/manager/statistic/StatisticMainView9.jsp">← Các báo cáo</a>
                <span>/</span>
                Thống kê nhà cung cấp
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        BÁO CÁO NHẬP HÀNG
                    </div>
                    <h1>Thống kê nhà cung cấp</h1>
                    <p>Theo dõi lượng hàng nhập theo nhà cung cấp trong khoảng thời gian bạn chọn.</p>
                </div>
                <span class="banner-number" aria-hidden="true">02</span>
            </section>
            <section class="panel">
                <h2 class="filter-title">Thời gian thống kê</h2>
                <form class="form-row" method="get" action="${pageContext.request.contextPath}/stat-supplier">
                    <input type="hidden" name="action" value="stat">
                    <div class="field grow">
                        <label for="start">Từ ngày</label>
                        <input id="start" name="start" type="date" value="<c:out value='${param.start}'/>" required>
                    </div>
                    <div class="field grow">
                        <label for="end">Đến ngày</label>
                        <input id="end" name="end" type="date" value="<c:out value='${param.end}'/>" required>
                    </div>
                    <button type="submit">Xem thống kê →</button>
                    <a class="btn secondary" href="${pageContext.request.contextPath}/stat-supplier">Đặt lại</a>
                </form>
            </section>
            <c:if test="${not empty message}">
                <p class="notice" role="alert">
                    <c:out value="${message}"/>
                </p>
            </c:if>
            <c:choose>
                <c:when test="${searched}">
                    <div class="section-head">
                        <div>
                            <h2>Xếp hạng nhà cung cấp</h2>
                            <p>Sắp xếp theo lượng hàng nhập từ cao đến thấp.</p>
                        </div>
                        <span class="badge">${fn:length(listSupplierStat)} nhà cung cấp</span>
                    </div>
                    <c:choose>
                        <c:when test="${empty listSupplierStat}">
                            <div class="empty">
                                <div class="empty-symbol" aria-hidden="true">
                                    ⌕
                                </div>
                                <h3>Chưa có dữ liệu nhập hàng</h3>
                                <p>Không có phiếu nhập trong khoảng thời gian này. Bạn hãy thử khoảng thời gian khác.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-wrap">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Điện thoại</th>
                                            <th class="numeric">Lượng nhập</th>
                                            <th class="numeric">Tổng tiền nhập</th>
                                            <th>Chi tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listSupplierStat}" var="stat" varStatus="row">
                                            <c:url value="/stat-supplier" var="listUrl">
                                                <c:param name="action" value="listImport"/>
                                                <c:param name="supplierId" value="${stat.id}"/>
                                                <c:param name="start" value="${param.start}"/>
                                                <c:param name="end" value="${param.end}"/>
                                            </c:url>
                                            <tr>
                                                <td>
                                                    <span class="badge">${row.count}</span>
                                                </td>
                                                <td>
                                                    <strong>
                                                        <c:out value="${stat.name}"/>
                                                    </strong>
                                                </td>
                                                <td>
                                                    <c:out value="${stat.phone}"/>
                                                </td>
                                                <td class="numeric">
                                                    <fmt:formatNumber value="${stat.totalImport}"/>
                                                </td>
                                                <td class="numeric">
                                                    <fmt:formatNumber
                                                        value="${stat.totalPayment}"
                                                        maxFractionDigits="0"/>
                                                    đ
                                                </td>
                                                <td>
                                                    <a class="detail" href="<c:out value='${listUrl}'/>">Xem phiếu nhập →</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <p class="caption">Lượng nhập là tổng số lượng trên các dòng phiếu nhập, theo đơn vị của từng nguyên liệu.</p>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <div class="empty">
                        <div class="empty-symbol" aria-hidden="true">
                            ⌕
                        </div>
                        <h3>Chọn thời gian để xem báo cáo</h3>
                        <p>Danh sách nhà cung cấp sẽ xuất hiện sau khi bạn xác nhận khoảng thời gian.</p>
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
