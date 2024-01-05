public class Tad_DealOptimizaitonContorller {
    
    public class dealData{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public string dealname{get;set;}
        @AuraEnabled public string highlights{get;set;}
        @AuraEnabled public string importantinfoAU{get;set;}
        @AuraEnabled public string importantinfoNZ{get;set;}
        @AuraEnabled public string summaryAU{get;set;}
        @AuraEnabled public string summaryNZ{get;set;}
        @AuraEnabled public List<mapIteneraryOrder> iteneraries{get;set;}
        @AuraEnabled public List<tourInclusion> tours{get;set;}
        @AuraEnabled public List<aboutTheProperty> properties{get;set;}
        @AuraEnabled public boolean toursort{get;set;}
        @AuraEnabled public boolean propertysort{get;set;}
        @AuraEnabled public List<initWrapper> attachInclusionList{get;set;}
        @AuraEnabled public Map<String,String> publishInclusionDetailMap{get;set;}
        @AuraEnabled public integer countOfHighlightedInclusions {get;set;}
        @AuraEnabled public List<RecordTypeWrapper> RecordTypeWrapper {get;set;}
        @AuraEnabled public String highlightsRecordId {get;set;}
        @AuraEnabled public Boolean isDealObject {get;set;}
        @AuraEnabled public String userRoleName {get;set;}
        @AuraEnabled public Boolean dataEditableDisable {get;set;}
        @AuraEnabled public Boolean showBDMcopy {get;set;}
        @AuraEnabled public Boolean showAnlystcopy {get;set;}
        @AuraEnabled public finalizedData BDMdata {get;set;}
        @AuraEnabled public finalizedData AnalystData {get;set;}
        @AuraEnabled public String title {get;set;}
        @AuraEnabled public String description {get;set;}
        @AuraEnabled public Boolean isFlightbookbynull {get;set;}
    }
    
    public class finalizedData{
        @AuraEnabled public string highlights{get;set;}
        @AuraEnabled public string dealtitle{get;set;}
        @AuraEnabled public string importantinfoAU{get;set;}
        @AuraEnabled public string importantinfoNZ{get;set;}
        @AuraEnabled public string summaryAU{get;set;}
        @AuraEnabled public string summaryNZ{get;set;}
        @AuraEnabled public List<mapIteneraryOrder> iteneraries{get;set;}
        @AuraEnabled public List<tourInclusion> tours{get;set;}
        @AuraEnabled public List<aboutTheProperty> properties{get;set;}
        @AuraEnabled public List<initWrapper> attachInclusionList{get;set;}
        @AuraEnabled public Map<String,String> publishInclusionDetailMap{get;set;}
        @AuraEnabled public integer countOfHighlightedInclusions {get;set;}
        @AuraEnabled public List<RecordTypeWrapper> RecordTypeWrapper {get;set;}
        @AuraEnabled public String highlightsRecordId {get;set;}
        @AuraEnabled public Boolean isDealObject {get;set;}
        @AuraEnabled public Boolean showBDMcopy {get;set;}
        @AuraEnabled public Boolean showAnlystcopy {get;set;}
        
    }
    
    public class picklistValues{
        @AuraEnabled  public String label {get;set;}
        @AuraEnabled  public String value {get;set;}
    }
    
    public class mapIteneraryOrder{
        @AuraEnabled public string itinNumber {get;set;}
        @AuraEnabled public list<iteneraryData> itinorderlist {get;set;}
        @Auraenabled public boolean showclone {get;set;}
        @Auraenabled public boolean sortup {get;set;}
        @Auraenabled public boolean check {get;set;}
    }
    public class iteneraryData{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public decimal day{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public string accommodation{get;set;}
        @AuraEnabled public string order{get;set;}
        @AuraEnabled public List<string> selectedmeals {get;set;}
        @AuraEnabled public boolean disable{get;set;}
        @AuraEnabled public boolean isclone{get;set;}
        @AuraEnabled public boolean toUpdateorInsert{get;set;}
        @AuraEnabled public boolean check{get;set;}
        @AuraEnabled public string country{get;set;}
        @AuraEnabled public string transfers{get;set;}
        //@AuraEnabled public activitydata activity{get;set;}
        @AuraEnabled public integer childIndex{get;set;}
        @AuraEnabled public integer parentIndex{get;set;}
        @AuraEnabled public integer selectedcount{get;set;}
        @AuraEnabled public boolean isBlank{get;set;}
    }
    
    public class tourInclusion{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public decimal order{get;set;}
        @AuraEnabled public List<string> selectedsite{get;set;}
        @AuraEnabled public boolean isclone{get;set;}
        @AuraEnabled public boolean toUpdateorInsert{get;set;}
        @AuraEnabled public integer childIndex{get;set;}        
    	@AuraEnabled public boolean isBlank{get;set;}
    }
    
    public class aboutTheProperty{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string description{get;set;}
        @AuraEnabled public decimal order{get;set;}
        @AuraEnabled public List<string> selectedsite{get;set;}
        @AuraEnabled public boolean isclone{get;set;}
        @AuraEnabled public boolean toUpdateorInsert{get;set;}
        @AuraEnabled public integer childIndex{get;set;}
		@AuraEnabled public boolean isBlank{get;set;}        
    }
    
    public class RecordTypeWrapper{
        @AuraEnabled public string RecordTypeName {get;set;}
        @AuraEnabled public string RecordTypeId {get;set;}
    }	
    
    public class initWrapper{     
        @AuraEnabled public boolean isclone{get;set;}
        @AuraEnabled public boolean toUpdateorInsert{get;set;}    
        @AuraEnabled public String selectedRecordType {get;set;}
        @AuraEnabled public String selectedPublishedInclusions {get;set;}
        @AuraEnabled public String selectedPublishedInclusionsDetail {get;set;}
        @AuraEnabled public String selectedText {get;set;}
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String isPublishInclusionSelected {get;set;}	
        @AuraEnabled public boolean isRecordBlank {get;set;}
    }
    
    /* public class activitydata{
@AuraEnabled public string id{get;set;}
@AuraEnabled public string name{get;set;}
}*/
    
    @AuraEnabled
    public static dealData getDealData(string dealId){
        system.debug('dealId:-'+ dealId);
        integer i = 0;
        dealData dealWraper = new dealData();
        List<mapIteneraryOrder> alliteneraries = new List<mapIteneraryOrder>();
        Map<string, List<iteneraryData>> itinOrderMap = new map<string, list<iteneraryData>>();
        List<tourInclusion> tourList = new List<tourInclusion>(); 
        List<aboutTheProperty> properties = new List<aboutTheProperty>();
        List<initWrapper> attachInclusionList = new List<initWrapper>();
        
        try{  
            /*   DP-57, DP-56 start */
            
            /* Get Current User's Metadata record */
            List<Deal_Finalized_users__mdt> getuserMdt = [SELECT id, Role_Type__c,  user_Email__c FROM Deal_Finalized_users__mdt WHERE user_Email__c=:UserInfo.getUserEmail() ];
            
            Deal__c dealdata = [SELECT ID, title__c, name, description__c, Deal_KSP__c, Summary_nz__c, Summary__c, Fine_Print__c, fine_print_nz__c, 	BDM_finalized__c, Analyst_finalized__c, Flight_Book_By__c,Dates_Flights__c  FROM Deal__c WHERE ID =: dealId LIMIT 1];
            dealWraper.dataEditableDisable = true;
            if(!getuserMdt.isEmpty()){
                system.debug('1');
                dealWraper.userRoleName = getuserMdt[0].Role_Type__c;
                if(getuserMdt[0].Role_Type__c =='BDM' && dealdata.BDM_finalized__c == false){
                    dealWraper.dataEditableDisable = false;
                    system.debug('2');
                }else if(getuserMdt[0].Role_Type__c =='Analyst' && dealdata.Analyst_finalized__c == false){
                    system.debug('4');
                    dealWraper.dataEditableDisable = false;
                }else if(getuserMdt[0].Role_Type__c =='Publisher'){
                    system.debug('5');
                    dealWraper.dataEditableDisable = false;
                }
            }
            
            
            
            if(dealdata.BDM_finalized__c == true ){
                dealWraper.showBDMcopy = true;
            }else{
                dealWraper.showBDMcopy = false;
            }
            if(dealdata.BDM_finalized__c == true && dealdata.Analyst_finalized__c == true){
                dealWraper.showAnlystcopy = true;
            }else{
                dealWraper.showAnlystcopy = false;
            }
            
            
            if(dealWraper.showBDMcopy == true){
                dealWraper.BDMdata = ShowFinalizedDealData('BDM' , dealId);
            }
            
            if(dealWraper.showAnlystcopy == true){	
                dealWraper.AnalystData = ShowFinalizedDealData('Analyst' , dealId);
            }
            
            /*   DP-57, DP-56 End */

            /*   DP-66 Start */
            if(	dealdata.Flight_Book_By__c == null && (dealdata.Dates_Flights__c=='Dates/Domestic Flights' || dealdata.Dates_Flights__c=='Dates/International Flights') ){
                dealWraper.isFlightbookbynull = true;
            }else{
                dealWraper.isFlightbookbynull = false;
            }
            /*   DP-66 End */
            
            List<Itinerary__c> itinList = [SELECT ID, name, Deal__c, accomodation__c, title__c, Meals_Included__c, body__c, Day_number__c, Itinerary__c, itinerary_activity__c,	Transfers__c, country_context__c FROM Itinerary__c WHERE   Deal__c =:dealId  ORDER BY Day_number__c];
            List<tour_inclusions__c> tourData = [SELECT id, name, Deal__c, body__c, order__c, site__c, title__c FROM tour_inclusions__c WHERE   Deal__c =:dealId ORDER BY order__c];
            List<About_The_Property__c> propertyList = [SELECT ID, name, Deal__c, Title__c, Description__c , site__c, Order__c FROM About_The_Property__c WHERE Deal__c =:dealId  ORDER BY Order__c];
            
            
            
            dealWraper.id = dealdata.id;
            dealWraper.dealname = 'DEAL - '+dealdata.name;
            dealWraper.highlights = dealdata.description__c;
            dealWraper.importantinfoAU = dealdata.Fine_Print__c;
            dealWraper.importantinfoNZ = dealdata.fine_print_nz__c;
            dealWraper.summaryAU = dealdata.Summary__c;
            dealWraper.summaryNZ = dealdata.Summary_nz__c;
            dealWraper.toursort = true;
            dealWraper.propertysort = true;
            dealWraper.title = dealdata.title__c;
        	dealWraper.description = dealdata.description__c;
            
            for(Itinerary__c itin :  itinList){
                if(!itinOrderMap.containsKey(itin.Itinerary__c)){
                    List<string> selectedmeals = new List<string>();
                    List<iteneraryData> itinTempList = new List<iteneraryData>();
                    iteneraryData itindata = new iteneraryData();
                    itindata.id = itin.id;
                    itindata.name = itin.name;
                    itindata.day = itin.Day_number__c;
                    itindata.title = itin.title__c;
                    itindata.description = itin.body__c;
                    itindata.accommodation = itin.accomodation__c;
                    //itindata.country = 	itin.country_context__c;
                    if(itin.country_context__c == null ){
                        itindata.country = 'AU';
                    }else{
                        itindata.country = 	itin.country_context__c;
                    }
                    itindata.transfers =itin.Transfers__c;
                    //itindata.activity = itin.itinerary_activity__c
                    itindata.disable = false;
                    itindata.isclone = false;
                    itindata.isBlank = false;//DP-82
                    itindata.toUpdateorInsert = false;
                    itindata.childindex = 1 ;
                    itindata.parentindex = 1 ;
                    itindata.selectedcount = 1 ;
                    itindata.check = false ;
                    system.debug('itin.Meals_Included__c:- '+ itin.Meals_Included__c);
                    if(itin.Meals_Included__c != null )
                    {
                        if(itin.Meals_Included__c.contains(';')){
                            selectedmeals.addAll(itin.Meals_Included__c.split(';'));    
                        }
                        else{
                            system.debug('itin.Meals_Included__c:- '+ itin.Meals_Included__c);
                            selectedmeals.add(itin.Meals_Included__c);
                        }
                    }
                    itindata.selectedmeals = selectedmeals;
                    itindata.order = itin.Itinerary__c;
                    itinTempList.add(itindata);
                    
                    itinOrderMap.put(itin.Itinerary__c, itinTempList  );
                }else if(itinOrderMap.containsKey(itin.Itinerary__c)){
                    List<string> selectedmeals = new List<string>(); 
                    List<iteneraryData> itinTempList = itinOrderMap.get(itin.Itinerary__c);
                    iteneraryData itindata = new iteneraryData();
                    itindata.id = itin.id;
                    itindata.name = itin.name;
                    itindata.day = itin.Day_number__c;
                    itindata.title = itin.title__c;
                    itindata.description = itin.body__c;
                    itindata.accommodation = itin.accomodation__c;
                    itindata.country = 	itin.country_context__c;
                    itindata.transfers =itin.Transfers__c;
                    //itindata.activity = itin.itinerary_activity__c
                    itindata.disable = false;
                    itindata.isclone = false;
                    itindata.check = false ;
                    itindata.isBlank = false;//DP-82
                    itindata.toUpdateorInsert = false;
                    system.debug('itin.Meals_Included__c:- '+ itin.Meals_Included__c);
                    if(itin.Meals_Included__c != null)
                    {
                        if(itin.Meals_Included__c.contains(';')){
                            selectedmeals.addAll(itin.Meals_Included__c.split(';'));    
                        }else{
                            selectedmeals.add(itin.Meals_Included__c);
                        }
                    }
                    itindata.selectedmeals = selectedmeals;
                    itindata.order = itin.Itinerary__c;
                    itinTempList.add(itindata);
                    
                    itinOrderMap.put(itin.Itinerary__c, itinTempList );
                }
                
            }
            dealWraper.iteneraries = alliteneraries;
            
            /*<<<<tour wrapper starts Here>>>>>*/
            
            if(!tourData.isEmpty()){
                for(tour_inclusions__c tour: tourData ){
                    List<string> toursites = new List<string>();
                    tourInclusion tourwrap = new tourInclusion();
                    //id, body__c, order__c, site__c, title__c
                    tourwrap.name = tour.Name;
                    tourwrap.id = tour.id;
                    tourwrap.title = tour.title__c;
                    tourwrap.description = tour.body__c;
                    tourwrap.order = tour.order__c;
                    tourwrap.isclone = false;
                    tourwrap.isBlank = false;
                    tourwrap.toUpdateorInsert = false;
                    if(tour.site__c != null){
                        if(tour.site__c.contains(';')){
                            system.debug('tour.site__c:- '+tour.site__c);
                            toursites.addAll(tour.site__c.split(';'));
                        }else{
                            toursites.add(tour.site__c);
                        }
                        tourwrap.selectedsite = toursites;
                    }
                    tourList.add(tourwrap);
                    
                }    
            }else{
                List<string> toursites = new List<string>();
                toursites.add('AU');
                tourInclusion tourwrap = new tourInclusion();
                tourwrap.description = '';
                tourwrap.isclone = true;
                tourwrap.isBlank = false;//DP-93
                tourwrap.selectedsite = toursites;
                tourwrap.toUpdateorInsert = true;                    
                tourList.add(tourwrap);
            }
            dealWraper.tours = tourList;
            /*<<<<tour wrapper End Here>>>>>*/
            
            
            /*<<<<About the Property wrapper starts Here>>>>>*/
            
            //ID, name, Title__c, Description__c , site__c, Order__c 
            if(!propertyList.isEmpty()){
                for(About_The_Property__c property : propertyList ){
                    List<string> propertySite = new List<string>();
                    aboutTheProperty propwrap = new aboutTheProperty();
                    propwrap.id = property.id;
                    propwrap.name = property.name;
                    propwrap.title = property.Title__c;
                    propwrap.description = property.Description__c;
                    propwrap.order = property.Order__c;
                    propwrap.isclone = false;
                    propwrap.isBlank = false;
                    propwrap.toUpdateorInsert = false;
                    if(property.site__c != null){
                        if(property.site__c.contains(';')){
                            system.debug('property.site__c:- '+property.site__c);
                            propertySite.addAll(property.site__c.split(';'));
                        }else{
                            propertySite.add(property.site__c);
                        }
                        propwrap.selectedsite = propertySite;
                    }
                    properties.add(propwrap);
                    
                }
            }else{
                List<string> propertySite = new List<string>();
                aboutTheProperty propwrap = new aboutTheProperty();
                propertySite.add('AU');
                propwrap.description = '';
                propwrap.isclone = true;
                propwrap.isBlank = false;//DP-93
                propwrap.selectedsite =  propertySite;
                propwrap.toUpdateorInsert = true;                    
                properties.add(propwrap);
            }
            dealWraper.properties = properties;
            /*<<<<About the Property wrapper Ends Here>>>>>*/
            
            
            
            
            
            for(string itinorder : itinOrderMap.keyset()){
                
                i++;
                integer mapsize = itinOrderMap.size();
                system.debug('mapsize"- '+ mapsize);
                system.debug('integer"- '+ i);
                
                mapIteneraryOrder itinWrap = new mapIteneraryOrder();
                itinWrap.itinNumber = itinorder;
                itinWrap.showclone = false;
                itinWrap.check = false;
                itinWrap.sortup = true;
                list<iteneraryData> itindataList = itinOrderMap.get(itinorder);
                
                itinWrap.itinorderlist = itindataList;
                alliteneraries.add(itinWrap);
                
            }
            if(!alliteneraries.isEmpty()){
                dealWraper.iteneraries = alliteneraries;    
            }else{
                List<mapIteneraryOrder> blankmapIteneraryOrder = new list<mapIteneraryOrder>();
                list<iteneraryData> blankItinRec = new List<iteneraryData>();
                iteneraryData blankWrap = new iteneraryData();
                blankWrap.isclone = true;
                blankWrap.isBlank = false;//DP-94
                blankWrap.toUpdateorInsert = true;//DP-94
                blankWrap.day = 1;
                blankItinRec.add(blankWrap);
                mapIteneraryOrder blankItinorderMap = new mapIteneraryOrder();
                blankItinorderMap.itinNumber='1';
                blankItinorderMap.showclone = false;
                blankItinorderMap.check = false;
                blankItinorderMap.itinorderlist = blankItinRec;
                blankmapIteneraryOrder.add(blankItinorderMap);
                dealWraper.iteneraries = blankmapIteneraryOrder;
                
            }
            
            
            List<initWrapper> initWrapperLst = new List<initWrapper>();
            List<initWrapper> recordTypeWrapperList = new List<initWrapper>();
            Id recordIdFinal = dealId;
            String sObjName = recordIdFinal.getSObjectType().getDescribe().getName();
            
            
            String dealHighlightsRecordTypeID = Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
            List<Attached_Inclusions__c> attachInclusionLst = [Select id, Name,Publishing_Inclusions__r.Id,Publishing_Inclusions__r.Full_Name_Formula__c,Selected_Inclusion_Detail__c,Text__c,RecordTypeId from Attached_Inclusions__c where Deal__c =: dealId ORDER BY Name ASC];
            //List<Attached_Inclusions__c> attachInclusionLst = [Select id, Name,Publishing_Inclusions__r.Name,Text__c,RecordTypeId from Attached_Inclusions__c where Deal__c =: dealId and RecordTypeId =: dealHighlightsRecordTypeID];
            System.debug('List of inclusions ='+attachInclusionLst.size());
            
            
            List<RecordTypeWrapper> rctWrapper = new List<RecordTypeWrapper>();    
            Map<String, Id> mapOfRecordTypeWithIds = TADUtils.getObjectNameRecordTypeId('Attached_Inclusions__c');
            
            dealData initObj = new dealData();
            Map<String,String> recordTypeMap = new Map<String,String>();
            for(String str : mapOfRecordTypeWithIds.keyset()){
                if(sObjName == 'Deal__c'){
                    initObj.isDealObject = true;
                    if(!str.containsIgnoreCase('/Room')){
                        RecordTypeWrapper rctWrapInstance = new RecordTypeWrapper();
                        rctWrapInstance.RecordTypeName = str;
                        rctWrapInstance.RecordTypeId = mapOfRecordTypeWithIds.get(str);
                        recordTypeMap.put(rctWrapInstance.RecordTypeId,rctWrapInstance.RecordTypeName);
                        rctWrapper.add(rctWrapInstance);
                    }
                }else{
                    initObj.isDealObject = false;
                    if(str.containsIgnoreCase('Room')){
                        RecordTypeWrapper rctWrapInstance = new RecordTypeWrapper();
                        rctWrapInstance.RecordTypeName = str;
                        rctWrapInstance.RecordTypeId = mapOfRecordTypeWithIds.get(str);
                        recordTypeMap.put(rctWrapInstance.RecordTypeId,rctWrapInstance.RecordTypeName);
                        rctWrapper.add(rctWrapInstance);
                    }
                }    
                initObj.countOfHighlightedInclusions = attachInclusionLst.size(); 
                initObj.highlightsRecordId = dealHighlightsRecordTypeID;
                
            }
            
            dealWraper.RecordTypeWrapper = rctWrapper;
            
            if(!attachInclusionLst.isEmpty()){
                for(Attached_Inclusions__c attachInclusionObj : attachInclusionLst){
                    initWrapper attachObj = new initWrapper();
                    attachObj.selectedRecordType = recordTypeMap.get(attachInclusionObj.RecordTypeId);
                    attachObj.selectedPublishedInclusions = attachInclusionObj.Publishing_Inclusions__r.Id;
                    attachObj.selectedPublishedInclusionsDetail = attachInclusionObj.Selected_Inclusion_Detail__c;
                    attachObj.selectedText = attachInclusionObj.Text__c;
                    attachObj.Id = attachInclusionObj.Id;
                       if(String.isBlank(attachObj.selectedPublishedInclusionsDetail)){
                          attachObj.isPublishInclusionSelected = 'BLANK';
                        }else{
                          attachObj.isPublishInclusionSelected = attachObj.selectedPublishedInclusionsDetail;
                        }

                        if(attachObj.selectedPublishedInclusionsDetail == null && attachObj.selectedPublishedInclusions !=null){
                        String splitField = attachInclusionObj.Publishing_Inclusions__r.Full_Name_Formula__c;
                        List<String> splitFieldBySpace = splitField.split(' ');
                        List<String> splitFutherImage = splitFieldBySpace[4].split('=');
                        String publishImage = splitFutherImage[1].replace('"','');
                        String imgURL = System.Label.Instance_Link+publishImage;
                        attachObj.isPublishInclusionSelected = attachObj.selectedPublishedInclusionsDetail;
                        attachObj.selectedPublishedInclusionsDetail = splitFieldBySpace[0] + ' , '+imgURL;
                    }
                    attachObj.isclone = false;
                    attachObj.isRecordBlank = false;
                    attachObj.toUpdateorInsert = true;
                    initWrapperLst.add(attachObj);
                }
                
            }else{
                initWrapper attachObj = new initWrapper();
                attachObj.selectedRecordType = 'Deal - Highlights';
                attachObj.selectedPublishedInclusions = null;
                attachObj.selectedPublishedInclusionsDetail= null;
                attachObj.selectedText = null;
                attachObj.Id = '';
                attachObj.isPublishInclusionSelected = 'BLANK';
                attachObj.isRecordBlank = false;
                attachObj.isclone = true;
                attachObj.toUpdateorInsert = true;
                initWrapperLst.add(attachObj); 
            }
            
            dealWraper.attachInclusionList = initWrapperLst;        
            
            return dealWraper;
            
        }catch(exception e){
            system.debug('Error while retriving DATA'+ e.getMessage());
            throw new AurahandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<picklistValues> getPicklistvalues(String objectName, String field_apiname){
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        List<picklistValues> ItinPickList = new List<picklistValues>();
        for (Schema.PicklistEntry pv : picklistValues) {
            picklistValues pv1 = new picklistValues();
            pv1.label=pv.getLabel();
            pv1.value=pv.getValue();
            ItinPickList.add(pv1);
        }
        
        return ItinPickList;
        
    }
    
    @AuraEnabled
    public static void SaveIteneries(List<mapIteneraryOrder> itenerariesOrderWrap , string dealId, list<iteneraryData> iteneraryDataToDelete ){
        
        system.debug('itenerariesOrderWrap:-'+ itenerariesOrderWrap);
        system.debug('iteneraryDataToDelete.itinorderlist:-'+ iteneraryDataToDelete);
        List<id> itinIdsToDelete = new List<id>(); 
        List<Itinerary__c> itinerariesToInsert = new List<Itinerary__c>();
        List<Itinerary__c> itinerariesToUpdate = new List<Itinerary__c>();  
        set<Id> itinIDToDeleteSet = new set<Id>();
        try{
            
            //FOR Insert Or Update Itinerary Data >>>>>>>>
            
            for(mapIteneraryOrder itinorderMap : itenerariesOrderWrap ){
                List<iteneraryData> itineriesList = itinorderMap.itinorderlist;
                for(iteneraryData itindata : itineriesList){
                    Itinerary__c itin = new Itinerary__c();
                    
                    //itindata.id = itin.id;
                    itin.Deal__c = dealId;
                    itin.Day_number__c =  itindata.day;
                    itin.title__c = itindata.title;
                    itin.body__c = itindata.description;
                    itin.accomodation__c = itindata.accommodation;
                    itin.Itinerary__c = itinorderMap.itinNumber;
                      if(String.isBlank(itindata.country)){
                        itin.country_context__c = 'AU';
                    }else{
                       itin.country_context__c = itindata.country; 
                    }
                    itin.Transfers__c = itindata.transfers;
                    //itin.itinerary_activity__c = itindata.activity; 
                    system.debug('itindata.isclone:- '+ itindata.isclone );
                    system.debug('itindata.toUpdateorInsert:- '+ itindata.toUpdateorInsert);
                    system.debug('itindata.selectedmeals:- '+itindata.selectedmeals );
                    
                    if((itindata.selectedmeals != null)){
                        if( itindata.selectedmeals.size() != 1 ){
                            
                            string itinMeals= '';
                            for(integer i=0; i<itindata.selectedmeals.size(); i++){
                                
                                if(i==0){
                                    itinMeals = itindata.selectedmeals.get(i);
                                }else{
                                    itinMeals =itinMeals+';'+   itindata.selectedmeals.get(i);
                                }
                            }
                            itin.Meals_Included__c = itinMeals;
                        }else{
                            itin.Meals_Included__c =itindata.selectedmeals.get(0) ;
                        }
                    }
                    
                    if(itindata.isclone != null && itindata.toUpdateorInsert != null){
                        if((itindata.isclone == true && itindata.toUpdateorInsert == true && itindata.isBlank == false) && (itindata.day != null ||  itindata.title != null || itindata.title != null || itindata.description != null || itindata.accommodation != null || !(itindata.selectedmeals.isEmpty())     )) {
                            system.debug('Itin to insert:- '+ itin );
                            itinerariesToInsert.add(itin);
                        }else if(itindata.isclone == false && itindata.toUpdateorInsert == true){
                            system.debug('Itin to Update:- '+ itin);
                            itin.id = itindata.id;
                            itinerariesToUpdate.add(itin);
                        }
                    }
                    
                    
                }
            }
            
            if(!itinerariesToInsert.isEmpty()){
                insert itinerariesToInsert;
            }
            if(!itinerariesToUpdate.isEmpty()){
                update itinerariesToUpdate;
            }
            
            //FOR Delete Itinerary Data>>>> 
            if(!iteneraryDataToDelete.isEmpty()){
                system.debug('inside iteneraryDataToDelete not empty '); 
                for(iteneraryData itinwrap: iteneraryDataToDelete ){
                    system.debug('itinwrap.id :-'+ itinwrap.id);
                    itinIdsToDelete.add(itinwrap.id);
                }    
            }
            if(!itinIdsToDelete.isEmpty()){
                List<Itinerary__c> itintoDelete = [SELECT id, name FROM Itinerary__c  WHERE id IN: itinIdsToDelete  AND deal__c =: dealId];
                system.debug('itintoDelete size:-'+ itintoDelete.size());
                if(!itintoDelete.isEmpty()){
                    for(Itinerary__c itin : itintoDelete){
                        itinIDToDeleteSet.add(itin.id);
                    }
                }
                
                List<Itinerary_Component_Join__c> itinCompJoinList = [SELECT Id, name FROM Itinerary_Component_Join__c WHERE Itinerary__c IN: itinIDToDeleteSet ];
                system.debug('itinCompJoinList size:-'+ itinCompJoinList.size());
                if(!itinCompJoinList.isEmpty()){
                    Delete itinCompJoinList;
                }
                if(!itintoDelete.isEmpty()){
                    delete itintoDelete;
                }
            }
            
            
            
        }catch(exception e){
            system.debug('Error In SaveIteneries :- '+ e.getMessage());
        }
    }
    
    @AuraEnabled
    public static iteneraryData saveSingleItinerary(iteneraryData itinrec, string dealId, string itinNumber){
        system.debug('itinrec:- '+ itinrec);
        Itinerary__c itin = new Itinerary__c();
        itin.Deal__c = dealId;
        itin.Day_number__c =  itinrec.day;
        itin.title__c = itinrec.title;
        itin.body__c = itinrec.description;
        itin.accomodation__c = itinrec.accommodation;
        itin.Itinerary__c = itinNumber;
        if(String.isBlank(itinrec.country)){
                itin.country_context__c = 'AU';
        }else{
                 itin.country_context__c = itinrec.country; 
         }
        //itin.country_context__c = itinrec.country;
        itin.Transfers__c = itinrec.transfers;
        //itin.itinerary_activity__c = itinrec.activity; 
        if(itinrec.selectedmeals !=null){
            if(itinrec.selectedmeals.size() != 1){
            
            string itinMeals= '';
            for(integer i=0; i<itinrec.selectedmeals.size(); i++){
                
                if(i==0){
                    itinMeals = itinrec.selectedmeals.get(i);
                }else{
                    itinMeals =itinMeals+';'+   itinrec.selectedmeals.get(i);
                }
            }
            itin.Meals_Included__c = itinMeals;
        }else{
            itin.Meals_Included__c =itinrec.selectedmeals.get(0) ;
        }
    }
        if((itinrec.isclone == true) && (itinrec.toUpdateorInsert == true) && (itinrec.isBlank == false)){
            insert itin;
            system.debug('newly inserted itin id:- '+ itin.id);
            itinrec.id = itin.id;
            
        } else if( (itinrec.isclone == false) && (itinrec.toUpdateorInsert == true)){
            
            itin.id = itinrec.id;
            update itin;
        }
        
        
        //itinrec.id = '';
        
        
        itinrec.isclone = false;
        itinrec.toUpdateorInsert = false;
        
        return itinrec;
        
    }
    
    
    /* @AuraEnabled
public static List <activitydata> getitinactivity (String searchKeyWord , string dealId ) {
List <activitydata> itinactivity = new list <activitydata> (); 
String searchKey = '%' +searchKeyWord + '%';
// String recordTypeParam = '%' +recordTypeValue + '%';
System.debug('searchKey'+searchKey);
List<Itinerary_Activity__c>  activity =[Select id , name from Itinerary_Activity__c where deal__c=: dealId AND  name LIKE: searchKey   LIMIT 10];

if(!activity.isEmpty()){
for(Itinerary_Activity__c act: activity ){
activitydata wrap = new activitydata();
wrap.id = act.id;
wrap.name = act.name;

itinactivity.add(wrap);
system.debug('itinactivity:- '+itinactivity);
}
}
if(!itinactivity.isEmpty()){
return itinactivity;    
}else{
return null;
}

}*/
    
    @AuraEnabled
    public static void updateDeal(dealData data , string fieldname){ 
        system.debug('data:- '+data );
        system.debug('fieldname:- '+ fieldname);
        
        deal__c deal = [SELECT Id, name, Summary__c, Summary_nz__c, Fine_Print__c, fine_print_nz__c  FROM deal__c WHERE id=: data.id limit 1];
        
        if(fieldname == 'Important Information'){
            deal.Fine_Print__c = data.importantinfoAU;
            deal.fine_print_nz__c = data.importantinfoNZ;
        }else if(fieldname == 'Overview'){
            deal.Summary__c = data.summaryAU;
            deal.Summary_nz__c = data.summaryNZ;
        }
        update deal;
        
        
        
    }
    
    @AuraEnabled
    public static void savetours(List<tourInclusion> tourlist , List<tourInclusion> toursToDelete , string dealId ){
        system.debug('tourlist:- '+ tourlist);
        system.debug('toursToDelete:- '+ toursToDelete);
        List<tour_inclusions__c> ToInsertList = new List<tour_inclusions__c>();
        List<tour_inclusions__c> ToUpdateList = new List<tour_inclusions__c>();
        List<tour_inclusions__c> ToDeleteList = new List<tour_inclusions__c>();
        
        TRY{
            //For Tours to Upsert
            for(tourInclusion tour: tourlist){
                tour_inclusions__c tourInclusion = new tour_inclusions__c();
                tourInclusion.body__c = tour.description;
                tourInclusion.Deal__c = dealId;
                tourInclusion.order__c = tour.order;
                tourInclusion.title__c = tour.title;
                
                system.debug('tour.selectedsite480:- '+ tour);
                if(tour.selectedsite!=null){
                    string site = '';
                    for(integer i=0; i<tour.selectedsite.size(); i++){
                        site = site +';'+tour.selectedsite[i];
                    }
                    tourInclusion.site__c = site;
                }else{ 
                    system.debug('inside else');
                    tourInclusion.site__c = 'AU';
                }
                
                if(tour.isclone != null && tour.toUpdateorInsert != null && tour.isBlank == false ){
                    
                    if(tour.isclone == true && tour.toUpdateorInsert == true ){
                        ToInsertList.add(tourInclusion);
                        
                    }else if(tour.isclone == false && tour.toUpdateorInsert == true){
                        tourInclusion.id = tour.id;
                        ToUpdateList.add(tourInclusion);
                    }
                }
                
                
            }
            if(!ToInsertList.isEmpty()){
                system.debug('ToInsertList.size:- '+ ToInsertList.size());
                insert ToInsertList;
            }
            if(!ToUpdateList.isEmpty()){
                system.debug('ToUpdateList.size:- '+ ToUpdateList.size());
                update ToUpdateList;
            }
            
            //For Tours to Delete
            
            set<ID> tourIdsToDelete = new set<Id>();
            for(tourInclusion data : toursToDelete ){
                tourIdsToDelete.add(data.id);
            }
            
            List<tour_inclusions__c> toursToDeleteList = [SELECT ID, name FROM tour_inclusions__c WHERE ID IN: tourIdsToDelete ];
            if(!toursToDeleteList.isEmpty()){
                system.debug('toursToDeleteList.size:- '+ toursToDeleteList.size());
                Delete toursToDeleteList;
            }
            
        }catch(exception e){
            system.debug('Error In Tour'+ e.getMessage());
            throw new AurahandledException(e.getMessage());
            
        }
    }
    
    @AuraEnabled
    public static void saveAttachInclusions(List<initWrapper> inclusionList , List<initWrapper> inclusionListToDelete , string dealId ){
        List<Attached_Inclusions__c	> ToInsertList = new List<Attached_Inclusions__c>();
        List<Attached_Inclusions__c	> ToUpdateList = new List<Attached_Inclusions__c>();
        List<Attached_Inclusions__c	> ToDeleteList = new List<Attached_Inclusions__c>();
        
        TRY{
            
            set<ID> attachIdsToDelete = new set<Id>();
            for(initWrapper data : inclusionListToDelete ){
                attachIdsToDelete.add(data.id);
            }
            
            List<Attached_Inclusions__c> attachInclusionToDeleteList = [Select id, Name,Publishing_Inclusions__c,Text__c,RecordTypeId from Attached_Inclusions__c WHERE ID IN: attachIdsToDelete ];
            if(!attachInclusionToDeleteList.isEmpty()){
                system.debug('toursToDeleteList.size:- '+ attachInclusionToDeleteList.size());
                Delete attachInclusionToDeleteList;
            }
            
            for(initWrapper inc: inclusionList){
                if(inc.selectedRecordType == null && inc.selectedPublishedInclusions == null &&  inc.selectedPublishedInclusionsDetail == null && inc.selectedText == null){
                    
                }else{
                    Attached_Inclusions__c attach = new Attached_Inclusions__c();
                    String recordtypeID = '';
                    if(inc.selectedRecordType == null){
                        recordtypeID = Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();             
                        
                    }else{
                        recordtypeID = Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get(inc.selectedRecordType).getRecordTypeId();             
                    }                attach.RecordTypeId = recordtypeID;
                    attach.RecordTypeId = recordtypeID;
                    attach.Publishing_Inclusions__c	 = inc.selectedPublishedInclusions;    
                    attach.Selected_Inclusion_Detail__c = inc.selectedPublishedInclusionsDetail;
                    attach.Text__c = inc.selectedText;
                    attach.Description__c = inc.selectedText;//DP-92    
                    attach.Deal__c = dealId;          
                    //attach.Id = inc.Id;             
                    
                    if(inc.isclone != null && inc.toUpdateorInsert != null ){
                        
                        if(inc.isclone == true && inc.toUpdateorInsert == true && inc.isRecordBlank == false){
                            ToInsertList.add(attach);
                            
                        }else if(inc.isclone == false && inc.toUpdateorInsert == true && inc.isRecordBlank == false){
                            attach.Id = inc.Id;
                            ToUpdateList.add(attach);
                        }
                    }
                    
                }
                
                
            }
            if(!ToInsertList.isEmpty()){
                system.debug('ToInsertList.size:- '+ ToInsertList.size());
                insert ToInsertList;
            }
            if(!ToUpdateList.isEmpty()){
                system.debug('ToUpdateList.size:- '+ ToUpdateList.size());
                update ToUpdateList;
            }       
            
        }catch(exception e){
            system.debug('Error In Tour'+ e.getMessage());
            throw new AurahandledException(e.getMessage());
            
        }
    }
    
    @AuraEnabled
    public static tourInclusion savesingletour (tourInclusion tourdata, string dealId){
        system.debug('tourdata:- '+ tourdata);
        system.debug('dealId:- '+ dealId);
        
        tour_inclusions__c tour = new tour_inclusions__c();
        tour.Deal__c = dealId;
        tour.title__c = tourdata.title;
        tour.body__c = tourdata.description;
        tour.order__c = tourdata.order;
        if(tourdata.selectedsite != null){
            string site ='';
            for(integer i=0;i<tourdata.selectedsite.size() ; i++){
                if(i == 0 ){
                    site = tourdata.selectedsite[i];
                }else {
                    site = site + ';' + tourdata.selectedsite[i];     
                }          
            }
            tour.site__c = site;
        }else if (tourdata.selectedsite == null){
            tour.site__c = 'AU';
        }
        if(tourdata.isclone == true && tourdata.toUpdateorInsert == true && tourdata.isBlank == false){
            insert tour;
            tourdata.id= tour.id ; 
        }else if(tourdata.isclone == false && tourdata.toUpdateorInsert == true){
            tour.id = tourdata.id; 
            update tour;
        }
        tourdata.isclone = false;
        tourdata.toUpdateorInsert = false;
        return tourdata;
        
    }
    
    @AuraEnabled
    public static void saveproperty(List<aboutTheProperty> propertylist , List<aboutTheProperty> propertiesToDelete , string dealId ){
        system.debug('tourlist:- '+ propertylist);
        system.debug('toursToDelete:- '+ propertiesToDelete);
        List<About_The_Property__c> ToInsertList = new List<About_The_Property__c>();
        List<About_The_Property__c> ToUpdateList = new List<About_The_Property__c>();
        List<About_The_Property__c> ToDeleteList = new List<About_The_Property__c>();
        
        TRY{
            //For Tours to Upsert
            for(aboutTheProperty data: propertylist){
                About_The_Property__c property = new About_The_Property__c();
                property.Description__c = data.description;
                property.Deal__c = dealId;
                property.order__c = data.order;
                property.title__c = data.title;
                
                system.debug('data.selectedsite:- '+ data);
                if(data.selectedsite!=null){
                    string site = '';
                    for(integer i=0; i<data.selectedsite.size(); i++){
                        site = site +';'+data.selectedsite[i];
                    }
                    property.site__c = site;
                }else{ 
                    system.debug('inside else');
                    property.site__c = 'AU';
                }
                
                if(data.isclone != null && data.toUpdateorInsert != null ){
                    
                    if(data.isclone == true && data.toUpdateorInsert == true && data.isBlank == false ){
                        ToInsertList.add(property);
                        
                    }else if(data.isclone == false && data.toUpdateorInsert == true){
                        property.id = data.id;
                        ToUpdateList.add(property);
                    }
                }
                
                
            }
            if(!ToInsertList.isEmpty()){
                system.debug('ToInsertList.size:- '+ ToInsertList.size());
                insert ToInsertList;
            }
            if(!ToUpdateList.isEmpty()){
                system.debug('ToUpdateList.size:- '+ ToUpdateList.size());
                update ToUpdateList;
            }
            
            //For Tours to Delete
            
            set<ID> propertyIdsToDelete = new set<Id>();
            for(aboutTheProperty data : propertiesToDelete ){
                propertyIdsToDelete.add(data.id);
            }
            
            List<About_The_Property__c> propertiesToDeleteList = [SELECT ID, name FROM About_The_Property__c WHERE ID IN: propertyIdsToDelete ];
            if(!propertiesToDeleteList.isEmpty()){
                system.debug('propertiesToDeleteList.size:- '+ propertiesToDeleteList.size());
                Delete propertiesToDeleteList;
            }
            
        }catch(exception e){
            system.debug('Error In Tour'+ e.getMessage());
            throw new AurahandledException(e.getMessage());
            
        }
    }
    
    @AuraEnabled
    public static aboutTheProperty saveSingleProperty(aboutTheProperty propertydata, string dealId){
        system.debug('propertydata:- '+ propertydata);
        system.debug('dealId:- '+ dealId);
        List<string> propertySite = new List<string>();
        
        About_The_Property__c property = new About_The_Property__c();
        property.Deal__c = dealId;
        property.title__c = propertydata.title;
        property.Description__c = propertydata.description;
        property.order__c = propertydata.order;
        if(propertydata.selectedsite != null){
            string site ='';
            for(integer i=0;i<propertydata.selectedsite.size() ; i++){
                if(i == 0 ){
                    site = propertydata.selectedsite[i];
                }else {
                    site = site + ';' + propertydata.selectedsite[i];     
                }          
            }
            property.site__c = site;
        }else if (propertydata.selectedsite == null){
            property.site__c = 'AU';
        }
        if(propertydata.isclone == true && propertydata.toUpdateorInsert == true && propertydata.isBlank == false ){
            insert property;
            propertydata.id= property.id ; 
        }else if(propertydata.isclone == false && propertydata.toUpdateorInsert == true){
            property.id = propertydata.id; 
            update property;
        }
        
        About_The_Property__c prop = [SELECT ID, site__c, name FROM About_The_Property__c WHERE ID =: propertydata.id LIMIT 1 ];
        
        if(prop.site__c != null){ 
            system.debug('prop.site__c:- '+prop.site__c);
            if(prop.site__c.contains(';')){
                
                propertySite.addAll(prop.site__c.split(';'));
            }else{
                propertySite.add(prop.site__c);
            }
        }
        propertydata.name = prop.Name;
        propertydata.selectedsite = propertySite;
        propertydata.isclone = false;
        propertydata.toUpdateorInsert = false;
        
        return propertydata;
    }
    
    //DP-56, DP-57 start
    @AuraEnabled
    public static void saveDealHistory (string dealId, string AnalystOrBDM){
        
        Deal__c dealdata = [SELECT ID, name, description__c, title__c, Deal_KSP__c, Summary_nz__c, Summary__c, Fine_Print__c, fine_print_nz__c, BDM_finalized__c, Analyst_finalized__c  FROM Deal__c WHERE ID =: dealId LIMIT 1];
        
        List<Deal_Build_History__c> DBHListToInsert = new List<Deal_Build_History__c>(); 
        
        if(AnalystOrBDM == 'BDM'){
            dealdata.BDM_finalized__c = true;
        }else if(AnalystOrBDM == 'Analyst' ){
            dealdata.Analyst_finalized__c = true;
        }
        
        update dealdata; 
        
        List<Itinerary__c> itinList = [SELECT ID, name, Deal__c, accomodation__c, title__c, Meals_Included__c, body__c, Day_number__c, Itinerary__c, itinerary_activity__c,	Transfers__c, country_context__c FROM Itinerary__c WHERE   Deal__c =:dealId  ORDER BY Day_number__c];
        system.debug('itinList.size :- '+ itinList.size());
        List<tour_inclusions__c> tourData = [SELECT id, name, Deal__c, body__c, order__c, site__c, title__c FROM tour_inclusions__c WHERE   Deal__c =:dealId ORDER BY order__c];
        List<About_The_Property__c> propertyList = [SELECT ID, name, Deal__c, Title__c, Description__c , site__c, Order__c FROM About_The_Property__c WHERE Deal__c =:dealId  ORDER BY Order__c];
        List<Attached_Inclusions__c> attachInclusionList = [Select id, Name,Publishing_Inclusions__r.Id,Selected_Inclusion_Detail__c,Text__c,RecordTypeId from Attached_Inclusions__c  where Deal__c =: dealId];
        Map<String, Id> mapOfRecordTypeWithIds = TADUtils.getObjectNameRecordTypeId('Attached_Inclusions__c');
        
        Map<String,String> recordTypeMap = new Map<String,String>();
        for(String str : mapOfRecordTypeWithIds.keyset()){
            recordTypeMap.put(mapOfRecordTypeWithIds.get(str),str);
        }
        
        Deal_Build_History__c  DealHistoryDeal = new Deal_Build_History__c();
        DealHistoryDeal.Deal__c = dealId;
        DealHistoryDeal.History_Saved_By__c = AnalystOrBDM;
        DealHistoryDeal.Type_of_Record__c = 'Deal';
        DealHistoryDeal.hi_Deal_highlights__c = (dealdata.description__c == null) ? null : dealdata.description__c; 
        DealHistoryDeal.hi_Deal_title__c = (dealdata.title__c == null) ? null : dealdata.title__c;
        DealHistoryDeal.ii_Description__c = (dealdata.Fine_Print__c == null) ? null : dealdata.Fine_Print__c;
        DealHistoryDeal.Overview__c = (dealdata.Summary__c == null) ? null : dealdata.Summary__c;
        DBHListToInsert.add(DealHistoryDeal);
        /*<<<<<<< Attached Inclusion History >>>>>>>>*/
        
        for(integer i=0; i<attachInclusionList.size() ;i++){
            //DBHListToInsert
            Deal_Build_History__c DealHistory = new Deal_Build_History__c();
            DealHistory.Deal__c = dealId;
            DealHistory.History_Saved_By__c = AnalystOrBDM;
            DealHistory.Type_of_Record__c = 'Attach Inclusion';
            DealHistory.ai_selectedPublishedInclusionsDetail__c = ((attachInclusionList[i].Selected_Inclusion_Detail__c == null)?'null': attachInclusionList[i].Selected_Inclusion_Detail__c);
            DealHistory.ai_PublishingInclusion__c = ((attachInclusionList[i].Publishing_Inclusions__c == null) ?'null' : attachInclusionList[i].Publishing_Inclusions__r.Id);
            DealHistory.ai_Recordtype__c = recordTypeMap.get(attachInclusionList[i].RecordTypeId);
            DealHistory.ai_Text__c = ((attachInclusionList[i].Text__c == null) ? 'null' : attachInclusionList[i].Text__c);
            DBHListToInsert.add(DealHistory);
        }
        
        
        /*<<<<<<< Itinerary  History >>>>>>>>*/
        
        for(integer i = 0 ; i< itinList.size(); i++){
            Deal_Build_History__c DealHistory = new Deal_Build_History__c();
            DealHistory.Deal__c = dealId;
            DealHistory.History_Saved_By__c = AnalystOrBDM;
            DealHistory.Type_of_Record__c = 'Itinerary';
            DealHistory.in_name__c =itinList[i].name  ;
            DealHistory.in_accommodation__c = ((itinList[i].accomodation__c == null) ? 'null' : itinList[i].accomodation__c)  ;
            DealHistory.in_country_context__c = ((itinList[i].country_context__c ==  null) ? 'null' : itinList[i].country_context__c);
            DealHistory.in_Day__c =  ((itinList[i].Itinerary__c == null) ? 'null' : (itinList[i].Itinerary__c)) +';'+((itinList[i].Day_number__c == null) ? 'null' : string.valueof(itinList[i].Day_number__c)) ;
            DealHistory.in_description__c = ((itinList[i].body__c == null)?'null' : itinList[i].body__c);
            DealHistory.in_inclusions__c = ((itinList[i].Meals_Included__c == null) ? 'null' : itinList[i].Meals_Included__c);
            DealHistory.in_itinerary_activity__c = ((itinList[i].itinerary_activity__c == null)? 'null' : itinList[i].itinerary_activity__c);
            DealHistory.in_itinerary_title__c = ((itinList[i].title__c == null)? 'null' : itinList[i].title__c);
            DealHistory.in_transfers__c = ((itinList[i].Transfers__c == null) ? 'null' : itinList[i].Transfers__c);    
            DBHListToInsert.add(DealHistory);
            
        }
        
        /*<<<<<<< Tour inclusion History >>>>>>>*/
        
        for(integer i = 0 ; i< tourData.size(); i++){
            Deal_Build_History__c DealHistory = new Deal_Build_History__c();
            DealHistory.Deal__c = dealId;
            DealHistory.History_Saved_By__c = AnalystOrBDM;
            DealHistory.Type_of_Record__c = 'Tour Inclusion';
            DealHistory.ti_name__c = tourData[i].name;
            DealHistory.ti_Description__c = ((tourData[i].body__c == null) ? 'null' : tourData[i].body__c)  ;
            DealHistory.ti_Order__c = ((tourData[i].order__c ==  null) ? 'null' : string.valueof(tourData[i].order__c));
            DealHistory.ti_Site__c=  ((tourData[i].site__c == null) ? 'null' : tourData[i].site__c) ;
            DealHistory.ti_Title__c = ((tourData[i].title__c == null)?'null' : tourData[i].title__c);
            DBHListToInsert.add(DealHistory);
        }
        
        /* <<<<<<< About the Property History >>>>>>>>*/
        
        // List<About_The_Property__c> propertyList = [SELECT ID, name, Deal__c, Title__c, Description__c , site__c, Order__c FROM About_The_Property__c WHERE Deal__c =:dealId  ORDER BY Order__c
        for(integer i = 0 ; i< propertyList.size(); i++){
            Deal_Build_History__c DealHistory = new Deal_Build_History__c();
            DealHistory.Deal__c = dealId;
            DealHistory.History_Saved_By__c = AnalystOrBDM;
            DealHistory.Type_of_Record__c = 'About the Property';
            DealHistory.ap_name__c = propertyList[i].name;
            DealHistory.ap_Description__c = ((propertyList[i].Description__c == null) ? 'null' : propertyList[i].Description__c) ;
            DealHistory.ap_Order__c = ((propertyList[i].Order__c ==  null) ? 'null' : string.valueof(propertyList[i].Order__c)) ;
            DealHistory.ap_Site__c =  ((propertyList[i].site__c == null) ? 'null' : propertyList[i].site__c) ;
            DealHistory.ap_Title__c = ((propertyList[i].Title__c == null)?'null' : propertyList[i].Title__c);
            DBHListToInsert.add(DealHistory);
        }
        
        if(!DBHListToInsert.isEmpty()){
            system.debug('DealHistory inserted size():- '+ DBHListToInsert.size());
            insert DBHListToInsert;
        }        
    }
    
    
    @AuraEnabled
    public static finalizedData ShowFinalizedDealData(string AnalystOrBDM, string dealId){
        system.debug(' AnalystOrBDM:- '+ AnalystOrBDM);
        system.debug(' dealId:- '+ dealId);
        
        try{
            List<Deal_Build_History__c> dealHistory = [SELECT name,Type_of_Record__c, id, ai_selectedPublishedInclusionsDetail__c, ai_PublishingInclusion__c, ai_Recordtype__c, ai_Text__c, hi_Deal_highlights__c, hi_Deal_title__c, History_Saved_By__c, ii_Description__c, in_name__c, in_accommodation__c, in_country_context__c, in_Day__c, in_description__c, in_inclusions__c, in_itinerary_activity__c, in_itinerary_title__c, in_transfers__c, Overview__c, ti_name__c, ti_Description__c, ti_Order__c, ti_Site__c, ti_Title__c, ap_name__c, ap_Description__c, ap_Order__c, ap_Site__c, ap_Title__c FROM Deal_Build_History__c  WHERE History_Saved_By__c =:AnalystOrBDM AND deal__c =:dealId  ]; 
            
            system.debug(' dealHistory.size:- '+ dealHistory.size());
            finalizedData data = new finalizedData();
            List<iteneraryData> itintempList = new List<iteneraryData>(); 
            List<mapIteneraryOrder> itinerariesOrderMap = new List<mapIteneraryOrder>();
            List<tourInclusion> tourdata = new List <tourInclusion>();
            List<aboutTheProperty> propertyData = new List<aboutTheProperty>();
            List<initWrapper> attachedInclusiondata = new List<initWrapper>();
            Map<string , List<iteneraryData>> ItinOrderMap = new Map<string, List<iteneraryData>>();
            
            
            for(Deal_Build_History__c DBH : dealHistory){
                if(DBH.Type_of_Record__c == 'Itinerary'){
                    List<string> selectedmeals = new List<string>();
                    iteneraryData itin = new iteneraryData();
                    //itin.id = itin.id;
                   itin.name = DBH.in_name__c;
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
                            //system.debug('itin.Meals_Included__c:- '+ itin.Meals_Included__c);
                            selectedmeals.add(DBH.in_inclusions__c);
                        }
                    }
                    itin.selectedmeals = selectedmeals;
                    
                    itintempList.add(itin);
                    
                    List<iteneraryData> emptyItinList = new List<iteneraryData>();
                    ItinOrderMap.put(itin.order , emptyItinList);
                    system.debug('1219:- '+ ItinOrderMap);
                }
                
                if(DBH.Type_of_Record__c == 'Attach Inclusion'){
                    initWrapper AtIn = new initWrapper();
                    AtIn.selectedRecordType = DBH.ai_Recordtype__c;
                    AtIn.selectedPublishedInclusions = ((DBH.ai_PublishingInclusion__c =='null')? null : DBH.ai_PublishingInclusion__c);
                    AtIn.selectedText = ((DBH.ai_Text__c == 'null') ?null : DBH.ai_Text__c);
                    AtIn.selectedPublishedInclusionsDetail  = ((DBH.ai_selectedPublishedInclusionsDetail__c == 'null')?null : DBH.ai_selectedPublishedInclusionsDetail__c);
                    attachedInclusiondata.add(AtIn);
                    
                }
                
                if(DBH.Type_of_Record__c == 'Tour Inclusion'){                    
                    List<string> toursite = new List<string>();
                    tourInclusion tempTour = new tourInclusion();
                    // ti_Description__c, ti_Order__c, ti_Site__c, ti_Title__c
                    tempTour.name = DBH.ti_name__c;
                    tempTour.title = (DBH.ti_Title__c == 'null') ? null : DBH.ti_Title__c;
                    tempTour.order = (DBH.ti_Order__c == 'null') ? null : integer.valueOf(DBH.ti_Order__c);
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
                    
                }if(DBH.Type_of_Record__c == 'About the Property'){
                    
                     //ap_Description__c, ap_Order__c, ap_Site__c, ap_Title__c
                    List<string> proprtysite = new List<string>();
                    aboutTheProperty tempProperty = new aboutTheProperty();
                    tempProperty.name = DBH.ap_name__c;
                    tempProperty.title = ((DBH.ap_Title__c == 'null') ? null : DBH.ap_Title__c);
                    tempProperty.description = ((DBH.ap_Description__c == 'null') ? null : DBH.ap_Description__c);
                    tempProperty.order =((DBH.ap_Order__c == 'null') ? null :  integer.valueOf(DBH.ap_Order__c));
                    
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
                    
                }if(DBH.Type_of_Record__c == 'Deal'){
                    data.importantinfoAU = (DBH.ii_Description__c==null)?null : DBH.ii_Description__c ;
                    data.summaryAU = (DBH.Overview__c==null)?null : DBH.Overview__c ;
                    data.highlights = (DBH.hi_Deal_highlights__c==null)?null : DBH.hi_Deal_highlights__c ;
                    data.dealtitle = (DBH.hi_Deal_title__c==null)?null : DBH.hi_Deal_title__c ;
                }
            }
            
            for(iteneraryData itin : itintempList ){
                    if(ItinOrderMap.containsKey(itin.order)){
                        List<iteneraryData> itinList =  ItinOrderMap.get(itin.order);
                        itinList.add(itin);
                        ItinOrderMap.put(itin.order , itinList );
                    }
                }
                system.debug('1289:- '+ ItinOrderMap);
            
                for(string key : ItinOrderMap.keySet()){
                    mapIteneraryOrder itinmap = new mapIteneraryOrder();
                    itinmap.itinNumber = key;
                    itinmap.itinorderlist = ItinOrderMap.get(key);
                    itinerariesOrderMap.add(itinmap);
                }
            
            
            //hi_Deal_highlights__c, hi_Deal_title__c, History_Saved_By__c, ii_Description__c, Overview__c
            
            data.iteneraries = itinerariesOrderMap;
            data.tours = tourdata;
            data.properties = propertyData;
            data.attachInclusionList = attachedInclusiondata; 
            
            
            
            return data;
        }catch(exception e){
            system.debug('error finalized:- '+ e.getMessage());
            throw e;
        }
    }
    //DP-56, DP-57 End
    
    @AuraEnabled
    public static List<String> saveHighlights (String title, String description, string dealId){
        List<String> highlightLst = new List<String>();
		Deal__c deal = new Deal__c();
        deal.title__c = title;
        deal.description__c = description;
        deal.id  = dealId;
       	update deal;
        
        highlightLst.add(title);
        highlightLst.add(description);
        return highlightLst;
    }
    
    //DP-54 start
    @AuraEnabled
    public static void CloneDealItineraries (string DailIdtoClonedFrom , string DailIdtoClonedTO ){
        system.debug('DailIdtoClonedFrom :-> ' + DailIdtoClonedFrom + '  <<< DailIdtoClonedTO >> : '+ DailIdtoClonedTO);
        
        Map<Id , List<Itinerary__c>> dealItineraryMap = New Map<Id , List<Itinerary__c>>();
        List<Itinerary__c> ItinerariseToinsert = new List<Itinerary__c>();
        
        for(integer i=0; i<2 ; i++ ){
            List<Itinerary__c> itinList = new List<Itinerary__c>();
            if(i==0){
                dealItineraryMap.put(DailIdtoClonedFrom , itinList );
            }else if(i==1){
                dealItineraryMap.put(DailIdtoClonedTO , itinList );
            }
        }
        
        List<Itinerary__c> itinList = [SELECT ID, name, Deal__c, accomodation__c, title__c, Meals_Included__c, body__c, Day_number__c, Itinerary__c, itinerary_activity__c,	Transfers__c, country_context__c FROM Itinerary__c WHERE   Deal__c In:dealItineraryMap.keySet()    ORDER BY Day_number__c];
        
        for(Itinerary__c itin:itinList ){
            List <Itinerary__c> itinListtoMap =  dealItineraryMap.get(itin.Deal__c);
            
            itinListtoMap.add(itin);
            dealItineraryMap.put(itin.Deal__c , itinListtoMap);
            
        }
        
        /*<<<<<<< Delete Existing Itineraries from " DailIdtoClonedTO "  >>>>>>>>*/
        
        if(!dealItineraryMap.get(DailIdtoClonedTO).isEmpty()){
            Set<ID> itinIdsToDelete = new Set<ID>();
            for(Itinerary__c itin: dealItineraryMap.get(DailIdtoClonedTO)){
                itinIdsToDelete.add(itin.id);
            }
            List<Itinerary_Component_Join__c> itinCompJoinList = [SELECT Id, name FROM Itinerary_Component_Join__c WHERE Itinerary__c IN: itinIdsToDelete ];
            system.debug('itinCompJoinList size:-'+ itinCompJoinList.size());
            if(!itinCompJoinList.isEmpty()){
                Delete itinCompJoinList;
            }
            
            DELETE dealItineraryMap.get(DailIdtoClonedTO);
        }
        
        /*<<<<<<< Clone All the Itineraries of "DailIdtoClonedFrom" to "DailIdtoClonedTO"  >>>>>>>>*/
        
        if(!dealItineraryMap.get(DailIdtoClonedFrom).isEmpty()){
            for(Itinerary__c itin: dealItineraryMap.get(DailIdtoClonedFrom) ){
                Itinerary__c clonedItinerary = itin.clone(false, true, false, false);
                clonedItinerary.itinerary_activity__c = null;
                clonedItinerary.Deal__c = DailIdtoClonedTO;  
                ItinerariseToinsert.add(clonedItinerary);
            }    
        }
        if(!ItinerariseToinsert.isEmpty()){
            insert ItinerariseToinsert;
            system.debug('ItinerariseToinsert:- '+ ItinerariseToinsert);
        }    
    }
    //DP-54 End
    
}