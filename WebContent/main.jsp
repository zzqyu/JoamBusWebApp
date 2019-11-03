<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
 <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>조암버스</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/scrolling-nav.css" rel="stylesheet">
    
    <style>
    @import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);
	body { background-color:#192231; font-family: 'Jeju Gothic', sans-serif;}
	
	#r_start_sta, #r_end_sta{font-size:90%;  width:100%;  color:#333333;}#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:12%;}#r_name{  white-space:nowrap;  font-size:130%;  color:#000;  font-weight:bold;}
    .bus_List{padding:10px;}
    header { padding: 70px 0 10px;}
    .card {color:#ffffff; width: 100%; height: 7rem; }
	a:visited { color: #f; text-decoration: none;}
 	a:hover { color: #f; text-decoration: underline;}
 	a:focus { color: #f; text-decoration: underline;}

    </style>
    
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-6154865008873271",
    enable_page_level_ads: true
  });
</script>
    
</head>
<body id="page-top">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">조암버스</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
          	<li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#menu">메뉴</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#siwoe">광역/시외버스</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#sinae">시내버스</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#maeul">마을/따복버스</a>
            </li>
            
            
          </ul>
        </div>
      </div>
    </nav>

	<header id="menu" style="background-color: #494e6b;">

		<div class="container text-white text-center">
			<div class="row" style="padding: 10px;">
				<a href="/appfile/buspay.html" class="card bg-dark col-6 col-sm-3">
					<br><br>버스 요금표
				</a>
				<a href="/searchBusstop" class="card bg-dark col-6 col-sm-3">
					<br><br>정류장검색
				</a>
				<a href="/appfile/terminalinfo.html" class="card bg-dark col-6 col-sm-3">
					<br> <br>터미널 정보
				</a>
				<a href="/appfile/hompageinfo.html"
					class="card bg-dark col-6 col-sm-3"><br> <br>홈페이지 정보</a>
			</div>
		</div>
	</header>


	<%
		DBManager dbm = new DBManager("JOAMBUS");
    %>
    <%!
	    String routeItemHtml(String[] s, int type){
	    	String answer = "<a class='list-group-item list-group-item-action' href='/routeinfo?routeId="+ s[0] + "'>"
					+"<table><tbody><tr>"
					+"<td rowspan='2'><img width='40px'"
					+"		src='drawable/bus_"+StaticValue.RouteTypeToColorName(type+"").toLowerCase()+".PNG'></td>"
					+"	<td rowspan='2' id='r_name'>"+s[1]+"</td>"
					+"	<td id='r_start_sta'>"+s[2];
					if(s[5].equals("N")) answer+="&lt;";
					answer+="=&gt;"+s[3]+"</td></tr><tr>"
					+"	<td id='r_end_sta'>";
					if(s[5].equals("N"))answer+="&lt;";
					answer+="=&gt;"+s[4]+"</td></tr></tbody></table></a>";
				return answer;
	    }
    %>
		<div id="siwoe" class="container bus_List">
			<p class="lead text-light">광역/시외버스</p>
			<div class="list-group">
				<%
	        	for(String[] s: dbm.mainRouteList(11))
	        		out.print(routeItemHtml(s, 11));
				
	        	for(String[] s: dbm.mainRouteList(43))
	        		out.print(routeItemHtml(s, 43));
				%>
			</div>
		</div>
	
		<div id="sinae" class="container bus_List">
			<p class="lead text-light">시내버스</p>
			<div class="list-group">
				<%
	        	for(String[] s: dbm.mainRouteList(13))
	        		out.print(routeItemHtml(s, 13));
				%>
			</div>
		</div>
	
	
		<div id="maeul"class="container bus_List">
			<p class="lead text-light">마을/따복버스</p>
			<div class="list-group">
				<%
	        	for(String[] s: dbm.mainRouteList(15))
	        		out.print(routeItemHtml(s, 15));
				
	        	for(String[] s: dbm.mainRouteList(30))
	        		out.print(routeItemHtml(s, 30));
				%>
			</div>
		</div>

	<!-- adsense -->
	<script //async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
	<script>//(adsbygoogle = window.adsbygoogle || []).push({});</script>

    <!-- Footer -->
    <footer class="py-5 bg-dark" >
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; Joam Bus Web App 2018</p>
      </div>
      <ins class="adsbygoogle"
			style="display: inline-block; width: 728px; height: 90px"
			data-ad-client="ca-pub-6154865008873271" data-ad-slot="1234567890"></ins>
      <div style="padding-bottom:50px;"></div>
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

  </body>
</html>