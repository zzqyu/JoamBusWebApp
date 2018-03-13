package joambuswebapp;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.HashMap;


public class DBManager {
	static String ENCORD = "UTF-8";
    //static String DB_NAME = "joambusdb";
    static String SQL_URL = "jdbc:mysql://ec2-13-125-133-124.ap-northeast-2.compute.amazonaws.com:3306/";
    static String SQL_CLASS_NAME = "com.mysql.jdbc.Driver";

    private Connection conn;
    private Statement stmt = null;
    
	public DBManager(String dbName) {
		
        try {
            Class.forName(SQL_CLASS_NAME);
            //sql db에 연결
            conn = DriverManager.getConnection(SQL_URL+dbName , "root", "005410");
            System.out.println("DB 연결 완료");
            //sql문을 쓰기 위해 객체 생성
            stmt = conn.createStatement();
            //ResultSet srs = stmt.executeQuery("show tables");
            //while (srs.next()) 
            //	System.out.println(srs.getString("Tables_in_busarrivaldb"));
        } catch (ClassNotFoundException e) {
            System.out.println("JDBC 드라이버 로드 에러");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("SQL 실행 에러");
            e.printStackTrace();
        } 
	}
	/*
	public ArrayList<HashMap<String, String>> getDBDataList(String tableName, String[] tagTitles, String criteriaTag, boolean isInc) throws SQLException{
		String sql = "SELECT ";
		for (String tag: tagTitles) {
			sql+=(tag+",");
		}
		sql+="FROM";
		sql=sql.replace(",FROM", " FROM "+ tableName + " ORDER BY "+ criteriaTag + " ASC;");
		if (!isInc) 
			sql.replace("ASC", "DESC");
		//System.out.println(sql);
		
		
		return getDBDataList(sql, tagTitles);
	}*/
	public ArrayList<HashMap<String, String>> getDBDataList(String tableName, String[] tagTitles, String criteriaTag, boolean isInc, String[] conditionTags, String[] conditionValue) throws SQLException{
		String sql = "SELECT ";
		for (String tag: tagTitles) {
			sql+=(tag+",");
		}
		sql+="FROM";
		sql=sql.replace(",FROM", " FROM "+ tableName + " ");
		if(conditionTags!=null && conditionValue!=null) {
			sql+="WHERE ";
			for(int i=0; i<conditionTags.length;i++) {
				sql+=(conditionTags[i]+"='"+conditionValue[i]+"',");
			}
		}
		sql+=("ORDER BY "+ criteriaTag + " ASC;");
		sql=sql.replace(",ORDER", " ORDER");
		if (!isInc) 
			sql.replace("ASC", "DESC");
		//System.out.println(sql);
		return getDBDataList(sql, tagTitles);
	}
	
	public ArrayList<HashMap<String, String>> getDBDataList(String sql, String[] tagTitles) throws SQLException{
		ArrayList<HashMap<String, String>> answer = new ArrayList<>();
		System.out.println(sql);
		ResultSet rs = stmt.executeQuery(sql);
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnsNumber = rsmd.getColumnCount();
        if (rs.wasNull()) {
        	System.out.println("결과가 없습니다.");
        	return null;
        }
        while (rs.next()) {
        	HashMap<String, String> row = new HashMap<>();
        	for(int i = 1; i <= columnsNumber; i++) {
                row.put(tagTitles[i-1], rs.getString(i));
        	}
        	answer.add(row);
        }
		
		return answer;
	}
	

}
