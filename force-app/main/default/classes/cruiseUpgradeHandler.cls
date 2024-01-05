public class cruiseUpgradeHandler {
    
    public static void findAndCreateOlRecord(List<Cruise_Upgrade__c> cruiseUpgrades){
        
        // Create OLI DataSet
        Set<String> oliIdsSet = new Set<String>();
        for(Cruise_Upgrade__c cu : cruiseUpgrades){
            oliIdsSet.add(cu.Order_Line_Item__c);
        }
        
        // Find OLI data
        Set<string> subOptionsId = new Set<string>();
        
        Map<Id,order_line_item__c> olis = new Map<Id,order_line_item__c>([SELECT Id ,ordexp_departure_date__r.Total_Sold_Hold_POE__c  ,ordexp_TAD_Order__r.ordexp_purchase_date__c,ordexp_TAD_Order__r.recordType.name,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ff_Account_Id__c,Quantity__c,Deal__c,Deal__r.Accounting_Treatment_AU__c,Deal__r.deal_type__c,ordexp_TAD_Order__r.ordexp_account__r.CurrencyIsoCode,ordexp_Options__c,Deal__r.per_night_allocation__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,Pricing_Model__c,ordexp_TAD_Order__r.ordexp_deal_type__c,ordexp_TAD_Order__r.ordexp_option__c, ordexp_orderRT__c,Departure_cities__c,Name,PAX_Quantity__c,Sub_Options__c,ordexp_TAD_Order__c, (select Id, hss_amount__c,departures_dates__c,HSS_Cost__c FROM Order_Nights_POE__r) FROM order_line_item__c WHERE Id IN: oliIdsSet]);
        for(order_line_item__c oli : olis.values()){
            subOptionsId.add(oli.Sub_Options__c);
        }
        System.debug('subOptionsId'+subOptionsId);
        
        // Get Component Data specific to Sub Option
        List<Component__c> components = [SELECT Id,Cost_Model__c,Is_Default_Departure_Surcharge__c,Deal__r.Accounting_Treatment_AU__c,PAX_Sold__c ,Start_Date__c,End_Date__c, Name,ff_Every_X_PAX_is_free__c,Merchant_Name__r.CurrencyIsoCode,ff_Pricing_structure__c,City__c,City__r.Surcharge__c,City__r.Deal__r.deal_type__c, City__r.surcharge_nz__c, Deal_D_O_S__c, LinkedDeal_D_O_S__c, LinkedDeal_D_O_S__r.deal_type__c, Component_Type__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Merchant_Name__c, Merchant_Name__r.Name, name__c,
                                         Allocations_Sold__c,CurrencyIsoCode,Max_Component_Price__c ,Options__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, mp_AE_SB_Accommodation__c, Stopover__c, Deal__c,(Select Id, Is_Min_or_Max_Price__c,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where Sub_Options__c  IN: subOptionsId];
        System.debug('components'+components);
        
        // Logic to create OL record
        
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        for(Cruise_Upgrade__c cu : cruiseUpgrades){
            for(Component__c c : components){
                
                String oliIds = cu.Order_Line_Item__c;
                double cruiseCPAmount = 0;
                
                Integer paxQty = Integer.valueOf(olis.get(oliIds).PAX_Quantity__c);
                if(c.Cost_Model__c =='Per QTY'){
                    paxQty = Integer.valueOf(olis.get(oliIds).Quantity__c);
                }

                order_line_POE__c ol = new order_line_POE__c();
                
                ol.Status__c = 'Active';
                ol.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
                String uniqueKey = oliIds + '#' + c.id+'#'+ol.departures_dates__c ;
                ol.External_Id__c = uniqueKey;
                ol.OL_Type__c = 'Component';
                ol.TAD_Order__c =  olis.get(oliIds).ordexp_TAD_Order__c;
                ol.Component_Name__c = c.name__c;
                ol.component__c  = c.Id;
                ol.Cruise_Upgrade__c = cu.id;
                ol.mp_merchant__c=c.Merchant_Name__c;
                ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                ol.Order_Line_Item__c = oliIds;
                //ol.MP_Start_Date__c = updateMPStartDate(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                ol.Deal__c = c.deal__c;//FF-894
                ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                ol.PAX_Travelling__c=1;
                if(olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TAD' || olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TC' ){
                    ol.ff_entity__c ='Trip A Deal Pty Limited';
                }else{
                    ol.ff_entity__c ='TripADeal (NZ) Limited';
                }
                
                
                ol.Gross_cost__c=cu.Nett__c ;
                
                // Calcualte Pricing
                
                orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOLGrossCost(c, olis.get(oliIds),integer.valueof(olis.get(oliIds).ordexp_departure_date__r.Total_Sold_Hold_POE__c));
                if(w.grossCostVal != null)
                    ol.Gross_cost__c = w.grossCostVal;
                else{
                    ol.Gross_cost__c = (c.Max_Component_Price__c==null?0:c.Max_Component_Price__c)*paxQty;
                    ol.Max_Price_applied__c = true;  
                } 
                ol.Component_Pricing__c = w.compPricingid;
                orderLines.add(ol); 
                System.debug('olRec'+ol);
            }
        }
        
        if(!orderLines.isEmpty()){
            insert orderLines;
        }
        
    }
    
    //PSAG - 82 Start
    public static void automateFinancialFields(List<Cruise_Upgrade__c> cruiseUpgrades){
        system.debug('cruiseUpgrades '+cruiseUpgrades);
        Set<Id> subOptionsIdSet = New Set<Id>();
        Map<String,Double> CruiseCPMap = New Map<String,Double>();
        
        List<Cruise_Upgrade__c> fetchCruiseUpgradeListToUpdate = [SELECT Id,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Sub_Options__c,Type__c,Cruise_CP__c,Nett__c,Total__c FROM Cruise_Upgrade__c WHERE Id IN : cruiseUpgrades];
        if(!fetchCruiseUpgradeListToUpdate.isEmpty()){
        
        // Get Order Line Gross Cost Rollup for Cruise CP Field update
                List<AggregateResult> AggregateResults = [SELECT Cruise_Upgrade__c, SUM(Gross_Cost__c) cruiseCP FROM order_line_POE__c Where Cruise_Upgrade__c IN: cruiseUpgrades GROUP BY Cruise_Upgrade__c];
                system.debug('AggregateResults '+AggregateResults);
                if(!AggregateResults.isEmpty()){
                    for(AggregateResult aggr : AggregateResults){
                        CruiseCPMap.put(string.ValueOf(aggr.get('Cruise_Upgrade__c')),Double.valueOf(aggr.get('cruiseCP')));
                    }
                }

            for(Cruise_Upgrade__c objCruise_Upgrade : fetchCruiseUpgradeListToUpdate){
                
                objCruise_Upgrade.Cruise_CP__c =   CruiseCPMap.get(objCruise_Upgrade.Id) != Null 
                    ? CruiseCPMap.get(objCruise_Upgrade.Id) : 0.00;
                
                if(objCruise_Upgrade.Nett__c != Null){
                    objCruise_Upgrade.Total__c = (objCruise_Upgrade.Nett__c - (1.2 * objCruise_Upgrade.Cruise_CP__c)) + (50 * objCruise_Upgrade.Order_Line_Item__r.PAX_Qty__c);
                }else{
                    objCruise_Upgrade.Total__c = (1.2 * objCruise_Upgrade.Cruise_CP__c) + (50 * objCruise_Upgrade.Order_Line_Item__r.PAX_Qty__c);
                }            
            }
           update fetchCruiseUpgradeListToUpdate; 
        }
    }
    //PSAG - 82 Stop
    
    
    //PSAG - 81 Start
    public static void createOrderCommsRecord(List<Cruise_Upgrade__c> cruiseUpgrades){
        List<Order_Communication_POE__c> ordCommsInsert = New List<Order_Communication_POE__c>();
        
        List<Cruise_Upgrade__c> fetchCruiseUpgradeListToUpdate = [SELECT Id,Include_Amount__c,Customer_Coms_Details__c,TAD_Order__r.Full_SFID__c,TAD_Order__r.ordexp_email_purchaser__c,TAD_Order__r.Purchaser_First_Name__c,TAD_Order__r.purchaser_last_name__c,TAD_Order__r.purchaser_full_name__c,Type__c,Total__c,TAD_Order__c   FROM Cruise_Upgrade__c WHERE Id IN : cruiseUpgrades AND Status__c = 'Secured'];
        
        if(!fetchCruiseUpgradeListToUpdate.isEmpty()){
            for(Cruise_Upgrade__c objCruiseUpgrade : fetchCruiseUpgradeListToUpdate){
                Order_Communication_POE__c ordComm = new Order_Communication_POE__c();
                ordComm.TAD_Order__c = objCruiseUpgrade.TAD_Order__c;
                ordComm.email_purchaser__c = objCruiseUpgrade.TAD_Order__r.ordexp_email_purchaser__c;
                ordComm.Order_SFID__c = objCruiseUpgrade.TAD_Order__r.Full_SFID__c;
                ordComm.purchaser_first_name__c = objCruiseUpgrade.TAD_Order__r.Purchaser_First_Name__c;
                ordComm.purchaser_last_name__c = objCruiseUpgrade.TAD_Order__r.purchaser_last_name__c;
                ordComm.purchaser_full_name__c = objCruiseUpgrade.TAD_Order__r.purchaser_full_name__c;
                ordComm.Cruise_Customisation_Type__c = objCruiseUpgrade.Type__c;
                if(objCruiseUpgrade.Include_Amount__c == True){
                   ordComm.Total_Amount_Paid__c = objCruiseUpgrade.Total__c; 
                }
                ordComm.communication_code__c = 'Cruise Product Expansion Order Confirmation';
                ordComm.Customer_Coms_Details__c = objCruiseUpgrade.Customer_Coms_Details__c;
                
                ordCommsInsert.add(ordComm);
            }
        }

        if(!ordCommsInsert.isEmpty()){
            insert ordCommsInsert;
        }
    }
    //PSAG - 81 Stop
}