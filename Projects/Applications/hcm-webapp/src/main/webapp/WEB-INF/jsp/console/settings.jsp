<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>

<c:forEach items="${userProducts}" var="userProduct" varStatus="count">
	<c:if test="${userProduct.isSelected()}">
		<section id="tab1" class="tab-content hide">
			<div id="product-relay-settings" class="relay-settings">
				<!-- Default panel contents -->
				<div class="panel panel-default"
					id="product-relay-control-${count.index}">

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
							<c:forEach items="${userProduct.relaySettings}"
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
											<th class="col_1">${localization['module-id']}</th>
											<th class="col_2">${localization['relay-id']}</th>
											<th>${localization['relay-name']}</th>
											<th>${localization['delay']}</th>
											<th>${localization['impulse']}</th>
											<th>${localization['timers']}</th>
										</tr>
									</thead>
									<tbody>

										<c:forEach items="${userProduct.relaySettings}"
											var="relaysetting" varStatus="count2">
											<c:forEach items="${relaysetting.productControlSettings}"
												var="pcs">
												<c:if test="${(pcs.userId eq userid) && pcs.isAccess()}">
													<tr class="${userProduct.serialNumber}-relay-setting"
														id="relay-setting-${count2.index}" style="display: none;">
														<td class="col_1"
															id="${userProduct.serialNumber}-moduleid-${count2.index}">${relaysetting.moduleId}</td>
														<td class="col_2"
															id="${userProduct.serialNumber}-relayid-${count2.index}">${relaysetting.relayId}</td>
														<td><input
															id="${userProduct.serialNumber}-relayname-${count2.index}"
															type="text" class="input-sm" style="width: 100px"
															value="${relaysetting.relayName}"></td>
														<td><input
															id="${userProduct.serialNumber}-delay-${count2.index}"
															type="number" min="0" class="input-sm"
															style="width: 50px" value="${relaysetting.delay}"></td>
														<td><c:choose>
																<c:when test="${relaysetting.impulseMode}">
																	<input
																		id="${userProduct.serialNumber}-impulse-${count2.index}"
																		checked type="checkbox" value="">
																</c:when>
																<c:otherwise>
																	<input
																		id="${userProduct.serialNumber}-impulse-${count2.index}"
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
							<c:forEach items="${userProduct.relaySettings}"
								var="relaysetting" varStatus="count2">

								<c:set var="lastItem"
									value="${fn:length(relaysetting.timerSettings)}" />
								<c:forEach items="${relaysetting.timerSettings}"
									var="timerSetting" varStatus="count3">

									<div class="${userProduct.serialNumber}-relay-timer thumbnail"
										id="relay-tmr-${count2.index}" style="display: none;">
										<table class="table">
											<thead>
												<tr>
													<th class="col_1">${localization['module-id']}</th>
													<th class="col_2">${localization['relay-id']}</th>
													<th class="col_3">${localization['timer-id']}</th>
													<th>${localization['timer']}</th>
													<th>${localization['days-of-week']}</th>
													<th>${localization['enabled']}</th>
												</tr>
											</thead>
											<tbody>
												<tr style="border-style: hidden;">
													<td class="col_1">${relaysetting.moduleId}</td>
													<td class="col_2">${relaysetting.relayId}</td>
													<td class="col_3"
														id="${userProduct.serialNumber}-timerid-${timerSetting.timerId}">${timerSetting.timerId}</td>

													<td>
														<div class="input-group clockpicker">
															<input
																id="start-timer-${userProduct.serialNumber}-${count2.index}-${count3.index}"
																type="text" class="form-control"
																value="${timerSetting.startTimer}"> <span
																class="input-group-addon"> <span
																class="glyphicon glyphicon-time"></span>
															</span>
														</div>
													</td>
													<td><div class="dropup">
															<select
																id="weekday-picker-start-${userProduct.serialNumber}-${count2.index}-${count3.index}"
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

													<td><c:choose>
															<c:when test="${timerSetting.timerEnabled}">
																<input
																	id="timer-enabled-${userProduct.serialNumber}-${count2.index}-${count3.index}"
																	checked type="checkbox" value="">
															</c:when>
															<c:otherwise>
																<input
																	id="timer-enabled-${userProduct.serialNumber}-${count2.index}-${count3.index}"
																	type="checkbox" value="">
															</c:otherwise>
														</c:choose></td>
												</tr>

												<tr>
													<td class="col_1"></td>
													<td class="col_2"></td>
													<td class="col_3"></td>

													<td>
														<div class="input-group clockpicker">
															<input
																id="end-timer-${userProduct.serialNumber}-${count2.index}-${count3.index}"
																type="text" class="form-control"
																value="${timerSetting.endTimer}"> <span
																class="input-group-addon"> <span
																class="glyphicon glyphicon-time"></span>
															</span>
														</div>
													</td>

													<td><div class="dropup">
															<select
																id="weekday-picker-end-${userProduct.serialNumber}-${count2.index}-${count3.index}"
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

													<td><c:if
															test="${lastItem == count3.count && relaysetting.timerSettings.size() > 1}">
															<button
																id="remove-setting-button-${userProduct.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}-${timerSetting.timerId}"
																onClick="deleteTimerSetting('${userProduct.serialNumber}','${relaysetting.moduleId}','${relaysetting.relayId}','${timerSetting.timerId}');"
																type="button" class="btn-danger btn btn-sm">${localization['delete']}</button>
														</c:if></td>
												</tr>
											</tbody>
										</table>
										<c:if test="${lastItem == count3.count}">
											<div style="text-align: right;">
												<button
													id="add-setting-button-${userProduct.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
													onClick="addTimerSetting('${userProduct.serialNumber}','${relaysetting.moduleId}','${relaysetting.relayId}');"
													type="button" class="btn-primary btn btn-sm">${localization['add-timer']}</button>
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
								<button id="save-switch-${userProduct.serialNumber}"
									onClick="updateProductSettings('${userProduct.serialNumber}','${count.index}');"
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
			</div>
		</section>
	</c:if>
</c:forEach>