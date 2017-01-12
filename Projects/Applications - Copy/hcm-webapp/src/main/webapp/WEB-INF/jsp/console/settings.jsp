<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>

<section id="tab1" class="tab-content hide">

	<div id="product-relay-settings">
		<!-- Default panel contents -->
		<c:forEach items="${userProducts}" var="ups" varStatus="count">

			<div class="panel panel-default"
				id="product-relay-control-${count.index}" style="display: none;">

				<div class="page-header" style="text-align: center;">
					<h3>${localization['relay-settings']}</h3>
				</div>

				<div class="container-fluid" style="text-align: center;">
					<label>${localization['select-relays']}</label>
				</div>
				<div id="product-relay-setting-dropdown-${count.index}"
					style="text-align: center;" class="container-fluid">
					<select id="product-relay-setting-picker-${count.index}"
						name="product-relay-setting-picker" multiple="multiple"
						onchange="showRelaySetting('product-relay-setting-picker-${count.index}','rel-setting-${count.index}');">
						<c:forEach
							items="${ups.productSettings.iterator().next().relaySettings}"
							var="relaysetting" varStatus="count2">
							<c:forEach items="${relaysetting.productControlSettings}"
								var="pcs">
								<c:if test="${(pcs.userId eq userid) && pcs.isAccess()}">
									<option value="relay-setting-${count2.index}">${relaysetting.relayName}
										(${relaysetting.moduleId}/${relaysetting.relayId})</option>
								</c:if>
							</c:forEach>
						</c:forEach>
					</select>
				</div>

				<br>
				<div class="table-responsive container panel panel-default">
					<div id="rel-setting-${count.index}">
						<div class="thumbnail">
							<table class="table table-striped" id="relaysettingtable">
								<thead>
									<tr>
										<th>${localization['module-id']}</th>
										<th>${localization['relay-id']}</th>
										<th>${localization['relay-name']}</th>
										<th>${localization['delay']}</th>
										<th>${localization['impulse']}</th>
										<th>${localization['timers']}</th>
									</tr>
								</thead>
								<tbody>

									<c:forEach
										items="${ups.productSettings.iterator().next().relaySettings}"
										var="relaysetting" varStatus="count2">
										<c:forEach items="${relaysetting.productControlSettings}"
											var="pcs">
											<c:if test="${(pcs.userId eq userid) && pcs.isAccess()}">
												<tr class="${ups.serialNumber}-relay-setting"
													id="relay-setting-${count2.index}" style="display: none;">
													<td id="${ups.serialNumber}-moduleid-${count2.index}">${relaysetting.moduleId}</td>
													<td id="${ups.serialNumber}-relayid-${count2.index}">${relaysetting.relayId}</td>
													<td><input
														id="${ups.serialNumber}-relayname-${count2.index}"
														type="text" class="input-sm" style="width: 150px"
														value="${relaysetting.relayName}"></td>
													<td><input
														id="${ups.serialNumber}-delay-${count2.index}"
														type="number" min="0" class="input-sm"
														style="width: 100px" value="${relaysetting.delay}"></td>
													<td><c:choose>
															<c:when test="${relaysetting.impulseMode}">
																<input id="${ups.serialNumber}-impulse-${count2.index}"
																	checked type="checkbox" value="">
															</c:when>
															<c:otherwise>
																<input id="${ups.serialNumber}-impulse-${count2.index}"
																	type="checkbox" value="">
															</c:otherwise>
														</c:choose></td>
													<td><button type="button" class="btn-primary btn"
															onclick="showHideTags('relay-timers-${count.index}','div','relay-tmr-${count2.index}','relay')">${localization['edit']}</button></td>
												</tr>
											</c:if>
										</c:forEach>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
					<div id="relay-timers-${count.index}" class="thumbnail">
						<c:forEach
							items="${ups.productSettings.iterator().next().relaySettings}"
							var="relaysetting" varStatus="count2">

							<c:set var="lastItem"
								value="${fn:length(relaysetting.timerSettings)}" />
							<c:forEach items="${relaysetting.timerSettings}"
								var="timerSetting" varStatus="count3">

								<div class="${ups.serialNumber}-relay-timer thumbnail"
									id="relay-tmr-${count2.index}" style="display: none;">
									<table class="table">
										<thead>
											<tr>
												<th>${localization['module-id']}</th>
												<th>${localization['relay-id']}</th>
												<th>${localization['timer-id']}</th>
												<th>${localization['function']}</th>
												<th>${localization['days-of-week']}</th>
												<th>${localization['timer']}</th>
												<th>${localization['enabled']}</th>
											</tr>
										</thead>
										<tbody>
											<tr style="border-style: hidden;">
												<td>${relaysetting.moduleId}</td>
												<td>${relaysetting.relayId}</td>
												<td id="${ups.serialNumber}-timerid-${timerSetting.timerId}">${timerSetting.timerId}</td>
												<td><label>${localization['start-timer']}</label></td>
												<td><div class="dropup">
														<select
															id="weekday-picker-start-${ups.serialNumber}-${count2.index}-${count3.index}"
															multiple="multiple">
															<c:set var="weekday"
																value="${timerSetting.startWeekDays}" />

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'mon')}">
																	<option selected value="mon">${localization['monday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="mon">${localization['monday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'tue')}">
																	<option selected value="tue">${localization['tuesday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="tue">${localization['tuesday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'wed')}">
																	<option selected value="wed">${localization['wednesday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="wed">${localization['wednesday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'thu')}">
																	<option selected value="thu">${localization['thursday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="thu">${localization['thursday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'fri')}">
																	<option selected value="fri">${localization['friday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="fri">${localization['friday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'sat')}">
																	<option selected value="sat">${localization['saturday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="sat">${localization['saturday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'sun')}">
																	<option selected value="sun">${localization['sunday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="sun">${localization['sunday']}</option>
																</c:otherwise>
															</c:choose>

														</select>
													</div></td>
												<td>
													<div class="input-group clockpicker">
														<input
															id="start-timer-${ups.serialNumber}-${count2.index}-${count3.index}"
															type="text" class="form-control"
															value="${timerSetting.startTimer}"> <span
															class="input-group-addon"> <span
															class="glyphicon glyphicon-time"></span>
														</span>
													</div>
												</td>
												<td><c:choose>
														<c:when test="${timerSetting.timerEnabled}">
															<input
																id="timer-enabled-${ups.serialNumber}-${count2.index}-${count3.index}"
																checked type="checkbox" value="">
														</c:when>
														<c:otherwise>
															<input
																id="timer-enabled-${ups.serialNumber}-${count2.index}-${count3.index}"
																type="checkbox" value="">
														</c:otherwise>
													</c:choose></td>
											</tr>

											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td><label>${localization['end-timer']}</label></td>
												<td><div class="dropup">
														<select
															id="weekday-picker-end-${ups.serialNumber}-${count2.index}-${count3.index}"
															multiple="multiple">

															<c:set var="weekday" value="${timerSetting.endWeekDays}" />

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'MO')}">
																	<option selected value="mon">${localization['monday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="mon">${localization['monday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'TU')}">
																	<option selected value="tue">${localization['tuesday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="tue">${localization['tuesday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'WE')}">
																	<option selected value="wed">${localization['wednesday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="wed">${localization['wednesday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'TH')}">
																	<option selected value="thu">${localization['thursday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="thu">${localization['thursday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'FR')}">
																	<option selected value="fri">${localization['friday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="fri">${localization['friday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'SA')}">
																	<option selected value="sat">${localization['saturday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="sat">${localization['saturday']}</option>
																</c:otherwise>
															</c:choose>

															<c:choose>
																<c:when test="${fn:containsIgnoreCase(weekday,'SU')}">
																	<option selected value="sun">${localization['sunday']}</option>
																</c:when>
																<c:otherwise>
																	<option value="sun">${localization['sunday']}</option>
																</c:otherwise>
															</c:choose>
														</select>
													</div></td>
												<td>
													<div class="input-group clockpicker">
														<input
															id="end-timer-${ups.serialNumber}-${count2.index}-${count3.index}"
															type="text" class="form-control"
															value="${timerSetting.endTimer}"> <span
															class="input-group-addon"> <span
															class="glyphicon glyphicon-time"></span>
														</span>
													</div>
												</td>
												<td><c:if
														test="${lastItem == count3.count && relaysetting.timerSettings.size() > 1}">
														<button
															id="remove-setting-button-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}-${timerSetting.timerId}"
															onClick="deleteTimerSetting('${ups.serialNumber}','${relaysetting.moduleId}','${relaysetting.relayId}','${timerSetting.timerId}');"
															type="button" class="btn-danger btn btn-sm">${localization['delete']}</button>
														<div
															id="remove-setting-progressbar-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}-${timerSetting.timerId}"
															class="loader" style="display: none;" id="timex"></div>
													</c:if></td>
											</tr>
										</tbody>
									</table>
									<c:if test="${lastItem == count3.count}">
										<div style="text-align: right;">
											<button
												id="add-setting-button-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
												onClick="addTimerSetting('${ups.serialNumber}','${relaysetting.moduleId}','${relaysetting.relayId}');"
												type="button" class="btn-primary btn btn-sm">${localization['add-timer']}</button>
											<div
												id="add-setting-progressbar-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
												class="loader" style="display: none; text-align: right;"
												id="timex"></div>
										</div>
									</c:if>
								</div>
							</c:forEach>
						</c:forEach>
					</div>

				</div>

				<div class="container-fluid" style="text-align: center;">

					<c:choose>
						<c:when test="${privilige eq 'ADMIN'}">
							<div style=" display: none;"
								id="save-progressbar-${ups.serialNumber}"
								class="loader" id="timex"></div>
						    <button id="save-switch-${ups.serialNumber}"
								onClick="updateProductSettings('${ups.serialNumber}','${count.index}');"
								type="submit" class="btn-primary btn">${localization['save-setting']}</button>
						</c:when>
						<c:otherwise>
							<button disabled type="submit" class="btn-primary btn">${localization['save-setting']}</button>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</c:forEach>
	</div>
</section>