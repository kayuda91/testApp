<%@ page import="http.MyHttpURLConnection" %>
<%@ page import="http.HttpApacheClient" %>
<%@ page import="json.JSONObject" %>
<%@ page import="json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Objects" %>
<%--
  Created by IntelliJ IDEA.
  User: kayud
  Date: 28.01.2016
  Time: 22:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
      <meta charset="utf-8">
      <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">

      <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
      <script type="text/javascript" src="js/bootstrap.min.js"></script>
      <script type="text/javascript" src="js/script.js"></script>
    <title>Title</title>
  </head>
  <body>
  <form action="" method="post" id="getInfo">
      <input type="text" name="username">
      <input type="submit" value="Get">
  </form>
  <%
      String acc = "";
      if (request.getParameter("username")!=null ) {
          MyHttpURLConnection http = new MyHttpURLConnection();
          http.getConfig(application.getRealPath("/") + "config.json");
          //System.out.println("REQUEST = " + request.getParameter("username"));
          //System.out.println("SESSION = " + session.getAttribute("access_token"));
          //http.USERNAME = request.getParameter("username");
          //acc = request.getParameter("username");
          //System.out.println("User = " + http.USERNAME);

          if (session.getAttribute("access_token")==null) {

              try {

                  //String resp = http.sendGet(request.getParameter("username"));
                  //out.print(resp);
                  String site = "https://api.instagram.com/oauth/authorize/?client_id=" + http.CLIENT_ID +
                          "&redirect_uri=" + http.REDIRECT_URI +
                          "&response_type=code"+
                          "&scope=basic+public_content+follower_list+likes+comments";
                  response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
                  response.setHeader("Location", site);
                  //out.print(http.sendPost().toString());

              } catch (Exception e) {
                  System.out.print(e.getMessage());
              }
          }
          else {
              try {
                  //String user = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 0).toString();
                  //String followers = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 1).toString();
                  //String followed_by = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 2).toString();
                  //String likes = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 3).toString();
                  String lastMediaInfo = http.sendGet(session.getAttribute("access_token").toString(), 4).toString();
                  String basic = http.sendGet(session.getAttribute("access_token").toString(), 5).toString();

                  if (lastMediaInfo != null && basic!=null){
                      List<String> comments = http.getCommentsTexts(http.getMediaIds(lastMediaInfo), session.getAttribute("access_token").toString());
                      //JSONObject followedBy = new JSONObject(followed_by);
                      //JSONObject followersJson = new JSONObject(followers);
                      //JSONObject likesJson = new JSONObject(likes);
                      //JSONObject commentsJson = new JSONObject(lastMediaInfo);
                      JSONObject basicInfo = new JSONObject(basic);
                      int commentsCount = http.calcComments(lastMediaInfo);
                      int likesCount = http.likesCount(lastMediaInfo);
                      //JSONObject data = basicInfo.getJSONObject("data");
                      JSONObject counts = basicInfo.getJSONObject("data").getJSONObject("counts");
                      int followCount = counts.getInt("follows"); //на сколько подписан
                      int followersCount = counts.getInt("followed_by"); //фоловеры
                      //int posts = counts.getInt("media"); //посты
                      out.println("Followers => " + followersCount);
                      out.println("Followed by => " + followCount);
                      out.println("Likes => " + likesCount);
                      out.println("Comments => " + commentsCount + "<br>");
                      /*for(String item : comments){
                          out.println(item + "<br>");
                      }*/

                      double scores = http.calcScores(followersCount, followCount, likesCount);
                      out.println(String.format("%.1f",scores) + "<br>");
                      Map<String, Integer> map = http.getWordsCount(comments);
                      Set<Map.Entry<String,Integer>> entrySet = map.entrySet();
                      for (Map.Entry<String,Integer> item : entrySet){
                          out.print(item.getKey() + " - " + item.getValue() + "<br>");
                      }
                      //out.println("Basic => " + basicInfo + "<br>"+counts);
                  }
              }
              catch (Exception e){
                  System.out.println(e.getMessage());
              }
          }
      }

      if (request.getParameter("getinfo")!=null && Objects.equals(request.getParameter("getinfo"), "true") && session.getAttribute("access_token")!=null){
          MyHttpURLConnection http = new MyHttpURLConnection();
          http.getConfig(application.getRealPath("/") + "config.json");
          try {
              //String user = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 0).toString();
              //String followers = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 1).toString();
              //String followed_by = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 2).toString();
              //String likes = http.sendGet(http.USERNAME, session.getAttribute("access_token").toString(), 3).toString();
              String lastMediaInfo = http.sendGet(session.getAttribute("access_token").toString(), 4).toString();
              String basic = http.sendGet(session.getAttribute("access_token").toString(), 5).toString();

              if (lastMediaInfo != null && basic!=null){
                  List<String> comments = http.getCommentsTexts(http.getMediaIds(lastMediaInfo), session.getAttribute("access_token").toString());
                  //JSONObject followedBy = new JSONObject(followed_by);
                  //JSONObject followersJson = new JSONObject(followers);
                  //JSONObject likesJson = new JSONObject(likes);
                  //JSONObject commentsJson = new JSONObject(lastMediaInfo);
                  JSONObject basicInfo = new JSONObject(basic);
                  int commentsCount = http.calcComments(lastMediaInfo);
                  int likesCount = http.likesCount(lastMediaInfo);
                  //JSONObject data = basicInfo.getJSONObject("data");
                  JSONObject counts = basicInfo.getJSONObject("data").getJSONObject("counts");
                  int followCount = counts.getInt("follows"); //на сколько подписан
                  int followersCount = counts.getInt("followed_by"); //фоловеры
                  //int posts = counts.getInt("media"); //посты
                  out.println("Followers => " + followersCount);
                  out.println("Followed by => " + followCount);
                  out.println("Likes => " + likesCount);
                  out.println("Comments => " + commentsCount + "<br>");
                      /*for(String item : comments){
                          out.println(item + "<br>");
                      }*/

                  double scores = http.calcScores(followersCount, followCount, likesCount);
                  out.println(String.format("%.1f",scores) + "<br>");
                  Map<String, Integer> map = http.getWordsCount(comments);
                  Set<Map.Entry<String,Integer>> entrySet = map.entrySet();
                  for (Map.Entry<String,Integer> item : entrySet){
                      out.print(item.getKey() + " - " + item.getValue() + "<br>");
                  }
                  //out.println("Basic => " + basicInfo + "<br>"+counts);
              }
          }
          catch (Exception e){
              System.out.println(e.getMessage());
          }

      }

      if (request.getParameter("code")!=null){
          MyHttpURLConnection http = new MyHttpURLConnection();
          http.getConfig(application.getRealPath("/") + "config.json");
          String url = "https://api.instagram.com/oauth/access_token";
          String params = "client_id="+http.CLIENT_ID+"&client_secret="+http.CLIENT_SECRET+
                  "&grant_type=authorization_code&redirect_uri="+
                  http.REDIRECT_URI+
                  "&code="+request.getParameter("code");
          try{
              String resp = http.sendPost(url, params).toString();
              if (resp != null) {
                  JSONObject json = new JSONObject(resp);
                  String access_token = json.getString("access_token");
                  System.out.println("Access token = " + access_token);
                  session.setAttribute( "access_token", access_token);

                  String site = http.REDIRECT_URI + "?getinfo=true";
                  response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
                  response.setHeader("Location", site);
              }
          }
          catch (Exception e){
              System.out.println(e.getMessage());
          }
      }
  %>
  </body>
</html>
