public class discardJournalController {
    
    public string[] selectedJournalIDs{get;set;}
    
    public discardJournalController(ApexPages.StandardSetController listcontroller){
        selectedJournalIDs = new string[]{};
            for(c2g__codaJournal__c journal : (c2g__codaJournal__c[])listcontroller.getSelected()){
                selectedJournalIDs.add(journal.Id);
            }
    }
    
    
    @AuraEnabled
    public static String discardJournalApex (String journalIds , String discardMessage){ 
        String message = 'pass';
        System.debug('journalIds'+journalIds);
        
        String finalString =  journalIds.replace('[','').replace(']','');
        System.debug('finalString'+finalString);
        List<string> idsData = finalString.split(', ');
        
        System.debug('idsData'+idsData);
        
        List<c2g__codaJournal__c>  journalList = [Select id,c2g__OwnerCompany__c, c2g__JournalStatus__c   from c2g__codaJournal__c  where id IN:idsData ];
        System.debug('journalList'+journalList);
        // check if any journal In progress
        Set<String> companies = new set<String>();
        for(c2g__codaJournal__c jor :  journalList){
            if(jor.c2g__JournalStatus__c !='In Progress'){
                message='NotInProgress';
                break;
            }
            companies.add(jor.c2g__OwnerCompany__c);
        }
        
        // check if user have access to company
        
        String loggedInUser = UserInfo.getUserId();
        if(message =='pass'){
            Set<string> accessCom = new Set<string>();
            List<c2g__codaUserCompany__c> usercompanies = [Select id,c2g__Company__c  from c2g__codaUserCompany__c where c2g__User__c=:loggedInUser ];
            for(c2g__codaUserCompany__c us :usercompanies){
              accessCom.add(us.c2g__Company__c);  
            }
            
            for(String rec : companies){
                if(!accessCom.contains(rec)){
                    message='NoAccess';
                    break;
                }   
            }
        }
        
        if(message=='pass'){
            
            Database.executeBatch(new batchToDiscardJournal(journalList,discardMessage), 100);  
        }
        System.debug('message'+message);
        return message;
        
    }
    
}