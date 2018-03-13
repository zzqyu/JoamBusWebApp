package joambuswebapp;


import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class BusRouteStation {
	private String centerYn; // 중앙차로 여부
	private String mobileNo; // 정류장 모바일번호
	private String regionName; // 지역이름
	private String stationId; // 정류장 ID
	private String stationName; // 정류장 이름
	private String gpsX; // 좌표
	private String gpsY;
	private String stationSeq;// 정류장순서
	private String turnYn; // 반환점 여부

	public BusRouteStation(String centerYn, String mobileNo, String regionName, String stationId, String stationName,
			String gpsX, String gpsY, String stationSeq, String turnYn) {
		this.centerYn = centerYn;
		this.mobileNo = mobileNo;
		this.regionName = regionName;
		this.stationId = stationId;
		this.stationName = stationName;
		this.gpsX = gpsX;
		this.gpsY = gpsY;
		this.stationSeq = stationSeq;
		this.turnYn = turnYn;
	}

	public String getCenterYn() {
		return centerYn;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public String getRegionName() {
		return regionName;
	}

	public String getStationId() {
		return stationId;
	}

	public String getStationName() {
		return stationName;
	}

	public String getGpsX() {
		return gpsX;
	}

	public String getGpsY() {
		return gpsY;
	}

	public String getStationSeq() {
		return stationSeq;
	}

	public String getTurnYn() {
		return turnYn;
	}
	public String toString() {
		return  centerYn + "\t" +
		 mobileNo + "\t" +
		 regionName+ "\t" +
		 stationId+ "\t" +
		 stationName+ "\t" +
		 gpsX+ "\t" +
		 gpsY+ "\t" +
		 stationSeq+ "\t" +
		 turnYn+ "\t";
	}

	public static ArrayList<BusRouteStation> getRouteStationList(String routeId) throws Exception {
		ArrayList<BusRouteStation> result = new ArrayList<BusRouteStation>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_ROUTE_STATION_LIST + StaticValue.SERVICE_KEY + "&routeId="
				+ routeId;
		URL url = new URL(u);
		URLConnection connection = url.openConnection();
		Document doc = StaticValue.parseXML(connection.getInputStream());
		NodeList descNodes = doc.getElementsByTagName("busRouteStationList");
		for (int i = 0; i < descNodes.getLength(); i++) {
			String centerYn = null;
			String mobileNo = null;
			String regionName= null;
			String stationId= null;
			String stationName= null;
			String gpsX= null;
			String gpsY= null;
			String stationSeq= null;
			String turnYn= null;

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				switch (node.getNodeName()) {

				case "centerYn":
					centerYn = node.getTextContent();
					break;
				case "mobileNo":
					mobileNo = node.getTextContent();
					break;
				case "regionName":
					regionName = node.getTextContent();
					break;
				case "stationId":
					stationId = node.getTextContent();
					break;
				case "stationName":
					stationName = node.getTextContent();
					break;
				case "gpsX":
					gpsX = node.getTextContent();
					break;
				case "gpsY":
					gpsY = node.getTextContent();
					break;
				case "stationSeq":
					stationSeq = node.getTextContent();
					break;
				case "turnYn":
					turnYn = node.getTextContent();
					break;

				}

			}
			result.add(new BusRouteStation(centerYn, mobileNo, regionName, stationId, stationName, gpsX, gpsY,
					stationSeq, turnYn));
		}

		return result;
	}

}
