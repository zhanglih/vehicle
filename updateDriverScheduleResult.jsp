<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverScheduleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
    	response.sendRedirect("login.jsp");

    String id=request.getParameter("id");
	String vehicleID=request.getParameter("plateNumber");
	String startTime=request.getParameter("startTime");
	String endTime=request.getParameter("endTime");

	BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
	DriverScheduleSchema driverScheduleSchema=blDriverSchedule.getSchema(Integer.parseInt(id));
	driverScheduleSchema.VehicleID=Integer.parseInt(vehicleID);
	driverScheduleSchema.StartTime=MiscTool.getUTF8FromISO(startTime);
	driverScheduleSchema.EndTime=MiscTool.getUTF8FromISO(endTime);

	boolean flag=blDriverSchedule.update(driverScheduleSchema);

	BLUserx blUserx = new BLUserx(con);
	BLLogx blLogx = new BLLogx(con);
	int userID = (Integer)session.getAttribute("ID");
	UserxSchema userxSchema = blUserx.getSchema(userID);
	
	LogxSchema logxSchema = new LogxSchema();
	logxSchema.CompanyID = userxSchema.CompanyID;
	logxSchema.UserxID = userxSchema.ID;
	logxSchema.LoggedTime = MiscTool.getNow();
	logxSchema.Memo = "更新驾驶员排班信息";

	if(flag)
	{
%>
		<script type="text/javascript">
			window.location.href="driverSchedule.jsp";
		</script>
<%
		logxSchema.Operation = "更新驾驶员排班信息成功";
	}
	else
	{
%>
		<script type="text/javascript">
			alert("更新失败");
			window.history.go(-1);
		</script>
<%
		logxSchema.Operation = "更新驾驶员排班信息失败";
	}
	blLogx.insert(logxSchema);
%>
<%@ include file="closeCon.jspf"%>
