<!--
	描述：用户组列表页面
    作者：张力
    手机：15201162896
    微信：15201162896
    日期：2017-06-06
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<!DOCTYPE HTML>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		Integer ID = (Integer)session.getAttribute("ID");
		BLUserx blUserx = new BLUserx(con);
		UserxSchema userxSchema = blUserx.getSchema(ID);
		Integer CompanyID = userxSchema.CompanyID;
		String Userx = userxSchema.Userx;

		BLCompany blCompany=new BLCompany(con);
        BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

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

		String name = "公司创始人";
		String keyWord = request.getParameter("keyword");
		if("root".equals(Userx))
		{
			whereClause = "Namex != '" + name + "'";
			if(keyWord!=null)
			{
				whereClause = whereClause + " AND Namex LIKE '~"+MiscTool.getUTF8FromISO(keyWord.trim())+"~'";//通过关键字查询
			}	
		}
		else
		{
			whereClause = "Namex != '" + name + "' And CompanyID="+CompanyID;
			if(keyWord!=null)
			{
				whereClause = whereClause + " AND Namex LIKE '~"+MiscTool.getUTF8FromISO(keyWord.trim())+"~'";//通过关键字查询
			}
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
		
		int count=blUserGroup.getCount(whereClause);
		if(number>count)
			number=count;
		
		List result =blUserGroup.select(whereClause,start+1,number);
%>
<html>
	<head>
		<title>用户组</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
			function createUserGroup()
			{
				window.location.href="createUserGroup.jsp";
			}
			
			function deleteConfirm(id)
            {
				//删除提示框
                var flag=confirm("确定删除？");
                if(flag)
                {
                    window.location.href="deleteUserGroup.jsp?id="+id;
                }
                else
                {	
                    return false;
                }
            }
        </script>
	</head>
	<!-- 令keyword元素获得焦点 -->
	<body onLoad='document.getElementById("keyword").focus();'>
		<form name="form" method="post" action="userGroup.jsp">
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
										<h2>用户组</h2>
									</header>
								
							        <table class="alt">
							            <thead>
							            	<tr>
							                <div class="row uniform">
							                     <div class="9u 9u$(small)">
								                    <input type="text" name="keyword" id="keyword" value="" placeholder="关键字"/>
												</div>
												<div class="3u 3u$(small)">
								                   	<div class="6u 6u$(small)" style="float:left;">
								                    	<input type="submit" class="button special" name="button" value="查询" />
								                    </div>
								                    <!-- 设置新建居中 -->
								                    <div class="6u 6u$(small)" style="float:right;">
								                    	<input type="button" name="button" value="新建" onclick="createUserGroup()" style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/>
							                    	</div>
							                    </div>
							                <div>
							                </tr>
							            </thead>
							            <tbody>
							              	<tr align="center">
								               	<td width="25%" align="center"><strong>启用</strong></td>
								                <td width="30%" align="center"><strong>用户组名</strong></td>
								                <td width="30%" align="center"><strong>权限</strong></td>
								                <td width="15%" align="center"><strong>操作</strong></td>
							             	</tr> 
							                <!-- 逐行显示 -->
											<%
												 for(Object obj:result)
												 {
													UserGroupSchema usg=(UserGroupSchema)obj;
											%>
							                <tr align="center">
							                 	<td><%=usg.IsEnabled==1?"<img src='img/1.png'>":"<img src='img/5.png'>"%></td>
							                 	<td><a href="userGroupToUser.jsp?cID=<%=CompanyID%>&&ugID=<%=usg.ID%>"><%=usg.Namex%></a></td>
							                 	<td><%=usg.Permissionx%></td>
							                 	<td>
								                 	<a href="updateUserGroup.jsp?id=<%=usg.ID%>" style="<%=suserRoot||supdateFlag?"display:static":"display:none"%>">编 辑</a> 
								                 	<span style="<%=suserRoot==false&&supdateFlag==false?"display:static":"display:none"%>">_ _</span>
		                                    		&nbsp;
								                 	|
								                 	&nbsp;
								                 	<a href="javascript:deleteConfirm(<%=usg.ID%>);" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">删 除</a>
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
																		out.println("&nbsp;<a href='userGroup.jsp?currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"'>"+i+"</a>");
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