//@formatter:off 
$(document).ready(			
		function() {
			setInterval(function(){ 
				var token = $("meta[name='_csrf']").attr("content");
				var header = $("meta[name='_csrf_header']").attr("content");
				var userid = document.getElementById("userid").value;
				var onlineMessage = document.getElementById("message-device-connected").value;
				var offlineMessage = document.getElementById("message-device-disconnected").value;
				var updatedMessage = document.getElementById("message-device-updated").value;
				
				$
				.ajax({
					type : "GET",
					contentType : "application/json",
					async : true,
					url : 'notifications/get/' + userid,
					dataType : 'json',
					beforeSend : function(xhr) {
						// here it is
						xhr.setRequestHeader(header, token);
					},
					success : function(res, ioArgs) {
					 
						console.log(JSON.stringify(res));
						$.each(res, function(index, element) {
							var serialNumber = element.sn;
							var connection = element.cn;
							var relays = element.rs;
							var notifications = element.ns;
							
							if (connection != null && connection == 0){
								var element = document.getElementById(serialNumber+"-connection-status-offline");
								if (element != null){
									element.style.display = "block";
								}
								var element = document.getElementById(serialNumber+"-connection-status-online");
								if (element != null){
									element.style.display = "none";
								}
								$.growl.disconnected({ message: serialNumber + offlineMessage });
							} else if (connection != null && connection == 1){
								var element = document.getElementById(serialNumber+"-connection-status-offline");
								if (element != null){
									element.style.display = "none";
								}
								var element = document.getElementById(serialNumber+"-connection-status-online");
								if (element != null){
									element.style.display = "block";
								}
								$.growl.connected({ message: serialNumber + onlineMessage });				
							}
							
							if (notifications != null){
								$.each(notifications, function(index, notification) {
									if (notification.indexOf("UPDATED") != -1){
										$.growl.updated({ message: serialNumber + updatedMessage });
									}
									if (notification.indexOf("REFRESH") != -1){
										location.reload();
									}
								});
							}
							
							if (relays != null){
								$.each(relays, function(index, relay) {
									var moduleId = relay.mi;
									var relayId = relay.ri;
									var stat = relay.sw; 
									
									if (stat == 1) {
										var element = document.getElementById("relaystatus-on-"
												+ serialNumber + "-" + moduleId + "-" + relayId);
										if (element != null) {
											element.style.display = "inline";
										}
										var element = document.getElementById("relaystatus-off-"
												+ serialNumber + "-" + moduleId + "-" + relayId);
										if (element != null) {
											element.style.display = "none";
										}
										 
									} else if (stat == 0) {
										var element = document.getElementById("relaystatus-on-"
												+ serialNumber + "-" + moduleId + "-" + relayId);
										if (element != null) {
											element.style.display = "none";
										}
										var element = document.getElementById("relaystatus-off-"
												+ serialNumber + "-" + moduleId + "-" + relayId);
										if (element != null) {
											element.style.display = "inline";
										}
									}
									
								});
							}
				        });

					},
					error : function(e) {
						// console.log("error");
						// console.log(e);
						location.reload();
					}

				});
				
			}, 3000);
		});

//@formatter:on
function registerProduct() {
	var data = {};
	var serialNumber = $("#registrationSerialNumber").val();

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var invalidMessage = document.getElementById("message-invalid-serial-number").value;
	var validMessage = document.getElementById("message-valid-serial-number").value;
		
	document.getElementById("register-error-message").style.visibility = "hidden";

	if (serialNumber == "" || serialNumber == null) {
		document.getElementById("register-error-message").innerHTML = invalidMessage;
		document.getElementById("register-error-message").style.visibility = "visible";
		return;
	}
	var userid = document.getElementById("userid").value;
	var serialNumber = $("#registrationSerialNumber").val();
	data['userId'] = userid;
	data['serialNumber'] = serialNumber;
	
	document.getElementById("loading-spinner").style.display = "block";

	var result = '';
	// console.log(data);

	$
			.ajax({
				type : "POST",
				contentType : "application/json",
				async : true,
				url : 'register',
				data : JSON.stringify(data),
				dataType : 'json',
				beforeSend : function(xhr) {
					// here it is
					xhr.setRequestHeader(header, token);
				},
				success : function(res, ioArgs) {
					result = res;

					// console.log(res);

					if (res == '0') {
						document.getElementById("register-error-message").innerHTML = invalidMessage;
						document.getElementById("register-error-message").style.visibility = "visible";
					} else {
						document.getElementById("register-success-message").innerHTML = validMessage;
						document.getElementById("register-success-message").style.visibility = "visible";
						//updateDevice(serialNumber);
						location.reload();
					}
					
					document.getElementById("loading-spinner").style.display = "none";

				},
				error : function(e) {
					// console.log("error");
					// console.log(e);
					document.getElementById("loading-spinner").style.display = "none";
				}

			});

}

