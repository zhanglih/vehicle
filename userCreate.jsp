<!--
    描述:新建用户界面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
        //获取当前登录用户userxSchema对象
		int ID=(Integer)session.getAttribute("ID");
		BLUserx blUserx=new BLUserx(con);
		UserxSchema userxSchema=blUserx.getSchema(ID);
		//获取当前登录用户对应的用户组
		int companyID=userxSchema.CompanyID;
        String name = "公司创始人";
		String whereClause="CompanyID='"+companyID+"' AND Namex != '"+ name +"'";
		BLUserGroup blUserGroup=new BLUserGroup(con);
		List result=blUserGroup.select(whereClause);        
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新建用户</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="JavaScript">
			function verity()
			{
				var regex;
                var regexKey = /[`~!@#$%^&*()+=|{}':;',.<>?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]/im;
                var userGroupID=form.userGroupID.value;
                if(userGroupID=="")
                {
                    alert("用户组不能为空");
                    form.userGroupID.focus();
                    return false;
                }
				var userx=form.userx.value;
				if(userx=="")
				{
					alert("用户名不能为空");
					form.userx.focus();
					return false;
				}
                var szReg=/^[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?$/;
                var bChk=szReg.test(userx); 
                if(!bChk)
                {
                    alert("请输入正确的用户名");
                    form.userx.focus();
                    return false;
                }
				var namex=form.namex.value;
				if(namex=="")
				{
					alert("姓名不能为空");
					form.namex.focus();
					return false;
				}
                if(regexKey.test(namex))
                {
                    alert("姓名中存在特殊字符，请重新输入");
                    form.namex.focus();
                    return false;
                }
				var mobile=form.mobile.value;
				if(mobile=="")
				{
					alert("手机不能为空");
					form.mobile.focus();
					return false;
				}
                regex = new RegExp("^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$");
                if(!regex.test(mobile))
                {
                    alert("请输入正确的手机号");
                    form.mobile.focus();
                    return false;
                }
                var memo = form.memo.value;
                if(regexKey.test(memo))
                {
                    alert("备注中存在特殊字符，请重新输入");
                    form.memo.focus();
                    return false;
                }
				return true;
			}
		</script>
	</head>
	<body onLoad="JavaScript:form.userx.focus();">
    	<form name="form" method="post" action="userCreateResult.jsp" onsubmit="return verity()">
		
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
                            <h2>新建用户</h2>
                        </header>    
                        <div class="row uniform">
                            <div class="12u$"><label for="namex">用户组</label></div>
                            <div class="7u 12u$(xsmall)">
                                <div class="select-wrapper">
                                    <select name="userGroupID">
                                        <option value="">- 用户组 -</option>
                                        <%
                                            for(Object obj:result)
                                            {
                                                UserGroupSchema userGroupSchema=(UserGroupSchema)obj;
                                        %>
                                            <option value="<%=userGroupSchema.ID%>">
                                                <%=userGroupSchema.Namex%>
                                            </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                            <div class="2u" align="left" style="color:red">
                                <a href="userGroupInto.jsp">用户组管理</a>
                            </div>
                            <div class="12u$"><label for="namex">用户名</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="text" name="userx" value="" placeholder="用户名" />
                            </div>
                            <div class="2u" align="left" style="color:red">
                                *
                            </div>
                            <div class="12u$"><label for="namex">姓名</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="text" name="namex" value="" placeholder="姓名" />
                            </div>
                            <div class="2u" align="left" style="color:red">
                                *
                            </div>
                            <div class="12u$"><label for="namex">手机</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="text" name="mobile" value="" placeholder="手机" />
                            </div>
                            <div class="2u" align="left" style="color:red">
                                *
                            </div>
                            
                            <div class="12u$"><label for="namex">备注</label></div>
                            <div class="7u$">
                                <textarea name="memo" 
                                    placeholder="备注" rows="6"></textarea>
                            </div>
                            <!-- Break -->
                            <div class="12u$">
                                <ul class="actions">
                                    <li><input type="submit" value="提交" class="special" /></li>
                                    <li><input type="reset" value="重置" /></li>
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