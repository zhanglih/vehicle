<!--
	描述：新建驾驶员页面
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-05
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID") == null){
		response.sendRedirect("login.jsp");
	}
	else
	{
		Integer ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		Integer CompanyID = userxSchema.CompanyID;
		String Userx = userxSchema.Userx;
		String whereClause = "";
		if("root".equals(userxSchema.Userx))
		{
			whereClause = "1=1";
		}
		else
		{
			whereClause = "1=1 AND ID = "+CompanyID;
		}
		
		BLCompany blCompany = new BLCompany(con);
		List result = blCompany.select(whereClause);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>驾驶员-新建</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="JavaScript">
			function verify()
			{
				var compay=form.compay.value;
				var namex=form.namex.value;
				var identityNo=form.identityNo.value;
				var mobile=form.mobile.value;
				var hiredDate=form.hiredDate.value;
				
				if(compay == "n")
				{
					alert("所属公司不能为空");
					document.getElementById("compay").focus();//设置焦点
					return false;
				}
				
				if(namex==null||namex=="")
				{
					alert("姓名不能为空");
					document.getElementById("namex").focus();//设置焦点
					return false;
				}
				var re = /[`~!@#$%^&*()+=|{}':;',.<>?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]/im;
				if(re.test(namex))
				{
					alert("姓名中存在特殊字符，请重新输入");
					document.getElementById("namex").focus();//设置焦点
					return false;
				}
				
				
				if(identityNo==null||identityNo=="")
				{
					alert("身份证号不能为空");
					document.getElementById("identityNo").focus();//设置焦点
					return false;
				}
				re = (/^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/)|(/^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$/);
				if(!identityNo.match(re))
                {
                    alert("请输入正确的身份证号码");
                    document.getElementById("identityNo").focus();//设置焦点
                    return false;
                }
				
				
				if(mobile==null||mobile=="")
				{
					alert("手机号不能为空");
					document.getElementById("mobile").focus();//设置焦点
					return false;
				}
				var reg = new RegExp("^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$");
				if(!reg.test(mobile))
				{
					alert("手机号输入有误");
					document.getElementById("mobile").focus();//设置焦点
					return false;
				}
				
				
				
				if(hiredDate==null||hiredDate=="")
				{
					alert("入职日期不能为空");
					document.getElementById("hiredDate").focus();//设置焦点
					return false;
				}
				reg = new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
				if(!reg.test(hiredDate))
				{
					alert("入职日期输入有误");
					document.getElementById("hiredDate").focus();//设置焦点
					return false;
				}
			}
		</script>
	</head>
	<body onload='document.getElementById("compay").focus();'>
		<form name="form" method="post" action="createDriverResult.jsp" onsubmit="return verify();">
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
										<h2>新建驾驶员</h2>
									</header>
									<!-- Break -->
                                    <div class="row uniform">
                                    	<div class="12u$"><label for="namex">所属公司</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <select name="compay" id="compay">
												<option value="n">请选择</option>
												<%
													for(Object obj:result)
													{
														CompanySchema companySchema = (CompanySchema)obj;
												%>
														<option value="<%=companySchema.ID%>"><%=companySchema.Namex%></option>
												<%
													}
												%>
											</select>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
                                        <!-- Break -->
                                        <!-- Break -->
                                        <div class="12u$"><label for="namex">姓名</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="namex" id="namex" value="" placeholder="姓名" maxlength="30"/>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
                                        <!-- Break -->
                                        <div class="12u$"><label for="namex">性别</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <select name="gender" id="gender">
												<option value="0">请选择</option>
												<option value="1">男</option>
												<option value="2">女</option>
											</select>
                                        </div>
                                        <!-- Break -->
										<div class="12u$"><label for="namex">身份证号</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="identityNo" id="identityNo" value="" placeholder="身份证号" maxlength="30"/>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
										<!-- Break -->
										<div class="12u$"><label for="namex">手机</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="mobile" id="mobile" value="" placeholder="手机" maxlength="30"/>
                                        </div>
                                        <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
										<!-- Break -->
										<div class="12u$"><label for="namex">工作性质</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="jobCharacter" id="jobCharacter" value="" placeholder="工作性质" maxlength="50"/>
                                        </div>
										<!-- Break -->
										<div class="12u$"><label for="namex">入职日期</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="hiredDate" id="hiredDate" value="" placeholder="入职日期" maxlength="30" onClick="WdatePicker()"/>
                                        </div>
										 <div class="6u 12u$(xsmall)" style="color:red">
                                        *</div>
										<!-- Break -->
										<div class="12u$"><label for="namex">备注</label></div>
                                        <div class="6u 12u$(xsmall)">
                                            <input type="text" name="memo" id="memo" value="" placeholder="备注" maxlength="30"/>
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