$(document)
		.ready(
				function() {
					if (localStorage.getItem("showNotificationModal") == "true") {

						document.getElementById("notificationModalTitle").innerHTML = localStorage
								.getItem("notificationModalTitle");
						document.getElementById("notificationModalContent").innerHTML = localStorage
								.getItem("notificationModalContent");

						$('#notificationModal').modal('show');
						localStorage.setItem("showNotificationModal", "false");
					}
				});

function saveProductName(serialNumber, field, index) {
	var data = {};
	
	var productName = document.getElementById("registred-product-field-" + field + "-"
			+ index).value;
	var userid = document.getElementById("userid").value;

	// console.log("SERIAL=" + serialNumber + " PRODUCTNAME=" + productName
	// + " USERID=" + userid);

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	data['userId'] = userid;
	data['serialNumber'] = serialNumber;
	data['productName'] = productName;

	// console.log(data);
	
	document.getElementById("loading-spinner").style.display = "block";

	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'update',
		data : JSON.stringify(data),
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			// console.log(res);

			if (res == '0') {

			} else {

			}
			document.getElementById("loading-spinner").style.display = "none";
			location.reload();

		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});

}

function addProductUser(serialNumber, index) {

	var userToAdd = document.getElementById("add-product-user-" + index).value;
	var userid = document.getElementById("userid").value;
	var validMessage = document.getElementById("message-invalid-user").value;
	
	document.getElementById("user-error-message-" + index).style.visibility = "hidden";
	// console.log("SERIALNUMBER=" + serialNumber);
	// console.log("INPUTID=" + index);
	// console.log("USER=" + userToAdd);

	if (userToAdd === null || userToAdd === "") {
		document.getElementById("user-error-message-" + index).innerHTML = validMessage;
		document.getElementById("user-error-message-" + index).style.visibility = "visible";
		return;
	}

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var result = '';
	
	document.getElementById("loading-spinner").style.display = "block";

	$
			.ajax({
				type : "POST",
				contentType : "application/json",
				async : true,
				url : 'productuser/add/' + userid + '/' + serialNumber + '/' + userToAdd + '/',
				dataType : 'json',
				beforeSend : function(xhr) {
					// here it is
					xhr.setRequestHeader(header, token);
				},
				success : function(res, ioArgs) {

					if (res == '0') {
						// console.log('0' + res);
						document.getElementById("user-error-message-" + index).innerHTML = validMessage;
						document.getElementById("user-error-message-" + index).style.visibility = "visible";
					} else if (res == '1') {
						// console.log('1' + res);
						//updateDevice(serialNumber);
						location.reload();
					} else if (res == '-1') {
						// console.log('-1' + res);
					}
					document.getElementById("loading-spinner").style.display = "none";

				},
				error : function(e) {
					// console.log("error");
					// console.log(e);
					document.getElementById("loading-spinner").style.display = "none";
				}			

			});

}

function removeProductUser(userToRemove, serialNumber, input) {

	var currUser = document.getElementById("username").value;
	// console.log("CURRENTUSER=" + currUser);
	if (currUser == userToRemove) {
		// console.log("do not delete urself lol");
		return;
	}

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;
	
	var result = '';
	
	document.getElementById("loading-spinner").style.display = "block";

	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'productuser/remove/' + userid + '/' + serialNumber + '/' + userToRemove + '/',
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				//updateDevice(serialNumber);
				location.reload();
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});

}

