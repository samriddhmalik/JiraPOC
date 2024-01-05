/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* ordercDataBundler class-
* Purpose: A class to bundle order__c related data for use in multiple handler classes
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Peter R   <peter.russell@tripadeal.com.au>
* @lastModifiedBy Peter R   <peter.russell@tripadeal.com.au>
* @maintainedBy   Peter R   <peter.russell@tripadeal.com.au>
* @version        1.0
* @created        2019-10-30
* @modified       2019-10-30
* @systemLayer    Utility
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public with sharing class ordercDataBundler {
    
    public Map<Id,Account> accounts {get;set;}
    public Map<Id,Deal__c> deals {get;set;}
    public Map<Id,options__c> options {get;set;}
    public Map<Id,sub_options__c> subOptions {get;set;}
    public Map<Id,departure_cities__c> cities {get;set;}
    public Map<Id,departures_dates__c> dds {get;set;}
    public Map<Id,sub_stopover__c> subStopovers {get;set;}
    public Map<Id,land_activity__c> landActivities {get;set;}
    public Map<Id,AE_SB__c> aesbs {get;set;}
    public Map<Id,airline_upgrade__c> airlineUpgrades {get;set;}
    public Map<Id,Component__c> components {get;set;}

    public List<Component__c> dealComponents {get;set;}
    public List<Component__c> optionComponents {get;set;}
    public List<Component__c> subOptionComponents {get;set;}
    public List<Component__c> landActivityComponents {get;set;}
    public List<Component__c> aesbComponents {get;set;}
    public List<Component__c> stopoverComponents {get;set;}
    public List<Component__c> airlineUpgradeComponents {get;set;}

    public Map<Id, List<Component__c>> sObjectIdComponentList {get;set;}

    /** This method instanciates the bundle***
*  @param : List<order__c> orders -> List of orders passed in from Trigger.New
*  @returnType : Instanciates ordercDataBundler 
* *********************/  
    public ordercDataBundler(List<order__c> orders) {

        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> dealIdSet = new Set<Id>();
        Set<Id> optionIdSet = new Set<Id>();
        Set<Id> subOptionIdSet = new Set<Id>();
        Set<Id> ddIdSet = new Set<Id>();
        Set<Id> cityIdSet = new Set<Id>();
        Set<Id> subStopoverIdSet = new Set<Id>();
        Set<Id> laIdSet = new Set<Id>();
        Set<Id> aesbIdSet = new Set<Id>();
        Set<Id> airlineUpgradeIdSet = new Set<Id>();

        for (order__c o : orders) {
            accountIdSet.add(o.Account__c);
            dealIdSet.add(o.deal__c);
            optionIdSet.add(o.Options__c);
            subOptionIdSet.add(o.Sub_Options__c);
            ddIdSet.add(o.departures_dates__c);
            cityIdSet.add(o.departure_cities__c);
            subStopoverIdSet.add(o.pre_tour_stopover__c);
            subStopoverIdSet.add(o.post_tour_stopover__c);
            laIdSet.add(o.land_activity__c);
            laIdSet.add(o.land_activity_a__c);
            laIdSet.add(o.land_activity_b__c);
            laIdSet.add(o.land_activity_c__c);
            aesbIdSet.add(o.ae__c);
            aesbIdSet.add(o.sb__c);
            airlineUpgradeIdSet.add(o.airline_upgrade__c);
        }

        accounts = new Map<Id, Account>([SELECT Id, IsPersonAccount, PersonEmail, FirstName, LastName, uid__c FROM Account WHERE Id IN :accountIdSet]);
        deals = new Map<Id, Deal__c>([SELECT Id, Name, title__c, per_night_allocation__c, Is_Escapes__c, is_domestic__c FROM Deal__c WHERE Id IN :dealIdSet]);
        options = new Map<Id, options__c>([SELECT Id, Name, Deal__c, title__c, price__c, price_nz__c, NIghts__c FROM options__c WHERE Id IN :optionIdSet]);
        subOptions = new Map<Id, sub_options__c>([SELECT Id, title__c, Price_formula__c, price_formula_nz__c, solo_surcharge__c, solo_surcharge_nz__c, Adult__c, Child__c FROM sub_options__c WHERE Id IN :subOptionIdSet]);
        dds = new Map<Id, departures_dates__c>([SELECT Id, date__c, HSS__c, HSS_nz__c, HSS_amount__c, HSS_amount_nz__c, fee_application__c FROM departures_dates__c WHERE Id IN :ddIdSet]);
        cities = new Map<Id, departure_cities__c>([SELECT Id, city__c, Surcharge__c, surcharge_nz__c, fee_application__c FROM departure_cities__c WHERE Id IN :cityIdSet]);
        
        if (!subStopoverIdSet.isEmpty()) { 
            subStopovers = new Map<Id, sub_stopover__c>([SELECT Id, Name, price_nz__c, Price__c, Price_Solo_nz__c, Price_Solo__c, fee_application__c FROM sub_stopover__c WHERE Id IN :subStopoverIdSet]);
        }
        if (!laIdSet.isEmpty()) {
            landActivities = new Map<Id, land_activity__c>([SELECT Id, Name, solo_price__c, solo_price_nz__c, price__c, price_nz__c, fee_application__c FROM land_activity__c WHERE Id IN :laIdSet]);
        }
        if (!aesbIdSet.isEmpty()) {
            aesbs = new Map<Id, AE_SB__c>([SELECT Id, Type__c, price__c, price_nz__c, fee_application__c FROM AE_SB__c WHERE Id IN :aesbIdSet]);
        }
        if (!airlineUpgradeIdSet.isEmpty()) {
            airlineUpgrades = new Map<Id, airline_upgrade__c>([SELECT Id, price__c, price_nz__c, fee_application__c FROM airline_upgrade__c WHERE Id IN :airlineUpgradeIdSet]);
        }

        components = new Map<Id,Component__c>([SELECT Id, Name, Deal_D_O_S__c, LinkedDeal_D_O_S__c, Component_Type__c, Cost_AUD__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Nett_Cost__c, Merchant_Name__c, Merchant_Name__r.Name, name__c,
                Options__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, Stopover__c, Deal__c FROM Component__c WHERE LinkedDeal_D_O_S__c IN :dealIdSet]);
        
        if (components.size() > 0) {

            dealComponents = new List<Component__c>();
            optionComponents = new List<Component__c>();
            subOptionComponents = new List<Component__c>();
            landActivityComponents = new List<Component__c>();
            aesbComponents = new List<Component__c>();
            stopoverComponents = new List<Component__c>();
            airlineUpgradeComponents = new List<Component__c>();

            for (Component__c c : components.values()) {
                if (c.Deal__c != null) {
                    dealComponents.add(c);
                } else if (c.Options__c != null) {
                    optionComponents.add(c);
                } else if (c.Sub_Options__c != null) {
                    subOptionComponents.add(c);
                } else if (c.Land_Activity__c != null) {
                    landActivityComponents.add(c);
                } else if (c.AE_SB__c != null) {
                    aesbComponents.add(c);
                } else if (c.Stopover__c != null) {
                    stopoverComponents.add(c);
                } else if (c.Airline_Upgrade__c != null) {
                    airlineUpgradeComponents.add(c);
                }
            }

            // Build accessible collections for each order
            // Map<Id, Map<String, List<Component__c>>>
            sObjectIdComponentList = new Map<Id, List<Component__c>>();

            //List<Component__c> orderDepDatesComponentList = new List<Component__c>();
            //List<Component__c> orderDepCitiesComponentList = new List<Component__c>();

            for (Id id : dealIdSet) {
                List<Component__c> orderDealComponentList = new List<Component__c>();
                for (Component__c c : dealComponents) {
                    if (id == c.Deal__c) {
                        orderDealComponentList.add(c);
                    }
                }
                if (!orderDealComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderDealComponentList);
                }
            }
            for (Id id : optionIdSet) {
                List<Component__c> orderOptionComponentList = new List<Component__c>();
                for (Component__c c : optionComponents) {
                    if (id == c.Options__c) {
                        orderOptionComponentList.add(c);
                    }
                }
                if (!orderOptionComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderOptionComponentList);
                }
            }
            for (Id id : subOptionIdSet) {
                List<Component__c> orderSuboptionComponentList = new List<Component__c>();
                for (Component__c c : subOptionComponents) {
                    if (id == c.Sub_Options__c) {
                        orderSuboptionComponentList.add(c);
                    }
                }
                if (!orderSuboptionComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderSuboptionComponentList);
                }
            }
            for (Id id : laIdSet) {
                List<Component__c> orderLandActivityComponentList = new List<Component__c>();
                for (Component__c c : landActivityComponents) {
                    if (id == c.Land_Activity__c) {
                        orderLandActivityComponentList.add(c);
                    }
                }
                if (!orderLandActivityComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderLandActivityComponentList);
                }
            }
            for (Id id : aesbIdSet) {
                List<Component__c> orderAeSbComponentList = new List<Component__c>();
                for (Component__c c : aesbComponents) {
                    if (id == c.AE_SB__c) {
                        orderAeSbComponentList.add(c);
                    }
                }
                if (!orderAeSbComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderAeSbComponentList);
                }
            }
            for (Id id : subStopoverIdSet) {
                List<Component__c> orderStopoverComponentList = new List<Component__c>();
                for (Component__c c : stopoverComponents) {
                    if (id == c.Stopover__c) {
                        orderStopoverComponentList.add(c);
                    }
                }
                if (!orderStopoverComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderStopoverComponentList);
                }
            }
            for (Id id : airlineUpgradeIdSet) {
                List<Component__c> orderAirlineUpgradeComponentList = new List<Component__c>();
                for (Component__c c : airlineUpgradeComponents) {
                    if (id == c.Airline_Upgrade__c) {
                        orderAirlineUpgradeComponentList.add(c);
                    }
                }
                if (!orderAirlineUpgradeComponentList.isEmpty()) {
                    sObjectIdComponentList.put(id, orderAirlineUpgradeComponentList);
                }
            }
        }
    }
}