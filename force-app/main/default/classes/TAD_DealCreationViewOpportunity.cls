public class TAD_DealCreationViewOpportunity {
    
    public static Map<Id, String> recordtypemap;
    
    
    
    
    @AuraEnabled 
    public static Map<Id, String> checkForOpportunityStage(Id RecordId){    
        
        if(RecordId != null){
            system.debug('RecordId '+RecordId);
            Opportunity oppRecord = [Select Id, Stagename from Opportunity where Id =: RecordId];
            system.debug('oppRecord '+oppRecord);
            if(oppRecord.StageName != null && (oppRecord.StageName == 'Product Pipeline')){
                List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get('Deal__c').getDescribe().getRecordTypeInfos();
                recordtypemap = new Map<Id, String>();
                
                for(RecordTypeInfo rt : recordtypes){
                    
                    if(rt.getName().trim() != '' && rt.active==true  )
                        
                        recordtypemap.put(rt.getRecordTypeId(), rt.getName());
                    
                }        
                
            }
        }
        if(!recordtypemap.isEmpty())
            return recordtypemap;
        else
            return null;
    }
    
    @AuraEnabled
    public static List<String> getMultiPiklistValues(){
        List<String> multipickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Deal__c.deal_type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            multipickListValuesList.add(pickListVal.getLabel());
        }     
        return multipickListValuesList;
    }
    
    @AuraEnabled
    public static List<String> getPiklistValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Deal__c.Dates_Flights__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public Static List<String> checkDeal(Id RecordId){
        List<String> dealList = New List<String>();
                List<String> oppList = New List<String>();

        if(RecordId != null){
            system.debug('RecordId '+RecordId);
            for(Opportunity oppRecord : [Select Deal__c,Deal__r.Name,Title__c,Proposed_Go_Live_Date__c,Physical_Country__c,Physical_Region__c,Travel_From__c,Travel_To__c,Approx_Allocations__c from Opportunity where Id =: RecordId]){
                if(oppRecord.Deal__c !=null){
                dealList.add(oppRecord.Deal__c);
                    dealList.add(oppRecord.Deal__r.Name);
                }
                else if(oppRecord.Title__c == null || oppRecord.Proposed_Go_Live_Date__c == null || oppRecord.Physical_Country__c == null || oppRecord.Physical_Region__c == null || oppRecord.Travel_From__c == null || oppRecord.Travel_To__c == null || oppRecord.Approx_Allocations__c == null){
                oppList.add('any');
                                
                }
                system.debug('oppRecord---60--> '+oppRecord);
                system.debug('dealList---62--> '+dealList);
                
                
            }
        }
        if(!dealList.isEmpty())
            return dealList;
        else
            return oppList;
    }
    
    
    @AuraEnabled
    public static void dealCreationFromOpportunity(Id RecordId,String SelectDealType, String dealId, String SelectedDateFlight){
        System.debug('Line--91-->'+RecordId);
        System.debug('Line--92-->'+SelectDealType);
        System.debug('Line--93-->'+dealId);
        System.debug('Line--94-->'+SelectedDateFlight);
        String[] strList = SelectDealType.split(',');
        System.debug('SelectDealType-92->'+strList);
        
        String str = String.join( strList, ';' );
         System.debug('SelectDealType-95->'+str);
        
        
        For(Opportunity opp : [Select Id,AccountId,StageName,Title__c,Price__c,Proposed_Go_Live_Date__c,Physical_Region__c,Physical_Country__c,
                               Approx_Allocations__c,Travel_From__c,Travel_To__c from Opportunity where StageName = 'Product Pipeline' and Id =: RecordId]){
                                   
                                   
                                   
                                   Deal__c d = new Deal__c();
                                   d.title__c = opp.Title__c;
                                   d.price__c = Integer.valueOf(opp.Price__c);
                                   d.start_date__c = opp.Proposed_Go_Live_Date__c;
                                   d.Region__c = opp.Physical_Region__c;
                                   d.Country__c = opp.Physical_Country__c;
                                   d.Valid_From__c = opp.Travel_From__c;
                                   d.Valid_To__c = opp.Travel_To__c;
                                   d.deal_type__c = str;
                                   d.Name = dealId;
                                   d.Dates_Flights__c = SelectedDateFlight;
                                   d.Flight_Book_By__c = 0;
                                   insert d;
                                   
                                   opp.Deal__c = d.Id;
                                   update opp;
                               }
        
    }



}