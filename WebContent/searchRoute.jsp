<%@page import="joambuswebapp.DBManager"%>
<%@page import="joambuswebapp.StaticValue"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	request.setCharacterEncoding("UTF-8");
	String keyword = request.getParameter("keyword");//노선 이름 검색 키워드
	
	//API를 통해서 노선 검색 결과 가져오기
	ArrayList<String[]> result = new ArrayList<String[]>();
	if(!keyword.toString().equals("null")) result = new DBManager("JOAMBUS").getBusSearchResult(keyword);
	//"ROUTE_ID", "ROUTE_NM", "ST_STA_NM", "ED_STA_NM", "ROUTE_TP"
	
%>
<%!
	/**
	 * @param r 노선정보
	 * @return 노선의 정보에 따른 출력해야 할 리스트 한 항목의 html
	 */
	
    String busItemHtml(String[] r){
    	String color = StaticValue.RouteTypeToColorName(r[4]+"").toLowerCase();
    	String html="<a class='list-group-item list-group-item-action' href='/routeinfo?routeId="+ r[0] + "'>"+
    			"<i></i>"+
    			"<h3 class='routenm bg-"+color+"' style='display:inline ; '>"+r[1]+"</h3><br>"+
    			"<h5 class='black' style='display:inline; '>"+r[2]+"</h5>";
    			html+="<i class='fa fa-exchange-alt black ' style='padding:0.2em'></i>";
    			html+="<h5 class='black' style='display:inline; '>"+r[3]+"</h5></a>";
    	
			return html;
    }
%>
<%
//검색결과가 있을 때 실행
if(!keyword.toString().equals("null")){%>

<div id="result" class="list-group">
    <h3 class="title-color-dark"><%=keyword%>번 검색 결과</h3>
	<%
      	for(String[] r: result)out.print(busItemHtml(r));
	%>
</div>
<%} %>