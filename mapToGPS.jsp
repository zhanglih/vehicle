<!--
	描述:GPS定位功能
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
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.*"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		String VIN = request.getParameter("id");

		BLDriveInfo blDriveInfo = new BLDriveInfo(con);
		BLVehicle blVehicle = new BLVehicle(con);

		VehicleSchema vehicleSchema = null;
		DriveInfoSchema driveInfoSchema = null;
		double longitude = 105;
		double latitude = 34;

		String whereClause = "VIN = '" + VIN + "'";
		List listV = blVehicle.select(whereClause);
		if(!listV.isEmpty())
		{
			for(Object objV : listV)
			{
				vehicleSchema = (VehicleSchema)objV;
			}
		}

		whereClause = "VehicleVIN = '" + VIN + "' AND EngineCondition != 1 ORDER BY UploadedTime DESC";
		List result1 = blDriveInfo.select(whereClause);
		int engineCondition1 = 1;
		String time1 = "";
		String locationx1 = "";

		if(!result1.isEmpty())
		{
			Object obj = result1.get(0);
			driveInfoSchema = (DriveInfoSchema)obj;
			engineCondition1 = driveInfoSchema.EngineCondition; 
			time1 = driveInfoSchema.UploadedTime;
			locationx1 = driveInfoSchema.Locationx;
		}

		whereClause = "VehicleVIN = '" + VIN + "' AND Locationx != '' ORDER BY UploadedTime DESC";
		List result = blDriveInfo.select(whereClause);
		if(!result.isEmpty())
		{
			Object obj = result.get(0);
			driveInfoSchema = (DriveInfoSchema)obj;
			String locationx = driveInfoSchema.Locationx;
			String[] list = locationx.split(",");
			longitude = Double.parseDouble(list[0]);
			latitude = Double.parseDouble(list[1]);
		}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="refresh" content="30">
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#container {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
		<style type="text/css">
	        .info 
	        {
	            border: solid 1px silver;
	        }
	        div.info-top 
	        {
	            position: relative;
	            background: none repeat scroll 0 0 #F9F9F9;
	            border-bottom: 1px solid #CCC;
	            border-radius: 5px 5px 0 0;
	        }
	        div.info-top div 
	        {
	            display: inline-block;
	            color: #333333;
	            font-size: 14px;
	            font-weight: bold;
	            line-height: 31px;
	            padding: 0 10px;
	        }
	        div.info-top img 
	        {
	            position: absolute;
	            top: 10px;
	            right: 10px;
	            transition-duration: 0.25s;
	        }
	        div.info-top img:hover 
	        {
	            box-shadow: 0px 0px 5px #000;
	        }
	        div.info-middle 
	        {
	            font-size: 12px;
	            padding: 6px;
	            line-height: 20px;
	        }
	        div.info-bottom 
	        {
	            height: 0px;
	            width: 100%;
	            clear: both;
	            text-align: center;
	        }
	        div.info-bottom img 
	        {
	            position: relative;
	            z-index: 104;
	        }
	        span 
	        {
	            margin-left: 5px;
	            font-size: 11px;
	        }
	        .info-middle img 
	        {
	            float: left;
	            margin-right: 6px;
	        }
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
			                            <h2>GPS定位</h2>
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
		        center: [<%=longitude%>, <%=latitude%>]
		    });
		    var marker;
		    var content;
		<%
			if(!result.isEmpty())
			{
				if(engineCondition1 == 2)	//超速报警
				{
					if(driveInfoSchema.VehicleSpeed>120)	//当前速度仍超速
					{
		%>
						marker = new AMap.Marker({
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
					else	//当前速度已回复正常
					{
		%>
						marker = new AMap.Marker({
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
				}
				else if(engineCondition1 == 3)	//怠速报警
				{
					if(locationx1.equals(driveInfoSchema.Locationx))	//怠速报警后车辆后仍在原地
					{
		%>
						marker = new AMap.Marker({
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
					else	//车辆已行驶
					{
		%>
						marker = new AMap.Marker({
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
				}
				else if(engineCondition1 == 4)	//疲劳驾驶报警
				{
		%>
					marker = new AMap.Marker({
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
				else if(engineCondition1 == 5)	//熄火报警
				{
		%>
					marker = new AMap.Marker({
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
				else	//正常行驶
				{
		%>
					marker = new AMap.Marker({
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
		%>
				var newCenter = map.setFitView();
				newCenter.getCenter();

		        AMap.event.addListener(marker, 'click', function() {
		        	infoWindow.open(map, marker.getPosition());
		        });

		        
		        var title = '车辆代维系统',
		        content = [];
				content.push("车牌号："+"<%=vehicleSchema.PlateNumber%>");
				content.push("车速："+"<%=driveInfoSchema.VehicleSpeed%>km/h");
				content.push("转速："+"<%=driveInfoSchema.RotatingSpeed%>rpm");
				content.push("电压："+"<%=driveInfoSchema.Voltage%>V");
				content.push("定位时间："+"<%=driveInfoSchema.UploadedTime%>");
			    var infoWindow = new AMap.InfoWindow({
			        isCustom: true,  //使用自定义窗体
			        content: createInfoWindow(title, content.join("<br/>")),
			        offset: new AMap.Pixel(16, -50)
			    });

			    function createInfoWindow(title, content) {
			        var info = document.createElement("div");
			        info.className = "info";

			        //可以通过下面的方式修改自定义窗体的宽高
			        //info.style.width = "400px";
			        // 定义顶部标题
			        var top = document.createElement("div");
			        var titleD = document.createElement("div");
			        var closeX = document.createElement("img");
			        top.className = "info-top";
			        titleD.innerHTML = title;
			        closeX.src = "http://webapi.amap.com/images/close2.gif";
			        closeX.onclick = closeInfoWindow;

			        top.appendChild(titleD);
			        top.appendChild(closeX);
			        info.appendChild(top);

			        // 定义中部内容
			        var middle = document.createElement("div");
			        middle.className = "info-middle";
			        middle.style.backgroundColor = 'white';
			        middle.innerHTML = content;
			        info.appendChild(middle);

			        // 定义底部内容
			        var bottom = document.createElement("div");
			        bottom.className = "info-bottom";
			        bottom.style.position = 'relative';
			        bottom.style.top = '0px';
			        bottom.style.margin = '0 auto';
			        var sharp = document.createElement("img");
			        sharp.src = "http://webapi.amap.com/images/sharp.png";
			        bottom.appendChild(sharp);
			        info.appendChild(bottom);
			        return info;
			    }
		        
		         //关闭信息窗体
			    function closeInfoWindow() {
			        map.clearInfoWindow();
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