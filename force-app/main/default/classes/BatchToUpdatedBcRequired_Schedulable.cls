global class BatchToUpdatedBcRequired_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      Set<id> dealIds = new Set<id>();
      Map<id,String> dealTobcRqrd=new  Map<id,String>();
      List<Component__c> componentList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Bc_required__c,Merchant_Name__r.Bc_required__c FROM Component__c WHERE Merchant_Name__r.Bc_required__c = 'Yes' ];
       for(Component__c c: componentList){
           dealIds.add(c.LinkedDeal_D_O_S__c);
           dealTobcRqrd.put(c.LinkedDeal_D_O_S__c,'Yes');
       }
      BatchToUpdatedBcRequired b = new BatchToUpdatedBcRequired(dealIds,dealTobcRqrd);
      database.executebatch(b);
   }
}