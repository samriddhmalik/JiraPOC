trigger UpdateOrderIdTrigger on order_item__c (before insert) {
    System.debug('order_item inserting');
}