function updateProductUser(userName, field, serialNumber, input) {
	var data = {};
	var selectedCallAccess = [];
	$("#product-relay-call-picker-" + field + "-" + input + " :selected").each(function() {
		selectedCallAccess.push($(this).text());
	});

	var selectedRelayAccess = [];
	$("#product-relay-priv-picker-" + field + "-" + input + " :selected").each(function() {
		selectedRelayAccess.push($(this).text());
	});
	var privilige = $("#product-priv-picker-" + field + "-" + input + " :selected").text();

	// console.log("PRIVILIGE=" + privilige);
	// console.log("USER=" + userName);
	// console.log("SERIALNUMBER=" + serialNumber);
	// console.log("PRIV-VALUES=" + selectedRelayAccess);
	// console.log("CALL-VALUES=" + selectedCallAccess);

	data['relayAccess'] = selectedRelayAccess;
	data['callAccess'] = selectedCallAccess;
	data['privilige'] = privilige;

	// console.log(data);

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;
	
	document.getElementById("loading-spinner").style.display = "block";
	
	$.ajax({
		type : "PUT",
		contentType : "application/json",
		async : true,
		url : 'productuser/update/' + userid + '/' + serialNumber + '/' + userName + '/',
		data : JSON.stringify(data),
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				//updateDevice(serialNumber);
				location.reload();
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});
}

function updateProductSettings(serialNumber, position) {

	var moduleIds = [];
	var relayIds = [];
	var timerIds = [];
	var relayNames = [];
	var delays = [];
	var impulses = [];

	var startWeekDays = [];
	var endWeekDays = [];
	var startTimers = [];
	var endTimers = [];
	var timerEnabled = [];

	$('td[id^="' + serialNumber + '-moduleid-"]').each(function() {
		moduleIds.push($(this).html());
	});

	$('td[id^="' + serialNumber + '-relayid-"]').each(function() {
		relayIds.push($(this).html());
	});

	$('td[id^="' + serialNumber + '-timerid-"]').each(function() {
		timerIds.push($(this).html());
	});

	// console.log('input[id^="'+serialNumber + '-relayname-"]');
	$('input[id^="' + serialNumber + '-relayname-"]').each(function() {

		relayNames.push($(this).val());
	});

	$('input[id^="' + serialNumber + '-delay-"]').each(function() {
		delays.push($(this).val());
	});

	$('input[id^="' + serialNumber + '-impulse-"]').each(function() {
		impulses.push($(this).is(':checked') ? "1" : "0");
	});

	$('select[id^="weekday-picker-start-' + serialNumber + '"]').each(
			function() {
				startWeekDays.push($(this).val());
			});

	$('select[id^="weekday-picker-end-' + serialNumber + '"]').each(function() {
		endWeekDays.push($(this).val());
	});

	$('input[id^="timer-enabled-' + serialNumber + '"]').each(function() {
		timerEnabled.push($(this).is(':checked') ? "1" : "0");
	});

	$('input[id^="start-timer-' + serialNumber + '"]').each(function() {
		startTimers.push($(this).val());
	});

	$('input[id^="end-timer-' + serialNumber + '"]').each(function() {
		endTimers.push($(this).val());
	});

	var tosend = {
		"moduleIds" : moduleIds,
		"relayIds" : relayIds,
		"timerIds" : timerIds,
		"relayNames" : relayNames,
		"delays" : delays,
		"impulses" : impulses,
		"startWeekDays" : startWeekDays,
		"endWeekDays" : endWeekDays,
		"timerEnabled" : timerEnabled,
		"startTimers" : startTimers,
		"endTimers" : endTimers
	};

	// console.log(JSON.stringify(tosend));
	var userid = document.getElementById("userid").value;
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	document.getElementById("loading-spinner").style.display = "block";
	
	$.ajax({
		type : "PUT",
		contentType : "application/json",
		async : true,
		url : 'productsetting/update/' + userid + '/' + serialNumber,
		data : JSON.stringify(tosend),
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				//updateDevice(serialNumber);
				location.reload();
				
				//
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});

}

