<!--
	描述:激活公司页面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	String email = request.getParameter("email");

	BLCompany blCompany= new BLCompany(con);
	BLLogx blLogx = new BLLogx(con);
	BLUserx blUserx = new BLUserx(con);
	
	CompanySchema companySchema = null;
	UserxSchema userxSchema = null;

	String whereClause = "Email = '" + email + "'";
	List list = blCompany.select(whereClause);
	whereClause = "Userx = '" + email + "'";
	List listUserx = blUserx.select(whereClause);
	for(Object objU : listUserx)
	{
		userxSchema = (UserxSchema)objU;
	}

	for(Object obj : list)
	{
		companySchema = (CompanySchema)obj;
	}
	companySchema.IsEnabled = 1;
	boolean flag = blCompany.update(companySchema);

	LogxSchema logxSchema = new LogxSchema();
	logxSchema.CompanyID = companySchema.ID;
	logxSchema.UserxID = userxSchema.ID;
	logxSchema.LoggedTime = MiscTool.getNow();
	logxSchema.Memo = "激活公司";
	if(flag)
	{
%>
		<script>
			alert("激活成功，请重新登录!");
			window.location.href="login.jsp";
		</script>
<%
		logxSchema.Operation = "公司激活成功";
	}
	else
	{
%>
		<script>
			alert("激活失败，请重新激活!");
			window.history.go(-1);
		</script>
<%
		logxSchema.Operation = "公司激活失败";
	}
	blLogx.insert(logxSchema);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>激活公司</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
        
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
			                            <h2>激活公司</h2>
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
<%@ include file="closeCon.jspf"%>