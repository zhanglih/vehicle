<!--
	描述： 车队行车信息查询页面
    作者： 张力
    手机： 15201162896
    微信： 15201162896
    日期： 2017-06-09

-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="java.math.BigDecimal"%>
<%@ include file="openCon.jspf"%>
<%
	
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		String company = request.getParameter("company");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		String whereClause = "CompanyID="+company;
		BLVehicle blVehicle = new BLVehicle(con);
		List vehicleResult = blVehicle.select(whereClause);
		
		Double fleetOilQuantity = 0.0;
		Double fleetMileage = 0.0;
		
		List driveInforesult = null;
		for(Object obj:vehicleResult)
		{
			VehicleSchema vehicleSchema = (VehicleSchema)obj;
			String VIN  = vehicleSchema.VIN ;
			int OilType = vehicleSchema.OilType;
			String whereClause1 = "VehicleVIN='"+VIN+"' and oilquantity != '' and mileage !='' AND UploadedTime between '"+startDate+"' and '"+endDate+"'  ORDER BY UploadedTime ASC" ;
			BLDriveInfo BLDriveInfo = new BLDriveInfo(con);
			driveInforesult = BLDriveInfo.select(whereClause1);
			
			double Oilsingle = 0.0;
			double Milsingle = 0.0;
			
			double startMil = 0.0;
			double endMil = 0.0;
			
			double startOil = 0.0;
			double endOil = 0.0;
			

			if(driveInforesult.size()>0)
			{
				
				/*
				for(int i=0;i<driveInforesult.size();i++)
				{
					if(i == 0)
					{
						DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveInforesult.get(i);
						String m = driveInfoSchema.Mileage;
						startMil = Double.parseDouble(m);
						
						String o = driveInfoSchema.OilQuantity;
						startOil = Double.parseDouble(o);
						
					}
					if(i == driveInforesult.size()-1)
					{
						DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveInforesult.get(i);
						String m = driveInfoSchema.Mileage;
						endMil = Double.parseDouble(m);
						
						String o = driveInfoSchema.OilQuantity;
						endOil = Double.parseDouble(o);
					}
				}
				*/
				if(driveInforesult.size() == 1)
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveInforesult.get(0);
					String  a = driveInfoSchema.OilQuantity;
					if(OilType==2)
					{
						 Oilsingle = Double.valueOf(a)/3;
					}
					else
					{
						 Oilsingle = Double.valueOf(a);
					}
					 
					String b = driveInfoSchema.Mileage;
					Milsingle = Double.valueOf(b);
				}
				else
				{
					DriveInfoSchema driveInfoSchema = (DriveInfoSchema)driveInforesult.get(0);
					String  a = driveInfoSchema.OilQuantity;
				    double oilStart = Double.valueOf(a);
				    String b = driveInfoSchema.Mileage;
				    double milStart = Double.valueOf(b);
				
					
					driveInfoSchema = (DriveInfoSchema)driveInforesult.get(driveInforesult.size()-1);
					String  a1 = driveInfoSchema.OilQuantity;
					double oilEnd = Double.valueOf(a1);
					String b1 = driveInfoSchema.Mileage;
					double milEnd = Double.valueOf(b1);
					
					if(OilType==2)
					{
						 
						 Oilsingle = (oilEnd - oilStart)/3;
					}
					else
					{
						 Oilsingle = oilEnd - oilStart;
					}
					
					Milsingle = milEnd - milStart;
				}
				
				 
			}
			
			fleetOilQuantity = fleetOilQuantity + Oilsingle;
			fleetMileage = fleetMileage + Milsingle;
		}
		
		
		fleetOilQuantity = fleetOilQuantity/1000;
		BigDecimal b = new BigDecimal(fleetOilQuantity);
		fleetOilQuantity =  b.setScale(6,BigDecimal.ROUND_HALF_UP).doubleValue(); 
		
		fleetMileage = fleetMileage/1000;
		
		//add zhangli start
		Integer ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		Integer CompanyID = userxSchema.CompanyID;
		String Userx = userxSchema.Userx;
		String whereClauseForCompany = "";
		if("root".equals(userxSchema.Userx))
		{
			whereClauseForCompany = "1=1";
		}
		else
		{
			whereClauseForCompany = "1=1 AND ID = "+CompanyID;
		}
		
		
		BLCompany blCompany = new BLCompany(con);
		List companyResult = blCompany.select(whereClauseForCompany);
		
		CompanySchema CompanySchema  = null;
		String namex = "";
		if(company!=null){
			CompanySchema  = blCompany.getSchema(Integer.parseInt(company));
			namex = CompanySchema.Namex;
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>车队行车信息</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
			function verify()
			{
				var company = form.company.value;
				if(company == 'n')
				{
					alert("请选择公司");
					document.getElementById("company").focus();
					return false;
				}
				
				var startDate = form.startDate.value;
				var endDate = form.endDate.value;
				
				
				if(startDate==null|| startDate=="")
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
										<h2>车队行车信息</h2>
									</header>
									<form method="post" action="fleetDriveInformation.jsp" onsubmit="return verify();" name="form" style="margin-bottom:0">
										<div class="row uniform">
											 <div class="2u 2u$(xsmall)" align="left">
											</div>
											<div class="2u 9u$(xsmall) select-wrapper" align="left" style="float:left; position:relative; left:-150px;">
												<select name="company" id="company">
												    <option value="n">公司名称</option>
													<%
													  for(Object obj:companyResult)
													  {
														CompanySchema companySchema = (CompanySchema)obj;
													%>
														<option value="<%=companySchema.ID%>"><%=companySchema.Namex%></option>
													<%
													  }
													%>
												</select>
											</div>
											<div class="3u 6u$(xsmall)" style="float:left; position:relative; left:-130px;">
												<input type="text" id="startDate" name="startDate" placeholder="开始日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" style="width:230px;"/>
											</div>
											<div class="3u 6u$(xsmall)" style="float:left; position:relative; left:-90px;">
												<input type="text" id="endDate" name="endDate" placeholder="结束日期" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="" style="width:230px;"/>
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
												<td width="30%"><strong>公司名称</strong></td>
												<td width="30%"><strong>油耗/l</strong></td>
												<td width="30%"><strong>里程/km</strong></td>
											</tr>
											<!-- 逐行显示 -->
												<tr>
													<%
														if(vehicleResult.size()>0 && driveInforesult.size()>0)
														{
															
														
													%>
													<td width="30%"><strong><%=namex%></strong></td>
													<td width="30%"><strong><%=fleetOilQuantity%></strong></td>
													<td width="30%"><strong><%=fleetMileage%></strong></td>
													<%
														}
													%>
												</tr>	
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
