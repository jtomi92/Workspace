<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<!-- If IE use the latest rendering engine -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- Set the page to the width of the device and set the zoon level -->
<meta name="viewport" content="width = device-width, initial-scale = 1">
<meta name="_csrf" content="${_csrf.token}" />
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>${localization['page-title']}</title>

<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">
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

</head>
<body>

	<jsp:include page="wrapper/header.jsp" />

	<div class="container">

		<form:form action="register" commandName="userForm">
			<div class="col-md-8 col-md-offset-2">

				<!-- page-header adds space aroundtext and enlarges it. It also adds an underline at the end -->
				<div class="page-header" style="text-align: center;">
					<h1>${localization['create-account']}</h1>
				</div>

				<h4>
					<label for="inputlg"> <b>${localization['email']}</b>
					</label>
				</h4>
				<form:input type="text" class="form-control input-lg" path="email"
					size="30" placeholder="john.doe@example.com" />
				<form:errors path="email" cssClass="alert-danger" />


				<h4>
					<label for="inputlg"> <b>${localization['password']}</b>
					</label>
				</h4>
				<form:password class="form-control input-lg" path="password"
					size="30" />
				<form:errors path="password" cssClass="alert-danger" />


				<div class="form-group">
					<div class="row">
						<div class="col-lg-6">
							<div class="input-group">
								<h4>
									<label for="inputlg"> <b>${localization['first-name']}</b>
									</label>
								</h4>
								<form:input type="text" class="form-control input-lg"
									path="firstName" size="30" placeholder="John" />
								<form:errors path="firstName" cssClass="alert-danger" />
							</div>
							<!-- /input-group -->
						</div>
						<!-- /.col-lg-6 -->
						<div class="col-lg-6">
							<div class="input-group">
								<h4>
									<label for="inputlg"> <b>${localization['last-name']}</b>
									</label>
								</h4>
								<form:input type="text" class="form-control input-lg"
									path="lastName" size="30" placeholder="Doe" />
								<form:errors path="lastName" cssClass="alert-danger" />
							</div>
							<!-- /input-group -->
						</div>
						<!-- /.col-lg-6 -->
					</div>
					<!-- /.row -->

					<h4>
						<label for="inputlg"> <b>${localization['phone-number']}</b>
						</label>
					</h4>
					<form:input type="text" class="form-control input-lg" path="phone"
						size="30" placeholder="+36301234567" />
					<form:errors path="phone" cssClass="alert-danger" />

				</div>


				<br>


				<div class="text-center" role="group" aria-label="...">
					<button type="submit" class="btn btn-primary btn-lg">${localization['create-account']}</button>
				</div>

				<c:if test="${not empty error}">
					<h4 class="text-center alert alert-danger">${error}</h4>
				</c:if>

				<c:if test="${not empty success}">
					<h4 class="text-center alert alert-success">${success}</h4>
				</c:if>

				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
			</div>
		</form:form>
	</div>

	<jsp:include page="wrapper/footer.jsp" />
 
</body>
</html>