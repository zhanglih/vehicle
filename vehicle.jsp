<!--
    描述:车辆管理
    作者:张腾
    手机:15731115318
    微信:1013738008
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
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
	    int companyID=userxSchema.CompanyID;

	    if(companyID!=0)
		{
			response.sendRedirect("vehicleList.jsp?companyID="+companyID);
		}


	    BLCompany blCompany=new BLCompany(con);
        BLVehicle blVehicle=new BLVehicle(con);
        List<VehicleSchema> vehicleList=blVehicle.select("CompanyID IS NOT NULL");
        List<Integer> companyIDList=new ArrayList<Integer>();
		
		for(VehicleSchema vehicleSchema:vehicleList)
		{
			
			if(!companyIDList.contains(vehicleSchema.CompanyID)){
	                companyIDList.add(vehicleSchema.CompanyID);
	        }
		}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>车辆管理</title>
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
										<h2>公司车辆</h2>
									</header>
										
										<div class="table-wrapper">
                                    		<table class="alt">
                                    			
												<tbody style="text-align:center">
		                                            <tr align="center" valign="middle">
		                                                <td><b>公司名称</b></td>                                                
		                                                <td><b>车辆数量</b></td>
		                                    		</tr>
		                                    	<%
		                                    		if(!companyIDList.isEmpty())
		                                    		{
		                                    			for(int companyid:companyIDList)
		                                    			{
		                                    				CompanySchema companySchema=blCompany.getSchema(companyid);
		                                    				if(companySchema!=null && !"".equals(companySchema))
		                                    				{
		                                    					int vehicleNumber=blVehicle.getCount("CompanyID="+companyid);
			                                    %>
			                                    	<tr>
			                                    		<td><a href="vehicleList.jsp?companyID=<%=companyid%>"><%=companySchema.Namex%></a></td>
			                                    		<td><%=vehicleNumber%></td>
			                                    	</tr>
			                                    <%
			                                    			}
		                                    			}
	                                    			}
		                                    	%>
                                        		</tbody>
                                            </table>                             
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
%>
<%@ include file="closeCon.jspf"%>
