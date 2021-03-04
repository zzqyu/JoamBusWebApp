<%@page import="java.net.URLDecoder"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
    <%
	String table[][][] = {
			{
				{"구분" ,"<i class='fa fa-user-tie'></i> 성인", "<i class='fa fa-school'></i> 청소년", "<i class='fa fa-child'></i> 어린이"},
				{"<i class='fa fa-money-bill-alt'></i> 현금" ,"2900", "2000", "2000"},
				{"<i class='fa fa-credit-card'></i> 카드" ,"2800", "1960", "1960"},
				{"<i class='fa fa-sun'></i> 조조(카드)" ,"2400", "1680", "1680"}
			},
			{
				{"구분" ,"<i class='fa fa-user-tie'></i> 성인", "<i class='fa fa-school'></i> 청소년", "<i class='fa fa-child'></i> 어린이"},
				{"<i class='fa fa-money-bill-alt'></i> 현금" ,"1500", "1100", "800"},
				{"<i class='fa fa-credit-card'></i> 카드" ,"1450", "1010", "730"},
				{"<i class='fa fa-sun'></i> 조조(카드)" ,"1250", "870", "630"}
			},
			{
				{"구분" ,"<i class='fa fa-user-tie'></i> 성인", "<i class='fa fa-school'></i> 청소년", "<i class='fa fa-child'></i> 어린이"},
				{"<i class='fa fa-money-bill-alt'></i> 현금" ,"1400", "1000", "700"},
				{"<i class='fa fa-credit-card'></i> 카드" ,"1350", "950", "680"},
				{"<i class='fa fa-sun'></i> 조조(카드)" ,"-", "-", "-"}
			}
	};
    String colors[] = {"red", "green", "yellow"};
    String buses[] = {"광역버스", "일반시내버스", "마을버스"};
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
							<a href="http://www.kjbus.co.kr">운영사 : 경진여객 운수</a>
							<a href="tel:031-351-8185">전화번호 : 031-351-8185</a>
							주소 : 경기도 화성시 우정읍 조암남로 3-4 (조암리 340-12)
							<iframe
									src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3182.968715747782!2d126.81360381529791!3d37.08205197989147!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357b105c94e342f7%3A0xeec52a2a13f9086f!2z7KGw7JWU7YSw66-464SQ!5e0!3m2!1sen!2skr!4v1536719100158"
									width="400" height="300" frameborder="0" style="border: 0"
									allowfullscreen></iframe>
									
							<hr>
							<a href="https://www.hsuco.or.kr/www/M040000/M040800/M0408001.jsp">운영사 : 화성도시공사</a>
							<a href="tel:031-353-0662">전화번호 : 031-353-0662</a>
						</div>
						
						<div class="image item-center image-new" id="c_left" style="background-color: #fee9d4; text-align:left">
							<div class="content"  >
								<h1><a class="title-color-dark" href="/main" >조암버스</a></h1>
								<br>
								<h3 class="title-color-dark">운수사 안내</h3>
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