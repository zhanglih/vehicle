<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverScheduleSchema"%>
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

		BLDriver blDriver=new BLDriver(con);
		List driverResult=blDriver.select("CompanyID="+companyID);

		BLVehicle blVehicle=new BLVehicle(con);
		List vehicleResult=blVehicle.select("companyID="+companyID);

		//获得DriverScheduleID
		String id=request.getParameter("id");
		BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
		DriverScheduleSchema driverScheduleSchema=blDriverSchedule.getSchema(Integer.parseInt(id));
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>更新排班</title>
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

									<form name="form" method="post" action="updateDriverScheduleResult.jsp?id=<%=id%>">
									  	<table>
									  		<!-- CompanyID -->
                                        	<input type="hidden" name="CompanyID" value="<%=companyID%>">
									   		<tr>
									      		<td><label for="driver" style="font-size:18px;">驾驶员</label></td>
									      		<td>
									      			<div class="12u$">
										      			<div class="select-wrapper">
											      			<label for="driver"></label>
											      			<select name="driver" id="driver" disabled="disabled">
											      			<%
										      					DriverSchema driverSchema=blDriver.getSchema(driverScheduleSchema.DriverxID);
										      					driverSchema=blDriver.getSchema(driverScheduleSchema.DriverxID);
							      							%>
							      								<option value="<%=driverScheduleSchema.DriverxID%>"><%=driverSchema.Namex%></option>
											      			</select>
										      			</div>
										      		</div>
									      		</td>
									      		<td><label for="plateNumber" style="font-size:18px;">车牌</label></td>
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
											      							<option value="<%=vehicleSchema.ID%>"
											      							<%
											      								if(driverScheduleSchema.VehicleID==vehicleSchema.ID)
											      									out.print("selected");
											      							%>
											      							><%=vehicleSchema.PlateNumber%></option>
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
											    	<input type="text" name="startTime" placeholder="" id="startTime" onClick="var startTime=$dp.$('endTime');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endTime.click();},maxDate:'#F{$dp.$D(\'endTime\')}'})" value='<%=driverScheduleSchema.StartTime%>' required readOnly/>
											    </td>
											    <td><label for="endTime" style="font-size:18px;">结束时间</label></td>
											    <td><label for="endTime"></label>
											    	<input type="text" name="endTime" placeholder="" id="endTime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startTime\')}'})" value="<%=driverScheduleSchema.EndTime%>" required readOnly/>
											    </td>
									    	</tr>
									  	</table>
										<!-- Break -->
										<div class="12u$">
											<ul class="actions">
												<li><input type="submit" value="提交" class="special" onClick=""/></li>
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
			
	</body>
</html>
<%
}
%>
<%@ include file="closeCon.jspf"%>