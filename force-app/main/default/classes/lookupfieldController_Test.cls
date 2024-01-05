@isTest
public class lookupfieldController_Test {
    //This test class just ensures that there is enough code coverage
    //to get the component into production from your sandbox
    //it does not perform any validations.
    static testMethod void testLookupField() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        List<string> returnFields = new List<string> {'Name'};
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
		    lookupfieldController.getObjectDetails('Account');
        lookupfieldController.GetRecentRecords('Account', returnFields, 5);
        lookupfieldController.SearchRecords('Account', returnFields, returnFields, '', 'Name', 'ASC', 5, 'CreatedDate > 2001-01-01T00:00:01Z');
        lookupfieldController.GetRecord('Account', returnFields, acctBussiness.Id);
    }
}