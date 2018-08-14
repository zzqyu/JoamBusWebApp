package joambuswebapp;


import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.TimeZone;

public class DBManager {
	static String ENCORD = "UTF-8";
    //static String DB_NAME = "joambusdb";
    static String SQL_URL = "jdbc:mysql://52.79.170.189:3306/";
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
	public ArrayList<String> tableList()
			throws SQLException, UnsupportedEncodingException {
		ArrayList<String> answer = new ArrayList<String>();
		String sql = "show tables;";
		ResultSet rs = stmt.executeQuery(sql);
		while (rs.next()) {
			answer.add(rs.getString(1));
    	}
		return answer;
	}
	public ArrayList<String[]> mainRouteList(int type)
			throws SQLException, UnsupportedEncodingException {
		ArrayList<String[]> answer = new ArrayList<String[]>();
		String sql = "SELECT R.ID ,R.NAME, S.NAME, R.mid_station_name, (SELECT NAME FROM STATION WHERE ID=R.END_STATION), R.IS_ONEWAY \r\n" + 
				"FROM ROUTE AS R, STATION AS S  \r\n" + 
				"WHERE R.TYPE = " + type + " AND R.START_STATION=S.ID "+
				"order by CAST(R.NAME AS unsigned);";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer.add(new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6)});
    	}
		return answer;
	}
	public String[] routeInfo(int id)
			throws SQLException, UnsupportedEncodingException {
		String[] answer = null;
		String sql = "SELECT R.TYPE, R.NAME, S.NAME as 'START',(SELECT NAME FROM STATION WHERE ID=R.END_STATION) AS 'END', R.START_FIRST, R.END_START, R.START_LAST, R.END_LAST \r\n" + 
				"FROM ROUTE AS R, JOAMBUS.STATION AS S  \r\n" + 
				"WHERE R.ID = "+id+" AND R.START_STATION=S.ID;";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer = new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)
					, rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8)};
			break;
    	}
		return answer;
	}
	public int haveTimeType(int id) throws SQLException, UnsupportedEncodingException {
		String sql = "SELECT IS_WEEKEND , IS_UP\r\n" + 
				"FROM JOAMBUS.TIME_TABLE \r\n" + 
				"where ROUTE_ID='"+id+"'\r\n" + 
				"group by IS_WEEKEND, IS_UP;";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		int weekday=1, up=1;
		char wKeyWord='N', uKeyWord='Y';
		while (rs.next()) {
			if(weekday==1 && rs.getString(1).charAt(0)=='Y') weekday++;
			if(up==1 && rs.getString(2).charAt(0)=='N') up++;
    	}
		int answer=1;
		if(weekday==2 && up==1)answer+=1;
		else if(weekday==1 && up==2)answer+=2;
		else if(weekday==2 && up==2)answer+=3;
		return answer;
	}
	public ArrayList<ArrayList<String>> curTimeTable(int id, int timeType) throws Exception {
		ArrayList<ArrayList<String>> answer = new ArrayList<ArrayList<String>>();
		boolean isUpDown = false;
        char isWeekend = 'N';
        Date now = new Date();
        
        TimeZone kst = TimeZone.getTimeZone ("JST"); 
		// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
		Calendar cal = Calendar.getInstance ( kst ); 
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK)-1;
        if(dayOfWeek==0)dayOfWeek=7;
        int HH = cal.get(Calendar.HOUR_OF_DAY);
        int MM = cal.get(Calendar.MINUTE);
        String time = HH+":"+((MM<10)?"0"+MM:MM);
        System.out.println("dayOfWeek="+DayOfWeek.of(dayOfWeek)+" timeType = "+timeType);
        if (timeType >= 3) isUpDown = true;
        if (timeType%2==0 && 
        		(DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY 
        		|| DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY
        		|| StaticValue.isHoliday())) isWeekend = 'Y';
        
        
		String sql = "SELECT TIME \r\n" + 
				"FROM TIME_TABLE \r\n" + 
				"where ROUTE_ID='"+id+"'\r\n" + 
				"and IS_WEEKEND='"+isWeekend+"'\r\n" + 
				"and IS_UP='Y'\r\n" + 
				"and TIME>='"+time+"'\r\n" + 
				"limit 3;";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		ArrayList<String> row = new ArrayList<>();
		while (rs.next()) {
			row.add(rs.getString(1));
    	}
		answer.add(row);
		if(isUpDown) {
			sql = "SELECT TIME \r\n" + 
					"FROM TIME_TABLE \r\n" + 
					"where ROUTE_ID='"+id+"'\r\n" + 
					"and IS_WEEKEND='"+isWeekend+"'\r\n" + 
					"and IS_UP='N'\r\n" + 
					"and TIME>='"+time+"'\r\n" + 
					"limit 3;";
			System.out.println(sql.toUpperCase());
			rs = stmt.executeQuery(sql.toUpperCase());
			row = new ArrayList<>();
			while (rs.next()) {
				row.add(rs.getString(1));
	    	}
			answer.add(row);
		}
		return answer;
	}
	public ArrayList<String[]> routeStationList(int id)
			throws SQLException, UnsupportedEncodingException {
		
		ArrayList<String[]> answer = new ArrayList<String[]>();
		String sql="SELECT STATION_ID, IS_TURN, S.NAME, S.MOBILE_NO\r\n" + 
				"FROM JOAMBUS.ROUTE_STATION, JOAMBUS.STATION AS S\r\n" + 
				"WHERE ROUTE_ID='"+id+"'\r\n" + 
				"AND STATION_ID=S.ID\r\n" + 
				"order by SEQUENCE;";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer.add(new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)});
    	}
		return answer;
	}
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
	public ArrayList<String> timeTableList(int id, int type)
			throws SQLException, UnsupportedEncodingException {
		ArrayList<String> answer = new ArrayList<>();
		char up='Y', weekend='N';
		if(type%2==0) up='N';
		if(type>2) weekend='Y';
		String sql = "SELECT TIME FROM JOAMBUS.TIME_TABLE\r\n" + 
				"where ROUTE_ID='"+id+"'\r\n" + 
				"and IS_UP='"+up+"'\r\n" + 
				"and IS_WEEKEND='"+weekend+"';";
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer.add(rs.getString(1).replace(":", "").substring(0, 4));
    	}
		return answer;
	}
}




















