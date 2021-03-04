
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Collections"%>
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
				routeItem.getUpLastTime(), routeItem.getDownLastTime(), null, routeItem.getPeekAlloc(), routeItem.getnPeekAlloc()};
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	else isJoamBus = routeInfo[8]!=null;
	
	// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
	Calendar cal = Calendar.getInstance ( TimeZone.getTimeZone ("JST") ); 
	
	String routeColor = StaticValue.RouteTypeToColor(routeInfo[0]);
	String colorName = StaticValue.RouteTypeToColorName(routeInfo[0]).toLowerCase();
	String[] tts=null; 
	ArrayList<String[]> locationList=null ,routeStation=null;
	ArrayList<Boolean> isDarks = null;
	int timeType, drivingBusNum=0;
	
	try{
		timeType=dbm.haveTimeType(routeId);
		routeStation = new ArrayList<String[]>();
		locationList = new ArrayList<String[]>();
		if(routeStation.isEmpty()){
			routeStation = StaticValue.getRouteStationList(routeId);
		
			for(int i = 0; i < routeStation.size(); i++ ){
				String[] row = routeStation.get(i);
				/*System.out.print("\""+routeId+"\",");
				System.out.print("\""+row[0]+"\",");//sid
				System.out.print("\""+row[1]+"\",");//updown
				System.out.print("\""+(i+1)+"\",");//order
				System.out.print("\""+routeInfo[1]+"\",");//route_NM
				System.out.println("\""+row[2]+"\"");//updown
				*/
			}
		}
		locationList = StaticValue.getBusLocationList(routeId);
		drivingBusNum = locationList.size();
		if(timeType>0){
			tts = timeOptionNames(timeType, routeInfo);
			isDarks = new ArrayList<Boolean>(Collections.nCopies(tts.length, false));
			char isWeekend = 'N';
			
	        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK)-1;
			if (timeType%2==0 && 
	        		(DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY 
	        		|| DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY)) isWeekend = 'Y';
	        if(timeType >= 5) {
	        	if(DayOfWeek.of(dayOfWeek) == DayOfWeek.SATURDAY )isWeekend = 'S';
	        	if(DayOfWeek.of(dayOfWeek) == DayOfWeek.SUNDAY )isWeekend = 'Y';
	        }
	        for(int i =0 ; i < tts.length; i++){
	        	if((isWeekend=='N'&&!tts[i].contains("토요")&&!tts[i].contains("공휴"))
				        	||(isWeekend=='S'&&tts[i].contains("토요"))
				        	||(isWeekend=='Y'&&tts[i].contains("공휴")))
	        		isDarks.set(i, true);
	        }
		}
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
	*/
%>
<%!
public String[] timeOptionNames(int timeType, String[] routeInfo) {
	final String WEEKDAY_STR = "평일&ensp;";
	final String WEEKEND_STR = "주말/공휴일&ensp;";
	final String WEEKSAT_STR = "토요일&ensp;";
	final String UP_STR = routeInfo[2]+"&ensp;";
	final String DOWN_STR = routeInfo[3]+"&ensp;";
	String[] result = null;
	System.out.println("timetype: " + timeType);
	if (timeType == 1) {
		result = new String[1];
		result[0] = UP_STR;
	}
    else if (timeType == 2)
    {
    	result = new String[2];
    	result[0] = WEEKDAY_STR;
    	result[1] = WEEKEND_STR;
    }
    else if (timeType == 3)
    {
    	result = new String[2];
    	result[0] = UP_STR;
    	result[1] = DOWN_STR;
    }
    else if (timeType == 4)
    {
    	result = new String[4];
    	result[0] = WEEKDAY_STR+UP_STR;
    	result[1] = WEEKDAY_STR+DOWN_STR;
    	result[2] = WEEKEND_STR+UP_STR;
    	result[3] = WEEKEND_STR+DOWN_STR;
    }
    else if (timeType == 5)
    {
    	result = new String[3];
    	result[0] = WEEKDAY_STR+UP_STR;
    	result[1] = WEEKSAT_STR+UP_STR;
    	result[2] = WEEKEND_STR+UP_STR;
    }
    else if (timeType == 6)
    {
    	result = new String[6];
    	result[0] = WEEKDAY_STR+UP_STR;
    	result[1] = WEEKSAT_STR+UP_STR;
    	result[2] = WEEKEND_STR+UP_STR;
    	result[3] = WEEKDAY_STR+DOWN_STR;
    	result[4] = WEEKSAT_STR+DOWN_STR;
    	result[5] = WEEKEND_STR+DOWN_STR;
    }
	return result;
}

%>



