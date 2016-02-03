<%@ page import="http.MyHttpURLConnection" %>
<%@ page import="http.HttpApacheClient" %>
<%@ page import="json.JSONObject" %>
<%@ page import="json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Objects" %>
<%@ page import="http.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%--
  Created by IntelliJ IDEA.
  User: kayud
  Date: 28.01.2016
  Time: 22:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/script.js"></script>
    <title>Title</title>
</head>
<body>
<header>
    <div class="container">
        <div class="col-md-12">
            <div class="row">
                <div class="header-top ">
                    <div class="header-info ">
                        <span class="bold">+7 812 677-01-98</span>
                        <span class="italic">Бесплатная доставка по России и Миру</span>
                    </div>
                    <div class="search text-center">
                        <form class="form-inline">
                            <div class="form-group">
                                <button type="button" class="pull-left"><img src="images/rectangle-404@2x.png"></button>
                                <input type="text" class="pull-left" placeholder="Поиск">
                            </div>
                        </form>

                    </div>
                    <div class=" pull-right">
                        <ul class="nav navbar-nav">
                            <li><a href="#">О бренде</a></li>
                            <li><a href="#">Франчайзинг</a></li>
                            <li><a href="#">Блог</a></li>
                            <li><a href="#">Инста-фото</a></li>
                            <li><a href="#">Контакты</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="col-md-12">
            <div class="row">
                <div class="main_menu header-middle text-center">
                    <div class="col-md-12">
                        <div class="logo col-md-12">
                            <img src="images/logo-rafinad@2x.png" class="center-block">
                        </div>
                        <div class="clearfix"></div>
                        <nav class="text-center navbar navbar-default">
                            <div class="menu">
                                <ul class="nav navbar-nav">
                                    <li><a href="#">Каталог</a></li>
                                    <li><a href="#">Распродажа</a></li>
                                    <li><a href="#">Коллекция «Онлайн»</a></li>
                                    <li><a href="#">Косметика</a></li>
                                    <li><a href="#">Обувь</a></li>
                                </ul>
                            </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
<main>
    <div class="container text-center">
        <div class="main_banner">
            <span class="big">Подберём платье по вашему<br>профилю в соцсети</span>
            <div class="clearfix"></div>
            <span><br>Для того, чтобы вам было проще определиться с выбором платья, мы разработали<br>
интеллектуальную систему подбора. На основе анализа вашего профиля в одной из соцсетей,<br>
она предложит вам несколько наиболее подходящих вариантов.</span>
            <div class="clearfix"></div>
            <div class="main-form">
                <span>Вставьте ссылку</span>
                <form class="form-inline" id="main-form">
                    <div class="form-group">
                        <input type="text" name="username" id="instalogin" placeholder="https://www.instagram.com/{ваш_аккаунт}">
                        <button type="submit" class="" id="submit" data-loading-text="Расчет...">Найти платье</button>
                    </div>
                </form>
                <span>или выберите соцсеть</span>
            </div>
            <div class="clearfix"></div>
            <div class="social_icons">
                <img src="images/facebook@2x.png">
                <img src="images/instagram@2x.png">
                <img src="images/vk@2x.png">
                <img src="images/ok@2x.png">
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="content">
            <span>Вот, что нам удалось найти для вас</span>
            <div class="select-group">

                <select>
                    <option>Любой повод</option>
                </select>

                <select>
                    <option>Все цвета</option>
                </select>

                <select>
                    <option>Все сезоны</option>
                </select>

            </div>
  <%
      String acc = "";
      if (request.getParameter("username")!=null && !Objects.equals(request.getParameter("username"), "") && request.getParameter("getinfo")== null && request.getParameter("code")==null) {
          MyHttpURLConnection http = new MyHttpURLConnection();
          http.getConfig(application.getRealPath("/") + "config.json");
          //System.out.println("REQUEST = " + request.getParameter("username"));
          //System.out.println("SESSION = " + session.getAttribute("access_token"));
          //http.USERNAME = request.getParameter("username");
          //acc = request.getParameter("username");
          //System.out.println("User = " + http.USERNAME);

          if (session.getAttribute("access_token")==null) {

              try {
                  session.setAttribute("user", request.getParameter("username"));
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
                      /*out.println("Followers => " + followersCount);
                      out.println("Followed by => " + followCount);
                      out.println("Likes => " + likesCount);
                      out.println("Comments => " + commentsCount + "<br>");*/
                      /*for(String item : comments){
                          out.println(item + "<br>");
                      }*/

                      double scores = http.calcScores(followersCount, followCount, likesCount);
                      out.println("<span>Скоринг — " + String.format("%.1f",scores) + "</span><br>");
                      Map<String, Integer> map = http.getWordsCount(comments);
                      Set<Map.Entry<String,Integer>> entrySet = map.entrySet();
                      String text = "";
                      out.print("<span>");
                      for (Map.Entry<String,Integer> item : entrySet){
                          out.print(item.getKey() + " - " + item.getValue() + "<br>");
                          text += item.getKey() + " - " + item.getValue() + "<br>";
                      }
                      out.print("</span>");
                      System.out.println("USERNAME = " + request.getParameter("username"));
                        try {
                            DBConnection con = new DBConnection();
                            Connection connection = con.getConnection();

                            con.insertRow(connection, session.getAttribute("user").toString(), scores, text);
                        }
                        catch (Exception e){
                            //e.printStackTrace();
                            System.out.println(e.getMessage());
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
                  /*out.println("Followers => " + followersCount);
                  out.println("Followed by => " + followCount);
                  out.println("Likes => " + likesCount);
                  out.println("Comments => " + commentsCount + "<br>");*/
                      /*for(String item : comments){
                          out.println(item + "<br>");
                      }*/

                  double scores = http.calcScores(followersCount, followCount, likesCount);
                  out.println("<span>Скоринг — " + String.format("%.1f",scores) + "</span><br>");
                  Map<String, Integer> map = http.getWordsCount(comments);
                  Set<Map.Entry<String,Integer>> entrySet = map.entrySet();
                  String text = "";
                  out.print("<span>");
                  for (Map.Entry<String,Integer> item : entrySet){
                      out.print(item.getKey() + " - " + item.getValue() + "<br>");
                      text += item.getKey() + " - " + item.getValue() + "\n";
                  }
                  out.print("</span>");
                  System.out.println("USER = " + request.getParameter("user"));
                  try {
                      DBConnection con = new DBConnection();
                      Connection connection = con.getConnection();

                      con.insertRow(connection, session.getAttribute("user").toString(), scores, text);
                  }
                  catch (Exception e){
                      //e.printStackTrace();
                      //out.print(e.toString());
                      System.out.println(e.getMessage());
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
        </div>
    </div>

</main>
</body>
</html>
