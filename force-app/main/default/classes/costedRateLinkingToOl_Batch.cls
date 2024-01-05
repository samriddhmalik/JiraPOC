global class costedRateLinkingToOl_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String Query = 'Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Rate__c !=NULL';
        
        return Database.getquerylocator(Query);
        
    }
    
    global void execute(Database.BatchableContext bc, List <Costed_Rate__c> crList) {
        
        Set<Id> dealIdSet = New Set<Id>();
        Set<Id> compIdSet = New Set<Id>();
        Set<Id> olIdsetExist = new Set<Id>();
        
        for(Costed_Rate__c cr : crList){
            dealIdSet.add(cr.Deal__c);
        }    
        List<Component__c> components = [SELECT Id, Name,Is_Default_Departure_Surcharge__c,ff_Every_X_PAX_is_free__c,PAX_Sold__c,ff_Pricing_structure__c,City__c,City__r.Surcharge__c,City__r.Deal__r.deal_type__c, City__r.surcharge_nz__c, Deal_D_O_S__c, LinkedDeal_D_O_S__c, LinkedDeal_D_O_S__r.deal_type__c, Component_Type__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Merchant_Name__c, Merchant_Name__r.Name, Merchant_Name__r.CurrencyIsoCode, name__c,
                                         Allocations_Sold__c,Options__c,CurrencyIsoCode,Start_Date__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, mp_AE_SB_Accommodation__c, Stopover__c, Deal__c,Deal__r.Accounting_Treatment_AU__c,(Select Id, Is_Min_or_Max_Price__c,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c IN: dealIdSet];
         system.debug('Line--22->'+components);
        for(Component__c comp : components){
            compIdSet.add(comp.Id);
        }  
          system.debug('Line--26->'+compIdSet);
        
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        
        if (components.size() > 0) {
            
            
            for(order_line_POE__c ol :[Select Id,Component__c,Component__r.CurrencyIsoCode,TAD_Order__r.ordexp_purchase_date__c,TAD_Order__r.ordexp_deal__c,ff_Merchant_Currency__c from order_line_POE__c where Component__c =: compIdSet AND Status__c !='Cancelled' AND TAD_Order__r.ordexp_master_status__c !='Cancelled' AND TAD_Order__r.ordexp_deal__c =:dealIdSet]){
                system.debug('Line--34-->'+ol);
                if(!olIdsetExist.contains(ol.Id)){
                    
                    
                    if(crList.size()>0){
                        for(Costed_Rate__c cr : crList){
                            if(ol.TAD_Order__r.ordexp_purchase_date__c !=null){
                                DateTime purchaseDate = ol.TAD_Order__r.ordexp_purchase_date__c;
                                Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                    DateTime dt = cr.Date_To__c;
                                    Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                    if((myDate < cdt || myDate == cdt) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                                
                                if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                    DateTime df = cr.Date_From__c;
                                    Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                    DateTime dt = cr.Date_To__c;
                                    Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                    if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                                
                                if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                    DateTime df = cr.Date_From__c;
                                    Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                    if((myDate > cdf || myDate == cdf) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                                
                                if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                    if(ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                            }
                        }
                    }
                    olIdsetExist.add(ol.Id);
                    orderLines.add(ol);
                }
                
            }
            
        }
        
        
        if (orderLines.size() > 0) {
            
            update orderLines;
            
        } 
    }
    
    global void finish(database.BatchableContext bc) {}
}