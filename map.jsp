<!--
	描述:接收新建用户数据
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ include file="openCon.jspf"%>
<%
	double longitude = Double.parseDouble(request.getParameter("longitude"));
	double latitude = Double.parseDouble(request.getParameter("latitude"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#allmap {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
		<title>地图展示</title>
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
			                            <h2>地图展示</h2>
			                        </header>
			                        <div id="allmap"></div>
								</section>
						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
			</div>
		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

		<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=YIIt0lPh6hj5oWp4rNft0ztObzz4KHVV"></script>
		<script type="text/javascript">
			// 百度地图API功能
			var map = new BMap.Map("allmap");    // 创建Map实例
			var point = new BMap.Point(<%=longitude%>, <%=latitude%>);
			map.centerAndZoom(point, 14);  // 初始化地图,设置中心点坐标和地图级别
			map.addControl(new BMap.MapTypeControl());   //添加地图类型控件
			map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放

			var myIcon = new BMap.Icon("img/map/car_green.png",new BMap.Size(26,13));
			var marker = new BMap.Marker(point,{icon:myIcon});// 创建标注  
			map.addOverlay(marker);			// 将标注添加到地图中
			
		</script>
	</body>
</html>

<%@ include file="closeCon.jspf"%>