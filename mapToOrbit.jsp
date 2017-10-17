<!--
	描述:车辆轨迹回放页面
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
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		String VIN = request.getParameter("id");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		BLCompany blCompany = new BLCompany(con);
		BLVehicle blVehicle = new BLVehicle(con);
		BLDriveInfo blDriveInfo = new BLDriveInfo(con);

		VehicleSchema vehicleSchema = null;

		String whereClause = "VIN = '" + VIN + "'";
		List lists = blVehicle.select(whereClause);
		for(Object objs : lists)
		{
			vehicleSchema = (VehicleSchema)objs;
		}

		DriveInfoSchema driveInfoSchema = null;
		CompanySchema companySchema = null;
		double longitude = 116.403963;
		double latitude = 39.915119;
		
		whereClause = "VehicleVIN = '" + VIN + "'";

		
		if(startDate == null && endDate == null)
		{
			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			long sysTime = now.getTime();
			long beforeTime = sysTime - 10*60*1000*6;
			Date beforeDate = new Date(beforeTime);
			startDate = sdf.format(beforeDate);
			endDate = MiscTool.getNow();
		}
		

		//按时间的升序排列
//		whereClause = whereClause + " AND Locationx != ''  AND UploadedTime >=' " + startDate + "' AND UploadedTime <'" + endDate + "' ORDER BY UploadedTime ASC" ;
		whereClause = whereClause + " AND Locationx != ''  AND UploadedTime BETWEEN' " + startDate + "' AND '" + endDate + "' ORDER BY UploadedTime ASC" ;

		List result = blDriveInfo.select(whereClause);
		List<String> list = new ArrayList<String>();
		List<String> listStartEnd = new ArrayList<String>();
		if(!result.isEmpty())
		{
			for(Object obj : result)
			{
				driveInfoSchema = (DriveInfoSchema)obj;
				String locationx = driveInfoSchema.Locationx;
				list.add(locationx);
			}
			listStartEnd.add(list.get(0));
			listStartEnd.add(list.get(list.size()-1));
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
		<title>轨迹回放</title>
	</head>
	<body>
		<form name="form" method="post" action="mapToOrbit.jsp?id=<%=vehicleSchema.VIN%>" onsubmit="return addLine();">
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
			                            <h2>轨迹显示</h2>
			                        </header>

									<div class="row uniform">
										<div class="5u 10u$(xsmall)">
											<input type="text" id="startDate" name="startDate" placeholder="开始日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value=""/>
										</div>
										<div class="5u 10u$(xsmall)">
											<input type="text" id="endDate" name="endDate" placeholder="结束日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" />
										</div>
										<div class="2u 4u$(xsmall)">
											<div class="12u$">
												<ul class="actions">
													<li><input type="submit" value="查询" class="special" /></li>
												</ul>
											</div>
										</div>
									</div>
									
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
			<script type="text/javascript" language="JavaScript">
				
				var lineArr = [];

				var map = new AMap.Map('container', {
			        resizeEnable: true,
			        center: [105, 34],
			        zoom: 5
			    });
				
			<%
				if(!result.isEmpty())
				{
					for (int i = 0; i < list.size(); i++) 
					{
						String[] pos = list.get(i).split(",");
						longitude = Double.parseDouble(pos[0]);
						latitude = Double.parseDouble(pos[1]);
			%>
						var point = new AMap.LngLat(<%=longitude%>,<%=latitude%>);
						lineArr.push(point);
			<%
					}
			%>
					var polyline = new AMap.Polyline({
				        path: lineArr,          //设置线覆盖物路径
				        strokeColor: "#00A", //线颜色
				        //strokeOpacity: 1,       //线透明度
				        strokeWeight: 3,        //线宽
				        //strokeStyle: "solid",   //线样式
				        //strokeDasharray: [10, 5] //补充线样式
				    });
				    polyline.setMap(map);


				    //添加起点
					
					
					new AMap.Marker({
				        map: map,
						position: [<%=listStartEnd.get(0).split(",")[0]%>,<%=listStartEnd.get(0).split(",")[1]%>],
				        icon: new AMap.Icon({            
				            size: new AMap.Size(30, 36),  //图标大小
				            image: "img/map/start.png",
				            imageOffset: new AMap.Pixel(-5, -3)
					    })         
				    });
				    

					//添加终点
					
					new AMap.Marker({
				        map: map,
						position: [<%=listStartEnd.get(1).split(",")[0]%>,<%=listStartEnd.get(1).split(",")[1]%>],
				        icon: new AMap.Icon({            
				            size: new AMap.Size(30, 36),  //图标大小
				            image: "img/map/end.png",
				            imageOffset: new AMap.Pixel(-5, -3)
				        })        
				    });

				    var newCenter = map.setFitView();
				 	newCenter.getCenter();
			<%
				}
			%>	
			</script>
			<script language="JavaScript">
				function addLine()
				{
					var startDate=form.startDate.value;
					var endDate=form.endDate.value;

					if(startDate==null||startDate=="")
					{
						alert("请输入开始时间");
						document.getElementById("startDate").focus();//设置焦点
						return false;
					}
				
					if(endDate==null||endDate=="")
					{
						alert("请输入结束时间");
						document.getElementById("endDate").focus();//设置焦点
						return false;
					}
					
				}
				window.onload = function()
				{				
					<%
						if(startDate!=null)
						{
					%>
							document.getElementById("startDate").value = '<%=startDate%>';
					<%				
						}
					%>
					
					<%
						if(endDate!=null)
						{
					%>
							document.getElementById("endDate").value = '<%=endDate%>';
					<%				
						}
					%>
				}
		</script>
		</form>
	</body>
</html>
<%
	}
%>
<%@ include file="closeCon.jspf"%>