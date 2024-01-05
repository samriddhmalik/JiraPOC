@isTest
public class costedRateRecordCreation_Batch_Test {

    @isTest
    public static void testMethodforCR(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        compList.add(auComp); 
        
        insert  compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = auComp.Id;
        price.Date_From__c = null;
        price.Date_To__c =  null;
        price.Max_Pax__c = null;
        price.Min_Pax__c = null;
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        price.Costed_FX_Rate__c = 0.62;
        price.CurrencyIsoCode = 'AUD';
        comPriceList.add(price);
        
        insert comPriceList;
        
        costedRateRecordCreation_Batch crBatch = new costedRateRecordCreation_Batch();
        ID batchprocessid = Database.executeBatch(crBatch);
            
    }
    
}