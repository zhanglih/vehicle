<!--
	描述:删除系统日志数据
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.17
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID = Integer.parseInt(request.getParameter("id"));
		BLLogx blLogx = new BLLogx(con);
		boolean flag = blLogx.delete(ID);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>删除系统日志</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
			<%
				if(flag)
				{
			%>
					window.location.href="systemLog.jsp?";
			<%
				}
				else
				{
			%>
					alert("删除失败");
					window.history.go(-1);
			<%
				}
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
										<h2>删除系统日志</h2>
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