<%@page import="java.net.URLDecoder"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
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
											
						<div class="content content-new" id="c1"  >
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
						
						<div class="image item-center image-new" id="c_left" style="background-color: #fee9d4; text-align:left">
							<div class="content"  style="width: 100%;padding:1.5rem;">
							<h1><a class="title-color-dark" href="/main" >조암버스</a></h1>
							<br>
							<h5 class="title-color-dark">화성시 우정읍·장안면 지역 버스 안내</h5>
							<br>
							<form method="post" action="">
								<label class="title-color-dark">검색</label>
								<div class="padding-bottom-device" >
									<select class="no-border bt-dark"  name="type" id="type" style="float: left;width:30%;">
										<option value="">검색 유형</option>
										<option value="r">노선</option>
										<option value="s">정류장</option>
										</select>
									<input class="no-border" style="background-color:#fffcf7; float: left;width:70%;" type="text" name="keyword" id="keyword" value="" placeholder="검색 유형 선택 후, 검색어를 입력하세요.">
								</div>
							</form>
							<ul class="actions">
								<li><a href="/buspay.jsp" class="button fit bt-dark no-box-shadow" >버스 요금</a></li>
								<li><a href="/terminalinfo.jsp" class="button fit bt-dark no-box-shadow">운수사 정보</a></li>
								<li><a href="/hompageinfo.jsp" class="button fit bt-dark no-box-shadow">홈페이지 정보</a></li>
							</ul>
							</div>
						</div>
					</section>

				<!-- Footer -->
				<jsp:include page="footer.jsp" flush="true"></jsp:include>

			</div>
			
			<!-- Scripts -->
			<jsp:include page="js.jsp" flush="true"></jsp:include>
	</body>
</html>