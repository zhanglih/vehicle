<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
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
		int id=Integer.parseInt(request.getParameter("id"));
		BLDriverSchedule blDriverSchedule=new BLDriverSchedule(con);
		boolean flag=blDriverSchedule.delete(id);

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);
		int userID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(userID);
		
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "删除驾驶员排班信息";

		if(flag)	
		{
%>
			<script type="text/javascript">
				window.location.href="driverSchedule.jsp";
			</script>
<%
			logxSchema.Operation = "删除驾驶员排班信息成功";
		}
		else
		{
%>
			<script type="text/javascript">
				alert("删除失败");
				window.history.go(-1);
			</script>
<%
			logxSchema.Operation = "删除驾驶员排班信息成功";
		}
		blLogx.insert(logxSchema);
	}
%>
<%@ include file="closeCon.jspf"%>