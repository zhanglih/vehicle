<!--
	描述：用户组创建
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	
	//add by zhangli 20170607 start
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
	    Integer ID = (Integer)session.getAttribute("ID");
		//add by zhangli 20170607 end
	
		String namex = request.getParameter("namex").trim();
		boolean flagNamex = "".equals(namex);
		int length = MiscTool.getUTF8FromISO(namex).length();
		boolean flagNamex1 = (length>30);
		String regEx="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"; 
		Pattern pattern = Pattern.compile(regEx);
		Matcher matcher = pattern.matcher(MiscTool.getUTF8FromISO(namex));
		boolean flagNamex2 = matcher.find();
		
		
		/*
		String isEnabled = request.getParameter("isEnabled");
		regEx = "[0-9]*";
		pattern = Pattern.compile(regEx);
		matcher = pattern.matcher(isEnabled);
		boolean flagisEnabled = matcher.matches();
		*/
		
		
		String [] permissionx = request.getParameterValues("permissionx");
		length = permissionx.length;
		boolean flagPermissionx = (length>0);
		String pp="";
		for(int i=0;i<permissionx.length;i++)
		{
			pp = pp+permissionx[i]+" ";
		}
		
		String memo = request.getParameter("memo");
		
		BLLogx blLogx = new BLLogx(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		UserGroupSchema userGroupSchema = new UserGroupSchema();
		
//		userGroupSchema.IsEnabled = Integer.valueOf(isEnabled);
		userGroupSchema.Namex = MiscTool.getUTF8FromISO(namex);
		userGroupSchema.Memo = MiscTool.getUTF8FromISO(memo);
		userGroupSchema.Permissionx = MiscTool.getUTF8FromISO(pp);
		
		//add by zhangli 20170607 start
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		userGroupSchema.CompanyID = userxSchema.CompanyID;
		//add by zhangli 20170607 end
		
		boolean flag = false;
		//&&flagisEnabled
		if(!flagNamex&&!flagNamex1&&!flagNamex2&&flagPermissionx)
		{
			flag=blUserGroup.insert(userGroupSchema);
		}
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "新增用户组";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>用户组-创建结果处理</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="userGroupInto.jsp";
		<%
				logxSchema.Operation = "新建用户组成功";
			}
			else
			{
		%>
				alert("新建驾驶员失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "新建用户组失败";
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
										<h2>新建用户组</h2>
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