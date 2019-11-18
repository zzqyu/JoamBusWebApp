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


public class UpdateRouteDBThread extends Thread {
	public static boolean isRun = false;
	private HttpServletRequest request;
	private String onlyDate;
	public UpdateRouteDBThread(HttpServletRequest request) {
		this.request = request;
		onlyDate = LocalDate.now().toString().replace("-", "");
	}
	private void updateRoute() throws Exception {
		String path = request.getSession().getServletContext().getRealPath("/").replace("\\", "/")+"gbisRoute";
		File f = new File(path+"/route"+onlyDate+".txt");
		
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
			
			URL website = new URL("http://openapi.gbis.go.kr/ws/download?route"+onlyDate+".txt");
			ReadableByteChannel rbc = Channels.newChannel(website.openStream());
			FileOutputStream fos = new FileOutputStream(path+"/route"+onlyDate+".txt");
			fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
			
			f = new File(path+"/route"+onlyDate+".txt");
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
		        	values+="('"+line.replace("|", "', '").replace("''", "NULL")+"'),\n";
		        	line="";
		        	System.out.println(cnt+"/"+f.length());
		        }
		        else line+=(char)singleCh;
		    	cnt++;
		    }
		    filereader.close();
		    new DBManager("JOAMBUS").routeInsertAndUpdate(values.substring(0, values.length()-2));
		
		}
		else{
			System.out.println("있어");
		}
	}
	public void run() {
		if(!isRun) {
			try {
				isRun = true;
				updateRoute();
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
