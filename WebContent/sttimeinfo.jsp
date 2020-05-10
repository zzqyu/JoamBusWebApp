<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.TimeZone"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	response.setCharacterEncoding("utf-8");
	String stationId = request.getParameter("stationId");
	String title = request.getParameter("title");
	String holi = request.getParameter("holi");	
	if(title != null) title = new String(title);
	if(holi != null) holi = new String(holi);
	boolean isHoli = StaticValue.isHoliday(true);
	if(holi != null) {
		if(holi.equals("T"))isHoli =true;
		else if(holi.equals("F"))isHoli =false; 
	}
	
	
	TimeZone kst = TimeZone.getTimeZone ("JST"); 
	// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
	Calendar cal = Calendar.getInstance ( kst );  
	int HH = cal.get(Calendar.HOUR_OF_DAY);
	int MM = cal.get(Calendar.MINUTE);
	String time = HH+""+((MM<10)?"0"+MM:MM);
	
	/*ArrayList<String> timeItemList=null;
	try {
		timeItemList = new DBManager("JOAMBUS").timeTableList(new Integer(routeId), new Integer(tableNo));
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} //StaticValue.getTimeList(routeId, Integer.parseInt(tableNo), request);
	int index = StaticValue.findTimeIndex(timeItemList, time);*/
	DBManager dbm = new DBManager("JOAMBUS");
	Boolean[] isHoliVisible = {false};
	ArrayList<String[]> tt = dbm.stationOfTimetable(stationId, isHoli, isHoliVisible);
	Map<String, ArrayList<String[]>> stt = new HashMap<>();
	//isweekend
	stt = dbm.stationOfTimetableOrderbyStart(stationId, isHoli, null);
	
	
	
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"><meta name="robots" content="noindex">  
  <meta name="viewport" content="width=device-width">  
  <title>조암버스:시간표</title>
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
	  ul{         
		  margin:5px;         
		  list-style:none;    
		  background-color:#eeeeee;  
		  padding-left:0px;   
		  color:#333333;
	  } 
	  li:hover{  
	  	background-color:#ffbdbd;
	  }
	  li{  
		  background-color:#ffffff;  
		  padding:2px;  
		  padding-left:5px;   
		  margin-bottom:1px; 
	  }
	  
	  
	  /* Style the tab */
	.tab {
	  overflow: hidden;
	  border: 1px solid #ccc;
	  background-color: #f1f1f1;
	}
	
	/* Style the buttons that are used to open the tab content */
	.tab button {
	  background-color: inherit;
	  float: left;
	  border: none;
	  outline: none;
	  cursor: pointer;
	  padding: 14px 16px;
	  transition: 0.3s;
	}
	
	/* Change background color of buttons on hover */
	.tab button:hover {
	  background-color: #ddd;
	}
	
	/* Create an active/current tablink class */
	.tab button.active {
	  background-color: #ccc;
	}
	
	/* Style the tab content */
	.tabcontent {
	  display: none;
	  padding: 6px 12px;
	  border: 1px solid #ccc;
	  border-top: none;
	}
	
	
	.switch {
	  position: relative;
	  display: inline-block;
	  width: 60px;
	  height: 34px;
	}
	
	.switch input { 
	  opacity: 0;
	  width: 0;
	  height: 0;
	}
	
	.slider {
	  position: absolute;
	  cursor: pointer;
	  top: 0;
	  left: 0;
	  right: 0;
	  bottom: 0;
	  background-color: #ccc;
	  -webkit-transition: .4s;
	  transition: .4s;
	}
	
	.slider:before {
	  position: absolute;
	  content: "";
	  height: 26px;
	  width: 26px;
	  left: 4px;
	  bottom: 4px;
	  background-color: white;
	  -webkit-transition: .4s;
	  transition: .4s;
	}
	
	input:checked + .slider {
	  background-color: #2196F3;
	}
	
	input:focus + .slider {
	  box-shadow: 0 0 1px #2196F3;
	}
	
	input:checked + .slider:before {
	  -webkit-transform: translateX(26px);
	  -ms-transform: translateX(26px);
	  transform: translateX(26px);
	}
	
	/* Rounded sliders */
	.slider.round {
	  border-radius: 34px;
	}
	
	.slider.round:before {
	  border-radius: 50%;
	}
	
	
  </style>
