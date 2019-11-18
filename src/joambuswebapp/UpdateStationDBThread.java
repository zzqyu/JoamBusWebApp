package joambuswebapp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.time.LocalDate;

import javax.servlet.http.HttpServletRequest;


public class UpdateStationDBThread extends Thread {
	public static boolean isRun = false;
	private HttpServletRequest request;
	private String onlyDate;
	public UpdateStationDBThread(HttpServletRequest request) {
		this.request = request;
		onlyDate = LocalDate.now().toString().replace("-", "");
	}
	
	private void updateStation() throws Exception{
		String path = request.getSession().getServletContext().getRealPath("/").replace("\\", "/")+"gbisStation";
		File f = new File(path+"/station"+onlyDate+".txt");
		
		// 파일 존재 여부 판단
		if (!f.isFile()) {
			System.out.println("그런 파일 없습니다.");
			File dir = new File(path);
			File[] fs = dir.listFiles();
			if(fs.length==1){
				System.out.println(fs[0].getName());
				if(!fs[0].getName().contains(onlyDate)){
					fs[0].delete();
				}
			}	
			
			URL website = new URL("http://openapi.gbis.go.kr/ws/download?station"+onlyDate+".txt");
			ReadableByteChannel rbc = Channels.newChannel(website.openStream());
			FileOutputStream fos = new FileOutputStream(path+"/station"+onlyDate+".txt");
			fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
			
			f = new File(path+"/station"+onlyDate+".txt");
			FileReader filereader = new FileReader(f);
		    int singleCh = 0;
		    int cnt=0;
		    String values = "";
		    String line = "";
		    boolean isFirst = true;
		    while((singleCh = filereader.read()) != -1){
		        if((char)singleCh=='^'){
		        	if(isFirst){
		        		isFirst = false;
		        		line="";
		        		continue;
		        	}
		        	line = "'"+line.replace("|", "'! '").replace("''", "NULL")+"'";
		        	String[] tmp = line.split("!");
		        	//STATION_ID', 'STATION_NM', 'CENTER_ID', 'CENTER_YN', 'X', 'Y', 'REGION_NAME', 'MOBILE_NO', 'DISTRICT_CD'
		        	values+="("+tmp[0]+","+tmp[7]+","+tmp[1]+","+tmp[4]+","+tmp[5]+"),\n";
		        	line="";
		        	System.out.println(cnt+"/"+f.length());
		        }
		        else line+=(char)singleCh;
		    	cnt++;
		    }
		    filereader.close();
		    new DBManager("JOAMBUS").stationInsertAndUpdate(values.substring(0, values.length()-2));
		
		}
		else{
			System.out.println("있어");
		}
	}
	public void run() {
		if(!isRun) {
			try {
				isRun = true;
				updateStation();
			}
			catch(Exception e) {
				e.getStackTrace();
			}
			finally {
				isRun = false;
				System.out.println("isRun!!!end");
			}
		}
		else {
			System.out.println("isRun!!!");
		}
	}
}
