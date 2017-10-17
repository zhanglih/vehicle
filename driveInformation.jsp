<!--
	描述：行车信息查询页面
    作者：张力
    手机： 15201162896
    微信： 15201162896
    日期： 2017-06-07

-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="java.util.List"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="java.math.BigDecimal"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else{
		
		String keyWord = MiscTool.getUTF8FromISO(request.getParameter("keyword"));
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		
		//根据页面输入的车牌号去车辆表中查询数据拿到VehicleVIN
		BLVehicle blVehicle = new BLVehicle(con);
		String whereClauseforVe = "PlateNumber='"+keyWord+"'";
		
		Integer ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		Integer CompanyID = userxSchema.CompanyID;
		String Userx = userxSchema.Userx;
		String whereClauseforAll = "";
		if("root".equals(userxSchema.Userx))
		{
			whereClauseforAll = "1=1";
		}
		else
		{
			whereClauseforAll = "1=1 AND CompanyID ="+CompanyID ;
		}
		
		List allVehicle = blVehicle.select(whereClauseforAll);
		
		List vehicleResult = blVehicle.select(whereClauseforVe);
		String VIN = "";
		int OilType = 0;
		for(Object obj:vehicleResult)
		{
			VehicleSchema vehicleSchema=(VehicleSchema)obj;
			VIN =  vehicleSchema.VIN;
			OilType = vehicleSchema.OilType;
		}
		String whereClause = "";
		if(keyWord!=null)
		{
			 whereClause = "VehicleVIN='"+VIN+"' and oilquantity != '' AND mileage !='' and UploadedTime between '"+startDate+"' and '"+endDate+"' ORDER BY UploadedTime ASC" ;
		}
		else
		{
			 whereClause = "1=2";
		}
		BLDriveInfo BLDriveInfo = new BLDriveInfo(con);
		List result = BLDriveInfo.select(whereClause);
		int size  = result.size();
		Double oilQuantity = 0.0;
		Double mileage = 0.0;
		
		Double mileageStart = 0.0;
		Double mileageEnd = 0.0;
		
		Double oilQuantityStart = 0.0;
		Double oilQuantityEnd = 0.0;
		
		String show = "";
		/*
		for(Object obj:result)
		{
			DriveInfoSchema driveInfoSchema=(DriveInfoSchema)obj;
			oilQuantity = oilQuantity+Double.parseDouble(driveInfoSchema.OilQuantity);
			mileage = mileage+Double.parseDouble(driveInfoSchema.Mileage);
		}*/
		
		
		if(size > 0)
		{
			
			/*
			for(int i=0;i<result.size();i++)
			{
				if(i == 0)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)result.get(i);
					
					String m = driveInfoSchema.Mileage;
					mileageStart = Double.parseDouble(m);
					
					String o = driveInfoSchema.OilQuantity;
					oilQuantityStart = Double.parseDouble(o);
				}
				if(i == result.size()-1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)result.get(i);
					
					String m = driveInfoSchema.Mileage;
					mileageEnd = Double.parseDouble(m);
					
					String o = driveInfoSchema.OilQuantity;
					oilQuantityEnd = Double.parseDouble(o);
				}
			}
			*/
			
			if(size == 1)
			{
				DriveInfoSchema driveInfoSchema = (DriveInfoSchema)result.get(0);
				
				String m = driveInfoSchema.Mileage;
				mileage = Double.parseDouble(m);
				
				String o = driveInfoSchema.OilQuantity;
				oilQuantity = Double.parseDouble(o);
				
				mileage = mileage/1000;
				
				if(OilType == 2)
				{
					oilQuantity = oilQuantity/1000/3;
					BigDecimal b = new BigDecimal(oilQuantity);
					oilQuantity =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue();  
					
				}
				else
				{
					oilQuantity = oilQuantity/1000;
				}
				
			}
			else
			{
				DriveInfoSchema driveInfoSchema = (DriveInfoSchema)result.get(0);
				String  a = driveInfoSchema.OilQuantity;
				oilQuantityStart = Double.valueOf(a);
				String b = driveInfoSchema.Mileage;
				mileageStart = Double.valueOf(b);
			
				
				driveInfoSchema = (DriveInfoSchema)result.get(result.size()-1);
				String  a1 = driveInfoSchema.OilQuantity;
				oilQuantityEnd = Double.valueOf(a1);
				String b1 = driveInfoSchema.Mileage;
				mileageEnd = Double.valueOf(b1);
				
				mileage = (mileageEnd - mileageStart)/1000;
		
				if(OilType == 2)
				{
					oilQuantity = (oilQuantityEnd - oilQuantityStart)/1000/3;
					BigDecimal b2 = new BigDecimal(oilQuantity);
					oilQuantity =  b2.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue(); 
				}
				else
				{
					oilQuantity = (oilQuantityEnd - oilQuantityStart)/1000;
				}
				
			}
		}
	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>行车信息</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script>
			function verify(){
				var keyword = form.keyword.value;
				var startDate = form.startDate.value;
				var endDate = form.endDate.value;
				
				/*
				if(keyword==null||keyword=="")
				{
					alert("请输入车牌号");
					document.getElementById("keyword").focus();//设置焦点
					return false;
				}
				*/
				
				if(keyword=="n")
				{
					alert("请选择车牌号");
					document.getElementById("keyword").focus();//设置焦点
					return false;
				}
				
				
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
					if(keyWord!=null)
					{
				%>
						document.getElementById("keyword").value = '<%=keyWord%>';
				<%				
					}
				%>
				
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
										<h2>行车信息</h2>
									</header>
									<form method="post" action="driveInformation.jsp" onsubmit="return verify();" name="form" style="margin-bottom:0">
										<div class="row uniform">
											<div class="3u 9u$(xsmall) select-wrapper">
												<select name="keyword" id="keyword">
												    <option value="n">车牌号</option>
													<%
													  for(Object obj:allVehicle)
													  {
														VehicleSchema vehicleSchema = (VehicleSchema)obj;
													%>
														<option value="<%=vehicleSchema.PlateNumber%>"><%=vehicleSchema.PlateNumber%></option>
													<%
													  }
													%>
												</select>
											</div>
											<div class="3u 6u$(xsmall)">
												<input type="text" id="startDate" name="startDate" placeholder="开始日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value=""/>
											</div>
											<div class="3u 6u$(xsmall)">
												<input type="text" id="endDate" name="endDate" placeholder="结束日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" />
											</div>
											<div class="2u 3u$(xsmall)">
												<div class="12u$">
													<ul class="actions">
														<li><input type="submit" value="查询" class="special" /></li>
													</ul>
												</div>
											</div>
											<!-- Break -->

										</div>
									</form>
									<div class="table-wrapper">
										<table class="alt" id="table">
											<tbody style="text-align:center">
											<tr>
												<td width="30%"><strong>车牌号</strong></td>
												<td width="30%"><strong>油耗/l</strong></td>
												<td width="30%"><strong>里程/km</strong></td>
											</tr>
											<!-- 逐行显示 -->
											<%
												if(size>0)
												{
											%>
													<tr>
														<td width="30%"><strong><%=keyWord%></strong></td>
														<td width="30%"><strong><%=oilQuantity%></strong></td>
														<td width="30%"><strong><%=mileage%></strong></td>
													</tr>
											<%
												}
											%>
											

											</tbody>
											<tfoot>
												<tr>
													<td colspan="6" style="text-align:center">
													</td>
												</tr>
											</tfoot>
										</table>
										<input id="Button1" type="button" value="导出EXCEL"onclick="tableToExcel('table','数据如下')" /> 
									</div>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>
			</div>
		<!-- Scripts -->
			<%@ include file="scripts.jspf"%> 
			<SCRIPT LANGUAGE="javascript">  
				  var tableToExcel = (function () {
						  var uri = 'data:application/vnd.ms-excel;base64,',
						  template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><?xml version="1.0" encoding="UTF-8" standalone="yes"?><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
						  base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
						  format = function (s, c) {
								return s.replace(/{(\w+)}/g,
								function (m, p) { return c[p];})
						  }
						  return function (table, name) {
							 if (!table.nodeType) table = document.getElementById(table)
							 var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
							 window.location.href = uri + base64(format(template, ctx))
						  }
				  })()
		    </SCRIPT>  
	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>
