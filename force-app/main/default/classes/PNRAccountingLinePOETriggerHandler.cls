public class PNRAccountingLinePOETriggerHandler {
   
    public static void createPAXSegmentLinkRecord(List<PNR_Accounting_Line_POE__c> listOfAccountingLines){
       
        Set<Id> setOfPNRIds = new Set<Id>();
        Set<String> firstNamesSet = new Set<String>();
        Set<String> lastNamesSet = new Set<String>();
       
        for(PNR_Accounting_Line_POE__c pal : listOfAccountingLines){
            setOfPNRIds.add(pal.pnr__c);
            String paxNameInstance = pal.passenger_name__c;
            if(!paxNameInstance.contains('/')){
                List<String> nameSplit = paxNameInstance.split(' ');
                firstNamesSet.add(nameSplit[1]);
                lastNamesSet.add(nameSplit[0]);
            }else{
                List<String> nameSplit = paxNameInstance.split('/');
                List<String> strLocalList = nameSplit[1].split(' ');
                firstNamesSet.add(strLocalList[0]);
                lastNamesSet.add(nameSplit[0]);
            }    
        }
       system.debug('firstNamesSet:'+firstNamesSet+'lastNamesSet:'+lastNamesSet);
        List<Segment_POE__c> listOfAssocatedSegments = [Select id, PNR__c, PNR__r.TAD_Order__c from Segment_POE__c where PNR__c in:setOfPNRIds];
        Map<String, List<Segment_POE__c>> mapOfOrderAgainstSegment = new Map<String, List<Segment_POE__c>>();
        Set<Id> orderIds = new Set<Id>();
       
        for(Segment_POE__c seg : listOfAssocatedSegments){
            orderIds.add(seg.PNR__r.TAD_Order__c);
            if(mapOfOrderAgainstSegment.containsKey(seg.PNR__r.TAD_Order__c)){
                List<Segment_POE__c> getExistingList = mapOfOrderAgainstSegment.get(seg.PNR__r.TAD_Order__c);
                getExistingList.add(seg);
            }else{
                List<Segment_POE__c> newListOfSegments = new List<Segment_POE__c>();
                newListOfSegments.add(seg);
                mapOfOrderAgainstSegment.put(seg.PNR__r.TAD_Order__c, newListOfSegments);
            }
        }
        List<customer_POE__c> listOfPAX = [Select id, Name, first_name__c, second_name__c, last_name__c, Passenger_Name__c,ordexp_tad_order__c from customer_POE__c where clean_first_name__c in:firstNamesSet AND clean_last_name__c in:lastNamesSet and ordexp_tad_order__c in:orderIds];
       
        Map<String, List<customer_POE__c>> mapOfOrderAgainstPAX = new Map<String, List<customer_POE__c>>();
        for(customer_POE__c cus : listOfPAX){
            if(mapOfOrderAgainstPAX.containsKey(cus.ordexp_tad_order__c)){
                List<customer_POE__c> getExistingList = mapOfOrderAgainstPAX.get(cus.ordexp_tad_order__c);
                getExistingList.add(cus);
            }else{
                List<customer_POE__c> newListOfPAX = new List<customer_POE__c>();
                newListOfPAX.add(cus);
                mapOfOrderAgainstPAX.put(cus.ordexp_tad_order__c, newListOfPAX);
            }
        }
       
       Map<String, List<Segment_POE__c>> mapOfPAXIdWithSegmentList = new Map<String, List<Segment_POE__c>>();
        for(String paxKey : mapOfOrderAgainstPAX.keySet()){
            for(customer_POE__c cus : mapOfOrderAgainstPAX.get(paxKey)){
                if(mapOfOrderAgainstSegment.containsKey(paxKey)){
                    mapOfPAXIdWithSegmentList.put(cus.Id, mapOfOrderAgainstSegment.get(paxKey));
                }
            }
        }
       
        List<PAX_Segment_Links__c> listToInsertJunctionRecords = new List<PAX_Segment_Links__c>();
        if(mapOfPAXIdWithSegmentList != null){
            for(String str : mapOfPAXIdWithSegmentList.keySet()){
                for(Segment_POE__c seg : mapOfPAXIdWithSegmentList.get(str)){
                    PAX_Segment_Links__c paxSegmentLinkInstance = new PAX_Segment_Links__c();
                    paxSegmentLinkInstance.Segment__c = seg.Id;
                    paxSegmentLinkInstance.Passengers__c = str;
                    listToInsertJunctionRecords.add(paxSegmentLinkInstance);
                }
            }
        }
       
        if(!listToInsertJunctionRecords.isEmpty()){
            insert listToInsertJunctionRecords;
        }
       
    }  
}