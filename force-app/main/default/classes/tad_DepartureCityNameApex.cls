public class tad_DepartureCityNameApex {

    public static void OLIInsert(list<order_line_item__c> oliList){
        system.debug('oliList '+oliList);
        Set<Id> ordIdsSet = new Set<Id>();
        Set<Id> depCityIdsSet = new Set<Id>();
        List<String> depCityNameList = new List<String>();
        Map<String,List<String>> depCityNameMap = new Map<String,List<String>>();
        List<TAD_Order__c> tadOrdListToUpdate = New List<TAD_Order__c>();
        
        for(order_line_item__c objOLI:oliList){
            ordIdsSet.add(objOLi.ordexp_TAD_Order__c);
            depCityIdsSet.add(objOLi.Departure_cities__c );
        }
        
        if(!ordIdsSet.isEmpty()){
            system.debug('oliList '+oliList);
            list<order_line_item__c> fetchOLIList = [SELECT Id,ordexp_TAD_Order__c,Departure_cities__c,Departure_cities__r.city__c FROM order_line_item__c WHERE ordexp_TAD_Order__c IN:ordIdsSet AND OLI_Status__c != 'Cancelled'];
            
            if(!fetchOLIList.isEmpty()){
                for(order_line_item__c objOLI:fetchOLIList){
                    if(depCityNameMap.ContainsKey(objOLI.ordexp_TAD_Order__c)){
                        depCityNameList = depCityNameMap.get(objOLI.ordexp_TAD_Order__c);
                        if(!depCityNameList.contains(objOLI.Departure_cities__r.city__c)){
                            depCityNameList.add(objOLI.Departure_cities__r.city__c);
                        }
                        depCityNameMap.put(objOLI.ordexp_TAD_Order__c,depCityNameList);
                    }
                    else{
                        depCityNameList.add(objOLI.Departure_cities__r.city__c);
                        depCityNameMap.put(objOLI.ordexp_TAD_Order__c,depCityNameList);
                    }
				}
                system.debug('depCityNameMap '+depCityNameMap);
            }
            else{
                for(string str : ordIdsSet){
                    TAD_Order__c ord = new TAD_Order__c(Id = str);
                    ord.Departure_City_Text__c = '';
                    tadOrdListToUpdate.add(ord);
                }
            }
            
            if(!depCityNameMap.isEmpty()){
                for(String str:depCityNameMap.keySet()){
                    TAD_Order__c ord = new TAD_Order__c(Id = str);
                    
                    if(depCityNameMap.get(str) != Null){
                        ord.Departure_City_Text__c = String.join(depCityNameMap.get(str), ' & ');
                    }
                    tadOrdListToUpdate.add(ord);
                }
            }
            try{
                system.debug('tadOrdListToUpdate '+tadOrdListToUpdate);
                if(!tadOrdListToUpdate.isEmpty()){
                 update tadOrdListToUpdate;
                }
            }
            catch(exception ex){
                system.debug('exception '+ex.getMessage());
            }
        }  
    }
    /*
    public static void OLIUpdate(list<order_line_item__c> oliList, Map<Id,order_line_item__c> oldMapOLI){
        
    }*/
}