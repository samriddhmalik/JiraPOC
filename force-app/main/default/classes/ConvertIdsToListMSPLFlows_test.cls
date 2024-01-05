@isTest
public class ConvertIdsToListMSPLFlows_test {
    @isTest 
    static void fetchSummary() {
        ConvertIdsToListMultiselectPicklistFlows c= new ConvertIdsToListMultiselectPicklistFlows();
        String s ='a;b;c;d';
        ConvertIdsToListMultiselectPicklistFlows.Requests R = new ConvertIdsToListMultiselectPicklistFlows.Requests();
        R.idsString = s;
        List<ConvertIdsToListMultiselectPicklistFlows.Requests> ListR = new List<ConvertIdsToListMultiselectPicklistFlows.Requests>();
        ListR.add(R);
        ConvertIdsToListMultiselectPicklistFlows.GetCount(ListR);
    }
        
}