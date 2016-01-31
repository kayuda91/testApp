package http;

import org.jooq.*;
import org.jooq.impl.DSL;

import java.sql.*;

/**
 * Created by kayud on 31.01.2016.
 *
 */

/**
 * This JOOQ example relies on three tables to be present in a MYSQL database.
 * Initial filling is supplied by the example itself @see initialize(DSLContext databaseContext)
 *
 * Schema name
 * ===========
 * LOOQTEST (
 *      CREATE DATABASE looqtest;
 *      USE looqtest;
 * )
 *
 * Tables
 * ======
 * CREATE TABLE food (
 *      id BIGINT PRIMARY KEY,
 *      kind VARCHAR(255)
 * );
 *
 * CREATE TABLE dinner_guests(
 *      id BIGINT PRIMARY KEY,
 *      name VARCHAR(255)
 * );
 *
 * CREATE TABLE dinner_favorites (
 *      foodid BIGINT NOT NULL,
 *      dinner_guest_id BIGINT NOT NULL,
 *      FOREIGN KEY fk_food(foodid) REFERENCES food(id),
 *      FOREIGN KEY fk_dinner_guests(dinner_guest_id) REFERENCES dinner_guests(id)
 * );
 */

public class DBConnection {
    public final String URL = "jdbc:postgresql://localhost:5432/test";
    public final String USER = "adminDB";
    public final String PASSWORD = "adminDB";

    private static Connection connection;
    private static Statement statement;
    private static ResultSet resultSet;

    public void setConnection(){
        try {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertRow(String instaLogin, double score, String text){
        String insert = "INSERT INTO public.\"instaQueries\"(" +
                "             \"insta_login\", scores, \"recently_words\")" +
                "    VALUES ('test', 1.1, 'qwerty - 2 qewqwe - 1');";
        setConnection();
        DSLContext db = DSL.using(connection, SQLDialect.POSTGRES);

        Table<Record> instaQueries;
        Field<String> insta_login;
        Field<String> recently_words;
        Field<Double> scores;
        //db.insertInto(, insta_login, scores, recently_words);

    }

    
}
