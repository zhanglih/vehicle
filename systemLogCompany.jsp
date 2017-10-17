<!--
	描述:查询系统日志列表
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.04.05
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	if(session.getAttribute("ID")==null)
	{
		response.sendRedirect("login.jsp");
	}
	else
	{
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
		
		int ID = (Integer)session.getAttribute("ID");
		UserxSchema userxSchema = blUserx.getSchema(ID);

		int companyID = userxSchema.CompanyID;
		String whereClause = "CompanyID="+companyID;
		
		startDate = request.getParameter("startDate");
		
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
		whereClause = whereClause + " ORDER BY LoggedTime DESC;";
		count = blLogx.getCount(whereClause);
		if(number>count)
			number = count;	
		List result = blLogx.select(whereClause,start+1,number);
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Generic</title>
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
						window.history.go(-1);
						return false;	
					}
				}
				else
				{
					window.history.go(-1);
					return false;	
				}
			}
		</script>
	</head>
	<body>
    	<form name="form" method="post" action="systemLogCompany.jsp">
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<%@ include file="header.jspf"%>

							<!-- Content -->
								<section>
                                    <div class="table-wrapper">
                                        
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
                                                    <td width="20%"><strong>备注</strong></td>
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
	                                                	<%=logxSchema.Memo%>
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
                                                                    out.println("&nbsp;<a href='systemLogCompany.jsp?currentPageNo="+i+"&start="                                         +startNumber+"&end="+endNumber+"&startDate="+(startDate==null?"":startDate)+"&endDate="+(endDate==null?"":endDate)+"'>"+i+"</a>");
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