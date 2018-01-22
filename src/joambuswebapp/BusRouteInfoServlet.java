package joambuswebapp;



import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Servlet implementation class BusRouteInfoServlet
 */
@WebServlet("/BusRouteInfoServlet")
public class BusRouteInfoServlet extends HttpServlet {
	private HttpServletRequest request;
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BusRouteInfoServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 1. 파라미터로 전송된 값을 얻어오기.
		this.request = request;
		response.setCharacterEncoding("utf-8");
		String routeId = request.getParameter("routeId");
		boolean[] isTimetable = new boolean[1];
		isTimetable[0]=false;
		ArrayList<String> ri = new ArrayList<String>();
		ri.add(routeId);
		RouteInfoItem routeItem = null;
		try {
			routeItem = StaticValue.getRouteInfoItem(ri, request).get(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String routeColor = StaticValue.RouteTypeToColor(routeItem.getRouteTypeCd());
		String[] tts = timeTitles(routeId, routeItem.getStartStationName(),routeItem.getEndStationName());
		if(tts.length == 2) {
			String[] temp = {tts[0], tts[1], " ", " "};
			tts = new String[4];
			tts = temp;
		}
		else if(tts.length==1) {
			String[] temp = {routeItem.getStartStationName()+"출발시간표", " ", " ", " "};
			tts = new String[4];
			tts = temp;
		}
		PrintWriter out = response.getWriter();
		out.print("<!DOCTYPE html>" + "<html>" + "<head>" + "  <meta charset=\"utf-8\">"
				+ "<meta name=\"robots\" content=\"noindex\">"
				+ "  <meta name=\"viewport\" content=\"width=device-width\">" + "  <title>노선상세정보</title>" 
				//css
				+ "<style id=\"jsbin-css\">" +
				"@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);"
				+"body { font-family: 'Jeju Gothic', sans-serif;}"
				+ "body{  margin:0px;}"
				+ "#info_and_time{  background-color:"+routeColor+";  text-align:center;  color:white;  line-height:45%;  padding:1px;  padding-top:55px;  padding-bottom:15px;}"
				+ "#subtitle{  font-size:125%}#time{  font-size:150%}ul{  margin:5px;  list-style:none;  padding-left:0px;margin-bottom:58px;  background-color:#cccccc;  }li:hover{  background-color:#ffbdbd; }li{  height:56px; margin-bottom:1px;  background-color:#ffffff;  line-height:90%;}"
				+ "a{  display:block; text-decoration:none;}"
				+ "#sta_name, #sta_mbno{ position: absolute;color:#333333;}"
				+ "#sta_name{  padding-top:5px; padding-left:8px;  font-size:110%}#sta_mbno{  padding-left:10px;  font-size:90%}#sta_property_box{ position: relative; float:right;}"
				+ "#bus_property_box{  font-size:72%;  float:left;  margin-top:20px;  color:black;}"
				+ "#seat{  float:right;}" + "#car_no{  float:bottom;}" + "#bus_loca_indi_box{  float:right;}"
				+ "#sta_img{  position: relative;  float:right;  height:56px}#sta_arr_img{  position: absolute;margin:6px;  height:44px;}"
				+ "</style>"
				//css 끝
				+ "</head>" + 
				//자바스크립트 부분 시작
				"<script>" + 
				"function timepage(s){" + 
				"  if(s==1||s==\"시간표\"){" + 
				"    window.open(\"timeinfo?routeId="+routeId+"&tableNo=1&title="+tts[0]+"\",\"_self\", \"\");" + 
				"  }else if(s==2){" + 
				"    window.open(\"timeinfo?routeId="+routeId+"&tableNo=2&title="+tts[1]+"\",\"_self\", \"\");" + 
				"  }else if(s==3){" + 
				"    window.open(\"timeinfo?routeId="+routeId+"&tableNo=3&title="+tts[2]+"\",\"_self\", \"\");" + 
				"  }else if(s==4){" + 
				"    window.open(\"timeinfo?routeId="+routeId+"&tableNo=4&title="+tts[3]+"\",\"_self\", \"\");" + 
				"  }" + 
				"  else{}" + 
				"}" + 
				"</script>"+ // 끝
				"<body>");
		out.print("<div style=\"position:fixed;z-index: 3;top:0px;left:0px;background-color:"+routeColor+";width:100%; height:55px;\" >\r\n" + 
				"<p style=\"display:inline; display:block;text-align:center; color:white; font-size:130%;\">"+routeItem.getRouteName()+"번</p>\r\n" + 
				"\r\n" 
				+"<a href=\"index.html\" style=\"position:absolute;top:20px;right:10px;\"><img src=\"/drawable/home.png\"/></a>\r\n" 
				+"</div>");
		out.print("  <div id=\"info_and_time\">" +"    <p id=\"subtitle\">" + routeItem.getStartStationName() + "-"
				+ routeItem.getEndStationName() + "</p>" + "    <p id=\"info_fl_time\">첫차:" + routeItem.getUpFirstTime()
				+ " | " + routeItem.getDownFirstTime() + " 막차:" + routeItem.getUpLastTime() + " | "
				+ routeItem.getDownLastTime() + "</p>" );
		try {
			for(String printstr:time(routeId, isTimetable))
				out.print("    <p id=\"time\">"+printstr+"</p>");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		

		try {
			ArrayList<ListItem> iList = ListItemList(routeId);
			out.print("    운행중인 버스: "+iList.get(0).getBusLocaCnt()+"대");
			if(isTimetable[0]) {
				String[] timeTableNames = timeOptionNames(routeId);
				if(timeTableNames.length == 1) {
					out.print("<input type=\"button\" style=\"color:white;float:right;padding-right:5px;background-color:"+routeColor+";border:1px;\" value=\"시간표\" onclick=\"timepage(this.value)\" />");
				}
				else {
					out.print("<select style=\"color:white;float:right;padding-right:5px;background-color:"+routeColor+";\" onchange=\"timepage(this.value)\">"+ 
							"    <option>시간표</option>\r\n");
					for(int i=0; i<timeTableNames.length; i++)
						out.print("<option value="+(i+1)+" >"+timeTableNames[i]+"</option>");
					out.print("</select>");
				}
			}
			out.print("  </div><br>"+"<div style=\"position: relative;z-index: 1;\"><ul>");

			for (ListItem i : iList) {

				String staImageFName;
				if (i.getBusRouteStation().getStationSeq().equals("1"))
					staImageFName = "start";
				else if (i.getBusRouteStation().getTurnYn().equals("Y"))
					staImageFName = "turn";
				else if (i.getBusRouteStation().getStationSeq().equals(iList.size() + ""))
					staImageFName = "end";
				else
					staImageFName = "mid";
				
				out.print("    <li>");
				if(!i.getBusRouteStation().getStationName().contains("(경유)"))
					out.print("      <a href=\"http://m.gbis.go.kr/search/StationArrivalViaList.do?stationId="
							+ i.getBusRouteStation().getStationId() + "\">" );
				
				out.print("        <table style=\"display:inline\">"
						+ "          <tr height=\"25px\"> " + "            <td id=\"sta_name\">"
						+ i.getBusRouteStation().getStationName() + "</td>" + "          </tr>"
						+ "          <tr height=\"25px\">" + "            <td id=\"sta_mbno\">"
						+ ((i.getBusRouteStation().getMobileNo()!=null)?i.getBusRouteStation().getMobileNo():"") 
						+ "</td>" + "          </tr>" + "        </table>"
						+ "        <div id=\"sta_property_box\">");
				if (i.getBusLocation() != null) {
					out.print("            <div id=\"bus_property_box\" >" + "              <div id=\"seat\" >"
							+ (i.getBusLocation().getRemainSeatCnt().contains("-1")?"":i.getBusLocation().getRemainSeatCnt()+"석")+"</div><br>"
							+ "              <div id=\"car_no\" >" + i.getBusLocation().getPlateNo() + "호</div>"
							+ "            </div>");

				}
				out.print("            <div id=\"bus_loca_indi_box\" >"
						+ "              <img id=\"sta_img\" src=\"drawable/station_"
						+ staImageFName + ".PNG\" />");
				if (i.getBusLocation() != null)
					out.print(
							"              <img id=\"sta_arr_img\" src=\"drawable/bus_"
									+ StaticValue.RouteTypeToColorName(routeItem.getRouteTypeCd()).toLowerCase()
									+ ".PNG\" />");
				out.print("            </div>" + "        </div>");
				if(!i.getBusRouteStation().getStationName().contains("(경유)"))
					out.print("      </a>");
				out.print("    </li> ");
			}

			out.print("</ul></div>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		out.print(StaticValue.AD+"</body>" + "</html>");
	}
	
	public String[] timeOptionNames(String busRouteId) {
		final String WEEKDAY_STR = "평일&ensp;";
		final String WEEKEND_STR = "주말&ensp;";
		final String UP_STR = "기점출발&ensp;";
		final String DOWN_STR = "종점출발&ensp;";
		final String TIMETABLE_STR = "시간표";
		String[] result = null;
		int timeType = StaticValue.getTimeType(busRouteId, request);
		if (timeType == 1) {
			result = new String[1];
			result[0] = TIMETABLE_STR;
		}
        else if (timeType == 2)
        {
        	result = new String[2];
        	result[0] = WEEKDAY_STR+ TIMETABLE_STR;
        	result[1] = WEEKEND_STR + TIMETABLE_STR;
        }
        else if (timeType == 3)
        {
        	result = new String[2];
        	result[0] = UP_STR + TIMETABLE_STR;
        	result[1] = DOWN_STR + TIMETABLE_STR;
        }
        else if (timeType == 4)
        {
        	result = new String[4];
        	result[0] = WEEKDAY_STR+UP_STR + TIMETABLE_STR;
        	result[1] = WEEKDAY_STR+DOWN_STR + TIMETABLE_STR;
        	result[2] = WEEKEND_STR+UP_STR + TIMETABLE_STR;
        	result[3] = WEEKEND_STR+DOWN_STR + TIMETABLE_STR;
        }
		return result;
	}
	public String[] timeTitles(String busRouteId, String start, String end) {
		final String WEEKDAY_STR = "평일&ensp;";
		final String WEEKEND_STR = "주말&ensp;";
		final String UP_STR = start+"출발&ensp;";
		final String DOWN_STR = end+"출발&ensp;";
		final String TIMETABLE_STR = "시간표";
		String[] result = null;
		int timeType = StaticValue.getTimeType(busRouteId, request);
		if (timeType == 1) {
			result = new String[1];
			result[0] = TIMETABLE_STR;
		}
        else if (timeType == 2)
        {
        	result = new String[2];
        	result[0] = WEEKDAY_STR+ TIMETABLE_STR;
        	result[1] = WEEKEND_STR + TIMETABLE_STR;
        }
        else if (timeType == 3)
        {
        	result = new String[2];
        	result[0] = UP_STR + TIMETABLE_STR;
        	result[1] = DOWN_STR + TIMETABLE_STR;
        }
        else if (timeType == 4)
        {
        	result = new String[4];
        	result[0] = WEEKDAY_STR+UP_STR + TIMETABLE_STR;
        	result[1] = WEEKDAY_STR+DOWN_STR + TIMETABLE_STR;
        	result[2] = WEEKEND_STR+UP_STR + TIMETABLE_STR;
        	result[3] = WEEKEND_STR+DOWN_STR + TIMETABLE_STR;
        }
		return result;
	}

	public String[] time(String busRouteId, boolean[] isTimeTable) throws Exception
    {
		String result[];
		String upTime1;
        boolean isUp = true;
        boolean isWeekday = true;
        Date now = new Date();
        
        TimeZone kst = TimeZone.getTimeZone ("JST"); 
		// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
		Calendar cal = Calendar.getInstance ( kst ); 
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        int HH = cal.get(Calendar.HOUR_OF_DAY);
        int MM = cal.get(Calendar.MINUTE);
        String time = HH+""+((MM<10)?"0"+MM:MM);
        
        int timeType = StaticValue.getTimeType(busRouteId, request);
        if (timeType == 2 && (DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY || DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY)) isWeekday = false;
        else if (timeType == 3) isUp = false;
        else if (timeType == 4)
        {
            isUp = false;
            if (StaticValue.isHoliday()) isWeekday = false;
        }
        ArrayList<String> timeItemList= StaticValue.getTimeList(busRouteId, true, isWeekday, request);
        if (timeItemList!=null){
            
            int index = StaticValue.findTimeIndex(timeItemList, time);
            
            upTime1 = (index >= timeItemList.size() ? "운행종료" : new StringBuffer(timeItemList.get(index)).insert(2, ':')
                + (index + 1 >= timeItemList.size() ? "" : ", " + new StringBuffer(timeItemList.get(index+1)).insert(2, ':')
                + (index + 2 >= timeItemList.size() ? "" : ", " + new StringBuffer(timeItemList.get(index+2)).insert(2, ':'))));

            if (!isUp)
            {
            	result = new String[2];
            	result[0] = upTime1;
                timeItemList = StaticValue.getTimeList(busRouteId, isUp, isWeekday, request);
                index = StaticValue.findTimeIndex(timeItemList, time);
                result[1] = (index >= timeItemList.size() ? "운행종료" : new StringBuffer(timeItemList.get(index)).insert(2, ':')
                        + (index + 1 >= timeItemList.size() ? "" : ", " + new StringBuffer(timeItemList.get(index+1)).insert(2, ':')
                                + (index + 2 >= timeItemList.size() ? "" : ", " + new StringBuffer(timeItemList.get(index+2)).insert(2, ':'))));
                
            }
            else {
            	result = new String[1];
            	result[0] = upTime1;
            }
            isTimeTable[0]=true;
        }
        else
        {
        	result = new String[1];
        	result[0] = "등록된 시간표가 없습니다.";
        	isTimeTable[0]=false;
        }
        return result;
    }
	
	ArrayList<ListItem> ListItemList(String routeId) {
		ArrayList<ListItem> result = new ArrayList<ListItem>();
		int i = 0;
		try {
			ArrayList<BusLocation> bl = BusLocation.getBusLocationList(routeId);
			
			bl.sort((x, y) -> new Integer(x.getStationSeq()).compareTo(Integer.parseInt(y.getStationSeq())));
			ArrayList<BusRouteStation> rsList = BusRouteStation.getRouteStationList(routeId);
			
			for (BusRouteStation rs : rsList) {
				BusLocation bLoca = null;

				if (i < bl.size() && bl.get(i).getStationSeq().equals(rs.getStationSeq())) {
					bLoca = bl.get(i++);
				}
				result.add(new ListItem(rs, bLoca,bl.size()));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	class ListItem {
		private BusRouteStation busRouteStation = null;
		private BusLocation busLocation = null;
		private int busLocacnt = 0;

		ListItem(BusRouteStation busRouteStation, BusLocation busLocation, int busLocacnt) {
			this.busRouteStation = busRouteStation;
			this.busLocation = busLocation;
			this.busLocacnt = busLocacnt;
		}

		public BusRouteStation getBusRouteStation() {
			return busRouteStation;
		}

		public BusLocation getBusLocation() {
			return busLocation;
		}
		public int getBusLocaCnt() {
			return busLocacnt;
		}
	}
}
