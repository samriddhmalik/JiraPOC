trigger MasterordercTrigger on order__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ordercDataBundler bundle;
    
    ordercTriggerHandler oTHandler = new ordercTriggerHandler(Trigger.isExecuting, Trigger.size);
    //SiteMinderUtilClass sMHandler = new SiteMinderUtilClass(Trigger.isExecuting, Trigger.size);
    
    List<order__c> ordRecNewListNonSiteMinder = new List<order__c>();
    Map<id,order__c> ordRecNewMapNonSiteMinder = new Map<id,order__c>();
    List<order__c> ordRecOldListNonSiteMinder = new List<order__c>();
    Map<Id,order__c> ordRecOldMapNonSiteMinder = new  Map<Id,order__c>();
    
    List<order__c> ordRecNewListSiteMinder = new List<order__c>();
    Map<id,order__c> ordRecNewMapSiteMinder = new Map<id,order__c>();
    List<order__c> ordRecOldListSiteMinder = new List<order__c>();
    Map<Id,order__c> ordRecOldMapSiteMinder = new  Map<Id,order__c>();
    
    // Code to Decide Which Path to take
    Set<Id> dealIds = new Set<Id>();
    for(order__c ord : trigger.New){
        dealIds.add(ord.deal__c);
    }
    
    Map<Id, Deal__c> deals = new Map<Id, Deal__c>([SELECT Id, Name,RecordType.name FROM Deal__c WHERE Id IN :dealIds]);
    
    for(order__c ord : trigger.New){
        if(deals.get(ord.deal__c).RecordType.name=='Hotel' && ord.order_status__c !='Migrate' && ord.order_status__c !='Migrated'){
            ordRecNewListSiteMinder.add(ord);
            if(trigger.newMap !=null){
                ordRecNewMapSiteMinder.put(ord.id,trigger.newMap.get(ord.id));  
            }
            if( trigger.oldMap !=null){
                ordRecOldListSiteMinder.add(trigger.oldMap.get(ord.id)); 
                ordRecOldMapSiteMinder.put(ord.id,trigger.oldMap.get(ord.id)); 
            }
        }else{
            ordRecNewListNonSiteMinder.add(ord); 
            if(trigger.newMap !=null){
                ordRecNewMapNonSiteMinder.put(ord.id,trigger.newMap.get(ord.id));  
            }
            if( trigger.oldMap !=null){
                ordRecOldListNonSiteMinder.add(trigger.oldMap.get(ord.id)); 
                ordRecOldMapNonSiteMinder.put(ord.id,trigger.oldMap.get(ord.id)); 
            }
            
        }   
    }
    
    // Old flow Runs Here
    if(!ordRecNewListNonSiteMinder.isEmpty()){
        if(Trigger.isInsert && Trigger.isBefore){
            
            oTHandler.OnBeforeInsert(ordRecNewListNonSiteMinder);
        }
        else if(Trigger.isInsert && Trigger.isAfter){
            oTHandler.OnAfterInsert(ordRecNewListNonSiteMinder);
        }
        else if(Trigger.isUpdate && Trigger.isBefore){
            if (ordercTriggerHandler.firstBeforeUpdate) {
                bundle = new ordercDataBundler(ordRecNewListNonSiteMinder);
                ordercTriggerHandler.firstBeforeUpdate = false;
                oTHandler.OnBeforeUpdate(ordRecOldListNonSiteMinder, ordRecNewListNonSiteMinder, ordRecNewMapNonSiteMinder, ordRecOldMapNonSiteMinder, bundle);
            }
        }
        else if(Trigger.isUpdate && Trigger.isAfter){
            if (ordercTriggerHandler.firstAfterUpdate) {
                ordercTriggerHandler.firstAfterUpdate = false;
                oTHandler.OnAfterUpdate(ordRecOldListNonSiteMinder, ordRecNewListNonSiteMinder, ordRecNewMapNonSiteMinder);
            }
        } 
    }
    
    // New SiteMinder flow Runs Here
    if(!ordRecNewListSiteMinder.isEmpty()){
      
        if(Trigger.isInsert && Trigger.isBefore){
            SiteMinderUtilClass.validationSiteMinder(ordRecNewListSiteMinder);
            SiteMinderUtilClass.calculatePricingSiteMinder(ordRecNewListSiteMinder,'Create');
        }
        if(Trigger.isInsert && Trigger.isAfter){
            SiteMinderUtilClass.createOrderNightRecords(ordRecNewListSiteMinder);
            SiteMinderUtilClass.createPaymentTransactionRecords(ordRecNewListSiteMinder);
            
            // Code checks and creates order Coupon
            List<order__c> orderCouponToProcess = new List<order__c>();
            for(order__c order : ordRecNewListSiteMinder){
                if(!String.isBlank(order.coupon__c)){
                    orderCouponToProcess.add(order);
                }   
            }
            if(!orderCouponToProcess.isEmpty()){
               SiteMinderUtilClass.handleCoupons(orderCouponToProcess);  
            }
            // Code checks and creates order Coupon ends
        }
        
        if(Trigger.isUpdate && Trigger.isBefore){
            
            List<order__c> revalidateOrderPrice = new List<order__c>();
            String status = 'NoChange';
            for(order__c order : ordRecNewListSiteMinder){
                if((order.Options__c != ordRecOldMapSiteMinder.get(order.id).Options__c) || (order.departures_dates__c != ordRecOldMapSiteMinder.get(order.id).departures_dates__c) || (order.Sub_Options__c != ordRecOldMapSiteMinder.get(order.id).Sub_Options__c )){
                    revalidateOrderPrice.add(order);   
                }
            }
            
            if(!revalidateOrderPrice.isEmpty()){
                SiteMinderUtilClass.calculatePricingSiteMinder(revalidateOrderPrice,'Update'); 
                status='Update';
            }
            
            SiteMinderUtilClass.updateAutoValues(ordRecNewListSiteMinder,status);
        }
        if(Trigger.isUpdate && Trigger.isAfter){
            
            List<order__c> orderCouponToProcess = new List<order__c>();
            List<order__c> orderForPayment = new List<order__c>();
            
            for(order__c order : ordRecNewListSiteMinder){
                if(order.coupon__c != ordRecOldMapSiteMinder.get(order.id).coupon__c){
                    orderCouponToProcess.add(order);
                }
                if(order.web_payment_processed__c == false && order.web_json__c!=null){
                    orderForPayment.add(order);   
                }
            }
            
            if(!orderCouponToProcess.isEmpty()){
               SiteMinderUtilClass.handleCoupons(orderCouponToProcess);  
            }
            
            if(!orderForPayment.isEmpty()){
                SiteMinderUtilClass.createPaymentTransactionRecords(orderForPayment);  
            }

            SiteMinderUtilClass.updateOrderNightRecords(ordRecNewListSiteMinder,trigger.oldMap);
            
        }
    }
    
    //  else if(Trigger.isDelete && Trigger.isBefore){
    //    oTHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    //  }
    //  else if(Trigger.isDelete && Trigger.isAfter){
    //    oTHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    //    ordercTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
    //  }
    //  else if(Trigger.isUnDelete){
    //    oTHandler.OnUndelete(Trigger.new);
    //  }
}