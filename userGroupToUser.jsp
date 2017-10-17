<!--
    描述:接收用户组页面点击用户组名后传递的参数，并展示该用户组内成员
    作者:杜乘风
    手机:13247191605
    微信:13247191605
    日期:2017.06.07
-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLCompany"%>
<%@ page import="com.quarkioe.vehicle.schema.CompanySchema"%>
<%@ page import="com.quarkioe.vehicle.schema.UserGroupSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserGroup"%>
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
        int ID = (Integer)session.getAttribute("ID");

        int companyID = Integer.parseInt(request.getParameter("cID"));
        int userGroupID = Integer.parseInt(request.getParameter("ugID"));

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

        //筛选所选公司所选用户组组内成员用户条件
        whereClause="UserGroupID = " + userGroupID ;
        List listUserx2 = blUserx2UserGroup.select(whereClause);
        StringBuilder str = new StringBuilder();
        if(!listUserx2.isEmpty())
        {
            str.append("(");

            for(int i=0;i<listUserx2.size()-1;i++)
            {
                userx2UserGroupSchema = (Userx2UserGroupSchema)listUserx2.get(i);
                str = str.append(userx2UserGroupSchema.UserxID);
                str = str.append(",");
            }
            userx2UserGroupSchema = (Userx2UserGroupSchema)listUserx2.get(listUserx2.size()-1);
            str = str.append(userx2UserGroupSchema.UserxID);
            str = str.append(")");

            whereClause= "ID in" + str;
        }
        else
            whereClause = "1 != 1";

            //接收页面搜索框输入参数
            String keyword=request.getParameter("keyword");
            
            if("".equals(keyword))
                whereClause= whereClause;
            else if(keyword!=null)
                whereClause="(Namex LIKE '~"+MiscTool.getUTF8FromISO(keyword)+"~' OR "+"Userx LIKE '~"+MiscTool.getUTF8FromISO(keyword)+"~') AND "+whereClause;
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
            
            int count=blUserx.getCount(whereClause);
            if(number>count)
                number=count;
            //分页查询
            List result=blUserx.select(whereClause,start+1,number);
        
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>用户列表</title>
        <meta charset="utf-8" />
        <%@ include file="head.jspf"%>
        <script language="JavaScript">
            function deleteConfirm(id,ugID,cID)
            {
                var flag=confirm("是否移出这条数据？");
                if(flag)
                    window.location.href="userGroupToDelete.jsp?id="+id+"&ugID="+ugID+"&cID="+cID;
            }
        </script>
    </head>
    <body>
        <form name="form" method="post" action="userGroupToUser.jsp?cID=<%=companyID%>&ugID=<%=userGroupID%>">
        
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
                            <h2>用户列表</h2>
                        </header>
                        <div class="table-wrapper">
                            <div class="row uniform">
                                <div class="8u 8u$(xsmall)">
                                    <input type="text" name="keyword" placeholder="关键字"
                                        value=
                                        "<%
                                            if(keyword!=null)
                                                out.print(MiscTool.getUTF8FromISO(keyword));
                                        %>"
                                        />
                                </div>
                                <div class="2u 2u$(xsmall)" align="center">
                                    <div class="12u$">
                                        <ul class="actions">
                                            <li><input type="submit" value="查询" class="special" /></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="2u 2u$(xsmall)" align="center">
                                    <div class="12u$">
                                        <ul class="actions">
                                            <li>
                                                <input type="button" name="button"  value="移入"
                                                onClick="JavaScript:window.location.href='userGroupToCreate.jsp?ugID=<%=userGroupID%>&cID=<%=companyID%>'" style="<%=suserRoot||screateFlag?"display:static":"display:none"%>"/>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <table class="alt">
                                <tbody>
                                    <tr>
                                        <td width=15% align="center"><strong>是否启用</strong></td>
                                        <td width= height="57" align="center">
                                            <strong>用户名</strong></td>
                                        <td width=20% align="center"><strong>姓名</strong></td>
                                        <td width=20% align="center"><strong>手机</strong></td>
                                        <td width=15% colspan="2" align="center"><strong>操作</strong></td>
                                    </tr>
                                    <%
                                          
                                            for(Object obj:result)
                                            {
                                                userxSchema=(UserxSchema)obj;
                                    %>
                                            <tr>
                                                <td align="center"><%=userxSchema.IsEnabled==1?"<img src='img/1.png'  style='display: inherit;'>":"<img src='img/5.png'  style='display: inherit;'>"%>
                                                </td>
                                                <td align="center"><a href="userCommon.jsp?id=<%=userxSchema.ID%>"><%=userxSchema.Userx%></a></td>
                                                <td align="center"><%=userxSchema.Namex%></td>
                                                <td align="center"><%=userxSchema.Mobile%></td>
                                                <td align="center">
                                                    <a href="javascript:deleteConfirm(<%=userxSchema.ID%>,<%=userGroupID%>,<%=companyID%>)" style="<%=suserRoot||sdeleteFlag?"display:static":"display:none"%>">移出</a>
                                                    <span style="<%=suserRoot==false&&sdeleteFlag==false?"display:static":"display:none"%>">_ _</span>
                                                </td>
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
                                                            out.print("&nbsp;<a "+"href='userGroupToUser.jsp?currentPageNo="+i+"&start="+startNumber+"&end="+endNumber+"&keyword="+(keyword==null?"":keyword)+"&cID="+companyID+"&ugID="+userGroupID+"'>"+i+"</a>");
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