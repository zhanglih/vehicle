<!--
	描述：展示地图信息
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-13
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else{
		String ID = request.getParameter("ID");
		BLArea blArea = new BLArea(con);
		AreaSchema areaSchema = blArea.getSchema(Integer.valueOf(ID));
		String locationx = areaSchema.Locationx;
		String longitudDev = areaSchema.LongitudDev;
		String lateralDev = areaSchema.LateralDev;
		String[] splitLocationx = locationx.split(",");
		
%>
<!doctype html>
<html>
	<head>
		<title>区域信息展示</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="GOOGLE=edge">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
		<script src="http://webapi.amap.com/maps?v=1.3&key=e32c22ad1a13d90e5c211db46113383e&plugin=AMap.MouseTool"></script>
		<script type="text/javascript" src="http://cache.amap.com/lbs/static/addToolbar.js"></script>
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#container {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
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
										<h2>电子围栏区域展示</h2>
									</header>
                                    <div id="container"></div>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
                    <script>
						var map = new AMap.Map("container", {
							resizeEnable: true
						});	
						
						<%
							//多边形电子围栏显示
							if("".equals(lateralDev))
							{
						%>
								 var polygonArr = new Array();
								 <%
									for(int i=0;i<splitLocationx.length-1;i=i+2)
									{
								 %>
									 var point = new AMap.LngLat(<%=splitLocationx[i]%>,<%=splitLocationx[i+1]%>);
									 polygonArr.push(point);
								 <%
									}
								 %>
								    
								  var  polygon = new AMap.Polygon({
									path: polygonArr,//设置多边形边界路径
									strokeColor: "#FF33FF", //线颜色
									strokeOpacity: 0.2, //线透明度
									strokeWeight: 3,    //线宽
									fillColor: "#1791fc", //填充色
									fillOpacity: 0.35//填充透明度
								  });
								  polygon.setMap(map);
						<%
							}
							//圆形电子围栏显示
							else
							{
						%>
								var circle = new AMap.Circle({
									center: new AMap.LngLat("<%=longitudDev%>", "<%=lateralDev%>"),// 圆心位置
									radius: <%=locationx%>, //半径
									strokeColor: "#1791fc", //线颜色 浅蓝色
									fillColor: "#1791fc", 
									strokeOpacity: 1, //线透明度
									strokeWeight: 0, //线粗细度
									fillOpacity: 0.35,//填充透明度
									resizeEnable: true
								});
								circle.setMap(map);
						<%
							}
						%>
						map.setFitView();
					</script>
			</div>
		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>