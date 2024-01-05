@isTest
public class DayTriggerHandlerTest {
    @isTest
    public static void DayTriggerTest(){
        
         List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');
      	List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal; 
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates1.special_date__c = True;
        departureDates1.create_travel_documentation__c = true;
        departureDates1.travel_days_created__c = true;
        departureDates1.create_days__c = true;
        departureDates1.travel_documentation_precheck__c = true;
        departureDates1.travel_documentation_created__c = true;
        insert departureDates1;
        
        Accommodation__c Accom = new Accommodation__c();
        Accom.account__c = acctBussiness.Id;
        Accom.Name = 'Test Accomodation';
        insert Accom;
            
        Day__c day1 = new Day__c();
      //  day1.accommodation__c = Accom.Id;
        day1.departures_dates__c = departureDates1.Id;
        day1.sub_option__c = subOptions.Id;
        insert day1;
        
       //  Day__c day2 = new Day__c();
        day1.accommodation__c = Accom.Id;
        day1.departures_dates__c = departureDates1.Id;
        day1.sub_option__c = subOptions.Id;
        update day1;
        
        
    }
    
    
  

}