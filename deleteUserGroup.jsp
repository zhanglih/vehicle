<!--
	描述：删除驾驶员
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-07-20
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
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

		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

		LogxSchema logxSchema = null;

		boolean flag = false;
		String whereClause = "UserGroupID = " + id;

		int count = blUserx2UserGroup.getCount(whereClause);
		if(count==0)
		{
			flag = blUserGroup.delete(id);

			int userID = (Integer)session.getAttribute("ID");
			UserxSchema userxSchema = blUserx.getSchema(userID);
			
			logxSchema = new LogxSchema();
			logxSchema.CompanyID = userxSchema.CompanyID;
			logxSchema.UserxID = userxSchema.ID;
			logxSchema.LoggedTime = MiscTool.getNow();
			logxSchema.Memo = "删除用户组";
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
    
		<title>用户组-删除</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script type="text/javascript">
		<%
			if(count==0)
			{
				if(flag)
				{
		%>
					window.location.href="userGroupInto.jsp";
		<%
					logxSchema.Operation = "删除用户组成功";
				}
				else
				{
		%>
					alert("删除用户组失败");
					window.history.go(-1);
		<%
					logxSchema.Operation = "删除用户组失败";
				}
				blLogx.insert(logxSchema);
			}
			else
			{
		%>
				alert("该用户组内还有用户，不能被删除");
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
										<h2>删除用户组</h2>
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