function switchRelay(serialNumber, moduleId, relayId) {

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;
	var relaystatus;
	var element = document.getElementById("relaystatus-on-" + serialNumber + "-" + moduleId + "-" + relayId);
	if (element != null && element.style.display == "inline") {
		relaystatus = 0;
	} else {
		relaystatus = 1;
	}


	var timeout = setTimeout(function() {
		document.getElementById("loading-spinner").style.display = "none";
	}, 6000);

	document.getElementById("loading-spinner").style.display = "block";
	
	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'relay/' + userid + '/' + serialNumber + '/' + moduleId + '/'
				+ relayId + '/' + relaystatus,

		beforeSend : function(xhr) {

			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {
 
			var fields = res.response.split(";");

			// if "SWITCH" is recieved
			if (fields.length == 5 && fields[0] == "SWITCH") {
				var serialNumber = fields[1];
				var moduleId = fields[2];
				var relayId = fields[3];
				var stat = fields[4];

				if (stat == "1") {
					var element = document.getElementById("relaystatus-on-"
							+ serialNumber + "-" + moduleId + "-" + relayId);
					if (element != null) {
						element.style.display = "inline";
					}
					var element = document.getElementById("relaystatus-off-"
							+ serialNumber + "-" + moduleId + "-" + relayId);
					if (element != null) {
						element.style.display = "none";
					}
				} else if (stat == "0") {
					var element = document.getElementById("relaystatus-on-"
							+ serialNumber + "-" + moduleId + "-" + relayId);
					if (element != null) {
						element.style.display = "none";
					}
					var element = document.getElementById("relaystatus-off-"
							+ serialNumber + "-" + moduleId + "-" + relayId);
					if (element != null) {
						element.style.display = "inline";
					}
				}
				
				clearTimeout(timeout);		
				
			}
			document.getElementById("loading-spinner").style.display = "none";

		},
		error : function(e) {

			clearTimeout(timeout);
			document.getElementById("loading-spinner").style.display = "none";
			location.reload();
		}

	});
}

/*function updateDevice(serialNumber) {

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;

	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'device/update/' + userid + '/' + serialNumber,
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {
			console.log(res);
			var fields = res.response.split(";");	
			if (fields.length == 2 && fields[0] == "UPDATED") {
				$.growl.updated({ message: fields[1] + " updated settings." });
			}
			
		},
		error : function(e) {
			 console.log("error");
			 console.log(e);
		}

	});
}*/

function restartDevice(serialNumber) {

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;

	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'device/restart/' + userid + '/' + serialNumber,
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				location.reload();
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
		}

	});
}

function deleteTimerSetting(serialNumber, moduleId, relayId, timerId) {
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userid = document.getElementById("userid").value;

	document.getElementById("loading-spinner").style.display = "block";
	
	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'productsetting/timer/remove/' + serialNumber + '/' + moduleId
				+ '/' + relayId + '/' + timerId,
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				location.reload();
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});
}

function addTimerSetting(serialNumber, moduleId, relayId) {
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	document.getElementById("loading-spinner").style.display = "block";
	$.ajax({
		type : "POST",
		contentType : "application/json",
		async : true,
		url : 'productsetting/timer/add/' + serialNumber + '/' + moduleId + '/'
				+ relayId,
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				// console.log('0' + res);
			} else if (res == '1') {
				// console.log('1' + res);
				location.reload();
			} else if (res == '-1') {
				// console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});
}

function loadProduct(){
	var serialNumber = $('#product-picker').children(":selected").attr("id");
	var userid = document.getElementById("userid").value;
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	document.getElementById("loading-spinner").style.display = "block";
	
	$.ajax({
		type : "GET",
		contentType : "application/json",
		async : true,
		url : 'userproduct/select/' + serialNumber + '/' + userid,
		dataType : 'json',
		beforeSend : function(xhr) {
			// here it is
			xhr.setRequestHeader(header, token);
		},
		success : function(res, ioArgs) {

			if (res == '0') {
				console.log('0' + res);
			} else if (res == '1') {
				console.log('1' + res);
				location.reload();
			} else if (res == '-1') {
				console.log('-1' + res);
			}
			document.getElementById("loading-spinner").style.display = "none";
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			document.getElementById("loading-spinner").style.display = "none";
		}

	});
}

function loadUserProduct() {
	var serialNumber = $("#product-picker").children(":selected").attr("id");
}
