public class AutoConvertLeadsHandler {

	@InvocableMethod(label = 'Auto Convert Leads')
    public static void LeadAssign(List<Id> LeadIds)  
    {         
        system.debug('LeadIds '+LeadIds);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1]; 
        Set<String> emaiIdSet = New Set<String>();
        Map<String,Lead> leadMap = New Map<String,Lead>();
        Map<String,Account> emailAccMap = New Map<String,Account>();
        List<Account> AccountListToUpdate = New List<Account>();
        
        List<Lead> getLeads = [SELECT Id,FirstName,LastName,Email,Phone FROM Lead WHERE Id IN : LeadIds];
        if(!getLeads.isEmpty()){
            for(Lead objLead : getLeads){
                emaiIdSet.add(objLead.Email);
                leadMap.put(objLead.Email,objLead);
            }
        }
        List<Account> getAccounts = [SELECT Id,PersonEmail,Phone FROM Account WHERE PersonEmail IN : emaiIdSet];
        system.debug('LeadIds '+getAccounts);
        if(!getAccounts.isEmpty()){
            for(Account objAccount : getAccounts){
                string uniqueKey;
                if(objAccount.Phone != Null){
                   uniqueKey = objAccount.PersonEmail;  
                }else{
                    uniqueKey = objAccount.PersonEmail; 
                }
                
                if(leadMap.get(objAccount.PersonEmail) != Null && objAccount.Phone != leadMap.get(objAccount.PersonEmail).Phone){
                    objAccount.Phone = leadMap.get(objAccount.PersonEmail).Phone;
                    AccountListToUpdate.add(objAccount);
                }
                
                emailAccMap.put(uniqueKey,objAccount);
            }
        }else{
            List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            for(Lead objLead : getLeads){
                
                Account acc = new Account();
                acc.RecordTypeId = RCTPersonAccount[0].Id;
                acc.FirstName = objLead.FirstName;
            	acc.Lastname = objLead.LastName;
                acc.PersonEmail = objLead.Email;
                acc.Phone = objLead.Phone;
                emailAccMap.put(objLead.Email,acc);
                AccountListToUpdate.add(acc); 
            }
           		
        }
        
        if(!AccountListToUpdate.isEmpty()){
                upsert emailAccMap.values();
            }
        
        system.debug('LeadIds '+emailAccMap);
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();    
        
        for(Lead currentlead: getLeads){                
            Database.LeadConvert Leadconvert = new Database.LeadConvert();    
            Leadconvert.setLeadId(currentlead.Id);                               
            Leadconvert.setConvertedStatus(convertStatus.MasterLabel);   
            string uniqueKey = currentlead.Email;
            system.debug('LeadIds '+uniqueKey);
            if(emailAccMap.get(uniqueKey) != Null){
             Leadconvert.setAccountId(emailAccMap.get(uniqueKey).Id);   
            }
            Leadconvert.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to create an opportunity from Lead Conversion  
            MassLeadconvert.add(Leadconvert);    
        }
        
        if (!MassLeadconvert.isEmpty())
        {            
            
            
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
            
        }    
    } 
    
}