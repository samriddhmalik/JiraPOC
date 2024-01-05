@isTest
public class BatchToUpdate_AccountFromLead_Test {

    static testMethod void basicTestwithAccount() {

        // Create dummy lead
        Lead testLead = new Lead(Company='Test Lead',FirstName='John',LastName='Doe');
        insert testLead;
        
        Account testAccount = new Account(name='Test Account');
        insert testAccount;
    
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
       
        Lead aLead = [select name, id, isConverted, convertedAccountID from Lead where id = :testLead.ID];
        System.Assert(aLead.isConverted);
        System.debug('ACCOUNT AFTER' + aLead.convertedAccountID);
        System.debug('ACCOUNT BEFORE' + testAccount.ID);
        //System.AssertEquals(testAccount.ID, aLead.convertedAccountID);
        
        BatchToUpdate_AccountFromLead listOfAcc = new BatchToUpdate_AccountFromLead();
        ID batchprocessid = Database.executeBatch(listOfAcc);
}
}