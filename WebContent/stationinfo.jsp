<%@page import="java.time.DayOfWeek"%>
<%@page import="java.util.Collections"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="joambuswebapp.*" %>
<%@page import="java.util.Arrays"%>
<%@page import="org.w3c.dom.*"%>
<%@page import="java.net.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
response.setCharacterEncoding("utf-8");
	
	String stationId = request.getParameter("stationId");//정류장 ID
	String stationMbId = request.getParameter("stationMbId");//정류장 모바일ID
	//String stationName = new String(request.getParameter("stationName").getBytes("8859_1"), "UTF-8"); //정류장 이름
	String stationName = new String(request.getParameter("stationName")); //정류장 이름
	

	String holi = request.getParameter("holi");	
	if(holi != null) holi = new String(holi);
	
	boolean isHoli = StaticValue.isHoliday(false);
	
	if(holi != null) {
		if(holi.equals("T"))isHoli =true;
		else if(holi.equals("F"))isHoli =false; 
	}


	DBManager dbm = new DBManager("JOAMBUS");
	String routeId, routeTypeCd, routeName, startStationName, middleStationName, endStationName, direction, isInDB="";
	ArrayList<String> arriveRouteIds= new ArrayList<String>();
	
	
	TimeZone kst = TimeZone.getTimeZone ("JST"); 
	// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
	Calendar cal = Calendar.getInstance ( kst );  
	int HH = cal.get(Calendar.HOUR_OF_DAY);
	int MM = cal.get(Calendar.MINUTE);
	String time = HH+""+((MM<10)?"0"+MM:MM);
	Boolean[] isHoliVisible = {false};
	//ArrayList<String[]> tt = dbm.stationOfTimetable(stationId, isHoli, isHoliVisible);
	Map<String, ArrayList<String[]>> stt = new HashMap<>();
	//isweekend
	stt = dbm.stationOfTimetableOrderbyStart(stationId, isHoli, null);
