<!--
    描述:更新车辆处理
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
    	response.sendRedirect("login.jsp");
    else
    {
        //获取参数
        int id=Integer.parseInt(request.getParameter("id"));
        String VIN=request.getParameter("VIN");//车辆识别码
        String brand=request.getParameter("Brand");//品牌
        String model=request.getParameter("Model");//型号
        String engineType=request.getParameter("EngineType");//发动机型号
        String engineNumber=request.getParameter("EngineNumber");//发动机号
        String purchasedDate=request.getParameter("PurchasedDate");//购买日期
        String useType=request.getParameter("UseType");//使用性质
        String oilType=request.getParameter("OilType");//燃油类型
        String statusx=request.getParameter("Statusx");//状态
        String ownerName=request.getParameter("OwnerName");//车主
        String ownerTel=request.getParameter("OwnerTel");//车主电话
        String isEnabled=request.getParameter("IsEnabled");//启用
        String memo=request.getParameter("Memo");//备注

        BLVehicle blVehicle=new BLVehicle(con);
        VehicleSchema vehicleSchema=blVehicle.getSchema(id);
       	vehicleSchema.VIN=MiscTool.getUTF8FromISO(VIN);//车辆识别码
        vehicleSchema.Brand=MiscTool.getUTF8FromISO(brand);//品牌
        vehicleSchema.Model=MiscTool.getUTF8FromISO(model);//型号
        vehicleSchema.EngineType=MiscTool.getUTF8FromISO(engineType);//发动机型号
        vehicleSchema.EngineNumber=MiscTool.getUTF8FromISO(engineNumber);//发动机号
        vehicleSchema.PurchasedDate=MiscTool.getUTF8FromISO(purchasedDate);//购买日期
        vehicleSchema.UseType=Integer.parseInt(useType);//使用性质
        vehicleSchema.OilType=Integer.parseInt(oilType);//燃油类型
        vehicleSchema.Statusx=Integer.parseInt(statusx);//状态
        vehicleSchema.OwnerName=MiscTool.getUTF8FromISO(ownerName);//车主
        vehicleSchema.OwnerTel=MiscTool.getUTF8FromISO(ownerTel);//车主电话
        vehicleSchema.IsEnabled=Integer.parseInt(isEnabled);//启用
        vehicleSchema.Memo=MiscTool.getUTF8FromISO(memo);//备注

        BLUserx blUserx = new BLUserx(con);
        BLLogx blLogx = new BLLogx(con);
        int userID = (Integer)session.getAttribute("ID");
        UserxSchema userxSchema = blUserx.getSchema(userID);
        
        LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userxSchema.CompanyID;
        logxSchema.UserxID = userxSchema.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "更新车辆信息";

        boolean flag=blVehicle.update(vehicleSchema);
        if(flag)
        {
%>
    		<script type="text/javascript">
    			window.location.href="vehicle.jsp";
    		</script>
<%
    	   logxSchema.Operation = "更新车辆信息成功";
        }
    	else
    	{
%>
    		<script type="text/javascript">
    			alert("更新失败");
    			window.history.go(-1);
    		</script>
<%
    	   logxSchema.Operation = "更新车辆信息失败";
        }
        blLogx.insert(logxSchema);
    }
%>
<%@ include file="closeCon.jspf"%>
