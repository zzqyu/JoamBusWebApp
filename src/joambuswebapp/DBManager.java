package joambuswebapp;


import java.io.FileInputStream;
import java.io.IOException;
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
import java.util.Properties;
import java.util.TimeZone;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

import com.fasterxml.jackson.databind.ObjectMapper;

public class DBManager {
	static String ENCORD = "UTF-8";
    //static String DB_NAME = "joambusdb";
	//127.0.0.1:50344
	//본 서버
    static String SQL_URL = "jdbc:mysql://139.162.72.92:3306/";

	//예비 서버
	//static String SQL_URL = "jdbc:mysql://127.0.0.1:55863/";
	
	//로컬 서버
	//static String SQL_URL = "jdbc:mysql://127.0.0.1:3306/";

    private Connection conn = null;
    private Statement stmt = null;
    
	public DBManager(String dbName) {
		
        try {
            //sql db에 연결
            conn = MySQLJDBCUtil.getConnection(conn);
            System.out.println("DB 연결 완료");
            //sql문을 쓰기 위해 객체 생성
            stmt = conn.createStatement();
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
		/*String sql = "SELECT R.ID ,R.NAME, S.NAME, R.mid_station_name, (SELECT NAME FROM STATION WHERE ID=R.END_STATION), R.IS_ONEWAY \r\n" + 
				"FROM ROUTE AS R, STATION AS S  \r\n" + 
				"WHERE R.TYPE = " + type + " AND R.START_STATION=S.ID "+
				"order by CAST(REPLACE(REPLACE(R.NAME, '[^0-9|-]', ''), '-', '.') AS DECIMAL(10,6));";*/
		/*String sql = "SELECT R.ROUTE_ID ,R.ROUTE_NM, S.STATION_NM, R.MID_STATION, (SELECT STATION_NM FROM JOAMBUS.STATION WHERE STATION_ID=R.ED_STA_ID), R.IS_ONEWAY\r\n" + 
				"				FROM JOAMBUS.ROUTE AS R, JOAMBUS.STATION AS S  \r\n" + 
				"				WHERE R.ROUTE_TP =  " + type + " \r\n" + 
				"                AND R.ST_STA_ID=S.STATION_ID \r\n" + 
				"                AND R.IS_ONEWAY IS NOT NULL\r\n" + 
				"				order by CAST(REPLACE(REPLACE(R.ROUTE_NM, '[^0-9|-]', ''), '-', '.') AS DECIMAL(10,6));";*/
		String sql = "SELECT ROUTE_ID , ROUTE_NM, ST_STA_NM, MID_STATION, ED_STA_NM, IS_ONEWAY\r\n"
				+ "FROM JOAMBUS.ROUTE\r\n"
				+ "WHERE ROUTE_TP =  " + type + " \r\n" 
				+ "AND IS_ONEWAY IS NOT NULL\r\n"
				+ "order by CAST(REPLACE(REPLACE(REPLACE(ROUTE_NM, 'H', '0.'), '[^0-9|-]', ''), '-', '.') AS DECIMAL(10,6));";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer.add(new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6)});
    	}
		return answer;
	}
	public String[] routeInfo(int id)
			throws SQLException, UnsupportedEncodingException, NullPointerException {
		String[] answer = null;
		/*String sql = "SELECT R.TYPE, R.NAME, S.NAME as 'START',(SELECT NAME FROM STATION WHERE ID=R.END_STATION) AS 'END', R.START_FIRST, R.END_START, R.START_LAST, R.END_LAST \r\n" + 
				"FROM ROUTE AS R, JOAMBUS.STATION AS S  \r\n" + 
				"WHERE R.ID = "+id+" AND R.START_STATION=S.ID;";*/
		String sql = "SELECT R.ROUTE_TP, R.ROUTE_NM, S.STATION_NM AS 'START',(SELECT STATION_NM FROM JOAMBUS.STATION WHERE STATION_ID=R.ED_STA_ID) AS 'END', R.UP_FIRST_TIME, R.UP_LAST_TIME, R.DOWN_FIRST_TIME, R.DOWN_LAST_TIME, R.IS_ONEWAY, R.PEEK_ALLOC, R.NPEEK_ALLOC \r\n" + 
				"FROM JOAMBUS.ROUTE AS R, JOAMBUS.STATION AS S  \r\n" + 
				"WHERE R.ROUTE_ID = "+id+" AND R.ST_STA_ID=S.STATION_ID;";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer = new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)
					, rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11)};
			break;
    	}
		return answer;
	}
	public String[] gbisRouteInfo(int id)
			throws SQLException, UnsupportedEncodingException {
		String[] answer = null;
		String sql = "SELECT ROUTE_TP, ROUTE_NM, ST_STA_NM,\r\n" + 
				"ED_STA_NM, UP_FIRST_TIME, DOWN_FIRST_TIME, UP_LAST_TIME, DOWN_LAST_TIME, PEEK_ALLOC, NPEEK_ALLOC \r\n" + 
				"FROM JOAMBUS.ROUTE\r\n" + 
				"WHERE ROUTE_ID = "+id+";";
		System.out.println(sql.toUpperCase());
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while (rs.next()) {
			answer = new String[] {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)
					, rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), null,rs.getString(9),rs.getString(10)};
			break;
    	}
		return answer;
	}
	
	public ArrayList<HashMap<String,Object>> convertResultSetToArrayList(ResultSet rs) throws SQLException {
	    ResultSetMetaData md = rs.getMetaData();
	    int columns = md.getColumnCount();
	    ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	 
	    while(rs.next()) {
	        HashMap<String,Object> row = new HashMap<String, Object>(columns);
	        for(int i=1; i<=columns; ++i) {
	            row.put(md.getColumnName(i).toLowerCase(), rs.getObject(i));
	        }
	        list.add(row);
	    }
	 
	    return list;
	}
	
	public int haveTimeType(int id) throws SQLException, UnsupportedEncodingException {
		String sql="SELECT count(distinct IS_WEEKEND) as `weekday`, count(distinct IS_UP) as `up`\r\n"
				+ "FROM JOAMBUS.TIME_TABLE \r\n"
				+ "WHERE ROUTE_ID='"+id+"';";
		
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		System.out.println(sql.toUpperCase());
		int weekday = 0, up=0;
		boolean isSat = false;
		int answer=0;
		while (rs.next()) {
			weekday = rs.getInt("weekday");
			up = rs.getInt("up");
		}
		isSat =(weekday>2);
		System.out.println("asdasdas "+weekday + " " + up);
		if(weekday==0 && up==0)answer = 0;
		else {
			answer = ((up-1)<<1) + ((weekday-1)) + 1;
			if(isSat) answer=5;
			if(answer==5 && up==2) answer++;
		}
		/*if(weekday==1 && up==1)answer = 1;
		else if(weekday==2 && up==1)answer = 2;
		else if(weekday==1 && up==2)answer+=2;
		else if(weekday==2 && up==2)answer+=3;*/
		
		return answer;
	}
	public ArrayList<ArrayList<String>> curTimeTable(int id, int timeType) throws Exception {
		ArrayList<ArrayList<String>> answer = new ArrayList<ArrayList<String>>();
		boolean isUpDown = false;
		boolean isHoliday = StaticValue.isHoliday(false);
        char isWeekend = 'N';
        Date now = new Date();
        
        TimeZone kst = TimeZone.getTimeZone ("JST"); 
		// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
		Calendar cal = Calendar.getInstance ( kst ); 
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK)-1;
        if(dayOfWeek==0)dayOfWeek=7;
        if(isHoliday&&dayOfWeek<=5)dayOfWeek=7;
        int HH = cal.get(Calendar.HOUR_OF_DAY);
        int MM = cal.get(Calendar.MINUTE);
        String time = HH+":"+((MM<10)?"0"+MM:MM);
        System.out.println("dayOfWeek="+DayOfWeek.of(dayOfWeek)+" timeType = "+timeType);
        if (timeType >= 3) isUpDown = true;
        if (timeType == 5) isUpDown = false;
        if (timeType%2==0 && 
        		(DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY 
        		|| DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY)) isWeekend = 'Y';
        if(timeType >= 5) {
        	if(DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY )isWeekend = 'S';
        	if(DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY )isWeekend = 'Y';
        }
        
        
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
		if(type>=5) weekend='S';
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
	
	public ArrayList<String[]> getBusSearchResult(String keyword)
			throws SQLException, UnsupportedEncodingException {
		ArrayList<String[]> answer = new ArrayList<>();
		String sql = "select ROUTE_ID, ROUTE_NM, ST_STA_NM, ED_STA_NM, ROUTE_TP from JOAMBUS.ROUTE where ROUTE_NM like '%"+keyword+"%' order by ROUTE_NM;";
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while(rs.next()){
	        String[] row = new String[] {"ROUTE_ID", "ROUTE_NM", "ST_STA_NM", "ED_STA_NM", "ROUTE_TP"};
        	for(int i=0; i<row.length; i++)
        		row[i]=rs.getString(row[i]);
        	answer.add(row);
        }
		return answer;
	}

	public ArrayList<String> getStationInfo(String stationId)
			throws SQLException, UnsupportedEncodingException {
		ArrayList<String> answer = new ArrayList<>();
		String sql = "SELECT * FROM joambus.station WHERE STATION_ID=\"" + stationId + "\";";
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while(rs.next()){
        	for(int i=0; i<9; i++)
        		answer.add(rs.getString(i+1));
        }
		return answer;
	}
	
	public ArrayList<StationRouteInfo> getRoutesOfStation(String stationId)
			throws SQLException, UnsupportedEncodingException {
		
		ArrayList<StationRouteInfo> answer = new ArrayList<>();
		
		String sql = "SELECT CASE rs.UPDOWN WHEN 'Y' THEN r.ED_STA_NM ELSE r.ST_STA_NM END as 'DIRECT',\r\n"
				+ "					rs.STA_ORDER, rs.UPDOWN, \r\n"
				+ "					r.*\r\n"
				+ "					FROM joambus.routestation as rs, joambus.route as r \r\n"
				+ "					WHERE rs.STATION_ID = '" + stationId + "' and rs.ROUTE_ID = r.ROUTE_ID;";
		
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		ArrayList<HashMap<String,Object>> rsMaps = convertResultSetToArrayList(rs);

		ObjectMapper mapper = new ObjectMapper(); 
		
		for(HashMap<String,Object> map: rsMaps) {
			answer.add(mapper.convertValue(map, StationRouteInfo.class));
		}		
		
		return answer;
	}
	
	public void routeInsertAndUpdate(String values) {
		//INSERT INTO table_name VALUES (value1, value2, value3,...)
		String sql = "REPLACE INTO JOAMBUS.GBIS_ROUTE VALUES ";
		sql+=values+";";
		System.out.println(sql);
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
	}
	public void stationInsertAndUpdate(String values) {
		//INSERT INTO table_name VALUES (value1, value2, value3,...)
		String sql = "REPLACE INTO JOAMBUS.STATION VALUES ";
		sql+=values+";";
		System.out.println(sql);
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
	}	
	//정류장 노선목록 마을버스 추가
	public ArrayList<String> localRouteSelectAtStation(String stationId)throws SQLException {
		//SELECT ROUTE_ID FROM joambus.routestation as rs where STATION_ID = 233001517 and EXISTS (SELECT ROUTE_ID FROM joambus.route as r where IS_ONEWAY IS NOT NULL and ROUTE_TP=30 and r.ROUTE_ID=rs.ROUTE_ID);
		ArrayList<String> answer = new ArrayList<>();
		String sql = "SELECT ROUTE_ID FROM joambus.routestation as rs where STATION_ID = "+stationId+" and EXISTS (SELECT ROUTE_ID FROM joambus.route as r where IS_ONEWAY IS NOT NULL and ROUTE_TP=30 and r.ROUTE_ID=rs.ROUTE_ID);";
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while(rs.next()){
	        String item = null;
	        item = rs.getString("ROUTE_ID");
        	answer.add(item);
        }
		return answer;
	}
	//정류장 시간표 시간순
	public ArrayList<String[]> stationOfTimetable(String stationId, boolean isWeekend, Boolean[] refHoliVisible)throws SQLException {
		ArrayList<String[]> answer = new ArrayList<>();
		String where = " AND t.IS_WEEKEND=\"N\" ";
		if(isWeekend)where = " AND (t.IS_WEEKEND=\"Y\" OR (not exists (select IS_WEEKEND from joambus.time_table where ROUTE_ID=rs.ROUTE_ID AND IS_WEEKEND=\"Y\"))) ";
		String sql = "SELECT t.TIME, rs.ROUTE_ID, rs.ROUTE_NM, "+
				" CASE WHEN is_up = 'Y' THEN r.ST_STA_NM ELSE r.ED_STA_NM END AS `출발지`,"+
				
				" CASE WHEN EXISTS(select * from joambus.time_table where IS_UP=\"N\") THEN /*상하행 둘다*/(CASE WHEN UPDOWN = 'N' THEN r.ST_STA_NM ELSE r.ED_STA_NM END) ELSE/*상행만*/(CASE WHEN UPDOWN = 'N' THEN r.ST_STA_NM ELSE r.ED_STA_NM END) END AS `도착지`   " + 
				/*" CASE WHEN EXISTS(select * from joambus.time_table where IS_UP=\"N\")  THEN  r.ST_STA_NM ELSE r.ED_STA_NM END AS `도착지` " +*/ 
				/*" CASE WHEN rs.STA_ORDER >= (select STA_ORDER from joambus.routestation where ROUTE_ID=r.ROUTE_ID and STATION_ID=r.ED_STA_ID limit 1) THEN  r.ST_STA_NM ELSE r.ED_STA_NM END AS `도착지`" + */
				
				" FROM joambus.time_table as t, (select ROUTE_ID, STATION_ID, UPDOWN, ROUTE_NM from joambus.routestation) as rs, (select ROUTE_ID, ST_STA_NM, ED_STA_NM from joambus.route) as r  " + 
				" WHERE rs.STATION_ID="+stationId+
				" AND rs.ROUTE_ID!=233000139 AND rs.ROUTE_ID!=233000271 AND rs.ROUTE_ID=t.ROUTE_ID AND r.ROUTE_ID=t.ROUTE_ID"+
				where+
				" AND (t.IS_UP=rs.UPDOWN OR (t.IS_UP!=rs.UPDOWN AND not exists (select IS_UP from joambus.time_table where ROUTE_ID=rs.ROUTE_ID AND IS_UP=\"N\"))) " + 
				" ORDER BY t.TIME;";
		System.out.println(sql);
		//String[] routeNms= {"50-1","2000"};//공휴일 있는 노선 확인 용
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while(rs.next()){//시간, rID, 노선명, 시간표기준지, 방향
        	answer.add(new String[] {rs.getString(1).substring(0, 5), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)});
        	/*if(refHoliVisible!=null && !refHoliVisible[0]) {
        		for(String nm: routeNms) {
        			if(rs.getString(3).contains(nm)) {
        				refHoliVisible[0] = true;
        				break;
        			}
        		}
        	}*/
        }
		return answer;
	}
	//정류장 시간표 출발지별 시간순 + 현재시간 이후 3타임
	public HashMap<String, ArrayList<String[]>> stationOfTimetableOrderbyStart(String stationId, boolean isWeekend, String time)throws SQLException {
		HashMap<String, ArrayList<String[]>> answer = new HashMap<>();
		String where = " AND t.IS_WEEKEND=\"N\"";
		String timeSql = " AND t.TIME >= \""+time+"\"";
		if(time==null) timeSql="";
		if(isWeekend)where = " AND (t.IS_WEEKEND=\"Y\" OR (not exists (select IS_WEEKEND from joambus.time_table where ROUTE_ID=rs.ROUTE_ID AND IS_WEEKEND=\"Y\")))";
		String sql = "SELECT t.TIME, rs.ROUTE_ID, rs.ROUTE_NM, "+
				" CASE WHEN is_up = 'Y' THEN r.ST_STA_NM ELSE r.ED_STA_NM END AS `출발지`,"+
				
				" CASE WHEN EXISTS(select * from joambus.time_table where IS_UP=\"N\") THEN /*상하행 둘다*/(CASE WHEN UPDOWN = 'N' THEN r.ST_STA_NM ELSE r.ED_STA_NM END) ELSE/*상행만*/(CASE WHEN UPDOWN = 'N' THEN r.ST_STA_NM ELSE r.ED_STA_NM END) END AS `도착지`  " + 
				/*" CASE WHEN EXISTS(select * from joambus.time_table where IS_UP=\"N\")  THEN  r.ST_STA_NM ELSE r.ED_STA_NM END AS `도착지` " +*/ 
				/*" CASE WHEN rs.STA_ORDER >= (select STA_ORDER from joambus.routestation where ROUTE_ID=r.ROUTE_ID and STATION_ID=r.ED_STA_ID limit 1) THEN  r.ST_STA_NM ELSE r.ED_STA_NM END AS `도착지`" +*/ 

				" FROM joambus.time_table as t, (select ROUTE_ID, STATION_ID, UPDOWN, ROUTE_NM from joambus.routestation) as rs, (select ROUTE_ID, ST_STA_NM, ED_STA_NM from joambus.route) as r  " + 
				" WHERE rs.STATION_ID="+stationId+
				" AND rs.ROUTE_ID!=233000139 AND rs.ROUTE_ID!=233000271 AND rs.ROUTE_ID=t.ROUTE_ID AND r.ROUTE_ID=t.ROUTE_ID"+
				where+
				" AND (t.IS_UP=rs.UPDOWN OR (t.IS_UP!=rs.UPDOWN AND not exists (select IS_UP from joambus.time_table where ROUTE_ID=rs.ROUTE_ID AND IS_UP=\"N\")))" + 
				timeSql+
				" ORDER BY `출발지`, t.TIME;";
		System.out.println(sql);
		ResultSet rs = stmt.executeQuery(sql.toUpperCase());
		while(rs.next()){
			String key = rs.getString(4);
			if(answer.containsKey(key)) {//키 있을때
				if(time!=null&&answer.get(key).size()==3) continue;
				answer.get(key).add(new String[] {rs.getString(1).substring(0, 5), rs.getString(2), rs.getString(3), rs.getString(5)});
			}
			else {//키 처음
				ArrayList<String[]> item = new ArrayList<>();
				item.add(new String[] {rs.getString(1).substring(0, 5), rs.getString(2), rs.getString(3), rs.getString(5)});
				answer.put(key, item);
			}
			
        }
		return answer;
	}
}

