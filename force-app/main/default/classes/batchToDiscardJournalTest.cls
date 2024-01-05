@isTest(SeeAllData=true)
public class batchToDiscardJournalTest {
    
    @isTest
    static void method2(){
        
        List<c2g__codaJournal__c> journalList= [Select id from c2g__codaJournal__c  where c2g__JournalStatus__c ='In Progress' and createddate <: Date.newInstance(2022, 08, 01) limit 1];
        
        discardJournalController.discardJournalApex(journalList[0].id,'discardRecord');
        
        
        c2g__codaJournal__c jour = journalList[0];       
        
        test.startTest();
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(journalList);
        stdSetController.setSelected(journalList);
        discardJournalController ext = new discardJournalController(stdSetController);
        test.stopTest();
        
    }
}