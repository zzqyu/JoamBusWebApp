package joambuswebapp;

public class TestMain {
	public static void main(String[] args) {
		try {
			//String routeId, String stationId
			//StaticValue.timetableOfRouteInStation("233000060", "233000422");
			StaticValue.timetableOfStation("233001356");
		}
		catch (Exception e) {
			// TODO: handle exception
		}
	}
}
