package joambuswebapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class StationInfoServlet extends HttpServlet {
	private HttpServletRequest request;

	private DBManager dbm = new DBManager(StaticValue.JOAMBUS_DB_NAME);
	public StationInfoServlet() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
		this.request = request;
		// 1. 파라미터로 전송된 값을 얻어오기.
		response.setCharacterEncoding("utf-8");
		String stationId = request.getParameter("stationId");//정류장 ID
		String stationMbId = request.getParameter("stationMbId");//정류장 모바일ID
		String stationName = new String(request.getParameter("stationName").getBytes("8859_1"), "UTF-8"); //정류장 이름
		
		PrintWriter out = response.getWriter();
		out.print("<!DOCTYPE html>" + 
				"<html>" + 
				"<head>" + 
				"<meta charset=\"utf-8\">" + 
				"<meta name=\"viewport\" content=\"width=device-width\">");
		//title
		out.print("<title>조암버스:"+stationName+"("+stationMbId+") 정류장정보</title>"
				+"<link rel=\"shortcut icon\" href=\"/drawable/favicon.ico\">");
		//CSS
		out.print("<style>" + 
				"@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);" + 
				 
				"body {" + 
				"	font-family: 'Jeju Gothic', sans-serif;" + 
				"	color: #000000;" + 
				"	font-size: 10pt;" + 
				"	margin:0px;" + 
				"	line-height: 2.5em;" + 
				"}" + 
				"ul {" + 
				"	margin: 5px;" + 
				"	list-style: none;" + 
				"	padding-left: 0px;" + 
				"	margin-bottom: 58px;" + 
				"	background-color: #ffffff;" + 
				"}" + 
				 
				"li:hover {" + 
				"	background-color: #ffbdbd;" + 
				"}" + 
				 
				"li {" + 
				"	height: 56px;" + 
				"	margin-bottom: 1px;" + 
				"	background-color: #ffffff;" + 
				"	line-height: 90%;" + 
				"}" + 
				 
				"a {" + 
				"	display: block;" + 
				"	text-decoration: none;" + 
				"}" + 
				"#list{" + 
				"	padding-top: 55px;" + 
				"}" + 
				"header {" + 
				"	padding-top:0px;" + 
				"	padding-bottom: 5px;" + 
				"	padding-left: 7px;" + 
				"    font-size: 90%;" + 
				"	height:25px;" + 
				"	background-color: #F7E7D6;" + 
				"	color:#ec6778;" + 
				"}" +
				"#route_name {" + 
				"    padding-top: 3px;" + 
				"    padding-left: 8px;" + 
				"    font-size: 180%;" + 
				"	color: #333333;" + 
				"}" + 
				"#route_des{" + 
				"	padding-top: 10px;" + 
				"    font-size: 120%;" + 
				"	color: #666666;" + 
				"}" + 
				"#route_time {" + 
				"    padding-left: 10px;" + 
				"	padding-bottom: 1px;" + 
				"    font-size: 90%;" + 
				"	color: #ec6778;" + 
				"}" + 
				"#stit {" + 
				"	font-size: 16pt;" + 
				"}" + 
				"</style>");
		out.print("</head>");
		out.print("<body>");
		//페이지 헤더
		out.print("<div style=\"position:fixed;z-index: 3;top:0px;left:0px;background-color:#ec6778;width:100%; height:55px;\">\r\n" + 
				"        <p style=\"display:inline; display:block;text-align:center; color:white; font-size:130%;\">"+stationName+"("+stationMbId+")</p>\r\n" + 
				"\r\n" + 
				"        <a href=\"index.html\" style=\"position:absolute;top:20px;left:10px;\">\r\n" + 
				"            <img src=\"/drawable/home.png\" />\r\n" + 
				"		</a>\r\n" + 
				"		<a href=\"/appfile/time.html\"style=\"position:absolute;top:20px;right:10px;\">\r\n" + 
				"            <img src=\"/drawable/time.png\" />\r\n" + 
				"        </a>\r\n" + 
				"    </div>");
		//메인 리스트 시작 부분
		out.print("<div style=\"position: relative;z-index: 1;\" id=\"list\">");
		out.print("<ul>");
		//리스트의 헤더 - 운행중인 버스
		out.print("<header id=\"header\">\r\n" + 
				"				<p>운행중인 버스</p>\r\n" + 
				"			</header>");
		//리스트 항목 loop를 이용해서 리스트를 만들자 !!추후수정
		ArrayList<String> arriveRouteIds= new ArrayList<>();
		try {
			ArrayList<BusArriveStation> routeList = BusArriveStation.getBusArriveStation(stationId);
			for(BusArriveStation routeItem: routeList) {
				arriveRouteIds.add(routeItem.getRouteId());
				ArrayList<HashMap<String, String>> routeInfoItem = dbm.getDBDataList(StaticValue.ROUTE_INFO_TABLE_NAME, StaticValue.STATIONINFO_SERVLET_ROUTEINFO_TAG, StaticValue.STATIONINFO_SERVLET_ROUTEINFO_TAG[0], false, new String[] {"routeId"}, new String[] {routeItem.getRouteId()});
				String routeId, routeTypeCd, routeName, startStationName, middleStationName, endStationName, direction, isInDB="";
				if (routeInfoItem.size()==0) {
					routeId = routeItem.getRouteId();
					RouteInfoItem rii = StaticValue.getRouteInfoItem(new ArrayList<String>(Arrays.asList(new String[] {routeId})), request).get(0);
					routeTypeCd = rii.getRouteTypeCd();
					routeName = rii.getRouteName();
					startStationName = rii.getStartStationName();
					middleStationName = "";
					endStationName = rii.getEndStationName();
					direction = "-";
					isInDB="2";
				}
				else {
					routeId = routeInfoItem.get(0).get("routeId");
					routeTypeCd = routeInfoItem.get(0).get("routeTypeCd");
					routeName = routeInfoItem.get(0).get("routeName");
					startStationName = routeInfoItem.get(0).get("startStationName");
					middleStationName = routeInfoItem.get(0).get("middleStationName");
					endStationName = routeInfoItem.get(0).get("endStationName");
					direction = "<=>";
					if (routeInfoItem.get(0).get("isOneWay").equals("Y")) direction = "=>";
					
				}
				//String direction = "<=>";
				//if (routeInfoItem.get("isOneWay").equals("Y")) direction = "=>";
				out.print("<li>\r\n" + 
						"                <a href=\"routeinfo"+isInDB+"?routeId="+routeId+"\">\r\n" + 
						"                    <table style=\"display:inline\">\r\n" + 
						"                        <tr height=\"25px\">\r\n" + 
						"							<td rowspan=2><img width=\"40px\"src=\"../drawable/bus_"+
						StaticValue.RouteTypeToColorName(routeTypeCd).toLowerCase()+".PNG\"/></td>\r\n" + 
						"							<td id=\"route_name\">"+routeName+"</td>\r\n" + 
						"							<td id=\"route_des\">"+startStationName.split("[.(]")[0]+direction+middleStationName.split("[.(]")[0]+direction+endStationName.split("[.(]")[0]+"</td>\r\n" + 
						"                        </tr>\r\n" + 
						"                        <tr height=\"25px\">\r\n" + 
						"							<td id=\"route_time\" colspan=2>약 "+routeItem.getPredictTime1()+ "분 후 "+(routeItem.getRemainSeatCnt1().equals("-1")?"":routeItem.getRemainSeatCnt1()+"석") +" </td>\r\n" + 
						"                        </tr>\r\n" + 
						"                    </table>\r\n" + 
						"                </a>\r\n" + 
						"			</li>");
			}
			
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		//리스트의 헤더 - 노선목록
		out.print("<header id=\"header\">\r\n" +  
				"					<p>노선 목록</p>\r\n" + 
				"			</header>");
		//리스트 항목  loop를 이용해서 리스트를 만들자 !!추후수정
		try {
			System.out.println("정류장 노선목록조회");
			ArrayList<String> gbisRouteList = stopByRouteList(stationId);
			for(String arriveRouteId: arriveRouteIds) {
				gbisRouteList.remove(arriveRouteId);
			}
			ArrayList<HashMap<String, String>> routeItemList=dbm.getDBDataList(StaticValue.STATION_OF_ROUTE_TABLE_NALE, new String[] {"routeId"}, "routeId", false, new String[] {"stationId"}, new String[] {stationId});
			
			for(HashMap<String, String> row: routeItemList) {
				System.out.println(row.get("routeId")+" 노선정보조회");
				gbisRouteList.remove(row.get("routeId"));
				HashMap<String, String> routeInfoItem = dbm.getDBDataList(StaticValue.ROUTE_INFO_TABLE_NAME, StaticValue.STATIONINFO_SERVLET_ROUTEINFO_TAG, StaticValue.STATIONINFO_SERVLET_ROUTEINFO_TAG[0], false, new String[] {"routeId"}, new String[] {row.get("routeId")}).get(0);
				String direction = "<=>";
				if (routeInfoItem.get("isOneWay").equals("Y")) direction = "=>";
				out.print("<li>\r\n" + 
						"	<a href=\"routeinfo?routeId="+routeInfoItem.get("routeId")+"\">\r\n" +
						//"				<a href=\"http://m.gbis.go.kr/search/StationArrivalViaList.do?stationId=233000929\">\r\n" + 
						"					<table style=\"display:inline\">\r\n" + 
						"						<tr height=\"50px\">\r\n" + 
						"							<td><img width=\"40px\"src=\"../drawable/bus_"+
						StaticValue.RouteTypeToColorName(routeInfoItem.get("routeTypeCd")).toLowerCase()+".PNG\"/></td>\r\n" + 
						"							<td id=\"route_name\">"+routeInfoItem.get("routeName")+"</td>\r\n" + 
						"							<td id=\"route_des\">"+routeInfoItem.get("startStationName").split("[.(]")[0]+direction+routeInfoItem.get("middleStationName").split("[.(]")[0]+direction+routeInfoItem.get("endStationName").split("[.(]")[0]+"</td>\r\n" + 
						"						</tr>\r\n" + 
						"					</table>\r\n" + 
						"				</a>\r\n" + 
						"			</li>");
			}
			for(String gbisRouteId: gbisRouteList) {
				RouteInfoItem rii = StaticValue.getRouteInfoItem(new ArrayList<String>(Arrays.asList(new String[] {gbisRouteId})), request).get(0);
				out.print("<li>\r\n" + 
						"	<a href=\"routeinfo2?routeId="+gbisRouteId+"\">\r\n" +
						//"				<a href=\"http://m.gbis.go.kr/search/StationArrivalViaList.do?stationId=233000929\">\r\n" + 
						"					<table style=\"display:inline\">\r\n" + 
						"						<tr height=\"50px\">\r\n" + 
						"							<td><img width=\"40px\"src=\"../drawable/bus_"+
						StaticValue.RouteTypeToColorName(rii.getRouteTypeCd()).toLowerCase()+".PNG\"/></td>\r\n" + 
						"							<td id=\"route_name\">"+rii.getRouteName()+"</td>\r\n" + 
						"							<td id=\"route_des\">"+rii.getStartStationName().split("[.(]")[0]+"-"+rii.getEndStationName().split("[.(]")[0]+"</td>\r\n" + 
						"						</tr>\r\n" + 
						"					</table>\r\n" + 
						"				</a>\r\n" + 
						"			</li>");
			}
			/*
			out.print("<li>\r\n" + 
					"				<a href=\"http://m.gbis.go.kr/search/StationArrivalViaList.do?stationId=233000929\">\r\n" + 
					"					<table style=\"display:inline\">\r\n" + 
					"						<tr height=\"50px\">\r\n" + 
					"							<td><img width=\"40px\"src=\"../drawable/bus_green.PNG\"/></td>\r\n" + 
					"							<td id=\"route_name\">5-4</td>\r\n" + 
					"							<td id=\"route_des\">조암터미널-호곡3리</td>\r\n" + 
					"						</tr>\r\n" + 
					"					</table>\r\n" + 
					"				</a>\r\n" + 
					"			</li>");
					*/
			}catch (Exception e) {
			// TODO: handle exception
		}
		out.print("</ul></div>");
		out.print(StaticValue.AD+"</body>" + "</html>");
	}
	private ArrayList<String> stopByRouteList(String stationId) {
		ArrayList<String> routeList = null;
		String u = StaticValue.URL + StaticValue.URL_GET_STATION_ROUTE_LIST + StaticValue.SERVICE_KEY + "&stationId="+stationId;
        URL url;
		try {
			routeList = new ArrayList<>();
			url = new URL(u);
		
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
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return routeList;
	}
}
