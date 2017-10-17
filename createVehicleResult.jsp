<!--
    描述:新建车辆处理
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
        String companyID=request.getParameter("CompanyID");//公司ID
        String plateNumber=request.getParameter("PlateNumber");//车牌号
        String VIN=request.getParameter("VIN");//车辆识别码
        String brand=request.getParameter("Brand");//品牌
        String model=request.getParameter("Model");//型号
        String engineType=request.getParameter("EngineType");//发动机型号
        String engineNumber=request.getParameter("EngineNumber");//发动机号
        String purchasedDate=request.getParameter("PurchasedDate");//购买日期
        String initialMileage=request.getParameter("InitialMileage");//初始里程
        String useType=request.getParameter("UseType");//使用性质
        String oilType=request.getParameter("OilType");//燃油类型
        String statusx=request.getParameter("Statusx");//状态
        String ownerName=request.getParameter("OwnerName");//车主
        String ownerTel=request.getParameter("OwnerTel");//车主电话
        String isEnabled=request.getParameter("IsEnabled");//是否启用
        String memo=request.getParameter("Memo");//备注

        VehicleSchema vehicleSchema=new VehicleSchema();
        vehicleSchema.CompanyID=Integer.parseInt(companyID);
        vehicleSchema.PlateNumber=MiscTool.getUTF8FromISO(plateNumber);
        vehicleSchema.VIN=MiscTool.getUTF8FromISO(VIN);
        vehicleSchema.Brand=MiscTool.getUTF8FromISO(brand);
        vehicleSchema.Model=MiscTool.getUTF8FromISO(model);
        vehicleSchema.EngineType=MiscTool.getUTF8FromISO(engineType);
        vehicleSchema.EngineNumber=MiscTool.getUTF8FromISO(engineNumber);
        vehicleSchema.PurchasedDate=MiscTool.getUTF8FromISO(purchasedDate);
        vehicleSchema.InitialMileage=Double.parseDouble(initialMileage);
        vehicleSchema.UseType=Integer.parseInt(useType);
        vehicleSchema.OilType=Integer.parseInt(oilType);
        vehicleSchema.Statusx=Integer.parseInt(statusx);
        vehicleSchema.OwnerName=MiscTool.getUTF8FromISO(ownerName);
        vehicleSchema.OwnerTel=MiscTool.getUTF8FromISO(ownerTel);
        vehicleSchema.IsEnabled=Integer.parseInt(isEnabled);
        vehicleSchema.Memo=MiscTool.getUTF8FromISO(memo);

        BLUserx blUserx = new BLUserx(con);
        BLLogx blLogx = new BLLogx(con);
        int userID = (Integer)session.getAttribute("ID");
        UserxSchema userxSchema = blUserx.getSchema(userID);
        
        LogxSchema logxSchema = new LogxSchema();
        logxSchema.CompanyID = userxSchema.CompanyID;
        logxSchema.UserxID = userxSchema.ID;
        logxSchema.LoggedTime = MiscTool.getNow();
        logxSchema.Memo = "新增车辆";

        BLVehicle blVehicle=new BLVehicle(con);
        boolean flag=blVehicle.insert(vehicleSchema);
        if(flag)
        {
%>
        	<script type="text/javascript">
        		window.location.href="vehicle.jsp";
        	</script>
<%
            logxSchema.Operation = "新增车辆成功";
        }
        else
        {
%>
        	<script type="text/javascript">
        		alert("新增失败");
        		window.history.go(-1);
        	</script>
<%
    	   logxSchema.Operation = "新增车辆失败";
        }
        blLogx.insert(logxSchema);
    }
%>
<%@ include file="closeCon.jspf"%>
