package joambuswebapp;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;


public class MakeXml {
	String s = System.getProperty("user.dir");
	ArrayList<String> routeList;
	String originePath = s+"/webapps/ROOT/";
	public MakeXml() throws Exception {
		init();
	}
	public void init() throws Exception {
		routeList = StaticValue.routeLocalization();
		saveFileInServerRouteId("appfile/", "routeList", routeList);
		for(String routeId: routeList) {
			ArrayList<BusRouteStation> rs = BusRouteStation.getRouteStationList(routeId);
			saveFileInServerBusRouteStation("routestation/", routeId);
		}
	}
	
	public void saveFileInServerRouteId(String path, String fileName, ArrayList<String> routeIds) throws IOException {
		File file = new File(originePath+path);
		if (!file.exists()) {
			// 디렉토리 생성 메서드
			file.mkdirs();
			System.out.println("created directory successfully!");
		}
		BufferedWriter out = new BufferedWriter(new FileWriter(originePath+path+fileName + ".xml"));
		System.out.println("Save: "+originePath+path+fileName + ".xml");
		out.write("<?xml version='1.0' encoding='utf-8'?>");
		out.newLine();
		out.write("<body>");
		out.newLine();
		for (String routeId : routeIds) {
			out.write("<routeId>" + routeId + "</routeId>");
			out.newLine();
		}
		out.write("</body>");
		out.newLine();
		out.close();
	}
	public void saveFileInServerBusRouteStation(String path, String routeId) throws Exception {
		File file = new File(originePath+path);
		if (!file.exists()) {
			// 디렉토리 생성 메서드
			file.mkdirs();
			System.out.println("created directory successfully!");
		}
		BufferedWriter out = new BufferedWriter(new FileWriter(originePath+path+routeId + ".xml"));
		System.out.println("Save: "+originePath+path+routeId + ".xml");
		String u = StaticValue.URL + StaticValue.URL_GET_BUS_ROUTE_STATION_LIST + StaticValue.SERVICE_KEY + "&routeId="
				+ routeId;
		URL url = new URL(u);
		URLConnection connection = url.openConnection();
		Document doc = StaticValue.parseXML(connection.getInputStream());
		TransformerFactory tf = TransformerFactory.newInstance();
		Transformer trans = tf.newTransformer();
		StringWriter sw = new StringWriter();
		trans.transform(new DOMSource(doc), new StreamResult(sw));
		out.write(sw.toString());
		out.newLine();
		out.close();
	}
}