class MySQLJDBCUtil {

    /**
     * Get database connection
     *
     * @return a Connection object
     * @throws SQLException
     * @throws ClassNotFoundException 
     */
	static Connection getConnection(Connection conn) throws SQLException, ClassNotFoundException {
		if(conn!=null)return conn;
        conn = null;

        try {

            // load the properties file
            Properties pros = new Properties();
            pros.load(MySQLJDBCUtil.class.getClassLoader().getResourceAsStream("info.properties"));
            
            StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
            encryptor.setPassword("password");
    	    encryptor.setAlgorithm("PBEWITHMD5ANDDES"); 
    	    
            // assign db parameters
            String driverName = pros.getProperty("db.driverName");
            String url = pros.getProperty("db.url");
            String user = pros.getProperty("db.id");
            String password = pros.getProperty("db.pwd");
            
            url = encryptor.decrypt(url);
            user = encryptor.decrypt(user);
            password = encryptor.decrypt(password);
            
            Class.forName(driverName);
            
            // create a connection to the database
            conn = DriverManager.getConnection(url, user, password);
        } catch (IOException e) {
            System.out.println(e.getMessage());
            String path = System.getProperty("user.dir");
            System.out.println("Working Directory = " + path);
            
        }
        return conn;
    }
	
	
}




















