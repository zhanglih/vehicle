<!--
    描述:Root用户登录显示公司用户列表界面。
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.07.17
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.Userx2UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx2UserGroup"%>
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
        BLUserx blUserx=new BLUserx(con);
        BLCompany blCompany=new BLCompany(con);
        BLUserGroup blUserGroup = new BLUserGroup(con);
        BLUserx2UserGroup blUserx2UserGroup = new BLUserx2UserGroup(con);

        UserxSchema userxSchema=null;
        CompanySchema companySchema = null;
        Userx2UserGroupSchema userx2UserGroupSchema = null;
        UserGroupSchema userGroupSchema = null;

        //查询条件
        String whereClause="1=1";
        
        //接收页面搜索框输入参数
        String keyword=request.getParameter("keyword");
        if("".equals(keyword))
            whereClause="1=1";
        else if(keyword!=null)
            whereClause="Namex LIKE '~"+MiscTool.getUTF8FromISO(keyword)+"~' AND "+whereClause;

        //分页查询前期条件
        int number=10;
        int currentPageNo=1;
        String currentPageNoStr=request.getParameter("currentPageNo");
        if(currentPageNoStr!=null)
            currentPageNo=new Integer(currentPageNoStr).intValue();
        int start=0;
        int end=0;
        String startStr=request.getParameter("start");
        if(startStr!=null)
            start=new Integer(startStr).intValue();
        String endStr=request.getParameter("end");
        if(endStr!=null)
            end=new Integer(endStr).intValue();
        else
            end=number;
        
        int count=blCompany.getCount(whereClause);
        if(number>count)
            number=count;
        //分页查询
        List result=blCompany.select(whereClause,start+1,number);
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>用户</title>
        <meta charset="utf-8" />
        <%@ include file="head.jspf"%>
    </head>
    <body>
        <form name="form" method="post" action="userRoot.jsp">
        
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
                            <h2>企业用户列表</h2>
                        </header>
                        <div class="table-wrapper">
                            <div class="row uniform">
                                <div class="9u 9u$(xsmall)">
                                    <input type="text" name="keyword" placeholder="关键字"
                                        value=
                                        "<%
                                            if(keyword!=null)
                                                out.print(MiscTool.getUTF8FromISO(keyword));
                                        %>"
                                        />
                                </div>
                                <div class="3u 3u$(xsmall)" align="center">
                                    <div class="12u$">
                                        <ul class="actions">
                                            <li><input type="submit" value="查询" class="special" /></li>
                                        </ul>
                                    </div>
                                </div>
                                <!-- <div class="2u 2u$(xsmall)" align="center">
                                    <div class="12u$">
                                        <ul class="actions">
                                            <li><input type="button" name="button"  value="新建" onClick="JavaScript:window.location.href='companyCreate.jsp'"/></li>
                                        </ul>
                                    </div>
                                </div> -->
                            </div>
                            <table class="alt">
                                <tbody>
                                    <tr>
                                        <td width=15% align="center"><strong>是否启用</strong></td>
                                        <td width= height="57" align="center">
                                            <strong>公司名称</strong></td>
                                        <td width=20% align="center"><strong>联系人</strong></td>
                                        <td width=20% align="center"><strong>电话</strong></td>
                                    </tr>
                                    <%
                                        for(Object obj:result)
                                        {
                                            companySchema = (CompanySchema)obj;
                                    %>
                                    <tr>
                                        <td align="center"><%=companySchema.IsEnabled==1?"<img src='img/1.png'  style='display: inherit;'>":"<img src='img/5.png'  style='display: inherit;'>"%>
                                        </td>
                                        <td align="center">
                                            <a href="systemLogRootCompany.jsp?id=<%=companySchema.ID%>">
                                                <%=companySchema.Namex%>
                                            </a>
                                        </td>
                                        <td align="center"><%=companySchema.ContactPerson%></td>
                                        <td align="center"><%=companySchema.Mobile%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td height="100" colspan="6" align="center">
                                            <%
                                                if(number!=0)
                                                {
                                                    int totalPages=count/number;
                                                    if(count%number>0)
                                                        totalPages++;
                                                    for(int i=1;i<=totalPages;i++)
                                                    {
                                                        int startNumber=(i-1)*number;
                                                        int endNumber=(i*number);
                                                        if(i==totalPages&&count%number>0)
                                                            endNumber=(i-1)*number+count%number;
                                                        if(currentPageNo!=i)
                                                            out.print("&nbsp;<a "+"href='userRoot.jsp?currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"&keyword="+(keyword==null?"":keyword)+"'>"+i+"</a>");
                                                        else
                                                            out.println("&nbsp;<B>"+i+"<B>");
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
</html>
<%
    }
%>
<%@ include file="closeCon.jspf"%>