trigger cruiseUpgradeTrigger on Cruise_Upgrade__c (after insert,After Update) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            
          /** LOGIC 1 - This Method would 1) Find Component based on OLI Sub-Option and relevant pricing to create OL record *** 
			* *********************/ 
        	cruiseUpgradeHandler.findAndCreateOlRecord(trigger.new);
            cruiseUpgradeHandler.createOrderCommsRecord(trigger.new);//PSAG - 81
          //  cruiseUpgradeHandler.automateFinancialFields(trigger.new);//PSAG - 82
            
         }
        }
        if(Trigger.isUpdate){
            //PSAG - 82 Start
            List<Cruise_Upgrade__c> cruiseUpgrades = New List<Cruise_Upgrade__c>();
            List<Cruise_Upgrade__c> cruiseUpgradesForOrdComms = New List<Cruise_Upgrade__c>();
            
            for(Cruise_Upgrade__c objCruiseUpgrade : Trigger.New){
                if(objCruiseUpgrade.Nett__c != Null && objCruiseUpgrade.Nett__c != Trigger.oldMap.get(objCruiseUpgrade.Id).Nett__c){
                    cruiseUpgrades.add(objCruiseUpgrade);
                }
                //PSAG - 81 Start
                if(objCruiseUpgrade.status__c == 'Secured' && objCruiseUpgrade.status__c != Trigger.oldMap.get(objCruiseUpgrade.Id).status__c){
                    cruiseUpgradesForOrdComms.add(objCruiseUpgrade);
                }//PSAG - 81 Stop
            }
            
            if(!cruiseUpgrades.isEmpty()){
             //   cruiseUpgradeHandler.automateFinancialFields(cruiseUpgrades);
            }
            //PSAG - 82 Stop
            //PSAG - 81 Start
            if(!cruiseUpgradesForOrdComms.isEmpty()){
                cruiseUpgradeHandler.createOrderCommsRecord(cruiseUpgradesForOrdComms);
            }//PSAG - 81 Stop
        }
}