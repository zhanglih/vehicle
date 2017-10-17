<!--
	描述：删除电子围栏信息
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<!DOCTYPE HTML>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		int id=Integer.parseInt(request.getParameter("id").trim());
		BLArea blArea=new BLArea(con);
		String whereClause="ID='"+id+"'";
		boolean flag=blArea.delete(id);

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "删除电子围栏";
%>	
<html>
	<head>
    
		<title>电子围栏-删除</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script type="text/javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="area.jsp";
		<%
				logxSchema.Operation = "删除电子围栏成功";
			}
			else
			{
		%>
				alert("删除电子围栏失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "删除电子围栏失败";
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
										<h2>删除电子围栏</h2>
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