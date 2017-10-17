<!--
	描述：新建驾驶员结果处理
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	BLDriveInfo blDriveInfo = new BLDriveInfo(con);
	DriveInfoSchema driveInfoSchema = new DriveInfoSchema();
	
	driveInfoSchema.VehicleID = 333;
	driveInfoSchema.OilQuantity = 4.4;
	driveInfoSchema.Mileage = 5.3;
	driveInfoSchema.UploadedTime = "2017-06-06 13:29:53";
	
	blDriveInfo.insert(driveInfoSchema);
%>


<!DOCTYPE HTML>
<html>
	<head>
		<title>驾驶员-创建结果处理</title>
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

									<!--
									<span class="image main"><img src="images/pic11.jpg" alt="" /></span>

									<p>Donec eget ex magna. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque venenatis dolor imperdiet dolor mattis sagittis. Praesent rutrum sem diam, vitae egestas enim auctor sit amet. Pellentesque leo mauris, consectetur id ipsum sit amet, fergiat. Pellentesque in mi eu massa lacinia malesuada et a elit. Donec urna ex, lacinia in purus ac, pretium pulvinar mauris. Curabitur sapien risus, commodo eget turpis at, elementum convallis elit. Pellentesque enim turpis, hendrerit.</p>
                                    -->
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
	
<%@ include file="closeCon.jspf"%>