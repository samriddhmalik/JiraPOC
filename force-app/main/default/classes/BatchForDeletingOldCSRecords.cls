global class BatchForDeletingOldCSRecords implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {       
        
        Date depDate = Date.parse('31/01/2023');
        String dt = String.valueOf(depDate);
        system.debug('Line8'+dt);
        String query= 'Select Id, ordexp_master_status__c from TAD_Order__c where (ordexp_master_status__c =\'In Progress\' OR ordexp_master_status__c =\'Cancelled\' OR ordexp_master_status__c =\'Secured\') AND'+
            +  ' ordexp_departure_date__r.date__c > '+ dt + ' ' ;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<TAD_Order__c> scope)
    {
        
        system.debug('scope of TAD Orders '+scope);
        Set<Id> orderIdSet = new Set<Id>();        
        Set<Id> oliList = new Set<Id>();
        List<order_line_item__c> oliDataList = new List<order_line_item__c>();
        List<Addon__c> addonDataList = new List<Addon__c>();        
        List<Itinerary__c> itnList = new List<Itinerary__c>();        
        List<order_line_POE__c> olList = New List<order_line_POE__c>();
        Set<Id> tadOrderPositiveSet = new Set<Id>();
        
        for(TAD_Order__c d: scope)
        {
            if(d.ordexp_master_status__c != 'Cancelled'){
                tadOrderPositiveSet.add(d.Id);
            }
            orderIdSet.add(d.Id);
        }
        
        system.debug('orderIdSet-21-->'+orderIdSet.size());
        
        if(orderIdSet.size() > 0){            
            // Delete for old cs attribution record
            List<CS_Attribution_POE__c> csDataList = [select id,cs_Attribution_Type__c,TAD_Order__r.ordexp_master_status__c from CS_Attribution_POE__c where TAD_Order__c IN: orderIdSet];
            system.debug('csDataList-42-->'+csDataList); 
            if(!csDataList.isEmpty()){
                Delete csDataList;  
            }
            
            if(tadOrderPositiveSet.size() > 0){
                oliDataList = [select id,Attribution__c,ordexp_suboption_amount__c,HSS_Amount__c,ordexp_city_surcharge_amount__c,Total_surcharge__c,CreatedById,ordexp_TAD_Order__c,ordexp_TAD_Order__r.Web_Agent__c,CurrencyIsoCode from order_line_item__c where ordexp_TAD_Order__c IN: tadOrderPositiveSet AND (OLI_Status__c = 'Active' OR OLI_Status__c = 'Secured')];
                
                if(!oliDataList.isEmpty()){
                    for(order_line_item__c ol: oliDataList)
                    {
                        oliList.add(ol.Id);
                        //  system.debug('oliList-28-->'+oliList);
                    }
                }
                if(oliList.size() > 0){
                    addonDataList = [select id,ordexp_amount__c,CreatedById,CurrencyIsoCode,TAD_Order_Id__c,Order_Line_Item__r.ordexp_TAD_Order__r.Web_Agent__c,Order_Line_Item__c,Attribution__c from AddOn__c where Order_Line_Item__c IN: oliList AND (AddOn_Status__c ='Active' Or AddOn_Status__c ='Secured')];
                }  
            }
        } 
        system.debug('addonDataList'+addonDataList);
        
        
        List<CS_Attribution_POE__c> listOfOliCsAttribute = new List<CS_Attribution_POE__c>();
        if(!oliDataList.isEmpty()){
        for(Order_line_item__c oli : oliDataList){ 
            CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
            CS_Attribution_POE__c cs1 = new CS_Attribution_POE__c();
            CS_Attribution_POE__c cs2 = new CS_Attribution_POE__c(); 
            
            // Card CSA-7 For hss Amount and ordexp_city_surcharge_amount__c is Equal to 0
            cs.cs_Attribution_Type__c = 'Sub Option';
            cs.cs_OLI__c = oli.Id;
            if(oli.Attribution__c != Null){
                cs.cs_Sale_Amount__c = oli.ordexp_suboption_amount__c==null?0:(((oli.ordexp_suboption_amount__c + oli.Total_surcharge__c)*oli.Attribution__c)/100);   
                    }
            cs.TAD_Order__c = oli.ordexp_TAD_Order__c;
            cs.cs_status__c ='Sold';
            cs.CurrencyIsoCode =oli.CurrencyIsoCode;
            cs.User__c = oli.ordexp_TAD_Order__r.Web_Agent__c == null ? oli.CreatedById : oli.ordexp_TAD_Order__r.Web_Agent__c;
            
            
            listOfOliCsAttribute.add(cs);   
            
            // Card CSA-9 For ordexp_city_surcharge_amount__c greater than 0
            if(oli.ordexp_city_surcharge_amount__c >0){
                cs1.cs_Attribution_Type__c = 'Dep City Surcharge';
                cs1.cs_OLI__c = oli.Id;               
                if(oli.Attribution__c != Null){
                    cs1.cs_Sale_Amount__c = oli.ordexp_city_surcharge_amount__c==null?0:((oli.ordexp_city_surcharge_amount__c*oli.Attribution__c)/(100));
                        }
                cs1.TAD_Order__c = oli.ordexp_TAD_Order__c;
                cs1.cs_status__c ='Sold';
                cs1.CurrencyIsoCode =oli.CurrencyIsoCode;
                cs1.User__c = oli.ordexp_TAD_Order__r.Web_Agent__c == null ? oli.CreatedById : oli.ordexp_TAD_Order__r.Web_Agent__c;
                listOfOliCsAttribute.add(cs1);                  
            }
            
            // Card CSA-8 For hss Amount s greater than 0
            if(oli.HSS_Amount__c > 0){
                cs2.cs_Attribution_Type__c = 'Dep Date HSS';
                cs2.cs_OLI__c = oli.Id;
                if(oli.Attribution__c != Null){
                    cs2.cs_Sale_Amount__c = oli.HSS_Amount__c==null?0:((oli.HSS_Amount__c*oli.Attribution__c)/(100)); 
                        }
                cs2.TAD_Order__c = oli.ordexp_TAD_Order__c;
                cs2.cs_status__c ='Sold';
                cs2.CurrencyIsoCode =oli.CurrencyIsoCode;
                cs2.User__c = oli.ordexp_TAD_Order__r.Web_Agent__c == null ? oli.CreatedById : oli.ordexp_TAD_Order__r.Web_Agent__c;
                listOfOliCsAttribute.add(cs2);  
                
            }    
        }
        }
        
        system.debug('line90'+listOfOliCsAttribute);       
        
        List<CS_Attribution_POE__c> listOfAddonCsAttribute = new List<CS_Attribution_POE__c>();
        
        if(!addonDataList.isEmpty()){
            for(AddOn__c addOn : addonDataList){
                CS_Attribution_POE__c csAttForAddOn = new CS_Attribution_POE__c();
                csAttForAddOn.cs_Attribution_Type__c = 'Addon';
                csAttForAddOn.cs_AddOn__c = addOn.Id;
                csAttForAddOn.cs_OLI__c = addOn.Order_Line_Item__c;
                if(addOn.Attribution__c != Null){
                    csAttForAddOn.cs_Sale_Amount__c = addOn.ordexp_amount__c == null || addOn.ordexp_amount__c == 0.00 ? 0 :((addOn.ordexp_amount__c * addOn.Attribution__c)/(100)); 
                        }
                system.debug('ordexp_amount__c line 123'+csAttForAddOn.cs_Sale_Amount__c);
                csAttForAddOn.TAD_Order__c = addOn.TAD_Order_Id__c;
                csAttForAddOn.cs_status__c ='Sold';
                csAttForAddOn.CurrencyIsoCode =addOn.CurrencyIsoCode;
                csAttForAddOn.User__c =  addOn.Order_Line_Item__r.ordexp_TAD_Order__r.Web_Agent__c == null ? addOn.CreatedById : addOn.Order_Line_Item__r.ordexp_TAD_Order__r.Web_Agent__c;
                listOfAddonCsAttribute.add(csAttForAddOn); 
                
            }  
        }
        
        
        
        
        if(!listOfOliCsAttribute.isEmpty()){
            Database.insert(listOfOliCsAttribute, false);
            
            
        }  
        if(!listOfAddonCsAttribute.isEmpty()){
            Database.insert(listOfAddonCsAttribute, false);
            
        }
        
        
    }
    
    
    
    
    global void finish(Database.BatchableContext bc)
    {
    }
}