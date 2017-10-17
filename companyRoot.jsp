<!--
	描述:Root用户登录显示界面
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
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
		response.sendRedirect("login.jsp");
	else
	{
		BLCompany blCompany=new BLCompany(con);
		String whereClause="ParentID = " + 0 ;

		String keyword = MiscTool.getUTF8FromISO(request.getParameter("keyword"));
		String startDate="";
		String endDate="";
		if(keyword!=null)
		{
			startDate = request.getParameter("startDate");
			if(startDate=="")
				startDate="2000-01-01";
			endDate = request.getParameter("endDate");
			if(endDate=="")
				whereClause="Namex like '~"+keyword.trim()+"~' AND "+"RegisteredTime>='"+startDate+" 00:00:00' AND RegisteredTime"+"<'"+MiscTool.getNow().split(" ")[0]+" 23:59:59'" + " AND ParentID = 0";
			else
				whereClause="Namex like '~"+keyword.trim()+"~' AND "+"RegisteredTime>='"+startDate+" 00:00:00' AND RegisteredTime"+"<'"+endDate+" 23:59:59'" + " AND ParentID = 0";
		}

		//分页
		int number = 10;
		int currentPageNo = 1;
		String currentPageNoStr = request.getParameter("currentPageNo");
		if(currentPageNoStr!=null)
			currentPageNo = new Integer(currentPageNoStr).intValue();
		int start = 0;
		int end = 0;
		String startStr = request.getParameter("start");
		if(startStr!=null)
			start = new Integer(startStr).intValue();
		String endStr = request.getParameter("end");
		if(endStr!=null)
			end = new Integer(endStr).intValue();
		else
			end = number;
		int count = blCompany.getCount(whereClause);
		if(number>count)
			number = count;

		whereClause += " ORDER BY RegisteredTime DESC";
		List result = blCompany.select(whereClause,start+1,number);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>公司列表</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
		<script language="javascript">
			function deleteConfirm(id)
			{
				var flag1 = confirm("确定要删除该公司吗？");
				if(flag1)
				{
					var flag2 = confirm("您确定要删除该公司吗？");
					if(flag2)
					{
						window.location.href="companyDelete.jsp?id="+id;
						return true;
					}
					else
					{
						window.location.href = "company.jsp";
						return false;	
					}
				}
				else
				{
					window.location.href = "company.jsp";
					return false;	
				}
			}
		</script>
	</head>
	<body>
		<form name="form" method="post" action="companyRoot.jsp" onsubmit="" style="margin-bottom:0">
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
										<h2>总公司列表</h2>
									</header>

									<div class="row uniform">
										<div class="2u 4u$(xsmall)">
											<input type="text" name="keyword" placeholder="关键字" value="<%=(keyword!=null?keyword:"")%>"/>
										</div>
										<div class="3u 6u$(xsmall)">
											<input type="text" name="startDate" placeholder="开始日期" readonly id="startDate" value="<%=((startDate!=null&&startDate!="2000-01-01")?startDate:"")%>"/>
										</div>
										<div class="3u 6u$(xsmall)">
											<input type="text" name="endDate" placeholder="结束日期" readonly id="endDate" value="<%=(endDate!=null?endDate:"")%>" />
										</div>
										<div class="2u 3u$(xsmall)">
											<div class="12u$">
												<ul class="actions">
													<li><input type="submit" value="查询" class="special" /></li>
												</ul>
											</div>
										</div>
										<div class="2u 3u$(xsmall)">
											<div class="12u$">
												<ul class="actions">
													<li>
														<input type="button" value="新建" class="special" onClick="JavaScript:window.location.href='companyCreate.jsp'"/>
													</li>
												</ul>
											</div>
										</div>
									</div>
									
									<div class="table-wrapper">
										<table class="alt">
											<tbody style="text-align:center">
												<tr>
													<td><strong>启用</strong></td>
													<td width="50%"><strong>公司</strong></td>
													<td><strong>创建时间</strong></td>
													<td><strong>操作</strong></td>
												</tr>
											<%
												if(!result.isEmpty())
												{
													for(Object obj:result)
													{
														CompanySchema company=(CompanySchema)obj;
											%>
														<tr>
															<td>
																<%=company.IsEnabled==1?"<img src='img/1.png'>":"<img src='img/5.png'>"%>
															</td>
															<td>
																<a href="companyRootParent.jsp?id=<%=company.ID%>">
																	<%=company.Namex%>
																</a>
															</td>
															<td><%=company.RegisteredTime%></td>
															<td>
																<a href="companyParentInfo.jsp?id=<%=company.ID%>">详情</a>
																|
																<a href="companyUpdate.jsp?id=<%=company.ID%>">编辑</a>
																|
																<a href="JavaScript:deleteConfirm(<%=company.ID%>);">删除</a>
															</td>
														</tr>
											<%
													}
												}
											%>

											</tbody>
											<tfoot>
												<tr>
													<td colspan="6" style="text-align:center">
													<%
														if(number!=0){
															int totalPages=count/number;
															if(count%number>0)
																totalPages++;
															for(int i=1;i<=totalPages;i++){
																int startNumber = (i-1)*number;
																int endNumber = (i*number);
																if(i==totalPages&&count%number>0)
																	endNumber=(i-1)*number+count%number;
																if(currentPageNo!=i)
																	out.print(
																	"&nbsp;<a href='companyRoot.jsp?currentPageNo="
																	+i
																	+"&keyword="
																	+keyword
																	+"&start="
																	+startNumber
																	+"&end="
																	+endNumber
																	+"'>"
																	+i
																	+"</a>");
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
			<script>
				$("#startDate").datepicker();
				$("#endDate").datepicker();
			</script>
		</form>
	</body>
</html>
<%
	}
%>
<%@ include file="closeCon.jspf"%>