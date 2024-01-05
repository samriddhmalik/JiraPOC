public with sharing class createInsuranceRecord {
    
    @AuraEnabled
    public static List<String> fetchInsuranceType(){
        
        List<String> insuranceOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Visa_Insurance_POE__c.Insurance_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            insuranceOptions.add(p.getLabel());
        }
        Return insuranceOptions;
    }
    
    @AuraEnabled
    public static List<String> fetchCoverType(){
        
        List<String> coverOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Visa_Insurance_POE__c.Cover_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            coverOptions.add(p.getLabel());
        }
        Return coverOptions;
    }
    
    @AuraEnabled 
    public static List<paxInfo> fetchNickNames(String SelectedPaxIds){
        system.debug('SelectedPaxIds'+SelectedPaxIds);
        List<String> PaxId = SelectedPaxIds.split(',');
        system.debug('PaxId List Size'+PaxId.size());
        
        List<paxInfo> paxListToBeReturned = new List<paxInfo>();
        Set<String> PaxIdSet = new Set<String>();
        
        for(String str : PaxId){
            system.debug('str str'+str);
            PaxIdSet.add(str.trim());
        }
        
        system.debug('PaxIdSet PaxIdSet'+PaxIdSet);
        
        
        List<customer_POE__c> customerList = [Select Id, ordexp_PAX_Nickname__c from customer_POE__c where Id IN:PaxIdSet];
        system.debug('customerList'+customerList); 
        
        for(customer_POE__c cus : customerList){
            
            system.debug('cus----'+cus);
            paxInfo paxWrapper = new paxInfo();
            paxWrapper.paxId = cus.Id;
            paxWrapper.paxNickName = cus.ordexp_PAX_Nickname__c;
            paxListToBeReturned.add(paxWrapper);
            
        } 
        
        system.debug('paxListToBeReturned paxListToBeReturned paxListToBeReturned'+paxListToBeReturned);
        return paxListToBeReturned;
        
    }
    
    @AuraEnabled
    public static Id saveInsuranceRecord(List<paxInfo> paxInfoList, String coverType, String insuranceType, Decimal cost , String oliId){
        system.debug('inside saveInsuranceRecord---');
        system.debug('oliId--'+oliId);
        List<Visa_Insurance_POE__c> insListToInsert = new List<Visa_Insurance_POE__c>();
       order_line_item__c fecthOli = [Select id , ordexp_TAD_Order__c from order_line_item__c where id =: oliId ];
        Id tadOrderId = fecthOli.ordexp_TAD_Order__c;
       Id insRecordTypeId = Schema.SObjectType.Visa_Insurance_POE__c.getRecordTypeInfosByName().get('Insurance').getRecordTypeId();
        
        for(paxInfo pax : paxInfoList){
            
            if(insuranceType == TAD_Constants.tadInsurance){
                
            Visa_Insurance_POE__c insTad = new Visa_Insurance_POE__c();
             insTad.Policy_Number__c = pax.paxPolicyNumber; 
             insTad.Cover_Type__c = coverType;
            insTad.Insurance_Type__c = insuranceType;
           insTad.Insurance_Sale_Price__c = cost;     
           insTad.Order_Line_Item__c = oliId;
            insTad.RecordTypeId = insRecordTypeId;
              insTad.Passenger__c =  pax.paxId;
             insListToInsert.add(insTad);
                system.debug('inside insurance TAD---'+insListToInsert);
                
            }
            if(insuranceType == TAD_Constants.nzInsurance){
                
             Visa_Insurance_POE__c insNz = new Visa_Insurance_POE__c();
                insNz.Policy_Number__c = pax.paxPolicyNumber; 
            insNz.Cover_Type__c = coverType;
            insNz.Insurance_Type__c = insuranceType;  
           insNz.Insurance_Total_External__c = cost;
           insNz.Order_Line_Item__c = oliId; 
           insNz.RecordTypeId = insRecordTypeId; 
           insNz.Passenger__c =  pax.paxId;
            insListToInsert.add(insNz);
                system.debug('inside insurance NZ---'+insListToInsert);
            }
            
        }
        system.debug('insListToInsertinsListToInsert'+insListToInsert);
        insert insListToInsert;
        Return tadOrderId;
    }
    
    public class paxInfo {
        @AuraEnabled public String paxId {get;set;} 
        @AuraEnabled public String paxNickName {get;set;}
        @AuraEnabled public String paxPolicyNumber {get;set;} 
    }
}