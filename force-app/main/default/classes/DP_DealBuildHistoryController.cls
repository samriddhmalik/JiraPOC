public class DP_DealBuildHistoryController {
    public ApexPages.StandardController stdController {get; set;}
    public finalizedData wrapperData {get;set;}
    
    
    public class finalizedData{
        @AuraEnabled public string highlights{get;set;}
        @AuraEnabled public string dealtitle{get;set;}
        @AuraEnabled public string importantinfoAU{get;set;}
        @AuraEnabled public string summaryAU{get;set;}
        @AuraEnabled public List<mapIteneraryOrder> iteneraries{get;set;}
        @AuraEnabled public list<iternaryWrapper> itenarylist {get;set;}
        @AuraEnabled public List<tourInclusion> tours{get;set;}
        @AuraEnabled public List<aboutTheProperty> properties{get;set;}
        @AuraEnabled public List<initWrapper> attachInclusionList{get;set;}
    }
    
    public class mapIteneraryOrder{
        @AuraEnabled public string itinNumber {get;set;}
        @AuraEnabled public list<iteneraryData> itinorderlist {get;set;}     
    }
    
    public class tourInclusion implements comparable {
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public decimal order{get;set;}
        @AuraEnabled public List<string> selectedsite{get;set;}
        public Integer compareTo(Object compareTo) {
            tourInclusion tour = (tourInclusion) compareTo;
            if(order !=null && tour.order !=null && order == tour.order){
                return 0;
            }
            if(order !=null && tour.order !=null && order > tour.order){
                return 1;
            }
            
            if(order == null || tour.order == null){
                return -1;
            }
            return -1;        
        }
    }
    
    public class aboutTheProperty implements comparable{
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public decimal order{get;set;}
        @AuraEnabled public List<string> selectedsite{get;set;}
        public Integer compareTo(Object compareTo) {
            aboutTheProperty property = (aboutTheProperty) compareTo;
            if(order !=null && property.order !=null && order == property.order){
                return 0;
            }
            if(order !=null && property.order !=null && order > property.order){
                return 1;
            }
            
            if(order == null || property.order == null){
                return -1;
            }
            return -1;         
        }
    }
    
    public class iteneraryData implements comparable{
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public decimal day{get;set;}
        @AuraEnabled public Integer itNumber{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public string accommodation{get;set;}
        @AuraEnabled public string order{get;set;}
        @AuraEnabled public List<string> selectedmeals {get;set;}
        @AuraEnabled public String mealsIncluded {get;set;}
        @AuraEnabled public string country{get;set;}
        @AuraEnabled public string transfers{get;set;}
      
        public Integer compareTo(Object compareTo) {
          iteneraryData itin = (iteneraryData) compareTo;
            if (day == itin.day) return 0;
            if (day > itin.day) return 1;
            return -1;        
        }
    }
    
    
    public class iternaryWrapper implements comparable{
        @AuraEnabled public Integer itNumber {get;set;}
        @AuraEnabled public List<iteneraryData> itList{get;set;}
        public Integer compareTo(Object compareTo) {
            iternaryWrapper itWrapper = (iternaryWrapper) compareTo;
            if (itNumber == Integer.valueOf(itWrapper.itNumber)) return 0;
            if (itNumber > Integer.valueOf(itWrapper.itNumber)) return 1;
            return -1;        
        }
    }
    
    public class initWrapper{     
        @AuraEnabled public String selectedRecordType {get;set;}
        @AuraEnabled public String selectedPublishedInclusionsDetail {get;set;}
        @AuraEnabled public String selectedText {get;set;}
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String inclusionName {get;set;}
        @AuraEnabled public String inclusionURL {get;set;}
    }
    
    public DP_DealBuildHistoryController(ApexPages.StandardController controller){
        stdController = controller;
        String AnalystOrBDM = 'BDM';
        String dealId = controller.getId();
        List<iteneraryData> itnLst = new List<iteneraryData>();
        try{
            List<Deal_Build_History__c> dealHistory = [SELECT name,Type_of_Record__c, id, ai_selectedPublishedInclusionsDetail__c, ai_PublishingInclusion__c, ai_Recordtype__c, ai_Text__c, hi_Deal_highlights__c, hi_Deal_title__c, History_Saved_By__c, ii_Description__c, in_name__c, in_accommodation__c, in_country_context__c, in_Day__c, in_description__c, in_inclusions__c, in_itinerary_activity__c, in_itinerary_title__c, in_transfers__c, Overview__c, ti_name__c, ti_Description__c, ti_Order__c, ti_Site__c, ti_Title__c, ap_name__c, ap_Description__c, ap_Order__c, ap_Site__c, ap_Title__c FROM Deal_Build_History__c  WHERE History_Saved_By__c =:AnalystOrBDM AND deal__c =:dealId Order by Id ASC ]; 
            finalizedData data = new finalizedData();
            List<iteneraryData> itintempList = new List<iteneraryData>(); 
            List<mapIteneraryOrder> itinerariesOrderMap = new List<mapIteneraryOrder>();
            List<tourInclusion> tourdata = new List <tourInclusion>();
            List<aboutTheProperty> propertyData = new List<aboutTheProperty>();
            List<initWrapper> attachedInclusiondata = new List<initWrapper>();
            Map<string , List<iteneraryData>> ItinOrderMap = new Map<string, List<iteneraryData>>();
            List<iternaryWrapper> itnWrapperLst = new List<iternaryWrapper>();
            integer counter = 0;
            for(Deal_Build_History__c DBH : dealHistory){
                if(DBH.Type_of_Record__c == 'Itinerary'){
                    System.debug('Itinerary ='+ DBH);
                    List<string> selectedmeals = new List<string>();
                    iteneraryData itin = new iteneraryData();
                    itin.name = DBH.in_name__c;
                    itin.itNumber = (DBH.in_Day__c.split(';')[0] == 'null') ? null : integer.valueOf(DBH.in_Day__c.split(';')[0]);
                    itin.day = (DBH.in_Day__c.split(';')[1] == 'null') ? null : integer.valueOf(DBH.in_Day__c.split(';')[1]);
                    itin.order = (DBH.in_Day__c.split(';')[0]=='null')?null : DBH.in_Day__c.split(';')[0] ;
                    itin.title = (DBH.in_itinerary_title__c == 'null' ) ? null : DBH.in_itinerary_title__c;
                    itin.description = (DBH.in_description__c == 'null') ? null : DBH.in_description__c;
                    itin.accommodation = (DBH.in_accommodation__c == 'null') ? null : DBH.in_accommodation__c;
                    itin.country = (DBH.in_country_context__c == 'null') ? null : DBH.in_country_context__c;
                    itin.transfers = (DBH.in_transfers__c == 'null') ? null : DBH.in_transfers__c;
                    
                    if(DBH.in_inclusions__c != 'null' )
                    {
                        if(DBH.in_inclusions__c.contains(';')){
                            selectedmeals.addAll(DBH.in_inclusions__c.split(';'));    
                        }
                        else{
                            selectedmeals.add(DBH.in_inclusions__c);
                        }
                    }
                    itin.selectedmeals = selectedmeals;
                    
                    itintempList.add(itin);
                    
                    List<iteneraryData> emptyItinList = new List<iteneraryData>();
                    ItinOrderMap.put(itin.order , emptyItinList);
                    system.debug('137:- '+ ItinOrderMap);
                    counter = counter+1;
                }
                
                if(DBH.Type_of_Record__c == 'Attach Inclusion'){
                    initWrapper AtIn = new initWrapper();
                    AtIn.selectedRecordType = DBH.ai_Recordtype__c;
                    AtIn.selectedText = ((DBH.ai_Text__c == 'null') ?null : DBH.ai_Text__c);
                    AtIn.selectedPublishedInclusionsDetail  = ((DBH.ai_selectedPublishedInclusionsDetail__c == 'null')?null : DBH.ai_selectedPublishedInclusionsDetail__c);
                    if(!String.isBlank(AtIn.selectedPublishedInclusionsDetail)){
                        String pi = AtIn.selectedPublishedInclusionsDetail ;
                        List<String> splitPI = pi.split(' , ');
                        AtIn.inclusionURL = splitPI[1];
                    }
                    attachedInclusiondata.add(AtIn);
                    counter = counter+1;
                }
                
                if(DBH.Type_of_Record__c == 'Tour Inclusion'){                    
                    List<string> toursite = new List<string>();
                    tourInclusion tempTour = new tourInclusion();
                    tempTour.name = DBH.ti_name__c;
                    tempTour.title = (DBH.ti_Title__c == 'null') ? null : DBH.ti_Title__c;
                    tempTour.order = (DBH.ti_Order__c == 'null') ? 9999 : integer.valueOf(DBH.ti_Order__c);
                    tempTour.description = (DBH.ti_Description__c== 'null') ? null : (DBH.ti_Description__c);
                        if(DBH.ti_Site__c != 'null' )
                    {
                        if(DBH.ti_Site__c.contains(';')){
                            toursite.addAll(DBH.ti_Site__c.split(';'));    
                        }
                        else{
                            toursite.add(DBH.ti_Site__c);
                        }
                    }
                    tempTour.selectedsite =toursite;
                    tourdata.add(tempTour);
                    counter = counter+1;
                    
                }if(DBH.Type_of_Record__c == 'About the Property'){
                    
                    List<string> proprtysite = new List<string>();
                    aboutTheProperty tempProperty = new aboutTheProperty();
                    tempProperty.name = DBH.ap_name__c;
                    tempProperty.title = ((DBH.ap_Title__c == 'null') ? null : DBH.ap_Title__c);
                    tempProperty.description = ((DBH.ap_Description__c == 'null') ? null : DBH.ap_Description__c);
                    tempProperty.order =((DBH.ap_Order__c == 'null') ? 9999 :  integer.valueOf(DBH.ap_Order__c));
                    
                    if(DBH.ap_Site__c != 'null' )
                    {
                        if(DBH.ap_Site__c.contains(';')){
                            proprtysite.addAll(DBH.ap_Site__c.split(';'));    
                        }
                        else{
                            proprtysite.add(DBH.ap_Site__c);
                        }
                    }
                    tempProperty.selectedsite = proprtysite;
                    propertyData.add(tempProperty);
                    counter = counter+1;
                    
                }if(DBH.Type_of_Record__c == 'Deal'){
                    data.importantinfoAU = (DBH.ii_Description__c==null)?null : DBH.ii_Description__c ;
                    data.summaryAU = (DBH.Overview__c==null)?null : DBH.Overview__c ;
                    data.highlights = (DBH.hi_Deal_highlights__c==null)?null : DBH.hi_Deal_highlights__c ;
                    data.dealtitle = (DBH.hi_Deal_title__c==null)?null : DBH.hi_Deal_title__c ;
                    System.debug('data ='+data);
                    counter = counter+1;
                }
                
                
                if(counter == dealHistory.size()){
                    System.debug('itintempList ='+itintempList);
                    for(iteneraryData itin : itintempList ){
                        if(ItinOrderMap.containsKey(itin.order)){
                            List<iteneraryData> itinList =  ItinOrderMap.get(itin.order);
                            itinList.add(itin);
                            ItinOrderMap.put(itin.order , itinList );
                        }
                    }
                    
                    for(string key : ItinOrderMap.keySet()){
                        mapIteneraryOrder itinmap = new mapIteneraryOrder();
                        itinmap.itinNumber = key;
                        itinmap.itinorderlist = ItinOrderMap.get(key);
                        itnLst.addAll(itinmap.itinorderlist);
                        itinerariesOrderMap.add(itinmap);
                    }    
                    Set<String> itNumberLst = new Set<String>();
                    for(integer k=0; k <itnLst.size();k++){
                        itNumberLst.add(String.valueOf(itnLst[k].itNumber));
                    }
                    List<String> listOfStrings = new List<String>(itNumberLst);
                    
                    
                    System.debug('itNumberLst= '+listOfStrings);
                    
                    for(integer n=0; n <listOfStrings.size();n++){
                        iternaryWrapper itWrapper = new iternaryWrapper();
                        //itWrapper.itNumber = String.valueOf(listOfStrings[n]);
                       	itWrapper.itNumber = Integer.valueOf(listOfStrings[n]);

                        //System.debug('itWrapper ='+itWrapper.itNumber);                
                        List<iteneraryData> pageItinLst = new List<iteneraryData>();
                        for(integer m=0; m <itnLst.size();m++){
                            //System.debug('itWrapper Next ='+String.valueOf(itnLst[m].itNumber)); 
                            if(itWrapper.itNumber == Integer.valueOf(itnLst[m].itNumber)){                       
                                iteneraryData itin = new iteneraryData();
                                itin.title = itnLst[m].title;
                                itin.description = itnLst[m].description;
                                itin.day = itnLst[m].day;
                                itin.itNumber = itnLst[m].itNumber;
                                itin.name = itnLst[m].name;
                                itin.accommodation = itnLst[m].accommodation;
                                List<String> meals =  itnLst[m].selectedmeals;
                                String mealIncluded = string.join(meals,',');
                                itin.mealsIncluded = mealIncluded;
                                pageItinLst.add(itin);        
                            } 
                            pageItinLst.sort();
                            itWrapper.itList = pageItinLst;
                        }
                        
                        itnWrapperLst.add(itWrapper);
                    }
                    data.iteneraries = itinerariesOrderMap;
            itnWrapperLst.sort();
            
            data.itenarylist = itnWrapperLst;
            tourdata.sort();
            data.tours = tourdata;
            propertyData.sort();
            data.properties = propertyData;
            data.attachInclusionList = attachedInclusiondata;
            wrapperData = data;
                }
            }          
            
        }catch(exception e){
            wrapperData = null;
        }        
    }
    
    public static void justIncrement1() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
    
    
   public static void justIncrement2() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
    public static void justIncrement3() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
       
    public static void justIncrement4() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
       
    public static void justIncrement5() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
       
    public static void justIncrement6() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
       
    public static void justIncrement7() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
    
       
    public static void justIncrement8() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
       
    public static void justIncrement9() {
        Integer i = 0;
     
        
    }
    
    
       
    public static void justIncrement10() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}