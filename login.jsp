<!--
	描述:登陆页面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ include file="openCon.jspf"%>
<%
	session.invalidate();
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>登录</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
			function verify()
			{
				var userx = form.userx.value;
				var passwordx = form.passwordx.value;
				if(userx=="")
				{
					alert("用户名不能为空");
					form.userx.focus();
					return false;
				}
				if(passwordx=="")
				{
					alert("密码不能为空");
					form.passwordx.focus();
					return false;
				}
				return true;
			}
		</script>
	</head>
	<body onLoad="JavaScript:form.userx.focus()">
		<form name="form" method="post" action="loginResult.jsp" onSubmit="return verify()">
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
									<div class="row uniform">
										<div class="6u 12u$(xsmall)" style="float:none">
											<input type="text" name="userx" value=
                                            "" placeholder="用户名" />
										</div>
										<div class="6u 12u$(xsmall)" style="float:none">
											<input type="password" name="passwordx" value="" placeholder="密码"/>
										</div>
										<!-- Break -->
										<div class="12u$">
											<ul class="actions">
												<li><input type="submit" value="登录" class="special"/></li>
												<li>
													<input type="button" value="注册" class="special" onclick="JavaScript:window.location.href='companyCreate.jsp'">
												</li>
											</ul>
										</div>
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
<%@ include file="closeCon.jspf"%>	