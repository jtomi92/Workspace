<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>

<section id="tab4" class="tab-content hide">
	<div class="panel panel-default">
		<!-- Default panel contents -->

		<div class="dropdown panel-heading">
			<div class="container-fluid">
				<label>${localization['register-my-product']}</label>
				<div class="input-group col-lg-6">
					<input id="registrationSerialNumber" type="text"
						class="form-control"
						placeholder="${localization['serial-number']}" /> <span
						class="input-group-btn">
						<button class="btn btn-primary" type="button"
							onClick="registerProduct()">${localization['register']}</button>
					</span>
				</div>
				<div class="container-fluid alert-danger"
					id="register-error-message"></div>
				<div class="container-fluid alert-success"
					id="register-success-message"></div>
			</div>
		</div>
	</div>
	<div class="panel panel-default">

		<br>
		<div class="page-header" style="text-align: center;">
			<h3>${localization['my-registered-products']}</h3>
		</div>
		<div class="container panel panel-default registered-products-large"
			style="padding-bottom: 10px;">
			<table class="table table-striped">
				<thead>
					<tr>
						<th><label>${localization['serial-number']}</label></th>
						<th><label>${localization['product-name']}</label></th>
						<th><label>${localization['registration-date']}</label></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${userProducts}" var="userProduct"
						varStatus="count2">
						<tr>
							<td><label>${userProduct.serialNumber}</label></td>
							<td>
								<div class="input-group">
									<input id="registred-product-field-1-${count2.index}" type="text"
										class="form-control" value="${userProduct.name}"> <span
										class="input-group-btn"> <c:choose>
											<c:when test="${privilige eq 'ADMIN'}">
												<button class="btn btn-primary" type="button"
													onClick="saveProductName('${userProduct.serialNumber}',1,'${count2.index}');">SAVE</button>
											</c:when>
											<c:otherwise>
												<button disabled class="btn btn-primary" type="button">${localization['save']}</button>
											</c:otherwise>
										</c:choose>

									</span>
								</div>
							</td>
							<td><label>${userProduct.creationDate}</label></td>
						</tr>

					</c:forEach>
				</tbody>
			</table>
		</div>


		<div class="container panel panel-default registered-products-small"
			style="padding-bottom: 10px;">
			<table class="table table-striped">
				<tbody>
					<c:forEach items="${userProducts}" var="userProduct"
						varStatus="count2">
						<tr>
							<td><label>${localization['serial-number']}</label></td>
							<td><label>${userProduct.serialNumber}</label></td>
						</tr>
						<tr>
							<td><label>${localization['product-name']}</label></td>
							<td>
								<div class="input-group">
									<input id="registred-product-field-2-${count2.index}" type="text"
										class="form-control" value="${userProduct.name}"> <span
										class="input-group-btn"> <c:choose>
											<c:when test="${privilige eq 'ADMIN'}">
												<button class="btn btn-primary" type="button"
													onClick="saveProductName('${userProduct.serialNumber}',2,'${count2.index}');">SAVE</button>
											</c:when>
											<c:otherwise>
												<button disabled class="btn btn-primary" type="button">${localization['save']}</button>
											</c:otherwise>
										</c:choose>

									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td><label>${localization['registration-date']}</label></td>
							<td><label>${userProduct.creationDate}</label></td>
						</tr>

						<tr>
							<td colspan="2"><hr
									style="height: 1px; border: none; color: #333; background-color: #333;"></td>
						</tr>

					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</section>