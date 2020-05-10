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
<style>
@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);
body {
 font-family: 'Jeju Gothic', sans-serif;
 background-color:#192231;
	color:#fff;
	line-height: 2.5em;
}

</style>

</head>
<body>
<!-- Navigation -->
   
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #985e6d;" id="mainNav">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="/" >조암버스</a>
        <p style="text-align:center; color:white; font-size:121%;margin-bottom:0;margin-right:0;"\>홈페이지 정보</p>
        <div class="" id="navbarSupportedContent"></div>
      </div>
    </nav>    
    
<div class="container" style="position: static;padding-top:72px">
	<ul>
		<li>제작자 : 김정규</li>
		<li><a href="https://www.facebook.com/joambusapp/">조암버스 페이스북 페이지</a></li>
		<li>본 홈페이지는 개인이 만든 홈페이지로 조암버스터미널과 경진여객과 관계가 없습니다.</li>
		<li><u>사용 플랫폼 및 API</u></li>
		<li>&ensp;&ensp;* 경기도 버스정보시스템(GBIS) API</li>
		<li>&ensp;&ensp;* Java 11 (Language)</li>
		<li>&ensp;&ensp;* Apache Tomcat® 9 (Web Server)</li>
		<li>&ensp;&ensp;* Microsoft Azure (Web Server)</li>
		<li>&ensp;&ensp;* Aws (Database Server)</li>
		<li>&ensp;&ensp;* MySQL (Database)</li>
	</ul>
</div>
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