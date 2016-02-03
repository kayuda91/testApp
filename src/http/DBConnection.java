package http;


import org.postgresql.ds.PGPoolingDataSource;

import java.sql.*;

public class DBConnection {
    public final String URL = "jdbc:postgresql://localhost:5432/test";
    public final String HOST = "localhost";
    public final int PORT = 5432;
    public final String DB = "test";
    public final String USER = "adminDB";
    public final String PASSWORD = "adminDB";

    private static Connection connection;
    private static Statement statement;
    private static ResultSet resultSet;

    private PGPoolingDataSource source;

    public DBConnection(){
        source = new PGPoolingDataSource();
        //source.setDataSourceName("A Data Source");
        source.setServerName(this.HOST);
        source.setPortNumber(this.PORT);
        source.setDatabaseName(this.DB);
        source.setUser(this.USER);
        source.setPassword(this.PASSWORD);
        //source.setMaxConnections(20);//Максимальное значение
        source.setInitialConnections(1);//Сколько соединений будет сразу открыто
    }

    public Connection getConnection() throws SQLException {
        return source.getConnection();
    }

    public void putConnection(Connection connection) throws SQLException {
        connection.close();
    }



    public boolean insertRow(Connection connection, String instaLogin, double score, String text) throws SQLException {
        String insert = "insert into \"instaQueries\" (scores, recently_words, insta_login) values (?, ?, ?)";

        PreparedStatement statement = connection.prepareStatement(insert);
        statement.setDouble(1, score);
        statement.setString(2, text);
        statement.setString(3,instaLogin);
        return statement.execute();
    }


}
