<!--
	描述:普通用户登录显示界面
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
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		String id = request.getParameter("id");
		int ID = Integer.parseInt(id);

		BLUserx blUserx = new BLUserx(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

        Userx2UserGroupSchema userx2UserGroupSchema = null;
        UserGroupSchema userGroupSchema = null;

		UserxSchema userxSchema = blUserx.getSchema(ID);
		String whereClause = "UserxID = " + userxSchema.ID;
		List list2 = blUserx2UserGroup.select(whereClause);
		for(Object obj2 : list2)
		{
			userx2UserGroupSchema = (Userx2UserGroupSchema)obj2;
			userGroupSchema = blUserGroup.getSchema(userx2UserGroupSchema.UserGroupID);
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户展示界面</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
	</head>
	<body>
		<form name="form" type="post" action="">
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
									<h2>用户详细信息</h2>
								</header>

								<table class="alt">
									<tbody align="center">
                                        <tr>
											<td>用户组</td>
											<td><%=userGroupSchema.Namex%></td>
										</tr>
                                        <tr>
											<td>用户名</td>
											<td><%=userxSchema.Userx%></td>
										</tr>
										<tr>
											<td>姓名</td>
											<td><%=userxSchema.Namex%></td>
										</tr>
										<tr>
											<td>电话</td>
											<td><%=userxSchema.Mobile%></td>
										</tr>
										<tr>
											<td>备注</td>
											<td><%=userxSchema.Memo%></td>
										</tr>
									</tbody>                                    
								</table>
                                
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