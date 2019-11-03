<%@ page import="joambuswebapp.*" %>
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
	
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="robots" content="noindex">
<meta name="viewport" content="width=device-width">
<title>조암버스</title>
<!-- Bootstrap core CSS -->
<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="css/scrolling-nav.css" rel="stylesheet">
<!-- Font Awesome CSS -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">

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
 

#list{  
	padding-top: 80px;  
}  
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
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:75px;"\><%=stationName+"("+stationMbId+")"%></p>
        <!-- Collapsible content -->
	    <div class="" id="navbarSupportedContent">
	        
		</div>
      </div>
    </nav>
	<!-- <div style="position:fixed;z-index: 3;top:0px;left:0px;background-color:#ec6778;width:100%; height:55px;"\>  
				        <p style="display:inline; display:block;text-align:center; color:white; font-size:130%;"\><%=stationName+"("+stationMbId+")"%></p>  
				  
				        <a href=index.html style="position:absolute;top:20px;left:10px;"\>  
				            <img src="/drawable/home.png" />  
						</a>   
				    </div>-->
	
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
					RouteInfoItem rii = StaticValue.getRouteInfoItem(new ArrayList<String>(Arrays.asList(new String[] {routeId})), request).get(0);
					routeTypeCd = rii.getRouteTypeCd();
					routeName = rii.getRouteName();
					startStationName = rii.getStartStationName();
					middleStationName = "";
					endStationName = rii.getEndStationName();
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
				//리스트로 표출하기
				for(String gbisRouteId: gbisRouteList) {
					RouteInfoItem rii = StaticValue.getRouteInfoItem(new ArrayList<String>(Arrays.asList(new String[] {gbisRouteId})), request).get(0);
												
					out.print("<a class='list-group-item list-group-item-action' "+
			    			"href='routeinfo.jsp?routeId="+gbisRouteId+"'><table>"+
							"<tbody><tr>"+
									"<td rowspan='3'><img width='40px'"+
											"src='drawable/bus_"+StaticValue.RouteTypeToColorName(rii.getRouteTypeCd()).toLowerCase()+".PNG'></td>"+
									"<td id='s_name'>"+rii.getRouteName()+"</td>"+
								"</tr><tr><td id='s_mbno'>"+rii.getStartStationName().split("[.(]")[0]+"-"+rii.getEndStationName().split("[.(]")[0]+"</td></tr></tbody></table></a>");
				}
				
			}catch (Exception e) {
			// TODO: handle exception
			}
			out.print("</ul></div>");
		
		
		%>
	</div>
	<!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom JavaScript for this theme -->
    <script src="js/scrolling-nav.js"></script>
</body>
</html>



















