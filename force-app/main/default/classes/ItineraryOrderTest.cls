/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* ItineraryOrder Test class-
* Purpose: Test Class for unit test coverage of ItineraryOrder 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-10-08
* @modified       
* @systemLayer    Test Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

@isTest
public class ItineraryOrderTest {
    
    private static testMethod void testGetSuffixWithoutParam() {
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        insert deal;
        
        Deal_Draft__c dealDraft = TestDataFactory.createDealDraft(deal);
        insert dealDraft;
        
        
        ItineraryOrder io = new ItineraryOrder();
        io.depDate=System.today();
        io.ae=new AE_SB__c();
        io.sb= new AE_SB__c();
        io.airlineUpgrade = new airline_upgrade__c();
        io.archetype=Label.Test;
        io.deal=deal;
        io.la=new land_activity__c();
        io.laa=new land_activity__c();
        io.lab=new land_activity__c();
        io.lac=new land_activity__c();
        io.msg=Label.Test;
        io.postTourStopover=new sub_stopover__c();
        io.preTourStopover=new sub_stopover__c();
        io.airlineUpgrade=new airline_upgrade__c();
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        options.itinerary_context__c = 'Main Package';
        insert options;

        options__c preOptions =  TestDataFactory.CreateOptions(deal.Id);
        preOptions.itinerary_context__c = 'Pre Extension';
        preOptions.prex_crossover_day__c = Label.ONE;
        insert preOptions;

        options__c bothOptions =  TestDataFactory.CreateOptions(deal.Id);
        bothOptions.itinerary_context__c = 'Both Extensions';
        bothOptions.prex_crossover_day__c = Label.ONE;
        insert bothOptions;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.STD_OPT__c=Label.Standard;
        insert subOptions;
        
        testGetSuffixWithoutParamOption(options,suboptions,Label.MainPackage,Label.Standard);
        testGetSuffixWithoutParamOption(preOptions,suboptions,Label.PreExtension,Label.Standard);
        testGetSuffixWithoutParamOption(options,suboptions,Label.PostExtension,Label.Standard);
        testGetSuffixWithoutParamOption(bothOptions,suboptions,Label.BothExtensions,Label.Standard);
        testGetSuffixWithoutParamOption(options,suboptions,Label.MainPackage,Label.Option);
        testGetSuffixWithoutParamOption(preOptions,suboptions,Label.PreExtension,Label.Option);
        testGetSuffixWithoutParamOption(options,suboptions,Label.PostExtension,Label.Option);
        testGetSuffixWithoutParamOption(bothOptions,suboptions,Label.BothExtensions,Label.Option);
        testGetSuffixWithoutParamOption(options,suboptions,Label.Upgrade,Label.Standard);
        
        testGetSuffixWithParamOption(suboptions,Label.MainPackage,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.PreExtension,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.PostExtension,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.BothExtensions,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.PreExtensionUpgrade,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.PostExtensionUpgrade,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.BothExtensionsUpgrade,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.MainPackage,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.PreExtension,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.PostExtension,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.BothExtensions,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.PreExtensionUpgrade,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.PostExtensionUpgrade,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.BothExtensionsUpgrade,Label.Option);
        testGetSuffixWithParamOption(suboptions,Label.Upgrade,Label.Standard);
        testGetSuffixWithParamOption(suboptions,Label.None,Label.Standard);
        
        Segment__c seg = new Segment__c();
        List<Segment__c> segList = new List<Segment__c>();
        segList.add(seg);
        Map<String,List<Segment__c>> segMap = new Map<String,List<Segment__c>>();
        segMap.put(Label.Test,segList);
        io.pnrMap=segMap;
        io.hasDepartingFlightToday(System.today());
        io.hasArrivingFlightToday(System.today());
        
    }
    
    private static void testGetSuffixWithoutParamOption(options__c options,sub_options__c subOptions,String optionName,String subOptName)
    {
        options.itinerary_context__c=optionName;
        update options;
        subOptions.STD_OPT__c=subOptName;
        update subOptions;
        ItineraryOrder io = new ItineraryOrder();
        io.option= options;
        io.subOption=subOptions;
        io.getSuffix();
        
    }
    
    private static void testGetSuffixWithParamOption(sub_options__c subOptions,String context,String subOptName)
    {
        subOptions.STD_OPT__c=subOptName;
        update subOptions;
        ItineraryOrder io = new ItineraryOrder();
        io.subOption=subOptions;
        io.getSuffix(context);
        
    }
}