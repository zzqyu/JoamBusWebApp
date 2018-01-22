package joambuswebapp;


import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class BusLocation {
	private String endBus; // 막차 여부
	private String lowPlate; // 저상 여부
	private String plateNo; // 차량 번호
	private String plateType; // 차량유형 >0:정보없음1:소형승합차2:중형승합차3:대형승합차4:2층버스
	private String remainSeatCnt; // 남은 좌석 수
	private String routeId; // 노선 ID
	private String stationId; // 정류장 ID
	private String stationSeq; // 정류장순서

	public BusLocation(String endBus, String lowPlate, String plateNo, String plateType, String remainSeatCnt,
			String routeId, String stationId, String stationSeq) {
		this.endBus = endBus;
		this.lowPlate = lowPlate;
		this.plateNo = plateNo;
		this.plateType = plateType;
		this.remainSeatCnt = remainSeatCnt;
		this.routeId = routeId;
		this.stationId = stationId;
		this.stationSeq = stationSeq;
	}

	public String getEndBus() {
		return endBus;
	}

	public String getLowPlate() {
		return lowPlate;
	}

	public String getPlateNo() {
		return plateNo;
	}

	public String getPlateType() {
		return plateType;
	}

	public String getRemainSeatCnt() {
		return remainSeatCnt;
	}

	public String getRouteId() {
		return routeId;
	}

	public String getStationId() {
		return stationId;
	}

	public String getStationSeq() {
		return stationSeq;
	}
	public static ArrayList<BusLocation> getBusLocationList(String routeId) throws Exception {
		ArrayList<BusLocation> result = new ArrayList<BusLocation>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_LOCATION_LIST + StaticValue.SERVICE_KEY + "&routeId="
				+ routeId;
		URL url = new URL(u);
		URLConnection connection = url.openConnection();
		Document doc = StaticValue.parseXML(connection.getInputStream());
		NodeList descNodes = doc.getElementsByTagName("busLocationList");
		for (int i = 0; i < descNodes.getLength(); i++) {
			String endBus = null;
			String lowPlate = null;
			String plateNo = null;
			String plateType = null;
			String remainSeatCnt = null;
			String stationId = null;
			String stationSeq = null;

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				switch (node.getNodeName()) {
				
				case "endBus" :  endBus = node.getTextContent(); break;
				case "lowPlate" : lowPlate  = node.getTextContent(); break;
				case "plateNo" : plateNo  = node.getTextContent(); break;
				case "plateType" : plateType  = node.getTextContent(); break;
				case "remainSeatCnt" : remainSeatCnt  = node.getTextContent(); break;
				case "stationId" :  stationId = node.getTextContent(); break;
				case "stationSeq" :  stationSeq = node.getTextContent(); break;
				
				}

			}
			result.add(new BusLocation(endBus, lowPlate, plateNo, plateType, remainSeatCnt, routeId, stationId, stationSeq));
		}

		return result;
	}
}
