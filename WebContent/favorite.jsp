<%@page import="java.net.URLDecoder"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
/*new UpdateRouteDBThread(request).start();
new UpdateStationDBThread(request).start();*/
%>

<!DOCTYPE html>
<html>
<head>
 <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="/drawable/favicon.ico">

    <title>조암버스</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/scrolling-nav.css" rel="stylesheet">
    
    <style>
    @import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);
	body { background-color:#192231; font-family: 'Jeju Gothic', sans-serif;}
	
	#r_start_sta, #r_end_sta{font-size:90%;  width:100%;  color:#333333;}#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:12%;}#r_name{  white-space:nowrap;  font-size:120%;  color:#000;  font-weight:bold;}
    .bus_List{padding:10px 0 0 0;}
    header {
    padding: 56px 0 0px;
	}
    .card {
    color: #ffffff;
    width: 100%;
    height: 3rem;
    line-height: 0.65;
	}
	a:visited { color: #f; text-decoration: none;}
 	a:hover { color: #f; text-decoration: underline;}
 	a:focus { color: #f; text-decoration: underline;}
	.list-group-item{
	padding-top: 0.75rem;
    padding-right: 0.5rem;
    padding-bottom: 0.75rem;
    padding-left: 0.5rem;
	}
    </style>
    
</head>
<body id="page-top">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="" onclick="javascript:location.replace('/')">조암버스</a>
        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
         <div class="collapse navbar-collapse"  id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
          	<li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#busstop">정류장</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#route">노선</a>
            </li>
            
          </ul>
        </div>
      </div>
    </nav>
	<header id="menu" style="background-color: #494e6b;">
	
		
		
	<%
	/*Cookie cookie = new Cookie( "cookieName" , "cookieValue" );
	response.addCookie( cookie );*/
	
    Cookie[] cookies = request.getCookies();
    if(cookies != null){
        for(Cookie tempCookie : cookies){
        	%><p><%=tempCookie.getName()%>  <%=tempCookie.getValue()%></p>
        	<%
        }
    }
	%>
	</header>
	
	<section style="padding-top:12px;">
   	<div class="container">
   	<div class="">
		<div id="busstop" class="bus_List">
			<p class="lead text-light">정류장</p>
			<div class="list-group">
				<a class="list-group-item list-group-item-action" href="/stationinfo?stationId=233001553&stationMbId=%2036699&stationName=화수사거리">
				<div><img width="24px" src="drawable/bus_stop.PNG"><div id="r_name" style="display:inline;"> 화수사거리( 36699)</div></div>
				<p><div class="col" id="r_name" style="display:inline;">10:00</div><div style="display:inline;"><img width="24px" src="drawable/bus_red.PNG">50-1</div></p>
				<p><div class="col" id="r_name" style="display:inline;">10:00</div><div style="display:inline;"><img width="24px" src="drawable/bus_red.PNG">50-1</div></p>
				<p><div class="col" id="r_name" style="display:inline;">10:00</div><div style="display:inline;"><img width="24px" src="drawable/bus_red.PNG">50-1</div></p>
				<p><div class="col" id="r_name" style="display:inline;">10:00</div><div style="display:inline;"><img width="24px" src="drawable/bus_red.PNG">50-1</div></p>
				</a>
			</div>
		</div>
	
		<div id="route" class="bus_List">
			<p class="lead text-light">노선</p>
			<div class="list-group">
				<a class="list-group-item list-group-item-action" href="/routeinfo?routeId=233000139">
				<div><img width="24px" src="drawable/bus_red.PNG"><div id="r_name" style="display:inline;"> 8155</div> 사곡사거리-사당역</div>
				<p id="r_start_sta">사곡사거리</p>
				<p class="col" id="r_name">10:00 10:15 10:30</p>
				<p id="r_start_sta">사당역(중)</p>
				<p class="col" id="r_name">10:00 10:15 10:30</p>
				</a>
			</div>
		</div>
	
	
	</div>
	</div>
	</section>

    <!-- Footer -->
    <footer class="py-5 bg-dark">
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
    
    <script>
    $('.carousel').carousel({
      interval: 3000 //기본 5초
    })
  	</script>
  	
  </body>
</html>