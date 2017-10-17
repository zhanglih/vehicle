<!--
    描述:删除车辆处理
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
    	response.sendRedirect("login.jsp");

	int id=Integer.parseInt(request.getParameter("id"));
	BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
	List result=blDriverSchedule.select("VehicleID="+id);
	//2017-08-24更新
	BLArea blArea=new BLArea(con);
	List<AreaSchema> relatedArea=blArea.select("VehicleID="+id);
	if(result.isEmpty() && relatedArea.isEmpty()){
		BLVehicle blVehicle=new BLVehicle(con);
		boolean flag=blVehicle.delete(id);

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "删除车辆";

		if(flag)	
		{
%>
			<script type="text/javascript">
				window.location.href="vehicle.jsp";
			</script>
<%
			logxSchema.Operation = "删除车辆成功";
		}
		else
		{
%>
			<script type="text/javascript">
				alert("删除失败");
				window.history.go(-1);
			</script>
<%
			logxSchema.Operation = "删除车辆失败";
		}
		blLogx.insert(logxSchema);
	}
	else
	{
%>
		<script type="text/javascript">
			alert("信息被占用，不能删除");
			window.history.go(-1);
		</script>
<%
	}
%>
<%@ include file="closeCon.jspf"%>
