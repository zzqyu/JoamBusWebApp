<%@page import="java.util.ArrayList"%>
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
    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
    
    <style>
    @import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);
	body { background-color:#192231; font-family: 'Jeju Gothic', sans-serif;}
	
	#s_name, #r_start_sta, #r_end_sta{  width:100%;  color:#333333;}#s_name,#s_mbno,#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:20%;}#r_name{  white-space:nowrap;  font-size:150%;  color:#000;  font-weight:bold;}
    .bus_List{padding:10px;}
    header { padding: 70px 0 10px;}
    .card {color:#ffffff; width: 100%; height: 7rem; }
    
    .active-pink-4 input[type=text]:focus:not([readonly]) {
	    border: 1px solid #f48fb1;
	    box-shadow: 0 0 0 1px #f48fb1;
	}
	.active-pink-3 input[type=text] {
	    border: 1px solid #f48fb1;
	    box-shadow: 0 0 0 1px #f48fb1;
	}
	.active-purple-4 input[type=text]:focus:not([readonly]) {
	    border: 1px solid #ce93d8;
	    box-shadow: 0 0 0 1px #ce93d8;
	}
	.active-purple-3 input[type=text] {
	    border: 1px solid #ce93d8;
	    box-shadow: 0 0 0 1px #ce93d8;
	}
	.active-cyan-4 input[type=text]:focus:not([readonly]) {
	    border: 1px solid #4dd0e1;
	    box-shadow: 0 0 0 1px #4dd0e1;
	}
	.active-cyan-3 input[type=text] {
	    border: 1px solid #4dd0e1;
	    box-shadow: 0 0 0 1px #4dd0e1;
	}
	.active-cyan-3 .fa, .active-cyan-4 .fa {
	    color: #4dd0e1;
	}
	.active-purple-3 .fa, .active-purple-4 .fa {
	    color: #ce93d8;
	}
	.active-pink-3 .fa, .active-pink-4 .fa {
	    color: #f48fb1;
	}
    </style>
    
</head>
<body id="page-top">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        
      </div>
    </nav>


	<%
		request.setCharacterEncoding("UTF-8");
		String keyword = request.getParameter("keyword")==null?"":new String(request.getParameter("keyword"));
		ArrayList<String[]> result = new ArrayList<String[]>();
		
		try{
			if(keyword!=null)result = StaticValue.getStationSearchResult(keyword);
			//stationId, stationName, mobileNo, regionName, districtCd, centerYN, gpsX, gpsY
		}catch(GbisException e){
			%>
			<script>
				alert("경기버스정보시스템 오류입니다. \n시간표 기능만 이용가능합니다. ");
				history.back();
			</script>
			<%
		}
		
    %>
    <%!
	    String stationItemHtml(String[] s){
	    	String answer = "<a class='list-group-item list-group-item-action' "+
	    			"href='/stationinfo?stationId="+s[0]+"&stationMbId="+s[2]+"&stationName="+s[1]+"'><table>"+
					"<tbody><tr>"+
							"<td rowspan='3'><img width='40px'"+
								"src='drawable/bus_stop.PNG'></td>"+
							"<td id='s_name'>"+s[1]+"</td>"+
						"</tr><tr><td id='s_mbno'>"+s[2]+"("+s[3]+")</td></tr></tbody></table></a>";
				return answer;
	    }
    %>
    	
    
    
    	<p style="height:60px;"/>
		
		<!-- Collapsible content -->
	    <div class="container" >
	        <!-- Search form -->
			<form class="active-cyan-4">
			    <input class="form-control form-control-sm mr-3" name="keyword" type="text" placeholder="정류장 검색" aria-label="Search"/>
			</form>
		</div>
		<div id="sinae" class="container bus_List">
			<p class="lead text-light"><%=keyword%> 검색 결과</p>
			<div class="list-group">
				<%
	        	for(String[] s: result)out.print(stationItemHtml(s));
				%>
			</div>
		</div>
	<!-- adsense -->
	<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
	<script>(adsbygoogle = window.adsbygoogle || []).push({});</script>

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