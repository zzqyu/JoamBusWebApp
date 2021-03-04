<%@page import="java.util.HashMap"%>
<%@ page import="joambuswebapp.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

	<%
		DBManager dbm = new DBManager("JOAMBUS");
    %>
    <%!
	    String routeItemHtml(String[] s, int type){
    		String color = StaticValue.RouteTypeToColorName(type+"").toLowerCase();
	    	String html="<a class='list-group-item list-group-item-action' href='/routeinfo?routeId="+ s[0] + "'>"+
			"<i></i>"+
			"<h3 class='routenm bg-"+color+"' style='display:inline ; '>"+s[1]+"</h3><br>"+
			"<h5 class='black' style='display:inline; '>"+s[2].replace("터미널", "").replace("만세시장", "")+"</h5>";
			if(s[5].equals("N"))
				html+="<i class='fa fa-exchange-alt black ' style='padding:0.2em'></i>";
			else
				html+="<i class='fa fa-arrow-right black ' style='padding:0.2em'></i>";
			html+="<h5 class='black' style='display:inline; '>"+s[4].split("\\(")[0].replace("터미널", "").replace("만세시장", "").replace("종점", "")+"</h5>";
			html+="<h6>"+s[3]+"</h6></a>";
					
			return html;
	    }
    %>
    <div id="siwoe" class="list-group">
    <h3 class="title-color-dark">광역버스</h3>
		<%
        	for(String[] s: dbm.mainRouteList(11))
        		out.print(routeItemHtml(s, 11));
			
		%>
	</div>
    <hr>
	<div id="sinae" class="list-group">
	<h3 class="title-color-dark">일반시내버스</h3>
		<%
			for(String[] s: dbm.mainRouteList(13)){
        		out.print(routeItemHtml(s, 13));
        	}
		%>
	</div>
    <hr>
	<div id="maeul"class="list-group">
   	<h3 class="title-color-dark">마을버스</h3>
		<%
        	for(String[] s: dbm.mainRouteList(30))
        		out.print(routeItemHtml(s, 30));
			
		%>
	</div>
</html>