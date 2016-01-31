<%@ page import="json.JSONObject" %>
<%@ page import="java.io.*" %>
<%@ page import="http.MyHttpURLConnection" %>
<%@ page import="jdk.nashorn.internal.parser.JSONParser" %><%--
  Created by IntelliJ IDEA.
  User: kayud
  Date: 30.01.2016
  Time: 16:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<%
    if (request.getParameter("submit") !=null){
        JSONObject json = new JSONObject();
        if (request.getParameter("client_id")!= null && request.getParameter("client_secret")!=null && request.getParameter("redirect_uri") != null) {
            json.put("client_id", request.getParameter("client_id"));
            json.put("client_secret", request.getParameter("client_secret"));
            json.put("redirect_uri", request.getParameter("redirect_uri"));
        }

        try {
            File file = new File(application.getRealPath("/") + "/config.json");
            FileOutputStream fos;
            BufferedWriter writer;

            fos = new FileOutputStream(file);
            writer = new BufferedWriter(new OutputStreamWriter(fos, "UTF8"));

            writer.write(json.toString());
            writer.close();

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        out.print ("Saved");
    }
    else {
        MyHttpURLConnection http = new MyHttpURLConnection();
        out.print (application.getRealPath("/") + "config.json");
        http.getConfig(application.getRealPath("/") + "config.json");
        //JSONObject json = new JSONObject();

%>
<form action="" method="post">
    <input type="text" name="client_id" placeholder="CLIENT ID">
    <input type="text" name="client_secret" placeholder="CLIENT SECRET">
    <input type="text" name="redirect_uri" placeholder="REDIRECT URI">
    <input type="submit" name="submit" value="Save">
</form>
<%
    }
%>
</body>
</html>
