<!--
	描述：区域信息保存
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-12
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
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

		String radius = request.getParameter("radius");
		String lng = request.getParameter("lng");
		String la = request.getParameter("la");
		String areaName = request.getParameter("areaName");
		String vehicleID = request.getParameter("vehicleID");
		String arry = request.getParameter("arry");
		AreaSchema areaSchema = new AreaSchema();

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		
		UserxSchema userxSchema = blUserx.getSchema(ID);

		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "新建电子围栏";
		
		areaSchema.VehicleID = Integer.valueOf(vehicleID);
		areaSchema.Namex = MiscTool.getUTF8FromISO(areaName);
		if(lng == null)
		{
			areaSchema.Locationx = arry;
		}
		else
		{
			areaSchema.Locationx = radius;
			areaSchema.LongitudDev = lng;
			areaSchema.LateralDev = la;
		}
		BLArea blArea = new BLArea(con);
		boolean flag = blArea.insert(areaSchema);
		if(flag)
		{
%>
		<script language="javascript">
			window.location.href="area.jsp";
		</script>
<%		
			logxSchema.Operation = "新建电子围栏成功";
		}
		else
		{
%>
		<script language="javascript">
			window.history.go(-1);
		</script>
<%
			logxSchema.Operation = "新建电子围栏失败";
		}
		blLogx.insert(logxSchema);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>区域信息保存</title>
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
										<h1>模板</h1>
									</header>

									
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>