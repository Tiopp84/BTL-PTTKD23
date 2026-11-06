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
        <title>Danh sách phiếu nhập · RestMan</title>
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
            <c:url value="/stat-supplier" var="backUrl">
                <c:param name="action" value="stat"/>
                <c:param name="start" value="${param.start}"/>
                <c:param name="end" value="${param.end}"/>
            </c:url>
            <div class="breadcrumb">
                <a href="<c:out value='${backUrl}'/>">← Thống kê nhà cung cấp</a>
                <span>/</span>
                Danh sách phiếu nhập
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        CHI TIẾT NHÀ CUNG CẤP
                    </div>
                    <h1>Danh sách phiếu nhập</h1>
                    <p>Tra cứu các lần nhập hàng của nhà cung cấp trong thời gian thống kê.</p>
                </div>
                <span class="banner-number" aria-hidden="true">03</span>
            </section>
            <c:if test="${not empty message}">
                <p class="notice" role="alert">
                    <c:out value="${message}"/>
                </p>
            </c:if>
            <section class="panel">
                <div class="info-grid">
                    <dl>
                        <dt>Nhà cung cấp</dt>
                        <dd>
                            <c:choose>
                                <c:when test="${not empty listInvoice}">
                                    <c:out value="${listInvoice[0].supplier.name}"/>
                                </c:when>
                                <c:otherwise>
                                    —
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                    <dl>
                        <dt>Liên hệ</dt>
                        <dd>
                            <c:out value="${listInvoice[0].supplier.phone}" default="—"/>
                        </dd>
                    </dl>
                    <dl>
                        <dt>Thời gian thống kê</dt>
                        <dd>
                            <c:out value="${param.start}"/>
                            →
                            <c:out value="${param.end}"/>
                        </dd>
                    </dl>
                </div>
            </section>
            <div class="section-head">
                <h2>Các lần nhập hàng</h2>
                <span class="badge">${fn:length(listInvoice)} phiếu nhập</span>
            </div>
            <c:set var="totalPayment" value="${0}"/>
            <c:choose>
                <c:when test="${empty listInvoice}">
                    <div class="empty">
                        <div class="empty-symbol" aria-hidden="true">
                            ⌕
                        </div>
                        <h3>Chưa có phiếu nhập</h3>
                        <p>Không có phiếu nhập phù hợp với nhà cung cấp và thời gian đã chọn.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Mã phiếu</th>
                                    <th>Ngày nhập</th>
                                    <th>Nhân viên kho</th>
                                    <th class="numeric">Tổng tiền</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listInvoice}" var="invoice" varStatus="row">
                                    <c:set var="totalPayment" value="${totalPayment + invoice.total}"/>
                                    <c:url value="/stat-supplier" var="detailUrl">
                                        <c:param name="action" value="detail"/>
                                        <c:param name="invoiceId" value="${invoice.id}"/>
                                        <c:param name="start" value="${param.start}"/>
                                        <c:param name="end" value="${param.end}"/>
                                        <c:param name="supplierId" value="${param.supplierId}"/>
                                    </c:url>
                                    <tr>
                                        <td>${row.count}</td>
                                        <td>
                                            <strong>
                                                PN
                                                <c:out value="${invoice.id}"/>
                                            </strong>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:out value="${invoice.staff.userName}"/>
                                        </td>
                                        <td class="numeric">
                                            <fmt:formatNumber value="${invoice.total}" maxFractionDigits="0"/>
                                            đ
                                        </td>
                                        <td>
                                            <a class="detail" href="<c:out value='${detailUrl}'/>">Xem chi tiết →</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="totals">
                        <div>
                            <span>Số phiếu nhập</span>
                            <strong>${fn:length(listInvoice)}</strong>
                        </div>
                        <div>
                            <span>Tổng tiền nhập</span>
                            <strong>
                                <fmt:formatNumber value="${totalPayment}" maxFractionDigits="0"/>
                                đ
                            </strong>
                        </div>
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
