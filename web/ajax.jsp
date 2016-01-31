<%@ page import="http.MyHttpURLConnection" %>
<%@ page import="json.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="json.JSONArray" %>
<%--
  Created by IntelliJ IDEA.
  User: kayud
  Date: 30.01.2016
  Time: 18:25
  To change this template use File | Settings | File Templates.
--%>
<%
    if (request.getParameter("username")!=null ) {
        JSONObject json = new JSONObject();
        for (int i = 0; i < 10; i++)
            json.put("key" + i, "val" + i);

        JSONArray aray = new JSONArray();
        aray.put("123");
        aray.put("234");
        json.put("arrr", aray);
        out.print(json);

    }
%>