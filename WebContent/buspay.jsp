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
						<%for(int n = 0 ; n < 3; n++){ %>
							<h3 class=' routenm bg-<%=colors[n] %>' style='display:inline ; width:180px;'><%=buses[n]%></h3>
							<div class="table-wrapper">
								<table class="alt">
									<thead>
										<tr>
										<%for(int j = 0 ; j < 4; j++){ %>
											<th><%=table[n][0][j] %></th>
										<%} %>
										</tr>
									</thead>
									<tbody>
										<%for(int i = 1 ; i <= 3; i++){ %>
										<tr>
											<%for(int j = 0 ; j < 4; j++){ %>
											<td><%=table[n][i][j] %></td>
											<%} %>
										</tr>
										<%} %>
									</tbody>
								</table>
							</div>
							<hr>
							<%} %>
						</div>
						
						<div class="image item-center image-new" id="c_left" style="background-color: #fee9d4; text-align:left">
							<div class="content"  >
								<h1><a class="title-color-dark" href="/main" >조암버스</a></h1>
								<br>
								<h3 class="title-color-dark">버스 요금 안내</h3>
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