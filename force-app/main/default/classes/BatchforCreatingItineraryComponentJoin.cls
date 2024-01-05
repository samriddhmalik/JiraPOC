global class BatchforCreatingItineraryComponentJoin implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from Deal__c';
        //return Database.QueryLocator(query);
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<Deal__c> scope)
    {
        Set<Id> dealIdSet = new Set<Id>();
        Set<Id> compIdSet = new Set<Id>();
        List<Component__c> compList = new List<Component__c>();
        List<Itinerary__c> itnList = new List<Itinerary__c>();
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        List<order_line_POE__c> olList = New List<order_line_POE__c>();
        for(Deal__c d: scope)
        {
            dealIdSet.add(d.Id);
            system.debug('dealIdSet-27-->'+dealIdSet);
        }
        if(dealIdSet.size() > 0){
            compList = [select id ,Component_Days__c,LinkedDeal_D_O_S__c from Component__c where LinkedDeal_D_O_S__c IN: dealIdSet AND Start_Date__c =null];
            itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c IN: dealIdSet];
        }
        system.debug('compList--34-->'+compList);
        system.debug('itnList--35-->'+itnList);
        for(Component__c comp : compList){ 
            String abc;
            if(comp.Component_Days__c ==NULL){
                abc = '1';
            }
            else{
                List<String> s = comp.Component_Days__c.split('-');
                system.debug('s---39--->'+s);
                abc =s[0];
                system.debug('abc'+abc);
            }
            for(Itinerary__c itin : itnList){
                if(abc == String.valueOf(itin.Day_number__c)){
                    Itinerary_Component_Join__c itinerray = new Itinerary_Component_Join__c();
                    itinerray.Component__c = comp.Id;
                    itinerray.Itinerary__c = itin.Id;
                    itnjoinList.add(itinerray);
                    system.debug('--itnjoinList-@@-'+itnjoinList);
                }
            }
            system.debug('---itnjoinList--'+itnjoinList);
        }
        system.debug('--itnjoinList-##-'+itnjoinList);
        if(!itnjoinList.isEmpty()){
            insert itnjoinList;
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }
}