<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
 		response.sendRedirect("login.jsp");
 	else
 	{
 		//获得CompanyID
	 	int sessionID=(Integer)session.getAttribute("ID");
		BLUserx blUserx=new BLUserx(con);
	    UserxSchema userxSchema=blUserx.getSchema(sessionID);
	    int companyID=userxSchema.CompanyID;

	    String whereClause="CompanyID="+companyID;

		BLDriver blDriver=new BLDriver(con);
		List driverResult=blDriver.select(whereClause);

		BLVehicle blVehicle=new BLVehicle(con);
		List vehicleResult=blVehicle.select(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新增排班</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
	</head>
	<body>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<%@ include file="header.jspf"%>

							<!-- Content -->
								<section>
									<header class="main">
										<h2>新增排班</h2>
									</header>

									<form name="form" method="post" action="createDriverScheduleResult.jsp">
									  	<table>
									  		<!-- CompanyID -->
                                        	<input type="hidden" name="CompanyID" value="<%=companyID%>">
									   		<tr>
									      		<td><label for="driver" style="font-size:18px;">驾驶员</label></td>
									      		<td>
										       		<div class="12u$">
														<div class="select-wrapper">
															<label for="driver"></label><!-- 其实没什么意义，为了格式好看 -->
															<select name="driver" id="driver" required>
																<option value="">- 请选择驾驶员 -</option>
																<%
																	if(!driverResult.isEmpty())
																	{
																		for(Object obj:driverResult)
																		{
																			DriverSchema driverSchema=(DriverSchema)obj;
																			%>
																			<option value="<%=driverSchema.ID%>"><%=driverSchema.Namex%></option>
																			<%
																		}
																	}
																%>
															</select>
														</div>
													</div>
									      		</td>
									      		<td><label for="demo-category" style="font-size:18px;">车牌</label></td>
									      		<td>
										      		<div class="12u$">
										      			<div class="select-wrapper">
											      			<label for="paleteNumber"></label>
											      			<select name="plateNumber" id="plateNumber" required>
											      				<option value="">- 请选择车牌号 -</option>
											      				<%
											      					if(!vehicleResult.isEmpty())
											      					{
											      						for(Object obj:vehicleResult)
											      						{
											      							VehicleSchema vehicleSchema=(VehicleSchema)obj;
											      							%>
											      							<option value="<%=vehicleSchema.ID%>"><%=vehicleSchema.PlateNumber%></option>
											      							<%
											      						}
											      					}
											      				%>
											      			</select>
										      			</div>
										      		</div>
									      		</td>
									    	</tr>
									    	<tr>
										      	<td><label for="startTime" style="font-size:18px;">开始时间</label></td>
											    <td>
											    	<label for="startTime"></label>
											    	<input type="text" name="startTime" placeholder="请点击选择" id="startTime" onClick="var startTime=$dp.$('endTime');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endTime.click();},maxDate:'#F{$dp.$D(\'endTime\')}'})" required readOnly/>
											    </td>
											    <td><label for="endTime" style="font-size:18px;">结束时间</label></td>
											    <td><label for="endTime"></label>
											    	<input type="text" name="endTime" placeholder="请点击选择" id="endTime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startTime\')}'})"  required readOnly/>
											    </td>
									    	</tr>
									  	</table>
										<!-- Break -->
										<div class="12u$">
											<ul class="actions">
												<li><input type="submit" value="提交" class="special" onClick="return check()"/></li>
												<li><input type="reset" value="重置"/></li>
											</ul>
										</div>
									</form>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>
			<script type="text/javascript">
				function check()
				{
					var startedTime=$("#startTime").val();
					var endedTime=$("#endTime").val();
					if(startedTime=='')
					{
						alert("开始时间不能为空");
						$('#startTime').focus();
						return false;
					}
					if(endedTime=='')
					{
						alert("结束时间不能为空");
						$('endTime').focus();
						return false;
					}
				}
			</script>
	</body>
</html>
<%
}
%>
<%@ include file="closeCon.jspf"%>
