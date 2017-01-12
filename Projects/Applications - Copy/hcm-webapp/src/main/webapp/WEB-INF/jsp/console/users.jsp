<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true" %>

<section id="tab2" class="tab-content hide">
	<div id="product-users">
		<c:forEach items="${userProducts}" var="ups" varStatus="count">
			<div class="panel panel-default"
				id="product-relay-control-${count.index}"
				style="border-style: hidden;">
				<div class="panel panel-default">
					<!-- Default panel contents -->
					<div class="dropdown panel-heading">
						<div class="container-fluid">
								<h4>${localization['add-new-user']}</h4>
								<div class="input-group col-lg-6">
									<input id="add-product-user-${count.index}" type="text"
										class="form-control" placeholder="${localization['email-address']}"> <span
										class="input-group-btn "> <c:choose>
											<c:when test="${privilige eq 'ADMIN'}">
												<button class="btn btn-primary" type="button"
													onClick="addProductUser('${ups.serialNumber}','${count.index}');">${localization['add-user']}</button>
											</c:when>
											<c:otherwise>
												<button disabled class="btn btn-primary" type="button">${localization['add-user']}</button>
											</c:otherwise>
										</c:choose>
									</span>
								</div>
								<div class="container-fluid alert-danger"
									id="user-error-message-${count.index}"></div>
								<div class="container-fluid alert-success"
									id="user-success-message-${count.index}"></div>
								<!-- /input-group -->
							
							<!-- /.col-lg-6 -->
						</div>

					</div>
				</div>



				<div class="container-fluid panel panel-default" style="padding-right:50px;padding-left:50px;">

					<!-- /input-group -->
					<div class="page-header" style="text-align: center;">
						<h3>${localization['current-users']}</h3>
					</div>

					<div class="panel panel-default" style="padding-right:10px;padding-left:10px;">
						<table class="table table-striped">
							<thead>
								<tr>
									<td><h4>${localization['privilige']}</h4></td>
									<td><h4>${localization['email-address']}</h4></td>
									<td><h4>${localization['relay-access']}</h4></td>
									<td><h4>${localization['call-access']}</h4></td>
									<td><h4>${localization['action']}</h4></td>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${ups.productUsers}" var="productUsers"
									varStatus="count2">

									<tr>
										<td><c:choose>
												<c:when
													test="${productUsers.userName eq pageContext.request.userPrincipal.name || privilige eq 'USER'}">
													<label>${productUsers.privilige}</label>
												</c:when>
												<c:otherwise>
													<label><select
														id="product-priv-picker-${count.index}-${count2.index}"
														class="form-control" style="width: 100px;">
															<c:if test="${productUsers.privilige eq 'ADMIN'}">
																<option value="priv-${count2.index}-${count3.index}"
																	selected>ADMIN</option>
																<option value="priv-${count2.index}-${count3.index}">${localization['user']}</option>
															</c:if>
															<c:if test="${productUsers.privilige eq 'USER'}">
																<option value="priv-${count2.index}-${count3.index}">${localization['admin']}</option>
																<option selected
																	value="priv-${count2.index}-${count3.index}">${localization['user']}</option>
															</c:if>
													</select></label>
												</c:otherwise>
											</c:choose></td>


										<td><label>${productUsers.userName}</label></td>
										<td><select
											id="product-relay-priv-picker-${count.index}-${count2.index}"
											multiple="multiple">
												<c:forEach
													items="${ups.productSettings.iterator().next().relaySettings}"
													var="relaysetting" varStatus="count3">

													<c:forEach items="${relaysetting.productControlSettings}"
														var="productControlSetting" varStatus="count4">

														<c:if
															test="${(productControlSetting.userId eq productUsers.userId) && productControlSetting.access}">
															<option value="r-${count2.index}-${count3.index}"
																selected>${relaysetting.relayName}</option>
														</c:if>
														<c:if
															test="${(productControlSetting.userId eq productUsers.userId) && (not productControlSetting.access)}">
															<option value="r-${count2.index}-${count3.index}">${relaysetting.relayName}</option>
														</c:if>

													</c:forEach>
												</c:forEach>
										</select></td>
										<td><select
											id="product-relay-call-picker-${count.index}-${count2.index}"
											multiple="multiple">
												<c:forEach
													items="${ups.productSettings.iterator().next().relaySettings}"
													var="relaysetting" varStatus="count3">
													<c:forEach items="${relaysetting.productControlSettings}"
														var="productControlSetting" varStatus="count4">

														<c:if
															test="${(productControlSetting.userId eq productUsers.userId) && productControlSetting.callAccess}">
															<option value="c-${count2.index}-${count3.index}"
																selected>${relaysetting.relayName}</option>
														</c:if>
														<c:if
															test="${(productControlSetting.userId eq productUsers.userId) && (not productControlSetting.callAccess)}">
															<option value="c-${count2.index}-${count3.index}">${relaysetting.relayName}</option>
														</c:if>

													</c:forEach>
												</c:forEach>
										</select></td>
										<td>
											<div class="btn-group">

												<c:choose>
													<c:when test="${privilige eq 'ADMIN'}">
														<button type="button" class="btn btn-primary"
															onClick="updateProductUser('${productUsers.userName}','${ups.serialNumber}','${count.index}-${count2.index}');">${localization['save']}</button>
														<c:if
															test="${not (productUsers.userName eq pageContext.request.userPrincipal.name)}">
															<button type="button" class="btn btn-danger"
																onClick="removeProductUser('${productUsers.userName}','${ups.serialNumber}','${count.index}-${count2.index}');">${localization['remove']}</button>
														</c:if>
													</c:when>
													<c:otherwise>
														<button type="button" disabled class="btn btn-primary">${localization['save']}</button>
														<button type="button" disabled class="btn btn-danger">${localization['remove']}</button>
													</c:otherwise>
												</c:choose>

											</div>
										</td>
									</tr>

								</c:forEach>
								
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</section>