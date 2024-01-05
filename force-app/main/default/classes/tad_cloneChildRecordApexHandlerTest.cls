@isTest
public class tad_cloneChildRecordApexHandlerTest {
    
    @isTest static  void testExecute1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        departure_cities__c depCities = TestDataFactory.createDepartureCitiesBasedonVariable(deal.Id,'AU','Adelaide');
        depCities.Active__c = true;
        depCities.data_refresh__c = false;
        depCities.order_filter__c = 'TAD TC NRMA';
        insert depCities;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        dealComp.Identifier__c='4';

        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        auComp.Identifier__c='1';
        compList.add(auComp);
        
                Component__c subComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subComp.LinkedDeal_D_O_S__c = deal.id;
        subComp.ff_Every_X_PAX_is_free__c = 4;
        subComp.Sub_Options__c=subOptions.id;
        subComp.Identifier__c='2';

        compList.add(subComp);

                Component__c opComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        opComp.LinkedDeal_D_O_S__c = deal.id;
        opComp.ff_Every_X_PAX_is_free__c = 4;
        opComp.Options__c=options.Id;
        opComp.Identifier__c='3';
        compList.add(opComp);

            Component__c depComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        depComp.ff_Every_X_PAX_is_free__c = 4;
        depComp.Identifier__c='5';
        depComp.City__c=depCities.Id;
        compList.add(depComp);

        insert compList;
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = opComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price;
        List<tad_cloneChildRecordApexHandler.selectedData> selectedList=new List<tad_cloneChildRecordApexHandler.selectedData>();
        tad_cloneChildRecordApexHandler.selectedData sldata=new tad_cloneChildRecordApexHandler.selectedData();
        sldata.rcdId=subOptions.id;
        sldata.type='suboption';
        sldata.identifier='5';
        selectedList.add(sldata);
        tad_cloneChildRecordApexHandler.selectedData sldata1=new tad_cloneChildRecordApexHandler.selectedData();
        sldata1.rcdId=auComp.id;
        sldata1.type='Component';
        sldata1.identifier='6';

        selectedList.add(sldata1);
        
        tad_cloneChildRecordApexHandler.selectedData sldata2=new tad_cloneChildRecordApexHandler.selectedData();
        sldata2.rcdId=options.id;
        sldata2.type='option';
        sldata2.identifier='7';
        selectedList.add(sldata2);
        tad_cloneChildRecordApexHandler.selectedData sldata3=new tad_cloneChildRecordApexHandler.selectedData();
        sldata3.rcdId=price.id;
        sldata3.type='Component Pricing';
        sldata3.identifier='8';

        selectedList.add(sldata3);
        
        tad_cloneChildRecordApexHandler.selectedData sldata4=new tad_cloneChildRecordApexHandler.selectedData();
        sldata4.rcdId=depCities.id;
        sldata4.type='Departure City';
        sldata4.identifier='9';
        
        selectedList.add(sldata4);
        tad_cloneChildRecordApexHandler.getAllDepartureCityData(depCities.id, 'Departure City');
        tad_cloneChildRecordApexHandler.getAllOptionData(options.Id, 'option');
        //tad_cloneChildRecordApexHandler.getAllOptionData(auComp.Id, 'Component');
      //  tad_cloneChildRecordApexHandler.getAllOptionData(opComp.Id, 'Component');

