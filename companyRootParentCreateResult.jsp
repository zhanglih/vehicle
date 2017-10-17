<!--
	描述:接收root用户新建总公司名下子公司界面传递的数据并作出响应。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.util.MailUtil"%>
<%@ page import="com.quarkioe.vehicle.util.CheckEmail"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ include file="openCon.jspf"%>
<%
	int ID = Integer.parseInt(request.getParameter("id"));

	BLCompany blCompany = new BLCompany(con);
	BLUserx blUserx = new BLUserx(con);
	BLUserGroup blUserGroup = new BLUserGroup(con);
	BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);
	BLLogx blLogx = new BLLogx(con);

	String namex = request.getParameter("namex");
	String contactPerson = request.getParameter("contactPerson");
	String tel = request.getParameter("tel");
	String mobile = request.getParameter("mobile");
	String email = request.getParameter("email");
	String address = request.getParameter("address");
	String postcode = request.getParameter("postcode");
	String website = request.getParameter("website");
	String memo = request.getParameter("memo");

	String regex = "[0-9]*";
	int length = 0;
	Pattern pattern = null;
	Matcher isNum = null;
	Matcher matcher = null;

	boolean nameFlag1 = "".equals(namex);
	length = MiscTool.getUTF8FromISO(namex).length();
	boolean nameFlag2 = (length<50);
	regex = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
	pattern = Pattern.compile(regex);
	matcher = pattern.matcher(MiscTool.getUTF8FromISO(namex));
	boolean nameFlag3 = matcher.find();

	boolean contactPersonFlag1 = "".equals(contactPerson);
	length = MiscTool.getUTF8FromISO(contactPerson).length();
	boolean contactPersonFlag2 = (length<30);
	regex = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
	pattern = Pattern.compile(regex);
	matcher = pattern.matcher(MiscTool.getUTF8FromISO(contactPerson));
	boolean contactPersonFlag3 = matcher.find();
	
	boolean telFlag = false;
	if("".equals(tel))
		telFlag = true;
	else
	{
		regex = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(tel));
		telFlag = matcher.matches();
	}

	boolean mobileFlag1 = "".equals(mobile);
	regex = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
	pattern = Pattern.compile(regex);
	matcher = pattern.matcher(MiscTool.getUTF8FromISO(mobile));
	boolean mobileFlag2 = matcher.matches();

	boolean emailFlag1 = "".equals(email);
	regex = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
	pattern = Pattern.compile(regex);
	matcher = pattern.matcher(MiscTool.getUTF8FromISO(email));
	boolean emailFlag2 = matcher.matches();

	regex = "[`~!@#$%^&*+=|{}':;'\\[\\].<>/?~！@#￥%……&*——+|{}【】‘；：”“’、？]"; 
	pattern = Pattern.compile(regex);
	matcher = pattern.matcher(MiscTool.getUTF8FromISO(address));
	boolean addressFlag = matcher.find();

	boolean postcodeFlag = false;
	if("".equals(postcode))
		postcodeFlag = true;
	else
	{
		regex = "/^[0-9][0-9]{5}$/";
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(postcode));
		postcodeFlag = !matcher.matches();
	}

	boolean websiteFlag = false;
	if("".equals(website))
		websiteFlag = true;
	else
	{
		regex = "^([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+$";
		pattern = Pattern.compile(regex);
		matcher = pattern.matcher(MiscTool.getUTF8FromISO(website));
		websiteFlag = matcher.matches();
	}

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

	UserxSchema userxSchema = null;
	UserGroupSchema userGroupSchema = null;
	Userx2UserGroupSchema user2UserGroupSchema = null;

	int count1 = 0;
	int count2 = 0;
	boolean companyFlag = false;
	boolean userxFlag = false;
	boolean userGroupFlag = false;
	boolean userx2UserGroupFlag = false;

	String whereClause = "Namex = '" + MiscTool.getUTF8FromISO(namex) + "'";
	List listDB = blCompany.select(whereClause);
	if(listDB.isEmpty())
	{
		CompanySchema companySchema = new CompanySchema();
		companySchema.ParentID = ID;	
		companySchema.Namex = MiscTool.getUTF8FromISO(namex);
		companySchema.ContactPerson = MiscTool.getUTF8FromISO(contactPerson);
		companySchema.Tel = tel;
		companySchema.Mobile = mobile;
		companySchema.Email = MiscTool.getUTF8FromISO(email);
		companySchema.Address = MiscTool.getUTF8FromISO(address);
		companySchema.Postcode = postcode;
		companySchema.Website = MiscTool.getUTF8FromISO(website);
		companySchema.RegisteredTime = MiscTool.getNow();
		companySchema.IsEnabled = 0;
		companySchema.Memo = MiscTool.getUTF8FromISO(memo);

		boolean flagEmail = true;
		CheckEmail ce = new CheckEmail();

		whereClause = "Userx = '" + email + "'";
		count1 = blUserx.getCount(whereClause);

		whereClause = "Email = '" + email + "'";
		count2 = blCompany.getCount(whereClause);
		if(count1==0&&count2==0&&!nameFlag1&&nameFlag2&&!nameFlag3&&!contactPersonFlag1&&contactPersonFlag2&&!contactPersonFlag3&&telFlag&&!mobileFlag1&&mobileFlag2&&!emailFlag1&&emailFlag2&&!addressFlag&&postcodeFlag&&websiteFlag&&memoFlag)
		{
			flagEmail = ce.checkEmailMethod(email);
			if(flagEmail)
			{
				companyFlag = blCompany.insert(companySchema);
				if(companyFlag)
				{
					List result1 = blCompany.select(whereClause);
					for(Object objCompany : result1)
					{
						companySchema = (CompanySchema)objCompany;
						
						userGroupSchema = new UserGroupSchema();
						userGroupSchema.CompanyID = companySchema.ID;
						userGroupSchema.Namex = "公司创始人";
						userGroupSchema.Permissionx = "create delete update";
						userGroupSchema.IsEnabled = 1;
						userGroupSchema.Memo = "公司创始人";

						userGroupFlag = blUserGroup.insert(userGroupSchema);
						if(userGroupFlag)
						{
							whereClause = "Namex = '公司创始人'";
							List listGroups = blUserGroup.select(whereClause);
							for(Object objGroups : listGroups)
							{
								userGroupSchema = (UserGroupSchema)objGroups;
							}
							userxSchema = new UserxSchema();
							userxSchema.CompanyID = companySchema.ID;
							userxSchema.Userx = companySchema.Email;
							userxSchema.Passwordx = "123456";
							userxSchema.Namex = companySchema.ContactPerson;
							userxSchema.Mobile = companySchema.Mobile;
							userxSchema.IsEnabled = 1;
							userxSchema.Memo = MiscTool.getUTF8FromISO(memo);
							userxFlag = blUserx.insert(userxSchema);

							whereClause = "Userx = '" + companySchema.Email + "'";
							if(userxFlag)
							{
								List result3 = blUserx.select(whereClause);
								for(Object objUserx : result3)
								{
									userxSchema = (UserxSchema)objUserx;
									user2UserGroupSchema = new Userx2UserGroupSchema();
									user2UserGroupSchema.UserxID = userxSchema.ID;
									user2UserGroupSchema.UserGroupID = userGroupSchema.ID;
									userx2UserGroupFlag = blUserx2UserGroup.insert(user2UserGroupSchema);
									if(userx2UserGroupFlag)
									{
										String subject = "欢迎注册";
										String body ="请点击链接激活您的账号，激活成功请重新登录，登录用户名为电子邮箱，初始密码为123456。"+"http://54.223.230.225/vehicle/ActiveCompany.jsp?email="+companySchema.Email;
										MailUtil mailUtil = new MailUtil(userxSchema.Userx,subject,body);
										mailUtil.send();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	int userID = (Integer)session.getAttribute("ID");
	userxSchema = blUserx.getSchema(userID);
	LogxSchema logxSchema = new LogxSchema();
	logxSchema.CompanyID = userxSchema.CompanyID;
	logxSchema.UserxID = userxSchema.ID;
	logxSchema.LoggedTime = MiscTool.getNow();
	logxSchema.Memo = "新建公司";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新建公司</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
		<%
			if(!listDB.isEmpty())
			{
		%>
				alert("该公司名已被占用");
				window.history.go(-1);
		<%
				logxSchema.Operation = "新建公司失败";
			}
			else if(flagEmail==false)
			{
		%>
				alert("请输入有效的邮箱地址");
				window.history.go(-1);
		<%
			}
			else if(count1>0||count2>0)
			{
		%>
				alert("该邮箱已经被占用");
				window.history.go(-1);
		<%
				logxSchema.Operation = "新建公司失败";
			}
			else if(userx2UserGroupFlag)
			{
		%>
				alert("注册成功,请前往邮箱激活！");
				window.location.href = "company.jsp";
		<%
				logxSchema.Operation = "新建公司成功";
			}
			else 
			{
		%>
				alert("新建公司失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "新建公司失败";
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
										<h2>新建公司</h2>
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
<%@ include file="closeCon.jspf"%>	