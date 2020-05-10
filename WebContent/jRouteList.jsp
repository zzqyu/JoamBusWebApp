<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
</head>
<body>

	<%
		DBManager dbm = new DBManager("JOAMBUS");
    %>
    <%!
	    String routeItemHtml(String[] s, int type){
	    	String answer = "<a class='list-group-item list-group-item-action' href='/routeinfo?routeId="+ s[0] + "'>"
					+"<table><tbody><tr>"
					+"<td rowspan='2'><img width='32px'"
					+"		src='drawable/bus_"+StaticValue.RouteTypeToColorName(type+"").toLowerCase()+".PNG'></td>"
					+"	<td rowspan='2' id='r_name'>"+s[1]+"</td>"
					+"	<td id='r_start_sta'>"+s[2].replace("터미널", "").replace("만세시장", "");
					if(s[5].equals("N")) answer+="&lt;";
					answer+="=&gt;"+s[3]+"</td></tr><tr>"
					+"	<td id='r_end_sta'>";
					if(s[5].equals("N"))answer+="&lt;";
					answer+="=&gt;"+s[4].replace("터미널", "").replace("만세시장", "")+"</td></tr></tbody></table></a>";
				return answer;
	    }
    %>
    <div class="">
		<div id="siwoe" class="bus_List">
			<p class="lead text-light">광역버스</p>
			<div class="list-group">
				<%
	        	for(String[] s: dbm.mainRouteList(11))
	        		out.print(routeItemHtml(s, 11));
				
				%>
			</div>
		</div>
	
		<div id="sinae" class="bus_List">
			<p class="lead text-light">시내버스</p>
			<div class="list-group">
				<%
	        	for(String[] s: dbm.mainRouteList(13))
	        		out.print(routeItemHtml(s, 13));
				%>
			</div>
		</div>
	
	
		<div id="maeul"class="bus_List">
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
	</div>
  </body>
</html>