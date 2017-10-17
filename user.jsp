<!--
	描述:用户模块用户权限判断
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		int ID = (Integer)session.getAttribute("ID");
		String whereClause = "1=1";

		boolean userRoot = false;
		boolean userParent = false;
		boolean userChild = false;
		boolean userParentCompany = false;
		boolean userChildCompany = false;
		boolean userParentCommon = false;
		boolean userChildCommon = false;

		BLUserx blUserx = new BLUserx(con);
		BLCompany blCompany = new BLCompany(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

		UserxSchema userxSchema = blUserx.getSchema(ID);;
		UserxSchema userxAdmin = null;
		CompanySchema companySchema = null;
		UserGroupSchema userGroupSchema = null;
		Userx2UserGroupSchema userx2UserGroupSchema = null;

		if(userxSchema.CompanyID==0)
		{
			userRoot = true;
	    }
	    else
	    {
			companySchema = blCompany.getSchema(userxSchema.CompanyID);
			String name = "公司创始人";
			whereClause = "Namex = '" + name + "' AND CompanyID = " + companySchema.ID;
			List result = blUserGroup.select(whereClause);
			if(!result.isEmpty())
			{
				for(Object obj : result)
				{
					userGroupSchema = (UserGroupSchema)obj;
					whereClause = "UserGroupID = " + userGroupSchema.ID;
					List list2 = blUserx2UserGroup.select(whereClause);
					//out.println(list2.size());
					if(!list2.isEmpty())
					{
						for(Object obj2 : list2)
						{
							userx2UserGroupSchema = (Userx2UserGroupSchema)obj2;
//							userxAdmin = blUserx.getSchema(userx2UserGroupSchema.UserxID);

							if(companySchema.ParentID==0)
							{
								/*
								if(ID == userxAdmin.ID)
								{
									userParentCompany = true;
								}
								else
								{
									userParentCommon = true;
								}
								*/
								userParent = true;
							}
							else
							{
								/*
								if(ID == userxAdmin.ID)
								{
									userChildCompany = true;
								}
								else
								{
									userChildCommon = true;
								}
								*/
								userChild = true;
							}
						}
					}				
				}
			}
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户权限判断</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
		<%
			if(userRoot)
			{
		%>
				window.location.href = "userRoot.jsp";
		<%
			}
			if(userParent)
			{
		%>
				window.location.href = "userCompany.jsp";
		<%
			}
			if(userChild)
			{
		%>
				window.location.href = "userCompany.jsp";
		<%
			}
		%>
		</script>
	</head>
	<body onLoad="JavaScript:form.userx.focus()">
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
										<h2>用户模块权限判断界面</h2>
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