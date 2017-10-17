<!--
	描述:用户组移入用户
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.25
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="java.util.List"%>
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

		BLUserx blUserx = new BLUserx(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

		UserxSchema userxSchema = null;
		UserGroupSchema userGroupSchema = null;
		Userx2UserGroupSchema userx2UserGroupSchema = null;

		String whereClause = "Namex = '公司创始人'";
		List list = blUserGroup.select(whereClause);
		for(Object obj : list)
		{
			userGroupSchema = (UserGroupSchema)obj;
		}

		whereClause = "UserGroupID = " + userGroupID + " OR UserGroupID = " + userGroupSchema.ID;

		List list1 = blUserx2UserGroup.select(whereClause);

		StringBuilder str = new StringBuilder();
		str = str.append("(");
		if(!list1.isEmpty())
		{
			for(int i=0;i<list1.size()-1;i++)
			{
				userx2UserGroupSchema = (Userx2UserGroupSchema)list1.get(i);
				str = str.append(userx2UserGroupSchema.UserxID+",");
			}
			userx2UserGroupSchema = (Userx2UserGroupSchema)list1.get(list1.size()-1);
			str = str.append(userx2UserGroupSchema.UserxID);
			str = str.append(")");

			whereClause = "CompanyID = " + companyID + " AND ID NOT in"+str;
		}
		else
			whereClause = "1 != 1";

		int count = blUserx.getCount(whereClause);
		
		List result = blUserx.select(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户组-移入</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
		<%
			if(count==0)
			{
		%>
				alert("没有可供移入对象,请添加用户");
				window.history.go(-1);
		<%
			}
		%>
		</script>
	</head>
	<body>
		<form name="form" method="post" action="userGroupToCreateResult.jsp?ugID=<%=userGroupID%>&cID=<%=companyID%>">
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
										<h2>用户组移入用户</h2>
									</header>
									<!-- Break -->
                                    <div class="row uniform">
                                        <!-- Break -->
                                        <div class="12u$">
                                            <label for="user">请选择要移入的用户</label>
                                        </div>
                                        <%
                                        	for(int i=0;i<result.size();i++)
                                        	{
                                        		userxSchema = (UserxSchema)result.get(i);
                                        %>
	                                        <div class="4u 6u$(xsmall)">
	                                            <input type="checkbox" id="user-<%=i%>" name="user" value="<%=userxSchema.ID%>">
	                                            <label for="user-<%=i%>"><%=userxSchema.Namex%></label>
	                                        </div>
	                                    <%
	                                    	}
	                                    %>
                                                                          
                                        <!-- Break -->
                                        <div class="12u$">
                                            <ul class="actions">
                                                <li><input type="submit" value="提交" class="special" /></li>
                                                <li><input type="reset" value="重置" /></li>
                                            </ul>
                                        </div>
                                        <!-- Break -->
                                    </div>
   
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