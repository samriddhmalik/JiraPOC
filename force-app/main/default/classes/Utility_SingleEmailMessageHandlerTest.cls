@isTest
public class Utility_SingleEmailMessageHandlerTest {
    @isTest 
    static void  emailHandler(){
        
        
        EmailTemplate e = new EmailTemplate (developerName = 'test',isActive = true, FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test'); // plus any other fields that you want to set
        insert e;
        
        List<Profile> pf = TADUtils.getUserProfile('System Administrator');
        User u = TestDataFactory.createUser(pf[0].id);        
        insert u;
        
        system.runAs(u) {
            
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);    
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
            system.debug('acctBussiness'+acctBussiness);
            // Bussiness account Inserted
            insert acctBussiness;
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            insert deal;
            
            //Deal_Draft__c dealDraft = TestDataFactory.createDealDraft(deal);
            //insert dealDraft;
            
            //deal.Deal_Draft__c=dealDraft.id;
            //update deal;
            
            options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
            options.itinerary_context__c='Main Package';
            insert options;
            
            sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
            subOptions.STD_OPT__c ='Standard';        
            subOptions.itinerary_context__c='1';
            insert subOptions;
            
            departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
            insert departureDates;
            
            departures_dates__c departureDates1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
            departureDates1.date__c = System.today().addDays(8);
            insert departureDates1;
            
            departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
            insert departureCities;
            
            Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
            insert itinerary; 
            
            sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
            insert subStopover; 
            
            AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
            ae.Type__c='Arrive Early';
            insert ae;
            
            AE_SB__c sb = TestDataFactory.createAE_SB(deal , options );
            sb.Type__c='Stay Behind';
            insert sb;
            
            land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
            insert la;
            
            airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
            au.price__c = 10;
            insert au;
            
            mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
            
            insert accAe;
            
            mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
            
            insert accSb;
            
            List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
            insert acctPerson;
            
            ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
            system.debug('RTTADOrder'+RTTADOrder);
            Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
            order.ordexp_master_status__c = 'On Hold';
            order.ordexp_sub_status__c = 'Initial Payment Pending';
            insert order;
            
            Product_FX_Pricing__c pfx = TestDataFactory.createPFXP();
            insert pfx;    
            
            Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Total Package',pfx);
            comp.Deal__c=deal.id;    
            insert comp;    
            
            List<departures_dates__c> ListdepartureDates = new List<departures_dates__c>();
            ListdepartureDates.add(departureDates);
            ListdepartureDates.add(departureDates1);
            
            List<string> toAddress = new List<string>();
            toAddress.add('test1@test.com');
            List<string> ccAddress = new List<string>();
            ccAddress.add('test2@test.com'); 
            map<string,string> param2Emailtemplate = new map<string,string>();
            param2Emailtemplate.put('name','test');
            Boolean isSaveAsActivity = true;
            Boolean isUseSignature = true;
            Utility_SingleEmailMessageHandler h = new Utility_SingleEmailMessageHandler();
            h.toAddresses=toAddress;
            h.ccAddresses=ccAddress;
            h.param2Emailtemplate=param2Emailtemplate;
            h.isSaveAsActivity=isSaveAsActivity;
            h.isUseSignature=isUseSignature;
            Utility_SingleEmailMessageHandler.EmailHandlerMethodForBeforeTrigger(h.toAddresses,h.ccAddresses,h.param2Emailtemplate,h.isSaveAsActivity,h.isUseSignature);
            Utility_SingleEmailMessageHandler.EmailHandlerMethod(h.toAddresses,h.ccAddresses,h.param2Emailtemplate,h.isSaveAsActivity,h.isUseSignature);
            Utility_SingleEmailMessageHandler.departDateFindTosetEmailAddress(ListdepartureDates,true,true,true,order.Id,e.Id,order.Id);
           // Utility_SingleEmailMessageHandler.Utility_SingleEmailMessageHandler(toAddress,ccAddress,param2Emailtemplate,false,false);
        }
    }
}