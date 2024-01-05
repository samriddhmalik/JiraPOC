public class MP_ItineraryComponentJoinRecordCreation {
    Public static Boolean firstcall=false;
    public static void ItineraryComponentJoinCreation(List<land_activity__c> landActList){
        
        Set<Id> LandActIdSet = new Set<Id>();
        Set<Id> DealIdSet = new Set<Id>();
        
        Set<Id> compIdSet = new Set<Id>();
        Set<Id> ItindSet = new Set<Id>();
        List<Component__c> compList = new List<Component__c>();
        List<Itinerary__c> itnList = new List<Itinerary__c>();
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        
        
        for(land_activity__c la:landActList){
            if(la.itinerary_activity__c !=null){
                LandActIdSet.add(la.Id);
                DealIdSet.add(la.Deal__c);
            }
        }
        
        
        itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c =: DealIdSet];
        compList = [Select Id,Name,Component_Days__c,Land_Activity__c,Land_Activity__r.itinerary_activity__c,Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c,LinkedDeal_D_O_S__c from Component__c where Land_Activity__c =: LandActIdSet AND LinkedDeal_D_O_S__c =: DealIdSet];
        
        for(Component__c comp : compList){ 
            
            String abc;
            if(comp.Land_Activity__r.itinerary_activity__c == NULL){
                abc = '1';
            }
            else{
                
                abc = string.valueOf(comp.Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c);
            }
            for(Itinerary__c itin : itnList){
                if(abc == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
                    Itinerary_Component_Join__c itinerray = new Itinerary_Component_Join__c();
                    itinerray.Component__c = comp.Id;
                    itinerray.Itinerary__c = itin.Id;
                    itinerray.Days_Number__c = itin.Day_number__c; //Changes for Deal Simplification  "Days Number Update On Itinerary junction Point" Flow to deactivated.
                    
                    itnjoinList.add(itinerray);
                }
            }
        }
        if(!itnjoinList.isEmpty()){
            insert itnjoinList;
        }
    }
    
    public static void ItineraryComponentJoinCreationOnComponent(list<Component__c> compList){
        
        Set<Id> LandActIdSet = new Set<Id>();
        Set<Id> DealIdSet = new Set<Id>();
        
        Set<Id> compIdSet = new Set<Id>();
        Set<Id> ItindSet = new Set<Id>();
        List<Component__c> compList1 = new List<Component__c>();
        List<Itinerary__c> itnList = new List<Itinerary__c>();
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        
        for(Component__c comp:compList){
            if(comp.LinkedDeal_D_O_S__c !=null){
                DealIdSet.add(comp.LinkedDeal_D_O_S__c);
            }
            compIdSet.add(comp.Id);
        }
        
        List<Itinerary_Component_Join__c>       dltitnList = [select id from Itinerary_Component_Join__c where Component__c =: compIdSet];
        delete dltitnList;
        
        itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c =: DealIdSet];
        compList = [Select Id,Name,Component_Days__c,Land_Activity__c,Land_Activity__r.itinerary_activity__c,Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c,LinkedDeal_D_O_S__c from Component__c where  id IN:compIdSet ];
        
        for(Component__c comp : compList){ 
            
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
                    if(abc.split(' ')[0] == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
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
    //PBP - 267 And PBP - 268 Start
    public static void ItineraryComponentJoinCreationOnItinerary(list<Itinerary__c> ItineraryList){
        Set<Id> DealIdSet = new Set<Id>();
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        
        for(Itinerary__c objItinerary : ItineraryList){
            if(objItinerary.Deal__c !=null){
                DealIdSet.add(objItinerary.Deal__c);
            }
        }
        
        if(!DealIdSet.isEmpty()){
            //Delete exsiting reocords    
            List<Itinerary_Component_Join__c> ItineraryCompJoinListToDelete = [select id from Itinerary_Component_Join__c where Itinerary__c IN :  ItineraryList];
            if(!ItineraryCompJoinListToDelete.isEmpty()){
                delete ItineraryCompJoinListToDelete;  
            }    
            
            list<Itinerary__c> itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c =:  DealIdSet];
            List<Component__c> compList = [Select Id,Name,Component_Days__c,Land_Activity__c,Land_Activity__r.itinerary_activity__c,Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c,LinkedDeal_D_O_S__c from Component__c where  LinkedDeal_D_O_S__c IN:DealIdSet ]; 
            
            
            for(Component__c comp : compList){ 
                
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
                    if(abc != null){
                        if(abc.split(' ')[0] == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
                            System.debug('abc'+abc);
                            System.debug('daynumber'+itin.Day_number__c);
                            System.debug('deal'+itin.Deal__c);
                            System.debug('linked'+comp.LinkedDeal_D_O_S__c);
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
            system.debug('itnjoinList '+itnjoinList);
            if(!itnjoinList.isEmpty()){
                insert itnjoinList;
            }
            
        }
    }
    
  
    public static void ItineraryComponentJoinCreationOnDealUpdate(Set<Id> dealIdSet){
        
        if(!DealIdSet.isEmpty()){
            //Delete exsiting reocords    
            List<Itinerary_Component_Join__c> ItineraryCompJoinListToDelete = [select id from Itinerary_Component_Join__c where Component__r.LinkedDeal_D_O_S__c IN :  dealIdSet OR  Itinerary__r.Deal__c IN : dealIdSet];
            system.debug('ItineraryCompJoinListToDelete '+ItineraryCompJoinListToDelete.size());
            if(!ItineraryCompJoinListToDelete.isEmpty()){
                delete ItineraryCompJoinListToDelete;  
            }    
            MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinRecordCreationOnDeal(DealIdSet);//PSAG - 338
        }
    }
    //PBP - 267 And PBP - 268 Stop
    
    //PSAG - 338 Start
    @future
    public static void ItineraryComponentJoinRecordCreationOnDeal(Set<Id> dealIdSet){
        List<Itinerary_Component_Join__c> itnjoinList = new List<Itinerary_Component_Join__c>();
        
        list<Itinerary__c> itnList = [select id ,Day_number__c,Deal__c from Itinerary__c where Deal__c =:  DealIdSet];
        List<Component__c> compList = [Select Id,Name,Component_Days__c,Land_Activity__c,Land_Activity__r.itinerary_activity__c,Land_Activity__r.itinerary_activity__r.main_tour_activity_day__c,LinkedDeal_D_O_S__c from Component__c where  LinkedDeal_D_O_S__c IN:DealIdSet ]; 
            
            
            for(Component__c comp : compList){ 
                
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
                    if(abc != null){
                        if(abc.split(' ')[0] == String.valueOf(itin.Day_number__c) && itin.Deal__c == comp.LinkedDeal_D_O_S__c){
                            System.debug('abc'+abc);
                            System.debug('daynumber'+itin.Day_number__c);
                            System.debug('deal'+itin.Deal__c);
                            System.debug('linked'+comp.LinkedDeal_D_O_S__c);
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
            system.debug('itnjoinList '+itnjoinList);
            if(!itnjoinList.isEmpty()){
                insert itnjoinList;
            }
    }
    //PSAG - 338 Stop
}