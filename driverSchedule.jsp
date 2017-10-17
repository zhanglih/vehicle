<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverScheduleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="java.util.List"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
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

	    BLCompany blCompany=new BLCompany(con);
        BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

        UserGroupSchema userGroupSchema = null;
        Userx2UserGroupSchema userx2UserGroupSchema = null;

        String spermissionStr = "";
		String permissionx = "";
		boolean screateFlag = false;
        boolean sdeleteFlag = false;
        boolean supdateFlag = false;
        boolean suserRoot = false;
		String whereClause = "1=1";

		if("root".equals(userxSchema.Userx))
			suserRoot = true;
		else
		{
			whereClause = "UserxID = " + userxSchema.ID ;
			List listUserx2UserGroup = blUserx2UserGroup.select(whereClause);
			if(!listUserx2UserGroup.isEmpty())
			{
				for(Object sobj1 : listUserx2UserGroup)
				{
					userx2UserGroupSchema = (Userx2UserGroupSchema)sobj1;
					userGroupSchema = blUserGroup.getSchema(userx2UserGroupSchema.UserGroupID);
					spermissionStr = userGroupSchema.Permissionx;
					String[] spermission = spermissionStr.split(" ");
					if(spermission.length>0)
					{
						for(int i=0;i<spermission.length;i++)
						{
							if("create".equals(spermission[i]))
								screateFlag = true;
							if("delete".equals(spermission[i]))
								sdeleteFlag = true;
							if("update".equals(spermission[i]))
								supdateFlag = true;
						}
					}
				}
			}
		}

	    //查询语句
		whereClause="CompanyID="+companyID;
		//root can see all
		if(companyID==0)
			whereClause="1=1";

		//驾驶员集合
		BLDriver blDriver=new BLDriver(con);
		List driverResult=blDriver.select(whereClause);

		//车辆集合
		BLVehicle blVehicle=new BLVehicle(con);
		List vehicleResult=blVehicle.select(whereClause);

		//条件查询
		String driverID=request.getParameter("driver");
		String vehicleID=request.getParameter("plateNumber");
		String startTime=request.getParameter("startTime");
		String endTime=request.getParameter("endTime");
		if(driverID!=null && !"".equals(driverID))
		{
			whereClause="DriverxID="+driverID+" AND "+whereClause;
		}
		if(vehicleID!=null && !"".equals(vehicleID))
		{
			whereClause="VehicleID="+vehicleID+" AND "+whereClause;
		}
		if(startTime!=null && !"".equals(startTime))
		{
			whereClause="StartTime>='"+startTime+"' AND "+whereClause;
		}
		if(endTime!=null && !"".equals(endTime))
		{
			whereClause="EndTime<='"+endTime+"' AND "+whereClause;
		}

		BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
		List result=blDriverSchedule.select(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>驾驶员排班表</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
			function deleteDriverSchedule(id)
			{
				var doubleDecision=confirm("确定删除吗，删除数据不能恢复？");
				if(doubleDecision)
				{
					window.location.href="deleteDriverSchedule.jsp?id="+id;	
				}
			}
		</script>
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
										<h2></h2>
									</header>

									<form method="post" action="driverSchedule.jsp" onsubmit="" name="form" style="margin-bottom:0">
										<div class="row uniform">
											<div class="2u 2u$(xsmall) select-wrapper">
												<select name="driver" id="driver">
													<option value="">驾驶员</option>
													<%
														if(!driverResult.isEmpty())
														{
															DriverSchema driverSchema=new DriverSchema();
															for(Object obj:driverResult)
															{
																driverSchema=(DriverSchema)obj;
																%>
																<option value="<%=driverSchema.ID%>"
																	<%
																		if(driverID!=null && driverID!="" && driverSchema.ID==Integer.parseInt(driverID))
																			out.print("selected");
																	%>
																><%=driverSchema.Namex%></option>
																<%
															}
														}
													%>
												</select>
											</div>
											<div class="2u 2u$(xsmall) select-wrapper">
												<select name="plateNumber" id="plateNumber">
											   		<option value="">车牌号</option>
											   		<%
											   			if(!vehicleResult.isEmpty())
											   			{
											   				for(Object obj:vehicleResult)
											   				{
											   					VehicleSchema vehicleSchema=(VehicleSchema)obj;
											   					%>
											   					<option value="<%=vehicleSchema.ID%>"
											   						<%
																		if(vehicleID!=null && vehicleID!="" && vehicleSchema.ID==Integer.parseInt(vehicleID))
																			out.print("selected");
																	%>
											   					><%=vehicleSchema.PlateNumber%></option>
											   					<%
											   				}
											   			}
											   		%>
												</select>
											</div>
											<div class="2u 2u$(xsmall)">
												<input type="text" name="startTime" placeholder="开始日期" id="startTime" onClick="var startTime=$dp.$('endTime');WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',onpicked:function(){endTime.click();},maxDate:'#F{$dp.$D(\'endTime\')}'})" value='<%=startTime!=null?startTime:""%>' readOnly/>
											</div>
											<div class="2u 2u$(xsmall)">
												<input type="text" name="endTime" placeholder="结束日期" id="endTime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startTime\')}'})" value='<%=endTime!=null?endTime:""%>' readOnly/>
											</div>
											<div class="4u 2u$(xsmall)">
												<div class="12u$">
													<ul class="actions">
														<li><input type="submit" value="查询" class="special"/></li>
														<li>
															<input type="button" value="新增" onclick="window.location.href='createDriverSchedule.jsp'" style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/>
														</li>
													</ul>
												</div>
											</div>
										</div>
									</form>
									<div class="table-wrapper">
                                		<table class="alt">
											<tbody style="text-align:center">
	                                            <tr align="center" valign="middle">
	                                                <td><b>驾驶员</b></td>                                                
	                                                <td><b>车牌号</b></td>
	                                                <td><b>开始时间</b></td>
	                                                <td><b>结束时间</b></td>
	                                                <td><b>操作</b></td>
	                                    		</tr>
		                                    	<%
		                                    		if(!result.isEmpty())
		                                    		{
		                                				DriverScheduleSchema driverScheduleSchema=new DriverScheduleSchema();//排班
		                                				DriverSchema driverSchema=new DriverSchema();//驾驶员
		                                				VehicleSchema vehicleSchema=new VehicleSchema();//车辆
		                                				for(Object obj:result)
		                                				{
		                                					driverScheduleSchema=(DriverScheduleSchema)obj;
		                                					driverSchema=blDriver.getSchema(driverScheduleSchema.DriverxID);
		                                					vehicleSchema=blVehicle.getSchema(driverScheduleSchema.VehicleID);
		                                					%>
		                                					<tr align="center" valign="middle">
			                                					<td><%=driverSchema.Namex%></td>
			                                					<td><%=vehicleSchema.PlateNumber%></td>
			                                					<td><%=driverScheduleSchema.StartTime%></td>
			                                					<td><%=driverScheduleSchema.EndTime%></td>
			                                					<td>
			                                    					<a href="updateDriverSchedule.jsp?id=<%=driverScheduleSchema.ID%>" style="<%=suserRoot||supdateFlag?"display:static":"display:none"%>">修改</a>
			                                    					<span style="<%=suserRoot==false&&supdateFlag==false?"display:static":"display:none"%>">_ _</span>
		                                    						&nbsp;
	                                                				|
	                                                				&nbsp;
	                                                    			<a href="javascript:deleteDriverSchedule(<%=driverScheduleSchema.ID%>)" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">删除</a>
	                                                    			<span style="<%=suserRoot==false&&sdeleteFlag==false?"display:static":"display:none"%>">_ _</span>
			                                    				</td>
		                                					</tr>
		                                					<%
		                                				}
		                                			}
		                                		%>
		                                		</tr>
                                    		</tbody>	
											<tfoot>
											
                                            </tfoot>
                                        </table>                             
                                    </div>
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
