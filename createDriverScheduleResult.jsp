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
    else
    {
		String companyID=request.getParameter("CompanyID");//公司ID，必须要有公司ID
		if(companyID==null || "".equals(companyID))
		{
%>
			<script type="text/javascript">
				alert("数据异常，请重试！");
				window.history.go(-1);
			</script>
<%
		}
		//数据表设计有缺陷，暂时没有CompanyID字段，更新jar包解锁此字段
		String driverxID=request.getParameter("driver");
		String vehicleID=request.getParameter("plateNumber");
		String startTime=request.getParameter("startTime");
		String endTime=request.getParameter("endTime");

		DriverScheduleSchema driverScheduleSchema=new DriverScheduleSchema();
		driverScheduleSchema.DriverxID=Integer.parseInt(driverxID);
		driverScheduleSchema.VehicleID=Integer.parseInt(vehicleID);
		driverScheduleSchema.CompanyID=Integer.parseInt(companyID);
		driverScheduleSchema.StartTime=MiscTool.getUTF8FromISO(startTime);
		driverScheduleSchema.EndTime=MiscTool.getUTF8FromISO(endTime);

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "新增排班信息";

		BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
		boolean flag=blDriverSchedule.insert(driverScheduleSchema);
		if(flag)
		{
%>
			<script type="text/javascript">
				window.location.href="driverSchedule.jsp";
			</script>
<%
			logxSchema.Operation = "新增排班信息成功";
		}
		else
		{
%>
			<script type="text/javascript">
				alert("新增失败");
				window.history.go(-1);
			</script>
<%
			logxSchema.Operation = "新增排班信息失败";
		}
		blLogx.insert(logxSchema);
	}
%>
<%@ include file="closeCon.jspf"%>
