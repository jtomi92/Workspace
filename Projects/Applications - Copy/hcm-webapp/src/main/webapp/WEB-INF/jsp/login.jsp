<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<title>${localization['page-title']}</title>


<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css" />
<link rel="stylesheet"
	href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.css" />

<link
	href="${pageContext.request.contextPath}/resources/custom/css/custom.css"
	rel="stylesheet">
<script src="http://code.jquery.com/jquery.js"></script>
<script
	src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/custom/js/cookies.js"></script>
<link href="https://fonts.googleapis.com/css?family=Exo" rel="stylesheet">

</head>
<body>

	<jsp:include page="wrapper/header.jsp">
		<jsp:param name="firstname" value="${firstname}" />
	</jsp:include>

	<div class="container">
		<form name='login' action="<c:url value='/login' />" method='POST'>
			<div class="col-md-8 col-md-offset-2">

				<!-- page-header adds space aroundtext and enlarges it. It also adds an underline at the end -->

				<div class="page-header" style="text-align: center;">
					<h1>${localization['login-to-my-console']}</h1>
				</div>

				<div class="form-group">
					<h4>
						<label for="inputlg"> ${localization['email-address']}</label>
					</h4>
					<input class="form-control input-lg" id="inputlg" name="username"
						type="text">
				</div>

				<div class="form-group">
					<h4>
						<label for="inputlg"> ${localization['password']}</label>
					</h4>
					<input class="form-control input-lg" id="inputlg" name="password"
						type="password">
				</div>

				<div style="text-align: center;">
					<h4>
						<label for="remember-me">${localization['remember-me']} <input
							type="checkbox" name="remember-me" id="remember-me"></label>
					</h4>
				</div>

				<br>

				<div class="text-center" role="group" aria-label="...">
					<button type="submit" class="btn btn-primary btn-lg">${localization['login']}</button>
				</div>

				<c:if test="${param.error ne null}">
					<br>
					<div class="text-center alert-danger">
						<h4>${localization['invalid-message']}</h4>
					</div>
				</c:if>
				<c:if test="${param.logout ne null}">
					<br>
					<div class="text-center alert-success">
						<h4>${localization['logout-message']}</h4>
					</div>
				</c:if>

				<br>
				<hr>

				<div class="text-center" role="group" aria-label="...">
					<a href="${pageContext.request.contextPath}/register">${localization['create-account']}</a>
				</div>

			</div>
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</form>
	</div>

	<jsp:include page="wrapper/footer.jsp" />


</body>
</html>