<!--
	描述:用户组移入用户
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.25
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int userGroupID = Integer.parseInt(request.getParameter("ugID"));
		int companyID = Integer.parseInt(request.getParameter("cID"));

		String[] userIDs = request.getParameterValues("user");

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

		boolean flag = false;
		Userx2UserGroupSchema userx2UserGroupSchema = new Userx2UserGroupSchema();
		for(int i=0;i<userIDs.length;i++)
		{
			userx2UserGroupSchema.UserxID = Integer.parseInt(userIDs[i]);
			userx2UserGroupSchema.UserGroupID = userGroupID;
			flag = blUserx2UserGroup.insert(userx2UserGroupSchema);
		}

		int ID = (Integer)session.getAttribute("ID");
        UserxSchema userxSchema = blUserx.getSchema(ID);

		LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userxSchema.CompanyID;
        logxSchema.UserxID = userxSchema.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "用户组移入用户";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户组-移入</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="userGroupInto.jsp";
		<%
				logxSchema.Operation = "用户组移入用户成功";
			}
			else
			{
		%>
				alert("删除失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "用户组移入用户失败";
			}
			blLogx.insert(logxSchema);
		%>
		</script>
	</head>
	<body>
		<form name="form" method="post" action="userGroupToCreateResult.jsp?ugID=<%=userGroupID%>">
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<%@ include file="header.jspf"%>

							<!-- Content -->
								<section>
                                   
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
</html>
<%
	}
%>
<%@ include file="closeCon.jspf"%>