@isTest
public class MP_RaiseAQuestion_TestClass {
    
        @testSetup 
    static void setup() {
        
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
      
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );
        insert con;
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Set<String> accList = new Set<String>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.NRMA_Membership_Number__c='0412345678';
    

        insert acctBussiness;
        accList.add(acctBussiness.Id);
        
            Tad_Order__c order = new Tad_Order__c();
            insert order;
            
            List<Id> tadOrderId = new  List<Id>();
            tadOrderId.add(order.Id);
            
        Case testCase = new Case();
        testCase.status = 'New';   
        testCase.AccountId = acmc.Id;
        testCase.ContactId=con.Id;
        insert testCase;
        testCase.status = 'Closed'; 
        Update testCase;
        
         Case testCase1 = new Case();
        testCase1.status = 'New';   
        testCase1.AccountId = acmc.Id;
        testCase1.ContactId=con.Id;
        insert testCase1;
        testCase1.status = 'Working'; 
        Update testCase1;
        
        

    }
    
    @isTest
    static void MP_RaiseAQuestionMethod(){
        
        Set<String> usrList = new Set<String>();
        List<String> dealList = New List<String>();
        Set<String> accList = new Set<String>();
        String caseId;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
        Contact con = [Select Id,Name from Contact limit 1];
        
        User newUser = new User( email='genelia.dsouza@gmail.com',
                                profileid = p.Id, 
                                UserName='genelia.dsouza@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                LastName = 'Dsouza');
        insert newUser;  
        
        usrList.add(newUser.Id);
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        accList.add(acctBussiness.Id);
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Tad_Order__c tadList = [Select Id From Tad_Order__c LIMIT 1];
        Case caselist = [Select Id from Case LIMIT 1];
        
        MP_RaiseAQuestion.TadWrapperClass tadWrap = new MP_RaiseAQuestion.TadWrapperClass();
        List<TAD_Order__c> testtadOrder = tadWrap.tadOrder;
        
        
        MP_RaiseAQuestion.CaseWrapperClass caseWrap = new MP_RaiseAQuestion.CaseWrapperClass();
        String testcasenumber= caseWrap.casenumber;
        String testdescription= caseWrap.description;
        String testsubject= caseWrap.subject;
        String testsubPlusCaseNo= caseWrap.subPlusCaseNo;
        String testcaseId= caseWrap.caseId;
        
        String fileinfo = '[{"fileName":"SalesReportData (17).csv","fileContent":"RGVhbCxPcmRlciBOdW1iZXIsQWNjb3VudCBOYW1lLFRvdXIgRGVwYXJ0dXJlIERhdGUsU3RhcnQgRGF0ZSxDb21wb25lbnQgTmFtZSxQYXggVHJhdmVsbGluZyxSb29tL0NhYmluIFJlcXVpcmVkLFJvb20vQ2FiaW4gQ29uZmlndXJhdGlvbgoiMzYwMCIsIk8tMDI1MDIiLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wMi0xNyIsIjIwMjItMDItMTciLCJMYW5kIFRvdXItMTcgRGF5IEFudGFyY3RpY2EgRXhwZWRpdGlvbiBDcnVpc2UiLCIyIiwiMiIsIlNvbG8iCiIzNjAwIiwiTy0wMjUwMiIsIlNhbXJpZGRoTWFsaWsiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjQiLCIyIiwiVHdpbiIKIjM2MDAiLCJPLTAyNTAyIiwiU2FtcmlkZGhNYWxpayIsIjIwMjItMDItMTciLCIyMDIyLTAyLTIwIiwiTGFuZCBBY3Rpdml0eS1UaWdyZSAmIERlbHRhIHdpdGggQm9hdCBSaWRlLTM2MDAiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NiIsIkR3YXluZSBCaXJ0bGVzIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjIiLCJTb2xvIgoiMzczMiIsIk8tMDMwODYiLCJEd2F5bmUgQmlydGxlcyIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAzMDg3IiwiQ2FybG9zIFNhbmNoZXoiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NyIsIkNhcmxvcyBTYW5jaGV6IiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjEiLCJUd2luIgoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwNjciLCJBZGFtIEJlbm5ldHQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA2NyIsIkFkYW0gQmVubmV0dCIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAyNzg3IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMjY1OSIsIlJlbnUiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxOTUwIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTk1MCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDciLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5NTAiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5MjgiLCJHZWV0YSIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTA2IiwiTGFuZCBUb3VyLTI1IERheSBBbnRhcmN0aWNhICYgU291dGggQW1lcmljYSIsIjIiLCIyIiwiU29sbyIKIjM3MzIiLCJPLTAxOTI4IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0xMCIsIkxhbmQgQWN0aXZpdHktRGF5IDM6IFJpbyBEZSBKYW5laXJvIEFuZ3JhIERvcyBSZWlzIElzbGFuZHMgQm9hdCBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTkyOCIsIkdlZXRhIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTMiLCJMYW5kIEFjdGl2aXR5LURheSA4OiBDb2xvbmlhIGRlbCBTYWNyYW1lbnRvLCBVcnVndWF5IERheSBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTc3OSIsIkFiaGluYXYgSm9zaGkiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxNjczIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTY3NCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDMiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMSIsIjEiLCJTb2xvIgoiMzczMiIsIk8tMDE2NzQiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzQ4NSIsIk8tMDA3MDciLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wNS0xNSIsIjIwMjItMDUtMTUiLCJMYW5kIFRvdXItMTIgRGF5IEFyZ2VudGluYSwgQ2hpbGUgJiBCcmF6aWwiLCIxIiwiMSIsIlNvbG8iCiIzNjAwIiwiTy0wMjU1NCIsIkFsY2hlbXkgRE1DICBBcmdlbnRpbmEiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjIiLCIyIiwiU29sbyIK"}]';
        System.runAs(newUser){    
            Test.startTest();
       try
      {
            MP_RaiseAQuestion.getTadOrderRecord();
            MP_RaiseAQuestion.updateCase(caselist.Id,'Test','Test');
             
            MP_RaiseAQuestion.uploadFiles(caselist.Id,fileinfo,'Test','Test');
      }
      catch(exception e)
         {
}     
        Test.stopTest();

         
            
        }
    }
        
     @isTest
    static void MP_RaiseAQuestionMethod1(){
        
        Set<String> usrList = new Set<String>();
        List<String> dealList = New List<String>();
        Set<String> accList = new Set<String>();
        String caseId;
        
    
        
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
        Contact con = [Select Id,Name from Contact limit 1];
        
        User newUser = new User( email='genelia.dsouza@gmail.com',
                                profileid = p.Id, 
                                UserName='genelia.dsouza@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                LastName = 'Dsouza');
        insert newUser;  
        
        usrList.add(newUser.Id);
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        accList.add(acctBussiness.Id);
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Tad_Order__c tadList = [Select Id From Tad_Order__c LIMIT 1];
        Case caselist = [Select Id from Case LIMIT 1];
        
        MP_RaiseAQuestion.TadWrapperClass tadWrap = new MP_RaiseAQuestion.TadWrapperClass();
        List<TAD_Order__c> testtadOrder = tadWrap.tadOrder;
        
        
        MP_RaiseAQuestion.CaseWrapperClass caseWrap = new MP_RaiseAQuestion.CaseWrapperClass();
        String testcasenumber= caseWrap.casenumber;
        String testdescription= caseWrap.description;
        String testsubject= caseWrap.subject;
        String testsubPlusCaseNo= caseWrap.subPlusCaseNo;
        String testcaseId= caseWrap.caseId;
        
        String fileinfo = '[{"fileName":"SalesReportData (17).csv","fileContent":"RGVhbCxPcmRlciBOdW1iZXIsQWNjb3VudCBOYW1lLFRvdXIgRGVwYXJ0dXJlIERhdGUsU3RhcnQgRGF0ZSxDb21wb25lbnQgTmFtZSxQYXggVHJhdmVsbGluZyxSb29tL0NhYmluIFJlcXVpcmVkLFJvb20vQ2FiaW4gQ29uZmlndXJhdGlvbgoiMzYwMCIsIk8tMDI1MDIiLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wMi0xNyIsIjIwMjItMDItMTciLCJMYW5kIFRvdXItMTcgRGF5IEFudGFyY3RpY2EgRXhwZWRpdGlvbiBDcnVpc2UiLCIyIiwiMiIsIlNvbG8iCiIzNjAwIiwiTy0wMjUwMiIsIlNhbXJpZGRoTWFsaWsiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjQiLCIyIiwiVHdpbiIKIjM2MDAiLCJPLTAyNTAyIiwiU2FtcmlkZGhNYWxpayIsIjIwMjItMDItMTciLCIyMDIyLTAyLTIwIiwiTGFuZCBBY3Rpdml0eS1UaWdyZSAmIERlbHRhIHdpdGggQm9hdCBSaWRlLTM2MDAiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NiIsIkR3YXluZSBCaXJ0bGVzIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjIiLCJTb2xvIgoiMzczMiIsIk8tMDMwODYiLCJEd2F5bmUgQmlydGxlcyIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAzMDg3IiwiQ2FybG9zIFNhbmNoZXoiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NyIsIkNhcmxvcyBTYW5jaGV6IiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjEiLCJUd2luIgoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwNjciLCJBZGFtIEJlbm5ldHQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA2NyIsIkFkYW0gQmVubmV0dCIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAyNzg3IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMjY1OSIsIlJlbnUiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxOTUwIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTk1MCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDciLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5NTAiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5MjgiLCJHZWV0YSIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTA2IiwiTGFuZCBUb3VyLTI1IERheSBBbnRhcmN0aWNhICYgU291dGggQW1lcmljYSIsIjIiLCIyIiwiU29sbyIKIjM3MzIiLCJPLTAxOTI4IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0xMCIsIkxhbmQgQWN0aXZpdHktRGF5IDM6IFJpbyBEZSBKYW5laXJvIEFuZ3JhIERvcyBSZWlzIElzbGFuZHMgQm9hdCBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTkyOCIsIkdlZXRhIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTMiLCJMYW5kIEFjdGl2aXR5LURheSA4OiBDb2xvbmlhIGRlbCBTYWNyYW1lbnRvLCBVcnVndWF5IERheSBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTc3OSIsIkFiaGluYXYgSm9zaGkiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxNjczIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTY3NCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDMiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMSIsIjEiLCJTb2xvIgoiMzczMiIsIk8tMDE2NzQiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzQ4NSIsIk8tMDA3MDciLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wNS0xNSIsIjIwMjItMDUtMTUiLCJMYW5kIFRvdXItMTIgRGF5IEFyZ2VudGluYSwgQ2hpbGUgJiBCcmF6aWwiLCIxIiwiMSIsIlNvbG8iCiIzNjAwIiwiTy0wMjU1NCIsIkFsY2hlbXkgRE1DICBBcmdlbnRpbmEiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjIiLCIyIiwiU29sbyIK"}]';
        System.runAs(newUser){    
            Test.startTest();
       try
      {
            MP_RaiseAQuestion.getTadOrderRecord();
            MP_RaiseAQuestion.updateCase(caselist.Id,'Test','Test');
             
            MP_RaiseAQuestion.uploadFiles(caselist.Id,fileinfo,'Test','Test');
      }
      catch(exception e)
         {
}     
        Test.stopTest();

         
            
        }
    }
      
    
}