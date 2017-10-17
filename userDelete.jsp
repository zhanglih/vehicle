<!--
	描述:删除用户列表
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
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
		BLUserx blUserx = new BLUserx(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);
		BLLogx blLogx = new BLLogx(con);

		Userx2UserGroupSchema userx2UserGroupSchema = null;
		UserGroupSchema userGroupSchema = null;

		boolean flag = false;
		boolean flag1 = false;

        int userID = (Integer)session.getAttribute("ID");
        UserxSchema userxSchema = blUserx.getSchema(userID);

		LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userxSchema.CompanyID;
        logxSchema.UserxID = userxSchema.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "删除用户信息";

		String whereClause = "UserxID = " + ID;
		List list1 = blUserx2UserGroup.select(whereClause);
		if(!list1.isEmpty())
		{
			for(Object obj1 : list1)
			{
				userx2UserGroupSchema = (Userx2UserGroupSchema)obj1;
				userGroupSchema = blUserGroup.getSchema(userx2UserGroupSchema.UserGroupID);
				if("公司创始人".equals(userGroupSchema.Namex))
				{
					flag = true;
				}
			}
		}
		if(flag==false)
		{
			flag1 = blUserx.delete(ID);
			blUserx2UserGroup.delete(whereClause);
		}
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
				alert("公司创始人不能被删除");
				window.history.go(-1);
		<%
			}
			else
			{
				if(flag1)
				{
		%>
					window.location.href="user.jsp";
		<%
					logxSchema.Operation = "删除用户信息成功";
				}
				else
				{
		%>
					alert("删除失败");
					window.history.go(-1);
		<%
					logxSchema.Operation = "删除用户信息失败";
				}
				blLogx.insert(logxSchema);
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
		                            <h2>删除用户</h2>
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