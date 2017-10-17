<!--
	描述：选择区域获取数据
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-09
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		String areaName = request.getParameter("areaName");
		String vehicleID = request.getParameter("vehicle");
		
		
		BLArea blArea = new BLArea(con);
		List list = blArea.select("1=1");
		List list1 = new ArrayList();
		for(Object obj:list)
		{
			AreaSchema areaSchema = (AreaSchema)obj;
			list1.add(areaSchema.VehicleID);
 		}
		boolean flag = list1.contains(Integer.valueOf(vehicleID));		
%>
	 
<!DOCTYPE HTML>
<html>
	<head>
		<title>创建电子围栏</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="GOOGLE=edge">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
		<script src="http://webapi.amap.com/maps?v=1.3&key=e32c22ad1a13d90e5c211db46113383e&plugin=AMap.MouseTool"></script>
		<script type="text/javascript" src="http://cache.amap.com/lbs/static/addToolbar.js"></script>
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#container {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
		
		<script type="text/javascript">
		<%
			if(flag)
			{
		%>
				alert("车辆已存在电子围栏");
				window.history.go(-1);
		<%		
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
										<h2>电子围栏区域展示</h2>
									</header>
                                    <div id="container"></div>
									<div class="button-group">
										<input type="button" class="button" value="圆形电子围栏" id="circle"/>
										<input type="button" class="button" value="多边形电子围栏" id="polygon"/>
										<input type="button" class="button" value="保存" id="save" onclick="save()"/>
									</div>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>
			<script>
					var map = new AMap.Map("container", {
						resizeEnable: true
					});	
					
					//在地图中添加MouseTool插件
					var mouseTool = new AMap.MouseTool(map);
					//画圆
					AMap.event.addDomListener(document.getElementById('circle'), 'click', function() {
						mouseTool.circle();
					}, false);
					//画多边形
					 AMap.event.addDomListener(document.getElementById('polygon'), 'click', function() {
						mouseTool.polygon();
					}, false);
					
					
					var flag = 0;
					var circleFlag = 0;
					var polygonFlag = 0;
					
					
					var arry = '';
					AMap.event.addDomListener(document.getElementById('polygon'), 'click', function() {
						AMap.event.addListener(mouseTool,"draw",function(e){
							console.log(e);
							var polygon = e.obj;
							arry = polygon.getPath();
							console.log(arry);
							flag = 1;
							polygonFlag = 1;
						});
					});
					
					
					var radius = '';
					var lng = '';
					var lat = '';
					AMap.event.addDomListener(document.getElementById('circle'), 'click', function() {
						//获取圆形覆盖物的中心点坐标与半径
						AMap.event.addListener(mouseTool,"draw",function(e){
							var circle = e.obj;
							var center = circle.getCenter();
							lat = circle.getCenter().lat;
							lng = circle.getCenter().lng;
							radius = circle.getRadius();
							console.log(lat);
							console.log(lng);
							console.log(radius);
							flag = 1;
							circleFlag = 1;
						});
					});
					
					function save(){
						//获得圆相关信息保存至数据库
						var areaName = '<%=areaName%>';
						var vehicleID = '<%=vehicleID%>';
						if(flag == 1 && circleFlag == 1)
						{
							window.location.href="saveArea.jsp?radius="+radius+"&lng="+lng+"&la="+lat+"&areaName="+areaName+"&vehicleID="+vehicleID;	
						}
						else if(flag == 1 && polygonFlag == 1)
						{
							window.location.href="saveArea.jsp?arry="+arry+"&areaName="+areaName+"&vehicleID="+vehicleID;
						}
						else
						{
							alert("请先选择围栏范围");
						}
					}
					map.setFitView();
			</script>
	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>