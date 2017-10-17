<!--
	描述：更新驾驶员信息
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID=Integer.parseInt(request.getParameter("ID").trim());
	
		String compay = request.getParameter("compay");
		boolean flagCompany1 = "".equals(compay);
		String regEx = "[0-9]*";
		Pattern pattern = Pattern.compile(regEx);
		Matcher isNum = pattern.matcher(compay);
		boolean flagCompany2 = isNum.matches();
		
		
		String namex = request.getParameter("namex");
		boolean flagNamex1 = "".equals(namex);
		int length = MiscTool.getUTF8FromISO(namex).length();
		boolean flagNamex2 = (length > 30);
		regEx="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
		pattern = Pattern.compile(regEx);
		Matcher matcher = pattern.matcher(MiscTool.getUTF8FromISO(namex));
		boolean flagNamex3 = matcher.find();
		
		
		String gender = request.getParameter("gender");
		boolean flagGender1 = "".equals(gender);
		regEx = "[0-9]*";
		pattern = Pattern.compile(regEx);
		isNum = pattern.matcher(gender);
		boolean flagGender2 = isNum.matches();
		
		
		String identityNo = request.getParameter("identityNo");
		boolean flagidentityNo1 = "".equals(identityNo);
		isNum = pattern.matcher(identityNo);
		boolean flagidentityNo2 = isNum.matches();
		length = MiscTool.getUTF8FromISO(identityNo).length();
		boolean flagidentityNo3 = (length > 30);
		
		
		String mobile = request.getParameter("mobile");
		boolean flagMobile1 = "".equals(mobile);
		regEx = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
		pattern = Pattern.compile(regEx);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(mobile));
		boolean flagMobile2 = matcher.matches();
		
		
		String jobCharacter = request.getParameter("jobCharacter");
		length = MiscTool.getUTF8FromISO(jobCharacter).length();
		boolean flagJobCharacter1 = (length>50);
		regEx="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
		pattern = Pattern.compile(regEx);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(jobCharacter));
		boolean flagJobCharacter2 = matcher.find();
		
		
		String memo = request.getParameter("memo");
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(memo));
		boolean flagMemo = matcher.find();
		
		
		String date = request.getParameter("hiredDate");
		boolean flagDate1 = "".equals(date);
		regEx = "(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";
		pattern = Pattern.compile(regEx);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(date));
		boolean flagDate2 = matcher.matches();
		
		BLDriver blDriver = new BLDriver(con);
		DriverSchema driverSchema = blDriver.getSchema(ID);
		
		driverSchema.Namex = MiscTool.getUTF8FromISO(namex);
		driverSchema.Gender = Integer.valueOf(gender);
		driverSchema.IdentityNo = identityNo;
		driverSchema.Mobile = mobile;
		driverSchema.JobCharacter = MiscTool.getUTF8FromISO(jobCharacter);
		driverSchema.Memo = MiscTool.getUTF8FromISO(memo);
		driverSchema.CompanyID = Integer.valueOf(compay);
		driverSchema.HiredDate = date;
		
		boolean flag = false;
		if(!flagCompany1&&flagCompany2&&!flagNamex1&&!flagNamex2&&!flagNamex3&&!flagGender1&&flagGender2
		&&!flagidentityNo1&&flagidentityNo2&&!flagidentityNo3&&!flagMobile1&&flagMobile2&&!flagJobCharacter1
		&&!flagJobCharacter2&&!flagMemo&&!flagDate1&&flagDate2)
		{
			flag = blDriver.update(driverSchema);
		}
		
		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "更新驾驶员信息";
	
%>
<!DOCTYPE HTML>
<html>
	<head>
    
		<title>驾驶员-修改结果处理</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="driver.jsp";
		<%
				logxSchema.Operation = "更新驾驶员信息成功";
			}
			else
			{
		%>
				alert("更新驾驶员信息失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "更新驾驶员信息失败";
			}
			blLogx.insert(logxSchema);
		%>
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
										<h1>模板</h1>
									</header>

									<!--
									<span class="image main"><img src="images/pic11.jpg" alt="" /></span>

									<p>Donec eget ex magna. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque venenatis dolor imperdiet dolor mattis sagittis. Praesent rutrum sem diam, vitae egestas enim auctor sit amet. Pellentesque leo mauris, consectetur id ipsum sit amet, fergiat. Pellentesque in mi eu massa lacinia malesuada et a elit
                                    -->
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>