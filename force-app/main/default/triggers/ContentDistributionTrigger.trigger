trigger ContentDistributionTrigger on ContentDistribution (after insert, after delete, after undelete) {

    order__c o = new order__c();
    Set<Id> orderIds = new Set<Id>();
    Set<Id> tadOrderIds = new Set<Id>();
    List<order__c> orders;
    List<TAD_Order__c> tadOrders;
    if (Trigger.isInsert || Trigger.isUndelete) {
        for (ContentDistribution contentDistribution : Trigger.new) {
            if (contentDistribution.RelatedRecordId != null) {
                if (String.valueOf(contentDistribution.RelatedRecordId).left(3) == 'a2f') {
                orderIds.add(contentDistribution.RelatedRecordId);
                }
                // For Tad Order Start card no. pbp-176
                if (String.valueOf(contentDistribution.RelatedRecordId).left(3) == 'aGU') {
                tadOrderIds.add(contentDistribution.RelatedRecordId);
                }
                
                //////----------------End---------
            }
        }
        
        // --------For Tad Order Start card no. pbp-176 -------
         if (!tadOrderIds.isEmpty()) {
            tadOrders = [SELECT Id, ordexp_has_extra_documents__c FROM TAD_Order__c WHERE Id IN :tadOrderIds];
            for (TAD_Order__c tadorder : tadOrders) {
                tadorder.ordexp_has_extra_documents__c = true;
            }
            update tadOrders;
        }
        
        
        //-------------------End--------------
        if (!orderIds.isEmpty()) {
            orders = [SELECT Id, has_extra_documents__c FROM order__c WHERE Id IN :orderIds];
            for (order__c order : orders) {
                order.has_extra_documents__c = true;
            }
            update orders;
        }
    }
    if (Trigger.isDelete) {
        Set<Id> orderIdsToCheck = new Set<Id>();
        Set<Id> tadOrderIdsToCheck = new Set<Id>();
        for (ContentDistribution contentDistribution : Trigger.old) {
            if (String.valueOf(contentDistribution.RelatedRecordId).left(3) == 'a2f') {
                orderIdsToCheck.add(contentDistribution.RelatedRecordId);
            }
          //------------------ For Tad Order Start card no. pbp-176--------------
             if (String.valueOf(contentDistribution.RelatedRecordId).left(3) == 'aGU') {
                tadOrderIdsToCheck.add(contentDistribution.RelatedRecordId);
            }
        }
        orders = [SELECT Id, has_extra_documents__c FROM order__c WHERE Id IN :orderIdsToCheck];
        tadOrders = [SELECT Id, ordexp_has_extra_documents__c FROM TAD_Order__c WHERE Id IN :tadOrderIdsToCheck];
        List<ContentDistribution> cds = [SELECT Id, RelatedRecordId FROM ContentDistribution WHERE RelatedRecordId IN :orderIdsToCheck];
       
        // ---------For Tad Order  By Munesh--------
        if(!tadOrderIdsToCheck.isEmpty()){
            
             List<ContentDistribution> cdsforTadOrder = [SELECT Id, RelatedRecordId FROM ContentDistribution WHERE RelatedRecordId IN :orderIdsToCheck];
        
        for (TAD_Order__c tadOrd : tadOrders) {
                tadOrd.ordexp_has_extra_documents__c = false;
        }
                   
        update tadOrders;    
        }
       
        
        
        for (order__c ord : orders) {
                ord.has_extra_documents__c = false;
        }
        for (order__c ord : orders) {
            for (ContentDistribution cd : cds) {
                if (ord.Id == cd.RelatedRecordId) {
                    ord.has_extra_documents__c = true;
                }
            }
        }
        update orders;
         update tadOrders;
    }
}