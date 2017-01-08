//@formatter:off 
$(document).ready(			
		function() {
			setInterval(function(){ 
				var token = $("meta[name='_csrf']").attr("content");
				var header = $("meta[name='_csrf_header']").attr("content");
				var userid = document.getElementById("userid").value;
				
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
								$.growl.disconnected({ message: serialNumber + " is now OFFLINE" });
							} else if (connection != null && connection == 1){
								var element = document.getElementById(serialNumber+"-connection-status-offline");
								if (element != null){
									element.style.display = "none";
								}
								var element = document.getElementById(serialNumber+"-connection-status-online");
								if (element != null){
									element.style.display = "block";
								}
								$.growl.connected({ message: serialNumber + " is now ONLINE" });				
							}
							
							if (notifications != null){
								$.each(notifications, function(index, notification) {
									if (notification.indexOf("UPDATED") != -1){
										$.growl.updated({ message: serialNumber + " updated settings" });
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

	document.getElementById("register-error-message").style.visibility = "hidden";

	if (serialNumber == "" || serialNumber == null) {
		document.getElementById("register-error-message").innerHTML = "Invalid serial number.";
		document.getElementById("register-error-message").style.visibility = "visible";
		return;
	}
	var userid = document.getElementById("userid").value;
	var serialNumber = $("#registrationSerialNumber").val();
	data['userId'] = userid;
	data['serialNumber'] = serialNumber;

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
						document.getElementById("register-error-message").innerHTML = "Serial Number does not exist.";
						document.getElementById("register-error-message").style.visibility = "visible";
					} else {
						document.getElementById("register-success-message").innerHTML = "You have successfully registered your product";
						document.getElementById("register-success-message").style.visibility = "visible";
						//updateDevice(serialNumber);
						location.reload();
					}

				},
				error : function(e) {
					// console.log("error");
					// console.log(e);
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

function saveProductName(serialNumber, index) {
	var data = {};
	var productName = document.getElementById("registred-product-field-"
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
			location.reload();

		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
		}

	});

}

function addProductUser(serialNumber, index) {

	var userToAdd = document.getElementById("add-product-user-" + index).value;
	var userid = document.getElementById("userid").value;
	
	document.getElementById("user-error-message-" + index).style.visibility = "hidden";
	// console.log("SERIALNUMBER=" + serialNumber);
	// console.log("INPUTID=" + index);
	// console.log("USER=" + userToAdd);

	if (userToAdd === null || userToAdd === "") {
		document.getElementById("user-error-message-" + index).innerHTML = "Field cannot be empty.";
		document.getElementById("user-error-message-" + index).style.visibility = "visible";
		return;
	}

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	var result = '';

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
						document.getElementById("user-error-message-" + index).innerHTML = "User does not exist.";
						document.getElementById("user-error-message-" + index).style.visibility = "visible";
					} else if (res == '1') {
						// console.log('1' + res);
						//updateDevice(serialNumber);
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
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
		}

	});

}

function updateProductUser(userName, serialNumber, input) {
	var data = {};
	var selectedCallAccess = [];
	$("#product-relay-call-picker-" + input + " :selected").each(function() {
		selectedCallAccess.push($(this).text());
	});

	var selectedRelayAccess = [];
	$("#product-relay-priv-picker-" + input + " :selected").each(function() {
		selectedRelayAccess.push($(this).text());
	});
	var privilige = $("#product-priv-picker-" + input + " :selected").text();

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
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
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

	$('#save-progressbar-' + serialNumber).show();
	$('#save-switch-' + serialNumber).hide();

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
			$('#save-progressbar-' + serialNumber).hide();
			$('#save-switch-' + serialNumber).show();
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
			$('#save-progressbar-' + serialNumber).hide();
			$('#save-switch-' + serialNumber).show();
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

	var progressbars = $('div[id^="relay-progressbar-' + serialNumber + '"]')
	var switches = $('button[id^="relay-switch-' + serialNumber + '"]')

	$.each(progressbars, function(key, value) {
		$(this).show();
	});
	$.each(switches, function(key, value) {
		$(this).hide();
	});

	var timeout = setTimeout(function() {
		var progressbars = $('div[id^="relay-progressbar-' + serialNumber
				+ '"]')
		var switches = $('button[id^="relay-switch-' + serialNumber + '"]')

		$.each(progressbars, function(key, value) {
			$(this).hide();
		});
		$.each(switches, function(key, value) {
			$(this).show();
		});
	}, 6000);

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
				var progressbars = $('div[id^="relay-progressbar-'
						+ serialNumber + '"]')
				var switches = $('button[id^="relay-switch-' + serialNumber
						+ '"]')
				clearTimeout(timeout);		
				$.each(progressbars, function(key, value) {
					$(this).hide();
				});
				$.each(switches, function(key, value) {
					$(this).show();
				});
			}
			

		},
		error : function(e) {
			var progressbars = $('div[id^="relay-progressbar-' + serialNumber
					+ '"]')
			var switches = $('button[id^="relay-switch-' + serialNumber + '"]')

			$.each(progressbars, function(key, value) {
				$(this).hide();
			});
			$.each(switches, function(key, value) {
				$(this).show();
			});
			clearTimeout(timeout);
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

	document.getElementById("remove-setting-progressbar-" + serialNumber + "-"
			+ moduleId + "-" + relayId + "-" + timerId).style.display = "block";
	document.getElementById("remove-setting-button-" + serialNumber + "-"
			+ moduleId + "-" + relayId + "-" + timerId).style.display = "none";

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
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
		}

	});
}

function addTimerSetting(serialNumber, moduleId, relayId) {
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	document.getElementById("add-setting-progressbar-" + serialNumber + "-"
			+ moduleId + "-" + relayId).style.display = "block";
	document.getElementById("add-setting-button-" + serialNumber + "-"
			+ moduleId + "-" + relayId).style.display = "none";

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
		},
		error : function(e) {
			// console.log("error");
			// console.log(e);
		}

	});
}

function loadUserProduct() {
	var serialNumber = $("#product-picker").children(":selected").attr("id");
}
