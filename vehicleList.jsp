<!--
    描述:车辆管理
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
 		response.sendRedirect("login.jsp");
 	else
 	{
 		//可变数组
 		String[] status={"正常","转让","停用","报废"};
 		String[] useTypes={"商用","其他"};
 		String[] oilTypes={"汽油","柴油","油电混合","电动"};

 		BLUserx blUserx=new BLUserx(con);
 		int sessionID=(Integer)session.getAttribute("ID");
 		UserxSchema userxSchema=blUserx.getSchema(sessionID);
 		
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

		if("root".equals(userxSchema.Namex))
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
		//获得CompanyID
		String companyid=request.getParameter("companyID");
 		int companyID=Integer.parseInt(companyid);
		whereClause="CompanyID="+companyID;

		//条件查询
		String keyword=request.getParameter("keyword");//关键字
		String statusx=request.getParameter("statusx");
		String useType=request.getParameter("useType");
		int keysel_flag=0;	//控制分页
		if(keyword!=null && !"".equals(keyword))
		{	
			keysel_flag++;
			keyword=MiscTool.getUTF8FromISO(keyword);
			whereClause=whereClause+" AND ( PlateNumber like '~"+keyword.trim()+"~' OR Brand like '~"+keyword.trim()+"~' OR Model like '~"+keyword.trim()+"~' OR OwnerName like '~"+keyword.trim()+"~' )";	
		}
		if(statusx!=null && !"".equals(statusx))
		{
			keysel_flag++;
			whereClause="Statusx="+statusx+" AND "+whereClause;
		}
		if(useType!=null && !"".equals(useType))
		{
			keysel_flag++;
			whereClause="UseType="+useType+" AND "+whereClause;
		}
		
		BLVehicle blVehicle=new BLVehicle(con);
		//分页查询
		int number = 10;
		int currentPageNo = 1;
		String currentPageNoStr = request.getParameter("currentPageNo");
		if(currentPageNoStr!=null)
			currentPageNo = new Integer(currentPageNoStr).intValue();
		int start = 0;
		int end = 0;
		String startStr = request.getParameter("start");
		if(startStr!=null)
			start = new Integer(startStr).intValue();
		String endStr = request.getParameter("end");
		if(endStr!=null)
			end = new Integer(endStr).intValue();
		else
			end = number;
		int count = blVehicle.getCount(whereClause);
		if(number>count)
			number = count;

		List result=blVehicle.select(whereClause+" ORDER BY ID",start+1,number);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>车辆管理</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
			function deleteVehicle(id)
			{
				var doubleDecision=confirm("确定删除吗，删除数据不能恢复？");
				if(doubleDecision)
				{
					window.location.href="deleteVehicle.jsp?id="+id;	
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
										<h2>车辆管理</h2>
									</header>
										<form method="post" action="vehicleList.jsp" onsubmit="" name="form" style="margin-bottom:0">
											<div class="row uniform">
												<input type="hidden" name="companyID" value="<%=companyID%>">
												<div class="3u 12u$(xsmall)">
													<input type="text" name="keyword" placeholder="关键字" value='<%=keyword==null?"":keyword%>'/>
												</div>
												<div class="2u 12u$(xsmall) select-wrapper">
													<select name="statusx" id="statusx">
														<option value="">状态</option>
														<%
															if(statusx!=null && !"".equals(statusx))
															{
																for(int i=1;i<=status.length;i++)
																{
																	if(i==Integer.parseInt(statusx))
																	{
																		out.println("<option selected value='"+i+"'>"+status[i-1]+"</option>");
																		continue;
																	}
																	out.println("<option value='"+i+"'>"+status[i-1]+"</option>");
																}
															}
															else
															{
																for(int i=1;i<=status.length;i++)
																{
																	out.println("<option value='"+i+"'>"+status[i-1]+"</option>");
																}
															}
														%>
													</select>
												</div>
												<div class="2u 12u$(xsmall) select-wrapper">
													<select name="useType" id="useType">
														<option value="">使用性质</option>
														<%
															if(useType!=null && !"".equals(useType))
															{
																for(int i=1;i<=useTypes.length;i++)
																{
																	if(i==Integer.parseInt(useType))
																	{
																		out.println("<option selected value='"+i+"'>"+useTypes[i-1]+"</option>");
																		continue;
																	}
																	out.println("<option value='"+i+"'>"+useTypes[i-1]+"</option>");
																}
															}
															else
															{
																for(int i=1;i<=useTypes.length;i++)
																{
																	out.println("<option value='"+i+"'>"+useTypes[i-1]+"</option>");
																}
															}
														%>
													</select>
												</div>
												<div>
													<ul class="actions">
														<li><input type="submit" value="查询" class="special"/></li>
														<li><input type="button" value="新增" onclick="window.location.href='createVehicle.jsp?companyID=<%=companyID%>'" style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/></li>
														<li><input type="button" value="返回" onclick="window.location.href='vehicle.jsp'"/></li>
													</ul>
												</div>
											</div>
										</form>
										</br>
										<div class="table-wrapper">
                                    		<table class="alt">
												<tbody style="text-align:center">
		                                            <tr align="center" valign="middle">
		                                                <td><b>启用</b></td>                                                
		                                                <td><b>车牌号</b></td>
		                                                <!-- <td><b>VIN</b></td> -->
		                                                <td><b>品牌</b></td>
		                                                <td><b>型号</b></td>
		                                                <!-- <td><b>发动机型号</b></td> -->
		                                                <td><b>购买日期</b></td>
		                                                <!-- <td><b>初始里程</b></td> -->
		                                                <!-- <td><b>使用性质</b></td> -->
		                                                <!-- <td><b>状态</b></td> -->
		                                                <td><b>车主</b></td>
		                                                <td><b>车主电话</b></td>
		                                                <!-- <td><b>备注</b></td> -->
		                                                <td><b>查看</b></td>
		                                                <td><b>操作</b></td>
		                                    		</tr>
		                                    	<%
		                                    		if(!result.isEmpty())
		                                    		{
		                                    			VehicleSchema vehicleSchema=new VehicleSchema();
			                                    		for(Object obj:result)
			                                    		{
		                                    				vehicleSchema=(VehicleSchema)obj;
		                                    			%>
		                                    			<tr align="center" valign="middle">
		                                    				<td><%=vehicleSchema.IsEnabled==1?"<img src='img/1.png'>":"<img src='img/5.png'>"%></td>
		                                    				<td><a href="vehicleDetails.jsp?id=<%=vehicleSchema.ID%>"><%=vehicleSchema.PlateNumber%></a></td>
		                                    				<!-- <td><%=vehicleSchema.VIN%></td> -->
		                                    				<td><%=vehicleSchema.Brand%></td>
		                                    				<td><%=vehicleSchema.Model%></td>
		                                    				<!-- <td><%=vehicleSchema.EngineType%></td> -->
		                                    				<td><%=vehicleSchema.PurchasedDate%></td>
		                                    				<!-- <td><%=vehicleSchema.InitialMileage%></td> -->
		                                    				<!-- <td><%=vehicleSchema.UseType%></td> -->
		                                    				<!-- <td><%=vehicleSchema.Statusx%></td> -->
		                                    				<td><%=vehicleSchema.OwnerName%></td>
		                                    				<td><%=vehicleSchema.OwnerTel%></td>
		                                    				<!-- <td><%=vehicleSchema.Memo%></td> -->
		                                    				<td>
                                                    			<a href="mapToGPS.jsp?id=<%=vehicleSchema.VIN%>">定位</a>
                                                    			|
                                                    			<a href="mapToOrbit.jsp?id=<%=vehicleSchema.VIN%>">轨迹</a>
		                                    				</td>
		                                    				<td>
		                                    					<a href="updateVehicle.jsp?id=<%=vehicleSchema.ID%>" style="<%=suserRoot||supdateFlag?"display:static":"display:none"%>">修改</a>
		                                    					<span style="<%=suserRoot==false&&supdateFlag==false?"display:static":"display:none"%>">_ _</span>
		                                    					&nbsp;
                                                				|
                                                				&nbsp;
                                                    			<a href="javascript:deleteVehicle(<%=vehicleSchema.ID%>)" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">删除</a>
                                                    			<span style="<%=suserRoot==false&&sdeleteFlag==false?"display:static":"display:none"%>">_ _</span>
		                                    				</td>
		                                    			</tr>
		                                    			<%
		                                    			}
		                                    		}
                                             	%>
                                        		</tbody>
												<tfoot>
													<tr>
														<td height="100" colspan="9" align="center">
														<%
															//分页查询有改动，多加了一个参数
			                                             	if(keysel_flag==0)
			                                                {
			                                             		
	                                                        	if(number != 0)
	                                                       		{
	                                                           		int totalPages = count/number;
	                                                           		if(count%number>0)
	                                                                totalPages++;
	                                                            	for(int i=1;i<=totalPages;i++)
	                                                            	{
	                                                                	int startNumber = (i-1)*number;
	                                                                	int endNumber = i*number;
	                                                                	if(i==totalPages&&count%number>0)
	                                                                    endNumber = (i-1)*number + count%number;
	                                                                	if(currentPageNo != i)
	                                                                    	out.println("&nbsp;<a href='vehicleList.jsp?companyID="+companyID+"&currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"'>"+i+"</a>");
	                                                                	else
	                                                                    	out.println("&nbsp;<B>"+i+"</B>");
	                                                             	}
	                                                           	}
			                                     			}
		                              					%>  
                              							</td>
                              						</tr> 
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
