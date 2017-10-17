<!--
	描述:新建公司界面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ include file="openCon.jspf"%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新建公司页面</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
			function verify()
			{
				var regex;
				var regexKey = /[`~!@#$%^&*+=|{}':;'<>?~！@#￥%……&*——+|{}【】‘；：”“’、？]/im; 
				var name = form.namex.value;
				if(name=="")
				{
					alert("公司名称不能为空");
					return false;
				}
				if(regexKey.test(name))
				{
					alert("公司名称中存在特殊字符，请重新输入");
					form.namex.focus();
					return false;
				}

				var contactPerson = form.contactPerson.value;
				if(contactPerson=="")
				{
					alert("联系人不能为空");
					return false;
				}
				if(regexKey.test(contactPerson))
				{
					alert("联系人中存在特殊字符，请重新输入");
					form.contactPerson.focus();
					return false;
				}

				var tel = form.tel.value;
				regex = new RegExp("^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$");
				if(tel!="")
				{
					if(!regex.test(tel))
					{
						alert("请输入正确的电话");
						form.tel.focus();
						return false;
					}
				}

				var mobile = form.mobile.value;
				if(mobile=="")
				{
					alert("手机不能为空");
					return false;
				}
				regex = new RegExp("^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$");
				if(!regex.test(mobile))
				{
					alert("请输入正确的手机号");
					form.mobile.focus();
					return false;
				}

				var email = form.email.value;
				if(email=="")
				{
					alert("电子邮箱不能为空");
					return false;
				}
				var szReg=/^[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?$/;
				var bChk=szReg.test(email); 
				if(!bChk)
				{
					alert("请输入正确的电子邮箱");
					form.email.focus();
					return false;
				}

				var address = form.address.value;
				if(address!="")
				{
					if(regexKey.test(address))
					{
						alert("地址中存在特殊字符，请重新输入");
						form.address.focus();
						return false;
					}
				}

				var postcode = form.postcode.value;
				var re= /^[1-9][0-9]{5}$/;
				if(postcode!="")
				{
					if(!re.test(postcode))
					{
						alert("请输入正确的邮政编码");
						form.postcode.focus();
						return false;
					}
				}

				var website = form.website.value;
				var reg=/^([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/)(([A-Za-z0-9-~]+)\.)+([A-Za-z0-9-~\/])+$/;
				var flag = reg.test(website);
				if(website!="")
				{
					if(!flag)
					{
						alert("请输入正确的网站");
						form.website.focus();
						return false;
					}
				}

				var memo = form.memo.value;
				if(memo!="")
				{
					if(regexKey.test(memo))
					{
						alert("备注中存在特殊字符，请重新输入");
						form.memo.focus();
						return false;
					}
				}
				return true;
			}
		</script>
	</head>
	<body onLoad="JavaScript:form.namex.focus()">
		<form name="form" method="post" action="companyCreateResult.jsp" onsubmit="return verify()">
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
										<h2>新建公司</h2>
									</header>
									
									<div class="row uniform">
										<div class="12u$"><label for="namex">公司名称</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" name="namex" id="namex" value="" placeholder="公司名称" maxlength="50" data-required="true"/>
										</div>
										<div class="2u" align="left" style="color:red">
			                                *
			                            </div>
			                            <div class="12u$"><label for="contactPerson">联系人</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" data-required name="contactPerson" value="" placeholder="联系人"  maxlength="30"/>
										</div>
										<div class="2u" align="left" style="color:red">
			                                *
			                            </div>
			                            <div class="12u$"><label for="tel">电话</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" name="tel" value="" placeholder="电话" maxlength="20" />
										</div>
										<div class="12u$"><label for="mobile">手机</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" data-required name="mobile" value="" maxlength="20" onkeypress="return /^[0-9]*$/.test(String.fromCharCode(event.which))" placeholder="手机" />
										</div>
										<div class="2u" align="left" style="color:red">
			                                *
			                            </div>
			                            <div class="12u$"><label for="email">电子邮箱</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" data-required name="email" id="email" maxlength="30" value="" onkeypress="return /[0-9a-zA-Z]|[@]|\./.test(String.fromCharCode(event.which))" placeholder="电子邮箱" />
										</div>
										<div class="2u" align="left" style="color:red">
			                                *
			                            </div>
			                            <div class="12u$"><label for="address">地址</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" name="address" value="" maxlength="200" placeholder="地址" />
										</div>
										<div class="12u$"><label for="postcode">邮政编码</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" name="postcode" value="" maxlength="10" placeholder="邮政编码" />
										</div>
										<div class="12u$"><label for="website">网站</label></div>
										<div class="7u 12u$(xsmall)">
											<input type="text" name="website" value="" maxlength="200" placeholder="网站" />
										</div>
										<div class="12u$"><label for="memo">备注</label></div>
										<div class="7u 12u$(xsmall)">
											<textarea name="memo" placeholder="备注" rows="6"></textarea>
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
</html>
<%@ include file="closeCon.jspf"%>	