</head>
<body>
	<!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:75px;"><%=title%></p>
        <!-- Collapsible content -->
	    <div class="" id="navbarSupportedContent">
	        
		</div>
      </div>
    </nav>
    	
	<div id="list" class="container bus_List" style="color:#fff;">
		<p style="padding-top:66px;color:#fff;"> 현재시간 &gt;&gt; <%=HH%>시<%=MM%>분</p>
		<p style="color:#fff;"> 8155번, 9802번을 제외한 정보를 보여드립니다.</p>
		<% if(isHoliVisible[0]){%>
		<div style="display: flex;align-items: center;">
		<p style="display:inline;">주말/공휴일</p>&nbsp;&nbsp;&nbsp;
		<label class="switch">
		  <input type="checkbox"  <%if(isHoli){%>checked<%}%> onclick="checkSwitch(this)" data-toggle="modal" data-target="#exampleModalCenter">
		  <span class="slider round"></span>
		</label>
		</div><%}%>
		<div class="tab">
		  <button class="tablinks" onclick="openCity(event, 'table0')"id="defaultOpen">시간순</button>
		  <%
		  int cnt = 0;
		  if(stt.keySet().size()>1){
		  for( String key:stt.keySet()){
		  %>
		  	<button class="tablinks" onclick="openCity(event, 'table<%=++cnt%>')"><%=key%> 출발</button>
		  <%}}%>
		</div>
		
		<!-- Tab content -->
		<div id="table0" class="tabcontent">
		  <div class="list-group">
		  	<%
			for(String[] row: tt){%>
				<a href="/routeinfo?routeId=<%=row[1]%>">
				<div class='list-group-item list-group-item-action'>
				<h6><%=row[0]%></h6> <%=row[2]%> <%=row[3]%>기준 <%=row[4]%>방향
				</div>
				</a>
			<%}%>
		  </div>
		</div>
		<%
		int cnt1 = 0;
		if(stt.keySet().size()>1){
		for( String key:stt.keySet()){%>
		<div id="table<%=++cnt1%>" class="tabcontent">
			<div class="list-group">
		  	<%
		  	for(String[] row:stt.get(key)){%>
		  		<a href="/routeinfo?routeId=<%=row[1]%>">
				<div class='list-group-item list-group-item-action'>
				<h6><%=row[0]%></h6> <%=row[2]%> <%=row[3]%>방향
				</div>
				</a>
			<%}%>
		  </div>
		</div>
		<%}}%>
		
	</div>
	
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
	
	<!-- Footer -->
    <footer class="py-5 bg-dark" >
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; Joam Bus Web App 2018</p>
        <div style="padding-bottom:50px;"></div>
      </div>
      <!-- /.container -->
    </footer>
	<%=StaticValue.AD%>
	<!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom JavaScript for this theme -->
    <script src="js/scrolling-nav.js"></script>
    <script type="text/javascript">
    function openCity(evt, cityName) {
    	  // Declare all variables
    	  var i, tabcontent, tablinks;

    	  // Get all elements with class="tabcontent" and hide them
    	  tabcontent = document.getElementsByClassName("tabcontent");
    	  for (i = 0; i < tabcontent.length; i++) {
    	    tabcontent[i].style.display = "none";
    	  }

    	  // Get all elements with class="tablinks" and remove the class "active"
    	  tablinks = document.getElementsByClassName("tablinks");
    	  for (i = 0; i < tablinks.length; i++) {
    	    tablinks[i].className = tablinks[i].className.replace(" active", "");
    	  }

    	  // Show the current tab, and add an "active" class to the button that opened the tab
    	  document.getElementById(cityName).style.display = "block";
    	  evt.currentTarget.className += " active";
    }
    function checkSwitch(ee){
    	var ck = ee.checked? "T" : "F";
    	location.replace("/sttimeinfo?stationId=<%=stationId%>&title=<%=title%>&holi="+ck);
    }
    document.getElementById("defaultOpen").click();
    
    
    </script>
</body>
</html>



















