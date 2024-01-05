@isTest
public class BatchScheduleTravefyTest {
    private class Mock implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest req) {
            if (req.getEndpoint()=='https://api.travefy.com:81/api/v1/users') {
                HttpResponse res = new HttpResponse();
                res.setBody('[{"User": {"Id": 262,"FullName": "Samriddh Malik","ImageUrl": "https://s3.amazonaws.com/travefy-storage/content/default-pro.png","Username": "sachin@psagtechnologies.com.p1","IsAgent": true,"AgentSubscriptionIsActive": true},"AccessToken": "79655d3ea7ec429da144d22af6bf3040","PublicKey": "a85976fd6f144d619bb65d394f0d70b1","AgentSubscriptionLevel": 1,"IsActive": true}]');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint()=='https://api.travefy.com:81/api/v1/trips') {
                HttpResponse res = new HttpResponse();
                res.setBody('[{"Id": 923,"ShareUrlPath": "trip/6yw8kar6zqggtj5rdkmsvuhsxf9q","Name": "12 Day 2 for 1 China Odyssey","Active": true}]');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint()=='https://api.travefy.com:81/api/v1/trips/923/tripUsers/invite'){
                HttpResponse res = new HttpResponse();
                res.setBody('[{"Id": 1025,"TripId": 917,"UserId": 274,"Role": 4}]');
                res.setStatusCode(200);
                return res;
                
            }
            return null; 
        }
        
    }
    
    public static testMethod void testschedule() {
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        Travefy_Document_POE__c travefy = new Travefy_Document_POE__c();
        travefy.ordexp_tad_order__c= order1.id;
        travefy.Order_Line_Item__c = oli.id;
        travefy.departures_dates__c  = departureDates.id;
        travefy.agent_email__c='sachin@psagtechnologies.com.p1';
        travefy.Send_to_Travefy__c = true;
        insert travefy;
        travefy.JSON_TripFull_Request__c='{ "Name": "Trip Test","InviteMessage": "Welcome to the trip!"}';
        travefy.JSON_TripUsers_Request__c='{"tripUsers":[{"role":"4","fullName":"Akhil Sharma","email":null},{"role":"4","fullName":"Kapil Sharma","email":null}]}';
        update travefy;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.StartTest();
        BatchScheduleTravefy tb = new BatchScheduleTravefy();
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, tb);
        Test.stopTest();
    }
    
}