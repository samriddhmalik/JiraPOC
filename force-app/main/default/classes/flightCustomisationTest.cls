@isTest
public class flightCustomisationTest  {

    @isTest
    public static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        //deal.merchant_sharing_deadline__c = 60;
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        
        dealList.add(deal);
        dealId.add(deal.Id);
        
        deal__c deal1 = TestDataFactory.createMerchantdeal(RCTTaddeal[0].Id , acctBussiness.Id );   // deal1s created
        deal1.Allocation_by__c='Deal';
        deal1.Flight_Book_By__c = 1;
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        deal1.PIF_Module__c = 'Hotel Only';
        //deal1.merchant_sharing_deadline__c = 60;
        deal1.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal1.Send_Merchant_Confirmation_email__c = true;
        deal1.Arrival_Airport_Code__c = 'SYD';
        deal1.Departure_Airport_Code__c = 'AUH';
        
        dealList.add(deal1);
        dealId.add(deal1.Id);
        
        insert dealList;
        
        AE_SB__c aesb = TestDataFactory.createAE_SBBasic(deal);
        insert aesb;
        airline_upgrade__c airlineUpgrade = TestDataFactory.airlineUpgrade(deal);
        insert airlineUpgrade;
        stopover__c stopOver = TestDataFactory.createStopover(deal);
        insert stopOver;
        sub_stopover__c substopover = TestDataFactory.createSubStopover(deal);
        insert substopover;
        
        Carrier__c carrier= new carrier__c();
        carrier.Deal__c = deal.id;
        carrier.Carrier_Price__c = 200;
        carrier.Carrier_Group__c = 'Emirates';
        insert carrier;
        
        Carrier_Addon_Junction__c caj = new Carrier_Addon_Junction__c();
        caj.deal__c = deal.id;
        caj.airline_upgrade__c = airlineUpgrade.id;
        caj.Carrier__c=carrier.id;
        insert caj;
        list<flightCustomisation.CarrierAddon> caListSave = new list<flightCustomisation.CarrierAddon>();
        flightCustomisation.CarrierAddon ca =new flightCustomisation.CarrierAddon();
        ca.addon = aesb.id;
        ca.carrier='Emirates';
        ca.type='aesb';
        caListSave.add(ca);
        
        flightCustomisation.CarrierAddon ca1 =new flightCustomisation.CarrierAddon();
        ca1.addon = airlineUpgrade.id;
        ca1.carrier='Emirates';
        ca1.type='airlineUpgrade';
        caListSave.add(ca1);
        
        flightCustomisation.CarrierAddon ca2 =new flightCustomisation.CarrierAddon();
        ca2.addon = substopover.id;
        ca2.carrier='Emirates';
        ca2.type='stopOver';
        caListSave.add(ca2);
        
        flightCustomisation.getDealData(deal.id);
        flightCustomisation.getCarriers(deal.id);
        flightCustomisation.getCarrierAddons(deal.id);
        flightCustomisation.getAESB(deal.id);
        flightCustomisation.getAirLineUpgrade(deal.id);
        //flightCustomisation.getStopOver(deal.id);
        flightCustomisation.saveRecords(caListSave,deal.id);
        flightCustomisation.deleteRecords(caListSave,deal.id);
    }
}