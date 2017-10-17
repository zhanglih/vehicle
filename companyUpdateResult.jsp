<!--
	描述:接收修改公司信息界面传递的数据并作出响应。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
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
		int ID = Integer.parseInt(request.getParameter("id"));

		BLCompany blCompany=new BLCompany(con);
		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);

		String namex = request.getParameter("namex");
		String contactPerson = request.getParameter("contactPerson");
		String tel = request.getParameter("tel");
		String mobile = request.getParameter("mobile");
		String email = request.getParameter("email");
		String website = request.getParameter("website");
		String address = request.getParameter("address");
		String postcode = request.getParameter("postcode");
		String isEnabled = request.getParameter("isEnabled");
		String memo = request.getParameter("memo");
		String registeredTime = request.getParameter("registeredTime");

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

		CompanySchema companySchema = blCompany.getSchema(ID);

		companySchema.Namex = MiscTool.getUTF8FromISO(namex);
		companySchema.ContactPerson = MiscTool.getUTF8FromISO(contactPerson);
		companySchema.Tel = tel;
		companySchema.Mobile = mobile;
		companySchema.Email = email;
		companySchema.Website = MiscTool.getUTF8FromISO(website);
		companySchema.Address = MiscTool.getUTF8FromISO(address);
		companySchema.Postcode = postcode;
		companySchema.IsEnabled = Integer.parseInt(isEnabled);
		companySchema.Memo = MiscTool.getUTF8FromISO(memo);

		boolean flag = false;
		
		
		if(!nameFlag1&&nameFlag2&&!nameFlag3&&!contactPersonFlag1&&contactPersonFlag2&&!contactPersonFlag3&&telFlag&&!mobileFlag1&&mobileFlag2&&!emailFlag1&&emailFlag2&&!addressFlag&&postcodeFlag&&websiteFlag&&memoFlag)
		{
			flag = blCompany.update(companySchema);
		}
		
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "修改公司资料";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>修改信息</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
			<%
				if(flag)
				{
			%>
					window.location.href="company.jsp";
			<%
					logxSchema.Operation = "修改公司资料成功";
				}
				else
				{
			%>
					alert("公司信息修改失败");
					window.history.go(-1);
			<%
					logxSchema.Operation = "修改公司资料失败";
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
			                            <h2>修改公司信息</h2>
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
