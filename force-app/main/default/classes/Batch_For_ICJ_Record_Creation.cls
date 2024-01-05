global class Batch_For_ICJ_Record_Creation implements Database.Batchable < sobject >,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String Query = 'Select Id,LinkedDeal_D_O_S__c,(Select Id,Component__c From Itinerary_Component_Joins__r) from Component__c where Component_Days__c !=null AND LinkedDeal_D_O_S__r.Status__c =\'Published\'';
        return Database.getquerylocator(Query);
        
        
    }    
    
    global void execute(Database.BatchableContext bc, List < Component__c > CompList) {
        
        Map<Id,List<Itinerary_Component_Join__c>> itcjMap = New Map<Id,List<Itinerary_Component_Join__c>>();
        List<Itinerary_Component_Join__c> itcjList = new List<Itinerary_Component_Join__c>();
        Set<Id> DealIdSet = new Set<Id>();
        Set<Id> compIdSet = new Set<Id>();
        Set<Id> ItindSet = new Set<Id>();
        List<Component__c> compList1 = new List<Component__c>();
        List<Itinerary__c> itnList = new List<Itinerary__c>();
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        Boolean icj = false;
        
        for(Component__c comp :CompList){
            if(comp.LinkedDeal_D_O_S__c !=null){
                DealIdSet.add(comp.LinkedDeal_D_O_S__c);
            }
            
            if(comp.Itinerary_Component_Joins__r.size() == 0){
                compIdSet.add(comp.Id);
                icj = true;
            }
            
        }
        
        
        if(icj == true){
            itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c =: DealIdSet];
            compList1 = [Select Id,Name,Component_Days__c,Land_Activity__c,Land_Activity__r.itinerary_activity__c,Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c,LinkedDeal_D_O_S__c from Component__c where  Id IN :compIdSet];
            
            
            for(Component__c comp : compList1){ 
                
                String abc;
                if(comp.Component_Days__c == NULL){
                    abc = '1';
                }
                else{
                    
                    if(comp.Component_Days__c.contains('-')){
                        List<String> s = comp.Component_Days__c.split('-');
                        abc =s[0];
                    }
                    else if(comp.Component_Days__c.contains(',')){
                        List<String> s = comp.Component_Days__c.split(',');
                        abc =s[0];
                    }
                    else if(comp.Component_Days__c !=null){
                        String s = comp.Component_Days__c;
                        abc =s;
                    }
                    
                }
                for(Itinerary__c itin : itnList){
                    System.debug('abc'+abc);
                    System.debug('daynumber'+itin.Day_number__c);
                    System.debug('deal'+itin.Deal__c);
                    System.debug('linked'+comp.LinkedDeal_D_O_S__c);
                    if(abc != null){
                        system.debug('Line--67-->'+abc.split(' ')[0]);
                        if(abc.split(' ')[0] == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
                            system.debug('Line--69-->'+abc.split(' ')[0]);
                            Itinerary_Component_Join__c itinerray = new Itinerary_Component_Join__c();
                            itinerray.Component__c = comp.Id;
                            itinerray.Itinerary__c = itin.Id;
                            itinerray.Days_Number__c = itin.Day_number__c; //Changes for Deal Simplification  "Days Number Update On Itinerary junction Point" Flow to deactivated.
                            itnjoinList.add(itinerray);
                        }
                    }
                    else{
                        if(abc == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
                            system.debug('INSIDE LOOP ITIN IF');
                            Itinerary_Component_Join__c itinerray = new Itinerary_Component_Join__c();
                            itinerray.Component__c = comp.Id;
                            itinerray.Itinerary__c = itin.Id;
                            itinerray.Days_Number__c = itin.Day_number__c; //Changes for Deal Simplification  "Days Number Update On Itinerary junction Point" Flow to deactivated.
                            itnjoinList.add(itinerray);
                            system.debug('--itnjoinList-@@-'+itnjoinList);
                        }
                    }
                }
            }
            
            if(!itnjoinList.isEmpty()){
                insert itnjoinList;
            }
        }
    }
    global void finish(database.BatchableContext bc) {}
}