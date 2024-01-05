public class Tad_createDepCityController {
    public class depCityData{
        @AuraEnabled  public String depName {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public String orderFilter {get;set;}
        @AuraEnabled  public String feeApplication {get;set;}
        @AuraEnabled  public String site {get;set;}
        @AuraEnabled  public String city {get;set;}
        @AuraEnabled  public Decimal surcharge {get;set;}
        @AuraEnabled  public Decimal surchargeNZD {get;set;}
        @AuraEnabled  public String herokuId {get;set;}
        @AuraEnabled  public String currencyCode {get;set;}
        @AuraEnabled  public Boolean dataRefresh {get;set;}
        @AuraEnabled  public Boolean isActive {get;set;}
    }
    public class componentData{
        @AuraEnabled  public String compName {get;set;}
        @AuraEnabled  public String mercName {get;set;}
        @AuraEnabled  public String mptJoin {get;set;}
        @AuraEnabled  public String canPolicy {get;set;}
        @AuraEnabled  public String landActivity {get;set;}
        @AuraEnabled  public String mpAesb {get;set;}
        @AuraEnabled  public String aesb {get;set;}
        @AuraEnabled  public Decimal departed {get;set;}
        @AuraEnabled  public String airlineUpgrade {get;set;}
        @AuraEnabled  public String stopover {get;set;}
        @AuraEnabled  public String cName {get;set;}
        @AuraEnabled  public String identifier {get;set;}
        @AuraEnabled  public String depCityId {get;set;}
        @AuraEnabled  public Date partDeadline {get;set;}
        @AuraEnabled  public String tieredCostedRate {get;set;}
        @AuraEnabled  public String compType {get;set;}
        @AuraEnabled  public String productPricing {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public Integer compPartnerSharing {get;set;}
    }
    public class componentPricingData{
        @AuraEnabled  public String pricingName {get;set;}
        @AuraEnabled  public String pricingCategory {get;set;}
        @AuraEnabled  public String componentId {get;set;}
        @AuraEnabled  public String pricingCurrency {get;set;}
        @AuraEnabled  public Decimal pricingCosted {get;set;}
        @AuraEnabled  public String pricingDeal {get;set;}
        @AuraEnabled  public Decimal pricingGrossCost {get;set;}
        @AuraEnabled  public Decimal pricingSoloCost {get;set;}
        @AuraEnabled  public Date pricingDateFrom {get;set;}
        @AuraEnabled  public Date pricingDateto {get;set;}
        @AuraEnabled  public Date pricingBdateFrom {get;set;}
        @AuraEnabled  public Date pricingBdateTo {get;set;}
        @AuraEnabled  public Integer pricingMinPax {get;set;}
        @AuraEnabled  public Integer pricingMaxPax {get;set;}
        @AuraEnabled  public String pricingJoin {get;set;}
    }
    @AuraEnabled
    public static Id saveDepCity ( depCityData depCityData ) {
        departure_cities__c depCity = new departure_cities__c();
        depCity.Name = depCityData.depName;
        depCity.Deal__c = depCityData.dealId;
        depCity.order_filter__c = depCityData.orderFilter;
        depCity.fee_application__c = depCityData.feeApplication;
        depCity.site__c = depCityData.site;
        depCity.city__c = depCityData.city;
        depCity.Surcharge__c = depCityData.surcharge;
        depCity.surcharge_nz__c = depCityData.surchargeNZD;
        depCity.herokuid__c = depCityData.herokuId;
        depCity.CurrencyIsoCode = depCityData.currencyCode;
        depCity.data_refresh__c = depCityData.dataRefresh;
        depCity.Active__c = depCityData.isActive;
        insert depCity;
        return depCity.Id;
    }
    @AuraEnabled
    public static Id saveComponent ( componentData compData ) {
        Component__c comp = new Component__c();
        comp.Name = compData.compName;
        comp.Merchant_Name__c = compData.mercName;
        comp.MPT_JOIN__c = compData.mptJoin;
        comp.Cancellation_Policy__c = compData.canPolicy;
        comp.Land_Activity__c = compData.landActivity;
        comp.AE_SB__c = compData.aesb;
        comp.mp_AE_SB_Accommodation__c = compData.mpAesb;
        comp.Stopover__c = compData.stopover;
        comp.Departed__c = compData.departed;
        comp.name__c = compData.cName;
        comp.Airline_Upgrade__c = compData.airlineUpgrade;
        comp.Partner_Deadline__c = compData.partDeadline;
        comp.City__c = compData.depCityId;
        comp.Identifier__c = compData.identifier;
        comp.ff_Pricing_structure__c = compData.tieredCostedRate;
        comp.Component_Type__c = compData.compType;
        comp.Product_FX_Pricing__c = compData.productPricing;
        comp.Partner_Sharing_Deadline__c = compData.compPartnerSharing;
        insert comp;
        return comp.Id;
    }

    @AuraEnabled
    public static Id saveComponentPricing ( componentPricingData compPricingData ) {
        Component_Pricing__c compPricing = new Component_Pricing__c();
        compPricing.Name = compPricingData.pricingName;
        compPricing.Category__c = compPricingData.pricingCategory;
        compPricing.CurrencyIsoCode = compPricingData.pricingCurrency;
        compPricing.Costed_FX_Rate__c = compPricingData.pricingCosted;
        compPricing.LinkedDeal_D_O_S__c = compPricingData.pricingDeal;
        compPricing.Component__c = compPricingData.componentId;
        compPricing.Cost__c = compPricingData.pricingGrossCost;
        compPricing.solo_rate_total__c = compPricingData.pricingSoloCost;
        compPricing.Date_From__c = compPricingData.pricingDateFrom;
        compPricing.Date_To__c = compPricingData.pricingDateto;
        compPricing.Booking_Date_from__c = compPricingData.pricingBdateFrom;
        compPricing.Booking_Date_to__c = compPricingData.pricingBdateTo;
        compPricing.Min_Pax__c = compPricingData.pricingMinPax;
        compPricing.Max_Pax__c = compPricingData.pricingMaxPax;
        compPricing.Join__c = compPricingData.pricingJoin;
        insert compPricing;
        return compPricing.Id;
    }
     @AuraEnabled
    public static String saveComp(String compList){
        try {
            Component__c compObj = (Component__c)JSON.deserialize(compList,Component__c.class);
            insert compObj;
            return compObj.Id;
        } catch (Exception e) {
            System.debug('Exception '+e.getMessage()+' at line '+e.getLineNumber());
             return null;
        }
    }
    @AuraEnabled
    public static Id getSubStopOverData(String stopoverList){
        try {
            sub_stopover__c ssoObj = (sub_stopover__c)JSON.deserialize(stopoverList,sub_stopover__c.class);
            insert ssoObj;
            return ssoObj.Id;
        } catch (Exception e) {
            System.debug('Exception '+e.getMessage()+' at line '+e.getLineNumber());
             return e.getMessage();
        }
    }
     @AuraEnabled
    public static Id saveAesbData(String aebsList){
        try {
            AE_SB__c aesbObj = (AE_SB__c)JSON.deserialize(aebsList,AE_SB__c.class);
            insert aesbObj;
            return aesbObj.Id;
        } catch (Exception e) {
            System.debug('Exception '+e.getMessage()+' at line '+e.getLineNumber());
             return e.getMessage();
        }
    }
     @AuraEnabled
    public static Id saveAirineUpgrade(String airUpgradeList){
        try {
            airline_upgrade__c auList = (airline_upgrade__c)JSON.deserialize(airUpgradeList,airline_upgrade__c.class);
            insert auList;
            return auList.Id;
        } catch (Exception e) {
            System.debug('Exception '+e.getMessage()+' at line '+e.getLineNumber());
             return e.getMessage();
        }
    }
    @AuraEnabled
    public static Id saveLandActivity(String landActivityList){
        try {
            land_activity__c landActivity = (land_activity__c)JSON.deserialize(landActivityList,land_activity__c.class);
            insert landActivity;
            return landActivity.Id;
        } catch (Exception e) {
            System.debug('Exception '+e.getMessage()+' at line '+e.getLineNumber());
             return e.getMessage();
        }
    }
}