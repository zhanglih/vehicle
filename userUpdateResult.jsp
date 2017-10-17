<!--
	描述:接收修改用户资料界面传递的数据并作出响应。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="com.quarkioe.vehicle.util.MailUtil"%>
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
		String ID=request.getParameter("id");
		BLUserx blUserx=new BLUserx(con);
		UserxSchema userxSchema=blUserx.getSchema(Integer.parseInt(ID));
		//接收参数
		String passwordx="123456";
		String namex=request.getParameter("namex");
		String mobile=request.getParameter("mobile");
		String isEnabled=request.getParameter("isEnabled");
		String memo=request.getParameter("memo");

		String regex = "[0-9]*";
		int length = 0;
		Pattern pattern = null;
		Matcher isNum = null;
		Matcher matcher = null;

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


		//重新赋值
		userxSchema.Passwordx=passwordx;
		userxSchema.Namex=MiscTool.getUTF8FromISO(namex);
		userxSchema.Mobile=mobile;
		userxSchema.IsEnabled=Integer.parseInt(isEnabled);
		userxSchema.Memo=MiscTool.getUTF8FromISO(memo);

		//执行修改，返回一个boolean值
		boolean flag = false;
		if(!nameFlag1&&nameFlag2&&!nameFlag3&&!mobileFlag1&&mobileFlag2&&memoFlag)
		{
			flag = blUserx.update(userxSchema);
		}

		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema user = blUserx.getSchema(userID);

		LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = user.CompanyID;
        logxSchema.UserxID = user.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "修改用户信息";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>修改用户资料</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
			<%
				if(flag)
				{
					String subject = "用户资料修改";
					String body ="您的资料已经更新，新密码为：123456，请重新登录并修改密码";
					MailUtil mailUtil = new MailUtil(userxSchema.Userx,subject,body);
					mailUtil.send();
			%>
					
					window.location.href = "user.jsp";
			<%
					logxSchema.Operation = "修改用户资料成功";
				}
				else
				{
			%>
					alert("修改失败");
					window.history.go(-1);
			<%
					logxSchema.Operation = "修改用户资料失败";
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
			                            <h2>修改用户资料</h2>
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