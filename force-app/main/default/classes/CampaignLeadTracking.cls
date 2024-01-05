@RestResource(urlMapping='/campaignLeads')
global class CampaignLeadTracking {    
    
    
    global class leadData{
        global String firstName{get;set;}
        global String lastName{get;set;}
        global String postCode{get;set;}
        global string phoneNumber{get;set;}
        global string email{get;set;}
        global String campaignId{get;set;}
        global date dob{get;set;}
        global String customerEntery{get;set;}
        
    }
    
    global class returnData{
        global Boolean isSuccess{get;set;}
        global String ErrorMessage{get;set;}
    }
    
    @HttpPost
    global static returnData createAvailabilityRecord(){
        
        
        returnData dataCheck = new returnData();
        
        
        RestRequest req = RestContext.request;
        String requestBodyString = req.requestBody.tostring(); 
        System.debug('requestBodyString'+requestBodyString);
        leadData mainWrap = (leadData)JSON.deserialize(requestBodyString, leadData.class);
        
        
        string emailValue = mainWrap.email;
        
        Boolean recordExist = false;
        
        // Search if Account exist
        List<account> accountRecord = [Select id, DOB__c,ShippingPostalCode  from account where PersonEmail =:emailValue limit 1];
        if(!accountRecord.isEmpty()){
            System.debug('Existing Account');
            recordExist = true;
            
            contact contactRec = [Select id from contact where accountId =: accountRecord[0].id limit 1];
            
            // create campaign member
            CampaignMember cmp = new CampaignMember ();
            cmp.CampaignId =mainWrap.campaignId;
            cmp.Campaign_Member_Type__c = 'Account';
            cmp.Status ='Sent';
            cmp.ContactId = contactRec.id;
            cmp.Customer_entry__c  = mainWrap.customerEntery;
            try {
                insert cmp;
                dataCheck.isSuccess= true;
            } catch(DmlException e) {
                if(e.getMessage().contains('Already a campaign member')){
                    dataCheck.ErrorMessage= 'Already a campaign member';
                }
            }
            
            
            // Update Account data
            
            
            if( (accountRecord[0].DOB__c == null && mainWrap.dob!=null ) || (accountRecord[0].ShippingPostalCode==null && mainWrap.postCode!=null ) ){
                account acc = new account();
                acc.DOB__c = mainWrap.dob;
                acc.ShippingPostalCode = mainWrap.postCode ;
                acc.id = accountRecord[0].id;
                try {
                    update acc;
                } catch(DmlException e) {
                    dataCheck.ErrorMessage = 'Account Update failed';
                }
                
                
            }
            
            
        }
        
        // Search of lead exist
        if(recordExist == false){
            System.debug('Existing Lead');
            List<lead> leadRecord = [Select id from lead where email=:emailValue limit 1];
            
            if(!leadRecord.isEmpty()){
                recordExist = true;
                
                // create campaign member
                CampaignMember cmp = new CampaignMember ();
                cmp.CampaignId =mainWrap.campaignId;
                cmp.Campaign_Member_Type__c = 'Existing Lead';
                cmp.Status ='Sent';
                cmp.LeadId  = leadRecord[0].id;
                cmp.Customer_entry__c  = mainWrap.customerEntery;
                try {
                    insert cmp;
                    dataCheck.isSuccess= true;
                } catch(DmlException e) {
                    if(e.getMessage().contains('Already a campaign member')){
                        dataCheck.ErrorMessage= 'Already a campaign member';
                    }
                }
                
            }
            
        }
        
        // Create new Lead record
        
        if(recordExist == false){
            System.debug('New Lead');
            lead leadR = new lead();
            leadR.firstName = mainWrap.firstName;
            leadR.lastName = mainWrap.lastName;
            leadR.PostalCode  = mainWrap.postCode;
            leadR.Phone  = mainWrap.phoneNumber;
            leadR.Email  = mainWrap.email;
            leadR.CampaignID__c  = mainWrap.campaignId;
            leadR.DOB__c = mainWrap.dob;
            leadR.Customer_entry__c  = mainWrap.customerEntery;
            Id recordTypeIds  = TADUtils.getRecordTypeList('TAD_Person_Account','Lead');
            leadR.recordTypeId = recordTypeIds;
            
            try {
                insert leadR;
                dataCheck.isSuccess= true;
            } catch(DmlException e) {
                dataCheck.ErrorMessage= e.getMessage();
            }
        }
        
        return dataCheck;
    }
    
}