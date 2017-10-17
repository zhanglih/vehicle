<!--
	描述：新建区域页面
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-05
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		
		Integer ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		Integer CompanyID = userxSchema.CompanyID;
		String Userx = userxSchema.Userx;
		String whereClause = "";
		if("root".equals(userxSchema.Userx))
		{
			whereClause = "1=1";
		}
		else
		{
			whereClause = "1=1 AND CompanyID ="+CompanyID ;
		}
		
		BLVehicle blVehicle = new BLVehicle(con);
		List result = blVehicle.select(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>电子围栏-新建</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="JavaScript">
			function verify()
			{
				var areaName = form.areaName.value;
				
				if(areaName==null||areaName=="")
				{
					alert("请输入名称");
					return false;
				}
				var vehicle = form.vehicle.value;
				
				if(vehicle == 'n')
				{
					
					alert("请选择车牌");
					return false;
				}
			}
		</script>
	</head>
	<body onload='document.getElementById("areaName").focus();'>
		<form name="form" method="post" action="createAreaResult.jsp" onsubmit="return verify();">
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
										<h2>新建电子围栏</h2>
									</header>
									<!-- Break -->
                                    <div class="row uniform">
                                    	<div class="12u$"><label for="namex">名称</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="areaName" id="areaName" value=""  maxlength="30"/>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
                                        <!-- Break -->
                                        <!-- Break -->
                                        <div class="12u$"><label for="namex">车牌</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <select name="vehicle" id="vehicle">
												<option value="n">请选择</option>
												<%
													for(Object obj:result)
													{
														VehicleSchema vehicleSchema = (VehicleSchema)obj;
												%>
													<option value="<%=vehicleSchema.ID%>"><%=vehicleSchema.PlateNumber%></option>
                                                <%												
													}
												%>
											</select>
                                        </div>
										 <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
									
                                        <div class="12u$">
                                            <ul class="actions">
                                                <li><input type="submit" value="选择区域" class="special" /></li>
                                                <li><input type="reset" value="重置" /></li>
                                            </ul>
                                        </div>
                                    </div>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>
		 </form>
	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>