package joambuswebapp;


public class RouteInfoItem {
	
	private String companyName;// ����� �̸�
	private String companyTel;// ����� ��ȭ��ȣ
	private String downFirstTime;// ���� ù�� �ð�
	private String downLastTime;// ���� ���� �ð�
	private String endMobileNo;// ���� ����Ϲ�ȣ
	private String endStationId;// ���� ������ID
	private String endStationName;// ���� ������ �̸�
	private String routeId;// �뼱 ID
	private String routeName;// �뼱 ��ȣ
	private String routeTypeCd;// �뼱����;
	private String startMobileNo;// ���� ����Ϲ�ȣ
	private String startStationId; // ���� ������ID
	private String startStationName; // ���� ������ �̸�
	private String upFirstTime;// ���� ù�� �ð�
	private String upLastTime;// ���� ���� �ð�

	public String getCompanyName() {
		return companyName;
	}

	public String getCompanyTel() {
		return companyTel;
	}

	public String getDownFirstTime() {
		return downFirstTime;
	}

	public String getDownLastTime() {
		return downLastTime;
	}

	public String getEndMobileNo() {
		return endMobileNo;
	}

	public String getEndStationId() {
		return endStationId;
	}

	public String getEndStationName() {
		return endStationName;
	}

	public String getRouteId() {
		return routeId;
	}

	public String getRouteName() {
		return routeName;
	}

	public String getRouteTypeCd() {
		return routeTypeCd;
	}

	public String getStartMobileNo() {
		return startMobileNo;
	}

	public String getStartStationId() {
		return startStationId;
	}

	public String getStartStationName() {
		return startStationName;
	}

	public String getUpFirstTime() {
		return upFirstTime;
	}

	public String getUpLastTime() {
		return upLastTime;
	}

	public RouteInfoItem() {
	}

	public RouteInfoItem(String companyName,
			String companyTel,
			String downFirstTime,
			String downLastTime,
			String endMobileNo,
			String endStationId,
			String endStationName,
			String routeId,
			String routeName,
			String routeTypeCd,
			String startMobileNo,
			String startStationId,
			String startStationName,
			String upFirstTime,
			String upLastTime) {
		this.companyName = companyName;
		this.companyTel = companyTel;
		this.downFirstTime = downFirstTime;
		this.downLastTime = downLastTime;
		this.endMobileNo = endMobileNo;
		this.endStationId = endStationId;
		this.endStationName = endStationName;
		this.routeId = routeId;
		this.routeName = routeName;
		this.routeTypeCd = routeTypeCd;
		this.startMobileNo = startMobileNo;
		this.startStationId = startStationId;
		this.startStationName = startStationName;
		this.upFirstTime = upFirstTime;
		this.upLastTime = upLastTime;
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		boolean sameSame = false;

		if (obj != null && obj instanceof RouteInfoItem) {
			sameSame = this.routeId.equals(((RouteInfoItem) obj).getRouteId());
		}

		return sameSame;

	}

	@Override
	public int hashCode() {
		String s = routeId;
		return s.hashCode();
	}
}
