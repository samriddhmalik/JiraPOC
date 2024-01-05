public class OnComponentStartDateUpdatehandler {
    
    
    public static void UpdateCmpCurrencyField( List<Component__c> compList){
        
        
        list<Component__c> fetchCompList = [SELECT Id,CurrencyIsoCode,Product_FX_Pricing__r.To_Currency__c FROM Component__c WHERE Id IN:compList];
        if(!compList.isEmpty()){
            for(Component__c objCmp : fetchCompList){
                objCmp.CurrencyIsoCode = objCmp.Product_FX_Pricing__r.To_Currency__c;
            }
        }
    }
    
    public static void UpdateStartDate(list<Component__c> compList)
    {
        system.debug('compList---5--'+compList);
        List<order_line_POE__c> OLP = new List<order_line_POE__c>();
        List<order_line_POE__c> OLPToUpdate = new List<order_line_POE__c>();
        OLP = [Select Id,Component_Name__c,Component_Type__c,Component__c,TAD_Order__r.ordexp_departure_date__r.date__c,Component__r.Component_Days__c,Component__r.Start_Date__c,Component__r.End_Date__c from order_line_POE__c where Component__c  IN: compList];
        system.debug('---line No---9--'+OLP);
        for(order_line_POE__c Ol : OLP ){
            Ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(Ol.TAD_Order__r.ordexp_departure_date__r.date__c,Ol.Component__r.Start_Date__c);
            OLPToUpdate.add(Ol);
            system.debug('OLPToUpdate'+OLPToUpdate);
        }
        
        update OLPToUpdate;
    }
    
    @future
    public static void OlToVerify(Set<id> compIds)
    {
        
        Map<id,List<Component_Pricing__c>>  latestCompPricingmap = new Map<id,List<Component_Pricing__c>> ();
        List<Component__c> compList = [Select id,PAX_Sold__c,(Select Id, Name,Is_Min_or_Max_Price__c,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) from Component__c where id=:compIds ];
        
        for(Component__c comp : compList){
            
            List<Component_Pricing__c> priceList = new  List<Component_Pricing__c>();
            for(Component_Pricing__c price : comp.Component_Pricing__r ){
                if(price.Is_Min_or_Max_Price__c  == 'MaxPax' ){
                    price.Max_Pax__c = 1000000;
                }
                if(price.Is_Min_or_Max_Price__c  == 'MinPax' ){
                    price.Min_Pax__c = 0;
                } 
                if(comp.PAX_Sold__c >= price.Min_Pax__c && comp.PAX_Sold__c <= price.Max_Pax__c ){
                    priceList.add(price);
                } 
            } 
            latestCompPricingmap.put(comp.id,priceList); 
        }
		
        System.debug('latestCompPricingmap'+latestCompPricingmap);
		Map<id,order_line_POE__c> olpToUpdate = new  Map<id,order_line_POE__c>();      
        List<order_line_POE__c> olp = [Select id,name,Component__c ,Component_Pricing__c ,Order_Line_Item__r.Pricing_Model__c,Order_Line_Item__r.ordexp_departure_date__r.date__c,Status__c ,Gross_Cost__c ,PAX_Travelling__c,Order_Line_Item__r.PAX_Quantity__c  from order_line_POE__c where Component__c IN:latestCompPricingmap.keySet() and Status__c!='Cancelled'];
        System.debug('olp'+olp);
        for(order_line_POE__c ol : olp){
            if(latestCompPricingmap.get(ol.Component__c).size()==1){
                Component_Pricing__c cmpRec = latestCompPricingmap.get(ol.Component__c)[0];
                if(ol.Component_Pricing__c !=cmpRec.id){
                    ol.Status__c='Updated';
                    ol.Component_Pricing__c = cmpRec.id;
                    if(ol.Order_Line_Item__r.Pricing_Model__c == 'Solo' && cmpRec.solo_rate_total__c != null){
                        ol.Gross_Cost__c = Integer.valueOf(ol.Order_Line_Item__r.PAX_Quantity__c) * cmpRec.solo_rate_total__c;
                    }
                    else if(cmpRec.Cost__c  != null){
                        ol.Gross_Cost__c = Integer.valueOf(ol.Order_Line_Item__r.PAX_Quantity__c) * cmpRec.Cost__c ;
                    } 
                    olpToUpdate.put(ol.id,ol);
                }
            }else if(latestCompPricingmap.get(ol.Component__c).size()>1){
                for(Component_Pricing__c cmpRec : latestCompPricingmap.get(ol.Component__c)){
                    
                    if( ol.Order_Line_Item__r.ordexp_departure_date__r.date__c >= cmpRec.Date_From__c && ol.Order_Line_Item__r.ordexp_departure_date__r.date__c <= cmpRec.Date_To__c){
                        if(ol.Component_Pricing__c !=cmpRec.id){
                            ol.Status__c='Updated';
                            ol.Component_Pricing__c = cmpRec.id;
                            if(ol.Order_Line_Item__r.Pricing_Model__c == 'Solo' && cmpRec.solo_rate_total__c != null){
                                ol.Gross_Cost__c = Integer.valueOf(ol.Order_Line_Item__r.PAX_Quantity__c) * cmpRec.solo_rate_total__c;
                            }
                            else if(cmpRec.Cost__c  != null){
                                ol.Gross_Cost__c = Integer.valueOf(ol.Order_Line_Item__r.PAX_Quantity__c) * cmpRec.Cost__c ;
                            } 
                            olpToUpdate.put(ol.id,ol);
                        }  
                    }
                }
            }
        }
        
        if(!olpToUpdate.isEmpty()){
            update olpToUpdate.values();
        }
        
    }
    
    public static void compListToAdjustApex(list<Component__c> compList){
        
        
    }
    
        //PSAG - 278 Start
    public static void updateMerchandDetailsToDeal(List<Component__c> cmpList){
        system.debug('cmpList '+cmpList);
        Map<String,List<String>> accMapForMerchantInfo = New Map<String,List<String>>();
        List<String> merchantNamesList = New List<String>();
        Set<String> dealIdSet = New Set<String>();
        List<Deal__c> dealListToUpdateMerchantInfo = New List<Deal__c>();
        
        
        for(Component__c objComponent : cmpList){
            dealIdSet.add(objComponent.LinkedDeal_D_O_S__c);
        }
        
        List<Component__c> fetchCmpList = [SELECT Id,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c   FROM Component__c WHERE LinkedDeal_D_O_S__c IN : dealIdSet];
        system.debug('cmpList '+fetchCmpList);
        if(!fetchCmpList.isEmpty()){
            for(Component__c objComponent : fetchCmpList){
                if(accMapForMerchantInfo.containsKey(objComponent.LinkedDeal_D_O_S__c)){
                     merchantNamesList = accMapForMerchantInfo.get(objComponent.LinkedDeal_D_O_S__c);
                    if(!merchantNamesList.contains(objComponent.Merchant_Name__r.Name)){
                        merchantNamesList.add(objComponent.Merchant_Name__r.Name);
                    }
                     
                }else{
                    if(!merchantNamesList.contains(objComponent.Merchant_Name__r.Name)){
                        merchantNamesList.add(objComponent.Merchant_Name__r.Name);
                    }
                }
               accMapForMerchantInfo.put(objComponent.LinkedDeal_D_O_S__c,merchantNamesList); 
            }
        }
        system.debug('cmpList '+accMapForMerchantInfo);
        if(!accMapForMerchantInfo.isEmpty()){
            for(string dealId : accMapForMerchantInfo.keySet()){
                if(dealId != null){
                Deal__c deal = New Deal__c(Id = dealId);
                if(accMapForMerchantInfo.get(dealId) != Null){
                  deal.List_Of_Merchants__c = String.join(accMapForMerchantInfo.get(dealId),'\n');  
                } else{
                  deal.List_Of_Merchants__c = '';  
                }
                dealListToUpdateMerchantInfo.add(deal);
            }
            }
        }
        system.debug('dealListToUpdateMerchantInfo'+dealListToUpdateMerchantInfo);
        if(!dealListToUpdateMerchantInfo.isEmpty() ){
            
            update dealListToUpdateMerchantInfo;
        }
    }
    //PSAG - 278 Stop
    
    
}