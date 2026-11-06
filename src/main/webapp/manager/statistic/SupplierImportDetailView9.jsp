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
        <title>Chi tiết phiếu nhập · RestMan</title>
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
            <c:choose>
                <c:when test="${not empty param.start and not empty param.end and not empty param.supplierId}">
                    <c:url value="/stat-supplier" var="backUrl">
                        <c:param name="action" value="listImport"/>
                        <c:param name="start" value="${param.start}"/>
                        <c:param name="end" value="${param.end}"/>
                        <c:param name="supplierId" value="${param.supplierId}"/>
                    </c:url>
                </c:when>
                <c:otherwise>
                    <c:url value="/stat-supplier" var="backUrl"/>
                </c:otherwise>
            </c:choose>
            <div class="breadcrumb">
                <a href="<c:out value='${backUrl}'/>">← Danh sách phiếu nhập</a>
                <span>/</span>
                Chi tiết phiếu nhập
            </div>
            <section class="banner">
                <div>
                    <div class="eyebrow">
                        PHIẾU NHẬP KHO
                    </div>
                    <h1>Chi tiết phiếu nhập</h1>
                    <p>Thông tin nguyên liệu, số lượng và chi phí của lần nhập hàng.</p>
                </div>
                <span class="banner-number" aria-hidden="true">04</span>
            </section>
            <c:choose>
                <c:when test="${not empty invoice}">
                    <section class="panel">
                        <div class="section-head" style="margin-top:0">
                            <h2>
                                Phiếu nhập PN
                                <c:out value="${invoice.id}"/>
                            </h2>
                            <span class="badge">Phiếu nhập kho</span>
                        </div>
                        <div class="info-grid">
                            <dl>
                                <dt>Nhà cung cấp</dt>
                                <dd>
                                    <c:out value="${invoice.supplier.name}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Ngày nhập</dt>
                                <dd>
                                    <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Nhân viên thực hiện</dt>
                                <dd>
                                    <c:choose>
                                        <c:when
                                            test="${not empty invoice.staff.name.firstName or not empty invoice.staff.name.lastName}">
                                            <c:out value="${invoice.staff.name.firstName}"/>
                                            <c:out value="${invoice.staff.name.lastName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${invoice.staff.userName}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Địa chỉ nhà cung cấp</dt>
                                <dd>
                                    <c:out value="${invoice.supplier.address.houseNumber}"/>
                                    <c:out value="${invoice.supplier.address.street}"/>
                                    <c:out value="${invoice.supplier.address.ward}"/>
                                    <c:out value="${invoice.supplier.address.city}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Liên hệ</dt>
                                <dd>
                                    <c:out value="${invoice.supplier.phone}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt>Ghi chú</dt>
                                <dd>
                                    <c:out value="${invoice.note}" default="—"/>
                                </dd>
                            </dl>
                        </div>
                    </section>
                    <div class="section-head">
                        <h2>Nguyên liệu nhập kho</h2>
                        <span class="badge">${fn:length(invoice.listImport)} dòng nguyên liệu</span>
                    </div>
                    <c:set var="totalQty" value="${0}"/>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Mã nguyên liệu</th>
                                    <th>Tên nguyên liệu</th>
                                    <th>Đơn vị</th>
                                    <th class="numeric">Số lượng</th>
                                    <th class="numeric">Đơn giá</th>
                                    <th class="numeric">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${invoice.listImport}" var="detail" varStatus="row">
                                    <c:set var="totalQty" value="${totalQty + detail.qty}"/>
                                    <tr>
                                        <td>${row.count}</td>
                                        <td>
                                            NL
                                            <c:out value="${detail.material.id}"/>
                                        </td>
                                        <td>
                                            <strong>
                                                <c:out value="${detail.material.name}"/>
                                            </strong>
                                        </td>
                                        <td>
                                            <c:out value="${detail.material.unit}"/>
                                        </td>
                                        <td class="numeric">
                                            <fmt:formatNumber value="${detail.qty}"/>
                                        </td>
                                        <td class="numeric">
                                            <fmt:formatNumber value="${detail.price}" maxFractionDigits="0"/>
                                            đ
                                        </td>
                                        <td class="numeric">
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${detail.qty * detail.price}"
                                                    maxFractionDigits="0"/>
                                                đ
                                            </strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="totals">
                        <div>
                            <span>Tổng số lượng theo dòng nhập</span>
                            <strong>
                                <fmt:formatNumber value="${totalQty}"/>
                            </strong>
                        </div>
                        <div>
                            <span>Tổng tiền phiếu nhập</span>
                            <strong>
                                <fmt:formatNumber value="${invoice.total}" maxFractionDigits="0"/>
                                đ
                            </strong>
                        </div>
                    </div>
                    <p class="caption" style="margin-top:10px">Số lượng được ghi theo đơn vị riêng của từng nguyên liệu.</p>
                </c:when>
                <c:otherwise>
                    <div class="empty">
                        <div class="empty-symbol" aria-hidden="true">
                            ⌕
                        </div>
                        <h3>Chưa có thông tin phiếu nhập</h3>
                        <p>Chọn một phiếu trong danh sách để xem chi tiết.</p>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="page-actions">
                <a class="btn secondary" href="<c:out value='${backUrl}'/>">← Quay lại</a>
                <a class="btn" href="${pageContext.request.contextPath}/manager/ManagerHomeView9.jsp">Xong · Về trang chủ →</a>
            </div>
        </main>
        <footer class="site-footer">
            <strong>RestMan · Quản lý nhà hàng</strong>
            <span>Chăm chút từng trải nghiệm.</span>
        </footer>
    </body>
</html>
