public class Tad_BatchToCreateAddonGP implements  Database.Batchable<sObject> {
    
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            select Id, Name, ordexp_amount__c, RecordTypeId, land_activity__c, AE_SB__c, Airline_Upgrade__c, Sub_Stopover__c, Pricing_Model__c,general_pricing__c from Addon__c where general_pricing__c = null and addon_status__c !='Cancelled'
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Addon__c> addonRecords){
        List<General_Pricing__c> gpRecordsToCreate = new List<General_Pricing__c>();
        String landActivityRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
        String aesbRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        String stopoverRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Sub_Stopover').getRecordTypeId();
        String airlineUpgradeRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId();
        Map<String,String> landactivityGpMap = new Map<String,String>();
        Map<String,String> airlineGpMap = new Map<String,String>();
        Map<String,String> stopoverGpMap = new Map<String,String>();
        Map<String,String> aesbGpMap = new Map<String,String>();
        Map<String,general_pricing__c> addonGpMap = new Map<String,general_pricing__c>();
        Set<Id> laIds = new Set<Id>();
        Set<Id> aesbIds = new Set<Id>();
        Set<Id> substopIds = new Set<Id>();
        Set<Id> auIds = new Set<Id>();
        for(Addon__c addon :addonRecords){
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId()){
                laIds.add(addon.land_activity__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId()){
                aesbIds.add(addon.AE_SB__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId()){
                auIds.add(addon.Airline_Upgrade__c);
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId()){
                substopIds.add(addon.Sub_Stopover__c);
            }
        }
        List<General_Pricing__c> lagpRecords = [select id,name,LA_Solo_Price__c,LA_Twin_Price__c, land_activity__c from General_Pricing__c where Active__c = true and land_activity__c IN:laIds];
        List<General_Pricing__c> aesbgpRecords = [select id,name,AE_SB_Price__c, AE_SB__c from General_Pricing__c where Active__c = true and AE_SB__c IN:aesbIds];
        List<General_Pricing__c> augpRecords = [select id,name,Price_Airline_upgrade__c,Price_Airline_upgrade_NZD__c, Airline_Upgrade__c from General_Pricing__c where Active__c = true and Airline_Upgrade__c IN:auIds];
        List<General_Pricing__c> stopgpRecords = [select id,name,Stopover_Solo_Price__c,Stopover_Twin_Price__c, Sub_Stopover__c from General_Pricing__c where Active__c = true and Sub_Stopover__c IN:substopIds];
        
        for(Addon__c addon :addonRecords){
            Boolean isGpExist = false;
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId()){
                for(General_Pricing__c gp:lagpRecords){
                    if(addon.land_activity__c == gp.land_activity__c){
                        if(addon.Pricing_Model__c == 'Solo' && addon.ordexp_amount__c == gp.LA_Solo_Price__c || addon.Pricing_Model__c == 'Twin' && addon.ordexp_amount__c == gp.LA_Twin_Price__c){
                            isGpExist = true;
                            addonGpMap.put(addon.Id,gp);
                        }
                    }
                }
                if(!isGpExist){ 
                    general_pricing__c gp = new general_pricing__c();
                    gp.RecordTypeId = landActivityRCT;
                    if(addon.Pricing_Model__c=='Solo'){
                        gp.LA_Solo_Price__c = addon.ordexp_amount__c;
                    }else{
                        gp.LA_Twin_Price__c = addon.ordexp_amount__c;
                    }
                    gp.Active__c = false;
                    gp.Land_Activity__c = addon.land_activity__c;
                    gpRecordsToCreate.add(gp);
                    addonGpMap.put(addon.Id,gp);
                    landactivityGpMap.put(addon.land_activity__c, gp.Id);
                }
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId()){
                for(General_Pricing__c gp:aesbgpRecords){
                    if(addon.AE_SB__c == gp.AE_SB__c){
                        if(addon.ordexp_amount__c == gp.AE_SB_Price__c){
                            isGpExist = true;
                            addonGpMap.put(addon.Id,gp);
                        }
                    }
                }
                if(!isGpExist){
                    general_pricing__c gp = new general_pricing__c();
                    gp.RecordTypeId = aesbRCT;
                    gp.AE_SB_Price__c = addon.ordexp_amount__c;
                    gp.Active__c = false;
                    gp.AE_SB__c = addon.AE_SB__c;
                    gpRecordsToCreate.add(gp);
                    addonGpMap.put(addon.Id,gp);
                    aesbGpMap.put(addon.AE_SB__c, gp.Id);  
                }
                
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId()){
                for(General_Pricing__c gp:augpRecords){
                    if(addon.Airline_Upgrade__c == gp.Airline_Upgrade__c){
                        if(addon.ordexp_amount__c == gp.Price_Airline_upgrade__c || addon.ordexp_amount__c == gp.Price_Airline_upgrade_NZD__c){
                            isGpExist = true;
                            addonGpMap.put(addon.Id,gp);
                        }
                    }
                }
                if(!isGpExist){
                    general_pricing__c gp = new general_pricing__c();
                    gp.RecordTypeId = airlineUpgradeRCT;
                    gp.Price_Airline_upgrade__c = addon.ordexp_amount__c;
                    gp.Active__c = false;
                    gp.Airline_Upgrade__c = addon.Airline_Upgrade__c;
                    gpRecordsToCreate.add(gp);
                    addonGpMap.put(addon.Id,gp);
                    airlineGpMap.put(addon.Airline_Upgrade__c,gp.Id);
                }
            }
            if(addon.RecordTypeId == Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId()){
                for(General_Pricing__c gp:stopgpRecords){
                    if(addon.Sub_Stopover__c == gp.Sub_Stopover__c){
                        if(addon.Pricing_Model__c == 'Solo' && addon.ordexp_amount__c == gp.Stopover_Solo_Price__c || addon.Pricing_Model__c == 'Twin' && addon.ordexp_amount__c == gp.Stopover_Twin_Price__c){
                            isGpExist = true;
                            addonGpMap.put(addon.Id,gp);
                        }
                    }
                }
                if(!isGpExist){
                    general_pricing__c gp = new general_pricing__c();
                    gp.RecordTypeId = stopoverRCT;
                    if(addon.Pricing_Model__c=='Solo'){
                        gp.Stopover_Solo_Price__c = addon.ordexp_amount__c;
                    }else{
                        gp.Stopover_Solo_Price__c = addon.ordexp_amount__c;
                    }
                    gp.Active__c = false;
                    gp.Sub_Stopover__c = addon.Sub_Stopover__c;
                    gpRecordsToCreate.add(gp);
                    addonGpMap.put(addon.Id,gp);
                    stopoverGpMap.put(addon.Sub_Stopover__c,gp.Id);
                }
            }
        } 
        try{
            if(!gpRecordsToCreate.isEmpty()){
                //  insert gpRecordsToCreate;
            }
            for(Addon__c add:addonRecords){
                add.general_pricing__c = addonGpMap.get(add.Id).Id;
            }
            update addonRecords;
        }catch(Exception e){
            system.debug('Error occured while creating GP records :'+ e.getMessage());
        }
        /* if(!stopoverGpMap.keys().isEmpty()){
List<sub_stopover__c> stList  = [select Sub_Stopover__c from ];
}
if(!airlineGpMap.keys().isEmpty()){
List<airline_upgrade__c> stList  = [];
}
if(!aesbGpMap.keys().isEmpty()){
List<AE_SB__c> stList  = [];
}
if(!landactivityGpMap.keys().isEmpty()){
List<land_activity__c> stList  = [];
}*/
        
    }   
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}