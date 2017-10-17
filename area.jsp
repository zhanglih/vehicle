<!--
	描述：电子围栏列表页面
    作者：张力
    手机： 15201162896
    微信： 15201162896
    日期： 2017-06-09

-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriveInfo"%>
<%@ page import="com.quarkioe.vehicle.schema.DriveInfoSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLArea"%>
<%@ page import="com.quarkioe.vehicle.schema.AreaSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLVehicle"%>
<%@ page import="com.quarkioe.vehicle.schema.VehicleSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int uID = (Integer)session.getAttribute("ID");

        BLUserx blUserx=new BLUserx(con);
        BLCompany blCompany=new BLCompany(con);
        BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

        UserxSchema userxSchema = blUserx.getSchema(uID);

        UserGroupSchema userGroupSchema = null;
        Userx2UserGroupSchema userx2UserGroupSchema = null;

        String spermissionStr = "";
        String permissionx = "";
        boolean screateFlag = false;
        boolean sdeleteFlag = false;
        boolean supdateFlag = false;
        boolean suserRoot = false;
        String whereClause = "1=1";

        if("root".equals(userxSchema.Userx))
            suserRoot = true;
        else
        {
            whereClause = "UserxID = " + userxSchema.ID ;
            List listUserx2UserGroup = blUserx2UserGroup.select(whereClause);
            if(!listUserx2UserGroup.isEmpty())
            {
                for(Object sobj1 : listUserx2UserGroup)
                {
                    userx2UserGroupSchema = (Userx2UserGroupSchema)sobj1;
                    userGroupSchema = blUserGroup.getSchema(userx2UserGroupSchema.UserGroupID);
                    spermissionStr = userGroupSchema.Permissionx;
                    String[] spermission = spermissionStr.split(" ");
                    if(spermission.length>0)
                    {
                        for(int i=0;i<spermission.length;i++)
                        {
                            if("create".equals(spermission[i]))
                                screateFlag = true;
                            if("delete".equals(spermission[i]))
                                sdeleteFlag = true;
                            if("update".equals(spermission[i]))
                                supdateFlag = true;
                        }
                    }
                }
            }
        }

		String keyWord = request.getParameter("keyword");
		whereClause = "1=1";
		if(keyWord!=null)
		{
			whereClause = whereClause + " AND Namex LIKE '~"+MiscTool.getUTF8FromISO(keyWord.trim())+"~'";//通过关键字查询
		}
		
		//分页查询
		int number=5;//每页显示的条目数
		int currentPageNo=1;//当前的页码
		String currentPageNoStr=request.getParameter("currentPageNo");
		if(currentPageNoStr!=null)
			currentPageNo=new Integer(currentPageNoStr).intValue();
		int start=0;//当前页的起始编号
		int end=0;//当前页的终止编号
		String startStr=request.getParameter("start");
		if(startStr!=null)
			start=new Integer(startStr).intValue();
			
		String endStr=request.getParameter("end");
		if(endStr!=null)
			end=new Integer(endStr).intValue();
		else
			end=number;
		
		BLArea blArea = new BLArea(con);
		
		int count=blArea.getCount(whereClause);
		if(number>count)
			number=count;
		
		List result = blArea.select(whereClause,start+1,number);	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>电子围栏</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script>
			function deleteConfirm(id)
			{
				//删除提示框
                var flag=confirm("确定删除?");
                if(flag)
                {
                    window.location.href="deleteArea.jsp?id="+id;
                }
                else
                {
                    return false;
					
                }
			}
			
			function createArea()
			{
                window.location.href="createArea.jsp";
			}
			
			function updateConfirm(id)
			{
				window.location.href="updateArea.jsp?ID="+id;
			}
		</script>
	</head>
	<body>
		<form method="post" action="area.jsp" onsubmit="return verify();" name="form" style="margin-bottom:0">
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
										<h2>电子围栏</h2>
									</header>
										<div class="row uniform">
											<div class="9u 9u$(xsmall)">
												<input type="text" id="keyword" name="keyword" placeholder="名称" value=""/>
											</div>
											<div class="3u 3u$(small)">
												<div class="6u 6u$(small)" style="float:left;">
													<input type="submit" class="button special" name="button" value="查询" />
												</div>
												<!-- 设置新建居中 -->
												<div class="6u u$(small)" style="float:right;">
													<input type="button" name="button" value="新建" onclick="createArea()"style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/>
												</div>
										    </div>
											<!-- Break -->
										</div>
										<br/>
									<div class="table-wrapper">
										<table class="alt" id="table">
											<tbody style="text-align:center">
											<tr>
												<td width="30%"><strong>名称</strong></td>
												<td width="30%"><strong>车牌</strong></td>
												<td width="30%"><strong>操作</strong></td>
											</tr>
											<!-- 逐行显示 -->
												<%
													for(Object obj:result)
													{
														AreaSchema areaSchema = (AreaSchema)obj;
														Integer ID = areaSchema.VehicleID;
														BLVehicle blVehicle = new BLVehicle(con);
														VehicleSchema vehicleSchema = blVehicle.getSchema(ID);
												%>	
												<tr>
													<td width="30%"><strong><a href="showArea.jsp?ID=<%=areaSchema.ID%>"><%=areaSchema.Namex%></a></strong></td>
													<td width="30%"><strong><%=vehicleSchema.PlateNumber%></strong></td>
													<td>
													<a href="javascript:updateConfirm(<%=areaSchema.ID%>);" style="<%=suserRoot||supdateFlag?"display:static":"display:none"%>">修改</a>
													<span style="<%=suserRoot==false&&supdateFlag==false?"display:static":"display:none"%>">_ _</span>

		                                    		&nbsp;
													|
													&nbsp;
													<a href="javascript:deleteConfirm(<%=areaSchema.ID%>);" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">删 除</a>
													<span style="<%=suserRoot==false&&sdeleteFlag==false?"display:static":"display:none"%>">_ _</span>
													</td>
												</tr>
												<%
													}
												%>
											</tbody>
											<tfoot>
												<tr>
													<td colspan="6" style="text-align:center">
														<%
															if(number != 0)
															{
																int totalPages = count/number;
																if(count%number>0)
																	totalPages++;
																for(int i=1;i<=totalPages;i++)
																{
																	int startNumber = (i-1)*number;
																	int endNumber = i*number;
																	if(i==totalPages&&count%number>0)
																		endNumber = (i-1)*number + count%number;
																	if(currentPageNo != i)
																		out.println("&nbsp;<a href='area.jsp?currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"'>"+i+"</a>");
																	else
																		out.println("&nbsp;<B>"+i+"</B>");
																}
															}
													  %>
													</td>
												</tr>
											</tfoot>
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
		</form>
	</body>
<%
	}
%>
</html>
<%@ include file="closeCon.jspf"%>
