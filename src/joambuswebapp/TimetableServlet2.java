package joambuswebapp;



import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class TimetableServlet
 */
@WebServlet("/TimetableServlet2")
public class TimetableServlet2 extends HttpServlet {
	private HttpServletRequest request; 
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TimetableServlet2() {
        super();
        // TODO Auto-generated constructor stub
    }
    protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 1. 파라미터로 전송된 값을 얻어오기.
    	this.request = request;
		response.setCharacterEncoding("utf-8");
		String stationId = request.getParameter("stationId");
		String title = request.getParameter("title");	
		if(title != null) title = new String(title.getBytes("8859_1"), "UTF-8");


		TimeZone kst = TimeZone.getTimeZone ("JST"); 
		// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
		Calendar cal = Calendar.getInstance ( kst );  
        int HH = cal.get(Calendar.HOUR_OF_DAY);
        int MM = cal.get(Calendar.MINUTE);
        @SuppressWarnings("deprecation")
		Time time = new Time(HH, MM, 0);
        ArrayList<ArrayList<Object>> timeItemList;
		try {
			timeItemList = StaticValue.timetableOfStation(stationId);
		
		int index = StaticValue.findTimeIndex2(timeItemList, time);
		PrintWriter out = response.getWriter();
		out.print("<!DOCTYPE html>" + 
				"<html>" + 
				"<head>" + 
				"  <meta charset=\"utf-8\">" + 
				"<meta name=\"robots\" content=\"noindex\">" + 
				"  <meta name=\"viewport\" content=\"width=device-width\">" + 
				"  <title>조암버스:시간표</title>" + "<link rel=\"shortcut icon\" href=\"/drawable/favicon.ico\">"+
				//css start
				"<style>" + 
				"@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css); " + 
				"body { font-family: 'Jeju Gothic', sans-serif;}" + 
				"ul{       " + 
				"  margin:5px;       " + 
				"  list-style:none;  " + 
				"  background-color:#eeeeee;" + 
				"  padding-left:0px; " + 
				"  color:#333333;" + 
				"} " + 
				"li:hover{" + 
				"  background-color:#ffbdbd;" + 
				"}" + 
				"li{" + 
				"  background-color:#ffffff;" + 
				"  padding:2px;" + 
				"  padding-left:5px; " + 
				"  margin-bottom:1px; " + 
				"}" + 
				"#now{" + 
				"  background-color:#ff6666;" + 
				"  color:#ffffff;" + 
				"  font-weight:bold;" + 
				"}" + 
				"</style>" + 
				//css end
				//js start
				"<script>" + 
				"(function () {" + 
				"    location.href = \"#now\"; " + 
				"})()" + 
				"</script>" + 
				//js end
				"</head>" + 
				//body start
				"<body>" );
		out.print("<div style=\"position:fixed;top:0px;left:0px;background-color:#ec6778;width:100%; height:60px;\" >\r\n" + 
				"<p style=\"display:inline; display:block;text-align:center; color:white; font-size:130%;\">"+title+"</p>\r\n" + 
				"\r\n" + 
				"<a href=\"index.html\" style=\"position:absolute;top:20px;right:10px;\"><img src=\"/drawable/home.png\"/></a>\r\n" +
				"</div>");
		out.print("<p style=\"padding-top:60px;\"> 현재시간 >> "+HH+"시"+MM+"분"+"</p>");
		out.print("<p style=\"font-size=75%;\"> 이 기능은 시험 중입니다.  </p>");
		out.print("<p style=\"font-size=75%;\"> 일부 정류장에서는 정확하지 않습니다</p>");
		out.print("<p style=\"font-size=75%;\"> (조암터미널, 수원역, 수원터미널 같은 기종점)</p>");
		out.print("<p style=\"font-size=75%;\"> 일부 노선은 대상 노선에서 제외했습니다.(8155, 28, 50-1)</p>");
		out.print(
				"  <ul>");
		
		for(int i=0;i<timeItemList.size();i++) {
			if(i==index)
				out.print("<li id=\"now\" >"+(Time)timeItemList.get(i).get(0)+"&emsp;"+(String)timeItemList.get(i).get(1)+"번</li>" );
			else	
				out.print("<li>"+(Time)timeItemList.get(i).get(0)+"&emsp;"+(String)timeItemList.get(i).get(1)+"번</li>" );
		}
		out.print(
				"  </ul>" + 
				"</body>" + 
				//body end
				"</html>");
		
		}
		catch(Exception e) {
			response.sendRedirect("/error2.html");
		}
    }
}
