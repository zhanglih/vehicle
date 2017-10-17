<!--
	描述:子公司用户登录显示公司详细信息界面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		int ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		BLCompany blCompany = new BLCompany(con);

		UserxSchema userxSchema = blUserx.getSchema(ID);

		CompanySchema companySchema = blCompany.getSchema(userxSchema.CompanyID);

		CompanySchema companyParent = blCompany.getSchema(companySchema.ParentID);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>公司详细信息</title>
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
									<h2>公司详细信息</h2>
								</header>
									
								<table class="alt">
									<tbody align="center">
                                        <tr>
											<td>公司名称</td>
											<td><%=companySchema.Namex%></td>
										</tr>
										<tr>
											<td>父公司名称</td>
											<td><%=companyParent.Namex%></td>
										</tr>
										<tr>
											<td>联系人</td>
											<td><%=companySchema.ContactPerson%></td>
										</tr>
										<tr>
											<td>电话</td>
											<td><%=companySchema.Tel%></td>
										</tr>
										<tr>
											<td>手机</td>
											<td><%=companySchema.Mobile%></td>
										</tr>
										<tr>
											<td>电子邮箱</td>
											<td><%=companySchema.Email%></td>
										</tr>
										<tr>
											<td>地址</td>
											<td><%=companySchema.Address%></td>
										</tr>
										<tr>
											<td>邮政编码</td>
											<td><%=companySchema.Postcode%></td>
										</tr>
										<tr>
											<td>网站</td>
											<td><%=companySchema.Website%></td>
										</tr>
										<tr>
											<td>注册时间</td>
											<td><%=companySchema.RegisteredTime%></td>
										</tr>
										<tr>
											<td>备注</td>
											<td><%=companySchema.Memo%></td>
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