        tad_cloneChildRecordApexHandler.getAllOptionData(price.Id, 'Component Pricing');
        //tad_cloneChildRecordApexHandler.getAllOptionData(subOptions.Id, 'suboption');
        tad_cloneChildRecordApexHandler.getComponentData(selectedList,'Component',opComp.id);
        tad_cloneChildRecordApexHandler.getComponentPricingData(selectedList);
        tad_cloneChildRecordApexHandler.checkComponentName(selectedList);
        tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'option');
        //tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Departure City');
      /*  tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'suboption');
        tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component');
        tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component Pricing');*/
        
    }
    
    @isTest static  void testExecute2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options created using the deal
        options.itinerary_context__c='1';
        insert options;
        
        departure_cities__c depCities = TestDataFactory.createDepartureCitiesBasedonVariable(deal.Id,'AU','Adelaide');
        depCities.Active__c = true;
        depCities.data_refresh__c = false;
        depCities.order_filter__c = 'TAD TC NRMA';
        insert depCities;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        dealComp.Identifier__c='4';

        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        auComp.Identifier__c='1';
        compList.add(auComp);
        
                Component__c subComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subComp.LinkedDeal_D_O_S__c = deal.id;
        subComp.ff_Every_X_PAX_is_free__c = 4;
        subComp.Sub_Options__c=subOptions.id;
        subComp.Identifier__c='2';

        compList.add(subComp);

        Component__c opComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        opComp.LinkedDeal_D_O_S__c = deal.id;
        opComp.ff_Every_X_PAX_is_free__c = 4;
        opComp.Options__c=options.Id;
        opComp.Identifier__c='3';
        compList.add(opComp);

            

        insert compList;
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = opComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price;
        List<tad_cloneChildRecordApexHandler.selectedData> selectedList=new List<tad_cloneChildRecordApexHandler.selectedData>();
        tad_cloneChildRecordApexHandler.selectedData sldata=new tad_cloneChildRecordApexHandler.selectedData();
        sldata.rcdId=subOptions.id;
        sldata.type='suboption';
        sldata.identifier='5';
        selectedList.add(sldata);
        tad_cloneChildRecordApexHandler.selectedData sldata1=new tad_cloneChildRecordApexHandler.selectedData();
        sldata1.rcdId=auComp.id;
        sldata1.type='Component';
        sldata1.identifier='6';

        selectedList.add(sldata1);
        
        tad_cloneChildRecordApexHandler.selectedData sldata2=new tad_cloneChildRecordApexHandler.selectedData();
        sldata2.rcdId=options.id;
        sldata2.type='option';
        sldata2.identifier='7';
        selectedList.add(sldata2);
        tad_cloneChildRecordApexHandler.selectedData sldata3=new tad_cloneChildRecordApexHandler.selectedData();
        sldata3.rcdId=price.id;
        sldata3.type='Component Pricing';
        sldata2.identifier='8';

        selectedList.add(sldata3);
        
        //tad_cloneChildRecordApexHandler.getAllOptionData(options.Id, 'option');
        //tad_cloneChildRecordApexHandler.getAllOptionData(auComp.Id, 'Component');
      //  tad_cloneChildRecordApexHandler.getAllOptionData(opComp.Id, 'Component');

        tad_cloneChildRecordApexHandler.getAllOptionData(price.Id, 'Component Pricing');
        tad_cloneChildRecordApexHandler.getAllOptionData(subOptions.Id, 'suboption');
        tad_cloneChildRecordApexHandler.getComponentData(selectedList,'',opComp.id);
        tad_cloneChildRecordApexHandler.getComponentPricingData(selectedList);
        tad_cloneChildRecordApexHandler.checkComponentName(selectedList);
        //tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'option');
        tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'suboption');
       // tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component');
       // tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component Pricing');
        
    }
     @isTest static  void testExecute3(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        dealComp.Identifier__c='4';

        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        auComp.Identifier__c='1';
        compList.add(auComp);
        
                Component__c subComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subComp.LinkedDeal_D_O_S__c = deal.id;
        subComp.ff_Every_X_PAX_is_free__c = 4;
        subComp.Sub_Options__c=subOptions.id;
        subComp.Identifier__c='2';

        compList.add(subComp);

                Component__c opComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        opComp.LinkedDeal_D_O_S__c = deal.id;
        opComp.ff_Every_X_PAX_is_free__c = 4;
        opComp.Options__c=options.Id;
        opComp.Identifier__c='3';
        compList.add(opComp);

            

        insert compList;
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = opComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price;
        List<tad_cloneChildRecordApexHandler.selectedData> selectedList=new List<tad_cloneChildRecordApexHandler.selectedData>();
        tad_cloneChildRecordApexHandler.selectedData sldata=new tad_cloneChildRecordApexHandler.selectedData();
        sldata.rcdId=subOptions.id;
        sldata.type='suboption';
        sldata.identifier='5';
        selectedList.add(sldata);
        tad_cloneChildRecordApexHandler.selectedData sldata1=new tad_cloneChildRecordApexHandler.selectedData();
        sldata1.rcdId=auComp.id;
        sldata1.type='Component';
        sldata1.identifier='6';

        selectedList.add(sldata1);
        
        tad_cloneChildRecordApexHandler.selectedData sldata2=new tad_cloneChildRecordApexHandler.selectedData();
        sldata2.rcdId=options.id;
        sldata2.type='option';
        sldata2.identifier='7';
        selectedList.add(sldata2);
        tad_cloneChildRecordApexHandler.selectedData sldata3=new tad_cloneChildRecordApexHandler.selectedData();
        sldata3.rcdId=price.id;
        sldata3.type='Component Pricing';
        sldata2.identifier='8';

        selectedList.add(sldata3);
        

        tad_cloneChildRecordApexHandler.getAllOptionData(price.Id, 'Component Pricing');
        tad_cloneChildRecordApexHandler.getAllOptionData(subOptions.Id, 'sub option');
        tad_cloneChildRecordApexHandler.getComponentData(selectedList,'',opComp.id);
        tad_cloneChildRecordApexHandler.getComponentPricingData(selectedList);
        tad_cloneChildRecordApexHandler.checkComponentName(selectedList);
        //tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'option');
        //tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'suboption');
        tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component');
       // tad_cloneChildRecordApexHandler.saveCloneData(selectedList,'Component Pricing');
        
    }
    
}