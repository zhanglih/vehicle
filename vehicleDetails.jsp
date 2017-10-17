<!--
    描述:车辆详情
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
 		response.sendRedirect("login.jsp");

	String id=request.getParameter("id");

	if(id.length()>0)
	{
		//可变数组
 		String[] status={"正常","转让","停用","报废"};
 		String[] useTypes={"商用","其他"};
 		String[] oilTypes={"汽油","柴油","油电混合","电动"};

		BLVehicle blVehicle=new BLVehicle(con);
		VehicleSchema vehicleSchema=blVehicle.getSchema(Integer.parseInt(id));
		if(vehicleSchema!=null)
		{
			String plateNumber=vehicleSchema.PlateNumber;//车牌号
			String VIN=vehicleSchema.VIN;//车辆识别码
			String brand=vehicleSchema.Brand;//品牌
			String model=vehicleSchema.Model;//型号
			String engineType=vehicleSchema.EngineType;//发动机型号
			String engineNumber=vehicleSchema.EngineNumber;//发动机号
			String purchasedDate=vehicleSchema.PurchasedDate;//购买日期
			double initialMileage=vehicleSchema.InitialMileage;//初始里程
			int useType=vehicleSchema.UseType;//使用性质
			int oilType=vehicleSchema.OilType;//燃油类型
			int statusx=vehicleSchema.Statusx;//状态
			String ownerName=vehicleSchema.OwnerName;//车主
			String ownerTel=vehicleSchema.OwnerTel;//车主电话
			int isEnabled=vehicleSchema.IsEnabled;//是否启用
			String memo=vehicleSchema.Memo;//备注
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>车辆详细信息</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
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
										<h2><%=plateNumber%></h2>
									</header>

									<div class="table-wrapper">
										<table class="alt">
											<tbody>
												<tr>
													<td>车辆识别码（VIN）</td>
													<td width="60%"><%=VIN%></td>
												</tr>
												<tr>
													<td>品牌</td>
													<td><%=brand%></td>
												</tr>
												<tr>
													<td>型号</td>
													<td><%=model%></td>
												</tr>
												<tr>
													<td>发动机型号</td>
													<td><%=engineType%></td>
												</tr>
												<tr>
													<td>发动机号</td>
													<td><%=engineNumber%></td>
												</tr>
												<tr>
													<td>购买日期</td>
													<td><%=purchasedDate%></td>
												</tr>
												<tr>
													<td>初始里程</td>
													<td><%=initialMileage%>KM</td>
												</tr>
												<tr>
													<td>使用性质</td>
													<td><%=useTypes[useType-1]%></td>
												</tr>
												<tr>
													<td>燃油类型</td>
													<td><%=oilTypes[oilType-1]%></td>
												</tr>
												<tr>
													<td>状态</td>
													<td><%=status[statusx-1]%></td>
												</tr>
												<tr>
													<td>车主</td>
													<td><%=ownerName%></td>
												</tr>
												<tr>
													<td>车主电话</td>
													<td><%=ownerTel%></td>
												</tr>
												<tr>
													<td>是否启用</td>
													<td><%=isEnabled==1?"启用":"不启用"%></td>
												</tr>
												<tr>
													<td>备注</td>
													<td><%=memo%></td>
												</tr>
											</tbody>
											<!-- <tfoot>
												<tr>
													<td colspan="2"></td>
													<td>100.00</td>
												</tr>
											</tfoot> -->

										</table>
										<ul class="actions">
											<li><input type="button" value="修改" class="special" onclick="window.location.href='updateVehicle.jsp?id=<%=vehicleSchema.ID%>'"/></li>
											<li><input type="button" value="返回" onclick="window.location.href='vehicle.jsp'"></li>
										</ul>
										
									</div>

								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>

	</body>
</html>
<%
		}
		else
		{
		%>
			<script language="javascript">
				alert("不存在该数据");
				window.history.go(-1);
			</script>
		<%
		}
	}
%>
<%@ include file="closeCon.jspf"%>
