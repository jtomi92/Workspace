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
<title>${localization['page-title']}</title>

<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css" />
<link rel="stylesheet"
	href="http://cdnjs.cloudflare.com/ajax/libs/prettify/r298/prettify.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/simple-sidebar.css">
<link href="https://fonts.googleapis.com/css?family=Exo"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/custom/css/contact.css">

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
					<label>${localization['contact-us']}</label>
				</h2>
			</div>
			<div class="panel panel-default">
				<div id="product-dropdown" class="dropdown panel-heading">

					<form:form action="contact" commandName="contactForm">
						<div class="form-group">



							<table class="table table-condensed">

								<tbody>
									<tr>
										<td><h4>${localization['name']}</h4></td>
										<td><form:input class="form-control input-lg"
												style="width:300px;" path="name" size="30" type="text" /></td>
										<td><p
												style="text-align: left; position: relative; float: left"
												class="alert-danger">${localization['invalid-name-message']}</p></td>
									</tr>


									<tr>
										<td><h4>${localization['email']}</h4></td>
										<td><form:input class="form-control input-lg"
												style="width:300px;" path="email" size="30" type="text" /></td>
										<td><p
												style="text-align: left; position: relative; float: left"
												class="alert-danger">${localization['invalid-email-message']}</p></td>
									</tr>


									<tr>
										<td><h4>${localization['message']}</h4></td>
										<td><form:textarea class="form-control input-lg"
												style="width:400px; height:200px;" path="message" size="30"
												type="text" /></td>
										<td>

											<p style="text-align: left; position: relative; float: left"
												class="alert-danger">${localization['invalid-content-message']}</p>
										</td>

									</tr>


									<tr>
										<td><h5>${localization['send-mail']}</h5></td>
										<td></td>
									</tr>

								</tbody>
							</table>
							<div class="text-center" role="group" aria-label="...">
								<button type="submit" class="btn btn-primary btn-lg">${localization['send-message']}</button>
							</div>
						</div>
					</form:form>

				</div>

			</div>
		</div>
	</div>


	<jsp:include page="wrapper/footer.jsp" />

</body>
</html>