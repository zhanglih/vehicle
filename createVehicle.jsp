<!--
    描述:新建车辆
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
    	response.sendRedirect("login.jsp");
    else
    {
	    //获得CompanyID
	    int sessionID=(Integer)session.getAttribute("ID");
	    BLUserx blUserx=new BLUserx(con);
	    UserxSchema userxSchema=blUserx.getSchema(sessionID);
 		String companyID=request.getParameter("companyID");
 		if(companyID==null || "".equals(companyID))
 		{
	    	companyID=userxSchema.CompanyID+"";
 		}

	    //可变数组
 		String[] status={"正常","转让","停用","报废"};
 		String[] useTypes={"商用","其他"};
 		String[] oilTypes={"汽油","柴油","油电混合","电动"};
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>新增车辆</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script type="text/javascript">
			function trim(str)
			{
				return str.replace(/(^\s+)|(\s+$)/g,"");
			}
			function checkPlateNumber()
			{
				var plateNumber=$("#PlateNumber").val();
				//alert(plateNumber);
		    	if (plateNumber.length == 7)
		    	{
		    		var regex = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
		    		result = plateNumber.match(regex);
		    		if(result)
		    			return true;
		    	}
		      	else
		      		return false;
			}
			function isPlateNumber()
			{
				if(!checkPlateNumber())
				{
					alert("无效的车牌！");
					document.form.PlateNumber.focus();
				}
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

				//车牌号
				if(!checkPlateNumber())
		      	{
		      		alert("请输入正确的车牌号！");
					document.form.PlateNumber.focus();
		      		return false;
		      	}
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
	</head>
	<body onLoad="JavaScript:form.PlateNumber.focus()">

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
										<h2>新增车辆</h2>
									</header>
									<form method="post" action="createVehicleResult.jsp" name="form">
										<div class="row uniform">
											<!-- CompanyID -->
                                        	<input type="hidden" name="CompanyID" value="<%=companyID%>">
											<!-- 车牌号 -->
											<div class="12u$"><label for="PlateNumber">车牌号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="PlateNumber" id="PlateNumber" value="" placeholder="请输入七位有效车牌，如：京A12345" maxlength="10" required="required" onchange="isPlateNumber()"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车辆识别码 -->
											<div class="12u$"><label for="VIN">VIN</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="VIN" id="VIN" value="" placeholder="车辆识别码" maxlength="17" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 品牌 -->
											<div class="12u$"><label for="Brand">品牌</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="Brand" id="Brand" value="" placeholder="" maxlength="30" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 型号 -->
                                        	<div class="12u$"><label for="Model">型号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="Model" id="Model" value="" placeholder="" maxlength="30"/>
                                        	</div>
											<!-- 发动机型号 -->
											<div class="12u$"><label for="EngineType">发动机型号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="EngineType" id="EngineType" value="" placeholder="" maxlength="20"/>
                                        	</div>
											<!-- 发动机号 -->
											<div class="12u$"><label for="EngineNumber">发动机号</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="EngineNumber" id="EngineNumber" value="" placeholder="" maxlength="20" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 购买日期 -->
											<div class="12u$"><label for="PurchasedDate">购买日期</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="PurchasedDate" id="PurchasedDate" value="" placeholder="单击请选择" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 初始里程 -->
											<div class="12u$"><label for="InitialMileage">初始里程</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="InitialMileage" id="InitialMileage" value="" placeholder="单位：KM" onBlur="overFormat(this)" required="required"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 使用性质 -->
											<div class="12u$"><label for="UseType">使用性质</label></div>
                                        	<div class="6u 12u$(xsmall) select-wrapper">
												<select name="UseType" id="UseType" required="required">
													<option value="">请选择</option>
													<%
														for(int i=1;i<=useTypes.length;i++)
														{
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
													<option value="">请选择</option>
												   	<%
														for(int i=1;i<=oilTypes.length;i++)
														{
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
													<option value="">请选择</option>
													<%
														for(int i=1;i<=status.length;i++)
														{
															out.println("<option value='"+i+"'>"+status[i-1]+"</option>");
														}
													%>
												</select>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车主 -->
											<div class="12u$"><label for="OwnerName">车主</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<input type="text" name="OwnerName" id="OwnerName" value="" placeholder="车主姓名" maxlength="30"/>
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 车主电话 -->
                                        	<div class="12u$"><label for="OwnerTel">车主电话</label></div>
                                        	<div class="6u 12u$(xsmall)" title="请输入数字">
                                            	<input type="text" name="OwnerTel" id="OwnerTel" maxlength="20" onkeyup="value=value.replace(/[^(\d)]/g,'')" placeholder="手机" required="required" />
                                        	</div>
                                        	<div class="6u 12u$(xsmall)" style="color:red">*</div>
											<!-- 是否启用 -->
											<div class="12u$"><label for="IsEnabled">启用</label></div>
                                           	<div class="6u 12u$(xsmall)">
	                                            <input type="radio" id="isEnabled" name="IsEnabled" value="1" checked>
	                                            <label for="isEnabled">是</label>
	                                            <input type="radio" id="disEnabled" name="IsEnabled" value="0">
	                                            <label for="disEnabled">否</label>
                                        	</div>
											<!-- 备注 -->
											<div class="12u$"><label for="Memo">备注</label></div>
                                        	<div class="6u 12u$(xsmall)">
                                            	<textarea name="Memo" id="Memo" placeholder="" rows="3"></textarea>
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
			
	</body>
</html>
<%
}
%>
<%@ include file="closeCon.jspf"%>
