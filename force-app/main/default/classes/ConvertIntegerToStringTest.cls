@isTest
public class ConvertIntegerToStringTest {
    @isTest 
    static void fetchSummary() {
        ConvertIntegerToString c= new ConvertIntegerToString();
        Integer s = 100;
        ConvertIntegerToString.Requests R = new ConvertIntegerToString.Requests();
        R.RequestInt = s;
        List<ConvertIntegerToString.Requests> ListR = new List<ConvertIntegerToString.Requests>();
        ListR.add(R);
        ConvertIntegerToString.GetCount(ListR);
    }
        
}