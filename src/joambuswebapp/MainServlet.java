package joambuswebapp;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/MainServlet")
public class MainServlet extends HttpServlet{
	
	public void init(ServletConfig config) throws ServletException{
		System.out.println("init 실행됨");
	}
	public void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		resp.setCharacterEncoding("utf-8");
		System.out.println("service 실행됨");

		PrintWriter out =resp.getWriter();
		out.print("" + 
				"<!DOCTYPE html>" + 
				"<html>" + 
				"<head>" +  
				"  <meta charset=\"UTF-8\">" + 
				"<meta name=\"robots\" content=\"noindex\">" + 
				"  <meta name=\"viewport\" content=\"width=device-width\">" + 
				"  <title>조암버스:홈</title>" + 
				"<link rel=\"shortcut icon\" href=\"/drawable/favicon.ico\">" + 
				"<style id=\"jsbin-css\">" + 
				"@import url(//fonts.googleapis.com/earlyaccess/jejugothic.css);\r\n" + 
				"body { font-family: 'Jeju Gothic', sans-serif;}"+
				"ul{" + 
				"  list-style:none;" + 
				"  padding-left:0px;" + 
				"  background-color:#cccccc;" + 
				"  " + 
				"}" + 
				"li:hover{" + 
				"  background-color:#ffbdbd;" + 
				"}" + 
				"li{" + 
				"  margin-bottom:1px;" + 
				"  background-color:#ffffff;" + 
				"}" + 
				"a{" + 
				"  text-decoration:none;" + 
				"}" + 
				"#r_start_sta, #r_end_sta{" + 
				"  width:100%;" +  
				"  color:#333333;" + 
				"}" + 
				"#r_start_sta{" + 
				"  padding-left:8px;" + 
				"}" + 
				"#r_end_sta{" + 
				"  padding-left:20%;" + 
				"}" + 
				"#r_name{" + 
				"  white-space:nowrap;"+
				"  font-size:150%;" + 
				"  color:#000;" + 
				"  font-weight:bold;" + 
				"}" + 
				"</style>" + 
				"</head>" + 
				"<body>"+
				"<div style=\"position:fixed;top:0px;left:0px;background-color:#ec6778;width:100%; height:55px;\" >\r\n" + 
				"<p style=\"margin-top:18px; display:block;text-align:center; color:white; font-size:130%;\">조암버스</p>\r\n" + 
				"<a href=\"appfile/hompageinfo.html\" style=\"position:absolute;top:18px; left:10px;\"><img src=\"/drawable/info.png\"/></a>\r\n" + 
				"<a href=\"appfile/buspay.html\" style=\"position:absolute;top:18px;right:10px;\"><img src=\"/drawable/pay.png\"/></a>\r\n" + 
				"</div>\r\n" + 
				"<div style=\"position: static;padding-top:58px;padding-bottom:58px;\">"+
				"<ul>");
		try {
			DBManager dbm = new DBManager(StaticValue.JOAMBUS_DB_NAME); 
			String[] tags =  StaticValue.MAIN_SERVLET_TABLE_TAGS;
			ArrayList<HashMap<String, String>> routeItemList=dbm.getDBDataList(StaticValue.ROUTE_INFO_TABLE_NAME, tags, tags[0], false, null, null);
			routeItemList.sort((x, y) -> new Float (Float.parseFloat(x.get("routeName").replace('-', '.').replaceAll("[^0-9.]", "")))
		            .compareTo(Float.parseFloat(y.get("routeName").replace('-', '.').replaceAll("[^0-9.]", ""))));
			/*
			for (HashMap<String, String> row:answer) {
				for(String tag: tags) 
					System.out.print(row.get(tag)+"\t");
				System.out.println();
			}
			ArrayList<RouteInfoItem> routeItemList =  StaticValue.getRouteInfoItem(StaticValue.routeLocalization(), req);*/
			out.print("<p>");
			for (HashMap<String, String> row:routeItemList) {
				String direction = "<=>";
				if (row.get("isOneWay").equals("Y")) direction = "=>";
				
				out.print("<li>\r\n" + 
						"      <a href=\"routeinfo?routeId="+row.get("routeId")+"\">\r\n" + 
						"      <table>\r\n" + 
						"        <tr>\r\n" + //https://joambusapp.azurewebsites.net/
						"          <td rowspan=2><img width=\"40px\"src=\"drawable/bus_"+
						StaticValue.RouteTypeToColorName(row.get("routeTypeCd")).toLowerCase()+".PNG\"/></td>\r\n" + 
						"          <td rowspan=2 id=\"r_name\">"+row.get("routeName")+"</td>\r\n" + 
						"          <td id=\"r_start_sta\">"+row.get("startStationName").split("[.(]")[0]+direction+row.get("middleStationName").split("[.(]")[0]+"</td>\r\n" + 
						"        </tr>\r\n" + 
						"        <tr>\r\n" + 
						"          <td id=\"r_end_sta\">"+direction+row.get("endStationName").split("[.(]")[0]+"</td>\r\n" + 
						"        </tr>\r\n" + 
						"      </table>\r\n" + 
						"      </a>\r\n" + 
						"    </li>");
				
			}
			/*
			for(RouteInfoItem routeItem:routeItemList) {
				//System.out.println("routeId :"+ s.getRouteId());
				//https://joambusapp.azurewebsites.net
				out.print("<li>\r\n" + 
						"      <a href=\"routeinfo?routeId="+routeItem.getRouteId()+"\">\r\n" + 
						"      <table>\r\n" + 
						"        <tr>\r\n" + //https://joambusapp.azurewebsites.net/
						"          <td rowspan=2><img width=\"40px\"src=\"drawable/bus_"+
						StaticValue.RouteTypeToColorName(routeItem.getRouteTypeCd()).toLowerCase()+".PNG\"/></td>\r\n" + 
						"          <td rowspan=2 id=\"r_name\">"+routeItem.getRouteName()+"</td>\r\n" + 
						"          <td id=\"r_start_sta\">"+routeItem.getStartStationName()+"</td>\r\n" + 
						"        </tr>\r\n" + 
						"        <tr>\r\n" + 
						"          <td id=\"r_end_sta\"><-> "+routeItem.getEndStationName()+"</td>\r\n" + 
						"        </tr>\r\n" + 
						"      </table>\r\n" + 
						"      </a>\r\n" + 
						"    </li>");
				
			}
		*/
			out.print("</p>");
			out.print("</ul>" +"</div>"+StaticValue.AD+"</body>" + 
					"</html>");
		} catch(Exception e) {
			e.printStackTrace();
			resp.sendRedirect("/error.html");
			return ;
		}
	}
}
