/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADUtils class-
* Purpose: A generic Utility Class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samra M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-08-07
* @modified       2019-10-11
* @systemLayer    
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
//@isTest
public class TADUtils {
    
    
    public static Id getRecordTypeList(String recTypeDevName, String objAPIName){
        
        Id recTypeId= Schema.getGlobalDescribe().get(objAPIName).getDescribe().getRecordTypeInfosByDeveloperName().get(recTypeDevName).getRecordTypeId();
        
        return recTypeId;
    }
    
    /** This Method would get the Record Type***
*  @param : String RCTName -> Record type name is passed for which record type is needed 
*  @returnType : RecordType  
* *********************/    
    public static List<RecordType> getRecordType(String RCTName){
        
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name =: RCTName];
        
        return rtList;
    }
    
    /** This Method would get a list of Record Types***
*  @param : Set<String> RCTNames -> Record type names is passed for the record types which are needed 
*  @returnType : Map<Id, RecordType>  
* *********************/    
    public static Map<Id, RecordType> getObjectRecordTypes (String objectName){
        Map<Id, RecordType> rtMap = new  Map<Id, RecordType>();
        System.debug('objectName'+objectName);
        List<RecordType> rtList = [SELECT Id, Name, SObjectType, IsActive FROM RecordType WHERE SObjectType=:objectName];
        System.debug('rtList'+rtList);
        for(RecordType rt : rtList){
            rtMap.put(rt.Id,rt);
        }
        return rtMap;
    }
    /** This Method would get a list of Record Types***
*  @param : Set<String> RCTNames -> Record type names is passed for the record types which are needed 
*  @returnType : Map<Id, RecordType>  
* *********************/    
    public static Map<String,Id> getObjectNameRecordTypeId (String objectName){
        
        Map<String,Id> tadOrderRtNameAndId = new  Map<String,Id>();
        List<RecordType> rtList = [SELECT Id, Name, SObjectType, IsActive FROM RecordType WHERE SObjectType=:objectName];
        for(RecordType rt : rtList){
            tadOrderRtNameAndId.put(rt.Name,rt.Id);
        }
        return tadOrderRtNameAndId;
    }
    
    
    /** This Method would get the user Profile***
*  @param : String profileName -> Profile Name is passed for which profile is needed
*  @returnType : Profile  
* *********************/   
    public static List<Profile> getUserProfile(String profileName){
        
        List<Profile> profileList = [Select Id from Profile where Name =: profileName];
        
        return profileList;
    }
    
    /** This Method would get all the merchants respective to each deal***
*  @param : Set<Id> dealIds -> Receives the deal ids as input
*  @returnType : Map  
* *********************/ 
    
    public static Map<Id,Set<String>> emailAddressMerchants (Set<Id> dealIds){
        
        Map<Id,Set<String>> dealToAddress = new Map<Id,Set<String>>();
        Set <Id> accIds = new Set <Id>();  
        
        List<Component__c> components = [Select Id, Merchant_Name__c,Merchant_Name__r.Company_Email__c,LinkedDeal_D_O_S__c from Component__c where LinkedDeal_D_O_S__c =:dealIds];
        for(Component__c comp : components){
            if(!dealToAddress.containsKey(comp.LinkedDeal_D_O_S__c)){
                dealToAddress.put(comp.LinkedDeal_D_O_S__c, new Set<String>{comp.Merchant_Name__r.Company_Email__c});     
            }else{
                Set<String> addList = dealToAddress.get(comp.LinkedDeal_D_O_S__c);
                addList.add(comp.Merchant_Name__r.Company_Email__c);
                dealToAddress.put(comp.LinkedDeal_D_O_S__c, addList);
            } 
        } 
        
        return  dealToAddress;  
    }
    
}