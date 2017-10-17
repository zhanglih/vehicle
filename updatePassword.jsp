<!--
	描述：用户点击菜单栏修改密码后跳转页面，修改密码需要输入原密码、新密码、确认密码；
    作者：杜乘风
    手机：13247191605
    微信：13247191605
    日期：2017-07-17
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("index.jsp");
	else
	{	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户-密码修改</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="JavaScript">
        	function verity()
			{
				var passwordx='<%=session.getAttribute("Passwordx")%>';
				var oldPassword=form.oldPassword.value;
				var newPassword=form.newPassword.value;
				var verifiedPassword=form.verifiedPassword.value;
				var regex=/^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])).{6,16}$/;
				if(oldPassword=="")
				{
					alert("原密码不能为空");
					form.oldPassword.focus();
					return false;
				}
				if(newPassword=="")
				{
					alert("新密码不能为空");
					form.newPassword.focus();
					return false;
				}
				if(verifiedPassword=="")
				{
					alert("确认密码不能为空");
					form.verifiedPassword.focus();
					return false;
				}
				if(newPassword!=verifiedPassword)
				{
					alert("确认密码与新密码不符");
					form.verifiedPassword.focus();
					return false;
				}
                if(!newPassword.match(regex))
                {
                    alert("密码必须是6-16位的大小写字母和数字组合");
                    form.newPassword.focus();
                    return false;
                }
                if(newPassword==passwordx)
                {
                    alert("新密码不能和原密码相同");
                    form.newPassword.focus();
                    return false;
                }
				if(!oldPassword.equals(passwordx))
				{
					alert("原始密码不正确");
					form.oldPassword.focus();
					return false;
				}
				return true;
			}
        </script>
	</head>
	<body onLoad="JavaScript:form.oldPassword.focus();">
		<form name="form" method="post" action="updatePasswordResult.jsp" onsubmit="return verity()">
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
                            <h2>修改用户密码</h2>
                        </header>
                        <div class="row uniform">
                            <div class="7u 12u$(xsmall)">
                                <input type="password" name="oldPassword" value="" placeholder="原密码"  maxlength="30"/>
                            </div>
                            <div class="2u" align="left" style="color:red">
                            	*
                            </div>
                            <div class="7u 12u$(xsmall)">
                                <input type="password" name="newPassword" value="" placeholder="新密码"  maxlength="30"/>
                            </div>
                            <div class="2u" align="left" style="color:red">
                           		*
                            </div>
                            <div class="7u 12u$(xsmall)">
                                <input type="password" name="verifiedPassword"  value="" placeholder="确认密码"  maxlength="30"/>
                            </div>
                            <div class="2u" align="left" style="color:red">
                            	*
                            </div>
                            <div class="12u$">
                                <ul class="actions">
                                 	<tr>
                                        <td height="60" colspan="2" align="right">
                                            <li><input type="submit" value="提交" class="special"/></li>
                                            <li><input type="reset" value="重置" onclick="JavaScript:form.oldPassword.focus();"/></li>
                                        </td>
                                    </tr>
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
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>