<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true" %>

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
<title>jTech Console</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/bootstrap-multiselect.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/bootstrap-clockpicker.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/stomp.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/ajax-functions.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/navigation.js"></script>


<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.1/sockjs.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/custom/js/jquery.growl.js"
	type="text/javascript"></script>
<link
	href="${pageContext.request.contextPath}/resources/custom/css/jquery.growl.css"
	rel="stylesheet" type="text/css" />

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/bootstrap-multiselect.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/custom.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/simple-sidebar.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/bootstrap-clockpicker.min.css">
<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">



</head>

<body>

	<input type="hidden" id="userid" name="userid" value="${userid}">
	<input type="hidden" id="username" name="username"
		value="${pageContext.request.userPrincipal.name}">

	<jsp:include page="wrapper/header.jsp">
		<jsp:param name="firstname" value="${firstname}" />
	</jsp:include>
	<br>

	<div class="container-fluid"
		style="padding-right: 0px; padding-left: 0px;">

		<div class="masthead center-block">

			<div class="panel panel-default">
				<div id="product-dropdown" class="dropdown panel-heading">
					<div style="display: inline-block;">
						<label>Select My <b>Product</b></label> <select
							id="product-picker" onchange="showProductControls('0');"
							class="form-control" style="width: 250px;">
							<c:forEach items="${userProducts}" var="ups" varStatus="count">
								<option id="${ups.serialNumber}"
									value="product-relay-control-${count.index}">${ups.name}
									(${ups.serialNumber})</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>

			<div id="tabs-container">
				<ul class="nav nav-tabs nav-justified" id="myTabs">
					<li class="active"><a href="#tab0">Controls</a></li>
					<li><a href="#tab1">Settings</a></li>
					<li><a href="#tab2">Users</a></li>
					<!-- 					<li><a href="#tab3">Overview</a></li> -->
					<li><a href="#tab4">Registration</a></li>
				</ul>
			</div>

			<jsp:include page="console/controls.jsp">
				<jsp:param name="userProducts" value="${userProducts}" />
			</jsp:include>

			<jsp:include page="console/settings.jsp">
				<jsp:param name="userProducts" value="${userProducts}" />
			</jsp:include>

			<jsp:include page="console/users.jsp">
				<jsp:param name="userProducts" value="${userProducts}" />
			</jsp:include>

			<jsp:include page="console/register.jsp">
				<jsp:param name="userProducts" value="${userProducts}" />
			</jsp:include>


		</div>

		<jsp:include page="wrapper/footer.jsp" />

	</div>



</body>
</html>