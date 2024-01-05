/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_CaseDuplicateContactDeleteBatchTest class-
* Purpose: This test class for TAD_CaseDuplicateContactDeleteBatch
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <bhara.joshi@psagtechnologies.com>
* @maintainedBy   Samrat M, Bharat J
* @version        2.0
* @created        2019-08-08
* @modified       2019-08-30  
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

@isTest(SeeAllData=False)
public class TAD_CaseDuplicateContactDeleteBatchTest {

    /** This Method creates the testData required by the Test Methods */
    @TestSetup
    static void makeData(){

        Contact con = TestDataFactory.testContact('john.doe@test.com');
        insert con;  //dummy contact inserted.
    }

/*** This Method will create a dummy contact and invoke the batch for unit test */
    private static testMethod void testDuplicateContactBatch() {

        /** Test Execution Starts */
        Test.startTest();

            TAD_CaseDuplicateContactDeleteBatch obj = new TAD_CaseDuplicateContactDeleteBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
          /** Test Execution Ends */
    }

    /*** This Method will create a dummy contact and invoke the batch for unit test */
    private static testMethod void testSchedulerBatchClass()
    {
        String CRON_EXP = '0 0 0 12 3 ? *';  //Cron Expressio
    
        /** Test Execution Starts */
        Test.startTest();

            String jobId = System.schedule('DuplicateContactBatchSchedulerTest',  CRON_EXP, new TAD_CaseContactDeleteBatchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        // Test Execution Ends 
    }
}