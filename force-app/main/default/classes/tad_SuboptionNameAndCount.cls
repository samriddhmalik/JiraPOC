public class tad_SuboptionNameAndCount{


public static void GetSuboptionAndCount(list<order_line_item__c> oliList){
    system.debug('oliList '+oliList);
	Set<Id> ordIdsSet = new Set<Id>();
	Set<string> subOptionIdsSet = new Set<string>();
	Set<Id> oliIdsSet = new Set<Id>();
	Map<string,list<Order_Line_Item__c>> subOptionMap = new Map<string,list<order_line_item__c>>();

	for(order_line_item__c objOLi:oliList){
                ordIdsSet.add(objOLi.ordexp_TAD_Order__c);
				subOptionIdsSet.add(objOLi.Sub_Options__c);
		}//for loop close
	
    if(!subOptionIdsSet.isEmpty()){
        system.debug('subOptionIdsSet '+subOptionIdsSet);
        List<Sub_Options__c> subOptionList = [select id,name,(select id,name,ordexp_TAD_Order__c from Order_Line_Items__r WHERE (OLI_Status__c='Secured' OR OLI_Status__c='Active' OR OLI_Status__c='On Hold')) from Sub_Options__c WHERE Id IN:subOptionIdsSet];
        list<order_line_item__c> oliListWithTadOrder = new List<order_line_item__c>();
        system.debug('subOptionList '+subOptionList);
        for(Sub_Options__c subOpt:subOptionList){
            system.debug('subOpt.Id '+subOpt.Id);
            system.debug('subOpt.Order_Line_Items__r '+subOpt.Order_Line_Items__r);
            subOptionMap.put(subOpt.Id,subOpt.Order_Line_Items__r);
        	}
    	}
    if(!ordIdsSet.isEmpty()){
        List<TAD_Order__c> fetchTadOrder = [SELECT Id,Name,Suboption_Text__c,(SELECT Id,Name,ordexp_TAD_Order__c,Sub_Options__r.Name,Sub_Options__c FROM Order_Line_Items_orders__r) FROM TAD_Order__c WHERE Id IN:ordIdsSet];
        system.debug('fetchTadOrder ' +fetchTadOrder);
        if(!fetchTadOrder.isEmpty()){
            list<order_line_item__c> oliListWithTadOrder = new List<order_line_item__c>();
            
            for(TAD_Order__c ord:fetchTadOrder){
                set<string> strSet = new set<string>();
                oliListWithTadOrder = ord.Order_Line_Items_orders__r;
                if(!oliListWithTadOrder.isEmpty()){
                    for(order_line_item__c oli:oliListWithTadOrder){
                        //system.debug('subOptionMap '+subOptionMap);
                        
                        string subCount;
                        if(oli.ordexp_TAD_Order__c==ord.Id){
                            //subCount = oli.Sub_Options__r.Name+'='+subOptionMap.get(oli.Sub_Options__c).size();
                        }
                        strSet.add(oli.Sub_Options__r.Name);
                    }
                }
    		  List <String> strList = new List <String>(strSet);
              ord.Suboption_Text__c = String.join(strList, ' | ' );
            }
            update fetchTadOrder;
        }
    }
  }
    
    public static void GetSuboptionOLIUpdate(list<order_line_item__c> oliList,Map<Id,order_line_item__c> oliOldMap){
        
        system.debug('oliList '+oliList);
        system.debug('oliList '+oliOldMap);
		Set<Id> ordIdsSet = new Set<Id>();
		Set<string> subOptionIdsSet = new Set<string>();
		Set<Id> oliIdsSet = new Set<Id>();
        Map<string,list<Order_Line_Item__c>> subOptionMap = new Map<string,list<order_line_item__c>>();
        
        for(order_line_item__c objOLi:oliList){
            order_line_item__c oldOli = oliOldMap.get(objOLi.Id);
            system.debug('oldOli '+oldOli);
            if((objOLi.OLI_Status__c!=oldOli.OLI_Status__c) || (objOLi.Sub_Options__c!=oldOli.Sub_Options__c)){
                ordIdsSet.add(objOLi.ordexp_TAD_Order__c);
				subOptionIdsSet.add(objOLi.Sub_Options__c);
            }
        }
        if(!subOptionIdsSet.isEmpty()){
        system.debug('subOptionIdsSet '+subOptionIdsSet);
        List<Sub_Options__c> subOptionList = [select id,name,(select id,name,ordexp_TAD_Order__c from Order_Line_Items__r WHERE (OLI_Status__c='Secured' OR OLI_Status__c='Active' OR OLI_Status__c='On Hold')) from Sub_Options__c WHERE Id IN:subOptionIdsSet];
        list<order_line_item__c> oliListWithTadOrder = new List<order_line_item__c>();
        system.debug('subOptionList '+subOptionList);
        
         for(Sub_Options__c subOpt:subOptionList){
            system.debug('subOpt.Id '+subOpt.Id);
            system.debug('subOpt.Order_Line_Items__r '+subOpt.Order_Line_Items__r);
            subOptionMap.put(subOpt.Id,subOpt.Order_Line_Items__r);
        	}
    	}
        if(!ordIdsSet.isEmpty()){
        List<TAD_Order__c> fetchTadOrder = [SELECT Id,Name,Suboption_Text__c,(SELECT Id,Name,ordexp_TAD_Order__c,Sub_Options__r.Name,Sub_Options__c FROM Order_Line_Items_orders__r WHERE (OLI_Status__c='Secured' OR OLI_Status__c='Active'  OR OLI_Status__c='On Hold')) FROM TAD_Order__c WHERE Id IN:ordIdsSet];
        system.debug('fetchTadOrder ' +fetchTadOrder);
        if(!fetchTadOrder.isEmpty()){
            list<order_line_item__c> oliListWithTadOrder = new List<order_line_item__c>();
            
            for(TAD_Order__c ord:fetchTadOrder){
                set<string> strSet = new set<string>();
                oliListWithTadOrder = ord.Order_Line_Items_orders__r;
                if(!oliListWithTadOrder.isEmpty()){
                    for(order_line_item__c oli:oliListWithTadOrder){
                        //system.debug('subOptionMap '+subOptionMap);
                        
                        string subCount;
                        if(oli.ordexp_TAD_Order__c==ord.Id){
                            //subCount = oli.Sub_Options__r.Name+'='+subOptionMap.get(oli.Sub_Options__c).size();
                        }
                        strSet.add(oli.Sub_Options__r.Name);
                    }
                }
    		  List <String> strList = new List <String>(strSet);
              ord.Suboption_Text__c = String.join(strList, ' | ' );
            }
            update fetchTadOrder;
        }
    }
    }
}