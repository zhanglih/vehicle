<!--
	描述:删除公司用户界面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverScheduleSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriverSchedule"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.*"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		int ID = Integer.parseInt(request.getParameter("id"));

		BLUserx blUserx = new BLUserx(con);
		BLCompany blCompany = new BLCompany(con);
		BLUserGroup blUserGroup = new BLUserGroup(con);
		BLVehicle blVehicle = new BLVehicle(con);
		BLArea blArea = new BLArea(con);
		BLDriverSchedule blDriverSchedule = new BLDriverSchedule(con);
		BLDriver blDriver = new BLDriver(con);
		BLLogx blLogx = new BLLogx(con);

		CompanySchema companySchema = null;
		UserxSchema userxSchema = null;
		VehicleSchema vehicleSchema = null;

		String whereClause = "";
		boolean flagUserx = false;
		boolean flagGroup = false;
		boolean flagCompany = false;
		boolean flagVehicle = false;
		boolean flagArea = false;
		boolean flagDriverSchedule = false;
		boolean flagDriver = false;
		boolean flagLogx = false;
		
		whereClause = "ParentID = " + ID;
		List list = blCompany.select(whereClause);
		whereClause = "CompanyID = " + ID ;
		if(list.size()==0)
		{
			List listUserx = blUserx.select(whereClause);
			if(listUserx.size()>0)
				flagUserx = blUserx.delete(whereClause);
			else
				flagUserx = true;

			List listUserGroup = blUserGroup.select(whereClause);
			if(listUserGroup.size()>0)
				flagGroup = blUserGroup.delete(whereClause);
			else
				flagGroup = true;
			
			List listVehicle = blVehicle.select(whereClause);
			if(listVehicle.size()>0)
			{
				for(Object objV : listVehicle)
				{
					vehicleSchema = (VehicleSchema)objV;
					String whereClause1 = "VehicleID = " + vehicleSchema.ID;
					List listArea = blArea.select(whereClause1);
					if(listArea.size()>0)
						flagArea = blArea.delete(whereClause1);
					else
						flagArea = true;

					List listDriverSchedule = blDriverSchedule.select(whereClause1);
					if(listDriverSchedule.size()>0)
						flagDriverSchedule = blDriverSchedule.delete(whereClause1);
					else
						flagDriverSchedule = true;
				}
				flagVehicle = blVehicle.delete(whereClause);
			}
			else
			{
				flagVehicle = true;
				flagArea = true;
				flagDriverSchedule = true;
			}

			List listDriver = blDriver.select(whereClause);
			if(listDriver.size()>0)
				flagDriver = blDriver.delete(whereClause);
			else
				flagDriver = true;

			List listLogx = blLogx.select(whereClause);
			if(listLogx.size()>0)
				flagLogx = blLogx.delete(whereClause);
			else
				flagLogx = true;

			flagCompany = blCompany.delete(ID);
		}
		else
		{
			CompanySchema companyParent = blCompany.getSchema(ID);
			list.add(companyParent);
			for(Object obj : list)
			{
				companySchema = (CompanySchema)obj;
				whereClause = "CompanyID = " + companySchema.ID;
				List listVehicle = blVehicle.select(whereClause);
				if(listVehicle.size()>0)
				{
					for(Object objV : listVehicle)
					{
						vehicleSchema = (VehicleSchema)objV;
						String whereClause1 = "VehicleID = " + vehicleSchema.ID;
						List listArea = blArea.select(whereClause1);
						if(listArea.size()>0)
							flagArea = blArea.delete(whereClause1);
						else
							flagArea = true;

						List listDriverSchedule = blDriverSchedule.select(whereClause1);
						if(listDriverSchedule.size()>0)
							flagDriverSchedule = blDriverSchedule.delete(whereClause1);
						else
							flagDriverSchedule = true;
					}
					flagVehicle = blVehicle.delete(whereClause);
				}
				else
				{
					flagVehicle = true;
					flagArea = true;
					flagDriverSchedule = true;
				}

				List listDriver = blDriver.select(whereClause);
				if(listDriver.size()>0)
					flagDriver = blDriver.delete(whereClause);
				else
					flagDriver = true;

				List listLogx = blLogx.select(whereClause);
				if(listLogx.size()>0)
					flagLogx = blLogx.delete(whereClause);
				else
					flagLogx = true;

				List listUserx = blUserx.select(whereClause);
				if(listUserx.size()>0)
					flagUserx = blUserx.delete(whereClause);
				else
					flagUserx = true;

				List listUserGroup = blUserGroup.select(whereClause);
				if(listUserGroup.size()>0)
					flagGroup = blUserGroup.delete(whereClause);
				else
					flagGroup = true;

				whereClause = "ID = " + companySchema.ID;
				flagCompany = blCompany.delete(whereClause);
			}
		}
		int userID = (Integer)session.getAttribute("ID");
		userxSchema = blUserx.getSchema(userID);
		LogxSchema logxSchema = new LogxSchema();
		logxSchema.CompanyID = userxSchema.CompanyID;
		logxSchema.UserxID = userxSchema.ID;
		logxSchema.LoggedTime = MiscTool.getNow();
		logxSchema.Memo = "删除公司";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>删除公司</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="JavaScript">
		<%
			if(flagUserx&&flagGroup&&flagLogx&&flagArea&&flagDriverSchedule&&flagVehicle&&flagDriver&&flagCompany)
			{
		%>
				window.location.href = "company.jsp";
		<%
				logxSchema.Operation = "删除公司成功";
			}
			else
			{
		%>
				alert("删除公司失败");
				window.history.go(-1);
		<%
				logxSchema.Operation = "删除公司失败";
			}
			blLogx.insert(logxSchema);
		%>
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
										<h2>删除公司</h2>
									</header>
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