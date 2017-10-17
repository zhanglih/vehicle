<!--
	描述:从用户组内移出用户
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.25
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
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
		int companyID = Integer.parseInt(request.getParameter("cID"));
		int userGroupID = Integer.parseInt(request.getParameter("ugID"));

		BLUserx blUserx = new BLUserx(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);
		BLLogx blLogx = new BLLogx(con);

		Userx2UserGroupSchema userx2UserGroupSchema = null;
		UserGroupSchema userGroupSchema = null;

        int userID = (Integer)session.getAttribute("ID");
        UserxSchema userxSchema = blUserx.getSchema(userID);

		LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userxSchema.CompanyID;
        logxSchema.UserxID = userxSchema.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "用户组移出用户";

		String whereClause = "UserxID = " + ID + " AND UserGroupID = " + userGroupID;
		boolean flag = blUserx2UserGroup.delete(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>删除用户</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="userGroupInto.jsp";
		<%
				logxSchema.Operation = "用户组移出用户成功";
			}
			else
			{
		%>
				alert("移出失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "用户组移出用户失败";
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
		                            <h2>移出用户</h2>
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