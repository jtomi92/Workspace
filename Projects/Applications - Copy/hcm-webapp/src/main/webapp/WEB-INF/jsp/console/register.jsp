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
				<h4>${localization['register-my-product']}</h4>
				<div class="input-group col-lg-6">
					<input id="registrationSerialNumber" type="text"
						class="form-control" placeholder="${localization['serial-number']}" /> <span
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
		<div class="container panel panel-default" style="padding-bottom:10px;">
			<table class="table table-striped">
				<thead>
					<tr>
						<th><h4>${localization['serial-number']}</h4></th>
						<th><h4>${localization['product-name']}</h4></th>
						<th><h4>${localization['registration-date']}</h4></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${userProducts}" var="userProduct"
						varStatus="count2">
						<tr >
							<td><h4>${userProduct.serialNumber}</h4></td>
							<td>
								<div class="input-group">
									<input id="registred-product-field-${count2.index}" type="text"
										class="form-control" placeholder="${userProduct.name}">
									<span class="input-group-btn"> <c:choose>
											<c:when test="${privilige eq 'ADMIN'}">
												<button class="btn btn-primary" type="button"
													onClick="saveProductName('${userProduct.serialNumber}','${count2.index}');">SAVE</button>
											</c:when>
											<c:otherwise>
												<button disabled class="btn btn-primary" type="button">${localization['save']}</button>
											</c:otherwise>
										</c:choose>

									</span>
								</div>
							</td>
							<td><h4>${userProduct.creationDate}</h4></td>
						</tr>
						
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</section>