<%@page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>조암버스</title>
  <link rel="shortcut icon" href="/drawable/favicon.ico">
  <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/scrolling-nav.css" rel="stylesheet">
<style id="jsbin-css">
@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);

body {
	font-family: 'Jeju Gothic', sans-serif;
	color: #333333;
	background-color:#192231;
	font-size: 10pt;
	margin:0px;
	line-height: 2.5em;
}
.list-group-item{
	width: 100%;
	height: 54px;
	text-align: center;
}
table{
width:100%;
padding:0px;
}
td {
	width: 150px;
	text-align: center;
}
/*css로는 스타일일 일괄적으로 정할 수 있다*/
#stit {
	font-size: 16pt;
}

header {  
	margin-top:20px;  
	padding-top:0px;  
	padding-bottom: 5px;  
	padding-left: 7px;  
    font-size: 100%;  
	height:32px;  
	line-height: 2.5em; 
	background-color: #F7E7D6;  
	color:#ec6778;  
} 

</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/">조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:75px;"\>버스요금표</p>
	    <div class="" id="navbarSupportedContent"></div>
      </div>
    </nav>  
	<div class="container" style="position: static;padding-top:72px">
	
	<header id=header><p>광역/직행버스(빨강)</p></header>
	<a class='list-group-item list-group-item-action' >
	<table  border=0 align="center">
		<tr>
			<td>구분</td>
			<td>성인</td>
			<td>청소년</td>
			<td>어린이</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>현금</td>
			<td>2900</td>
			<td>2000</td>
			<td>2000</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>카드</td>
			<td>2800</td>
			<td>1960</td>
			<td>1960</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>조조(카드)</td>
			<td>2400</td>
			<td>1560</td>
			<td>1560</td>
		</tr>
	</table></a>
	
	<header id=header><p>시내버스(초록)</p></header>
	<a class='list-group-item list-group-item-action' >
	<table  border=0 align="center">
		<tr>
			<td>구분</td>
			<td>성인</td>
			<td>청소년</td>
			<td>어린이</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>현금</td>
			<td>1500</td>
			<td>1100</td>
			<td>800</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>카드</td>
			<td>1450</td>
			<td>1010</td>
			<td>730</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>조조(카드)</td>
			<td>1250</td>
			<td>810</td>
			<td>530</td>
		</tr>
	</table></a>
	
	<header id=header><p>마을버스(노랑)</p></header>
	<a class='list-group-item list-group-item-action' >
	<table  border=0 align="center">
		<tr>
			<td>구분</td>
			<td>성인</td>
			<td>청소년</td>
			<td>어린이</td>
		</tr>
	</table></a>
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>현금</td>
			<td>1250</td>
			<td>900</td>
			<td>600</td>
		</tr>
		
	</table></a>
	
	<a class='list-group-item list-group-item-action' ><table  border=0 align="center">
		<tr>
			<td>카드</td>
			<td>1150</td>
			<td>810</td>
			<td>580</td>
		</tr>
	</table></a>
	
		
	</div><%=StaticValue.AD%>
	
 <!-- Bootstrap core JavaScript -->
 <script src="vendor/jquery/jquery.min.js"></script>
 <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

 <!-- Plugin JavaScript -->
 <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

 <!-- Custom JavaScript for this theme -->
 <script src="js/scrolling-nav.js"></script>
 </body>
</html>