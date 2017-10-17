<!--
	描述：驾驶员列表页面
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%@ page import="com.quarkioe.vehicle.bl.BLDriver"%>
<%@ page import="com.quarkioe.vehicle.schema.DriverSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int ID = (Integer)session.getAttribute("ID");

        BLUserx blUserx=new BLUserx(con);
        BLCompany blCompany=new BLCompany(con);
        BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

        UserxSchema userxSchema = blUserx.getSchema(ID);

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
			whereClause = "1=1 AND Namex LIKE '~"+MiscTool.getUTF8FromISO(keyWord.trim())+"~'";//通过关键字查询
		}
			
		int number=10;//每页显示的条目数
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
		
		BLDriver blDriver = new BLDriver(con);
		int count=blDriver.getCount(whereClause);
		if(number>count)
			number=count;
		
		List result =blDriver.select(whereClause,start+1,number);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>驾驶员</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
			function createDriver()
			{
				window.location.href="createDriver.jsp";
			}
			
			function deleteConfirm(id)
            {
				//删除提示框
                var flag=confirm("确定删除?");
                if(flag)
                {
                    window.location.href="deleteDriver.jsp?id="+id;
                }
                else
                {
                    return false;
					
                }
            }
			
			
			function driverSchedule()
            {
                window.location.href="driverSchedule.jsp";
            }
        </script>
	</head>
	<!-- 令keyword元素获得焦点 -->
	<body onLoad='document.getElementById("keyword").focus();'>
		<form name="form" method="post" action="driver.jsp">
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
										<h2>驾驶员列表</h2>
									</header>

							        <table class="alt">
							            <thead>
							            	<tr>
							                <div class="row uniform">
							                     <div class="8u 8u$(small)">
								                    <input type="text" name="keyword" id="keyword"value="" placeholder="关键字"/>
												</div>
												<div class="3u 5u$(small)">
								                   	<div class="2u 2u$(small)" style="float:left;">
								                    	<input type="submit" class="button special" name="button" value="查询"/>
								                    </div>
								                    <!-- 设置新建居中 -->
								                    <div class="2u 2u$(small)" style="float:right;">
								                    	<input type="button" name="button" value="新建" onclick="createDriver()" style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/>
							                    	</div>
													
													<div class="2u 2u$(small)" style="float:right; position:relative; left:-55px;">
								                    	<input type="button" name="button" value="排班" onclick="driverSchedule()"/>
							                    	</div>
													
							                    </div>
							                <div>
							                </tr>
							            </thead>
										<br/>
							            <tbody>
							              	<tr align="center">
								               	<td width="25%" align="center"><strong>姓名</strong></td>
								                <td width="30%" align="center"><strong>手机</strong></td>
								                <td width="30%" align="center"><strong>工作性质</strong></td>
								                <td width="15%" align="center"><strong>操作</strong></td>
							             	</tr>
											<%
												for(Object obj:result)
												{
													DriverSchema driverSchema=(DriverSchema)obj;
											%>
											<tr align="center">
												<td><%=driverSchema.Namex%></td>
							                   <td><%=driverSchema.Mobile%></td>
							                   <td><%=driverSchema.JobCharacter%></td>
							                   <td>
								                    <a href="updateDriver.jsp?id=<%=driverSchema.ID%>" style="<%=suserRoot||supdateFlag?"display:static":"display:none"%>">
								                   		编 辑
								                    </a>
								                    <span style="<%=suserRoot==false&&supdateFlag==false?"display:static":"display:none"%>">_ _</span>
		                                    		&nbsp;
								                    | 
								                    &nbsp;
								                    <a href="javascript:deleteConfirm(<%=driverSchema.ID%>);" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">
								                   		删 除
								                    </a>
								                    <span style="<%=suserRoot==false&&sdeleteFlag==false?"display:static":"display:none"%>">_ _</span>
							                   </td>
											</tr>
											<%
												}
											%>
							            </tbody>
							            
							            <tfoot>
							                    <tr>
							                        <td colspan="4" align="center">
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
																		out.println("&nbsp;<a href='driver.jsp?currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"'>"+i+"</a>");
																	else
																		out.println("&nbsp;<B>"+i+"</B>");
																}
															}
													  %>
							                        </td>
							                    </tr>
							            </tfoot>
							        </table>
    
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