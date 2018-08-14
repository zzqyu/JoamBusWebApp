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
	
	#r_start_sta, #r_end_sta{  width:100%;  color:#333333;}#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:20%;}#r_name{  white-space:nowrap;  font-size:150%;  color:#000;  font-weight:bold;}
    .bus_List{padding:10px;}
    header { padding: 70px 0 10px;}
    .card {color:#ffffff; width: 100%; height: 7rem; }
    </style>
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
        <div class="row" style="padding:10px;">
		    <div class="card bg-dark col-sm-6 col-lg-3" ><br><br>버스 요금표</div>
		    <div class="card bg-dark text-gray col-sm-6 col-lg-3" ><br><br>정류장검색<br>-추후기능제공-</div>
		    <div class="card bg-dark col-sm-6 col-lg-3" ><br><br>터미널 정보</div>
		    <div class="card bg-dark col-sm-6 col-lg-3" ><br><br>홈페이지 정보</div>
		</div>
      </div>
    </header>
    
    
    <%
		DBManager dbm = new DBManager("JOAMBUS");
    %>
    <%!
	    String routeItemHtml(String[] s, int type){
	    	String answer = "<a class='list-group-item list-group-item-action' href='https://joambusapp.azurewebsites.net/routeinfo?routeId="+ s[0] + "'>"
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



    <!-- Footer -->
    <footer class="py-5 bg-dark" >
      <div class="container">
        <p class="m-0 text-center text-white">Copyright &copy; Joam Bus Web App 2018</p>
      </div>
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