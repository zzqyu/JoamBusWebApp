package joambuswebapp;


import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;




public class StaticValue {
	//busstationservice
	
	public final static String DAY_URL="http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?serviceKey=zRuxSFejoJKPbOZdUuxyIUWJF7R56lxvA5LbRwxQWj8IVxCG2F6aYImQvUJIdzvjM3EDvvYQfrQyIirNaYWkqA%3D%3D&";
	public final static String URL = "http://openapi.gbis.go.kr/ws/rest";
	public final static String URL_GET_STATION_ROUTE_LIST = "/busstationservice/route";
	public final static String URL_GET_BUS_ROUTE_INFO_ITEM = "/busrouteservice/info";
	public final static String URL_GET_BUS_ROUTE_STATION_LIST = "/busrouteservice/station";
	public final static String URL_GET_BUS_LOCATION_LIST = "/buslocationservice";
	public final static String URL_GET_BUS_STATION_ARRIVE_LIST = "/busarrivalservice/station";
	public final static String URL_GET_STATION_LIST = "/busstationservice";
	public final static String PUBLIC_SERVICE_KEY = "?serviceKey=1234567890";
	public final static String PRIVATE_SERVICE_KEY = "?serviceKey=zRuxSFejoJKPbOZdUuxyIUWJF7R56lxvA5LbRwxQWj8IVxCG2F6aYImQvUJIdzvjM3EDvvYQfrQyIirNaYWkqA%3D%3D";
	public final static String SERVICE_KEY = PRIVATE_SERVICE_KEY;
	public final static String SERVER_URL = "https://joambusapp.azurewebsites.net";
    public final static String SERVER_URL_TIME = "/routetime";
    public final static String SERVER_URL_APP = "/appfile";
    public final static String AD = "<div style=\"position:fixed;z-index: 3; background:#192231; padding-top:0px; bottom:-8px;left:0px;width:100%;\">\r\n" + 
    		"<ins class=\"kakao_ad_area\" style=\"display:none;\" \r\n" + 
    		"	 data-ad-unit    = \"DAN-tol7l6smt92u\" \r\n" + 
    		"	 data-ad-width   = \"320\" \r\n" + 
    		"	 data-ad-height  = \"50\"></ins> " + 
    		"</div>" + 
    		"<script type=\"text/javascript\" src=\"//t1.daumcdn.net/kas/static/ba.min.js\" async></script>";
    
    
    public final static String[] MAIN_SERVLET_TABLE_TAGS = {"routeName","routeId","startStationName","middleStationName","endStationName", "routeTypeCd", "isOneWay"};
    public final static String[] ROUTEINFO_SERVLET_STATION_LIST_TAG = {"centerYn", "mobileNo", "regionName", "stationId", "stationName", "x", "y", "stationSeq", "turnYn"};
    public final static String[] ROUTEINFO_SERVLET_ROUTEINFO_TAG = {"routeTypeCd", "startStationName", "endStationName", "routeName", "upFirstTime", "downFirstTime", "upLastTime", "downLastTime"};
    public final static String[] STATIONINFO_SERVLET_ROUTEINFO_TAG = {"routeName", "routeId", "startStationName", "middleStationName", "endStationName", "routeTypeCd", "isOneWay"};
    public final static String ROUTE_INFO_TABLE_NAME = "routeInfo";
    public final static String STATION_OF_ROUTE_TABLE_NALE = "routestation";
    public final static String JOAMBUS_DB_NAME = "joambusdb";
    public final static String ARRIVAL_TIME_DB_NAME = "busarrivaldb";
    
	
	public static String RouteTypeToColorName(String routeType)
    {
        if (routeType == null)
            return "GREEN";
        switch (routeType)
        {
            //직좌, 광역, 경기순환
            case "11":
            case "14":
            case "16": return "RED";
            case "13": return "GREEN";
            case "12": return "BLUE";
            case "15": return "PUPPLE";
            case "30": return "YELLOW";
            //시외, 공항
            case "41":
            case "42":
            case "43":
            case "51":
            case "52":
            case "53": return "GRAY";
            default: return "GREEN";
        }
    }
	public static String RouteTypeToColor(String routeType)
    {
        final String GREEN = "#00a080", RED = "#f04d2f", BLUE = "#0489b4",
            GRAY = "#333333", YELLOW = "#fcb814", PUPPLE = "#ba5c88";
        if (routeType == null)
            return GREEN;
        switch (routeType)
        {
            //직좌, 광역, 경기순환
            case "11":
            case "14":
            case "16": return RED;
            case "13": return GREEN;
            case "12": return BLUE;
            case "15": return PUPPLE;
            case "30": return YELLOW;
            //시외, 공항
            case "41":
            case "42":
            case "43":
            case "51":
            case "52":
            case "53": return GRAY;
            default: return GREEN;
        }
    }
	public static int getTimeType(String ri, HttpServletRequest request)
    {
        String u = rootURL(request) + StaticValue.SERVER_URL_TIME + "/route_time_type_list.xml";
        URL url;
		try {
			url = new URL(u);
			URLConnection connection = url.openConnection();
			Document doc = StaticValue.parseXML(connection.getInputStream());
			NodeList descNodes = doc.getElementsByTagName("routeTimeType");
			for (int i = 0; i < descNodes.getLength(); i++) {
				String routeId = null;
				String type = null;
				for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
					switch (node.getNodeName()) {
					case "routeId":
						routeId = node.getTextContent();
						break;
					case "type":
						type = node.getTextContent();
						break;
					}
				}
				if(routeId.equals(ri)) {
					return Integer.parseInt(type);
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return 1;
    }
	public static ArrayList<String> getTimeList(String routeId, boolean isUp, boolean isWeekday, HttpServletRequest request)
    {
        int typeNo = 1;
        if (!isUp && isWeekday) typeNo = 2;
        else if (isUp && !isWeekday) typeNo = 3;
        else if (!isUp && !isWeekday) typeNo = 4;
        System.out.println("getTimeList typeNo "+ typeNo);
        return getTimeList(routeId, typeNo, request);
        
    }
	public static ArrayList<String> getTimeList(String routeId, int typeNo, HttpServletRequest request)
    {
        ArrayList<String> result = new ArrayList<String>();
        String u = rootURL(request) + SERVER_URL_TIME + "/" + routeId + "/time_table_type_" + typeNo + ".xml";
        try {
        	URL url = new URL(u);
			URLConnection connection = url.openConnection();
			Document doc = StaticValue.parseXML(connection.getInputStream());
			NodeList descNodes = doc.getElementsByTagName("timeItem");
			if(descNodes==null) return null;
			for (int i = 0; i < descNodes.getLength(); i++) {
				result.add(descNodes.item(i).getTextContent());
			}
			return result;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
        
    }
	public static int findTimeIndex(ArrayList<String> as, String s) {
		int i = -1;
		for(i = 0; i<as.size(); i++) {
			if(Integer.parseInt(as.get(i))>Integer.parseInt(s))
				break;
		}
		return i;
	}
	public static int findTimeIndex2(ArrayList<ArrayList<Object>> as, Time s) {
		int i = -1;
		for(i = 0; i<as.size(); i++) {
			if(((Time)as.get(i).get(0)).compareTo(s)==1)
				break;
		}
		return i;
	}
	public static String rootURL(HttpServletRequest request) {
		return request.getRequestURL().toString().replace(request.getRequestURI(),"");
	}
	public static ArrayList<String> routeLocalization() throws Exception {
		
		ArrayList<String> routeList = new ArrayList<String>();
		final String[] staIdArray =
            { "233001070","233000402","233000931","233000992","233000372",
            //우정읍사무소, 어은삼거리, 어은4리 , 장안여중, 조암8리
            //해창1리 ,석포삼거리,석포5리마을회관,석포1리, 마파지,매향3리,이화리, 장안6리
        "233000927","233000397","233001381","233001516","233002863", "233001779", "233001053", "233000991"};
		
		for(String ri:staIdArray) {
			String u = URL + URL_GET_STATION_ROUTE_LIST + SERVICE_KEY + "&stationId="+ri;
	        URL url = new URL(u);
			URLConnection connection = url.openConnection();
			//connection.setConnectTimeout(15000);
			connection.setReadTimeout(15000);
			Document doc = StaticValue.parseXML(connection.getInputStream());
			NodeList descNodes = doc.getElementsByTagName("busRouteList");
			for (int i = 0; i < descNodes.getLength(); i++) {
				String routeId = null;// 노선 ID
				for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
					if (node.getNodeName().equals("routeId")) {
						routeId = node.getTextContent();
						continue;
					}
				}
				
				
				if (!routeList.contains(routeId))
					routeList.add(routeId);
			}
		}
		routeList.add("241483004");
		routeList.add("241483010");
		return routeList;
	}
	
	public static Document parseXML(InputStream stream) throws Exception {

		DocumentBuilderFactory objDocumentBuilderFactory = null;
		DocumentBuilder objDocumentBuilder = null;
		Document doc = null;

		try {

			objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
			objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();
			doc = objDocumentBuilder.parse(stream);

		} catch (Exception ex) {
			throw ex;
		}

		return doc;
	}
	
	public static InputStream getXmlAtUri(String uri) throws IOException, InterruptedException {
		System.out.println(uri);
		HttpClient client = HttpClient.newHttpClient();
        HttpRequest hRequest = HttpRequest.newBuilder()
                .uri(URI.create(uri))
                .build();

        HttpResponse<InputStream>hResponse = client.send(hRequest,
                HttpResponse.BodyHandlers.ofInputStream());
        return hResponse.body();
	}
	
	
	
	public static boolean isHoliday(boolean isAddSat) throws Exception {
		TimeZone kst = TimeZone.getTimeZone ("JST"); 
		Calendar cal = Calendar.getInstance ( kst ); 
		int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
		if((isAddSat && DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY) || DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY) {
			return true;
		}
		String u = DAY_URL+"solYear="+ new SimpleDateFormat ("yyyyMM").format(cal.getTime());
		String today = new SimpleDateFormat ("yyyyMMdd").format(cal.getTime());
        System.out.println(today);
        System.out.println(u);
		URL url = new URL(u);
		URLConnection connection = url.openConnection();
		connection.setReadTimeout(15000);
		Document doc = StaticValue.parseXML(connection.getInputStream());
		NodeList descNodes = doc.getElementsByTagName("locdate");
		
		TransformerFactory tf = TransformerFactory.newInstance();

		Transformer transformer = tf.newTransformer();

		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");

		StringWriter writer = new StringWriter();

		transformer.transform(new DOMSource(doc), new StreamResult(writer));

		String output = writer.getBuffer().toString();

		System.out.println(output);


		if(descNodes==null) return false;
		for (int i = 0; i < descNodes.getLength(); i++) {
			String day = descNodes.item(i).getTextContent();
			
			if(today.equals(day)) 
				return true;
		}
		return false;
	}
	@SuppressWarnings("deprecation")
	public static ArrayList<Time> timetableOfRouteInStation(String route, String stationId, boolean isrouteId){
		ArrayList<Time> timeList = new ArrayList<>();
		ArrayList<Time> answer = new ArrayList<>();
		HashMap<Integer, Integer> countOfListSize = new HashMap<>();
		
		String routeTag = isrouteId?"routeID":"routeNo";
		
		DBManager dbm = new DBManager(ARRIVAL_TIME_DB_NAME);
		try {
			for(String tableName : dbm.tableList()) {
				ArrayList<HashMap<String, String>> dateTimetable = dbm.getDBDataList(tableName, new String[] {"arrTime"}, "arrTime", true, new String[] {routeTag, "stationID"}, new String[] {route, stationId});
				if(dateTimetable == null) {
					System.out.println("!!");
					continue; 
				}
				//날짜별 시간표 사이즈 개수 수집
				int timetableSize = dateTimetable.size();
				if(timetableSize!=0) {
					if(!countOfListSize.containsKey(timetableSize))
						countOfListSize.put(timetableSize, 1);
					else
						countOfListSize.put(timetableSize, countOfListSize.get(timetableSize)+1);
					
					for (HashMap<String, String> row: dateTimetable) {
						String[] strTime = (row.get("arrTime")).split("[:.]"); //HH:mm:ss.000000
						timeList.add(new Time(Integer.parseInt(strTime[0]), Integer.parseInt(strTime[1]), Integer.parseInt(strTime[2])));
					}
				}
			
			}
			if (countOfListSize.isEmpty())
				return null;
			
			StaticGMethod<Integer> sm = new StaticGMethod<>();
			countOfListSize = sm.sortByValue(countOfListSize, true);
			
			timeList.sort((x, y) -> x.compareTo(y));
			
			int div = (int)countOfListSize.keySet().toArray()[0];
			float gap = timeList.size()/div;
			float startIndex = gap/2;
			float index = startIndex;
			while (index < timeList.size()) {
				answer.add(timeList.get(Math.round(index)));
				index+=gap;
			}

			
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return answer;
		//ArrayList<HashMap<String, String>> a = dbm.getDBDataList(tableName, tagTitles, criteriaTag, isInc, conditionTags, conditionValue)
	}
	
	public static ArrayList<ArrayList<Object>> timetableOfStation(String stationId){
		DBManager dbm = new DBManager(JOAMBUS_DB_NAME);
		ArrayList<ArrayList<Object>> timetable = new ArrayList<>();
		try {
			ArrayList<HashMap<String, String>> routeItemList=dbm.getDBDataList(StaticValue.STATION_OF_ROUTE_TABLE_NALE, new String[] {"routeId"}, "routeId", false, new String[] {"stationId"}, new String[] {stationId});
			for(HashMap<String, String> row : routeItemList) {
				String routeNo = dbm.getDBDataList(StaticValue.ROUTE_INFO_TABLE_NAME, new String[] {"routeName"}, "routeName", false, new String[] {"routeId"}, new String[] {row.get("routeId")}).get(0).get("routeName");
				if(routeNo.contains("50-1") || routeNo.equals("28")|| routeNo.equals("8155")) continue;
				for(Time t: timetableOfRouteInStation(routeNo, stationId, false)) {
					ArrayList<Object> timetableRow = new ArrayList<>();
					timetableRow.add(t);
					timetableRow.add(routeNo);
					timetable.add(timetableRow);
				}
			}
			timetable.sort((x, y) -> ((Time)x.get(0)).compareTo((Time)y.get(0)));
			/*
			for(ArrayList<Object> row : timetable) {
				System.out.println( (Time)row.get(0) + "\t" +   (String)row.get(1));
			}*/
			return timetable;
		
		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
			return null;
		}
		
	}
	/**
	 * @param stationId 정류장 id
	 * @return 해당 정류장을 경유하는 노선들의 id 리스트
	 */
	public static ArrayList<String> stopByRouteList(String stationId) {
		ArrayList<String> routeList = null;
		String u = StaticValue.URL + StaticValue.URL_GET_STATION_ROUTE_LIST + StaticValue.SERVICE_KEY + "&stationId="+stationId;
		try {
			routeList = new ArrayList<String>();
		
			Document doc = StaticValue.parseXML(getXmlAtUri(u));
			NodeList descNodes = doc.getElementsByTagName("busRouteList");
			for (int i = 0; i < descNodes.getLength(); i++) {
				String routeId = null;// 노선 ID
				for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
					if (node.getNodeName().equals("routeId")) {
						routeId = node.getTextContent();
						continue;
					}
				}
				
				
				if (!routeList.contains(routeId))
					routeList.add(routeId);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return routeList;
	}
	
	
	/**
	 * @param stationId 정류장 id
	 * @return 정류장에 도착 예정인 버스정보 목록
	 * @throws Exception
	 */
	public static ArrayList<BusArriveStation> getBusArriveStation(String stationId) throws Exception {
		ArrayList<BusArriveStation> result = new ArrayList<BusArriveStation>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_STATION_ARRIVE_LIST + StaticValue.SERVICE_KEY + "&stationId="
				+ stationId;
		
		Document doc = StaticValue.parseXML(getXmlAtUri(u));
		NodeList descNodes = doc.getElementsByTagName("busArrivalList");
		System.out.println(descNodes.getLength());
		for (int i = 0; i < descNodes.getLength(); i++) {
			stationId = null; 
			String routeId = null; 
			String locationNo1 = null; 
			String predictTime1 = null; 
			String lowPlate1 = null; 
			String plateNo1 = null; 
			String remainSeatCnt1 = null; 
			String locationNo2 = null; 
			String predictTime2 = null; 
			String lowPlate2 = null; 
			String plateNo2 = null; 
			String remainSeatCnt2 = null; 
			String staOrder = null; 
			String flag = null; 

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				System.out.println(node.getNodeName());
				switch (node.getNodeName()) {
				
				case "stationId" : stationId = node.getTextContent(); break;
				case "routeId" : routeId = node.getTextContent(); break;
				case "locationNo1" : locationNo1 = node.getTextContent(); break;
				case "predictTime1" : predictTime1 = node.getTextContent(); break;
				case "lowPlate1" : lowPlate1 = node.getTextContent(); break;
				case "plateNo1" : plateNo1 = node.getTextContent(); break;
				case "remainSeatCnt1" : remainSeatCnt1 = node.getTextContent(); break;
				case "locationNo2" : locationNo2 = node.getTextContent(); break;
				case "predictTime2" : predictTime2 = node.getTextContent(); break;
				case "lowPlate2" : lowPlate2 = node.getTextContent(); break;
				case "plateNo2" : plateNo2 = node.getTextContent(); break;
				case "remainSeatCnt2" : remainSeatCnt2 = node.getTextContent(); break;
				case "staOrder" : staOrder = node.getTextContent(); break;
				case "flag" : flag = node.getTextContent(); break;
				
				}
				System.out.println(node.getTextContent());

			}
			result.add(new BusArriveStation(stationId,  routeId,  locationNo1, predictTime1,  lowPlate1,  plateNo1,  remainSeatCnt1,   locationNo2,  predictTime2,  lowPlate2,  plateNo2,  remainSeatCnt2,  staOrder,  flag));
		}

		return result;
	}
	
	/**
	 * @param routeIdList 노선의 ID 리스트
	 * @param request
	 * @return 노선들의 정보를 담은 리스트 리턴
	 * @throws Exception
	 */
	public static ArrayList<RouteInfoItem> getRouteInfoItem(ArrayList<String> routeIdList, HttpServletRequest request) throws Exception{
		ArrayList<RouteInfoItem> result = new ArrayList<RouteInfoItem>();
		for(String ri:routeIdList) {
			String u = URL + URL_GET_BUS_ROUTE_INFO_ITEM + SERVICE_KEY + "&routeId=" + ri;
		
			Document doc = StaticValue.parseXML(getXmlAtUri(u));
			NodeList descNodes = doc.getElementsByTagName("busRouteInfoItem");
			for (int i = 0; i < descNodes.getLength(); i++) {
				String companyName="";
				String companyTel="";
				String downFirstTime="";
				String downLastTime="";
				String endMobileNo="";
				String endStationId="";
				String endStationName="";
				String routeId="";
				String routeName="";
				String routeTypeCd="";
				String startMobileNo="";
				String startStationId="";
				String startStationName="";
				String upFirstTime="";
				String upLastTime="";
			
				for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
					switch(node.getNodeName()) {
						case "companyName" : companyName = node.getTextContent();  break;
						case "companyTel" :  companyTel= node.getTextContent(); break;
						case "downFirstTime" :  downFirstTime= node.getTextContent(); break;
						case "downLastTime" : downLastTime = node.getTextContent(); break;
						case "endMobileNo" :  endMobileNo= node.getTextContent(); break;
						case "endStationId" : endStationId = node.getTextContent(); break;
						case "endStationName" :endStationName  = node.getTextContent(); break;
						case "routeId" : routeId = node.getTextContent(); break;
						case "routeName" : routeName = node.getTextContent(); break;
						case "routeTypeCd" : routeTypeCd = node.getTextContent(); break;
						case "startMobileNo" : startMobileNo = node.getTextContent(); break;
						case "startStationId" : startStationId = node.getTextContent(); break;
						case "startStationName" : startStationName = node.getTextContent(); break;
						case "upFirstTime" : upFirstTime = node.getTextContent(); break;
						case "upLastTime" : upLastTime = node.getTextContent(); break;
					}
	
				}
				result.add(new RouteInfoItem(companyName, companyTel, downFirstTime, downLastTime, endMobileNo, endStationId, endStationName, routeId, routeName, routeTypeCd, startMobileNo, startStationId, startStationName, upFirstTime, upLastTime));
			}
		}
		result.sort((x, y) -> new Float (Float.parseFloat(x.getRouteName().replace('-', '.').replaceAll("[^0-9.]", "")))
	            .compareTo(Float.parseFloat(y.getRouteName().replace('-', '.').replaceAll("[^0-9.]", ""))));
	            
		return result;
	}

	
	
	/**
	 * @param routeId 노선의 id
	 * @return 노선의 정류장 리스트 
	 * @throws Exception
	 */
	public static ArrayList<String[]> getRouteStationList(int routeId) throws Exception {
		ArrayList<String[]> result = new ArrayList<>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_ROUTE_STATION_LIST + StaticValue.SERVICE_KEY + "&routeId="
				+ routeId;
		
		Document doc = StaticValue.parseXML(getXmlAtUri(u));
		NodeList descNodes = doc.getElementsByTagName("busRouteStationList");
		for (int i = 0; i < descNodes.getLength(); i++) {
			String mobileNo = null;
			String stationId= null;
			String stationName= null;
			String turnYn= null;

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				switch (node.getNodeName()) {

				case "mobileNo":
					mobileNo = node.getTextContent();
					break;
				case "stationId":
					stationId = node.getTextContent();
					break;
				case "stationName":
					stationName = node.getTextContent();
					break;
				case "turnYn":
					turnYn = node.getTextContent();
					break;

				}

			}
			result.add(new String[]{stationId, turnYn, stationName, mobileNo});
		}

		return result;
	}
	/**
	 * @param routeId 노선의 id
	 * @return 노선의 실시간 버스 위치 정보 리스트
	 * @throws Exception
	 */
	//stationSeq, endBus, lowPlate, plateNo, plateType, remainSeatCnt, routeId+"", stationId
	public static ArrayList<String[]> getBusLocationList(int routeId) throws Exception {
		ArrayList<String[]> result = new ArrayList<>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_LOCATION_LIST + StaticValue.SERVICE_KEY + "&routeId="
				+ routeId;
		
		Document doc = StaticValue.parseXML(getXmlAtUri(u));
		NodeList descNodes = doc.getElementsByTagName("busLocationList");
		for (int i = 0; i < descNodes.getLength(); i++) {
			String endBus = null;
			String lowPlate = null;
			String plateNo = null;
			String plateType = null;
			String remainSeatCnt = null;
			String stationId = null;
			String stationSeq = null;

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				switch (node.getNodeName()) {
				
				case "endBus" :  endBus = node.getTextContent(); break;
				case "lowPlate" : lowPlate  = node.getTextContent(); break;
				case "plateNo" : plateNo  = node.getTextContent(); break;
				case "plateType" : plateType  = node.getTextContent(); break;
				case "remainSeatCnt" : remainSeatCnt  = node.getTextContent(); break;
				case "stationId" :  stationId = node.getTextContent(); break;
				case "stationSeq" :  stationSeq = node.getTextContent(); break;
				
				}

			}
			result.add(new String[] {stationSeq, endBus, lowPlate, plateNo, plateType, remainSeatCnt, routeId+"", stationId});
		}
		Collections.sort(result, (x, y) -> new Integer(x[0]).compareTo(new Integer(y[0])));
		return result;
	}
	/**
	 * @param keyword 정류장 검색 키워드
	 * @return 정류장 검색 결과 리스트
	 * @throws Exception
	 */
	public static ArrayList<String[]> getStationSearchResult(String keyword) throws Exception {
		ArrayList<String[]> result = new ArrayList<>();

		String u = URL + URL_GET_STATION_LIST + SERVICE_KEY + "&keyword="+URLEncoder.encode(keyword, "UTF-8");
		
		Document doc = StaticValue.parseXML(getXmlAtUri(u));
		NodeList descNodes = doc.getElementsByTagName("busStationList");
		for (int i = 0; i < descNodes.getLength(); i++) {
			String stationId = null; //정류소목록
			String stationName = null; //정류소아이디
			String mobileNo = null; //정류소 번호 (고유 5자리 모바일 번호)
			String regionName = null; //지역명 (정류소가 위치하는 지역의 명칭)
			String districtCd = null; //관할지역 (1:서울, 2:경기, 3:인천)
			String centerYN = null; //중앙차로여부 (N : 일반, Y : 중앙차로)
			String gpsX = null; // 정류소 X좌표
			String gpsY = null; // 정류소 Y좌표

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				switch (node.getNodeName()) {
				case "stationId" :  stationId = node.getTextContent(); break;
				case "stationName" :  stationName = node.getTextContent(); break;
				case "mobileNo" :  mobileNo = node.getTextContent(); break;
				case "regionName" :  regionName = node.getTextContent(); break;
				case "districtCd" :  districtCd = node.getTextContent(); break;
				case "centerYN" :  centerYN = node.getTextContent(); break;
				case "X" :  gpsX = node.getTextContent(); break;
				case "Y" :  gpsY = node.getTextContent(); break;
				}
			}
			result.add(new String[] {stationId, stationName, mobileNo, regionName, districtCd, centerYN, gpsX, gpsY});
		}
		System.out.println(result.size()+"사이즈");
		return result;
	}
	
}
