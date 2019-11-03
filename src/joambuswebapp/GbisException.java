package joambuswebapp;

public class GbisException extends Exception{
	private static String message = "Gbis Error";
	public GbisException(){
        super(message);
    }
}
