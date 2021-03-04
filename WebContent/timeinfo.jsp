<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.TimeZone"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
response.setCharacterEncoding("utf-8");
	String routeId = request.getParameter("routeId");
	String tableNo = request.getParameter("tableNo");
	String title = request.getParameter("title");	
	if(title != null) title = new String(title);
	
	if(title.contains("토요일")&&tableNo.equals("2")) tableNo="5";
	
	
	
	TimeZone kst = TimeZone.getTimeZone ("JST"); 
	// 주어진 시간대에 맞게 현재 시각으로 초기화된 GregorianCalender 객체를 반환.
	Calendar cal = Calendar.getInstance ( kst );  
	int HH = cal.get(Calendar.HOUR_OF_DAY);
	int MM = cal.get(Calendar.MINUTE);
	String time = HH+""+((MM<10)?"0"+MM:MM);
	
	ArrayList<String> timeItemList=null;
	try {
		timeItemList = new DBManager("JOAMBUS").timeTableList(new Integer(routeId), new Integer(tableNo));
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} //StaticValue.getTimeList(routeId, Integer.parseInt(tableNo), request);
	int index = StaticValue.findTimeIndex(timeItemList, time);
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
	  
	  #now{  
		  background-color:#ff6666;  
		  color:#ffffff;  
		  font-weight:bold;
	  }
  </style>
</head>
<body>
	<!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:75px;"\><%=title%></p>
        <!-- Collapsible content -->
	    <div class="" id="navbarSupportedContent">
	        
		</div>
      </div>
    </nav>
    	
	<div id="list" class="container bus_List">
		<p style="padding-top:66px;color:#fff;"> 현재시간 &gt;&gt; <%=HH%>시<%=MM%>분</p>
		<div class="list-group">
		<%
		for(int i=0;i<timeItemList.size();i++) {
			if(i==index)
				out.print("<div class='list-group-item list-group-item-action' id=\"now\" >"+new StringBuffer(timeItemList.get(i)).insert(2, ':')+"</div>" );
			else	
				out.print("<div class='list-group-item list-group-item-action'>"+new StringBuffer(timeItemList.get(i)).insert(2, ':')+"</div>" );
		}
		%>
		</div>
		
	</div>
	<a id="click" class="nav-link js-scroll-trigger" href="#now"></a>
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
    $("#click").get(0).click();
    </script>
</body>
</html>



















