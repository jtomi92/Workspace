<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- HEADER START -->

<link
	href="${pageContext.request.contextPath}/resources/custom/css/languages.min.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/custom/js/language-selector.js"
	type="text/javascript"></script>

<div class="collapse navbar-collapse navbar-inverse"
	id="bs-example-navbar-collapse-1">

	<div style="height: 52px" class="container-fluid">
		<div class="container-fluid">

			<!-- 			<span class="navbar-form navbar-left"><a -->
			<%-- 				style="color: white;" href="${pageContext.request.contextPath}/console"><span --%>
			<!-- 					class="glyphicon glyphicon-home"></span> HOME</a> </span> <span -->
			<!-- 				class="navbar-form navbar-left"> <a style="color: white;" -->
			<%-- 				href="${pageContext.request.contextPath}/console"><span --%>
			<!-- 					class="glyphicon glyphicon-th"></span> PRODUCTS</a> -->
			<!-- 			</span>  -->

			<div style="float: left; line-height: 35px;">
				<span class="navbar-form navbar-left"> <a
					style="color: white;"
					href="${pageContext.request.contextPath}/contact"><span
						class="glyphicon glyphicon-earphone"></span>${localization['contact-us']}</a>
				</span>
			</div>


			<div class="btn-group dropdown"
				style="float: right; padding-top: 8px; padding-right: 40px;">
				<button type="button" class="btn btn-default dropdown-toggle"
					data-toggle="dropdown">
					<span class="lang-sm lang-lbl" lang="${cookie.locale.value}"></span>
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu language-selector"
					style="padding-left: 15px;" role="menu">

					<c:choose>
						<c:when test="${cookie.locale.value eq 'hu'}">
							<li><span class="lang-sm lang-lbl"
								lang="en"></span></li>
						</c:when>
						<c:when test="${cookie.locale.value eq 'en'}">
							<li><span class="lang-sm lang-lbl"
								lang="hu"></span></li>
						</c:when>
					</c:choose>
				</ul>

			</div>

			<div style="float: right; line-height: 35px;">
				<span class="flagstrap navbar-form navbar-left" id="select_country"
					data-selected-country=""></span>
			</div>

			<div style="float: right; line-height: 35px;">
				<span class="navbar-form navbar-right"> <a
					style="color: white;"
					href="${pageContext.request.contextPath}/console"><span
						class="glyphicon glyphicon-phone"></span> ${localization['my-console']}</a>
				</span>
			</div>

			<div style="float: right; line-height: 35px;">
				<span class="navbar-form navbar-right"> <font color="white">|</font></span>
			</div>

			<div style="float: right; line-height: 35px;">
				<span class="navbar-form navbar-right"> <a
					style="color: white;"
					href="${pageContext.request.contextPath}/myaccount"><span
						class="glyphicon glyphicon-user"></span> ${localization['my-account']}</a>
				</span>
			</div>



			<c:if test="${not empty param.firstname}">

				<div style="float: right; line-height: 35px;">
					<span class="navbar-form navbar-right"> <font color="white">|</font></span>
				</div>

				<div style="float: right; line-height: 35px;">
					<span class="navbar-form navbar-right"> <a
						style="color: white;"
						href="${pageContext.request.contextPath}/logout"> <span
							class="glyphicon glyphicon-log-out"></span> ${localization['sign-out']}</a>

					</span>
				</div>

				<!-- 					<span class="navbar-form navbar-right"> <font color="white">|</font></span> -->

				<!-- 					<span class="navbar-form navbar-right"> <font color="white">Hello<b> -->
				<%-- 								${param.firstname}</b></font></span> --%>

			</c:if>


		</div>

	</div>
</div>


<!-- HEADER END -->