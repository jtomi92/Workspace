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
<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">
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


</head>
<body>

	<jsp:include page="wrapper/header.jsp">
		<jsp:param name="firstname" value="${firstName}" />
	</jsp:include>


	<div class="container">
		<form name='myaccount' action="<c:url value='/myaccount' />"
			method='POST'>
			<div class="col-md-16 col-md-offset-2">
				<!-- page-header adds space aroundtext and enlarges it. It also adds an underline at the end -->

				<div class="page-header" style="text-align: center;">
					<h1>${localization['my-account']}</h1>
				</div>

				<table class="table table-condensed">
					<thead>
						<tr>
							<th colspan="2" style="text-align: center;"><h4>
									${localization['login-information']}</h4></th>
						</tr>
						<tr>
							<c:if test="${not empty passwordsuccess}">
								<th colspan="2" style="text-align: center;"><br>
									<div class="text-center alert-danger">
										<h4>${passwordsuccess}</h4>
									</div></th>
							</c:if>

							<c:if test="${not empty passworderror}">
								<th colspan="2" style="text-align: center;"><br>
									<div class="text-center alert-danger">
										<h4>${passworderror}</h4>
									</div></th>
							</c:if>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><h4>${localization['old-password']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="oldPassword" type="password"></td>
						</tr>

						<tr>
							<td><h4>${localization['new-password']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="newPassword" type="password"></td>
						</tr>

						<tr>
							<td><h4>${localization['confirm-password']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="confirmPassword" type="password"></td>
						</tr>

					</tbody>
				</table>




				<table class="table">
					<thead>
						<tr>
							<th colspan="2" style="text-align: center;"><h4>${localization['my-information']}</h4></th>
						</tr>

						<tr>
							<c:if test="${not empty success}">
								<th colspan="2" style="text-align: center;"><br>
									<div class="text-center alert-success">
										<h4>${success}</h4>
									</div></th>
							</c:if>

							<c:if test="${not empty error}">
								<th colspan="2" style="text-align: center;"><br>
									<div class="text-center alert-danger">
										<h4>${error}</h4>
									</div></th>
							</c:if>
						</tr>
					</thead>
					<tbody>

						<tr>
							<td><h4>${localization['first-name']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="firstName" value="${firstName}" type="text"></td>
						</tr>

						<tr>
							<td><h4>${localization['last-name']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="lastName" value="${lastName}" type="text"></td>
						</tr>
						<tr>
							<td><h4>${localization['email-address']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="email" value="${email}" type="text"></td>
						</tr>

						<tr>
							<td><h4>${localization['phone-number']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="phone" value="${phone}" type="text"></td>
						</tr>

						<tr>
							<td><h4>${localization['address']}</h4></td>
							<td><input class="form-control input-lg" id="inputlg"
								name="address" value="${address}" type="text"></td>

						</tr>

						<tr>
							<td><h4>${localization['city']}</h4></td>

							<td><input class="form-control input-lg" id="inputlg"
								name="city" value="${city}" type="text"></td>

						</tr>
				</table>

				<br>

				<div class="text-center" style="padding-bottom: 100px;" role="group"
					aria-label="...">
					<button type="submit" class="btn btn-primary btn-lg">${localization['save-changes']}</button>
				</div>

				<br>


			</div>
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</form>
	</div>
	<div class="container-fluid">
		<jsp:include page="wrapper/footer.jsp" />
	</div>

</body>
</html>