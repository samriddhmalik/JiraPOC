public class AddOnTriggerHandler {
    
    public static Boolean runOnce = false;
    
    public static void addstatusUpdateForAeSbAccomodation(List<AddOn__c> newAddonList, Map<Id, AddOn__c> oldAddonMap, Map<Id,AddOn__c> newAddonMap ){
        for(AddOn__c addon : newAddonList){
            
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('mp_AE_SB_Accommodation').getRecordTypeId() && ( (oldAddonMap.get(addOn.id).AE_Nights__c != newAddonMap.get(addOn.Id).AE_Nights__c && newAddonMap.get(addOn.Id).AE_Nights__c > oldAddonMap.get(addOn.Id).AE_Nights__c) || (oldAddonMap.get(addOn.id).SB_Nights__c != newAddonMap.get(addOn.Id).SB_Nights__c && newAddonMap.get(addOn.Id).SB_Nights__c > oldAddonMap.get(addOn.Id).SB_Nights__c)) ){
                system.debug('addon '+addon);	
                addon.AddOn_Status__c = 'On Hold';                
            }
        }
        
    }
    /* PSAG-379-attach general pricing to addon when created*/
    public Static void attachGeneralPricing(List<AddOn__c> addOnRecords){
        Set<Id> landActivityIds = new Set<Id>();
        Set<Id> aesbIds = new Set<Id>();
        Set<Id> airlineUpgradeIds = new Set<Id>();
        Set<Id> stopoverIds = new Set<Id>();
        Map<String,String> landActivityMap = new Map<String,String>();
        Map<String,String> airlineUpgradeMap = new Map<String,String>();
        Map<String,String> stopoverMap = new Map<String,String>();
        Map<String,String> aesbMap = new Map<String,String>();
        for(AddOn__c addOn :addOnRecords){
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId()){
                landActivityIds.add(addon.land_activity__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId()){
                aesbIds.add(addon.AE_SB__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId()){
                airlineUpgradeIds.add(addon.Airline_Upgrade__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId()){
                stopoverIds.add(addon.Sub_Stopover__c);
            }
        }
        List<General_Pricing__c> gpRecords = [Select id ,Land_Activity__c,Airline_Upgrade__c,Sub_Stopover__c,AE_SB__c, name,LA_Solo_Price__c,LA_Twin_Price__c from General_Pricing__c where (Land_Activity__c IN:landActivityIds or AE_SB__c IN:aesbIds or Airline_Upgrade__c IN: airlineUpgradeIds or Sub_Stopover__c IN:stopoverIds) and Active__c=true ];        
        for(General_Pricing__c gp : gpRecords){
            if(gp.Land_Activity__c !=null){
              landActivityMap.put(gp.Land_Activity__c,gp.id); 
            }
            if(gp.Airline_Upgrade__c !=null){
                airlineUpgradeMap.put(gp.Airline_Upgrade__c,gp.id); 
            }
            if(gp.Sub_Stopover__c !=null){
                stopoverMap.put(gp.Sub_Stopover__c,gp.id);
            }
            if(gp.AE_SB__c !=null){
                aesbMap.put(gp.AE_SB__c,gp.id); 
            }
        }
        for(AddOn__c addOn :addOnRecords){
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId()){
                addon.General_Pricing__c = landActivityMap.get(addon.land_activity__c);
            }
             if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId()){
                addon.General_Pricing__c = aesbMap.get(addon.AE_SB__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId()){
                addon.General_Pricing__c = airlineUpgradeMap.get(addon.Airline_Upgrade__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId()){
                addon.General_Pricing__c = stopoverMap.get(addon.Sub_Stopover__c);
            }
           }
        }
    /* PSAG-379-End*/
    public static void addOnAmountFinancials( List<AddOn__c>  newAddOn , Map<id,AddOn__c> newAddOnMap)  {
        // Map<id,AddOn__c> newAddOnMap = (Map<id,AddOn__c>)JSON.deserialize(newAddOnMapString, Map<id,AddOn__c>.class);
        //List<AddOn__c>  newAddOn = (List<AddOn__c>)JSON.deserialize(newAddOnString, List<AddOn__c>.class);
        
        Set<ID> addOnIds = new Set<ID>();
        List<AddOn__c> addOnToUpdate = new List<AddOn__c>(); 
        Map<Id,TAD_Order__c> orderToUpdateMap = new Map<Id,TAD_Order__c> ();
        
        Set<ID> AESBIds = new Set<ID>();
        Set<ID> airlineUpgradeIds = new Set<ID>();
        Set<ID> stopoverIds = new Set<ID>();
        Set<ID> landActivityIds = new Set<ID>();
        Set<ID> AESBAccomIds = new Set<ID>();
        set<id> oliIds=new set<id>();
        set<id> gpIds=new set<id>();
        map<id,Date> preDate=new map<id,Date>();
        map<id,Date> postDate=new map<id,Date>();
        map<id,Date> departureDate=new map<id,Date>();
        map<id,Date> returnDate=new map<id,Date>();        
        Map<ID,AE_SB__c> AESBMap = new Map<ID,AE_SB__c>();
        Map<ID,General_Pricing__c> gpMap = new Map<ID,General_Pricing__c>();//PSAG-379
        Map<ID,airline_upgrade__c> airlineUpgradeMap = new Map<ID,airline_upgrade__c>();
        Map<ID,sub_stopover__c> stopoverMap = new Map<ID,sub_stopover__c>();
        Map<ID,land_activity__c> landActivityMap = new Map<ID,land_activity__c>();
        Map<ID,mp_AE_SB_Accommodation__c> AESBAccomMap = new Map<ID,mp_AE_SB_Accommodation__c>();
        
        List<Enhanced_Pricing__c> AESBEnhancedPricings = new List<Enhanced_Pricing__c>();
        List<Enhanced_Pricing__c> StopOverEnhancedPricings = new List<Enhanced_Pricing__c>();
        
        
        for(AddOn__c addOn : newAddOn) {
            gpIds.add(addOn.General_Pricing__c);//PSAG-379
            AESBIds.add(addOn.AE_SB__c);
            airlineUpgradeIds.add(addOn.Airline_Upgrade__c);
            stopoverIds.add(addOn.Sub_Stopover__c);
            landActivityIds.add(addOn.land_activity__c);
            AESBAccomIds.add(addOn.AE_SB_Accommodation__c);
            
            oliIds.add(addOn.Order_Line_Item__c);
        }
        //PSAG-379-start
        if(!gpIds.isempty()){
            List<General_Pricing__c> gpList = [Select LA_Solo_Price__c,AE_SB_Price__c,LA_Twin_Price__c,Price_Airline_upgrade__c,Price_AUD__c,Price_NZD__c,Price_Airline_upgrade_NZD__c,Solo_Surcharge_AUD__c,Solo_Surcharge_NZD__c,Stopover_Solo_Price__c,Stopover_Twin_Price__c,Surcharge_AUD__c,Surcharge_NZD__c,Active__c from General_Pricing__c where id IN: gpIds];
            for(General_Pricing__c gp:gpList){
                gpMap.put(gp.Id,gp);
            }
        }//PSAG-379-end
        if(!oliIds.isempty()){
            List<Order_Line_Item__c> olis= [Select Id,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ordexp_TAD_Order__r.ordexp_departure_date__r.ordexp_return_date__c from Order_Line_Item__c where id in:oliIds];
            for(Order_Line_Item__c ol:olis){
                departureDate.put(ol.Id,(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c));
                returnDate.put(ol.Id,(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.ordexp_return_date__c));
                preDate.put(ol.Id,(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c-2));
                postDate.put(ol.Id,(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c+2));
            }
        }
        if(!AESBIds.isempty()){
            List<AE_SB__c> AESBList = [Select id,Blockout__c,price__c,price_nz__c from AE_SB__c where id IN: AESBIds ];
            AESBEnhancedPricings = [select Date_To__c, AE_SB__c, Date_From__c,Price_Solo__c,Price_Twin__c,Price__c from Enhanced_Pricing__c where AE_SB__c IN: AESBIds AND Active__c = true];
            System.debug('AESBEnhancedPricings'+AESBEnhancedPricings);
            for(AE_SB__c aesb : AESBList)
            {
                AESBMap.put(aesb.id,aesb);
            }
        }
        
        if(!airlineUpgradeIds.isempty()){
            List<airline_upgrade__c> airlineUpgradeList = [Select id,price__c,price_nz__c from airline_upgrade__c where id IN: airlineUpgradeIds ];
            for(airline_upgrade__c au : airlineUpgradeList)
            {
                airlineUpgradeMap.put(au.id,au);
            } 
        }
        
        if(!stopoverIds.isempty()){
            List<sub_stopover__c> stopoverList = [Select id,price__c,price_nz__c,Price_Solo__c,nights__c, Price_Solo_nz__c,Blockout__c, type__c from sub_stopover__c where id IN: stopoverIds ];
            StopOverEnhancedPricings = [select Date_To__c,Date_From__c, Sub_Stopover__c, Price_Solo__c,Price_Twin__c,Price__c from Enhanced_Pricing__c where sub_stopover__c IN: stopoverIds AND Active__c = true];
            System.debug('StopOverEnhancedPricings'+StopOverEnhancedPricings);
            for(sub_stopover__c ss : stopoverList)
            {
                stopoverMap.put(ss.id,ss);
            }
        }
        
        if(!landActivityIds.isempty()){
            List<land_activity__c> landActivityList = [Select id,price__c,price_nz__c,solo_price_nz__c,solo_price__c from land_activity__c where id IN: landActivityIds ];
            for(land_activity__c la : landActivityList)
            {
                landActivityMap.put(la.id,la);
            }
        }
        
        if(!AESBAccomIds.isempty()){
            List<mp_AE_SB_Accommodation__c> AESBAccomList = [Select id,mp_AE_SB__c,mp_AE_SB__r.Type__c,mp_Hotel_Name__c,mp_Name__c,mp_Price_Per_Night__c from mp_AE_SB_Accommodation__c where id IN: AESBAccomIds];
            for(mp_AE_SB_Accommodation__c Accom : AESBAccomList )
            {
                AESBAccomMap.put(Accom.id,Accom);
            }
        }
        
        //Get all RCT for Addons
        String landActRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.Land_Activity).getRecordTypeId();
        String subStopRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.SubStopover).getRecordTypeId();
        String AESBRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.AESB).getRecordTypeId();
        //  String SubStopover = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.STOPOVER).getRecordTypeId();
        //  String visaRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.VISA).getRecordTypeId();
        String insuranceRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.INSURANCE).getRecordTypeId();
        String airlineUpgradeRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.AIRLINEUPGRADE).getRecordTypeId();
        String tadTCRCT = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.TC).getRecordTypeId();
        String tadWTRCT = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByDeveloperName().get(TAD_Constants.WT).getRecordTypeId(); 
        String AESBAccomRCT = TAD_Constants.AESBAccom;
        /*PSAG - 45 Start
        Map<String,Wholesale_Commissions__c> wholesaleMap = new Map<String,Wholesale_Commissions__c>();
        String wtRecNames = TAD_Constants.WORLDTRAVELLERS+','+TAD_Constants.TRAVELLERSCHOICE; 
        List<Wholesale_Commissions__c> wholesaleList =[SELECT id,name,AE_SB__c,Airline_Upgrade__c,Deal__c,Departure_City_Surcharge__c,HSS__c,Land_Activities__c,Solo_Supplement__c,Stopover__c FROM Wholesale_Commissions__c where name in :wtRecNames.split(',')];
        for(Wholesale_Commissions__c ws : wholesaleList)
        {
            wholesaleMap.put(ws.name,ws);
        }
        PSAG - 45 Stop */
        for(AddOn__c addOndata :newAddOn){
            Boolean isEnhancedPricingExist = false;
            Double enhancedPrice= 0;
            // For Blockout Dates Check
             if((addOndata.RecordTypeId==AESBRCT && !String.isBlank(AESBMap.get(addOndata.AE_SB__c).Blockout__c)) || (addOndata.RecordTypeId==subStopRCT && !String.isBlank(stopoverMap.get(addOndata.Sub_Stopover__c).Blockout__c))){
                Date stopoverDate;
                Date AESBdate;
                String myInput;
                if(addOndata.RecordTypeId==AESBRCT && !String.isBlank(AESBMap.get(addOndata.AE_SB__c).Blockout__c)){
                    /* psag143 starts */
                    if(!AESBEnhancedPricings.isEmpty()){
                        for(Enhanced_Pricing__c ep :AESBEnhancedPricings){
                       if(addOndata.ordexp_new_aesb_date__c >= ep.Date_From__c && addOndata.ordexp_new_aesb_date__c <= ep.Date_To__c && addOndata.AE_SB__c == ep.AE_SB__c){
                          isEnhancedPricingExist = true;
                           enhancedPrice = ep.Price__c;
                               }
                           }
                    }
                    /* psag143 ends */
                    myInput = AESBMap.get(addOndata.AE_SB__c).Blockout__c;
                    AESBdate = addOndata.ordexp_new_aesb_date__c;
                }
               else if(addOndata.RecordTypeId==subStopRCT && !String.isBlank(stopoverMap.get(addOndata.Sub_Stopover__c).Blockout__c)){
                    myInput=stopoverMap.get(addOndata.Sub_Stopover__c).Blockout__c;
                    if(stopoverMap.get(addOndata.Sub_Stopover__c).type__c=='Pre Tour'){
                        //AESBdate=preDate.get(addOndata.Order_Line_Item__c);
                          //AESBdate = addOndata.ordexp_new_aesb_date__c;
                          stopoverDate = departureDate.get(addOndata.Order_Line_Item__c).addDays(-stopoverMap.get(addOndata.Sub_Stopover__c).nights__c.intValue());
                    }  
                    if(stopoverMap.get(addOndata.Sub_Stopover__c).type__c=='Post Tour'){
                        //AESBdate=postDate.get(addOndata.Order_Line_Item__c);
                        //AESBdate = addOndata.ordexp_new_aesb_date__c;
                        stopoverDate = returnDate.get(addOndata.Order_Line_Item__c).addDays(stopoverMap.get(addOndata.Sub_Stopover__c).nights__c.intValue());
                    }
                    if(!StopOverEnhancedPricings.isEmpty()){
                        for(Enhanced_Pricing__c ep :StopOverEnhancedPricings){
                            system.debug('ep'+ep);
                       if(stopoverDate >= ep.Date_From__c && stopoverDate <= ep.Date_To__c && addOndata.Sub_Stopover__c == ep.Sub_Stopover__c){
                          isEnhancedPricingExist = true;
                           enhancedPrice = addOndata.Pricing_Model__c == 'Solo' ? ep.Price_Solo__c : ep.Price_Twin__c;
                               }
                           }
                    }
                }
                String []  dates = myInput.split('\n');
                String passBlockout = System.label.Allow_Blockout_Date_for_Stop_Over;
                for(String line : dates){
                    if(line.contains('-')){
                        String []  moreDates = line.split('-');
                        String startDate = moreDates[0].deleteWhitespace();
                        String endDate = moreDates[1].deleteWhitespace();
                        if(startDate.length()==10 && endDate.length()==10){
                            if (!isEnhancedPricingExist && ((convertStringToDate(startDate) <= AESBdate && AESBdate <= convertStringToDate(endDate)) || (passBlockout == 'false' && (convertStringToDate(startDate) <= stopoverDate && stopoverDate <= convertStringToDate(endDate))))) {
                                addOndata.addError('This date falls under BlockOut dates: '+myInput); 
                            }
                        }
                    }
                    
                    else if(!isEnhancedPricingExist && (convertStringToDate(line) == AESBdate ||  (passBlockout == 'false' && convertStringToDate(line) == stopoverDate)))
                    {
                        addOndata.addError('This date falls under BlockOut dates: '+myInput); 
                    }
                    
                }  
            }
            /* psag143 ends */
            // BlockOut Date Ends
            
            
            // AESB Message on Order

            //Commented for PBP-257
            
            /*if(addOndata.RecordTypeId==AESBRCT){
                if(orderToUpdateMap.get(addOndata.TAD_Order_Id__c)==null){
                    TAD_Order__c tadOrder = new TAD_Order__c(id=addOndata.TAD_Order_Id__c);     
                    tadOrder.ordexp_aesb_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }else{
                    TAD_Order__c tadOrder  =   orderToUpdateMap.get(addOndata.TAD_Order_Id__c);
                    tadOrder.ordexp_aesb_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }
            }
            
            else if(addOndata.RecordTypeId==subStopRCT){
                if(orderToUpdateMap.get(addOndata.TAD_Order_Id__c)==null){
                    TAD_Order__c tadOrder = new TAD_Order__c(id=addOndata.TAD_Order_Id__c);     
                    tadOrder.ordexp_stopover_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }else{
                    TAD_Order__c tadOrder  =   orderToUpdateMap.get(addOndata.TAD_Order_Id__c);
                    tadOrder.ordexp_stopover_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }
            }
            
            //Card PBP-69 Start
             else if(addOndata.RecordTypeId==airlineUpgradeRCT){
                if(orderToUpdateMap.get(addOndata.TAD_Order_Id__c)==null){
                    TAD_Order__c tadOrder = new TAD_Order__c(id=addOndata.TAD_Order_Id__c);     
                    tadOrder.ordexp_airline_upgrade_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }else{
                    TAD_Order__c tadOrder  =   orderToUpdateMap.get(addOndata.TAD_Order_Id__c);
                    tadOrder.ordexp_airline_upgrade_check__c=true;
                    orderToUpdateMap.put(addOndata.TAD_Order_Id__c,tadOrder);
                }
            }
            //Card PBP-69 Stop*/
            
             //Comment for PBP-257 finish
            // Message ends 
            
            // Financials & Commission for Add-Ons
            Double comAmount= 0;
            Double finAmount= 0;
            Double PricePerNight= 0;
            if(Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get('mp_AE_SB_Accommodation').getRecordTypeId() == addOndata.RecordTypeId){
                
                PricePerNight = AESBAccomMap.get(addOndata.AE_SB_Accommodation__c).mp_Price_Per_Night__c;
                
                if(AESBAccomMap.get(addOndata.AE_SB_Accommodation__c).mp_AE_SB__r.Type__c == 'Arrive Early' &&  AESBAccomMap.get(addOndata.AE_SB_Accommodation__c).mp_Price_Per_Night__c != null){
                    
                    addOndata.ordexp_amount__c = addOndata.AE_Nights__c * PricePerNight;
                    
                }
                if(AESBAccomMap.get(addOndata.AE_SB_Accommodation__c).mp_AE_SB__r.Type__c == 'Stay Behind' &&  AESBAccomMap.get(addOndata.AE_SB_Accommodation__c).mp_Price_Per_Night__c != null){
                    
                    addOndata.ordexp_amount__c = addOndata.SB_Nights__c *  PricePerNight;               
                    
                }
                
            }
            if(addOndata.tad_order_rt_name__c =='TAD' || addOndata.tad_order_rt_name__c =='TC'){  
                
                if(addOndata.RecordTypeId==AESBRCT){									//Check for AE/SB Addons Only
                    if(!isEnhancedPricingExist){
                        if(addOndata.General_Pricing__c == null){ //PSAG-379
                            finAmount=AESBMap.get(addOndata.AE_SB__c).price__c;
                            addOndata.ordexp_amount__c=finAmount;
                        }else{
                            addOndata.ordexp_amount__c = gpMap.get(addOndata.General_Pricing__c).AE_SB_Price__c;
                        }
                        /*PSAG - 46 Start 
                    if(addOndata.tad_order_rt_name__c == 'TC'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).AE_SB__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount; 
                    PSAG - 46 Stop*/
                    }else
                    {
                        finAmount = enhancedPrice;
                         /*PSAG - 46 Start 
                        if(addOndata.tad_order_rt_name__c == 'TC'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).AE_SB__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount; 
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                    }
                    
                }
                
                if(addOndata.RecordTypeId==airlineUpgradeRCT){       
                    //Check for Airline Upgrade Addons Only
                    if(addOndata.General_Pricing__c == null){//PSAG-379
                           finAmount=airlineUpgradeMap.get(addOndata.Airline_Upgrade__c).price__c;
                        addOndata.ordexp_amount__c=finAmount;
                    }else{
                        addOndata.ordexp_amount__c=gpMap.get(addOndata.General_Pricing__c).Price_Airline_upgrade__c;
                    }
                 
                    /*PSAG - 46 Start 
                    if(addOndata.tad_order_rt_name__c == 'TC'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Airline_Upgrade__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    
                }
                
                if(addOndata.RecordTypeId==landActRCT){      						//Check for Land Activities Addons Only
                    if(addOndata.General_Pricing__c == null){//PSAG-379
                    if(addOndata.pricing_model__c==Label.Solo) 
                    {
                        finAmount=landActivityMap.get(addOndata.land_activity__c).solo_price__c;
                    }
                    else
                    {
                        finAmount=landActivityMap.get(addOndata.land_activity__c).price__c;
                    }
                     /*PSAG - 46 Start 
                    if(addOndata.tad_order_rt_name__c == 'TC'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Land_Activities__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount;
                     PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                    }else{
                        addOndata.ordexp_amount__c = addOndata.pricing_model__c==Label.Solo ? gpMap.get(addOndata.General_Pricing__c).LA_Solo_Price__c:gpMap.get(addOndata.General_Pricing__c).LA_Twin_Price__c;
                    }
                }
                
                if(addOndata.RecordTypeId==subStopRCT){	
                      //Check for SubStopover Addons Only
                    if(!isEnhancedPricingExist){
                       if(addOndata.General_Pricing__c == null){//PSAG-379
                         if(addOndata.pricing_model__c==Label.Solo)
                    {
                        finAmount=stopoverMap.get(addOndata.Sub_Stopover__c).Price_Solo__c;
                    }
                    else{
                        finAmount=stopoverMap.get(addOndata.Sub_Stopover__c).price__c;
                    }
                       }else{
                            finAmount = addOndata.pricing_model__c==Label.Solo ? gpMap.get(addOndata.General_Pricing__c).Stopover_Solo_Price__c:gpMap.get(addOndata.General_Pricing__c).Stopover_Twin_Price__c;

                         //  addOndata.ordexp_amount__c = addOndata.pricing_model__c==Label.Solo ? gpMap.get(addOndata.General_Pricing__c).Stopover_Solo_Price__c:gpMap.get(addOndata.General_Pricing__c).Stopover_Twin_Price__c;
                       }
                    }else{
                        finAmount = enhancedPrice;
                    }
                    
                   
                    /*PSAG - 46 Start                     
                    if(addOndata.tad_order_rt_name__c == 'TC'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Stopover__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                }
                
            }
            
            if(addOndata.tad_order_rt_name__c =='TNZ' || addOndata.tad_order_rt_name__c =='WT'){
                
                if(addOndata.RecordTypeId==AESBRCT){									//Check for AE/SB Addons Only
                    finAmount=AESBMap.get(addOndata.AE_SB__c).price_nz__c;
                    /*PSAG - 46 Start 
                    if(addOndata.tad_order_rt_name__c == 'WT'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).AE_SB__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                } 
                
                if(addOndata.RecordTypeId==airlineUpgradeRCT){						//Check for Airline Upgrade Addons Only
                    finAmount=airlineUpgradeMap.get(addOndata.Airline_Upgrade__c).price_nz__c;
                    /*PSAG - 46 Start
                    if(addOndata.tad_order_rt_name__c == 'WT'){
                        if(!wholesaleMap.isEmpty()){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Airline_Upgrade__c)/100;
                        }
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                } 
                
                if(addOndata.RecordTypeId==landActRCT){								//Check for Land Activities Addons Only
                    
                    if(addOndata.pricing_model__c==Label.Solo)
                    {
                        finAmount=landActivityMap.get(addOndata.land_activity__c).solo_price_nz__c;
                    }
                    else
                    {
                        finAmount=landActivityMap.get(addOndata.land_activity__c).price_nz__c;
                    }
                    /*PSAG - 46 Start
                    if(addOndata.tad_order_rt_name__c == 'WT'){
                        if(!wholesaleMap.isEmpty()){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Land_Activities__c)/100;
                      }
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;
                    				
                }
                
                if(addOndata.RecordTypeId==subStopRCT){								//Check for SubStopover Addons Only
                    
                    if(addOndata.pricing_model__c==Label.Solo)
                    {
                        finAmount=stopoverMap.get(addOndata.Sub_Stopover__c).Price_Solo_nz__c;
                    }
                    else{
                        finAmount=stopoverMap.get(addOndata.Sub_Stopover__c).price_nz__c;
                    }
                    /*PSAG - 46 Start
                    if(addOndata.tad_order_rt_name__c == 'WT'){
                        comAmount=(finAmount*wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Stopover__c)/100;
                    }
                    addOndata.ordexp_commission__c=comAmount;
                    PSAG - 46 Stop*/
                    addOndata.ordexp_amount__c=finAmount;

                }				
                
            }       
            
        }
        
        if(!orderToUpdateMap.isEmpty() && orderToUpdateMap.values() != null){
            update orderToUpdateMap.values();
        }
        
    } 
    
   //changes for PBP-257
    public static void checkAESBonOrder(Set<ID> orderIds){
        
        List<TAD_Order__c> orderToUpdate = new List<TAD_Order__c>();
        //changes to query for Card FF-69:-AND AddOn_Status__c != 'Cancelled'
        //List<AddOn__c> addOnCheck = [Select id , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND ordexp_rct_Name__c ='AE/SB' AND AddOn_Status__c != 'Cancelled']; 
        List<AddOn__c> addOnsecuredCheck = [Select id , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND ordexp_rct_Name__c ='AE/SB' AND AddOn_Status__c != 'Cancelled' AND  AddOn_Status__c != 'On Hold' ];
        
        //System.debug('addOnCheck: '+addOnCheck);
        if( addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
                tadorder.ordexp_aesb_check__c=false;
                orderToUpdate.add(tadorder);
            }  
        }else if(!addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
                tadorder.ordexp_aesb_check__c=true;
                orderToUpdate.add(tadorder);
            }  
        }
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
        
    }
        
    public static void checkStopoverOnOrder(Set<ID> orderIds){
                            system.debug('inside Stopover Addon triggerHandller');

        List<TAD_Order__c> orderToUpdate = new List<TAD_Order__c>();
        //changes to query for Card FF-69:-AND AddOn_Status__c != 'Cancelled'
       // List<AddOn__c> addOnCheck = [Select id , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND ordexp_rct_Name__c ='Sub Stopover' AND AddOn_Status__c != 'Cancelled']; 
        List<AddOn__c> addOnsecuredCheck = [Select id , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND ordexp_rct_Name__c ='Stopover' AND AddOn_Status__c != 'Cancelled' AND  AddOn_Status__c != 'On Hold' ];
        //System.debug('addOnCheck: '+addOnCheck);
        if( addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
                tadorder.ordexp_stopover_check__c=false;
                orderToUpdate.add(tadorder);
            }  
        } else if(!addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
                tadorder.ordexp_stopover_check__c=true;
                orderToUpdate.add(tadorder);
            }  
        }
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
        
        
    } 
    
    //Card PBP - 69 Start
    public static void checkAirlineUpgradeOnOrder(Set<ID> orderIds){
        List<TAD_Order__c> orderToUpdate = new List<TAD_Order__c>();
        
       // List<AddOn__c> addOnCheck = [Select id , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND (ordexp_rct_Name__c ='Airline Upgrade' AND AddOn_Status__c != 'Cancelled')]; 
        List<AddOn__c> addOnsecuredCheck = [Select id ,name , TAD_Order_Id__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c IN: orderIds AND ordexp_rct_Name__c ='Airline Upgrade' AND AddOn_Status__c != 'Cancelled' AND  AddOn_Status__c != 'On Hold'];
        system.debug('addOnsecuredCheck:-  '+ addOnsecuredCheck);
        //System.debug('addOnCheck: '+addOnCheck);
        if(addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                system.debug('updateOrder '+updateOrder);
                TAD_Order__c tadorder = new TAD_Order__c(Id=updateOrder);
                tadorder.ordexp_airline_upgrade_check__c=false;
                orderToUpdate.add(tadorder);
                system.debug('AU false');
            }  
        } else if(!addOnsecuredCheck.isEmpty()){
            for(ID updateOrder : orderIds){
                system.debug('updateOrder '+updateOrder);
                TAD_Order__c tadorder = new TAD_Order__c(Id=updateOrder);
                tadorder.ordexp_airline_upgrade_check__c=true;
                orderToUpdate.add(tadorder);
                 system.debug('AU true');
            }
        }
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
    }
    //Card PBP - 69 Stop    
    
    //changes for PBP-257 End
      
    public static Date convertStringToDate(String dates){
        String strDate = dates;
        String day = strDate.substring(0,2);
        String month = strDate.substring(3,5);
        String year = strDate.substring(6,10);
        Date departureDate = Date.newInstance(integer.valueOf(year),integer.valueOf(month),integer.valueOf(day));
        return departureDate;
    }
    public static void checkAeSbOnPassengerForAccom(List<AddOn__c> newAddOnRecords){
        
        Set<Id> paxIdOfAeSbAccom = new Set<Id>();
        
        for(AddOn__c addOn : newAddOnRecords){
            if(addOn.ordexp_rct_Name__c == 'AE/SB Accommodation'){
                paxIdOfAeSbAccom.add(addOn.Passenger__c);  
                
            }   
        }
        System.debug('paxIdOfAeSbAccom--'+paxIdOfAeSbAccom);
        
        List<AddOn__c> aeSbAddon = new List<AddOn__c>();
        
        if(!paxIdOfAeSbAccom.isEmpty()){
            
            aeSbAddon = [Select id,AddOn_Status__c,ordexp_rct_Name__c,Passenger__c from AddOn__c where  Passenger__c IN: paxIdOfAeSbAccom AND AddOn_Status__c != 'Cancelled' AND ordexp_rct_Name__c =: 'AE/SB' ];
            
        }
        system.debug('aeSbAddon---'+aeSbAddon);
        
        List<Id> paxIds = new List<Id>();
        for(AddOn__c adon : aeSbAddon){
            
            paxIds.add(adon.Passenger__c);
        }
        System.debug('paxIds---'+paxIds);
        
        
        for(AddOn__c a : newAddOnRecords){
            System.debug('paxIds.contains(a.Passenger__c)---'+paxIds.contains(a.Passenger__c));
            System.debug('a.ordexp_rct_Name__c---'+a.ordexp_rct_Name__c);
            System.debug('a.Passenger__c--'+a.Passenger__c);
            
            if(a.ordexp_rct_Name__c == 'AE/SB Accommodation'){
                
                if(!paxIds.contains(a.Passenger__c)){
                    
                    System.debug('inside adderror');
                    a.Passenger__c.addError('No active AE/SB addon exists for this Passenger');
                }
            }
            
        }
    }
    
    public static void checkPassengerOnAddOn(List<AddOn__c> newAddOnRecords,Map<id,AddOn__c> oldAddOnMap,String state){
        
        Set<Id> addOnPassengerIds = new Set<Id>();
        
        // PSAG - 410 Start
        List<String> activityTimeOfTheDayList = New List<String>();
        activityTimeOfTheDayList.add('Morning');
        activityTimeOfTheDayList.add('Afternoon');
        activityTimeOfTheDayList.add('Evening');
        // PSAG - 410 Stop 
        
        for(AddOn__c addOn : newAddOnRecords){
            if(state=='Insert'){
                addOnPassengerIds.add(addOn.Passenger__c);   
            }else if(state=='Update'){
                if(addOn.Passenger__c!=oldAddOnMap.get(addOn.id).Passenger__c){
                    addOnPassengerIds.add(addOn.Passenger__c); 
                }   
            }    
        }
        
        if(!addOnPassengerIds.isEmpty()){
            
            List<AddOn__c> addOnList = [Select id,Land_Activity_Time__c,order_line_item__r.CurrencyIsoCode ,AddOn_Status__c,ordexp_rct_Name__c,LA_Activity_time_of_day__c,Itinerary_Day_Number__c,RecordTypeId ,AE_SB__c, AE_SB__r.Type__c, land_activity__c, AE_SB_Accommodation__r.orderxp_AE_SB_Accommodation_Type__c, Sub_Stopover__r.type__c ,Airline_Upgrade__c ,Passenger__c,Passenger__r.ordexp_PAX_Nickname__c from AddOn__c where Passenger__c IN: addOnPassengerIds AND Land_Activity_Time__c != Null];
            
            for(AddOn__c Add1: addOnList){
                
                for(AddOn__c Add2:newAddOnRecords){
                    Add2.CurrencyIsoCode=Add1.order_line_item__r.CurrencyIsoCode;
                    if(Add1.AddOn_Status__c != 'Cancelled' && Add1.ordexp_rct_Name__c == 'AE/SB' &&  (Add2.AE_SB__c == Add1.AE_SB__c) && Add1.Passenger__c!=null && ( Add1.Passenger__c == Add2.Passenger__c) ){
                        Add2.Passenger__c.addError('AddOn of '+Add1.AE_SB__r.Type__c+' type already exists for: '+Add1.Passenger__r.ordexp_PAX_Nickname__c);
                    }
                    else if(Add1.AddOn_Status__c != 'Cancelled' && Add1.ordexp_rct_Name__c == 'Airline Upgrade' && (Add2.Airline_Upgrade__c == Add1.Airline_Upgrade__c) && Add1.Passenger__c!=null && ( Add1.Passenger__c == Add2.Passenger__c) ){
                        
                        Add2.Passenger__c.addError('AddOn of Airline Upgrade already exists for: '+Add1.Passenger__r.ordexp_PAX_Nickname__c);
                    }
                    else if(Add1.AddOn_Status__c != 'Cancelled' && Add1.ordexp_rct_Name__c == 'Stopover' && (Add2.Sub_Stopover__c == Add1.Sub_Stopover__c) && Add1.Passenger__c!=null && ( Add1.Passenger__c == Add2.Passenger__c) ){
                        
                        Add2.Passenger__c.addError('Addon of this ' + Add1.Sub_Stopover__r.type__c + ' Stopover type already exist for: '+Add1.Passenger__r.ordexp_PAX_Nickname__c);
                    }
                    else if(Add1.AddOn_Status__c != 'Cancelled' && Add1.ordexp_rct_Name__c == 'Land Activity' && (Add2.RecordTypeId == Add1.RecordTypeId) && (Add1.Land_Activity_Time__c != Null) && (Add1.LA_Activity_time_of_day__c  == Add2.LA_Activity_time_of_day__c 
						|| (Add1.Land_Activity_Time__c == 'All day' && activityTimeOfTheDayList.contains(Add2.Land_Activity_Time__c) || (Add2.Land_Activity_Time__c == 'All day' && activityTimeOfTheDayList.contains(Add1.Land_Activity_Time__c))))&& ( Add1.Itinerary_Day_Number__c == Add2.Itinerary_Day_Number__c) && Add1.Passenger__c!=null && ( Add1.Passenger__c == Add2.Passenger__c) ){
                        
                        Add2.Passenger__c.addError('This Land Activity already exists or conflicts with other activity for the user '+Add1.Passenger__r.ordexp_PAX_Nickname__c);
                    }
                    
                    else if(Add1.AddOn_Status__c != 'Cancelled' && Add1.ordexp_rct_Name__c == 'AE/SB Accommodation' && ( Add1.AE_SB_Accommodation__c == Add2.AE_SB_Accommodation__c) && Add1.Passenger__c!=null && ( Add1.Passenger__c == Add2.Passenger__c) ){
                        
                        Add2.Passenger__c.addError('AddOn of this  '+Add1.AE_SB_Accommodation__r.orderxp_AE_SB_Accommodation_Type__c+' Accommodation already exists for: '+Add1.Passenger__r.ordexp_PAX_Nickname__c);
                    }
                }
            }   
        }  
    }
    // commented by Anshudhar on 27-12-2022
    /*
    public static void createCSAttributionForAddon(List<AddOn__c> newAddOnRecords){
        List<CS_Attribution_POE__c> listOfCsAttribute = new List<CS_Attribution_POE__c>();
        
        for(AddOn__c addOn : [Select id, ordexp_amount__c, Order_Line_Item__c, Customisation__c,Order_Line_Item__r.Name, Order_Line_Item__r.ordexp_TAD_Order__c, Order_Line_Item__r.Deal__r.Name, ordexp_AddOn_Name__c, CreatedBy.Id, LastModifiedById from Addon__c where Id IN : newAddOnRecords  ]){ 
            
            CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
            cs.cs_AddOn__c = addOn.Id;
            cs.cs_Sale_Amount__c = addOn.ordexp_amount__c != null? addOn.ordexp_amount__c : 0.00;
            cs.cs_Attribution_Type__c = 'Addon';
            cs.TAD_Order__c = addOn.Order_Line_Item__r.ordexp_TAD_Order__c;
            cs.User__c = addOn.LastModifiedById;
            cs.cs_status__c = 'On Hold';
            cs.cs_OLI__c = addOn.Order_Line_Item__c;
            cs.cs_Order_Customisation__c = addOn.Customisation__c != null ?  addOn.Customisation__c : null;
            listOfCsAttribute.add(cs);
            
        }
        if(!listOfCsAttribute.isEmpty()){
            insert listOfCsAttribute;
        }
    }
   
    public static void amendmentForAddonToCreateCsAttribution(List<AddOn__c> newAddOnRecords, Map<Id,AddOn__c> oldAddOnMap, Map<Id,AddOn__c> newAddOnMap ){
        system.debug('amendmentForAddonToCreateCsAttribution '+newAddOnRecords);
        Map<Id, AddOn__c> addIdVsaddOnMap = new Map<Id, AddOn__c>();
        Map<Id, Id> addOnvsconsultantIdMap = new Map<Id, Id>();
        List<CS_Attribution_POE__c> csAttributeList = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> csAttributeListToUpdate = new List<CS_Attribution_POE__c>();
        Set<Id> createdByUserIds = new set<Id>();
        for(AddOn__c addOn : [select Id,ordexp_amount__c, Order_Line_Item__c, Customisation__c,Order_Line_Item__r.Name, Order_Line_Item__r.ordexp_TAD_Order__c, Order_Line_Item__r.Deal__r.Name, ordexp_AddOn_Name__c, LastModifiedById from Addon__c where Id IN :newAddOnRecords ]){
            addIdVsaddOnMap.put(addOn.Id, addOn);
            createdByUserIds.add(addOn.LastModifiedById);
            addOnvsconsultantIdMap.put(addOn.Id, addOn.LastModifiedById);
        }
        system.debug('addOnvsconsultantIdMap '+addOnvsconsultantIdMap);
        
        for(CS_Attribution_POE__c attribute : [Select Id, cs_AddOn__c, User__c, cs_Sale_Amount__c from CS_Attribution_POE__c where cs_AddOn__c IN :addIdVsaddOnMap.keySet() AND cs_status__c != 'Cancelled' ]){
            system.debug('attribute '+attribute);
            if(attribute != null && newAddOnMap.get(attribute.cs_AddOn__c) != oldAddOnMap.get(attribute.cs_AddOn__c) && newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c != oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c  ){
                if(addIdVsaddOnMap.get(attribute.cs_AddOn__c).LastModifiedById == attribute.User__c ){
                    system.debug('new map amount '+newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c);
                    system.debug('oldAddOnMap amount '+oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c);
                    if(addOnvsconsultantIdMap.containskey(attribute.cs_AddOn__c)){
                        addOnvsconsultantIdMap.remove(attribute.cs_AddOn__c);
                    }
                    attribute.cs_Sale_Amount__c =  newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c >= oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c ? attribute.cs_Sale_Amount__c +(newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c - oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c)  : calculatefinalSaleAmount(newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c,oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c, attribute.cs_Sale_Amount__c ) ;
                    attribute.cs_status__c = newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c >= oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c ? 'On Hold' : 'Sold';
                    system.debug('attribute.cs_Sale_Amount__c  '+attribute.cs_Sale_Amount__c);
                    
                }else{
                    //addOnvsconsultantIdMap.put(attribute.cs_AddOn__c, addIdVsaddOnMap.get(attribute.cs_AddOn__c).LastModifiedById);
                    if(newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c < oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c){
                        attribute.cs_Sale_Amount__c =  calculatefinalSaleAmount(newAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c,oldAddOnMap.get(attribute.cs_AddOn__c).ordexp_amount__c, attribute.cs_Sale_Amount__c );
                        
                        
                    }
                }
                
                
            }
            
            
            
            csAttributeListToUpdate.add(attribute);
            
            
        }
        if(!addOnvsconsultantIdMap.isEmpty()){
            for(Id addOnId : addOnvsconsultantIdMap.keySet()){
                CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
                cs.cs_AddOn__c =addOnId;
                cs.cs_Sale_Amount__c = addIdVsaddOnMap.get(addOnId).ordexp_amount__c != null && (addIdVsaddOnMap.get(addOnId).ordexp_amount__c - oldAddOnMap.get(addOnId).ordexp_amount__c ) > 0 ? (addIdVsaddOnMap.get(addOnId).ordexp_amount__c - oldAddOnMap.get(addOnId).ordexp_amount__c ) : 0.00;
                cs.cs_Attribution_Type__c = 'Addon';
                cs.TAD_Order__c = addIdVsaddOnMap.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__c;
                cs.User__c = addIdVsaddOnMap.get(addOnId).LastModifiedById;
                cs.cs_status__c = 'On Hold';
                //cs.Name = addOn.ordexp_AddOn_Name__c;
                cs.cs_OLI__c = addIdVsaddOnMap.get(addOnId).Order_Line_Item__c;
                cs.cs_Order_Customisation__c = addIdVsaddOnMap.get(addOnId).Customisation__c != null?  addIdVsaddOnMap.get(addOnId).Customisation__c : null;
                csAttributeList.add(cs);
            }
        }
        Savepoint sp = Database.setSavepoint();
        
        try{
            if(!csAttributeList.isEmpty()){
                system.debug('csAttributeList '+csAttributeList);
                insert csAttributeList;
            }
            if(!csAttributeListToUpdate.isEmpty()){
                system.debug('csAttributeListToUpdate '+csAttributeListToUpdate);
                update csAttributeListToUpdate;
            }
            
        }catch(exception ex){
            Database.RollBack(sp);
        }
    }
    
    public static void cancellationAttribution(List<AddOn__c> newAddOnRecords){
        Set<Id> createdByUserIds = new set<Id>();
        Map<Id,Set<Id>> addonMapvsCancelledConsultant = new  Map<Id,Set<Id>>();
        List<CS_Attribution_POE__c> attributeList = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> attributeListWithNoSold = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> attributeListWithNoCancelled = new List<CS_Attribution_POE__c>();
        Map<Id,Set<Id>> addonMapvsSoldConsultant = new  Map<Id,Set<Id>>();
        Map<Id, Id> addonIdVslastModifiedMap = new Map<Id, Id>();
        for(AddOn__c addon : newAddOnRecords){
            addonIdVslastModifiedMap.put(addon.Id, addon.LastModifiedById);
        }
        
        for(CS_Attribution_POE__c attribute : [Select Id, cs_AddOn__c, User__c, cs_status__c from CS_Attribution_POE__c where cs_AddOn__c IN : newAddOnRecords AND cs_status__c = 'Cancelled' AND cs_Attribution_Type__c = 'Addon']){
            if(!addonMapvsCancelledConsultant.containskey(attribute.cs_AddOn__c)){
                addonMapvsCancelledConsultant.put(attribute.cs_AddOn__c, new Set<Id>{attribute.User__c} );    
            }else{
                Set<Id> attrIds = addonMapvsCancelledConsultant.get(attribute.cs_AddOn__c);
                attrIds.add(attribute.User__c);
                addonMapvsCancelledConsultant.put(attribute.cs_AddOn__c, attrIds ); 
            }
            
        }
        for(CS_Attribution_POE__c attribute : [Select Id, Name, User__c, User__r.Name, TAD_Order__c, cs_Sale_Amount__c, cs_AddOn__c , cs_AddOn__r.ordexp_amount__c, cs_AddOn__r.Cancellation_Amount__c, cs_status__c from CS_Attribution_POE__c where cs_AddOn__c IN : newAddOnRecords AND cs_status__c = 'Sold' ]){
            system.debug('attribute name '+attribute.Name);
            system.debug('attribute username'+attribute.User__r.name);
            if(!addonMapvsSoldConsultant.containskey(attribute.cs_AddOn__c)){
                addonMapvsSoldConsultant.put(attribute.cs_AddOn__c, new Set<Id>{attribute.User__c} );    
            }else{
                Set<Id> attrIds = addonMapvsSoldConsultant.get(attribute.cs_AddOn__c);
                attrIds.add(attribute.User__c);
                addonMapvsSoldConsultant.put(attribute.cs_AddOn__c, attrIds ); 
            }
            if(addonMapvsCancelledConsultant.get(attribute.cs_AddOn__c) ==null || !addonMapvsCancelledConsultant.get(attribute.cs_AddOn__c).contains(attribute.User__c) ){
                
                system.debug('attribute cancelled '+attribute);
                system.debug('attribute amount cancelled '+attribute.cs_AddOn__r.Cancellation_Amount__c );
                system.debug('attribute amount sale '+attribute.cs_Sale_Amount__c );
                CS_Attribution_POE__c newAttr = new CS_Attribution_POE__c();
                newAttr.cs_status__c = 'Cancelled';
                newAttr.User__c = attribute.User__c;
                newAttr.cs_AddOn__c = attribute.cs_AddOn__c;
                newAttr.cs_original_sale_amount__c = attribute.cs_AddOn__r.ordexp_amount__c;
                newAttr.cs_cancelled_amount__c = attribute.cs_AddOn__r.Cancellation_Amount__c > 0.00 ? attribute.cs_AddOn__r.Cancellation_Amount__c : 0.00 ;
                Decimal cancelledamount = ( ( attribute.cs_AddOn__r.Cancellation_Amount__c / attribute.cs_AddOn__r.ordexp_amount__c)*100) / 100;
                system.debug('cancelledamount' +cancelledamount);
                newAttr.cs_Sale_Amount__c =  attribute.cs_AddOn__r.Cancellation_Amount__c > 0.00  ? attribute.cs_Sale_Amount__c * cancelledamount  : 0.00; 
                newAttr.cs_attribution__c = attribute.Id;
                newAttr.cs_Attribution_Type__c = 'Addon';
                newAttr.TAD_Order__c = attribute.TAD_Order__c;
                attributeList.add(newAttr);
                
                
            }
        }
        for(AddOn__c addOn : [select Id,ordexp_amount__c, Order_Line_Item__c, Customisation__c,Order_Line_Item__r.Name, Order_Line_Item__r.ordexp_TAD_Order__c, Order_Line_Item__r.Deal__r.Name, ordexp_AddOn_Name__c, LastModifiedById from Addon__c where Id IN :newAddOnRecords ]){
            if(addonMapvsSoldConsultant.get(addOn.Id) == null || !addonMapvsSoldConsultant.get(addOn.Id).contains(addOn.LastModifiedById)){
                
                CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
                cs.cs_AddOn__c = addOn.Id;
                cs.cs_Sale_Amount__c =  0.00;
                cs.cs_Attribution_Type__c = 'Addon';
                cs.TAD_Order__c = addOn.Order_Line_Item__r.ordexp_TAD_Order__c;
                cs.User__c = addOn.LastModifiedById;
                cs.cs_status__c = 'Sold';
                //cs.Name = addOn.ordexp_AddOn_Name__c;
                cs.cs_OLI__c = addOn.Order_Line_Item__c;
                cs.cs_Order_Customisation__c = addOn.Customisation__c != null?  addOn.Customisation__c : null;
                attributeListWithNoSold.add(cs);
                
                
                
            }
            system.debug('attributeList '+attributeList);
            // Savepoint sp = Database.setSavepoint();
            try{
                if(!attributeList.isEmpty() ){
                    system.debug('attributeList --' +attributeList);
                    upsert attributeList;
                }
                if(!attributeListWithNoSold.isEmpty()){
                    system.debug('attributeListWithNoSold --' +attributeListWithNoSold);
                    insert attributeListWithNoSold;
                    
                }
                
                for(CS_Attribution_POE__c cs : attributeListWithNoSold){
                    CS_Attribution_POE__c cancelledCs = new CS_Attribution_POE__c();
                    cancelledCs.cs_AddOn__c = cs.cs_AddOn__c;
                    cancelledCs.cs_Sale_Amount__c =  cs.cs_Sale_Amount__c;
                    cancelledCs.cs_Attribution_Type__c = cs.cs_Attribution_Type__c;
                    cancelledCs.TAD_Order__c = cs.TAD_Order__c;
                    cancelledCs.User__c = cs.User__c;
                    cancelledCs.cs_status__c = 'Cancelled';
                    //cancelledCs.;
                    cancelledCs.cs_attribution__c = cs.Id;
                    cancelledCs.cs_OLI__c = cs.cs_OLI__c;
                    cancelledCs.cs_Order_Customisation__c = cs.cs_Order_Customisation__c;
                    attributeListWithNoCancelled.add(cancelledCs);
                    
                    system.debug(' cancelledCs '+cancelledCs.User__c);
                    
                    
                }
                if(!attributeListWithNoCancelled.isEmpty()){
                    system.debug('attributeListWithNoCancelled --'+attributeListWithNoCancelled);
                    insert attributeListWithNoCancelled;
                }
                
                
            }catch(exception ex ){
                system.debug('ex exception '+ex);
                // Database.RollBack(sp);
            }
        }
        
    }
     */
    public static Decimal calculatefinalSaleAmount(Decimal newAmount, Decimal oldAmount, Decimal consultantSaleAmount){
        system.debug('newAmount '+newAmount+'& oldAmount '+oldAmount+'& consultantSaleAmount '+consultantSaleAmount);
        Decimal percentamount = 0;
        if(newAmount != null && oldAmount != null){
            system.debug('differenceAmount '+(oldAmount-newAmount));
            percentamount = newAmount/oldAmount;
        }
        
        
        // system.debug('differenceAmount '+(oldAmount-newAmount));
        Decimal consultantSaleAmountNew =(consultantSaleAmount*percentamount);
        
        return consultantSaleAmountNew;
    }
    public static void calculateCreditUsed(List<AddOn__c> newAddOnList){
        
        Set<Id> addOnIds = new Set<Id>();
        List<AddOn__c> addOnListToUpdate = new List<AddOn__c>();
        
        For(AddOn__c addon : newAddOnList ){
            
            addOnIds.add(addon.Id);
        }
        List<AddOn__c> addOnList = [Select Id, Name ,Credit_Utilized__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_amount_outstanding__c,Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c, ordexp_amount__c,Order_Line_Item__r.ordexp_TAD_Order__c from AddOn__c where Id IN : addOnIds ];
        For(AddOn__c ad : addOnList){
            
            if(ad.Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c != 0){
                
                if((ad.Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c - ad.ordexp_amount__c) >= 0){
                    
                    ad.Credit_Utilized__c =  ad.ordexp_amount__c;
                    System.debug(' ad.Credit_Utilized__c---'+ ad.Credit_Utilized__c);
                    addOnListToUpdate.add(ad);
                }else{
                    
                    ad.Credit_Utilized__c = ad.Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c;
                    System.debug(' ad.Credit_Utilized__c---'+ ad.Credit_Utilized__c);
                    addOnListToUpdate.add(ad);
                }
            }
            
        }
        
        if(!addOnListToUpdate.isEmpty()){
            
            update addOnListToUpdate;
        }
        
    }
    
    //PBP-274, PBP-354 - start
    public static void sendNotificationOnSecuredAU(List<AddOn__c> newAddOnList, Map<Id, AddOn__c>oldMap){
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        /*******Changes Made By Ajit**For PSAG--89**/
        //EmailTemplate  NotificationToTicketingConsultant = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue, BrandTemplateId  from EmailTemplate where DeveloperName = 'Email_Notification_to_the_Ticketing_consultant'];
         EmailTemplate  NotificationToTicketingConsultant = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue, BrandTemplateId  from EmailTemplate where DeveloperName = 'Email_Notification_to_the_Ticketing_consultant_Clone'];
        /*******Changes Made By Ajit**For PSAG--89**/
        List<Id> securedAUAddOns = new List<Id>();
        
        for(AddOn__c ao: newAddOnList )
        {
            if(ao.Record_Type_Name__c=='Airline Upgrade' && ao.AddOn_Status__c!=oldMap.get(ao.Id).AddOn_Status__c && (ao.AddOn_Status__c == 'Secured' || ao.AddOn_Status__c == 'Active'))
            {
                securedAUAddOns.add(ao.Id);
            }
        }
        
        system.debug('securedAUAddOns:- '+ securedAUAddOns);
        
        List<AddOn__c> securedAuAddOnList = [SELECT Id, Name,Order_Line_Item__c, Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordxp_min_numbers_met__c, Order_Line_Item__r.ordexp_TAD_Order__r.name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_approved_to_run_under_minimum__c, Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_sub_status__c,  Deal__c, Deal__r.Ticketing_Consultant__r.name, Deal__r.Ticketing_Consultant__r.email FROM AddOn__c WHERE Id In:securedAUAddOns];
        system.debug('securedAuAddOnList:- '+ securedAuAddOnList);
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        Map<Id,AddOn__c> AuMap = new map<Id, AddOn__c>();
        Map<Id,string> TadStatusMap = new map<Id, string>();
        Map<Id,string> TadNameMap = new Map<Id,string>();
        Map<Id,string> TicketingMap = new Map<Id,string>();
        
        if(!securedAuAddOnList.isEmpty())
        {
            for(AddOn__c ao: securedAuAddOnList)
            {
                AuMap.put(ao.Id, ao);
                TadStatusMap.put(ao.Id,ao.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c);
                TadNameMap.put(ao.Id, ao.Order_Line_Item__r.ordexp_TAD_Order__r.name );
                TicketingMap.put(ao.Id, ao.Deal__r.Ticketing_Consultant__r.name);
                system.debug('AuMap:- '+AuMap);
            }  
        }
        
        for(integer i=0; i<securedAUAddOns.size(); i++){
            system.debug('AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c :-- '+AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c );
            
            if((AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c=='Secured' || AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c=='In Progress') && AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__c != Null && ( AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordxp_min_numbers_met__c == true ||  AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_approved_to_run_under_minimum__c == true   ) &&  AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_sub_status__c != 'Flights Pending - Out of Range')
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                system.debug('AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__r.email '+AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__r.email);
                mail.toAddresses = new String[] {AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__r.email};
                mail.setSubject(NotificationToTicketingConsultant.Subject);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                 String emailBody = NotificationToTicketingConsultant.HTMLValue;
                if(i==0){
                   emailBody = emailBody.replace('{!TAD_Order__c.Name}', AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.name);
                   emailBody = emailBody.replace('{!Deal__c.Ticketing_Consultant__c}', AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__r.name);
                }
                else if(i!=0){
                    emailBody = emailBody.replace(AuMap.get(securedAUAddOns[i-1]).Order_Line_Item__r.ordexp_TAD_Order__r.name, AuMap.get(securedAUAddOns[i]).Order_Line_Item__r.ordexp_TAD_Order__r.name);
                    emailBody = emailBody.replace(AuMap.get(securedAUAddOns[i-1]).Deal__r.Ticketing_Consultant__r.name, AuMap.get(securedAUAddOns[i]).Deal__r.Ticketing_Consultant__r.name);
                }
                    
                mail.setHtmlBody(emailBody);
                allmsg.add(mail);
            }
        }
        
        
        system.debug('allmsg '+allmsg);
        if(!allmsg.isEmpty())
        {
            system.debug('allmsg 0'+allmsg[0]);
            Messaging.sendEmail(allmsg);
        }
    }
     //PBP-274, PBP-354 End

     //flightCustomisation-in case of stopover-PSAG-234
    public static void UpdateAddonPrice(List<AddOn__c> newAddOnList){
        list<id> stopList = new list<id>();
        map<id, decimal> stopPriceMapSolo = new map<id, decimal>();
        map<id, decimal> stopPriceMapTwin = new map<id, decimal>();
        set<id> carrierId=new set<id>();
        Set<Id> addOnIds = new Set<Id>();

        for(addon__c a:newAddOnList){
            if(a.sub_stopover__c!=null)
            	addOnIds.add(a.Id);
        }
        
        list<addon__c> addOnList = [Select id, name, pricing_model__c, ordexp_amount__c,sub_stopover__c, sub_stopover__r.price_solo__c, sub_stopover__r.price__c, order_line_item__c, order_line_item__r.carrier__c from addon__c where id in:addOnIds];
        for(addon__c aa:addOnList){
            stopList.add(aa.Sub_Stopover__c);
            carrierId.add(aa.Order_Line_Item__r.carrier__c);
            system.debug('order_line_item__r.carrier__c '+aa.order_line_item__r.carrier__c);
        }
        system.debug('stopList '+stopList);
        if(!stopList.isEmpty()){
                list<carrier_addon_junction__c> caj = [Select id, name, sub_stopover__c, carrier__c, carrier__r.Carrier_Price__c from carrier_addon_junction__c where sub_stopover__c IN:stopList AND carrier__c IN:carrierId];
            	system.debug('caj '+caj);    
            for(carrier_addon_junction__c c:caj){
                    for(addon__c a1 : addOnList){
                        if( a1.Sub_Stopover__c==c.sub_stopover__c && a1.Order_Line_Item__r.carrier__c==c.Carrier__c){
                            system.debug('matched');
                            decimal priceSolo = a1.Sub_Stopover__r.Price_Solo__c - c.Carrier__r.carrier_price__c;
                            decimal priceTwin = a1.Sub_Stopover__r.Price__c - c.Carrier__r.carrier_price__c;
                            stopPriceMapSolo.put(a1.id,priceSolo);
                            stopPriceMapTwin.put(a1.id,priceTwin);
                        }
                    }
                }
       }
        list<addon__c> addToUpdate = new List<addon__c>();
        for(addon__c add : addOnList){
            if(add.pricing_model__c=='Solo'){
                if(stopPriceMapSolo.containsKey(add.id)){
                    add.ordexp_amount__c=stopPriceMapSolo.get(add.id);
                    addToUpdate.add(add);
                }
            }else{
                if(stopPriceMapTwin.containsKey(add.id)){
                    add.ordexp_amount__c=stopPriceMapTwin.get(add.id);
                    addToUpdate.add(add);
                }
            }
        }
        if(!addToUpdate.isEmpty()){
            update addToUpdate;
        }
        
    }
    //PSAG-234 End
}