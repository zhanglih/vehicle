<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.quarkioe.vehicle.schema.UserxSchema"%>
<%@ page import="com.quarkioe.vehicle.bl.BLUserx"%>
<%@ page import="com.quarkioe.vehicle.bl.BLLogx"%>
<%@ page import="com.quarkioe.vehicle.schema.LogxSchema"%>
<%@ page import="org.everdow.nepenthes.util.MiscTool"%>
<%@ page import="java.util.List"%>
<%@ include file="openCon.jspf"%>
<%
	BLUserx blUserx = new BLUserx(con);
	BLLogx blLogx = new BLLogx(con);
	/*
	int userID = (Integer)session.getAttribute("ID");
	UserxSchema userxSchema = blUserx.getSchema(userID);
	
	LogxSchema logxSchema = new LogxSchema();
	logxSchema.CompanyID = userxSchema.CompanyID;
	logxSchema.UserxID = userxSchema.ID;
	logxSchema.LoggedTime = MiscTool.getNow();
	logxSchema.Operation = "测试";
	logxSchema.Memo = "测试";

	blLogx.insert(logxSchema);*/

	String whereClause = "CompanyID = " + 1;
	List list = blLogx.select(whereClause);
	out.println(list.size());



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>helloworld</title>


<body>
</body>
</html>
<%@ include file="closeCon.jspf"%>
