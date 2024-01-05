global class BAU_List_ofMerchantsOnDeal_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      BAU_List_of_Merchants_On_Deal b = new BAU_List_of_Merchants_On_Deal();
      database.executebatch(b);
   }
}