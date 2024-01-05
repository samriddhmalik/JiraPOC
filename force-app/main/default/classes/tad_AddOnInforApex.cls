public class tad_AddOnInforApex {
	//Card : PBP-100
    public static void AddOnDetails(list<AddOn__c> addOnRecords){
		system.debug('addOnRecords '+addOnRecords);
        set<string> tadOrdIdsSet = new set<string>();
        Map<string,Set<String>> addOnInfoMap = new Map<string,Set<String>>();
        Map<string,string> ordSubOptTextMap = new Map<string,string>();
        Map<string,string> addOnTypeMap = new Map<string,string>();
        Map<String,integer> addOnCountMap = new Map<String,integer>();
        Map<String,integer> addOnTotalCountMap = new Map<String,integer>();//PBP - 358
        
        List<TAD_Order__c> ordToUpdate = new List<TAD_Order__c>();
        for(AddOn__c objAddOn:addOnRecords){
            tadOrdIdsSet.add(objAddOn.TAD_Order_Id__c );
        }
        
        if(!tadOrdIdsSet.isEmpty()){
            system.debug('tadOrdIdsSet '+tadOrdIdsSet);
            list<AddOn__c> fetchAllAddsForOrder = [Select Id,Name,ordexp_AddOn_Name__c,Record_Type_Name__c,TAD_Order_Id__c,Order_Line_Item__r.ordexp_TAD_Order__c,Order_Line_Item__r.ordexp_TAD_Order__r.Suboption_Text__c,RecordType.DeveloperName,AE_SB__r.Name,Airline_Upgrade__r.Name,Sub_Stopover__r.Name,land_activity__r.name FROM AddOn__c WHERE TAD_Order_Id__c IN:tadOrdIdsSet AND AddOn_Status__c != 'Cancelled'];
            system.debug('fetchAllAddsForOrder '+fetchAllAddsForOrder);
            if(!fetchAllAddsForOrder.isEmpty()){
                for(AddOn__c objAddOn:fetchAllAddsForOrder){
                    system.debug('RecordType.DeveloperName '+objAddOn.RecordType.DeveloperName);

                        if(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__r.Suboption_Text__c != Null){
                            //ordSubOptTextMap.put(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c,objAddOn.Order_Line_Item__r.ordexp_TAD_Order__r.Suboption_Text__c);
                        }
                    
                    Set <String> strSet = new Set <String>();
                    
                                        
                    //PBP - 358 Start
                    if(!addOnTotalCountMap.containsKey(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c)){
                        addOnTotalCountMap.put(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c,1);
                    }else{
                        
                        integer countTotalAddOn = addOnTotalCountMap.get(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c)+1;
                        addOnTotalCountMap.put(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c,countTotalAddOn);
                    }
                    system.debug('addOnTotalCountMap '+addOnTotalCountMap);
                    //PBP - 358 Stop
                    
                    if(addOnInfoMap.containsKey(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c)){
                        strSet = addOnInfoMap.get(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c);

                        if(objAddOn.AE_SB__c != Null){
                           strSet.add(objAddOn.AE_SB__r.Name);
                            
                            //get the count of Addon - Start
                            if(!addOnCountMap.containsKey(objAddOn.AE_SB__r.Name)){
        						addOnCountMap.put(objAddOn.AE_SB__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.AE_SB__r.Name)+1;
        						addOnCountMap.put(objAddOn.AE_SB__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.AE_SB__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End
                        }   
                        if(objAddOn.Airline_Upgrade__c != Null){
                            strSet.add(objAddOn.Airline_Upgrade__r.Name);
                            
                            //get the count of Addon - Start
                           if(!addOnCountMap.containsKey(objAddOn.Airline_Upgrade__r.Name)){
        						addOnCountMap.put(objAddOn.Airline_Upgrade__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.Airline_Upgrade__r.Name)+1;
        						addOnCountMap.put(objAddOn.Airline_Upgrade__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.Airline_Upgrade__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End
 
                        }
                        if(objAddOn.land_activity__c != Null){
                            strSet.add(objAddOn.land_activity__r.Name);
                            
                            //get the count of Addon - Start
                           if(!addOnCountMap.containsKey(objAddOn.land_activity__r.Name)){
        						addOnCountMap.put(objAddOn.land_activity__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.land_activity__r.Name)+1;
        						addOnCountMap.put(objAddOn.land_activity__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.land_activity__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End
                            
                        }
                        if(objAddOn.Sub_Stopover__c != Null){
                            strSet.add(objAddOn.Sub_Stopover__r.Name);
                            
                            //get the count of Addon - Start
                           if(!addOnCountMap.containsKey(objAddOn.Sub_Stopover__r.Name)){
        						addOnCountMap.put(objAddOn.Sub_Stopover__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.Sub_Stopover__r.Name)+1;
        						addOnCountMap.put(objAddOn.Sub_Stopover__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.Sub_Stopover__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End
                            
                        }
                       }else{
                        if(objAddOn.AE_SB__c != Null){
                           strSet.add(objAddOn.AE_SB__r.Name);
                            
                            //get the count of Addon - Start
                            if(!addOnCountMap.containsKey(objAddOn.AE_SB__r.Name)){
        						addOnCountMap.put(objAddOn.AE_SB__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.AE_SB__r.Name)+1;
        						addOnCountMap.put(objAddOn.AE_SB__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.AE_SB__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End

                        }   
                        if(objAddOn.Airline_Upgrade__c != Null){
                            strSet.add(objAddOn.Airline_Upgrade__r.Name);
                           
                            //get the count of Addon - Start
                            if(!addOnCountMap.containsKey(objAddOn.Airline_Upgrade__r.Name)){
        						addOnCountMap.put(objAddOn.Airline_Upgrade__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.Airline_Upgrade__r.Name)+1;
        						addOnCountMap.put(objAddOn.Airline_Upgrade__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.Airline_Upgrade__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End

                        }
                        if(objAddOn.land_activity__c != Null){
                            strSet.add(objAddOn.land_activity__r.Name);
                            
                           //get the count of Addon - Start
                            if(!addOnCountMap.containsKey(objAddOn.land_activity__r.Name)){
        						addOnCountMap.put(objAddOn.land_activity__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.land_activity__r.Name)+1;
        						addOnCountMap.put(objAddOn.land_activity__r.Name,countAddOn);
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.land_activity__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End

                        }
                        if(objAddOn.Sub_Stopover__c != Null){
                            strSet.add(objAddOn.Sub_Stopover__r.Name);
                            
                            //get the count of Addon - Start
                           	if(!addOnCountMap.containsKey(objAddOn.Sub_Stopover__r.Name)){
        						addOnCountMap.put(objAddOn.Sub_Stopover__r.Name,1);
    							}else{
        						integer countAddOn = addOnCountMap.get(objAddOn.Sub_Stopover__r.Name)+1;
        						addOnCountMap.put(objAddOn.Sub_Stopover__r.Name,countAddOn);
                                
                        	}//get the count of Addon - End
                            
                            //get add on type - start
                            addOnTypeMap.put(objAddOn.Sub_Stopover__r.Name,objAddOn.Record_Type_Name__c);
                            //get add on type - End
                        }
                   }
                 system.debug('strSet '+strSet);
                 addOnInfoMap.put(objAddOn.Order_Line_Item__r.ordexp_TAD_Order__c,strSet);      
                }
                system.debug('addOnCountMap '+addOnCountMap);
                system.debug('addOnInfoMap '+addOnInfoMap);
                system.debug('addOnTypeMap '+addOnTypeMap);
            }
            else{
                // if we delete addon - start
                for(string ordId:tadOrdIdsSet){
                    TAD_Order__c ord = new TAD_Order__c(Id = ordId);
                     ord.Add_On_information__c = '';
                     ord.Number_of_Add_Ons__c = Null;//PBP - 358
                    ordToUpdate.add(ord);
                }
              }
            }
        
        if(!addOnInfoMap.isEmpty()){
            for(string str:addOnInfoMap.keySet()){
                TAD_Order__c ord = new TAD_Order__c(Id = str);
                
                //update addon with count - start
                List<String> strList = New List<string>();
                for(string updateStr:addOnInfoMap.get(str)){
                    if(addOnTypeMap.get(updateStr) != null){
                        strList.add(addOnTypeMap.get(updateStr)+' - '+updateStr+' - '+addOnCountMap.get(updateStr));
                    }else{
                        strList.add(updateStr+'- '+addOnCountMap.get(updateStr));
                    }
                }
                //update addon with count - End
                
                if(!strList.isEmpty()){
                    ord.Add_On_information__c = String.join(strList, '\n');
                }else{
                    ord.Add_On_information__c = '';
                }
                
                if(addOnTotalCountMap.get(str) != Null){
                    ord.Number_of_Add_Ons__c = integer.valueOf(addOnTotalCountMap.get(str));
                }else{
                    ord.Add_On_information__c = '';
                }
                
                system.debug('ord 178'+Ord);
                   ordToUpdate.add(ord);
            }
        }
        
        
        try{
            if(!ordToUpdate.isEmpty()){
                system.debug('ordToUpdate '+ordToUpdate);
                update ordToUpdate;
            }
        }
        catch (exception e) {
            system.debug('exception '+e.getMessage());
        }
    }
}