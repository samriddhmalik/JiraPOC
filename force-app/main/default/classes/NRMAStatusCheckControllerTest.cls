@isTest
global class NRMAStatusCheckControllerTest {

    @isTest
    static void testCallout(){
        Test.setMock(WebServiceMock.class, new NRMACalloutMock());

        mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort check = new mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort();
        mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType res = check.GetMemberStatus('123456789','','','','','','');
        System.debug(res);
        System.assertEquals('True',res.MemberStatus);
        System.assertEquals('P',res.IdType);

    }

    @isTest
    static void testWithAccNRMAStatusCheckController() {
        
        List<RecordType> RCT = TADUtils.getRecordType(Label.TAD_RT_NRMA_Person_Account);
        Account acct = TestDataFactory.createPersonAccount(RCT[0].id);
        insert acct;

        PageReference pageRef = Page.New_Single_Payment;
        pageRef.getParameters().put('id', String.valueOf(acct.Id));
        Test.setCurrentPage(pageRef);
        Test.setMock(WebServiceMock.class, new NRMACalloutMock());
        Test.startTest();

        System.debug(acct);

        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        NRMAStatusCheckController controller = new NRMAStatusCheckController(sc);
        controller.saveResult();
        controller.backToAccount();

        Test.stopTest();

    }

    @isTest
    static void testWithoutAccNRMAStatusCheckController() {

        List<RecordType> RCT = TADUtils.getRecordType(Label.TAD_RT_NRMA_Person_Account);
        Account acct = TestDataFactory.createPersonAccount(RCT[0].id);
        insert acct;
		acct.NRMA_Membership_Number__c='';
        update acct; 

        PageReference pageRef = Page.New_Single_Payment;
        pageRef.getParameters().put('id', String.valueOf(acct.Id));
        Test.setCurrentPage(pageRef);
        Test.setMock(WebServiceMock.class, new NRMACalloutMock());
        Test.startTest();

        System.debug(acct);

        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        NRMAStatusCheckController controller = new NRMAStatusCheckController(sc);
        controller.saveResult();
        controller.backToAccount();

        Test.stopTest();

    }
}