/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Utility_SingleEmailMessageHandler
* Purpose: Apex Class Used as Utility Class for Single Email Messages.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Hansa Sabbarwal  <hansa@psagtechnologies.com>
* @lastModifiedBy Hansa Sabbarwal  <hansa@psagtechnologies.com>

* @version        1.0
* 
* @modified       2020-01-23
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class Utility_SingleEmailMessageHandler {
    public List<string> toAddresses {get;set;}
    public List<string> ccaddresses {get;set;}
    public map<string,string> param2Emailtemplate {get;set;}
    public  Boolean isSaveAsActivity;  
    public  Boolean isUseSignature;
    
    
    public void Utility_SingleEmailMessageHandler(list<string> toAddresses, list<string> ccaddresses, map<string,string>param2Emailtemplate,Boolean isSaveAsActivity, Boolean isUseSignature ){
        
        this.toAddresses = toAddresses;
        this.ccaddresses = ccaddresses;
        this.param2Emailtemplate = param2Emailtemplate;
        this.isUseSignature = isUseSignature;
        this.isSaveAsActivity = isSaveAsActivity;
        
        
        
        
    } 
    
    //You could also use a no constructor class and just declare a method as below that 
    //you go directly to OR just do all the work in your constructor as above
    // except the DML which cannot be done in a constructor.
    public static void EmailHandlerMethodForBeforeTrigger(list<string> toAddresses, list<string> ccaddresses, map<string,string>param2Emailtemplate, Boolean isSaveAsActivity, Boolean isUseSignature){
        
        // code for processing the above data that also does the email DML or calls other methods
        // to do various parts of the work, but returns nothing (thus the reason for keyword void). 
        
		system.debug('here email handler');       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        mail.subject = param2Emailtemplate.containsKey('Subject') ? param2Emailtemplate.get('Subject') : '';
        mail.plainTextBody = param2Emailtemplate.containskey('plainTextBody') ? param2Emailtemplate.get('plainTextBody') : '';
        mail.htmlbody = param2Emailtemplate.containsKey('htmlBody')  ? param2Emailtemplate.get('htmlBody') : '' ;
        mail.ToAddresses = toAddresses;
       	mail.setSenderDisplayName(System.Label.Senders_Name); 
        mail.setReplyTo(System.Label.Set_ReplyTo );
        mail.setSaveAsActivity(isSaveAsActivity);
        mail.setUseSignature(isUseSignature);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        system.debug('allmsg   '+allmsg);
        try {
            Messaging.sendEmail(allmsg,false);
            system.debug('Sent ');
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }  
    }
    
    @Future
    public static void EmailHandlerMethod(list<string> toAddresses, list<string> ccaddresses, map<string,string>param2Emailtemplate, Boolean isSaveAsActivity, Boolean isUseSignature){
        
        // code for processing the above data that also does the email DML or calls other methods
        // to do various parts of the work, but returns nothing (thus the reason for keyword void). 
        
		system.debug('here email handler');       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        mail.subject = param2Emailtemplate.containsKey('Subject') ? param2Emailtemplate.get('Subject') : '';
        mail.plainTextBody = param2Emailtemplate.containskey('plainTextBody') ? param2Emailtemplate.get('plainTextBody') : '';
        mail.htmlbody = param2Emailtemplate.containsKey('htmlBody')  ? param2Emailtemplate.get('htmlBody') : '' ;
        mail.ToAddresses = toAddresses;
       	mail.setSenderDisplayName(System.Label.Senders_Name); 
        mail.setReplyTo(System.Label.Set_ReplyTo );
        mail.setSaveAsActivity(isSaveAsActivity);
        mail.setUseSignature(isUseSignature);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        system.debug('allmsg   '+allmsg);
        try {
            Messaging.sendEmail(allmsg,false);
            system.debug('Sent ');
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }  
    }
    
    public static void departDateFindTosetEmailAddress(List<departures_dates__c> depList, Boolean isSaveAsActivity, Boolean isUseSignature, Boolean isBccSender, String targetObjectId, String emailTemplateId, String whatId  ){
        Map<Id,List<departures_dates__c>> MapOfDealIdVsListOfdd = new  Map<Id,List<departures_dates__c>>();
        for(departures_dates__c dept : depList ){
            if(!MapOfDealIdVsListOfdd.containsKey(dept.Deal__c)){
                MapOfDealIdVsListOfdd.put(dept.Deal__c, new List<departures_dates__c>{dept});
            }else{
                List<departures_dates__c> deptList =  MapOfDealIdVsListOfdd.get(dept.Deal__c);
                deptList.add(dept);
                MapOfDealIdVsListOfdd.put(dept.Deal__c, deptList);
            }
        }
        if(MapOfDealIdVsListOfdd != null && !MapOfDealIdVsListOfdd.isEmpty()){
            Map<Id,List<String>> MapOfDealIdVsListOfMerchantMail = new  Map<Id,List<String>>();
            for(Component__c comp : [Select Id, Merchant_Name__c, Merchant_Name__r.Name, Merchant_Name__r.Company_Email__c, Deal__c  from Component__c where Deal__c =:MapOfDealIdVsListOfdd.keySet()]){
               
                if(!MapOfDealIdVsListOfMerchantMail.containskey(comp.Deal__c) ){
                    
                    MapOfDealIdVsListOfMerchantMail.put(comp.Deal__c,new List<String>{comp.Merchant_Name__r.Company_Email__c} );
                }else{
                    
                    List<String> emailList = MapOfDealIdVsListOfMerchantMail.get(comp.Deal__c);
                    
                    emailList.add(comp.Merchant_Name__r.Company_Email__c);
                    
                    
                    MapOfDealIdVsListOfMerchantMail.put(comp.Deal__c,emailList );
                }
                
                system.debug('MapOfDealIdVsListOfMerchantMail   '+json.serialize(MapOfDealIdVsListOfMerchantMail));
            }
            Map<Id, List<String>> deptIdVsEmailMap = new Map<Id, List<String>>();
            for(Id dealId : MapOfDealIdVsListOfdd.keySet()){
                for(departures_dates__c dd : MapOfDealIdVsListOfdd.get(dealId)){
                    if(!deptIdVsEmailMap.containsKey(dd.Id)){
                       deptIdVsEmailMap.put(dd.Id, MapOfDealIdVsListOfMerchantMail.get(dd.Id) );
                        
                    }
                   
                }
            }
            
            for(Id deptId : deptIdVsEmailMap.keySet()){
                EmailHandlerMethodForTargetObject(deptIdVsEmailMap.get(deptId), null, isSaveAsActivity, isUseSignature, isBccSender, targetObjectId, emailTemplateId, whatId, null);
            }
            
        }
    }
    
   
    /***********************Utility Method When Target Object Id and What Id is Given**********************
@createdBy Hansa Sabbarwal  <hansa@psagtechnologies.com>
*********************************************/
    @Future
    public static void EmailHandlerMethodForTargetObject(list<string> toAddresses, list<string> ccaddresses,  Boolean isSaveAsActivity, Boolean isUseSignature, Boolean isBccSender, String targetObjectId, String emailTemplateId, String whatId, map<string,string>param2Emailtemplate){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(targetObjectId); 
        mail.setSenderDisplayName(System.Label.Senders_Name); 
        mail.setReplyTo(System.Label.Set_ReplyTo );
        mail.setUseSignature(isUseSignature); 
        mail.setBccSender(isBccSender); 
        mail.setSaveAsActivity(isSaveAsActivity); 
        if(param2Emailtemplate != null && param2Emailtemplate.containsKey('htmlBody')){
            mail.htmlbody = param2Emailtemplate.containsKey('htmlBody')  ? param2Emailtemplate.get('htmlBody') : '' ;
            mail.subject = param2Emailtemplate.containsKey('Subject') ? param2Emailtemplate.get('Subject') : '';
           
        }
        mail.setTemplateID(emailTemplateId); 
        mail.setWhatId(whatId);
        mail.toAddresses = toAddresses;
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        system.debug('allmsg   '+allmsg);
        try {
            Messaging.sendEmail(allmsg,false);
            system.debug('Sent ');
            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }  
        
    }
    
    
    
}