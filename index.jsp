<!--
	描述:登陆页面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.05.31
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="java.math.BigDecimal"%>
<%@ include file="openCon.jspf"%>
<%
	 if(session.getAttribute("ID")==null)
	 {
		response.sendRedirect("login.jsp");
	 }
	 else
	 {
		 List dataList = new ArrayList();
		 DateFormat df2 = new SimpleDateFormat("MM.dd");
		 for(int i=0;i<=6;i++){
			 Calendar calendar = Calendar.getInstance();  
			 Date date=new Date(); 
			 calendar.setTime(date);
			 calendar.add(Calendar.DAY_OF_MONTH, -i);
			 date = calendar.getTime();
			 dataList.add(df2.format(date));
		 }
		 
		
		//保存今天向后推7天的日期
		SimpleDateFormat myFmt=new SimpleDateFormat("yyyy-MM-dd");
		List dataList2 = new ArrayList();
		for(int i=0;i<=6;i++)
		{
			 Calendar calendar = Calendar.getInstance();  
			 Date date=new Date(); 
			 calendar.setTime(date);
			 calendar.add(Calendar.DAY_OF_MONTH, -i);
			 date = calendar.getTime();
			 dataList2.add(myFmt.format(date));
		}
		
		
		String whereClause = "1=1";
		int id=(Integer)session.getAttribute("ID");
	    BLUserx blUserx = new BLUserx(con);
		String userx = blUserx.getSchema(id).Userx;
		int companyID = blUserx.getSchema(id).CompanyID;
		if(!"root".equals(userx))
		{
			whereClause = "1=1 AND CompanyID = "+companyID;
		}
		
		BLVehicle blVehicle = new BLVehicle(con);
		List vehiceList = blVehicle.select(whereClause);
		double day1Oil = 0.0;
		double day2Oil = 0.0;
		double day3Oil = 0.0;
		double day4Oil = 0.0;
		double day5Oil = 0.0;
		double day6Oil = 0.0;
		double day7Oil = 0.0;
		
		double day1Mil = 0.0;
		double day2Mil = 0.0;
		double day3Mil = 0.0;
		double day4Mil = 0.0;
		double day5Mil = 0.0;
		double day6Mil = 0.0;
		double day7Mil = 0.0;
		
		
		
		BLDriveInfo blDriveInfo = new BLDriveInfo(con);
		for(Object obj:vehiceList)
		{
			VehicleSchema vehicleSchema = (VehicleSchema)obj;
			String vin = vehicleSchema.VIN;
			int OilType = vehicleSchema.OilType;
			
			//查询车辆今天的油耗数据
			String whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(0)+"' AND oilquantity != '' AND mileage !='' order by uploadedtime asc";
			List  driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day1Oil = day1Oil + oil/3;
					}
					else
					{
						day1Oil = day1Oil + oil;
					}
					
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day1Mil = day1Mil + mil;
				}
				else 
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					double oil = oilEnd - oilStart;
					
					if(OilType==2)
					{
						day1Oil = day1Oil + oil/3;
					}
					else
					{
						day1Oil = day1Oil+oil;
					}
					
					double mil = milEnd - milStart;
					day1Mil = day1Mil + mil;
					
				}
			}
			
			
			
			//前一天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(1)+"' AND oilquantity != '' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day2Oil = day2Oil + oil/3;
					}
					else
					{
						day2Oil = day2Oil + oil;
					}
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day2Mil = day2Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day2Oil = day2Oil+oil/3;
					}
					else
					{
						day2Oil = day2Oil+oil;
					}
					double mil = milEnd - milStart;
					day2Mil = day2Mil + mil;
				}
			}
			
			
			
			//前两天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(2)+"' AND oilquantity != '' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day3Oil = day3Oil + oil/3;
					}
					else
					{
						day3Oil = day3Oil + oil;
					}
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day3Mil = day3Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day3Oil = day3Oil + oil/3;
					}
					else
					{
						day3Oil = day3Oil + oil;
					}
					
					double mil = milEnd - milStart;
					day3Mil = day3Mil + mil;
				}
			}
			
			
			
			//前三天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(3)+"' AND oilquantity != '' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					
					if(OilType==2)
					{
						day4Oil = day4Oil + oil/3;
					}
					else
					{
						day4Oil = day4Oil + oil;
					}
					
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day4Mil = day4Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day4Oil = day4Oil + oil/3;
					}
					else
					{
						day4Oil = day4Oil + oil;
					}
					
					double mil = milEnd - milStart;
					day4Mil = day4Mil + mil;
				}
			}
			
			//前四天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(4)+"' AND oilquantity !='' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day5Oil = day5Oil + oil/3;
					}
					else
					{
						day5Oil = day5Oil + oil;
					}
					
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day5Mil = day5Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day5Oil = day5Oil + oil/3;
					}
					else
					{
						day5Oil = day5Oil + oil;
					}
					
					double mil = milEnd - milStart;
					day5Mil = day5Mil + mil;
				}
			}
			
			
			
			
			//前五天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(5)+"' AND oilquantity !='' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day6Oil = day6Oil + oil/3;
					}
					else
					{
						day6Oil = day6Oil + oil;
					}
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day6Mil = day6Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day6Oil = day6Oil + oil/3;
					}
					else
					{
						day6Oil = day6Oil + oil;
					}
					
					double mil = milEnd - milStart;
					day6Mil = day6Mil + mil;
				}
			}
			
			
			
			//前六天
			whereClause1 = "VehicleVIN= '"+vin+"' AND  to_char(uploadedtime,'YYYY-MM-DD') like '"+dataList2.get(6)+"' AND oilquantity !='' AND mileage !='' order by uploadedtime asc";
			driveinfoList = blDriveInfo.select(whereClause1);
			if(driveinfoList.size()>0)
			{
				if(driveinfoList.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oil = Double.valueOf(a);
					if(OilType==2)
					{
						day7Oil = day7Oil + oil/3;
					}
					else
					{
						day7Oil = day7Oil + oil;
					}
					
					
					String b = driveInfoSchema.Mileage;
					double mil = Double.valueOf(b);
					day7Mil = day7Mil + mil;
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveinfoList.get(0);
					String  a = driveInfoSchema.OilQuantity;
					double oilStart = Double.valueOf(a);
					String b = driveInfoSchema.Mileage;
					double milStart = Double.valueOf(b);
					
					driveInfoSchema = (DriveInfoSchema)driveinfoList.get(driveinfoList.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					
					double oil = oilEnd - oilStart;
					if(OilType==2)
					{
						day7Oil = day7Oil + oil/3;
					}
					else
					{
						day7Oil = day7Oil + oil;
					}
					
					double mil = milEnd - milStart;
					day7Mil = day7Mil + mil;
				}
			}
			
		}
		
		//油耗图标展示集合
		
		List oilShow = new ArrayList();
		
		BigDecimal b = new BigDecimal(day1Oil/1000);
		day1Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day2Oil/1000);
		day2Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day3Oil/1000);
		day3Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day4Oil/1000);
		day4Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day5Oil/1000);
		day5Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day6Oil/1000);
		day6Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		b = new BigDecimal(day7Oil/1000);
		day7Oil =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();
		
		
		
		oilShow.add(day1Oil);
		oilShow.add(day2Oil);
		oilShow.add(day3Oil);
		oilShow.add(day4Oil);
		oilShow.add(day5Oil);
		oilShow.add(day6Oil);
		oilShow.add(day7Oil);
		
		//里程图标展示集合
		List milShow = new ArrayList();
		milShow.add(day1Mil/1000);
		milShow.add(day2Mil/1000);
		milShow.add(day3Mil/1000);
		milShow.add(day4Mil/1000);
		milShow.add(day5Mil/1000);
		milShow.add(day6Mil/1000);
		milShow.add(day7Mil/1000);
		
		
		//首页地图展示
		BLCompany blCompany = new BLCompany(con);
		VehicleSchema vehicleSchema = null;
		DriveInfoSchema driveInfoSchema = null;
		double longitude = 103.388611;
		double latitude = 35.563611;
		int engineCondition = 0;
		List result = blVehicle.select(whereClause);
		List results = null;
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>欢迎页面</title>
		<meta charset="utf-8" />
		<meta http-equiv="refresh" content="30">
		<%@ include file="head.jspf"%>
		<style type="text/css">
			#container {width: 60em;height: 40em;overflow: hidden;margin:0;font-family:"微软雅黑";}
		</style>
	</head>
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<%@ include file="header.jspf"%>

							<!-- Content -->
								<section>
									<div id="container"></div>
									<header class="main">
                                        <div id="main1" style="width:400px;height:300px;float:left;display:inline;"></div>
										<div id="main2" style="width:400px;height:300px;float:left; display:inline;"></div>
									</header>
									
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
				// 基于准备好的dom，初始化echarts实例
				var myChart = echarts.init(document.getElementById('main1'));
				//java集合转换为js数组
				var dataArr=new Array();
		        <%
					for(int i=0;i<dataList.size();i++)
					{
				%>
						dataArr[<%=i%>]='<%=dataList.get(i)%>';
				<%
					}
				%>
				
				
				var oilShow=new Array();
		        <%
					for(int i=0;i<oilShow.size();i++)
					{
				%>
						oilShow[<%=i%>]='<%=oilShow.get(i)%>';
				<%
					}
				%>
				
				var milShow=new Array();
		        <%
					for(int i=0;i<milShow.size();i++)
					{
				%>
						milShow[<%=i%>]='<%=milShow.get(i)%>';
				<%
					}
				%>
				
				// 指定图表的配置项和数据
				var option = {
					title: {
						text: '车辆7天内油耗(单位:l)'
					},
					tooltip: {},
					legend: {
						data:['销量']
					},
					xAxis: {
						data: dataArr
					},
					yAxis: {
					},
					series: [{
						type: 'bar',
						data: oilShow
					}]
				};
				// 使用刚指定的配置项和数据显示图表。
				myChart.setOption(option);
				
				
				
				
				
				// 基于准备好的dom，初始化echarts实例
				var myChart2 = echarts.init(document.getElementById('main2'));
				//java集合转换为js数组
				// 指定图表的配置项和数据
				var option1 = {
					title: {
						text: '车辆7天内里程(单位:km)'
					},
					tooltip: {},
					legend: {
						data:['销量']
					},
					xAxis: {
						data: dataArr
					},
					yAxis: {
					},
					series: [{
						type: 'bar',
						data: milShow
					}]
				};
				// 使用刚指定的配置项和数据显示图表。
				myChart2.setOption(option1);
				
				
				
				
				var map = new AMap.Map('container', {
					resizeEnable: true,
					zoom:5,
					center: [105,34]
				});
				<%
					if(!result.isEmpty())
					{
				%>
						var infoWindow = new AMap.InfoWindow({offset: new AMap.Pixel(0, -30)});
						var marker;
				<%
						for(Object objs : result)
						{
							vehicleSchema = (VehicleSchema)objs;

							whereClause = "VehicleVIN = '" + vehicleSchema.VIN + "' AND EngineCondition != 1 ORDER BY UploadedTime DESC";
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

							whereClause = "VehicleVIN = '" + vehicleSchema.VIN + "' AND Locationx != '' ORDER BY UploadedTime DESC";
							results = blDriveInfo.select(whereClause);
							if(!results.isEmpty())
							{
								Object obj = results.get(0);
								driveInfoSchema = (DriveInfoSchema)obj;

								String[] pos = driveInfoSchema.Locationx.split(",");
								longitude = Double.parseDouble(pos[0]);
								latitude = Double.parseDouble(pos[1]);
								engineCondition = driveInfoSchema.EngineCondition;

								
								if(engineCondition1 == 2)
								{
									if(driveInfoSchema.VehicleSpeed>120)
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
									else
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
								else if(engineCondition1 == 3)
								{
									if(locationx1.equals(driveInfoSchema.Locationx))
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
									else
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
								else if(engineCondition1 == 4)
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
								else if(engineCondition1 == 5)
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
								else
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
							    marker.content = "车牌号："+"<%=vehicleSchema.PlateNumber%>"+"<br/>"+"车速："+"<%=driveInfoSchema.VehicleSpeed%>km/h"+"<br/>"+"转速："+"<%=driveInfoSchema.RotatingSpeed%>rpm"+"<br/>"+"电压："+"<%=driveInfoSchema.Voltage%>V"+"<br/>"+"定位时间："+"<%=driveInfoSchema.UploadedTime%>";
								marker.on('click', markerClick);
								marker.emit('click', {target: marker});

				<%
							}
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
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>	