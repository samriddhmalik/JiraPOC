@isTest
public class Tad_UpdateCouponExpiryBatchTest {
@isTest
    public static void testMethod1(){
        test.startTest();
        coupon__c coupon = new coupon__c(Name__c = 'test Coupon',Coupon_type__c = 'Staff', currency_code__c ='AUD',Usage__c = 'Multi',usable_count__c = 5,Is_Agent_Coupon__c = true,Expiry_Date__c = System.today());
        insert coupon;
        Tad_UpdateCouponExpiryBatchScheduler sch = new Tad_UpdateCouponExpiryBatchScheduler();
        String cron = '0 0 2 * * ?'; 
        System.schedule('testjob',cron,sch);
        test.stopTest();
    }
}