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
	
	TimeZone kst = TimeZone.getTimeZone ("JST"); 
	// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
	Calendar cal = Calendar.getInstance ( kst );  
	int HH = cal.get(Calendar.HOUR_OF_DAY);
	int MM = cal.get(Calendar.MINUTE);
	String time = HH+":"+((MM<10)?"0"+MM:MM);
	

	DBManager dbm = new DBManager("JOAMBUS");
	Map<String, ArrayList<String[]>> stt = new HashMap<>();
	stt = dbm.stationOfTimetableOrderbyStart(stationId, StaticValue.isHoliday(true), time);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="robots" content="noindex">
<meta name="viewport" content="width=device-width">
<title>조암버스</title>
<link rel="shortcut icon" href="/drawable/favicon.ico">
<!-- Bootstrap core CSS -->
<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="css/scrolling-nav.css" rel="stylesheet">
<!-- Font Awesome CSS -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<style>  
@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);  
 
body {  
	font-family: 'Jeju Gothic', sans-serif;  
	background-color:#192231;
	font-size: 10pt;  
	margin:0px;  
	line-height: 1m;  
}  
.card {color:#ffffff; width: 100%; height: 7rem; }
 
header {  
	padding-top:0px;  
	padding-bottom: 5px;  
	padding-left: 7px;  
    font-size: 90%;  
	height:25px;  
	line-height: 2.5em; 
	background-color: #F7E7D6;  
	color:#ec6778;  
} 

#route_time {  
    padding-left: 10px;  
	padding-bottom: 1px;  
    font-size: 90%;  
	color: #ec6778;  
}  
#stit {  
	font-size: 16pt;  
}  
#s_name, #r_start_sta, #r_end_sta{font-size:150%; font-style:bold; color:#333333;}#s_name,#s_mbno,#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:20%;}#r_name{  white-space:nowrap;  font-size:150%;  color:#000;  font-weight:bold;}
    .bus_List{padding:10px;}
    


</style>
</head>
<body>
	<!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/" style="font-size:125%;">조암버스</a>
        <p style="text-align:center; color:white; font-size:100%;margin-bottom:0;margin-right:30px;"><%=stationName+"("+stationMbId.trim()+")"%></p>
        <!-- Collapsible content -->
	    <div class="" id="navbarSupportedContent">
	        
		</div>
      </div>
    </nav>
    <div style="color:#fff;background-color: #985e6d; padding-top:80px;padding-bottom:10px;">
    	<table style="margin-left: auto; margin-right: auto;">
    		<tbody style="line-height:0%">
	    		<%
				//int cnt1 = 0;
				for( String key:stt.keySet()){%>
    			<tr style="font-size:16pt;line-height:40%">
    			<td style="font-size:10pt;vertical-align:top;float:left;text-align:right;line-height:100%"><%=key%><br>출발</td>
    			<%for(String[] row:stt.get(key)){%>
					<td><%=row[0]%><br><br><p style="font-size:10pt"><%=row[2]%></p></td>
				<%}%>
    			</tr>
    			<%}%>
    		</tbody>
    	</table>
    	<div style="height:38px;">
    	<a style="color:#fff;" href="/sttimeinfo?stationId=<%=stationId%>&title=<%=stationName %>"><button type="button" class="btn btn-outline-light" style="float:right;margin-right:8px" data-toggle="modal" data-target="#exampleModalCenter">시간표</button></a>
    	</div>
    	
	</div>
	<div id="list" class="container bus_List">
		<header id=header><p>운행중인 버스</p></header>
		<div class="list-group">
		<%
		//운행중인 버스 리스트 표출
			
			ArrayList<String> arriveRouteIds= new ArrayList<String>();
			try {
				//API를 통해 도착 예정 버스노선ID 목록 받기
				ArrayList<BusArriveStation> routeList = StaticValue.getBusArriveStation(stationId);
				//리스트로 표출하기
				for(BusArriveStation routeItem: routeList) {
					arriveRouteIds.add(routeItem.getRouteId());
					String routeId, routeTypeCd, routeName, startStationName, middleStationName, endStationName, direction, isInDB="";
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
					routeTypeCd = routeInfo[0];
					routeName = routeInfo[1];
					startStationName = routeInfo[2];
					middleStationName = "";
					endStationName = routeInfo[3];
					direction = "-";
					
					out.print("<a class='list-group-item list-group-item-action' "+
			    			"href='routeinfo.jsp?routeId="+routeId+"'><table>"+
							"<tbody><tr>"+
									"<td rowspan='3'><img width='40px'"+
											"src='drawable/bus_"+StaticValue.RouteTypeToColorName(routeTypeCd).toLowerCase()+".PNG'></td>"+
									"<td id='s_name'>"+routeName+"</td>"+
											"<td id=\"route_time\" colspan=2>약 "+routeItem.getPredictTime1()+ "분 후 "+(routeItem.getRemainSeatCnt1().equals("-1")?"":routeItem.getRemainSeatCnt1()+"석") +" </td>\r\n" +
													((routeItem.getPredictTime2().equals(""))?"":("<td id=\"route_time\" colspan=2>약 "+routeItem.getPredictTime2()+ "분 후 "+(routeItem.getRemainSeatCnt2().equals("-1")?"":routeItem.getRemainSeatCnt2()+"석") +" </td>\r\n")) +
								"</tr><tr><td id='s_mbno'>"+startStationName.split("[.(]")[0]+direction+middleStationName.split("[.(]")[0]+direction+endStationName.split("[.(]")[0]+"</td></tr></tbody></table></a>");
				}
				
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		%>
		</div>
		<header id=header><p>노선 목록</p></header>
		<div class="list-group">
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
					String routeId, routeTypeCd, routeName, startStationName, middleStationName, endStationName, direction;
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
					routeTypeCd = routeInfo[0];
					routeName = routeInfo[1];
					startStationName = routeInfo[2];
					endStationName = routeInfo[3];
					if(routeTypeCd.equals("30")) routeName+="(실시간 미지원)";
					out.print("<a class='list-group-item list-group-item-action' "+
			    			"href='routeinfo.jsp?routeId="+gbisRouteId+"'><table>"+
							"<tbody><tr>"+
									"<td rowspan='3'><img width='40px'"+
											"src='drawable/bus_"+StaticValue.RouteTypeToColorName(routeTypeCd).toLowerCase()+".PNG'></td>"+
									"<td id='s_name'>"+routeName+"</td>"+
								"</tr><tr><td id='s_mbno'>"+startStationName.split("[.(]")[0]+"-"+endStationName.split("[.(]")[0]+"</td></tr></tbody></table></a>");
				}
				
			}catch (Exception e) {
			// TODO: handle exception
			}
			out.print("</ul></div>");
		
		
		%>
	</div>
	<!-- Footer -->
    <footer class="py-5 bg-dark" >
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; Joam Bus Web App 2018</p>
        <div style="padding-bottom:50px;"></div>
      </div>
      <!-- /.container -->
    </footer>
	<%=StaticValue.AD%>
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLongTitle">시간표 로딩 중...</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onClick="history.go(0)">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <div class="spinner-border"></div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal" onClick="history.go(0)">Close</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	
	
	
	
	
	
	<!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom JavaScript for this theme -->
    <script src="js/scrolling-nav.js"></script>
    <script type="text/javascript">
    
    var _showPage = function() {
    	  var loader = $("div.loader");
    	  var container = $("div.container");
    	  loader.css("display","none");
    	  container.css("display","block");
    	};
    </script>
</body>
</html>



