%>
<%!
    String routeItemHtml(String[] routeInfo, String routeId, BusArriveStation routeItem){
   		String color = StaticValue.RouteTypeToColorName(routeInfo[0]).toLowerCase();
    	String html="<a class='list-group-item list-group-item-action' href='/routeinfo?routeId="+ routeId + "'>"+
		"<h3 class='routenm bg-"+color+"' style='display:inline ; '>"+routeInfo[1]+"</h3><br>"+
		"<h5 class='black' style='display:inline; '>"+routeInfo[2]+"</h5>";
		html+="<i class='fa fa-exchange-alt black ' style='padding:0.2em'></i>";
		html+="<h5 class='black' style='display:inline; '>"+routeInfo[3]+"</h5>";
		if(routeItem!=null){
			html+="<h6>"+routeItem.getPredictTime1()+ "분 후 "+(routeItem.getRemainSeatCnt1().equals("-1")?"":routeItem.getRemainSeatCnt1()+"석") ;
			if(!routeItem.getPredictTime2().isEmpty())html+="&ensp;" + routeItem.getPredictTime2()+ "분 후 "+(routeItem.getRemainSeatCnt2().equals("-1")?"":routeItem.getRemainSeatCnt2()+"석");
			html+="</h6></a>";
		}	
		else html+="<h6> </h6></a>";
		return html;
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
							    <h3 class="title-color-dark">운행중인 노선</h3>
								<%
									try{
										ArrayList<BusArriveStation> routeList = StaticValue.getBusArriveStation(stationId);
										Collections.sort(routeList, (x, y)->(Integer.compare(Integer.parseInt(x.getPredictTime1()) , Integer.parseInt(y.getPredictTime1()))));
							        	for(BusArriveStation routeItem: routeList){
							        		arriveRouteIds.add(routeItem.getRouteId());
											routeId = routeItem.getRouteId();
											String[] routeInfo = dbm.routeInfo(Integer.parseInt(routeId));
											if(routeInfo==null) { 
												System.out.println("없는 노선");
												routeInfo = dbm.gbisRouteInfo(Integer.parseInt(routeId));
												if(routeInfo==null){
													try {
														ArrayList<String> ri = new ArrayList<String>();
														ri.add(routeId+"");
														RouteInfoItem ii = StaticValue.getRouteInfoItem(ri, request).get(0);
														routeInfo = new String[]{ii.getRouteTypeCd(), ii.getRouteName(), 
																ii.getStartStationName(), ii.getEndStationName(), 
																ii.getUpFirstTime(), ii.getDownFirstTime(),
																ii.getUpLastTime(), ii.getDownLastTime()};
													} catch (Exception e) {
														e.printStackTrace();
													}
												}
											}
							        		out.print(routeItemHtml(routeInfo, routeId, routeItem));
							        	}
									}catch (Exception e) {
									// TODO: handle exception
									}
								%>
								<hr>
							    <h3 class="title-color-dark">노선 목록</h3>
							    <%
									//정류장을 경유하는 전체 노선 중 위 도착 예정인 버스 제외하고 출력
									
									try {
										//API를 통해 정류장을 경유하는 전체 노선ID 목록 받기
										ArrayList<String> gbisRouteList = StaticValue.stopByRouteList(stationId);
										//전체 노선 목록에서 도착 예정 노선을 제거한다
										for(String arriveRouteId: arriveRouteIds) {
											gbisRouteList.remove(arriveRouteId);
										}
										//50-1추가
										gbisRouteList.addAll(dbm.localRouteSelectAtStation(stationId));
										//리스트로 표출하기
										for(String gbisRouteId: gbisRouteList) {
											String[] routeInfo = dbm.routeInfo(Integer.parseInt(gbisRouteId));
											if(routeInfo==null) { 
												System.out.println("없는 노선");
												routeInfo = dbm.gbisRouteInfo(Integer.parseInt(gbisRouteId));
												if(routeInfo==null){
													try {
														ArrayList<String> ri = new ArrayList<String>();
														ri.add(gbisRouteId+"");
														RouteInfoItem ii = StaticValue.getRouteInfoItem(ri, request).get(0);
														routeInfo = new String[]{ii.getRouteTypeCd(), ii.getRouteName(), 
																ii.getStartStationName(), ii.getEndStationName(), 
																ii.getUpFirstTime(), ii.getDownFirstTime(),
																ii.getUpLastTime(), ii.getDownLastTime()};
													} catch (Exception e) {
														e.printStackTrace();
													}
												}
											}
											out.print(routeItemHtml(routeInfo, gbisRouteId, null));
										}
										
									}catch (Exception e) {
									// TODO: handle exception
									}
								
								
								%>
						    </div>
							
						</div>
						
						<div class="image item-center image-new" id="c_left" style=" background-color: #fee9d4; text-align:left">
							<div class="content" style="width: 100%;padding:1.5rem;" >
								<h2><a class="title-color-dark" href="/main" >조암버스</a></h2>
								<h4 class="title-color-dark"><%=stationName %><%if(stationMbId.contains("NULL")){%>(<%=stationMbId %>)<%} %></h4>
								<%
								int cnt = 0;
								if(stt.size()>0){%>
								<div class="box1" style="margin-top:12px;<%if(stt.size()>3){ %> padding:0.5em;<%} %>">
									<% if(isHoliVisible[0]){%>
									<div style="display: flex;white-space:nowrap; align-items: center;">
										<h6 style="display:inline;" class='title-color-dark'>시간표&nbsp;&nbsp;&nbsp;</h6>
										<div style="position:absolute; right:10%;">
											<input type="checkbox" onclick="checkSwitch(this)" id="holi"  name="holi" <%if(isHoli){%>checked<%}%>>
											<label for="holi">주말/공휴일</label>
										</div>
									</div><%}%>
									
									<%
									for( String key:stt.keySet()){
									%>
									<div class="box2" <%if(stt.size()>3){ %> style="padding:0.5em"<%} %>>
										<label class='title-color-dark'> <%=key.split("\\(")[0].replace("터미널", "").replace("만세시장", "").replace("종점", "")%>출발</label>
										<div style="display: flex;overflow-x:auto; white-space:nowrap; width:inherit;"> 
											<%
											boolean flag = false;
											for(String[] row: stt.get(key)){
												String nowTime = String.format("%02d:%02d", cal.get(Calendar.HOUR_OF_DAY),cal.get(Calendar.MINUTE));
												String curTime = row[0];
											%>
											<div style="flex-shrink: 0; margin-bottom: 0rem; font-size:0.5em;" >
												<a class='list-group-item  title-color-dark 
												<% if(!flag && !LocalTime.parse(nowTime).isAfter(LocalTime.parse(curTime))) {%>
												time-accent<%}%>' 
												href="/routeinfo?routeId=<%=row[1]%>"
												<% if(!flag && !LocalTime.parse(nowTime).isAfter(LocalTime.parse(curTime))) {
													flag = true;%>
												id="time_accent<%=cnt%>" <%}%>
												<%if(stt.size()>3){ %> style="padding:0.35em;"<%} %>>
												<h6><%=curTime%>&ensp;<%=row[2]%></h6><%=row[3].split("\\(")[0].replace("터미널", "").replace("만세시장", "").replace("종점", "")%>방향
												</a>
											</div>
											<%}%>
										</div>
									</div>
									<%cnt++;} %>
								</div>
								<%} %>
							</div>
						</div>
					</section>

				<!-- Footer -->
				<jsp:include page="footer.jsp" flush="true"></jsp:include>

			</div>
			
			<script type="text/javascript">
			function checkSwitch(ee){
		    	var ck = ee.checked? "T" : "F";
		    	location.replace("/stationinfo?stationId=<%=stationId%>&stationMbId=<%=stationMbId%>&stationName=<%=stationName%>&holi="+ck);
		    }
			
			<%for(int i = 0; i <= cnt; i++){%>
				document.getElementById('time_accent<%=i%>').scrollIntoView(true);
			<%}%>
			document.documentElement.scrollTop = 0;
			
			
			</script>
			
			
			<!-- Scripts -->
			<jsp:include page="js.jsp" flush="true"></jsp:include>
			
	</body>
</html>







