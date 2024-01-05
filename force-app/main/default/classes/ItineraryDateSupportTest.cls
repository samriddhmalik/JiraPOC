@isTest
public class ItineraryDateSupportTest {
		
     static testmethod  void testItineraryDateSupport() {

        Test.startTest();
        Set<String> contexts = new Set<String>{
                'Main Package', 'Pre Extension', 'Post Extension', 'Upgrade'
        };
        Map<String, List<Itinerary__c>> itinList = new Map<String, List<Itinerary__c>>();

        for (String str : contexts) {
            
            List<Itinerary__c> itins = TestDataFactory.ListofItinerarys(5 , str );
            
            itinList.put(str, itins);
        }

        Date myDate = Date.newInstance(2020, 2, 1);

        ItineraryDateSupport ids = new ItineraryDateSupport(myDate, itinList);
        ItineraryDateSupport ids1 = new ItineraryDateSupport(myDate, itinList,1);

        for (String str : contexts) {
            ids.startDateForContext(str);
            ids1.startDateForContext(str);
        }
        Test.stopTest();
    }

}