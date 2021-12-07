package joambuswebapp;


public class StationRoute {
	private String routeId;// �뼱 ID
	private String routeName; // ���� ��ȣ
	private String routeTypeCd;// �뼱 ����
	private String staOrder; // �뼱�� �ش������忡 ���°?

	public StationRoute() {
	}

	public StationRoute(String routeId, String routeName, String routeTypeCd, String staOrder) {
		this.routeId = routeId;
		this.routeName = routeName;
		this.routeTypeCd = routeTypeCd;
		this.staOrder = staOrder;
	}
	public String getRouteId() {return routeId;}
	public String getRouteName() {return routeName;}
	public String getRouteTypeCd() {return routeTypeCd;}
	public String getStaOrder() {return staOrder;}
	@Override
	public boolean equals(Object obj) {
		boolean sameSame = false;

	    if (obj != null && obj instanceof StationRoute){
	        sameSame = this.routeId.equals(((StationRoute) obj).getRouteId());
	    }

	    return sameSame;

	}
	@Override
    public int hashCode(){
        String s = routeId;
        return s.hashCode();
    }
}
