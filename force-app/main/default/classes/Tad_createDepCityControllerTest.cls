@isTest
public class Tad_createDepCityControllerTest {
@isTest
    public static void makeData(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness; 
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        departure_cities__c depCity = TestDataFactory.createDepartureCitiesBasedonVariable(deal.Id,'AU', 'Auckland');
        insert depCity;
        stopover__c st = new stopover__c();
        st.Deal__c = deal.Id;
        insert st;
        Product_FX_Pricing__c fxp = TestDataFactory.createPFXP();
        insert fxp;
        sub_stopover__c subStopover = new sub_stopover__c();
        subStopover.Name = 'Test-St';
        subStopover.Deal__c = st.Deal__c;
        subStopover.site__c = 'AU';
        subStopover.Price__c = 250;
        subStopover.Price_Solo__c = 200;
        subStopover.type__c = 'Post Tour';
        subStopover.Destination__c = 'Hong Kong';

         land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
                la.site__c = 'AU';
        
        Tad_createDepCityController.depCityData wrap = new Tad_createDepCityController.depCityData();
        wrap.depName = depCity.Name;
        wrap.dealId = depCity.Deal__c;
        wrap.site = depCity.site__c;
        wrap.isActive = depCity.Active__c;
        wrap.city = depCity.city__c;
        wrap.dataRefresh = false;
        
        Id depId = Tad_createDepCityController.saveDepCity(wrap);
        Tad_createDepCityController.getSubStopOverData(JSON.serialize(subStopover));
        Tad_createDepCityController.saveLandActivity(JSON.serialize(la));
        Tad_createDepCityController.componentData compWrap = new Tad_createDepCityController.componentData();
            compWrap.compName = 'Test';
            compWrap.mercName = acctBussiness.Id;
            compWrap.cName  ='Test';
            compWrap.identifier = 'yt';
            compWrap.depCityId = depId;
            compWrap.tieredCostedRate =  'Not applicable';
            compWrap.compType = 'Rail';
            compWrap.productPricing =fxp.Id;
            compWrap.dealId =deal.Id;
         Id compID = Tad_createDepCityController.saveComponent(compWrap);
        Tad_createDepCityController.componentPricingData pricingWrap= new Tad_createDepCityController.componentPricingData();
        pricingWrap.pricingName = 'Test';
        pricingWrap.componentId =compID;
        Tad_createDepCityController.saveComponentPricing(pricingWrap);
        
    }
}