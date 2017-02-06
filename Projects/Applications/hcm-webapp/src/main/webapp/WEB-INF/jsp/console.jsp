<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>

<!DOCTYPE html>
<html lang="en">


<head>
<meta http-equiv="Cache-Control"
	content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta charset="UTF-8">
<!-- If IE use the latest rendering engine -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Set the page to the width of the device and set the zoon level -->
<meta name="viewport" content="width = device-width, initial-scale = 1">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>${localization['page-title']}</title>


<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css" />
<link rel="stylesheet"
	href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.css" />
<link
	href="${pageContext.request.contextPath}/resources/custom/css/jquery.growl.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/bootstrap-multiselect.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/custom.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/console.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/simple-sidebar.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/bootstrap-clockpicker.min.css">

<script src="http://code.jquery.com/jquery.js"></script>
<script
	src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/bootstrap-multiselect.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/bootstrap-clockpicker.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/ajax-functions.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/navigation.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/custom/js/jquery.growl.js"
	type="text/javascript"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/cookies.js"></script>
<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">


</head>

<body>

	<input type="hidden" id="userid" name="userid" value="${userid}">
	<input type="hidden" id="username" name="username"
		value="${pageContext.request.userPrincipal.name}">

	<input type="hidden" id="message-device-updated"
		name="message-device-updated"
		value="${localization['message-device-updated']}">
	<input type="hidden" id="message-device-connected"
		name="message-device-connected"
		value="${localization['message-device-connected']}">
	<input type="hidden" id="message-device-disconnected"
		name="message-device-disconnected"
		value="${localization['message-device-disconnected']}">
	<input type="hidden" id="message-invalid-serial-number"
		name="message-invalid-serial-number"
		value="${localization['message-invalid-serial-number']}">
	<input type="hidden" id="message-valid-serial-number"
		name="message-valid-serial-number"
		value="${localization['message-valid-serial-number']}">
	<input type="hidden" id="message-invalid-user"
		name="message-invalid-user"
		value="${localization['message-invalid-user']}">


	<jsp:include page="wrapper/header.jsp">
		<jsp:param name="firstname" value="${firstname}" />
	</jsp:include>
	<br>

	<div class="console-container">
		<div id="product-dropdown"
			class="panel panel-default dropdown panel-heading">
			<label class="select-my-product-label">${localization['select-my-product']}</label>
			<select id="product-picker" onchange="loadProduct();"
				class="form-control select-my-product-picker">
				<c:forEach items="${userProducts}" var="ups" varStatus="count">

					<c:choose>
						<c:when test="${ups.isSelected()}">
							<option selected id="${ups.serialNumber}" class="select-my-product-picker-option"
								value="product-relay-control-${count.index}">${ups.name}
								(${ups.serialNumber})</option>
						</c:when>
						<c:otherwise>
							<option id="${ups.serialNumber}" class="select-my-product-picker-option"
								value="product-relay-control-${count.index}">${ups.name}
								(${ups.serialNumber})</option>
						</c:otherwise>
					</c:choose>

				</c:forEach>
			</select>
		</div>

		<div id="tabs-container navigation-tab-container">
			<ul class="nav nav-tabs nav-justified navigation-tabs" id="myTabs">
				<li class="active navigation-tab-list-element"><a href="#tab0">${localization['controls-title']}</a></li>
				<li><a href="#tab1" class="navigation-tab-list-element">${localization['settings-title']}</a></li>
				<li><a href="#tab2" class="navigation-tab-list-element">${localization['users-title']}</a></li>
				<!-- 					<li><a href="#tab3">Overview</a></li> -->
				<li><a href="#tab4" class="navigation-tab-list-element">${localization['registration-title']}</a></li>
			</ul>
		</div>


		<jsp:include page="console/controls.jsp"></jsp:include>
		<jsp:include page="console/settings.jsp"></jsp:include>
		<jsp:include page="console/users.jsp"></jsp:include>
		<jsp:include page="console/register.jsp"></jsp:include>


	</div>

	<jsp:include page="wrapper/footer.jsp" />

</body>
</html>