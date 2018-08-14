package joambuswebapp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

public class StaticGMethod<T>{
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap<T, T> sortByValue(final HashMap map, boolean isASC) {
		ArrayList list = new ArrayList(map.entrySet());
		
	    Collections.sort(list, new Comparator() {
	        public int compare(Object o1, Object o2) {
	            return ((Comparable) ((Map.Entry) (o1)).getValue()).compareTo(((Map.Entry) (o2)).getValue());          
	        }
	    });

	    if(isASC) {
			Collections.reverse(list);
		}
	    
	    HashMap sortedHashMap = new LinkedHashMap();
	    
	    for (Iterator it = list.iterator(); it.hasNext();) {
	        Map.Entry entry = (Map.Entry) it.next();
	        sortedHashMap.put(entry.getKey(), entry.getValue());
	    } 
	    
	    return sortedHashMap;
	}
}