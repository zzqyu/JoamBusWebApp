<%@page import="java.net.URLDecoder"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
							<h5>제작자 : 김정규</h5><br>
							<h5><a href="https://www.facebook.com/joambusapp/" ><i class="icon brands style fa-facebook-f"></i><span class="label"> 조암버스 페이스북</span></a></h5><br>
							<h5><a href="mailto:wjdrb0626@naver.com" class="fa fa-envelope"><span class="label"> Email: wjdrb0626@naver.com</span></a></h5><br>
							<h5>본 홈페이지는 개인이 만든 홈페이지로 조암버스터미널과 경진여객과 관계가 없습니다.</h5><br>
							<h5><u>사용 플랫폼 및 API</u></h5>
							<h5>&ensp;&ensp;* 경기도 버스정보시스템(GBIS) API</h5>
							<h5>&ensp;&ensp;* <i class="fa fa-java"></i> Java 15 (Language)</h5>
							<h5>&ensp;&ensp;* Apache Tomcat® 9 (Web Server)</h5>
							<h5>&ensp;&ensp;* <i class="fa fa-microsoft"></i> Microsoft Azure (Web Server)</h5>
							<h5>&ensp;&ensp;* <i class="fa fa-database"></i> MySQL (Database)</h5>
						</div>
						
						<div class="image item-center image-new" id="c_left" style="background-color: #fee9d4; text-align:left">
							<div class="content"  >
								<h1><a class="title-color-dark" href="/main" >조암버스</a></h1>
								<br>
								<h3 class="title-color-dark">홈페이지 안내</h3>
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