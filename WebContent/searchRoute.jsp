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
    	String answer = "<a class='list-group-item list-group-item-action' "+
    			"href='/routeinfo.jsp?routeId="+r[0]+"'><table>"+
				"<tbody><tr>"+
						"<td rowspan='3'><img width='40px'"+
								"src='drawable/bus_"+StaticValue.RouteTypeToColorName(r[4]+"").toLowerCase()+".PNG'></td>"+
						"<td id='s_name'>"+r[1]+"</td>"+
					"</tr><tr><td id='s_mbno'>"+r[2]+"-"+r[3]+"</td></tr></tbody></table></a>";
			return answer;
    }
%>
<%
//검색결과가 있을 때 실행
if(!keyword.toString().equals("null")){%>

<div id="result" class="bus_List">
	<p class="lead text-light"> <%=keyword%> 검색 결과 </p>
	<div class="list-group">
		<%
       	for(String[] r: result)out.print(busItemHtml(r));
		%>
	</div>
</div>
<%} %>