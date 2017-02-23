<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- HEADER START -->

<link
	href="${pageContext.request.contextPath}/resources/custom/css/languages.min.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/custom/css/wrapper-header.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/custom/js/language-selector.js"
	type="text/javascript"></script>

<div class="collapse navbar-collapse navbar-inverse"
	id="bs-example-navbar-collapse-1">
	
	<div style="display: none;" id="loading-spinner" class="loading">Loading&#8230;</div>
	<div class="container-fluid header-container-small">
	
		
		<div class="container-fluid navigation-tab-container-dropdown" style="float: left; line-height: 50px;">
			<div class="dropdown">
				<button class="btn btn-primary dropdown-toggle" type="button"
					id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="true">
					<span class="glyphicon glyphicon-list"> MENU</span>	
				</button>
				<ul class="navigation-dropdown dropdown-menu" aria-labelledby="dropdownMenu1">
					<li><a href="${pageContext.request.contextPath}/contact">${localization['contact-us']}</a></li>
					<li><a href="${pageContext.request.contextPath}/console">${localization['my-console']}</a></li>
					<li><a href="${pageContext.request.contextPath}/myaccount">${localization['my-account']}</a></li>
					<li><a href="${pageContext.request.contextPath}/logout">${localization['sign-out']}</a></li>
				</ul>
			</div>
		</div>
		
		<div  style="float: left; line-height: 50px; padding-left:30px;">
			<label style="color: #FFF;">jTech IoT</label>
		</div>
		
		<div class="btn-group dropdown"
			style="float: right; padding-top: 8px;">

			<c:choose>
				<c:when test="${empty cookie.locale.value}">
					<button type="button" class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span class="lang-sm lang-lbl" lang="en"></span> <span
							class="caret"></span>
					</button>
					<ul class="dropdown-menu language-selector"
						style="padding-left: 15px;" role="menu">
						<li><span class="lang-sm lang-lbl" lang="hu"></span></li>
					</ul>
				</c:when>
				<c:when test="${not empty cookie.locale.value}">
					<button type="button" class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span class="lang-sm lang-lbl" lang="${cookie.locale.value}"></span>
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu language-selector"
						style="padding-left: 15px;" role="menu">

						<c:choose>
							<c:when test="${cookie.locale.value eq 'hu'}">
								<li><span class="lang-sm lang-lbl" lang="en"></span></li>
							</c:when>
							<c:when test="${cookie.locale.value eq 'en'}">
								<li><span class="lang-sm lang-lbl" lang="hu"></span></li>
							</c:when>
						</c:choose>
					</ul>
				</c:when>

			</c:choose>

		</div>
	</div>

	<div class="container-fluid header-container-large">

		<div style="float: left; line-height: 35px;">
			<span class="navbar-form navbar-left"> <a
				style="color: white;"
				href="${pageContext.request.contextPath}/contact"><span
					class="glyphicon glyphicon-earphone"></span>${localization['contact-us']}</a>
			</span>
		</div>


		<div class="btn-group dropdown"
			style="float: right; padding-top: 8px; padding-right: 40px;">

			<c:choose>
				<c:when test="${empty cookie.locale.value}">
					<button type="button" class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span class="lang-sm lang-lbl" lang="en"></span> <span
							class="caret"></span>
					</button>
					<ul class="dropdown-menu language-selector"
						style="padding-left: 15px;" role="menu">
						<li><span class="lang-sm lang-lbl" lang="hu"></span></li>
					</ul>
				</c:when>
				<c:when test="${not empty cookie.locale.value}">
					<button type="button" class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span class="lang-sm lang-lbl" lang="${cookie.locale.value}"></span>
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu language-selector"
						style="padding-left: 15px;" role="menu">

						<c:choose>
							<c:when test="${cookie.locale.value eq 'hu'}">
								<li><span class="lang-sm lang-lbl" lang="en"></span></li>
							</c:when>
							<c:when test="${cookie.locale.value eq 'en'}">
								<li><span class="lang-sm lang-lbl" lang="hu"></span></li>
							</c:when>
						</c:choose>
					</ul>
				</c:when>

			</c:choose>

		</div>

		<div style="float: right; line-height: 35px;">
			<span class="flagstrap navbar-form navbar-left" id="select_country"
				data-selected-country=""></span>
		</div>

		<div style="float: right; line-height: 35px;">
			<span class="navbar-form navbar-right"> <a
				style="color: white;"
				href="${pageContext.request.contextPath}/console"><span
					class="glyphicon glyphicon-phone"></span>
					${localization['my-console']}</a>
			</span>
		</div>

		<div style="float: right; line-height: 35px;">
			<span class="navbar-form navbar-right"> <font color="white">|</font></span>
		</div>

		<div style="float: right; line-height: 35px;">
			<span class="navbar-form navbar-right"> <a
				style="color: white;"
				href="${pageContext.request.contextPath}/myaccount"><span
					class="glyphicon glyphicon-user"></span>
					${localization['my-account']}</a>
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
						class="glyphicon glyphicon-log-out"></span>
						${localization['sign-out']}
				</a>

				</span>
			</div>

			<!-- 					<span class="navbar-form navbar-right"> <font color="white">|</font></span> -->

			<!-- 					<span class="navbar-form navbar-right"> <font color="white">Hello<b> -->
			<%-- 								${param.firstname}</b></font></span> --%>

		</c:if>


	</div>

</div>


<!-- HEADER END -->