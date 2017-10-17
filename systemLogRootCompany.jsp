<!--
	描述:root用户查看公司系统日志详情界面
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.17
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
		int companyID = Integer.parseInt(request.getParameter("id"));

		BLUserx blUserx = new BLUserx(con);
		BLLogx blLogx = new BLLogx(con);

		int number = 10;
		int currentPageNo = 1;
		int start = 0;
		int end = 0;
		int count = 0;
		String startDate = "";
		String endDate = "";

		String currentPageNoStr = request.getParameter("currentPageNo");
		if(currentPageNoStr!=null)
			currentPageNo = new Integer(currentPageNoStr).intValue();
		String startStr = request.getParameter("start");
		if(startStr != null)
			start = new Integer(startStr).intValue();
		
		String endStr = request.getParameter("end");
		if(endStr != null)
			end = new Integer(endStr).intValue();
		else
			end = number;
		
		String whereClause = "CompanyID="+companyID;

		startDate = request.getParameter("startDate");
		/*		
		if(startDate==null)
			startDate="";
		endDate = request.getParameter("endDate");
		if(endDate==null)
			endDate = "";
		if(startDate=="")
		{
			if(endDate == "")
			{
				whereClause=whereClause+" AND LoggedTime"+">='"+"2010-01-01 00:00:00' AND LoggedTime"+"<='"+MiscTool.getNow().split(" ")[0]+" 23:59:59'";
			}
			else
			{
				whereClause = whereClause + " AND LoggedTime"+"<='"+endDate+" 23:59:59'";
			}
		}
		else
		{
			if(endDate == "")
			{
				whereClause=whereClause+" AND LoggedTime"+">='"+startDate+" 00:00:00' AND LoggedTime"+"<='"+MiscTool.getNow().split(" ")[0]+" 23:59:59'";
			}
			else
			{
				whereClause = whereClause + " AND LoggedTime"+">='"+startDate+" 00:00:00' AND LoggedTime"+"<='"+endDate+" 23:59:59'";
			}
		}
		*/

		
		if(startDate==null || startDate=="")
			startDate="";
		endDate = request.getParameter("endDate");
		if(endDate==null || endDate=="")
		{
			if(startDate==null || startDate=="")
			{
				whereClause=whereClause+" AND LoggedTime"+"<='"+MiscTool.getNow().split(" ")[0]+" 23:59:59'";
			}
			else
			{
				whereClause=whereClause+" AND LoggedTime"+">='"+startDate+" 00:00:00' AND LoggedTime"+"<='"+MiscTool.getNow().split(" ")[0]+" 23:59:59'";
			}				
		}
		else
		{
			if(startDate==null || startDate=="")
			{
				whereClause = whereClause + " AND LoggedTime"+"<='"+endDate+" 23:59:59'";
			}
			else
			{
				whereClause = whereClause + " AND LoggedTime"+">='"+startDate+" 00:00:00' AND LoggedTime"+"<='"+endDate+" 23:59:59'";
			}
		}
		
		count = blLogx.getCount(whereClause);
		if(number>count)
			number = count;

		whereClause = whereClause + " ORDER BY LoggedTime DESC";	
		List result = blLogx.select(whereClause,start+1,number);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>系统日志</title>
		<meta charset="utf-8" />
		<%@ include file="head.jspf"%>
        <script language="javascript">
			function deleteConfirm(id)
			{
				var flag = confirm("确定要删除吗？");
				if(flag)
				{
					var flag2 = confirm("您确定要删除吗？");
					if(flag2)
					{
						window.location.href="systemLogDelete.jsp?id="+id;
						return true;
					}
					else
					{
						alert("删除失败!");
						window.history.go(-1);
						return false;	
					}
				}
				else
				{
					alert("删除失败!");
					window.history.go(-1);
					return false;	
				}
			}
		</script>
	</head>
	<body>
    	<form name="form" method="post" action="systemLogCompany.jsp?companiesID=<%=companyID%>">
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
										<h2>系统日志</h2>
									</header>
                                        <table class="alt">
                                            <thead>
                                                <tr>
                                                    <div class="row uniform">
									                    <div class="5u 5u$(small)">
									                        <input type="text" name="startDate" id="startDate" readonly placeholder="起始日期" 
									                        	value="<%=((startDate!=null&&startDate!="2000-01-01")?startDate:"")%>"/>
									                    </div>
									                    <div class="5u 5u$(small)">
									                        <input type="text" name="endDate" id="endDate" readonly placeholder="结束日期" 
									                        	value="<%=(endDate!=null?endDate:"")%>"/>
									                    </div>
									                    <div class="2u 2u$(small)">
										                    <div class="6u 6u$(small)" style="float:left;">
										                    	<input type="submit" class="button special" name="button" value="查询" />
										                    </div>
									                    </div>
									                <div>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            	<tr align="center">
                                                    <td width="25%"><strong>姓名</strong></td>
                                                    <td width="25%"><strong>操作内容</strong></td>
                                                    <td width="30%"><strong>记录日志时间</strong></td>
                                                    <td width="20%"><strong>操作</strong></td>
                                                </tr>
                                            <%
													for(Object obj : result)
													{
														LogxSchema logxSchema = (LogxSchema)obj;
											%>
                                                <tr align="center">
                                                <%
                                                	UserxSchema userx = blUserx.getSchema(logxSchema.UserxID);
                                                %>
	                                                <td>
	                                                	<%=userx.Namex%>
	                                                </td>
                                                    <td><%=logxSchema.Operation%></td>
                                                    <td><%=logxSchema.LoggedTime%></td>
                                                    <td>
	                                                	<a href="javascript:deleteConfirm(<%=logxSchema.ID%>);">删除</a>
	                                                </td>
                                                </tr>
                                            <%
													}
											%>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="5" align="center">
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
                                                                    {
																		out.println("&nbsp;<a href='systemLogRootCompany.jsp?id="+companyID+"&currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"&startDate="+(startDate==null?"":startDate)+"&endDate="+(endDate==null?"":endDate)+"'>"+i+"</a>");
                                                                    }
                                                                    else
                                                                    {
                                                                        out.println("&nbsp;<B>"+i+"</B>");
                                                                    }
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