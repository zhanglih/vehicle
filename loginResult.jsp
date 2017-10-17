 <!--
	描述:接收登陆页面返回的信息并做出响应，如果用户存在并且用户名与密码均正确则允许登录，否则登录失败。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	//接收login.jsp传递的参数
	String user = request.getParameter("userx");
	String password = request.getParameter("passwordx");
	
	boolean flag = false;
	//判断用户的角色，root用户，非root用户
	if("root".equals(user))
		flag = true;
	
	BLUserx blUserx = new BLUserx(con);
	BLCompany blCompany = new BLCompany(con);
	BLLogx blLogx = new BLLogx(con);

	UserxSchema userxSchema = null;
	CompanySchema companySchema = null;
	
	String whereClause = "Userx='"+user+"' and Passwordx='"+password+"'";

	//根据查询条件查询用户并返回一个集合
	List list = blUserx.select(whereClause);
	//集合不为空，数据库中存在该用户
	if(!list.isEmpty())
	{
		for(Object obj : list)
		{
			userxSchema = (UserxSchema)obj;

			LogxSchema logxSchema = new LogxSchema();
			logxSchema.CompanyID = userxSchema.CompanyID;
			logxSchema.UserxID = userxSchema.ID;
			logxSchema.LoggedTime = MiscTool.getNow();
			logxSchema.Memo = "登录";

			if(flag==false)
			{
				int isEnabled = userxSchema.IsEnabled;
				companySchema = blCompany.getSchema(userxSchema.CompanyID);
				int companyIsEnabled = companySchema.IsEnabled ;
				//判断该用户是否启用，已启用则可以访问，禁止则禁止访问
				if(companyIsEnabled == 0)
				{
%>
					<script>
						alert("该公司已被禁止访问");
						window.history.go(-1);
					</script>
<%
				}
				else if(isEnabled==0)
				{
%>
					<script type="text/javascript">
						alert("该用户已被禁止访问");
						window.history.go(-1);
					</script>
<%
				}
				else
				{
%>
					<script>
						alert("登录成功!");
						window.location.href="index.jsp";
					</script>
<%
					logxSchema.Operation = "登录成功";
				}
			}
			else
			{
%>
				<script>
					alert("登录成功!");
					window.location.href="index.jsp";
				</script>
<%
				logxSchema.Operation = "登录成功";
			}
			blLogx.insert(logxSchema);	
			//将用户ID存储在session中	
			session.setAttribute("ID",userxSchema.ID);
			session.setAttribute("Passwordx",userxSchema.Passwordx);
			//设置session超时时间
			session.setMaxInactiveInterval(30*60);
		}
	}
	//集合为空，数据库中不存在该用户
	else
	{
		//该用户不是root用户则显示用户名或密码错误
		if(flag==false)
		{
%>
			<script>
				alert("用户名或密码错误");
				window.history.go(-1);
			</script>
<%
		}
		//该用户为root用户，先判断数据库中是否存在用户名为root的用户，若不存在则自动创建用户名与密码均为root的root用户，若存在则显示用户名或密码错误
		else
		{
			whereClause = "Userx = '"+user+"'";
			List result = blUserx.select(whereClause);
			if(result.isEmpty())
			{
				UserxSchema rootUser = new UserxSchema();
				rootUser.CompanyID = 0;
				rootUser.Userx="root";
				rootUser.Passwordx="root";
				rootUser.Namex="root";
				rootUser.Mobile="13247191605";
				rootUser.IsEnabled=1;
				rootUser.Memo="root";
				boolean flag2 = blUserx.insert(rootUser);
				if(flag2)
				{
%>
					<script>
						window.location.href="loginResult.jsp?userx=<%=user%>&passwordx=<%=password%>";
					</script>
<%
				}
				else
				{
%>
					<script>
						alert("账号或密码错误，请重新登陆!");
						window.history.go(-1);
					</script>
<%
				}
			}
			else
			{
%>
				<script>
					alert("账号或密码错误，请重新登陆!");
					window.history.go(-1);
				</script>
<%
			}
		}
	}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户登录</title>
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
										<h2>登录</h2>
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