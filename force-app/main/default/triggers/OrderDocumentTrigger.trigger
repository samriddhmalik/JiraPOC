trigger OrderDocumentTrigger on Order_Document__c (after insert, after delete, after undelete) {

    order__c o = new order__c();
    Set<Id> orderIds = new Set<Id>();
    List<order__c> orders;

    if (Trigger.isInsert || Trigger.isUndelete) {
        // Collate order Id's into set
        for (Order_Document__c od : Trigger.new) {
            orderIds.add(od.order__c);
        }
        // Use set to return orders
        orders = [SELECT Id, has_order_documents__c FROM order__c WHERE Id IN :orderIds];
        for (order__c order : orders) {
            // Mark orders as has docs..
            order.has_order_documents__c = true;
        }
        update orders;
    }
    if (Trigger.isDelete) {
        Set<Id> orderIdsToCheck = new Set<Id>();
        for (Order_Document__c od : Trigger.old) {
            orderIdsToCheck.add(od.order__c);
        }
        orders = [SELECT Id, has_order_documents__c FROM order__c WHERE Id IN :orderIdsToCheck];
        List<Order_Document__c> ods = [SELECT Id, order__c FROM Order_Document__c WHERE order__c IN :orderIdsToCheck];
        for (order__c ord : orders) {
            ord.has_order_documents__c = false;
        }
        for (order__c ord : orders) {
            for (Order_Document__c od : ods) {
                if (ord.Id == od.order__c) {
                    ord.has_order_documents__c = true;
                }
            }
        }
        update orders;
    }
}