<!DOCTYPE HTML>
<!--
	Story by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
	<jsp:include page="head.jsp" flush="true"></jsp:include>
	<body class="is-preload"  >

		<!-- Wrapper -->
			<div id="wrapper" class="divided">

				<!-- One -->
					<section class="banner style1 orient-right content-align-left image-position-left fullscreen onload-image-fade-in onload-content-fade-right">
						<div class="content content-new" id="c1" >
							
							<div class="list-group">
							<%for(int i=0; i<routeStation.size();i++){
								String url = "stationinfo?stationId="+routeStation.get(i)[0]+"&stationMbId="+routeStation.get(i)[3]+"&stationName="+routeStation.get(i)[2];
								boolean isBusCurStation = false;
								boolean isSeat = false;
								String carNum="", seat="";
								if(url.contains("(경유)"))url="";
								if(locationList.size()>0&&new Integer(locationList.get(0)[0])==i+1){
									isBusCurStation = true;
									isSeat = !locationList.get(0)[5].equals("-1");
									carNum = locationList.get(0)[3].substring(5);
									seat = locationList.get(0)[5];
									locationList.remove(0);
								}
							%>
								<a class="list-group-item list-group-item-action <%if(routeStation.get(i)[2].contains("(경유)")){ %> inactiveLink <%} %>" 
								href="<%if(!routeStation.get(i)[2].contains("(경유)")){ %><%=url%><%} %>">
									<h5 class="<%if(!routeStation.get(i)[2].contains("(경유)")){ %>black<%} %> busstop-text-width" ><%=routeStation.get(i)[2] %></h5>
									<h6 class="busstop-text-width"><%=routeStation.get(i)[3]==null?"&emsp;":routeStation.get(i)[3]%></h6>
									<div class="vl"></div>
									<div class="circle-<%if(routeStation.get(i)[1].charAt(0)=='Y'){%>endstop<%}else{%>normal<%}%>">
										<%if(routeStation.get(i)[1].charAt(0)=='Y'){%>
										<i class='fa fa-undo'></i>
										<%} %>
										<%if(isBusCurStation){ %>
											<div class="loca-bus-back"></div>
											<i class='loca-bus <%=colorName%> fas fa-bus'></i>
											<div class="loca-bus-num <%if(isSeat){ %>loca-bus-seat <%} %>"><%=carNum%><%if(isSeat){ %> <%=seat%>석<%} %></div>
										<%} %>
										
									</div>
								</a>
							<%} %>
							</div>
						</div>
						
						<div class="image item-center image-new" id="c_left" style=" background-color: #fee9d4; text-align:left">
							<div class="content" style="width: 100%;padding:1.5rem;" >
								<h2 ><a class="title-color-dark" href="/main" >조암버스</a></h2>
								<h3 class="title-color-dark" style='display:inline;'><a class='title-color-dark routenm bg-<%=colorName%>'><%=routeInfo[1]%></a></h3>
								<h4 class="title-color-dark" style='display:inline;' class='title-color-dark'><%=routeInfo[2]%>-<%=routeInfo[3]%></h4>
								<h6 class="title-color-dark" style='margin-top:0.4em;'>기점 첫차<%=routeInfo[4].substring(0, 5)%> 막차<%=routeInfo[5].substring(0, 5)%>&emsp;|종점 첫차<%=routeInfo[6].substring(0, 5)%> 막차<%=routeInfo[7].substring(0, 5)%>&emsp;|배차간격: <%if(Integer.parseInt(routeInfo[9])>0){%><%=routeInfo[9]%>~<%}%><%if(Integer.parseInt(routeInfo[10])>0){%><%=routeInfo[10]%>분<%} else{%>-<%} %></h6>
								<%if(!colorName.equals("yellow")){%>
									<h6 class="title-color-dark" style="margin-top:20px;">운행 중인 버스: <%=drivingBusNum%>대</h6>
								<%} %>	
								<%if(tts!=null){ %>
							  	<div class="box1" style="margin-top:20px;">
									<h6 class='title-color-dark'>시간표</h6>
									<%if(routeInfo[1].contains("H106")){ %>
									    <p style="color:red;">조암출발 시간은 남양출발시간 + 60~70분이니 참고하기 바랍니다.</p>
									<%} %>
									<%
									int tnum=1;
							  		for(String startBusstop: tts){
							  			int tNo = tnum;
							  			if(startBusstop.contains("토요일")&&tnum==2) tNo=5;
							  			ArrayList<String> timeList = dbm.timeTableList(routeId, tNo);
							  		%>
									<div class="box2<%=isDarks.get(tnum-1)?"-dark":""%>">
										<label class='time-title title-color-<%=isDarks.get(tnum-1)?"light":"dark"%>'> <%=(startBusstop)%>출발</label>
										<div style="display: flex;overflow-x:auto; white-space:nowrap; width:inherit;"> 
										<%
										boolean flag = false;
										for(String timeItem:timeList){
											
											String nowTime = String.format("%02d:%02d", cal.get(Calendar.HOUR_OF_DAY),cal.get(Calendar.MINUTE));
											String curTime = timeItem.substring(0,2)+":"+timeItem.substring(2);
										%>
											<p 
											<% 
											if(!flag && !LocalTime.parse(nowTime).isAfter(LocalTime.parse(curTime))) {
												flag = true;
											%>
											class="time-accent<%=isDarks.get(tnum-1)?"-dark":""%>" id="time_accent<%=tnum%>" 
											<%}%>
											style="<%if(tts.length>3){ %>margin-bottom: 0rem;<%} %> margin-top:1.5em; flex-shrink: 0;">&nbsp;<%=curTime%>&nbsp;</p>
										<%} %>
										</div>
									</div>
									<%tnum++;} %>
								</div>
								<%} %>
							<%if(colorName.equals("yellow")){%>
								<br><a href="http://m.gbis.go.kr/search/getBusRouteDetail.do?routeId=<%=routeId%>&osInfoType=M" class="button small bt-dark no-box-shadow" >실시간 위치</a>
							<%}%> 
							</div>
						</div>
					</section>

				<!-- Footer -->
				<jsp:include page="footer.jsp" flush="true"></jsp:include>

			</div>
			
			<script type="text/javascript">
			<%if(tts!=null){for(int i = 1; i <= tts.length; i++){%>
				document.getElementById('time_accent<%=i%>').scrollIntoView();
			<%}}%>
			document.documentElement.scrollTop = 0;
			</script>
			
			<!-- Scripts -->
			<jsp:include page="js.jsp" flush="true"></jsp:include>
			
	</body>
</html>







