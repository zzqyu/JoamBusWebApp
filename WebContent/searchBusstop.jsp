<%@page import="joambuswebapp.StaticValue"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
	request.setCharacterEncoding("UTF-8");
	String keyword = request.getParameter("keyword");//정류장 이름 검색 키워드
	
	//API를 통해서 정류장 검색 결과 가져오기
	ArrayList<String[]> result = new ArrayList<String[]>();
	if(!keyword.toString().equals("null"))result = StaticValue.getStationSearchResult(keyword);
	//stationId, stationName, mobileNo, regionName, districtCd, centerYN, gpsX, gpsY
%>
<%!
	/**
	 * @param s 정류장의 정보
	 * @return 정류장의 정보에 따른 출력해야 할 리스트 한 항목의 html
	 */
    String stationItemHtml(String[] s){
    	String answer = "<a class='list-group-item list-group-item-action' "+
    			"href='/stationinfo.jsp?stationId="+s[0]+"&stationMbId="+s[2]+"&stationName="+s[1]+"'><table>"+
				"<tbody><tr>"+
						"<td rowspan='3'><img width='40px'"+
							"src='drawable/bus_stop.PNG'></td>"+
						"<td id='s_name'>"+s[1]+"</td>"+
					"</tr><tr><td id='s_mbno'>"+s[2]+"("+s[3]+")</td></tr></tbody></table></a>";
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
       	for(String[] s: result)out.print(stationItemHtml(s));
		%>
	</div>
</div>
<%} %>
	