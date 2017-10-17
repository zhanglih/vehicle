<!--
	描述：用户组更新结果处理
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
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID=Integer.parseInt(request.getParameter("ID").trim());
		BLUserGroup blUserGroup = new BLUserGroup(con);
		UserGroupSchema userGroupSchema=blUserGroup.getSchema(ID);
		
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
		
//		userGroupSchema.IsEnabled = Integer.valueOf(isEnabled);
		userGroupSchema.Namex = MiscTool.getUTF8FromISO(namex);
		userGroupSchema.Memo = MiscTool.getUTF8FromISO(memo);
		userGroupSchema.Permissionx = MiscTool.getUTF8FromISO(pp);
		
		boolean flag = false;
		//&&flagisEnabled
		if(!flagNamex&&!flagNamex1&&!flagNamex2&&flagPermissionx)
		{
			flag = blUserGroup.update(userGroupSchema);
		}
		
		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "修改用户组信息";
%>
<!DOCTYPE HTML>
<html>
	<head>
    
		<title>用户组-修改结果处理</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
		<%
			if(flag)
			{
		%>
				window.location.href="userGroupInto.jsp";
		<%
				logxSchema.Operation = "修改用户组信息成功";
			}
			else
			{
		%>
				alert("修改用户组信息失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "修改用户组信息失败";
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