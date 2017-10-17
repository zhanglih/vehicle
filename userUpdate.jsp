<!--
    描述:修改用户资料界面
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
        int ID=Integer.parseInt(request.getParameter("id"));
        BLUserx blUserx=new BLUserx(con);
        UserxSchema userxSchema=blUserx.getSchema(ID);
        int isEnabled=userxSchema.IsEnabled;
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>修改用户资料</title>
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
    <body onLoad="JavaScript:form.passwordx.focus();">
        <form name="form" method="post" action="userUpdateResult.jsp?id=<%=userxSchema.ID%>" onsubmit="return verity()">
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
                            <h2>修改用户资料</h2>
                        </header>
                        <div class="row uniform">
                            <div class="12u$"><label for="namex">用户名</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="email" name="userx" value="<%=userxSchema.Userx%>" placeholder="用户名"  maxlength="30" readonly/>
                            </div>
                            <div class="12u$"><label for="namex">姓名</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="text" name="namex" value="<%=userxSchema.Namex%>" placeholder="姓名"  maxlength="30"/>
                            </div>
                            <div class="2u" align="left" style="color:red">
                                *
                            </div>
                            <div class="12u$"><label for="namex">手机</label></div>
                            <div class="7u 12u$(xsmall)">
                                <input type="text" name="mobile" 
                                    value="<%=userxSchema.Mobile%>" placeholder="手机"  maxlength="20"/>
                            </div>
                            <div class="5u" align="left" style="color:red">
                                *
                            </div>
                            <!-- Break -->
                            <div class="12u$"><label for="isEnabled">启用</label></div>
                            <%
                                if(isEnabled==1)
                                {
                            %>
                            <div class="1u 1u$(small)" align="left">
                                <input type="radio" id="isEnabled-yes" name="isEnabled" 
                                    value="1" checked>
                                <label for="isEnabled-yes">是</label>
                            </div>
                            <div class="1u$ 1u$(small)" align="left">
                                <input type="radio" id="isEnabled-no" name="isEnabled" 
                                    value="0">
                                <label for="isEnabled-no">否</label>
                            </div>
                            <%
                                }
                                else
                                {
                            %>
                            <div class="1u 1u$(small)" align="left">
                                <input type="radio" id="isEnabled-yes" name="isEnabled" 
                                    value="1" >
                                <label for="isEnabled-yes">是</label>
                            </div>
                            <div class="1u$ 1u$(small)" align="left">
                                <input type="radio" id="isEnabled-no" name="isEnabled" 
                                    value="0" checked>
                                <label for="isEnabled-no">否</label>
                            </div>
                            <%
                                }
                            %>
                            <!-- Break -->
                            <div class="12u$"><label for="namex">备注</label></div>
                            <div class="7u$">
                                <textarea name="memo" 
                                    placeholder="备注" rows="6"><%=userxSchema.Memo%></textarea>
                            </div>
                            <!-- Break -->
                            <div class="12u$">
                                <ul class="actions">
                                    <li><input type="submit" value="确定" class="special"/></li>
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