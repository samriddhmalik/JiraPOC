/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TCPdfGeneratorSchedule_extension
* Purpose: Extension Used for WholesaleOptionalExtrasPDF page for TAD Order
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Hansa Sabbarwal  <hansa@psagtechnologies.com>
* @lastModifiedBy Hansa Sabbarwal  <hansa@psagtechnologies.com>

* @version        3.0
* 
* @modified       2020-01-17
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public with sharing class TCPdfGeneratorSchedule_extension {
    public final TAD_Order__c  ord{get;set;}
    public List<order_line_item__c> lineItemList{get;set;}
    public List<order_line_item__c> lineItemListforNoAddOn{get;set;}
    public Map<String,List<WrapperClass>> MapLineIdVsWrap{get;set;}
    public Boolean isLineItemList{get;set;}
    public Boolean isLineItemListWithNoAddOn{get;set;}
    public static String depDate{get;set;}
    
    public TCPdfGeneratorSchedule_extension(ApexPages.StandardController controller){
        isLineItemList = false;
        isLineItemListWithNoAddOn = false;
        if(!Test.isRunningTest()){
            controller.addFields(new List<String>{'Name'});
        }
        
        MapLineIdVsWrap = new Map<String,List<WrapperClass>>();
        List<WrapperClass> blankList = new List<WrapperClass>();
        this.ord = (TAD_Order__c)controller.getRecord();
        if(Ord.Id != null){
            TAD_Order__c temp = [select Id, Name,ordexp_departure_date__c,  ordexp_departure_date__r.date__c from TAD_Order__c where Id=: ord.Id];
            lineItemList = new List<order_line_item__c>();
            lineItemListforNoAddOn = new List<order_line_item__c>();
            system.debug('temp '+temp.ordexp_departure_date__r.date__c.format());
            
            depDate = DateTime.newInstance(temp.ordexp_departure_date__r.date__c.year(), temp.ordexp_departure_date__r.date__c.month(), temp.ordexp_departure_date__r.date__c.day()).format('EEEE MMMM dd, YYYY');
            system.debug('depDate '+depDate);
            
            /***Below is the Implementation for getting data for Line item with its add-ons, Visa & Insurance, Customisation. Since we will not have more than 200 records we are using inner query***/
            for( order_line_item__c lineItem : [select Id, PAX_Qty__c, Sub_Options__r.Name, ordexp_TAD_Order__c, Name, Pricing_Model__c, Departure_cities__c,Departure_cities__r.Name, ordexp_suboption_amount__c, Total_surcharge__c, ordexp_city_surcharge_amount__c,
                                                OLI_Commission__c,(select Id , RecordType.Name, AE_SB_Name__c, ordexp_commission__c, ordexp_amount__c, Airline_Upgrade__r.Name, land_activity__r.Name, Sub_Stopover__r.Name from AddOns__r), (select Id,Name, RecordType.Name ,Commission__c, Total_Cost__c from Order_Customisations_POE__r),
                                                (select Id ,RecordType.Name, Name, Passenger__r.Name , Commission_amount__c from Visa_Insurance_POE__r)
                                                from order_line_item__c where ordexp_TAD_Order__c =: ord.Id ]){
                                                    
                                                    List<WrapperClass> wrapList = new List<WrapperClass>();
                                                    
                                                    if(!lineItem.Visa_Insurance_POE__r.isEmpty()){
                                                        for(Visa_Insurance_POE__c visa : lineItem.Visa_Insurance_POE__r ){
                                                            wrapList.add(new WrapperClass(visa.Name,visa.RecordType.Name,0.00, visa.Commission_amount__c, true));
                                                            
                                                        } 
                                                    }
                                                    
                                                    if(!lineItem.Order_Customisations_POE__r.isEmpty()){
                                                        
                                                        for(Order_Customisations_POE__c customise : lineItem.Order_Customisations_POE__r ){
                                                            wrapList.add(new WrapperClass(customise.Name, customise.RecordType.Name, customise.Total_Cost__c, customise.Commission__c, true));
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    if(!lineItem.AddOns__r.isEmpty()){
                                                        
                                                        for(AddOn__c addOn : lineItem.AddOns__r ){
                                                            if(addOn.RecordType.Name == 'Sub Stopover'){
                                                                
                                                                wrapList.add(new WrapperClass(addOn.Sub_Stopover__r.Name ,addOn.RecordType.Name, addOn.ordexp_amount__c, addOn.ordexp_commission__c, true));
                                                            }if(addOn.RecordType.Name == 'Land Activity'){
                                                                
                                                                wrapList.add(new WrapperClass(addOn.land_activity__r.Name ,addOn.RecordType.Name, addOn.ordexp_amount__c, addOn.ordexp_commission__c, true));
                                                            } if(addOn.RecordType.Name == 'Airline Upgrade'){
                                                                
                                                                wrapList.add(new WrapperClass(addOn.Airline_Upgrade__r.Name ,addOn.RecordType.Name, addOn.ordexp_amount__c, addOn.ordexp_commission__c , true));
                                                            } if(addOn.RecordType.Name == 'AE/SB'){
                                                                wrapList.add(new WrapperClass(addOn.AE_SB_Name__c ,addOn.RecordType.Name, addOn.ordexp_amount__c, addOn.ordexp_commission__c , true));
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                    if(wrapList != null  && !MapLineIdVsWrap.containsKey(lineItem.Id) && !wrapList.isEmpty()){
                                                        MapLineIdVsWrap.put(lineItem.Id, wrapList);
                                                        if(lineItem.Departure_cities__c !=null){
                                                            lineItemList.add(lineItem);
                                                           
                                                        }
                                                        	
                                                        system.debug('lineItemList -- '+lineItemList);
                                                        system.debug('MapLineIdVsWrap -- '+JSON.serializePretty(MapLineIdVsWrap) );
                                                    }else{
                                                        if(lineItem.Departure_cities__c !=null){
                                                            lineItemListforNoAddOn.add(lineItem);
                                                        }
                                                         
                                                    }
                                                    system.debug('wrapList '+json.serialize(wrapList));
                                                    system.debug('MapLineIdVsWrap '+json.serialize(MapLineIdVsWrap));
                                                    
                                                    
                                                }
            if(lineItemList != null && !lineItemList.isEmpty()){
                isLineItemList = true;
            }
            if(lineItemListforNoAddOn != null && !lineItemListforNoAddOn.isEmpty()){
                isLineItemListWithNoAddOn = true;
            }
            
        }
        
        
        
    }
    public Boolean getRenderMapList(Id keyToCheck){
        
        return MapLineIdVsWrap.containsKey(keyToCheck);
    }
    
    public Class WrapperClass{
        
        public String nameTitle{get;set;}
        public String recordTypeName {get;set;}
        public Decimal amount{get;set;}
        public Decimal commision{get;set;}
        public Boolean isAddOn{get;set;}
        public WrapperClass(String nameTitle,String recordTypeName, Decimal amount, Decimal commision, Boolean isAddOn ){
            this.nameTitle = nameTitle;
            this.recordTypeName = recordTypeName;
            this.amount = amount;
            this.commision = commision;
            this.isAddOn = false;
            
        }
        
    }
}