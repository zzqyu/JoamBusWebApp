
<%@page import="java.util.ArrayList"%>
<%@page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	boolean isJoamBus = true;
	boolean isGbisError = false;
	DBManager dbm = new DBManager("JOAMBUS");
	response.setCharacterEncoding("utf-8");
	int routeId = Integer.parseInt(request.getParameter("routeId"));
	//유형, 이름, 기점, 종점, 기점첫차, 종점첫차, 기점막차, 종점막차
	String[] routeInfo = dbm.routeInfo(routeId);
	
	if(routeInfo==null) { 
		isJoamBus = false;
		System.out.println("없는 노선");
		routeInfo = dbm.gbisRouteInfo(routeId);
			if(routeInfo==null){
			RouteInfoItem routeItem = null;
			try {
				ArrayList<String> ri = new ArrayList<String>();
				ri.add(routeId+"");
				routeItem = StaticValue.getRouteInfoItem(ri, request).get(0);
				routeInfo = new String[]{routeItem.getRouteTypeCd(), routeItem.getRouteName(), 
						routeItem.getStartStationName(), routeItem.getEndStationName(), 
						routeItem.getUpFirstTime(), routeItem.getDownFirstTime(),
						routeItem.getUpLastTime(), routeItem.getDownLastTime()};
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	else isJoamBus = routeInfo[8]!=null;
	
	String routeColor = StaticValue.RouteTypeToColor(routeInfo[0]);
	String colorName = StaticValue.RouteTypeToColorName(routeInfo[0]).toLowerCase();
	String[] tts=null; 
	ArrayList<String[]> locationList=null ,routeStation=null;
	ArrayList<ArrayList<String>> timeTable=null;
	int timeType;
	try{
		timeType=dbm.haveTimeType(routeId);
		timeTable = dbm.curTimeTable(routeId,timeType);
		//ArrayList<String[]> routeStation = dbm.routeStationList(routeId);
		routeStation = new ArrayList<String[]>();
		locationList = new ArrayList<String[]>();
		if(routeStation.isEmpty()){
			routeStation = StaticValue.getRouteStationList(routeId);

			for(int i = 0; i < routeStation.size(); i++ ){
				String[] row = routeStation.get(i);
				System.out.print("\""+routeId+"\",");
				System.out.print("\""+row[0]+"\",");//sid
				System.out.print("\""+row[1]+"\",");//updown
				System.out.print("\""+(i+1)+"\",");//order
				System.out.print("\""+routeInfo[1]+"\",");//route_NM
				System.out.println("\""+row[2]+"\"");//updown

				/*for(String item: row)System.out.print("\""+item+"\",");
				System.out.println();*/
			}

		}
		locationList = StaticValue.getBusLocationList(routeId);
		tts = timeOptionNames(timeType, routeInfo);
	}
	catch(GbisException e){
		isGbisError = true;
	}
	catch(Exception e){
		e.printStackTrace();
	}

	
	//stationSeq, endBus, lowPlate, plateNo, plateType, remainSeatCnt, routeId+"", stationId
	//정류장id, 반환점, 정류장이름, 정류장모바일번호
	/*
	route -> 노선이름, 행선지, 첫차막차, 유형
	timetable -> 테이블종류, 당일 시간표
	*/
	
	
%>
<%!
public String[] timeOptionNames(int timeType, String[] routeInfo) {
	final String WEEKDAY_STR = "평일&ensp;";
	final String WEEKEND_STR = "주말/공휴일&ensp;";
	final String WEEKSAT_STR = "토요일&ensp;";
	final String UP_STR = routeInfo[2]+"&ensp;";
	final String DOWN_STR = routeInfo[3]+"&ensp;";
	final String TIMETABLE_STR = "시간표";
	String[] result = null;
	if (timeType == 1) {
		result = new String[1];
		result[0] = UP_STR+TIMETABLE_STR;
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
    else if (timeType == 5)
    {
    	result = new String[3];
    	result[0] = WEEKDAY_STR+UP_STR + TIMETABLE_STR;
    	result[1] = WEEKSAT_STR+UP_STR + TIMETABLE_STR;
    	result[2] = WEEKEND_STR+UP_STR + TIMETABLE_STR;
    }
    else if (timeType == 6)
    {
    	result = new String[6];
    	result[0] = WEEKDAY_STR+UP_STR + TIMETABLE_STR;
    	result[1] = WEEKSAT_STR+UP_STR + TIMETABLE_STR;
    	result[2] = WEEKEND_STR+UP_STR + TIMETABLE_STR;
    	result[3] = WEEKDAY_STR+DOWN_STR + TIMETABLE_STR;
    	result[4] = WEEKSAT_STR+DOWN_STR + TIMETABLE_STR;
    	result[5] = WEEKEND_STR+DOWN_STR + TIMETABLE_STR;
    }
	return result;
}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="robots" content="noindex">
<meta name="viewport" content="width=device-width">
<title>조암버스:<%=routeInfo[1]%>번 노선정보</title>
<!-- Bootstrap core CSS -->
<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="css/scrolling-nav.css" rel="stylesheet">
<!-- Font Awesome CSS -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<link rel="shortcut icon" href="/drawable/favicon.ico">
<link href="css/routeinfo.css" rel="stylesheet">
</style>
</head>
<script>
	<%
	if(isGbisError){
	%>
		alert("경기버스정보시스템 오류입니다. \n시간표 기능만 이용가능합니다. ");
	<%
	}
	%>
	
</script>
<body>
	<!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: <%=routeColor%>;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:75px;"\><%=routeInfo[1]%>번</p>
        <!-- Collapsible content -->
	    <div class="" id="navbarSupportedContent">
	        
		</div>
      </div>
    </nav>
	<div id="info_and_time" style="background-color: <%=routeColor%>;padding-top:80px;padding-bottom:15px;padding-right:10px;">
		<p id="subtitle"><%=routeInfo[2]%>-<%=routeInfo[3]%></p>
		<p id="info_fl_time">첫차:<%=routeInfo[4].substring(0, 5)%> | <%=routeInfo[5].substring(0, 5)%> 막차:<%=routeInfo[6].substring(0, 5)%> | <%=routeInfo[7].substring(0, 5)%></p>
		<%
		if(timeTable.isEmpty()){
			if(isJoamBus) out.print("<p id='time'>운행종료<p>");
			else out.print("<p id='time'>시간표가 없습니다. <p>");
		}
		else{
			%>
			<%
			for(int i=0; i<timeTable.size(); i++){
				%>
				<p id="time">
				<%
				for(int j=0; j<timeTable.get(i).size();j++)
					out.print(timeTable.get(i).get(j).substring(0,5)+"&ensp;");
				if(i==1&&timeTable.get(i).isEmpty())
					out.print("<p id='time'>운행종료");
				%></p><%
			}
		}%>
		<div style="height:38px;">
		<%
		if(colorName.equals("yellow")){
			out.print("<input type=\"button\" class=\"btn btn-outline-light\" style=\"float:right;\"onclick='location.href=\"http://m.gbis.go.kr/search/getBusRouteDetail.do?routeId="+routeId+"&osInfoType=M\"') value=\"실시간위치\"/>");		
		}
		else out.print("<p style=\"display:inline;height:38px;\">운행중인 버스: "+locationList.size()+"대</p>");		
		
		if(isJoamBus){
			if(tts.length == 1) {
				%>
				<input type="button" class="btn btn-outline-light" style="float:right;" value="시간표" onclick="javascript:window.open('timeinfo?routeId=<%=routeId%>&tableNo=1&title=<%=tts[0]%>', '_self');" />
				<% 
			}
			else {
				%>
				<button class="btn btn-outline-light dropdown-toggle" type="button" id="dropdownMenuButton" style="float:right;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    시간표
				  </button>
				  <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
				  <%
				  for(int i=0; i<tts.length; i++){
				  %>
				  	<br>
				    <a class="dropdown-item" href="timeinfo?routeId=<%=routeId%>&tableNo=<%=(i+1)%>&title=<%=tts[i].replace("&ensp;", " ")%>"><%=tts[i]%></a>
				    <br>
				   <%} %>
				  </div>
				
				<%
				
			}

		}%>
		</div>
	</div>
	<br>
	<div class="container" style="position: relative; z-index: 1;">
		<ul>
			<%
			//id , 턴, 이름, 모바일번호
			for(int i=0; i<routeStation.size();i++){
				boolean isBusCurStation = false;
				String fileName = "mid";
				if(i==0) fileName="start";
				else if(i==routeStation.size()-1)fileName="end";
				if(routeStation.get(i)[1].charAt(0)=='Y')fileName="turn";
				String url = "stationinfo?stationId="+routeStation.get(i)[0]+"&stationMbId="+routeStation.get(i)[3]+"&stationName="+routeStation.get(i)[2];
				if(url.contains("(경유)"))url="";
				%>
				<li><a href="<%=url%>">
					<table style="display: inline">
						<tr height="25px">
							<td id="sta_name"><%=routeStation.get(i)[2]%></td>
						</tr>
						<tr height="25px">
							<td id="sta_mbno"><%=routeStation.get(i)[3]==null?"":routeStation.get(i)[3]%></td>
						</tr>
					</table>
					
					<div id="sta_property_box">
						<% if(locationList.size()>0&&new Integer(locationList.get(0)[0])==i+1){%>
							<div id="bus_property_box">
								<%if(!locationList.get(0)[5].equals("-1")) {%>
									<div id="seat"><%=locationList.get(0)[5]%>석</div><br>
								<%} %>
								<div id="car_no"><%=locationList.get(0)[3]%>호</div>
							</div>
						<%
							isBusCurStation = true;
							locationList.remove(0);
						}%>
						<div id="bus_loca_indi_box">
							<img id="sta_img" src="drawable/station_<%=fileName%>.PNG" />
							<% if(isBusCurStation){%>
								<img id="sta_arr_img" src="drawable/bus_<%=colorName%>.PNG">
							<%}%>
						</div>
					</div>
				</a></li>
			<%}%>
		</ul>
	</div>
	<%=StaticValue.AD%>
	
    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom JavaScript for this theme -->
    <script src="js/scrolling-nav.js"></script>
</body>
</html>



















