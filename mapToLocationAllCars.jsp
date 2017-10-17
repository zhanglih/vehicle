<!--
	描述:Root用户登录后所有车辆位置地图实时显示
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="java.util.*"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		BLCompany blCompany = new BLCompany(con);
		BLVehicle blVehicle = new BLVehicle(con);
		BLDriveInfo blDriveInfo = new BLDriveInfo(con);

		VehicleSchema vehicleSchema = null;
		DriveInfoSchema driveInfoSchema = null;
		double longitude = 103.388611;
		double latitude = 35.563611;
		int engineCondition = 0;

		String whereClause = "1=1";
		List result = blVehicle.select(whereClause);
		List results = null;
		List<String> list = new ArrayList<String>();
		for(Object objs : result)
		{
			vehicleSchema = (VehicleSchema)objs;
			whereClause = "VehicleVIN = '" + vehicleSchema.VIN + "' ORDER BY UploadedTime DESC";
			results = blDriveInfo.select(whereClause);
			if(!results.isEmpty())
			{
				Object obj = results.get(0);
				driveInfoSchema = (DriveInfoSchema)obj;
				String locationx = driveInfoSchema.Locationx;
				String information = locationx + "," + driveInfoSchema.EngineCondition; 
				list.add(information);
			}
		}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#container {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
		<title>GPS定位</title>
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
			                            <h2>位置地图实时显示</h2>
			                        </header>
			                        <div id="container"></div>
								</section>
						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
			</div>
		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

		<script src="http://webapi.amap.com/maps?v=1.3&key=e32c22ad1a13d90e5c211db46113383e"></script>
    	<script type="text/javascript" src="http://cache.amap.com/lbs/static/addToolbar.js"></script>
		<script type="text/javascript">
		var map = new AMap.Map('container', {
	        resizeEnable: true,
	        zoom:5,
	        center: [105,34]
	    });
		<%
			if(!list.isEmpty())
			{
		%>
				var infoWindow = new AMap.InfoWindow({offset: new AMap.Pixel(0, -30)});
		<%
				for (int i = 0; i < list.size(); i++) 
				{
					String[] pos = list.get(i).split(",");
					longitude = Double.parseDouble(pos[0]);
					latitude = Double.parseDouble(pos[1]);
					engineCondition = Integer.parseInt(pos[2]);

					if(engineCondition == 1)
					{
		%>
						var marker =new AMap.Marker({
					        map: map,
							position: [<%=longitude%>, <%=latitude%>],
					        icon: new AMap.Icon({            
					            size: new AMap.Size(26, 13),  //图标大小
					            image: "img/map/car_green.png",
					            imageOffset: new AMap.Pixel(0, 0)
					        })        
					    });
		<%
					}
					if(engineCondition == 2)
					{
		%>
						var marker = new AMap.Marker({
					        map: map,
							position: [<%=longitude%>, <%=latitude%>],
					        icon: new AMap.Icon({            
					            size: new AMap.Size(26, 13),  //图标大小
					            image: "img/map/car_red.png",
					            imageOffset: new AMap.Pixel(0, 0)
					        })        
					    });
		<%
					}
					if(engineCondition == 3)
					{
		%>
						var marker = new AMap.Marker({
					        map: map,
							position: [<%=longitude%>, <%=latitude%>],
					        icon: new AMap.Icon({            
					            size: new AMap.Size(26, 13),  //图标大小
					            image: "img/map/car_yellow.png",
					            imageOffset: new AMap.Pixel(0, 0)
					        })        
					    });
		<%
					}
					if(engineCondition == 4)
					{
		%>
						var marker = new AMap.Marker({
					        map: map,
							position: [<%=longitude%>, <%=latitude%>],
					        icon: new AMap.Icon({            
					            size: new AMap.Size(26, 13),  //图标大小
					            image: "img/map/car_scarlet.png",
					            imageOffset: new AMap.Pixel(0, 0)
					        })        
					    });
		<%
					}
					if(engineCondition == 5)
					{
		%>
						var marker = new AMap.Marker({
					        map: map,
							position: [<%=longitude%>, <%=latitude%>],
					        icon: new AMap.Icon({            
					            size: new AMap.Size(26, 13),  //图标大小
					            image: "img/map/car_gray.png",
					            imageOffset: new AMap.Pixel(0, 0)
					        })        
					    });
		<%
					}
		%>
					marker.content = "车牌号："+"<%=vehicleSchema.PlateNumber%>"+"<br/>"+"定位时间："+"<%=driveInfoSchema.UploadedTime%>";
			        marker.on('click', markerClick);
			        marker.emit('click', {target: marker});
		<%
				}
		%>
				function markerClick(e) {
			        infoWindow.setContent(e.target.content);
			        infoWindow.open(map, e.target.getPosition());
			    }

				map.setFitView();
		<%
			}
		%>
		</script>
	</body>
</html>
<%
	}
%>
<%@ include file="closeCon.jspf"%>