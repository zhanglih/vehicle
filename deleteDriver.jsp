<!--
	描述：删除驾驶员
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverScheduleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		int id=Integer.parseInt(request.getParameter("id").trim());
		BLDriver blDriver=new BLDriver(con);
		
		BLDriverSchedule blDriverSchedule = new BLDriverSchedule(con);
		String whereClause="DriverxID='"+id+"'";
		List result = blDriverSchedule.select(whereClause);
		if(result.size() > 0)
		{
%>	
		<script language="javascript">
			alert("改驾驶员有对应排班信息，不允许删除");
	        window.history.go(-1);
		</script>
		
<%	
			return;
		}
		
		boolean flag=blDriver.delete(id);

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "删除驾驶员";
%>
<!DOCTYPE HTML>	
<html>
	<head>
    
		<title>驾驶员-删除</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="driver.jsp";
		<%
				logxSchema.Operation = "删除驾驶员成功";
			}
			else
			{
		%>
				alert("删除驾驶员失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "删除驾驶员失败";
			}
			blLogx.insert(logxSchema);
		%>
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
										<h2>删除驾驶员</h2>
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
</html>
<%
	}
%>
<%@ include file="closeCon.jspf"%>