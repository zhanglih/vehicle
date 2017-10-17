<!--
	描述：接收修改密码参数并作出黎，失败返回上一层，成功跳转到登陆页面
    作者：杜乘风
    手机：13247191605
    微信：13247191605
    日期：2017-07-17
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("index.jsp");
	}
	else
	{
		//接收参数newPassword作为用户修改的passwordx
		int id=(Integer)(session.getAttribute("ID"));
		String passwordx=request.getParameter("newPassword");
		
		BLUserx blUserx=new BLUserx(con);
		UserxSchema userxSchema=blUserx.getSchema(id);
		userxSchema.Passwordx=passwordx;
		boolean flag=blUserx.update(userxSchema);

		BLLogx blLogx = new BLLogx(con);
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "修改密码";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户-密码修改</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
		<%
			if(flag)
			{
				session.invalidate();
		%>
				alert("修改成功，请重重新登陆。");
				window.location.href="index.jsp";
		<%
				logxSchema.Operation = "修改密码成功";
			}
			else
			{
		%>
				alert("修改失败，返回上一层。");
				window.history.go(-1);
		<%
				logxSchema.Operation = "修改密码失败";
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
                            <h2>修改密码</h2>
                        </header>
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