<!--
    描述:更新车辆
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

    //可变数组
	String[] status={"正常","转让","停用","报废"};
	String[] useTypes={"商用","其他"};
	String[] oilTypes={"汽油","柴油","油电混合","电动"};

    int id=Integer.parseInt(request.getParameter("id"));
    BLVehicle blVehicle=new BLVehicle(con);
    VehicleSchema vehicleSchema=blVehicle.getSchema(id);
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
		<title>更新车辆</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
	</head>
	<body onLoad="JavaScript:form.VIN.focus()">

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
										<h2></h2>
									</header>
									<form method="post" action="updateVehicleResult.jsp?id=<%=id%>" name="form">
										<div class="row uniform">
											<!-- 车牌号 -->
											<div class="12u$"><label for="PlateNumber">车牌号</label></div>
                                        	<div class="6u 12u$(xsmall)" title="车牌号不能修改">
                                            	<input type="text" name="PlateNumber" id="PlateNumber" value="<%=plateNumber%>" maxlength="10" required="required" readonly="true" />
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车辆识别码 -->
											<div class="12u$"><label for="VIN">VIN</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="VIN" id="VIN" value="<%=VIN%>" placeholder="车辆识别码" maxlength="17" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 品牌 -->
											<div class="12u$"><label for="Brand">品牌</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="Brand" id="Brand" value="<%=brand%>" placeholder="" maxlength="30" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 型号 -->
                                        	<div class="12u$"><label for="Model">型号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="Model" id="Model" value="<%=model%>" placeholder="" maxlength="30"/>
                                        	</div>
											<!-- 发动机型号 -->
											<div class="12u$"><label for="EngineType">发动机型号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="EngineType" id="EngineType" value="<%=engineType%>" placeholder="" maxlength="20" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 发动机号 -->
											<div class="12u$"><label for="EngineNumber">发动机号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="EngineNumber" id="EngineNumber" value="<%=engineNumber%>" placeholder="" maxlength="20" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 购买日期 -->
											<div class="12u$"><label for="PurchasedDate">购买日期</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="PurchasedDate" id="PurchasedDate" value="<%=purchasedDate%>" placeholder="格式为YYYY-MM-DD" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 初始里程 -->
											<div class="12u$"><label for="InitialMileage">初始里程</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="InitialMileage" id="InitialMileage" value="<%=initialMileage%>" placeholder="单位：KM" required="required" readonly="true"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 使用性质 -->
											<div class="12u$"><label for="UseType">使用性质</label></div>
                                        	<div class="6u 12u$(xsmall) select-wrapper">
												<select name="UseType" id="UseType" required="required">
													<%
													   	for(int i=1;i<=useTypes.length;i++)
													   	{	
													   		if(i==useType)
													   		{
													   			out.println("<option selected value='"+i+"'>"+useTypes[i-1]+"</option>");
													   			continue;
													   		}
													   		out.println("<option value='"+i+"'>"+useTypes[i-1]+"</option>");
													   	}
													%>
												</select>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 燃油类型 -->
											<div class="12u$"><label for="OilType">燃油类型</label></div>
                                        	<div class="6u 12u$(xsmall) select-wrapper">
												<select name="OilType" id="OilType" required="required">
												   	<%
														for(int i=1;i<=oilTypes.length;i++)
														{
															if(i==oilType)
															{
																out.println("<option selected value='"+i+"'>"+oilTypes[i-1]+"</option>");
																continue;
															}
															out.println("<option value='"+i+"'>"+oilTypes[i-1]+"</option>");
														}
													%>
												</select>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 状态 -->
											<div class="12u$"><label for="Statusx">状态</label></div>
                                        	<div class="6u 12u$(xsmall) select-wrapper">
												<select name="Statusx" id="Statusx" required="required">
													<%
														for(int i=1;i<=status.length;i++)
														{
															if(i==statusx)
															{
																out.println("<option selected value='"+i+"'>"+status[i-1]+"</option>");
																continue;
															}
															out.println("<option value='"+i+"'>"+status[i-1]+"</option>");
														}
													%>
												</select>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车主 -->
											<div class="12u$"><label for="OwnerName">车主</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="OwnerName" id="OwnerName" value="<%=ownerName%>" placeholder="车主姓名" maxlength="30" required/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车主电话 -->
                                        	<div class="12u$"><label for="OwnerTel">车主电话</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="OwnerTel" id="OwnerTel" maxlength="20" onkeyup="value=value.replace(/[^(\d)]/g,'')" placeholder="手机" required="required" value="<%=ownerTel%>" />
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 是否启用 -->
											<div class="12u$"><label for="IsEnabled">启用</label></div>
                                           	<div class="6u 12u$(xsmall)">
	                                            <input type="radio" id="isEnabled" name="IsEnabled" value="1" <%if(isEnabled==1)out.print("checked");%>>
	                                            <label for="isEnabled">是</label>
	                                            <input type="radio" id="disEnabled" name="IsEnabled" value="0" <%if(isEnabled==0)out.print("checked");%>>
	                                            <label for="disEnabled">否</label>
                                        	</div>
											<!-- 备注 -->
											<div class="12u$"><label for="Memo">备注</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<textarea name="Memo" id="Memo" placeholder="" rows="3" value="<%=memo%>"></textarea>
                                        	</div>
											<!-- Break -->
											<div class="12u$">
												<ul class="actions">
													<li><input type="submit" value="提交" class="special" onClick="return check()"/></li>
													<li><input type="reset" value="重置" /></li>
												</ul>
											</div>
										</div>
									</form>
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<%@ include file="sidebar.jspf"%>

			</div>

		<!-- Scripts -->
			<%@ include file="scripts.jspf"%>
			<script type="text/javascript">
				function trim(str)
				{
					return str.replace(/(^\s+)|(\s+$)/g,"");
				}
				function overFormat(th)
				{
					var v = th.value;
				    if(v === ''){
				        v = '0.00';
				    }else if(v === '0'){
				        v = '0.00';
				    }else if(v === '0.'){
				        v = '0.00';
				    }else if(/^0+\d+\.?\d*.*$/.test(v)){
				        v = v.replace(/^0+(\d+\.?\d*).*$/, '$1');
				        v = inp.getRightPriceFormat(v).val;
				    }else if(/^0\.\d$/.test(v)){
				        v = v + '0';
				    }else if(!/^\d+\.\d{2}$/.test(v)){
				        if(/^\d+\.\d{2}.+/.test(v)){
				            v = v.replace(/^(\d+\.\d{2}).*$/, '$1');
				        }else if(/^\d+$/.test(v)){
				            v = v + '.00';
				        }else if(/^\d+\.$/.test(v)){
				            v = v + '00';
				        }else if(/^\d+\.\d$/.test(v)){
				            v = v + '0';
				        }else if(/^[^\d]+\d+\.?\d*$/.test(v)){
				            v = v.replace(/^[^\d]+(\d+\.?\d*)$/, '$1');
				        }else if(/\d+/.test(v)){
				            v = v.replace(/^[^\d]*(\d+\.?\d*).*$/, '$1');
				            ty = false;
				        }else if(/^0+\d+\.?\d*$/.test(v)){
				            v = v.replace(/^0+(\d+\.?\d*)$/, '$1');
				            ty = false;
				        }else{
				            v = '0.00';
				        }
				    }
				    th.value = v; 
				}
				function check()
				{
					var re = /[`~!@#$%^&*()+=|{}':;',.<>?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]/im;
					var date_regex=/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/;
					var phoneReg=/^1[3|4|5|7|8][0-9]\d{4,8}$/;

			      	//VIN
					var vin=$("#VIN").val();		      	
					if(re.test(vin))
					{
						alert("VIN中存在特殊字符，请重新输入");
						document.getElementById("VIN").focus();//设置焦点
						return false;
					}
					//品牌
					var brand=$("#Brand").val();
					if(re.test(brand))
					{
						alert("品牌中存在特殊字符，请重新输入");
						document.getElementById("Brand").focus();//设置焦点
						return false;
					}
					

			      	//手机号码
			      	var phoneNumber=$("#OwnerTel").val();
			      	if(!phoneReg.test(phoneNumber)){
			      		alert("请输入正确的手机号");
			      		document.getElementById("OwnerTel").focus();//设置焦点
			      		return false;
			      	}
				}
			</script>
	</body>
</html>
<%@ include file="closeCon.jspf"%>
