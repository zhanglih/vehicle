<!--
	描述：新建用户组页面
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID=Integer.parseInt(request.getParameter("id"));
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户组-新建</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="JavaScript">
		function verify()
		{
			var namex=form.namex.value;
			if(namex==null||namex=="")
			{
				alert("用户组名不能为空");
				document.getElementById("namex").focus();//设置焦点
				return false;
			}
			var re = /[`~!@#$%^&*()+=|{}':;',.<>?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]/im;
			if(re.test(namex))
			{
				alert("用户组名称中存在特殊字符，请重新输入");
				document.getElementById("namex").focus();//设置焦点
				return false;
			}
			
			
			//权限判断
			var obj = document.getElementsByName("permissionx");//获得权限数组遍历成字符串
			permissionx = [];
			for(k in obj)
			{
				if(obj[k].checked)
					permissionx.push(obj[k].value);
			}
			if(permissionx.length==0)
			{
				alert("权限不能为空");
				document.getElementById("permissionx-a").focus();//设置焦点
				return false;
			}
			
		}
		</script>
	</head>
	<body onload='document.getElementById("namex").focus();'>
		<form name="form" method="post" action="rootCreateUserGroupResult.jsp?id=<%=ID%>" onsubmit="return verify();">
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
										<h2>新建用户组</h2>
									</header>
									<!-- Break -->
                                    <div class="row uniform">
                                    	<div class="12u$"><label for="namex">用户组名</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="namex" id="namex" value="" placeholder="用户组名" maxlength="30"/>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
                                        <!-- Break -->
                                        <div class="12u$">
                                            <label for="permissionx-a">权限</label>
                                        </div>
                                        <div class="3u 6u$(xsmall)">
                                            <input type="checkbox" id="permissionx-a" name="permissionx" value="create">
                                            <label for="permissionx-a">增加</label>
                                        </div>
                                        <div class="3u 6u$(xsmall)">
                                            <input type="checkbox" id="permissionx-b" name="permissionx" value="update">
                                            <label for="permissionx-b">修改</label>
                                        </div>
                                        <div class="3u 6u$(xsmall)">
                                            <input type="checkbox" id="permissionx-c" name="permissionx" value="delete">
                                            <label for="permissionx-c">删除</label>
                                        </div>
                                        <!-- Break -->
                                        <!-- 
                                        <div class="12u$"><label for="isEnabled">启用</label></div>
                                        <div class="3u 3u$(small)">
                                            <input type="radio" id="isEnabled-a" name="isEnabled" value="1" checked>
                                            <label for="isEnabled-a">是</label>
                                        </div>
                                        <div class="9u 9u$(small)">
                                            <input type="radio" id="isEnabled-b" name="isEnabled" value="0" >
                                            <label for="isEnabled-b">否</label>
                                        </div>
                                         -->
                                        <!-- Break -->
                                        <div class="12u$"><label for="memo">备注</label></div>
                                        <div class="6u 12u$(xsmall)" style="float:none"> 
                                            <input type="text" name="memo" value="" placeholder="备注" />
                                        </div>
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