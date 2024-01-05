@istest
public class MobileAppGetCouponDetails_Testv2 {
   
  /* @isTest
    static void TestMethod1() {
       
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c='djjddjdd';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Australia';
        deal.Region__c='Asia';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10;   
        coupon.Coupon_Restrictions__c = 'Cinc:Australia;India|Deal:'+deal.name__c+';4312,6723|Rinc:Pacific;Asia|Cexc:China;Japan';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
       
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    }
     @isTest
    static void TestMethod2() {
       
      List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c='djjddjdd';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Australia';
        deal.Region__c='Asia';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10;   
        coupon.Coupon_Restrictions__c = 'Deal:'+deal.name__c+';4312;6723|Rinc:Pacific;Asia|Cexc:China;Japan';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
       
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    } */
    
   @isTest
    static void TestMethod3() {
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c='djjddjdd';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Canada;United States';
        deal.Region__c='Asia';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        //coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10; 
        coupon.Min_order_value__c=87;
        //coupon.Coupon_Restrictions__c = 'Cexc:China;Japan|Rexc:Asia|Rinc:North America|Cinc:Canada;United States|'+deal.name__c+'4312;6723';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
        coupon.Usage__c = 'Multi';
       
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.Id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
       MobileAppGetCouponDetailsv2.mainWrapper mn=new MobileAppGetCouponDetailsv2.mainWrapper();
        mn.Coupon='';
        mn.Discount=90;
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    }
 
   @isTest
    static void TestMethod5() {
       
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c=null;
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Australia';
        deal.Region__c='Asia';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10;   
        coupon.Coupon_Restrictions__c = 'Cexc:China;Japan|Rexc:Asia|Rinc:North America|Cinc:Canada;United States|Deal:'+deal.name__c+'4312;6723';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
       
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    } 
    
    @isTest
    static void TestMethod6() {
   List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c='djjddjdd';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Canada;United States';
        deal.Region__c='North America';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10; 
        coupon.Min_order_value__c=87;
        coupon.Coupon_Restrictions__c = 'Cexc:China;Japan|Rexc:Asia|Rinc:North America|Cinc:Canada;United States|Deal:4312;6723';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
       	coupon.Usage__c = 'Multi';
        
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    }
    
    
    @isTest
    static void TestMethod7() {
   List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
           
       List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acc.app_session__c='djjddjdd';
        insert acc;
       
       
        // List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       // List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.app_session__c='djjddjdd';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Country__c='Canada;United States';
        deal.Region__c='Asia';
        
        insert deal;
         account accc=[Select id ,app_session__c from account where id=:acctBussiness.id];
        
        coupon__c coupon = new coupon__c();    
        coupon.Status__c = 'Enabled';      
        coupon.Name__c = 'testcoupon1';      
        coupon.Discount__c = 500;  
        //coupon.Deal__c=deal.id;
        coupon.usable_count__c=10;
        // coupon.appSessionCode=accc.app_session__c;
        coupon.usable_count__c = 10; 
        coupon.Min_order_value__c=87;
        //coupon.Coupon_Restrictions__c = 'Cexc:China;Japan|Rexc:Asia|Rinc:North America|Cinc:Canada;United States|'+deal.name__c+'4312;6723';
        coupon.account__c=acctBussiness.Id;
        coupon.currency_code__c = 'AUD';
        coupon.Usage__c = 'Single';
       
        insert coupon;
        system.debug('Coupon'+coupon);
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getCouponDetailsv2/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{ "CouponName": "'+coupon.Name__c+'", "orderAmount": 500, "appSessionCode": "'+accc.app_session__c+'", "accountSFId": "'+accc.Id+'", "DealId": "'+deal.Id+'"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
       // req.params.put('appSessionCode',accc.app_session__c);
      //  req.params.put('accountSFId',accc.id);
       // req.params.put('token','xyz');
        RestContext.response= res;
   
        MobileAppGetCouponDetailsv2.couponRequest cq= new MobileAppGetCouponDetailsv2.couponRequest();
       
        cq.CouponName=coupon.Name__c;
        cq.orderAmount= 20000;
        cq.appSessionCode=accc.app_session__c;
        cq.accountSFId=accc.Id;
       
       MobileAppGetCouponDetailsv2.mainWrapper mn=new MobileAppGetCouponDetailsv2.mainWrapper();
        mn.Coupon='';
        mn.Discount=90;
        system.debug('cq line 19 '+cq);
        Test.startTest();
        MobileAppGetCouponDetailsv2.discountSearch();
        Test.stopTest();
    }
   
}