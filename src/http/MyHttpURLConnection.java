package http;

import json.JSONArray;
import json.JSONObject;

import javax.net.ssl.HttpsURLConnection;
import java.io.*;
import java.net.URL;
import java.util.*;

/**
 * Created by kayud on 28.01.2016.
 *
 *
 * CREATE TABLE instaQueries
 (
 id integer NOT NULL DEFAULT nextval('instaQueries_id_seq'::regclass),
 scores double precision,
 recently_words text,
 insta_login text,
 CONSTRAINT id PRIMARY KEY (id)
 )
 WITH (
 OIDS=FALSE
 );
 ALTER TABLE instaQueries
 OWNER TO postgres;

 */
public class MyHttpURLConnection {

    public String REDIRECT_URI = "http://localhost:8080";
    public String CLIENT_ID = "b218e7100d2e4fdc8b06fb16e80ca5a9";//"c6c42747215240cc803a89d63a4a2a50";
    public String CLIENT_SECRET = "636f7be54a834d45aca04a6756f27458";//"f569a4de3d0b4c79a2bfea98e81d9fcb";
    public  final String USER_AGENT = "Mozilla/5.0";
    public String USERNAME = "";

    /**
     * Читаем настройки приложения для использования апи
     * @param path : путь к файлу с конфигами
     * @throws IOException
     */
    public void getConfig (String path) throws IOException {
        String result = "";
        try {
            BufferedReader br = new BufferedReader(new FileReader(path));
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();
            while (line != null) {
                sb.append(line);
                line = br.readLine();
            }
            result = sb.toString();
        } catch(Exception e) {
            e.printStackTrace();
        }
        if (!Objects.equals(result, "")) {
            JSONObject json = new JSONObject(result);
            REDIRECT_URI = json.getString("redirect_uri");
            CLIENT_ID = json.getString("client_id");
            CLIENT_SECRET = json.getString("client_secret");
        }
    }
    /**
     *
     * @param token: Токен
     * @param param: Параметр, что плоучить на выходе (0-базовая инфа, 1 фолловеры)
     * @return : JSON ответ от сервера или NULL
     * @throws Exception
     */
    public StringBuilder sendGet(String token, int param) throws Exception {

        //String url = "https://www.instagram.com/oauth/authorize/?client_id=c6c42747215240cc803a89d63a4a2a50&redirect_uri=http://localhost:8080&response_type=token";//"https://instagram.com/oauth/authorize/?client_id="+CLIENT_ID+"&redirect_uri=http://localhost:8080&response_type=token";
        String url = "";//https://api.instagram.com/v1/users/search?q="+username+"&access_token="+token;

        switch (param){
            case 1: url = "https://api.instagram.com/v1/users/self/follows/?access_token="+token; break;
            case 2: url = "https://api.instagram.com/v1/users/self/followed-by/?access_token=" + token; break;
            case 3: url = "https://api.instagram.com/v1/users/self/media/liked/?count=30&access_token=" + token; break;
            case 4: url = "https://api.instagram.com/v1/users/self/media/recent/?access_token="+token+"&count=30"; break;
            case 5: url = "https://api.instagram.com/v1/users/self/?access_token="+token;
        }
        URL obj = new URL(url);
        //HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        HttpsURLConnection httpsCon = (HttpsURLConnection) obj.openConnection();

        // optional default is GET
        httpsCon.setRequestMethod("GET");

        //add request header
        httpsCon.setRequestProperty("User-Agent", USER_AGENT);

        int responseCode = httpsCon.getResponseCode();
        //System.out.println("\nSending 'GET' request to URL : " + url);
        //System.out.println("Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(
                new InputStreamReader(httpsCon.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        //print result
        //System.out.println(response.toString());
        if (responseCode == 200){
            //calcScores(response.toString());
            return (response);
        }
        else
        {
            return null;
        }
    }

    public JSONObject getCommentToMedia(String token, String mediaId) throws Exception {
        //String url = "https://www.instagram.com/oauth/authorize/?client_id=c6c42747215240cc803a89d63a4a2a50&redirect_uri=http://localhost:8080&response_type=token";//"https://instagram.com/oauth/authorize/?client_id="+CLIENT_ID+"&redirect_uri=http://localhost:8080&response_type=token";
        String url = "https://api.instagram.com/v1/media/"+mediaId+"/comments?access_token="+token;
        URL obj = new URL(url);
        //HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        HttpsURLConnection httpsCon = (HttpsURLConnection) obj.openConnection();

        // optional default is GET
        httpsCon.setRequestMethod("GET");

        //add request header
        httpsCon.setRequestProperty("User-Agent", USER_AGENT);

        int responseCode = httpsCon.getResponseCode();
        //System.out.println("\nSending 'GET' request to URL : " + url);
        //System.out.println("Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(
                new InputStreamReader(httpsCon.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        //print result
        //System.out.println(response.toString());
        if (responseCode == 200){
            return (new JSONObject(response.toString()));
        }
        else
        {
            return null;
        }

    }

    /**
     * Пост запрос для авторизации
      * @param url : путь из апи
     * @param params : параметры для запроса
     * @return : JSON ответ от сервера
     * @throws Exception
     */
    public StringBuilder sendPost(String url, String params) throws Exception {
        URL obj = new URL(url);
        HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();

        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        con.setRequestProperty("charset", "utf-8");
        con.setRequestProperty("Content-Length", "" + Integer.toString(params.getBytes().length));

        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(params);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();
        //System.out.println("\nSending 'POST' request to URL : " + url);
        //System.out.println("Post parameters : " + params);
        //System.out.println("Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        //print result
        //System.out.println(response.toString());
        if (responseCode== 200)
        {
            return response;
        }
        else {
            StringBuilder builder = new StringBuilder();
            builder.append(responseCode);
            return builder;
        }
        //return inputLine;
        //return response;
    }

    /**
     * Считаем количество комментариев к последним 30 постам пользователя
     * @param comments : JSON объект - ответ от сервера после запроса информации
     * @return : Количество комментариев
     */
    public int calcComments(String comments) {
        int count = 0;
        JSONObject json = new JSONObject(comments);
        JSONArray data = json.getJSONArray("data");
        for(int i = 0; i < data.length(); i++){
            JSONObject obj = (JSONObject) data.get(i);
            count += obj.getJSONObject("comments").getInt("count");
        }
        return count;
    }

    /**
     * Считаем количество лайков к последним 30 постам пользователя
     * @param comments: JSON объект - ответ от сервера после запроса информации
     * @return : Количество лайков
     */
    public int likesCount(String comments) {
        int count = 0;
        JSONObject json = new JSONObject(comments);
        JSONArray data = json.getJSONArray("data");
        for(int i = 0; i < data.length(); i++){
            JSONObject obj = (JSONObject) data.get(i);
            count += obj.getJSONObject("likes").getInt("count");
        }
        return count;
    }

    /**
     * Считываем айдишники постов пользователя
     * @param comments:JSON объект - ответ от сервера после запроса инфы о пользователе
     * @return : Список айдишников последних 30 постов
     */
    public List<String> getMediaIds(String comments){
        List<String> list = new ArrayList<>();
        JSONObject json = new JSONObject(comments);
        JSONArray data = json.getJSONArray("data");
        if (data.length()>0) {
            for (int i = 0; i < data.length(); i++) {
                JSONObject obj = (JSONObject) data.get(i);
                list.add(obj.getString("id"));
                //System.out.println(obj.getString("id"));
            }
        }
        return list;
    }

    /**
     * Получаем тексты комментариев к постам
     * @param mediaIds : Список айдишников постов
     * @param token : Ключ токен
     * @return : Список из комментариев к постам
     * @throws Exception
     */
    public List<String> getCommentsTexts(List<String> mediaIds, String token) throws Exception {
        List<String> list = new ArrayList<>();
        for(String item : mediaIds){
            JSONObject response = getCommentToMedia(token, item);
            for(int i = 0; i < response.getJSONArray("data").length(); i++) {
                JSONObject text = (JSONObject) response.getJSONArray("data").get(i);
                //System.out.println("RESPONSE = " + response);
                list.add(text.getString("text"));
            }
        }

        return list;
    }

    /**
     * Подсчет скорингового балла
     * @param followersCount : Фолловеры (Подписчики)
     * @param followCount : Подписки
     * @param likesCount : Лайки
     * @return : Скоринговый балл
     */
    public double calcScores(int followersCount, int followCount, int likesCount) {
        double scores = 1;
        if (followersCount < 50){
            scores -= 0.2;
        }
        else {
            System.out.println(followersCount % 500);
            if (followersCount > 500) {
                double points = 0.1 * (followersCount / 500);
                if (points > 0.5)
                    scores += 0.5;
                else
                    scores += points;
            }
            if (followCount > 0){
                double points = 0.1 * (followCount / 200);
                if (points > 0.3)
                    points = 0.3;
                scores -= points;
            }

            if(likesCount > 30){
                double points = 0.1 * ((likesCount - 30) / 10);
                scores += points;
            }
            if (likesCount < 30){
                if (likesCount < 20){
                    if (likesCount < 10)
                        scores -= 0.3;
                    scores -= 0.2;
                }
                scores -= 0.1;
            }
        }
        return scores;
    }

    /**
     * Считаем количество слов
     * @param comments : Список комментариев
     * @return : Мап с повторяющимися словами и их количеством
     */
    public Map<String, Integer> getWordsCount (List<String> comments){
        Map<String, Integer> map = new HashMap<>();

        List<String> allWords = new ArrayList<>(); // список со всеми словами из всех комментов
        for(String comment : comments) {
            String[] aWordsArray = comment.split(" ");
            for (String wordsArray : aWordsArray) {
                if (!wordsArray.startsWith("@")) //не учитываем обращения к плоьзователям
                    allWords.add(wordsArray);
            }
        }

        for (String word : allWords){ //считаем совпадения и если совпадает то увеличиваем счетчик
            int count = 0;
            for (String item : comments)
            {
                if (word.equals(item)) count++;
            }
            if (count > 0)
                map.put(word, count); //записываем только повторяющиеся
        }
        return map;
    }
}
