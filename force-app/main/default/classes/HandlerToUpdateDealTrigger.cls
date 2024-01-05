public class HandlerToUpdateDealTrigger {
    
    /* 
     * This function will fetch the TAD orders 
     
     * and count associated OrderLineItems
     
     * Prevent user to update deal field of TAD order
     
     *  if it have OrderLineItems
     
     * */
    
    public static void checkDealBeforeUpdate(Map<Id,TAD_Order__c> newOrderMap, Map<Id,TAD_Order__c> oldOrderMap){
        
        system.debug('newOrderMap-->'+newOrderMap);
        Map<Id, Integer> OrderIdVsLineitemCount = new  Map<Id, Integer>();

        for(AggregateResult result : [Select count(Id)child , ordexp_TAD_Order__c from order_line_item__c where ordexp_TAD_Order__c IN : newOrderMap.keySet() group by ordexp_TAD_Order__c] ){
            system.debug('result '+result);
            Id ordId = (Id) result.get('ordexp_TAD_Order__c');

            if(OrderIdVsLineitemCount != null && !OrderIdVsLineitemCount.containsKey(ordId)){
                
                OrderIdVsLineitemCount.put(ordId,(Integer)result.get('child'));
                
                system.debug('Map values-->'+OrderIdVsLineitemCount);
            }
            
           
        }
         for(TAD_Order__c ord :[Select Id from TAD_Order__c where Id IN :  OrderIdVsLineitemCount.keyset()] ){
                
                if(OrderIdVsLineitemCount.get(ord.Id) > 0 && newOrderMap.containsKey(ord.Id) && oldOrderMap.containsKey(ord.Id) && newOrderMap.get(ord.Id).ordexp_deal__c != oldOrderMap.get(ord.Id).ordexp_deal__c ) {
                   TAD_Order__c oldRecord = newOrderMap.get(ord.Id);
                    oldRecord.ordexp_deal__c.addError('You cannot edit Deal');
                    
                }
              
            }
        
        
    }
    
}