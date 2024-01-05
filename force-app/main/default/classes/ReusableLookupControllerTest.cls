@isTest
public class ReusableLookupControllerTest {
    
    @isTest
    static void methodTest(){
        Publishing_Inclusions__c publishObj = new Publishing_Inclusions__c();
        publishObj.Name = 'babycarriage';       
        insert publishObj;
        
        ReusableLookupController.SearchWrapper seachWrapper = new ReusableLookupController.SearchWrapper();
        seachWrapper.objectApiName = 'Publishing_Inclusions__c';
        seachWrapper.fieldApiName = 'Full_Name_Formula__c';        
        seachWrapper.otherFieldApiName = '';
        seachWrapper.searchString = 'babycarriage';
        seachWrapper.selectedRecordId = '';
        seachWrapper.parentRecordId = '';
        seachWrapper.parentFieldApiName = '';
        
        ReusableLookupController.fetchRecords(seachWrapper);
        ReusableLookupController.getIconName('Publishing_Inclusions__c');
    }
    
}