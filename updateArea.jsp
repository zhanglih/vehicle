<!--
	描述：更新区域
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
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		String ID = request.getParameter("ID");
		BLArea blArea = new BLArea(con);
		AreaSchema areaSchema = blArea.getSchema(Integer.valueOf(ID));
		String locationx = areaSchema.Locationx;
		String longitudDev = areaSchema.LongitudDev;
		String lateralDev = areaSchema.LateralDev;
		String[] splitLocationx = locationx.split(",");
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>更新电子围栏</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
		<script src="http://webapi.amap.com/maps?v=1.3&key=e32c22ad1a13d90e5c211db46113383e&plugin=AMap.PolyEditor,AMap.CircleEditor,AMap.MouseTool"></script>
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
										<h2>更新电子围栏</h2>
									</header>
									<div id="container"></div>
									<div class="button-group">
										<input type="button" class="button" value="开始编辑圆形电子围栏" onClick="editor.startEditCircle()"/>
										<input type="button" class="button" value="结束编辑圆形电子围栏" onClick="editor.closeEditCircle()"/>
										<input type="button" class="button" value="开始编辑多边形电子围栏" onClick="editor.startEditPolygon()"/>
                                        <input type="button" class="button" value="结束编辑多边形电子围栏" onClick="editor.closeEditPolygon()"/>
										<input type="button" class="button" value="保存" id="save" onclick="save()"/>
									</div>
								</section>
						</div>
					</div>
				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
                    <script>
						var map = new AMap.Map("container", {
							resizeEnable: true
						});	
						map.setFitView();
						var flag = 0;
						var circle = 0;
						var poly = 0;
						<%
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
								    
								var editor={};  
								editor._polygon=(function(){
								return new AMap.Polygon({
									map: map,
									path: polygonArr,
									strokeColor: "#1791fc",
									strokeOpacity: 0.2,
									strokeWeight: 3,
									fillColor: "#1791fc",
									fillOpacity: 0.35
								});
								})();

								editor._polygonEditor= new AMap.PolyEditor(map, editor._polygon);
								editor.startEditPolygon=function(){
									editor._polygonEditor.open();
								}
								editor.closeEditPolygon=function(){
									editor._polygonEditor.close();
								}
								var path = '';
								AMap.event.addListener(editor._polygonEditor,"end",function(e){
									path = e.target.Qi.path;
									flag = 1;
									poly = 1;
								});
						<%						
							}
							else
							{
						%>
							  //编辑圆
                              var Arr = new Array();
							  var editor={};
							  Arr[0] = '<%=longitudDev%>';
							  Arr[1] = '<%=lateralDev%>';
							  editor._circle=(function(){
							  var circle = new AMap.Circle({
								  center: Arr,// 圆心位置
								  radius: <%=locationx%>, //半径
								  strokeColor: "#1791fc", //线颜色
								  strokeOpacity: 1, //线透明度
								  strokeWeight: 0, //线粗细度
								  fillColor: "#1791fc", //填充颜色
								  fillOpacity: 0.35//填充透明度
								});
									circle.setMap(map);
									return circle;
								})();
								
								editor._circleEditor = new AMap.CircleEditor(map, editor._circle);
								editor.startEditCircle=function(){
									editor._circleEditor.open();
								}
								editor.closeEditCircle=function(){
									editor._circleEditor.close();
								}
								var radius = '';
								var lng = '';
								var la = '';
								AMap.event.addListener(editor._circleEditor,"end",function(e){
									console.log(e);
									radius = e.target.Qi.radius;
									lng = e.target.Qi.center.lng;
									la = e.target.Qi.center.lat;
									flag = 1;
									circle = 1;
								});
						<%
							}
						%>
						function save(){
							if(flag == 1 && circle==1)
							{
								window.location.href="updateAreaResult.jsp?radius="+radius+"&lng="+lng+"&la="+la+"&ID="+<%=ID%>;
							}
							else if(flag == 1 && poly==1)
							{
								window.location.href="updateAreaResult.jsp?path="+path+"&ID="+<%=ID%>;
							}
							else
							{
								alert("请先编辑电子围栏");
							}
					    }
						
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