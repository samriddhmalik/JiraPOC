@istest
public class MobileAppGetCouponDetails_Test {
    
    @isTest
    static void TestMethod1() {
        
        
        coupon__c Coupon=TestDataFactory.createCoupon();
        insert Coupon;
        system.debug('Coupon'+Coupon);
        
        coupon__c cs=[SELECT id,Name ,balance_remaining__c from coupon__c where id =:Coupon.Id];
        system.debug('cs line 13 '+cs);
        
        MobileAppGetCouponDetails.couponRequest cq= new MobileAppGetCouponDetails.couponRequest();
        
        cq.CouponName=cs.Name;
        cq.orderAmount= 2000;
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetails.discountSearch(cq);
        Test.stopTest();
    }
     @isTest
    static void TestMethod2() {
        
        
        coupon__c Coupon=TestDataFactory.createCoupon();
        insert Coupon;
        system.debug('Coupon'+Coupon);
        
        coupon__c cs=[SELECT id,Name ,balance_remaining__c from coupon__c where id =:Coupon.Id];
        system.debug('cs line 13 '+cs);
        
        MobileAppGetCouponDetails.couponRequest cq= new MobileAppGetCouponDetails.couponRequest();
        
        cq.CouponName=cs.Name;
        cq.orderAmount= 50;
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetails.discountSearch(cq);
        Test.stopTest();
    }
     @isTest
    static void TestMethod3() {
        
        MobileAppGetCouponDetails.couponRequest cq= new MobileAppGetCouponDetails.couponRequest();
        
        cq.CouponName='test1';
        cq.orderAmount= 50;
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetails.discountSearch(cq);
        Test.stopTest();
    }
    
}