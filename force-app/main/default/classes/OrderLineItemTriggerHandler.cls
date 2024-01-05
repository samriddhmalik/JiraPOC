/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* OrderLineItemTriggerHandler-
* Purpose: Handler class for  OrderLineItemTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-11-19
* @modified       2019-12-08
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class OrderLineItemTriggerHandler {
    
    public static Boolean runOnce = false;  
    public static Integer runCount = 0;  
    
    public static void updateFinancials(String jsonOliString)
    {   
        /*
List<Order_line_item__c> oliToUpdate = new List<Order_line_item__c>();
List<Order_line_item__c> oliToProcess = new List<Order_line_item__c>();
List<Order_line_item__c> oliList = (List<Order_line_item__c>)JSON.deserialize(jsonOliString, List<Order_line_item__c>.class);  

//After Insert/Update Code

for(Order_line_item__c oliIterate : oliList) {
if(oliIterate.ordexp_orderRT__c =='TC'|| oliIterate.ordexp_orderRT__c =='WT'){
oliToProcess.add(oliIterate);  
}
}

if(!oliToProcess.isEmpty()){

Map<String,Wholesale_Commissions__c> wholesaleMap = new Map<String,Wholesale_Commissions__c>(); 
String wtRecNames = TAD_Constants.WORLDTRAVELLERS+','+TAD_Constants.TRAVELLERSCHOICE; 
List<Wholesale_Commissions__c> wholesaleList =[SELECT id,name,AE_SB__c,Airline_Upgrade__c,Deal__c,Departure_City_Surcharge__c,HSS__c,Land_Activities__c,Solo_Supplement__c,Stopover__c FROM Wholesale_Commissions__c where name in :wtRecNames.split(',')];
for(Wholesale_Commissions__c ws : wholesaleList)
{
wholesaleMap.put(ws.name,ws);
}

for(Order_line_item__c oli : oliToProcess)
{
if(oli.ordexp_orderRT__c==TAD_Constants.TC && !test.isRunningTest())
{    
oli.OLI_Commission__c=(oli.ordexp_suboption_amount__c *wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Deal__c)/100+
(oli.ordexp_city_surcharge_amount__c *wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Departure_City_Surcharge__c)/100+
(oli.Total_surcharge__c *wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).Solo_Supplement__c)/100+
(oli.HSS_Amount__c *wholesaleMap.get(TAD_Constants.TRAVELLERSCHOICE).HSS__c)/100;
}
if(oli.ordexp_orderRT__c==TAD_Constants.WT)
{
oli.OLI_Commission__c=(oli.ordexp_suboption_amount__c *wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Deal__c)/100+
(oli.ordexp_city_surcharge_amount__c *wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Departure_City_Surcharge__c)/100+
(oli.Total_surcharge__c *wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).Solo_Supplement__c)/100+
(oli.HSS_Amount__c *wholesaleMap.get(TAD_Constants.WORLDTRAVELLERS).HSS__c)/100;
}
Order_line_item__c ol = new Order_line_item__c();
ol.id=oli.id;
ol.OLI_Commission__c=oli.OLI_Commission__c;
oliToUpdate.add(ol);
}

if(!oliToUpdate.isEmpty()){
update oliToUpdate;  
}

}   */
    }
    
    public Static void attachGeneralPricing(Set<id> subOption,List<Order_line_item__c> olRecords){
        List<General_Pricing__c> gpRecords = [Select id , Sub_Options__c from General_Pricing__c where Sub_Options__c IN:subOption and Active__c=true ];
        
        Map<String,String> subOptionGPMap = new Map<String,String>();
        for(General_Pricing__c gp : gpRecords){
            subOptionGPMap.put(gp.Sub_Options__c,gp.id); 
        }
        
        for(Order_line_item__c ol : olRecords){
            if(ol.isSplit__c  == False){
                ol.General_Pricing__c=subOptionGPMap.get(ol.Sub_Options__c);
            }
            
        }
        
    }
    /*PSAG-438 -Starts*/
    
    public Static void handleDepCity(Set<id> depCityId,List<Order_line_item__c> olRecords){
        List<General_Pricing__c> gpRecords = [Select id , Departure_City__c from General_Pricing__c where Departure_City__c IN:depCityId and Active__c=true ];
        Map<String,String> depCityGPMap = new Map<String,String>();
        for(General_Pricing__c gp : gpRecords){
            depCityGPMap.put(gp.Departure_City__c,gp.id); 
        }
          for(Order_line_item__c ol : olRecords){
                ol.GP_Dep_City__c=depCityGPMap.get(ol.Departure_cities__c);
            
        }
    }
        /*PSAG-438 -Ends*/
    public static void restricSameDateForSubOptionAllocation(List<Order_line_item__c> oliList, Map<Id,Order_line_item__c> newOliMap){
        for(Order_line_item__c ord :[Select Id, ordexp_TAD_Order__r.ordexp_sub_status__c, ordexp_departure_date__c, Departure_cities__c, ordexp_Options__c, Sub_Options__c, Deal__c, Pricing_Model__c from Order_line_item__c where Id IN :  newOliMap.keyset()] ){
            Order_line_item__c oldRecord = newOliMap.get(ord.Id);
            List<String> restrictedSubTypes = new List<String>{'Customer Request','Flights Ticketed - NO S/O','Flights Ticketed - S/O Req','Cabins Booked/Flights Pending','Cabins Booked/Flights Ticketed - NO S/O','Cabins Booked/Flights Ticketed - S/O Req','BC Sent','Travel Pack Sent','Travel Pack Sent & MSC Cruise Ticket Pending','Travel Pack Sent & MSC Cruise Ticket Sent','Travelling','Survey Sent','Feedback Returned (Positive)','Feedback Returned (Negative)','Expired/Time out','Min Number - Deal Changed','Min Number - Credit issued','Min Number - Refunded','Customer','Pax No Show','Offloaded'};
                system.debug('oldRecord.Departure_cities__c'+oldRecord.Departure_cities__c);
            if(restrictedSubTypes.contains(ord.ordexp_TAD_Order__r.ordexp_sub_status__c))
            {
                if(ord.ordexp_departure_date__c != oldRecord.ordexp_departure_date__c) {
                    oldRecord.ordexp_departure_date__c.addError('You cannot edit Departure Date');
                }
                if(ord.Departure_cities__c  != oldRecord.Departure_cities__c) {
                    oldRecord.Departure_cities__c.addError('You cannot edit Departure City');
                }
                if(ord.ordexp_Options__c  != oldRecord.ordexp_Options__c) {
                    oldRecord.ordexp_Options__c.addError('You cannot edit Options');
                }
                if(ord.Sub_Options__c  != oldRecord.Sub_Options__c) {
                    oldRecord.Sub_Options__c.addError('You cannot edit Sub Options');
                }
                if(ord.Deal__c  != oldRecord.Deal__c) {
                    oldRecord.Deal__c.addError('You cannot edit Deal');
                }
                //  if(ord.Pricing_Model__c  != oldRecord.Pricing_Model__c) {
                //     oldRecord.Pricing_Model__c.addError('You cannot edit Pricing Model');
                // }
            }              
        }
    }
    
    public static void updateGrossAmountOnTadOrder(List<Order_line_item__c> newOliList , Map<Id,Order_line_item__c> oldOliMap, String state){
        Set<Id> orders = new Set<Id>();
        List<tad_order__c> orderToUpdate = new  List<tad_order__c>();
        
        for(Order_line_item__c oli :newOliList){
            if(state == 'Insert'){
                orders.add(oli.ordexp_TAD_Order__c);
            }
            if(state == 'Update'){
                if((oli.ordexp_total_customisations_amount__c!= oldOliMap.get(oli.id).ordexp_total_customisations_amount__c)
                   || (oli.orderxp_addons_amount__c!= oldOliMap.get(oli.id).orderxp_addons_amount__c)
                   || (oli.Total_Coupon_Discount__c!= oldOliMap.get(oli.id).Total_Coupon_Discount__c)
                   || (oli.ordexp_departure_date__c != oldOliMap.get(oli.id).ordexp_departure_date__c )
                   || (oli.ordexp_total_visa_amount__c  != oldOliMap.get(oli.id).ordexp_total_visa_amount__c  )
                   || (oli.ordexp_total_insurance_amount__c  != oldOliMap.get(oli.id).ordexp_total_insurance_amount__c  )
                   || (oli.sm_Hotel_Price__c   != oldOliMap.get(oli.id).sm_Hotel_Price__c   )
                   || (oli.on_hss_amount__c  != oldOliMap.get(oli.id).on_hss_amount__c  )
                   || (oli.General_Pricing__c   != oldOliMap.get(oli.id).General_Pricing__c   )
                   || (oli.ordexp_oli_CanAmount__c  != oldOliMap.get(oli.id).ordexp_oli_CanAmount__c  )
                   || (oli.OLI_GST_Amount__c  != oldOliMap.get(oli.id).OLI_GST_Amount__c  )
                   || (oli.Cruise_Upgrade__c   != oldOliMap.get(oli.id).Cruise_Upgrade__c   )
                   || (oli.Departure_cities__c  != oldOliMap.get(oli.id).Departure_cities__c  ) || (oli.PAX_Quantity__c  != oldOliMap.get(oli.id).PAX_Quantity__c  ))
                {
                    orders.add(oli.ordexp_TAD_Order__c);   
                }  
            }
            
        }
        if(!orders.isEmpty()){
            List<tad_order__c> ordersList = [Select id ,ordexp_gross_amount__c,ordexp_departure_date__c,ordexp_deal__r.ordexp_Is_Allocation_by_SubOption__c, ordexp_Sub_Options_for_Stay__c,(Select id, ordexp_departure_date__c,OLI_GST_Amount__c,orderxp_total_amount__c from Order_Line_Items_orders__r) from tad_order__c where id IN:orders];
            
            for(tad_order__c o :ordersList){
                Decimal grossAmount =0;
                Decimal gstAmount =0;
                tad_order__c tad = new  tad_order__c(id=o.id);
                for(Order_line_item__c ol :o.Order_Line_Items_orders__r){
                    grossAmount = grossAmount + ol.orderxp_total_amount__c;
                    gstAmount = gstAmount + ol.OLI_GST_Amount__c ;
                }
                System.debug('GST Amount'+gstAmount);
                if(tad.ordexp_gross_amount__c!=grossAmount){
                    tad.ordexp_gross_amount__c= grossAmount;
                    tad.ff_Total_Order_GST_Amount__c=gstAmount;
                    orderToUpdate.add(tad);   
                }
                
            }
            
            if(!orderToUpdate.isEmpty()){
                update orderToUpdate;   
            }  
        }
        
    }
    
    /* 
public static void createCSAttributionForOLI(List<Order_line_item__c> newOLIRecords){
List<CS_Attribution_POE__c> listOfCsAttribute = new List<CS_Attribution_POE__c>();
for(Order_line_item__c oli : [Select id, ordexp_suboption_amount__c, Total_surcharge__c, ordexp_city_surcharge_amount__c, HSS_Amount__c, ordexp_TAD_Order__c, CreatedBy.Id, LastModifiedBy.Id from Order_line_item__c where Id IN : newOLIRecords]){ 
CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
cs.cs_OLI__c = oli.Id;
cs.cs_Sale_Amount__c = ((oli.ordexp_suboption_amount__c==null?0:oli.ordexp_suboption_amount__c) + oli.Total_surcharge__c + oli.ordexp_city_surcharge_amount__c + oli.HSS_Amount__c);
cs.cs_Attribution_Type__c = 'OLI';
cs.TAD_Order__c = oli.ordexp_TAD_Order__c;
cs.cs_status__c ='On Hold';
cs.User__c = oli.LastModifiedBy.id;
listOfCsAttribute.add(cs);   
}
if(!listOfCsAttribute.isEmpty()){
insert listOfCsAttribute;
}
}


public static void updateCSAttributionForOLIamendments(List<Order_line_item__c> newOLIRecords, Map<Id,Order_line_item__c> oldOLIMap, Map<Id,Order_line_item__c> newOLIMap){

system.debug('updateCSAttributionForOLIamendments '+newOLIRecords);

Map<Id, Order_line_item__c> oliIdVsOliMap = new Map<Id, Order_line_item__c>();
Map<Id, Id> oliIdvsconsultantIdMap = new Map<Id, Id>();
List<Order_line_item__c> oliListToUpdate = new List<Order_line_item__c>();
List<CS_Attribution_POE__c> csAttributeList = new List<CS_Attribution_POE__c>();
List<CS_Attribution_POE__c> csAttributeListToUpdate = new List<CS_Attribution_POE__c>();
Set<Id> createdByUserIds = new set<Id>();
for(Order_line_item__c oli : [Select id, ordexp_suboption_amount__c, Total_surcharge__c, ordexp_city_surcharge_amount__c, HSS_Amount__c, ordexp_TAD_Order__c, CreatedBy.Id, LastModifiedBy.Id from Order_line_item__c where Id IN : newOLIRecords]){
Decimal oldAmount = (oldOLIMap.get(oli.Id).ordexp_city_surcharge_amount__c + oldOLIMap.get(oli.Id).ordexp_suboption_amount__c + oldOLIMap.get(oli.Id).Total_surcharge__c + oldOLIMap.get(oli.Id).HSS_Amount__c);
Decimal newAmount = (newOLIMap.get(oli.Id).ordexp_city_surcharge_amount__c + newOLIMap.get(oli.Id).ordexp_suboption_amount__c + newOLIMap.get(oli.Id).Total_surcharge__c + newOLIMap.get(oli.Id).HSS_Amount__c);
if(newAmount != oldAmount && newAmount > oldAmount ){
oli.OLI_Status__c = 'On Hold';
oliListToUpdate.add(oli);
}	
oliIdVsOliMap.put(oli.Id, oli);
createdByUserIds.add(oli.LastModifiedById);
oliIdvsconsultantIdMap.put(oli.Id, oli.LastModifiedById);
}
system.debug('oliIdvsconsultantIdMap '+oliIdvsconsultantIdMap);

for(CS_Attribution_POE__c attribute : [Select Id, cs_OLI__c, User__c, cs_Sale_Amount__c from CS_Attribution_POE__c where cs_OLI__c IN :oliIdVsOliMap.keySet() AND cs_status__c != 'Cancelled' ]){
Decimal oldAmount = (oldOLIMap.get(attribute.cs_OLI__c).ordexp_city_surcharge_amount__c + oldOLIMap.get(attribute.cs_OLI__c).ordexp_suboption_amount__c + oldOLIMap.get(attribute.cs_OLI__c).Total_surcharge__c + oldOLIMap.get(attribute.cs_OLI__c).HSS_Amount__c);
Decimal newAmount = (oliIdVsOliMap.get(attribute.cs_OLI__c).ordexp_suboption_amount__c + oliIdVsOliMap.get(attribute.cs_OLI__c).Total_surcharge__c + oliIdVsOliMap.get(attribute.cs_OLI__c).ordexp_city_surcharge_amount__c + oliIdVsOliMap.get(attribute.cs_OLI__c).HSS_Amount__c);
system.debug('oldAmount '+oldAmount +' & newAmount '+newAmount);
if(oliIdVsOliMap.get(attribute.cs_OLI__c).LastModifiedById == attribute.User__c ){
if(oliIdvsconsultantIdMap.containskey(attribute.cs_OLI__c)){
oliIdvsconsultantIdMap.remove(attribute.cs_OLI__c);
}

attribute.cs_Sale_Amount__c =  (newAmount > oldAmount ) ? attribute.cs_Sale_Amount__c + (newAmount - oldAmount) : calculatefinalSaleAmount(newAmount , oldAmount, attribute.cs_Sale_Amount__c ) ;
attribute.cs_status__c = (newAmount > oldAmount ) ? 'On Hold': 'Sold';
system.debug('attribute '+attribute);


}else{
if((oliIdVsOliMap.get(attribute.cs_OLI__c).ordexp_suboption_amount__c + oliIdVsOliMap.get(attribute.cs_OLI__c).Total_surcharge__c + oliIdVsOliMap.get(attribute.cs_OLI__c).ordexp_city_surcharge_amount__c) < (oldOLIMap.get(attribute.cs_OLI__c).ordexp_city_surcharge_amount__c + oldOLIMap.get(attribute.cs_OLI__c).ordexp_suboption_amount__c + oldOLIMap.get(attribute.cs_OLI__c).Total_surcharge__c + oldOLIMap.get(attribute.cs_OLI__c).HSS_Amount__c)){
attribute.cs_Sale_Amount__c =  calculatefinalSaleAmount(newAmount , oldAmount, attribute.cs_Sale_Amount__c );

system.debug('attribute '+attribute);

}

}
csAttributeListToUpdate.add(attribute);




}
if(!oliIdvsconsultantIdMap.isEmpty()){
for(Id oliId : oliIdvsconsultantIdMap.keySet()){
CS_Attribution_POE__c cs = new CS_Attribution_POE__c();

Decimal saleAmountOfOli = oliIdVsOliMap.get(oliId).ordexp_suboption_amount__c +oliIdVsOliMap.get(oliId).Total_surcharge__c + oliIdVsOliMap.get(oliId).ordexp_city_surcharge_amount__c + oliIdVsOliMap.get(oliId).HSS_Amount__c;
Decimal OriginalSaleAmountOfOli = oldOLIMap.get(oliId).ordexp_suboption_amount__c + oldOLIMap.get(oliId).Total_surcharge__c + oldOLIMap.get(oliId).ordexp_city_surcharge_amount__c + oldOLIMap.get(oliId).HSS_Amount__c;
cs.cs_Sale_Amount__c = saleAmountOfOli != null && (saleAmountOfOli - OriginalSaleAmountOfOli ) > 0 ? (saleAmountOfOli - OriginalSaleAmountOfOli ) : 0.00;
cs.cs_Attribution_Type__c = 'OLI';
cs.TAD_Order__c = oliIdVsOliMap.get(oliId).ordexp_TAD_Order__c;
cs.User__c = oliIdVsOliMap.get(oliId).LastModifiedById;
cs.cs_status__c = 'On Hold';
//cs.Name = addOn.ordexp_AddOn_Name__c;
cs.cs_OLI__c = oliId;

csAttributeList.add(cs);
}
}
Savepoint sp = Database.setSavepoint();

try{
if(!csAttributeList.isEmpty()){
system.debug('csAttributeList '+csAttributeList);
insert csAttributeList;
}
if(!csAttributeListToUpdate.isEmpty()){
system.debug('csAttributeListToUpdate '+csAttributeListToUpdate);
update csAttributeListToUpdate;
}
if(!oliListToUpdate.isEmpty()){
update oliListToUpdate;
}

}catch(exception ex){
Database.RollBack(sp);
}

}

public static void cancellationAttribution(List<Order_line_item__c> newOLIRecords){
Set<Id> createdByUserIds = new set<Id>();
Map<Id,Set<Id>> oliMapvsCancelledConsultant = new  Map<Id,Set<Id>>();
List<CS_Attribution_POE__c> attributeList = new List<CS_Attribution_POE__c>();
Map<Id,Set<Id>> OliMapvsSoldConsultant = new  Map<Id,Set<Id>>();


for(CS_Attribution_POE__c attribute : [Select Id, cs_OLI__c, User__c, cs_status__c from CS_Attribution_POE__c where cs_OLI__c IN : newOLIRecords AND cs_status__c = 'Cancelled' AND cs_Attribution_Type__c = 'OLI']){
if(!oliMapvsCancelledConsultant.containskey(attribute.cs_OLI__c)){
oliMapvsCancelledConsultant.put(attribute.cs_OLI__c, new Set<Id>{attribute.User__c} );    
}else{
Set<Id> attrIds = oliMapvsCancelledConsultant.get(attribute.cs_OLI__c);
attrIds.add(attribute.User__c);
oliMapvsCancelledConsultant.put(attribute.cs_OLI__c, attrIds ); 
}

}
for(CS_Attribution_POE__c attribute : [Select Id, User__c, cs_OLI__c, cs_OLI__r.Cancellation_Amount__c, TAD_Order__c, cs_Sale_Amount__c, cs_OLI__r.ordexp_suboption_amount__c, cs_OLI__r.Total_surcharge__c, cs_OLI__r.ordexp_city_surcharge_amount__c, cs_OLI__r.HSS_Amount__c, cs_status__c from CS_Attribution_POE__c where cs_OLI__c IN : newOLIRecords AND cs_Attribution_Type__c = 'OLI' AND  cs_status__c = 'Sold']){

Decimal saleOliAmount = attribute.cs_OLI__r.ordexp_suboption_amount__c +  attribute.cs_OLI__r.Total_surcharge__c +  attribute.cs_OLI__r.ordexp_city_surcharge_amount__c +   attribute.cs_OLI__r.HSS_Amount__c; 
if(!OliMapvsSoldConsultant.containskey(attribute.cs_OLI__c)){
OliMapvsSoldConsultant.put(attribute.cs_OLI__c, new Set<Id>{attribute.User__c} );    
}else{
Set<Id> attrIds = OliMapvsSoldConsultant.get(attribute.cs_OLI__c);
attrIds.add(attribute.User__c);
OliMapvsSoldConsultant.put(attribute.cs_OLI__c, attrIds ); 
}
if(oliMapvsCancelledConsultant.get(attribute.cs_OLI__c) == null || !oliMapvsCancelledConsultant.get(attribute.cs_OLI__c).contains(attribute.User__c) ){

system.debug('attribute cancelled '+attribute);
system.debug('attribute amount cancelled '+attribute.cs_OLI__r.Cancellation_Amount__c );
system.debug('attribute amount sale '+attribute.cs_Sale_Amount__c );
CS_Attribution_POE__c newAttr = new CS_Attribution_POE__c();
newAttr.cs_status__c = 'Cancelled';
newAttr.User__c = attribute.User__c;

newAttr.cs_original_sale_amount__c = saleOliAmount;
newAttr.cs_cancelled_amount__c = attribute.cs_OLI__r.Cancellation_Amount__c > 0.00 ? attribute.cs_OLI__r.Cancellation_Amount__c : 0.00 ;
Decimal cancelledamount = ( ( attribute.cs_OLI__r.Cancellation_Amount__c / saleOliAmount)*100) / 100;
system.debug('cancelledamount' +cancelledamount);
newAttr.cs_Sale_Amount__c =  attribute.cs_OLI__r.Cancellation_Amount__c > 0.00  ? attribute.cs_Sale_Amount__c * cancelledamount  : 0.00; 
newAttr.CS_Attribution__c = attribute.Id;
newAttr.cs_OLI__c = attribute.cs_OLI__c;
newAttr.cs_Attribution_Type__c = 'OLI';
newAttr.TAD_Order__c = attribute.TAD_Order__c;
attributeList.add(newAttr);


}
}
for(Order_line_item__c oli : [Select id, ordexp_suboption_amount__c, Total_surcharge__c, ordexp_city_surcharge_amount__c, HSS_Amount__c, ordexp_TAD_Order__c, CreatedBy.Id, LastModifiedBy.Id from Order_line_item__c where Id IN : newOLIRecords]){
if(OliMapvsSoldConsultant.get(oli.Id) == null || !OliMapvsSoldConsultant.get(oli.Id).contains(oli.LastModifiedById)){

CS_Attribution_POE__c cs = new CS_Attribution_POE__c();

cs.cs_Sale_Amount__c =  0.00;
cs.cs_Attribution_Type__c = 'OLI';
cs.TAD_Order__c = oli.ordexp_TAD_Order__c;
cs.User__c = oli.LastModifiedById;
cs.cs_status__c = 'Sold';
//cs.Name = addOn.ordexp_AddOn_Name__c;
cs.cs_OLI__c = oli.Id;
//cs.cs_Order_Customisation__c = addOn.Customisation__c != null?  addOn.Customisation__c : null;
attributeList.add(cs);

CS_Attribution_POE__c cancelledCs = new CS_Attribution_POE__c();
//  cancelledCs.cs_AddOn__c = addOn.Id;
cancelledCs.cs_Sale_Amount__c =  0.00;
cancelledCs.cs_Attribution_Type__c = 'OLI';
cancelledCs.TAD_Order__c = oli.ordexp_TAD_Order__c;
cancelledCs.User__c = oli.LastModifiedById;
cancelledCs.cs_status__c = 'Cancelled';
//cs.Name = addOn.ordexp_AddOn_Name__c;
cancelledCs.cs_OLI__c = oli.Id;
//cancelledCs.cs_Order_Customisation__c = addOn.Customisation__c != null?  addOn.Customisation__c : null;
attributeList.add(cancelledCs);

}
system.debug('attributeList '+attributeList);
// Savepoint sp = Database.setSavepoint();
try{
if(!attributeList.isEmpty()){
insert attributeList;
}

}catch(exception ex ){
system.debug('ex exception '+ex);
// Database.RollBack(sp);
}
}

}
*/ 
    private static Decimal calculatefinalSaleAmount(Decimal newAmount, Decimal oldAmount, Decimal consultantSaleAmount){
        system.debug('newAmount '+newAmount+'& oldAmount '+oldAmount+'& consultantSaleAmount '+consultantSaleAmount);
        Decimal percentamount = newAmount/oldAmount;
        
        system.debug('differenceAmount '+(oldAmount-newAmount));
        Decimal consultantSaleAmountNew = (consultantSaleAmount*percentamount);
        
        return consultantSaleAmountNew;
    }
    
    public static void createUpdateAllocationForOrder(List<Order_line_item__c> newOliList , Map<Id,Order_line_item__c> oldOliMap,Map<Id,Order_line_item__c> newOliMap,String instance){
        
        
        if(instance=='Update'){
            List<Order_Night_POE__c> orderNight = [Select id  from Order_Night_POE__c where Order_Line_Item__c  IN:newOliList];
            delete orderNight;
        }
        
        Set<ID> dealSet = new Set<ID>();
        Set<ID> optionSet = new Set<ID>();
        Set<ID> subOptionONset = new Set<ID>();
        
        for(Order_line_item__c o : newOliList){
            if(o.Deal__c!=null){
                dealSet.add(o.Deal__c);
            }
            if(o.ordexp_Options__c!=null){
                optionSet.add(o.ordexp_Options__c);
            }
            if(o.Sub_Options__c!=null){
                subOptionONset.add(o.Sub_Options__c);
            }
        }
        
        List<Order_line_item__c> oliRequiredData = [Select id ,isSplit__c,Tad_Order_Status__c,Initial_HSS_Amount__c,Initial_HSS_NZ_Amount__c,Pricing_Model__c,OLI_Status__c,ordexp_TAD_Order__r.Converted_from_Legacy__c,PAX_Quantity__c ,Quantity__c ,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_master_status__c,ordexp_Options__c,ordexp_TAD_Order__r.RecordType.Name,ordexp_TAD_Order__r.ordexp_departure_date__c,ordexp_TAD_Order__r.ordexp_departure_date__r.Allocation_Table__c,
                                                    ordexp_TAD_Order__r.ordexp_departure_date__r.Allocation_Table__r.Remaining__c,ordexp_Options__r.NIghts__c,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,Sub_Options__c,ordexp_departure_date__r.Allocation_Table__c,
                                                    Deal__c,Deal__r.Allocation_by__c,Deal__r.Allocation_By_NZ__c,Deal__r.per_night_allocation__c,ordexp_TAD_Order__r.ordexp_deal_type__c,Sub_Options__r.Adult__c,Deal__r.RecordType.Name,ordexp_TAD_Order__r.sm_Start_Date__c,ordexp_TAD_Order__r.sm_End_Date__c,ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c from Order_line_item__c where ID IN: newOliMap.keyset()]  ;
        
        
        Set<Date> dateInfo = new Set<Date>();
        for(Order_line_item__c olRec : oliRequiredData){
            if(olRec.Deal__r.per_night_allocation__c==true){
                Date startDate = null;
                Integer Nights = 0;
                //if(olRec.Deal__r.RecordType.Name == 'Hotel'){
                //    startDate=olRec.ordexp_TAD_Order__r.sm_Start_Date__c;
                //    Nights=startDate.daysBetween(olRec.ordexp_TAD_Order__r.sm_End_Date__c);
                //  }else{
                startDate = olRec.ordexp_departure_date__r.date__c;   
                Nights = Integer.valueOf(olRec.ordexp_Options__r.NIghts__c);  
                //  }
                for (Integer a = 0 ; a < Nights ; a++) {
                    Date day = startDate.addDays(a);
                    dateInfo.add(day);
                } 
            }else{
                dateInfo.add(olRec.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c);
            }
        }
        System.debug('dateInfo'+dateInfo);
        Map<Id,Map<Date,departures_dates__c>> ddOptionDatesMap = new Map<Id,Map<Date,departures_dates__c>>();
        
        if(!dateInfo.isEmpty()){
            system.debug('This is 1...');
            
            List<departures_dates__c> ddDatesON = new List<departures_dates__c>();
            if(System.label.Online_Dates_Allocation =='true'){
                ddDatesON = [Select id ,fee_application__c,HSS_Cost_Currency__c,HSS__c ,HSS_amount__c,HSS_nz__c,HSS_amount_nz__c , Allocation_Table__c ,Allocation_Table__r.Remaining__c, options__c,sub_options__c,Deal__c,date__c from departures_dates__c where (options__c IN: optionSet OR sub_options__c IN: subOptionONset OR Deal__c IN:dealSet)  AND (online_status__c ='Online' OR online_status__c ='Hidden') and date__c IN:dateInfo ORDER BY date__c  ASC ];
            }else{
                ddDatesON = [Select id ,fee_application__c,HSS_Cost_Currency__c,HSS__c ,HSS_amount__c,HSS_nz__c,HSS_amount_nz__c , Allocation_Table__c ,Allocation_Table__r.Remaining__c, options__c,sub_options__c,Deal__c,date__c from departures_dates__c where (options__c IN: optionSet OR sub_options__c IN: subOptionONset OR Deal__c IN:dealSet)  AND  date__c IN:dateInfo ORDER BY date__c  ASC ];
            }
            
            for(departures_dates__c dd1 : ddDatesON){
                
                if(dd1.Deal__c!=null){
                    Map<Date,departures_dates__c> ddMap1 = new Map<Date,departures_dates__c>();
                    for(departures_dates__c dd2 : ddDatesON) {
                        if(dd1.Deal__c== dd2.Deal__c){
                            ddMap1.put (dd2.date__c,dd2);  
                        }
                    } 
                    ddOptionDatesMap.put(dd1.Deal__c,ddMap1);   
                } 
                
                if(dd1.options__c!=null){
                    Map<Date,departures_dates__c> ddMap1 = new Map<Date,departures_dates__c>();
                    for(departures_dates__c dd2 : ddDatesON) {
                        if(dd1.options__c== dd2.options__c){
                            ddMap1.put (dd2.date__c,dd2);  
                        }
                    } 
                    ddOptionDatesMap.put(dd1.options__c,ddMap1);   
                } 
                
                if(dd1.sub_options__c!=null){
                    Map<Date,departures_dates__c> ddMap1 = new Map<Date,departures_dates__c>();
                    for(departures_dates__c dd2 : ddDatesON) {
                        if(dd1.sub_options__c== dd2.sub_options__c){
                            ddMap1.put (dd2.date__c,dd2);  
                        }
                    } 
                    ddOptionDatesMap.put(dd1.sub_options__c,ddMap1);   
                } 
            }     
            
        }   
        
        system.debug('ddOptionDatesMap APRIL'+ddOptionDatesMap);
        
        List<Order_Night_POE__c> OrderNightsInsert = new  List<Order_Night_POE__c>();  
        system.debug('oliRequiredData'+oliRequiredData);
        for(Order_line_item__c ol : oliRequiredData){
            
            Boolean TADTC = ol.ordexp_TAD_Order__r.RecordType.Name=='TAD' || ol.ordexp_TAD_Order__r.RecordType.Name=='TC' ;
            Decimal paxQty = Integer.valueOf(ol.Quantity__c);
            
            if(ol.Deal__r.per_night_allocation__c==false){
                
                if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Deal'){
                    Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                    OrderNights.departures_dates__c= ol.ordexp_TAD_Order__r.ordexp_departure_date__c;
                    OrderNights.Allocation__c=ol.ordexp_TAD_Order__r.ordexp_departure_date__r.Allocation_Table__c;
                    OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;
                    OrderNights.Order_Line_Item__c=ol.Id;
                    if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                        OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                    }
                    
                    // Calculate HSS
                    if(ddOptionDatesMap.get(ol.Deal__c) != null){
                        departures_dates__c ddRec = ddOptionDatesMap.get(ol.Deal__c).get(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c);
                        if(ddRec.HSS__c ==true && TADTC==true){
                            //PSAG - 251 Start
                            if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                            }else{
                               OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                            }
                        	//PSAG - 251 Stop
                             
                        }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                            //PSAG - 251 Start
                            if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                            }else{
                               OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                            }
                        	//PSAG - 251 Stop
                        }
                    }
                    
                    // Is solo check
                    if(ol.Pricing_Model__c=='Solo'){
                        OrderNights.Is_Solo__c=true;   
                    }
                    
                    OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                    OrderNights.evening_date__c=ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;
                    if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                        OrderNights.status__c='Hold';  
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                        OrderNights.status__c='Secured'; 
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                        OrderNights.status__c='Active'; 
                    }
                    if(ol.Tad_Order_Status__c == 'Quote' ){
                        OrderNights.status__c='Delete'; 
                    }
                    OrderNightsInsert.add(OrderNights);
                }
                
                else if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Option'){
                    Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                    OrderNights.departures_dates__c= ol.ordexp_TAD_Order__r.ordexp_departure_date__c;
                    OrderNights.Allocation__c=ol.ordexp_TAD_Order__r.ordexp_departure_date__r.Allocation_Table__c;
                    OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;   
                    OrderNights.Order_Line_Item__c=ol.id;
                    if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                        OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                    }
                    
                    // Calculate HSS
                    if(ddOptionDatesMap.get(ol.ordexp_Options__c) != null){//PBP-64
                        departures_dates__c ddRec = ddOptionDatesMap.get(ol.ordexp_Options__c).get(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c);
                        if(ddRec!=null){
                            if(ddRec.HSS__c ==true && TADTC==true){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                                }
                                //PSAG - 251 Stop
                                
                            }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }
                                //PSAG - 251 Stop
                            }
                        }
                    }
                    
                    // Is solo check
                    if(ol.Pricing_Model__c=='Solo'){
                        OrderNights.Is_Solo__c=true;   
                    }
                    
                    OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                    OrderNights.evening_date__c=ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;
                    if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                        OrderNights.status__c='Hold';  
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                        OrderNights.status__c='Secured'; 
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                        OrderNights.status__c='Active'; 
                    }
                    if(ol.Tad_Order_Status__c == 'Quote' ){
                        OrderNights.status__c='Delete'; 
                    }
                    
                    OrderNightsInsert.add(OrderNights);
                }
                
                else if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Sub Option'){
                    system.debug('line576 ');
                    Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                    OrderNights.departures_dates__c= ol.ordexp_departure_date__c;
                    OrderNights.Allocation__c=ol.ordexp_departure_date__r.Allocation_Table__c;
                    OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;   
                    OrderNights.Order_Line_Item__c=ol.id;
                    if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                        OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                    }
                    
                    // Calculate HSS
                    if(ddOptionDatesMap.get(ol.Sub_Options__c) != null){//PBP-64
                        departures_dates__c ddRec = ddOptionDatesMap.get(ol.Sub_Options__c).get(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c);
                        if(ddRec!=null){
                            if(ddRec.HSS__c ==true && TADTC==true){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                                }
                                //PSAG - 251 Stop
                                
                            }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }
                                //PSAG - 251 Stop
                            }
                        }
                    }
                    
                    // Is solo check
                    if(ol.Pricing_Model__c=='Solo'){
                        OrderNights.Is_Solo__c=true;   
                    }
                    
                    OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                    OrderNights.evening_date__c=ol.ordexp_departure_date__r.date__c;
                    if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                        OrderNights.status__c='Hold';  
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                        OrderNights.status__c='Secured'; 
                    }
                    if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                        OrderNights.status__c='Active'; 
                    }
                    if(ol.Tad_Order_Status__c == 'Quote' ){
                        OrderNights.status__c='Delete'; 
                    }
                    
                    OrderNightsInsert.add(OrderNights);
                }
                
            }
            
            if(ol.Deal__r.per_night_allocation__c==true){
                
                if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Deal'){
                    Date startDate = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;   
                    Integer Nights = Integer.valueOf(ol.ordexp_Options__r.NIghts__c);
                    
                    for (Integer a = 0 ; a < Nights ; a++) {
                        Date day = startDate.addDays(a);
                        if(ddOptionDatesMap.get(ol.deal__c).get(day)!=null){
                            Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                            OrderNights.departures_dates__c= ddOptionDatesMap.get(ol.Deal__c).get(day).id;
                            OrderNights.Allocation__c=ddOptionDatesMap.get(ol.Deal__c).get(day).Allocation_Table__c;
                            OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;
                            if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                                OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                            }
                            
                            
                            if(ddOptionDatesMap.get(ol.Deal__c) != null){//PBP-64
                                departures_dates__c ddRec = ddOptionDatesMap.get(ol.Deal__c).get(day);
                                if(ddRec!=null){
                                    if(ddRec.HSS__c ==true && TADTC==true){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                                }
                                //PSAG - 251 Stop
                                
                            }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                                //PSAG - 251 Start
                                if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                    OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }else{
                                    OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                }
                                //PSAG - 251 Stop
                            }
                                }
                            }
                            
                            // Is solo check
                            if(ol.Pricing_Model__c=='Solo'){
                                OrderNights.Is_Solo__c=true;   
                            }
                            
                            OrderNights.Order_Line_Item__c=ol.id;   
                            OrderNights.evening_date__c=day;
                            OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                            if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                                OrderNights.status__c='Hold';  
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                                OrderNights.status__c='Secured'; 
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                                OrderNights.status__c='Active'; 
                            }
                            if(ol.Tad_Order_Status__c == 'Quote' ){
                                OrderNights.status__c='Delete'; 
                            }
                            
                            OrderNightsInsert.add(OrderNights);
                        }
                        else{
                            newOliMap.get(ol.id).addError('Requested Allocation Day is not Available');  
                        } 
                    }
                }
                if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Option'){
                    Date startDate = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;   
                    Integer Nights = Integer.valueOf(ol.ordexp_Options__r.NIghts__c);
                    
                    for (Integer a = 0 ; a < Nights ; a++) {
                        Date day = startDate.addDays(a);
                        if(ddOptionDatesMap.get(ol.ordexp_Options__c).get(day)!=null){
                            Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                            OrderNights.departures_dates__c= ddOptionDatesMap.get(ol.ordexp_Options__c).get(day).id;
                            OrderNights.Allocation__c=ddOptionDatesMap.get(ol.ordexp_Options__c).get(day).Allocation_Table__c;
                            OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;
                            if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                                OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                            }
                            
                            if(ddOptionDatesMap.get(ol.ordexp_Options__c) != null){//PBP-64
                                departures_dates__c ddRec = ddOptionDatesMap.get(ol.ordexp_Options__c).get(day);
                                if(ddRec!=null){
                                    if(ddRec.HSS__c ==true && TADTC==true){
                                        //PSAG - 251 Start
                                        if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                            OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }else{
                                            OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                                        }
                                        //PSAG - 251 Stop
                                        
                                    }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                                        //PSAG - 251 Start
                                        if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                            OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }else{
                                            OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }
                                        //PSAG - 251 Stop
                                    }
                                }
                            }
                            
                            // Is solo check
                            if(ol.Pricing_Model__c=='Solo'){
                                OrderNights.Is_Solo__c=true;   
                            }
                            
                            OrderNights.Order_Line_Item__c=ol.id;   
                            OrderNights.evening_date__c=day;
                            OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                            if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                                OrderNights.status__c='Hold';  
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                                OrderNights.status__c='Secured'; 
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                                OrderNights.status__c='Active'; 
                            }
                            if(ol.Tad_Order_Status__c == 'Quote' ){
                                OrderNights.status__c='Delete'; 
                            }
                            
                            OrderNightsInsert.add(OrderNights);
                        }
                        else{
                            newOliMap.get(ol.id).addError('Requested Allocation Day is not Available');  
                        } 
                    }  
                }
                if((TADTC==true?ol.Deal__r.Allocation_by__c:ol.Deal__r.Allocation_By_NZ__c)=='Sub Option'){
                    
                    Date startDate = null;
                    Integer Nights = 0;
                    //if(ol.Deal__r.RecordType.Name == 'Hotel'){
                    //    startDate=ol.ordexp_TAD_Order__r.sm_Start_Date__c;
                    //    Nights=startDate.daysBetween(ol.ordexp_TAD_Order__r.sm_End_Date__c);
                    // }else{
                    startDate = ol.ordexp_departure_date__r.date__c;   
                    Nights = Integer.valueOf(ol.ordexp_Options__r.NIghts__c);  
                    //  }
                    
                    for (Integer a = 0 ; a < Nights ; a++) {
                        Date day = startDate.addDays(a);
                        
                        if(ddOptionDatesMap.get(ol.Sub_Options__c).get(day)!=null){
                            
                            Order_Night_POE__c OrderNights = new  Order_Night_POE__c();
                            OrderNights.departures_dates__c= ddOptionDatesMap.get(ol.Sub_Options__c).get(day).id;
                            OrderNights.Allocation__c=ddOptionDatesMap.get(ol.Sub_Options__c).get(day).Allocation_Table__c;
                            OrderNights.TAD_Order__c=ol.ordexp_TAD_Order__c;
                            if(ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != null || ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c != ''){
                                OrderNights.CurrencyIsoCode = ol.ordexp_TAD_Order__r.ordexp_departure_date__r.HSS_Cost_Currency__c;
                            }
                            
                            if(ddOptionDatesMap.get(ol.Sub_Options__c) != null){//PBP-64
                                departures_dates__c ddRec = ddOptionDatesMap.get(ol.Sub_Options__c).get(day);
                                if(ddRec!=null){
                                    if(ddRec.HSS__c ==true && TADTC==true){
                                        //PSAG - 251 Start
                                        if(ddRec.HSS_amount__c != ol.Initial_HSS_Amount__c && ol.Initial_HSS_Amount__c != Null && ol.isSplit__c == True){
                                            OrderNights.HSS__c = ol.Initial_HSS_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }else{
                                            OrderNights.HSS__c = ddRec.HSS_amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c));  
                                        }
                                        //PSAG - 251 Stop
                                        
                                    }else if(ddRec.HSS_nz__c  ==true && TADTC==false){
                                        //PSAG - 251 Start
                                        if(ddRec.HSS_amount_nz__c != ol.Initial_HSS_NZ_Amount__c && ol.Initial_HSS_NZ_Amount__c != Null && ol.isSplit__c == True){
                                            OrderNights.HSS__c = ol.Initial_HSS_NZ_Amount__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }else{
                                            OrderNights.HSS__c =ddRec.HSS_amount_nz__c * (ddRec.fee_application__c=='Per QTY'?Integer.valueOf(ol.Quantity__c):Integer.valueOf(ol.PAX_Quantity__c)); 
                                        }
                                        //PSAG - 251 Stop
                                    }
                                }
                            }
                            
                            // Is solo check
                            if(ol.Pricing_Model__c=='Solo'){
                                OrderNights.Is_Solo__c=true;   
                            }
                            
                            OrderNights.Order_Line_Item__c=ol.id; 
                            OrderNights.order_quantity__c=Integer.valueOf(ol.Quantity__c);
                            OrderNights.evening_date__c=day;
                            if(ol.OLI_Status__c==TAD_Constants.OLIONHOLD){
                                OrderNights.status__c='Hold';  
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLISECURED){
                                OrderNights.status__c='Secured'; 
                            }
                            if(ol.OLI_Status__c==TAD_Constants.OLIACTIVE ){
                                OrderNights.status__c='Active'; 
                            }
                            if(ol.Tad_Order_Status__c == 'Quote' ){
                                OrderNights.status__c='Delete'; 
                            }
                            
                            OrderNightsInsert.add(OrderNights);
                            
                        }
                        else{
                            newOliMap.get(ol.id).addError('Requested Allocation Day is not Available');
                        } 
                    }
                }  
            }
        }
        
        if(!OrderNightsInsert.isEmpty()){
            
            insert OrderNightsInsert;
            
        }
        
    }
    public static void processRelatedRecordStatus(List<Order_line_item__c> oliToProcessNew,Map<Id,Order_line_item__c> oldOLIMap){
        
        Set<id> cancelledOliRecords = new Set<id>();
        Set<id> securedOliRecords = new Set<id>();
        for(Order_line_item__c ordL : oliToProcessNew){
            if((ordL.OLI_Status__c =='Secured'  || ordL.OLI_Status__c =='Active') && oldOLIMap.get(ordL.id).OLI_Status__c != ordL.OLI_Status__c  ){
                securedOliRecords.add(ordL.id);  
            }
            if(ordL.OLI_Status__c =='Cancelled'){
                cancelledOliRecords.add(ordL.id);
            }
        }
        
        // Process Secured status
        System.debug('securedOliRecords'+securedOliRecords);
        if(!securedOliRecords.isEmpty()){
            List<Order_Night_POE__c> onToActive = [Select id,status__c,Order_Line_Item__r.OLI_Status__c from Order_Night_POE__c where Order_Line_Item__c IN:securedOliRecords ];        
            System.debug('onToActive'+onToActive);
            if(!onToActive.isEmpty()){
                for(Order_Night_POE__c ons : onToActive){
                    if(ons.Order_Line_Item__r.OLI_Status__c=='Secured'){
                        ons.status__c='Secured'; 
                    }
                    if(ons.Order_Line_Item__r.OLI_Status__c=='Active' ){
                        ons.status__c='Active'; 
                    } 
                }
                update onToActive;
            }
        }
        System.debug('securedOliRecords'+securedOliRecords);
        
        // Process Cancelled status
        if(!cancelledOliRecords.isEmpty()){
            List<Order_Night_POE__c> onToCancel = [Select id,status__c from Order_Night_POE__c where Order_Line_Item__c IN:cancelledOliRecords and status__c !='Delete' ];        
            if(!onToCancel.isEmpty()){
                for(Order_Night_POE__c ons : onToCancel){
                    ons.status__c ='Delete';
                }
                update onToCancel;
            }
            
            List<order_line_POE__c> olToCancel = [Select id, Order_Line_Item__c from order_line_POE__c where Order_Line_Item__c IN:cancelledOliRecords and Status__c!= 'Cancelled'];
            if(!olToCancel.isEmpty()){
                for(order_line_POE__c ol : olToCancel){
                    ol.Status__c='Cancelled';
                }
                update olToCancel;
            }
        }
    }
    
    //PSAG - 251 Start
    public static void handlerDepDateHSSAmount(List<Order_line_item__c> orderLineItems){
        
        Set<Id> depDatesIds = New Set<Id>();
        
        for(Order_line_item__c objOLI : orderLineItems){
            if(objOLI.isSplit__c == false){
                depDatesIds.add(objOLI.ordexp_departure_date__c);
            }
        }
        
        if(!depDatesIds.isEmpty()){
            Map<Id, departures_dates__c> getDepDates = New Map<Id,departures_dates__c>([Select Id,HSS_amount_nz__c,HSS_amount__c FROM departures_dates__c WHERE Id IN : depDatesIds]);
            for(Order_line_item__c objOLI: orderLineItems){
                if(getDepDates.get(objOLI.ordexp_departure_date__c) != Null){
                    objOLI.Initial_HSS_NZ_Amount__c = getDepDates.get(objOLI.ordexp_departure_date__c).HSS_amount_nz__c; 
                }
                if(getDepDates.get(objOLI.ordexp_departure_date__c) != Null){
                    objOLI.Initial_HSS_Amount__c = getDepDates.get(objOLI.ordexp_departure_date__c).HSS_amount__c;
                }
            } 
        }
        
    }
    //PSAG - 251 Stop
}