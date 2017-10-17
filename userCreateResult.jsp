<!--
	描述:接收新建用户数据并作出响应。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.util.MailUtil"%>
<%@ page import="com.quarkioe.vehicle.util.CheckEmail"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

		Userx2UserGroupSchema userx2UserGroupSchema = null;
		UserxSchema userCompany = blUserx.getSchema(ID);
		int companyID = userCompany.CompanyID;
		
		String userGroupID = request.getParameter("userGroupID");
		String userx = request.getParameter("userx");
		String passwordx = "123456";
		String namex = request.getParameter("namex");
		String mobile = request.getParameter("mobile");
		String memo = request.getParameter("memo");
		

		String regex = "[0-9]*";
		int length = 0;
		Pattern pattern = null;
		Matcher isNum = null;
		Matcher matcher = null;

		boolean userxFlag1 = "".equals(userx);
		regex = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(userx));
		boolean userxFlag2 = matcher.matches();

		boolean nameFlag1 = "".equals(namex);
		length = MiscTool.getUTF8FromISO(namex).length();
		boolean nameFlag2 = (length<30);
		regex = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(namex));
		boolean nameFlag3 = matcher.find();

		boolean mobileFlag1 = "".equals(mobile);
		regex = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(mobile));
		boolean mobileFlag2 = matcher.matches();
		
		boolean memoFlag = false;
		if("".equals(memo))
			memoFlag = true;
		else
		{
			regex = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
			pattern = Pattern.compile(regex);
			matcher = pattern.matcher(MiscTool.getUTF8FromISO(memo));
			memoFlag = !matcher.find();
		}

		BLLogx blLogx = new BLLogx(con);
		LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userCompany.CompanyID;
        logxSchema.UserxID = userCompany.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "新增用户";
		
		UserxSchema userxSchema = new UserxSchema();
		userxSchema.CompanyID = companyID;
		userxSchema.Userx = MiscTool.getUTF8FromISO(userx);
		userxSchema.Passwordx = passwordx;
		userxSchema.Namex = MiscTool.getUTF8FromISO(namex);
		userxSchema.Mobile = mobile;
		userxSchema.Memo = MiscTool.getUTF8FromISO(memo);
		userxSchema.IsEnabled = 0;

		boolean flagEmail = true;
		CheckEmail ce = new CheckEmail();

		String whereClause = "Userx ='" + MiscTool.getUTF8FromISO(userx) + "' and CompanyID=" + companyID;

		int count = blUserx.getCount(whereClause);
		boolean flag = false;
		if(count==0&&!userxFlag1&&userxFlag2&&!nameFlag1&&nameFlag2&&!nameFlag3&&!mobileFlag1&&mobileFlag2&&memoFlag)
		{
			flagEmail = ce.checkEmailMethod(userxSchema.Userx);
			if(flagEmail)
			{
				flag = blUserx.insert(userxSchema);
			}
		}
		if(flag)
		{
			List result = blUserx.select(whereClause);
			for(Object obj : result)
			{
				userxSchema = (UserxSchema)obj;
				userx2UserGroupSchema = new Userx2UserGroupSchema();
				userx2UserGroupSchema.UserxID = userxSchema.ID;
				userx2UserGroupSchema.UserGroupID = Integer.parseInt(userGroupID);
				flag = blUserx2UserGroup.insert(userx2UserGroupSchema);
			}
			String subject = "欢迎注册";
			String body ="请点击链接激活您的账号，激活成功请重新登录，初始密码为123456:"+"http://54.223.230.225/vehicle/ActiveUserx.jsp?user="+userxSchema.Userx;
			MailUtil mailUtil = new MailUtil(userxSchema.Userx,subject,body);
			mailUtil.send();
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新建用户</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
		<%
			if(count>0)
			{
		%>
				alert("该用户名已存在!");
				window.history.go(-1);
		<%	
			}
			if(flagEmail==false)
			{
		%>
				alert("请输入有效的邮箱地址");
				window.history.go(-1);
		<%
			}
			if(flag)
			{
		%>
				alert("注册成功，请前往邮箱激活!");
				window.location.href="user.jsp";
		<%
				logxSchema.Operation = "新增用户成功";
				blLogx.insert(logxSchema);
			}
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
			                            <h2>新建用户</h2>
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
<%
	}
%>
<%@ include file="closeCon.jspf"%>