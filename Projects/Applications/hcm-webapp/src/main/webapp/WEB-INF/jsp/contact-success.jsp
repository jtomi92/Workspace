<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
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
<title>jTech Contact Us</title>

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/custom.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/simple-sidebar.css">
<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">
<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css" />
<link rel="stylesheet"
	href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.css" />

<script src="http://code.jquery.com/jquery.js"></script>
<script
	src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/cookies.js"></script>

</head>
<body>

	<jsp:include page="wrapper/header.jsp">
		<jsp:param name="firstname" value="${firstname}" />
	</jsp:include>

	<div class="container-fluid"
		style="padding-right: 0px; padding-left: 0px;">

		<div class="masthead center-block">

			<div class="panel panel-default">

				<h2 style="text-align: center;">
					<label>Contact <b>Us</b></label>
				</h2>
			</div>
			<div class="panel panel-default">
				<div id="product-dropdown" class="dropdown panel-heading">

					<h4>
						Thank you for <b>Your</b> feedback! We'll get in contact soon.
					</h4>

				</div>

			</div>
		</div>
	</div>


	<jsp:include page="wrapper/footer.jsp" />

</body>
</html>