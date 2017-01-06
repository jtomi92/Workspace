<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>

<section id="tab0" class="tab-content active">

	<div id="product-relay-controls">
		<c:forEach items="${userProducts}" var="ups" varStatus="count">

				<div class="panel panel-default"
					id="product-relay-control-${count.index}" style="display: none;">


					<c:choose>
						<c:when test="${ups.isConnected()}">
							<div id="${ups.serialNumber}-connection-status"
								style="text-align: center;"
								class="container-fluid alert-success">Device is ONLINE</div>
						</c:when>
						<c:otherwise>
							<div id="${ups.serialNumber}-connection-status"
								style="text-align: center;" class="container-fluid alert-danger">Device
								is OFFLINE</div>
						</c:otherwise>
					</c:choose>


					<div class="page-header" style="text-align: center;">
						<h3>Relay Controls</h3>
					</div>

					<div class="container-fluid" style="text-align: center;">
						<label>Select Relays</label>
					</div>
					<div id="product-rel-control-dropdown-${count.index}"
						style="text-align: center;" class="container-fluid">
						<select id="product-relay-control-picker-${count.index}"
							multiple="multiple"
							onchange="showProductRelayControl('product-relay-control-picker-${count.index}','rel-control-${count.index}');">
							<c:forEach
								items="${ups.productSettings.iterator().next().relaySettings}"
								var="relaysetting" varStatus="count2">
								<c:forEach items="${relaysetting.productControlSettings}"
									var="pcs">
									<c:if test="${(pcs.userId eq userid) && pcs.isAccess()}">
										<option value="relay-control-${count2.index}">${relaysetting.relayName}
											(${relaysetting.moduleId}/${relaysetting.relayId})</option>
									</c:if>
								</c:forEach>
							</c:forEach>
						</select>
					</div>
					<br>

					<div id="rel-control-${count.index}"
						class="container panel panel-default">
						<table class="table table-striped" style="margin-bottom: 10px;">
							<thead>
								<tr>
									<th>Module ID</th>
									<th>Relay ID</th>
									<th>Relay Name</th>
									<th>Status</th>
									<th>Control</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach
									items="${ups.productSettings.iterator().next().relaySettings}"
									var="relaysetting" varStatus="count">
									<c:forEach items="${relaysetting.productControlSettings}"
										var="pcs">
										<c:if test="${(pcs.userId eq userid) && pcs.isAccess()}">
											<tr id="relay-control-${count.index}" style="display: none;">
												<td>${relaysetting.moduleId}</td>
												<td>${relaysetting.relayId}</td>
												<td>${relaysetting.relayName}</td>
												<td><c:choose>
														<c:when
															test="${empty relaysetting.relayStatus || relaysetting.relayStatus eq 'N'}">
															<span
																id="relaystatus-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
																class="label label-danger">OFF</span>
														</c:when>
														<c:otherwise>
															<span
																id="relaystatus-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
																class="label label-success">ON</span>
														</c:otherwise>
													</c:choose></td>
												<td>
													<div
														id="relay-progressbar-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
														class="loader" style="display: none;" id="timex"></div>
													<button
														id="relay-switch-${ups.serialNumber}-${relaysetting.moduleId}-${relaysetting.relayId}"
														style="display: block;" type="button"
														class="btn-primary btn"
														onClick="switchRelay('${ups.serialNumber}','${relaysetting.moduleId}', '${relaysetting.relayId}');">SWITCH</button>
												</td>
											</tr>
										</c:if>
									</c:forEach>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
		</c:forEach>
	</div>
</section>