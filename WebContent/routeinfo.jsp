
<%@page import="java.util.ArrayList"%>
<%@page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	boolean isJoamBus = true;
	DBManager dbm = new DBManager("JOAMBUS");
	response.setCharacterEncoding("utf-8");
	int routeId = Integer.parseInt(request.getParameter("routeId"));
	//유형, 이름, 기점, 종점, 기점첫차, 종점첫차, 기점막차, 종점막차
	String[] routeInfo = dbm.routeInfo(routeId);
	if(routeInfo==null) { 
		isJoamBus = false;
		System.out.println("없는 노선");
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
	String routeColor = StaticValue.RouteTypeToColor(routeInfo[0]);
	String colorName = StaticValue.RouteTypeToColorName(routeInfo[0]).toLowerCase();
	int timeType=dbm.haveTimeType(routeId);
	ArrayList<ArrayList<String>> timeTable = dbm.curTimeTable(routeId,timeType);
	ArrayList<String[]> routeStation = dbm.routeStationList(routeId);
	if(routeStation.isEmpty())routeStation = StaticValue.getRouteStationList(routeId);
	ArrayList<String[]> locationList = StaticValue.getBusLocationList(routeId);
	
	//stationSeq, endBus, lowPlate, plateNo, plateType, remainSeatCnt, routeId+"", stationId
	//정류장id, 반환점, 정류장이름, 정류장모바일번호
	/*
	route -> 노선이름, 행선지, 첫차막차, 유형
	timetable -> 테이블종류, 당일 시간표
	*/
	
	String[] tts = timeOptionNames(timeType);
%>
<%!
public String[] timeOptionNames(int timeType) {
	final String WEEKDAY_STR = "평일&ensp;";
	final String WEEKEND_STR = "주말&ensp;";
	final String UP_STR = "기점출발&ensp;";
	final String DOWN_STR = "종점출발&ensp;";
	final String TIMETABLE_STR = "시간표";
	String[] result = null;
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

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="robots" content="noindex">
<meta name="viewport" content="width=device-width">
<title>조암버스:<%=routeInfo[1]%>번 노선정보</title>
<link rel="shortcut icon" href="/drawable/favicon.ico">
<link href="css/routeinfo.css" rel="stylesheet">
</style>
</head>
<script>
	<%
	String[] temp = new String[4];
	temp[0] = tts[0].replace("기점", routeInfo[2]);
	if(tts.length == 2) temp[1] = tts[1].replace("종점", routeInfo[3]);
	else if(tts.length==4) {
		temp[2] = tts[2].replace("기점", routeInfo[2]);
		temp[3] = tts[3].replace("종점", routeInfo[3]);
	}
	%>
	function timepage(s) {
		var url="timeinfo?routeId=<%=routeId%>&tableNo=";
		if (s == 1 || s == "시간표") {
			window
					.open(
							url+"1&title=<%=temp[0]%>",
							"_self", "");
		} else if (s == 2) {
			window
					.open(
							url+"2&title=<%=temp[1]%>",
							"_self", "");
		} else if (s == 3) {
			window
					.open(
							url+"3&title=<%=temp[2]%>",
							"_self", "");
		} else if (s == 4) {
			window
					.open(
							url+"4&title=<%=temp[3]%>",
							"_self", "");
		} else {
		}
	}
</script>
<body>
	<div
		style="position: fixed; z-index: 3; top: 0px; left: 0px; background-color: <%=routeColor%>; width: 100%; height: 55px;">
		<p
			style="display: inline; display: block; text-align: center; color: white; font-size: 130%;"><%=routeInfo[1]%>번</p>

		<a href="index.html"
			style="position: absolute; top: 20px; right: 10px;"><img
			src="/drawable/home.png" /></a>
	</div>
	<div id="info_and_time" style="background-color: <%=routeColor%>;">
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
		}
		if(colorName.equals("yellow")){
			out.print("실시간 위치 미지원<br><br><button onclick='location.href=\"http://m.gbis.go.kr/search/getBusRouteDetail.do?routeId="+routeId+"&osInfoType=M\"')>실시간 위치 보기</button>");		
		}
		else out.print("운행중인 버스: "+locationList.size()+"대");		
		
		if(isJoamBus){
			if(tts.length == 1) {
				out.print("<input type=\"button\" style=\"color:white;float:right;padding-right:5px;background-color:"+routeColor+";border:1px;\" value=\"시간표\" onclick=\"timepage(this.value)\" />");
			}
			else {
				out.print("<select style=\"color:white;float:right;padding-right:5px;background-color:"+routeColor+";\" onchange=\"timepage(this.value)\">"+ 
						"    <option>시간표</option>\r\n");
				for(int i=0; i<tts.length; i++)
					out.print("<option value="+(i+1)+" >"+tts[i]+"</option>");
				out.print("</select>");
			}
		}
		%>
	</div>
	<br>
	<div style="position: relative; z-index: 1;">
		<ul>
			<%
			//id , 턴, 이름, 모바일번호
			for(int i=0; i<routeStation.size();i++){
				boolean isBusCurStation = false;
				String fileName = "mid";
				if(i==0) fileName="start";
				else if(i==routeStation.size()-1)fileName="end";
				if(routeStation.get(i)[1].charAt(0)=='Y')fileName="turn";
				%>
				<li><a href="stationinfo?stationId=<%=routeStation.get(i)[0]%>&stationMbId=<%=routeStation.get(i)[3]%>&stationName=<%=routeStation.get(i)[2]%>">
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
</body>
</html>



















