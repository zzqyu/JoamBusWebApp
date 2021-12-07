package joambuswebapp;


import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class BusArriveStation {
	
	//private String BusArrivalList; //버스도착정보목록
	private String stationId; //정류소 아이디
	private String routeId; //노선 아이디
	private String locationNo1; //첫번째차량 위치 정보
	private String predictTime1; //첫번째차량 도착예상시간
	private String lowPlate1; //첫번째차량 저상버스여부
	private String plateNo1; //첫번째차량 차량번호
	private String remainSeatCnt1; //첫번째차량 빈자리 수
	private String locationNo2; //두번째차량 위치 정보
	private String predictTime2; //두번째차량 도착예상시간
	private String lowPlate2; //두번째차량 저상버스여부
	private String plateNo2; //두번째차량 차량번호
	private String remainSeatCnt2; //두번째차량 빈자리 수
	private String staOrder; //정류소 순번
	private String flag; //상태구분

	public BusArriveStation(String stationId,  String routeId,  String locationNo1,
			String predictTime1,  String lowPlate1,  String plateNo1,  String remainSeatCnt1,  
			String locationNo2,  String predictTime2,  String lowPlate2,  String plateNo2,  
			String remainSeatCnt2,  String staOrder,  String flag) {
				this.stationId = stationId;
				this.routeId = routeId;
				this.locationNo1 = locationNo1;
				this.predictTime1 = predictTime1;
				this.lowPlate1 = lowPlate1;
				this.plateNo1 = plateNo1;
				this.remainSeatCnt1 = remainSeatCnt1;
				this.locationNo2 = locationNo2;
				this.predictTime2 = predictTime2;
				this.lowPlate2 = lowPlate2;
				this.plateNo2 = plateNo2;
				this.remainSeatCnt2 = remainSeatCnt2;
				this.staOrder = staOrder;
				this.flag = flag;
	}
	public String getStationId() {
		return stationId;
	}


	public String getRouteId() {
		return routeId;
	}


	public String getLocationNo1() {
		return locationNo1;
	}


	public String getPredictTime1() {
		return predictTime1;
	}


	public String getLowPlate1() {
		return lowPlate1;
	}


	public String getPlateNo1() {
		return plateNo1;
	}


	public String getRemainSeatCnt1() {
		return remainSeatCnt1;
	}


	public String getLocationNo2() {
		return locationNo2;
	}


	public String getPredictTime2() {
		return predictTime2;
	}


	public String getLowPlate2() {
		return lowPlate2;
	}


	public String getPlateNo2() {
		return plateNo2;
	}


	public String getRemainSeatCnt2() {
		return remainSeatCnt2;
	}


	public String getStaOrder() {
		return staOrder;
	}


	public String getFlag() {
		return flag;
	}

	
	public static ArrayList<BusArriveStation> getBusArriveStation(String stationId) throws Exception {
		ArrayList<BusArriveStation> result = new ArrayList<BusArriveStation>();

		String u = StaticValue.URL + StaticValue.URL_GET_BUS_STATION_ARRIVE_LIST + StaticValue.SERVICE_KEY + "&stationId="
				+ stationId;
		URL url = new URL(u);
		URLConnection connection = url.openConnection();
		InputStream is = connection.getInputStream();
        
		Document doc = StaticValue.parseXML(is);
		NodeList descNodes = doc.getElementsByTagName("busArrivalList");
		System.out.println(descNodes.getLength());
		for (int i = 0; i < descNodes.getLength(); i++) {
			stationId = null; 
			String routeId = null; 
			String locationNo1 = null; 
			String predictTime1 = null; 
			String lowPlate1 = null; 
			String plateNo1 = null; 
			String remainSeatCnt1 = null; 
			String locationNo2 = null; 
			String predictTime2 = null; 
			String lowPlate2 = null; 
			String plateNo2 = null; 
			String remainSeatCnt2 = null; 
			String staOrder = null; 
			String flag = null; 

			for (Node node = descNodes.item(i).getFirstChild(); node != null; node = node.getNextSibling()) { // 첫번째 자식을
				System.out.println(node.getNodeName());
				switch (node.getNodeName()) {
				
				case "stationId" : stationId = node.getTextContent(); break;
				case "routeId" : routeId = node.getTextContent(); break;
				case "locationNo1" : locationNo1 = node.getTextContent(); break;
				case "predictTime1" : predictTime1 = node.getTextContent(); break;
				case "lowPlate1" : lowPlate1 = node.getTextContent(); break;
				case "plateNo1" : plateNo1 = node.getTextContent(); break;
				case "remainSeatCnt1" : remainSeatCnt1 = node.getTextContent(); break;
				case "locationNo2" : locationNo2 = node.getTextContent(); break;
				case "predictTime2" : predictTime2 = node.getTextContent(); break;
				case "lowPlate2" : lowPlate2 = node.getTextContent(); break;
				case "plateNo2" : plateNo2 = node.getTextContent(); break;
				case "remainSeatCnt2" : remainSeatCnt2 = node.getTextContent(); break;
				case "staOrder" : staOrder = node.getTextContent(); break;
				case "flag" : flag = node.getTextContent(); break;
				
				}
				System.out.println(node.getTextContent());

			}
			result.add(new BusArriveStation(stationId,  routeId,  locationNo1, predictTime1,  lowPlate1,  plateNo1,  remainSeatCnt1,   locationNo2,  predictTime2,  lowPlate2,  plateNo2,  remainSeatCnt2,  staOrder,  flag));
		}

		return result;
	}


	
}
