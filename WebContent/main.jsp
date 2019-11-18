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
	
	#r_start_sta, #r_end_sta{font-size:90%;  width:100%;  color:#333333;}#r_start_sta{  padding-left:8px;}#r_end_sta{  padding-left:12%;}#r_name{  white-space:nowrap;  font-size:130%;  color:#000;  font-weight:bold;}
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

    </style>
    
</head>
<body id="page-top">

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
         <div class="collapse navbar-collapse"  id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
          	<li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#menu">메뉴</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#siwoe">광역버스</a>
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
		<%
		boolean isMobile = false;
		String agent = request.getHeader("USER-AGENT");
		String[] mobileos = {"iPhone","iPod","Android","BlackBerry","Windows CE","Nokia","Webos","Opera Mini","SonyEricsson","Opera Mobi","IEMobile"};
		int j = -1;
		for(int i=0 ; i<mobileos.length ; i++) {
			j=agent.indexOf(mobileos[i]);
			if(j > -1 ){
				isMobile = true;
				break;
			}
		}
		if(isMobile){ %>
	    <div class="bd-example">
			<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
			  <ol class="carousel-indicators">
			    <li data-target="#carouselExampleIndicators" data-slide-to="0" class=""></li>
			    <li data-target="#carouselExampleIndicators" data-slide-to="1" class=""></li>
			    <li data-target="#carouselExampleIndicators" data-slide-to="2" class="active"></li>
			  </ol>
			  <div class="carousel-inner">
			    <div class="carousel-item">
			    <a href="https://m.search.naver.com/search.naver?display=15&page=2&query=%EC%A1%B0%EC%95%94%EB%B2%84%EC%8A%A4&sm=mtb_pge&start=1&where=m">
			      <img class="d-block w-100"  src="drawable/banner1.jpg" data-holder-rendered="true">
			      </a>
			    </div>
			    <div class="carousel-item">
			    	<a href="https://play.google.com/store/apps/details?id=com.dolapps.jbapp">
			      <img class="d-block w-100"  src="drawable/banner2.jpg" data-holder-rendered="true">
			      </a>
			    </div>
			    <div class="carousel-item active">
			    	<a href="https://play.google.com/store/apps/details?id=com.dolapps.bank_noti_widget">
			      <img class="d-block w-100"  src="drawable/banner3.jpg" data-holder-rendered="true">
			      </a>
			    </div>
			    
			  </div>
			  <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
			    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
			    <span class="sr-only">Previous</span>
			  </a>
			  <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
			    <span class="carousel-control-next-icon" aria-hidden="true"></span>
			    <span class="sr-only">Next</span>
			  </a>
			</div>
		</div>	
		<%}else{ %>
	    <%} %>
		
		  
	
		<div class="container text-white text-center">
			<div class="row" style="padding: 10px;">
				<a href="/buspay.jsp" class="card bg-dark col-6 col-sm-3">
					<br><br>버스 요금표
				</a>
				<a href="/" class="card bg-dark col-6 col-sm-3">
					<br><br>
				</a>
				<a href="/terminalinfo.jsp" class="card bg-dark col-6 col-sm-3">
					<br> <br>터미널 정보
				</a>
				<a href="/hompageinfo.jsp"
					class="card bg-dark col-6 col-sm-3"><br> <br>홈페이지 정보</a>
			</div>
		</div>
		
	</header>
	
	<%
	//변수 선언
	request.setCharacterEncoding("UTF-8");
	//검색 타입
	String type = request.getParameter("type");
	//검색 타입 안내 텍스트 
	String typeText = type==null?"검색 유형;을 선택하세요(정류장/노선)":(type.equals("s")?"정류장 검색;":type.equals("r")?"노선 검색;":"검색 유형;");
	//검색 키워드
	String keyword = request.getParameter("keyword")==null?null:new String(URLDecoder.decode(request.getParameter("keyword"), "UTF-8"));
	//검색 유형에 따른 호출할 include jsp명
	String jsp = type==null?"jRouteList.jsp":(type.equals("s")?"searchBusstop.jsp":type.equals("r")?"searchRoute.jsp":null);
	if(keyword==null||keyword.equals(""))jsp = "jRouteList.jsp";
	%>
	
	<section style="padding-top:12px;">
   	<div class="container">
   	
	   	<div id="searchArea" >
	   		
		    <div class="input-group">
				<div class="input-group-btn">
					<button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<%=typeText.split(";")[0]%>
					</button>
					<div class="dropdown-menu">
						<a class="dropdown-item" href="?type=r">노선 검색</a>
						<a class="dropdown-item" href="?type=s">정류장 검색</a>
					</div>
				</div>
				<input class="form-control form-control-sm" name="keyword" type="text" placeholder="<%=typeText.replace(";", "")%>" aria-label="Search"
				<%if(type!=null){ %>onkeydown="JavaScript:Enter_Check(this.value);"<%} %>
				/>
			</div>
	  	</div>
	  	
		
		<%
		//검색 유형에 대한 검색키워드가 입력이 되면 그에 따른 검색 결과를 처리하는 jsp를 include를 통해 출력한다. 
		if (jsp!=null){
		%>
		<jsp:include page="<%=jsp%>" flush="true">
		    <jsp:param name="keyword" value="<%=keyword%>"/>
		</jsp:include>
		<%
		}
		%>
	
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
  	
  	<script type="text/javascript">

  //검색 기능 호출 함수
    function Enter_Check(keyword){
        // 엔터키의 코드는 13입니다.
	    if(event.keyCode == 13){
	    	window.open("?type=<%=type%>&keyword="+ encodeURI(encodeURIComponent(keyword)),"_self")
	    }
	}
</script>

  </body>
</html>