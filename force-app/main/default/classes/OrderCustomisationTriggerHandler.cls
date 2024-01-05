/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-28-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class OrderCustomisationTriggerHandler {
    public static Boolean runOnce = false;
  /*  public static void flightQuoteRequested(Set<ID> orderIds){
        
        List<TAD_Order__c> orderToUpdate = new List<TAD_Order__c>();
        
        for(ID updateOrder : orderIds){
            TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
            tadorder.ordexp_master_status__c = 'On Hold';
            tadorder.ordexp_sub_status__c='Flight Quote Request';
            orderToUpdate.add(tadorder);
        }  
        
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
        
    }
    public static void flightQuoteAccepted(Set<ID> orderIds){
        List<TAD_Order__c> orderToUpdate = new List<TAD_Order__c>();
        
        for(ID updateOrder : orderIds){
            TAD_Order__c tadorder = new TAD_Order__c(id=updateOrder); 
            tadorder.ordexp_master_status__c = 'On Hold';
            tadorder.ordexp_sub_status__c='Flight Quote Accepted (Customer)';
            orderToUpdate.add(tadorder);
        }
        
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
    } */

    public static void applyCreditToOC(List<Order_Customisations_POE__c> newOCList , Map<Id,Order_Customisations_POE__c> oldOCMap , Map<Id,Order_Customisations_POE__c> newOCMap){
        List<Order_Customisations_POE__c> listToBeUpdated = new List<Order_Customisations_POE__c>();
        Set<Id> ocUpdatedIds = new Set<Id>();
        for(Order_Customisations_POE__c oc : newOCList){
            system.debug('All the 3 fields '+oc.ordexp_order_amount_outstanding__c+' '+oc.Total_price__c+' '+oc.Status__c);
            if((oc.ordexp_order_amount_outstanding__c + oc.Total_price__c <=0)&& oc.Status__c =='Customer Approved'){
                Order_Customisations_POE__c oc1 = new Order_Customisations_POE__c();
                oc1.id=oc.id;
                oc1.Status__c='Accepted_and_Paid';
                listToBeUpdated.add(oc1);
                ocUpdatedIds.add(oc.id); 
            }
        }
        
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
        
        if(!ocUpdatedIds.isEmpty()){
            List<mp_Quote_Detail_POE__c > qdList = [Select id,mp_Order_Customisation__c,Quote_Approval_Status__c  from mp_Quote_Detail_POE__c where mp_Order_Customisation__c IN:ocUpdatedIds AND Quote_Approval_Status__c !='Decline'];
            for(mp_Quote_Detail_POE__c qd : qdList ){
                qd.Quote_Approval_Status__c ='Paid';
            }
            update qdList;
        }
    } 
    /*
    public static void createCsAttributionRecord(List<Order_Customisations_POE__c> OcList, Map<Id,Order_Customisations_POE__c> OcOldMap){
        
        system.debug('trigger.new---'+OcList);
        system.debug('trigger.oldmap--'+OcOldMap);
        List<CS_Attribution_POE__c> csAttListToInsert = new  List<CS_Attribution_POE__c>();
        for(Order_Customisations_POE__c ordCus: OcList){
            
            if((ordCus.Status__c!= null) && (ordCus.Status__c== 'Accepted_and_Paid') && ((OcOldMap.get(ordCus.Id).Status__c)!= 'Accepted_and_Paid')&& ((ordCus.Total_price__c == OcOldMap.get(ordCus.Id).Total_price__c))){
                
                CS_Attribution_POE__c attribution = new CS_Attribution_POE__c();
                attribution.cs_Order_Customisation__c = ordCus.Id;
                attribution.TAD_Order__c = ordCus.mp_tad_order__c;
                attribution.cs_OLI__c = ordCus.Order_Line_Item__c;
                attribution.cs_status__c = 'Sold';
                attribution.cs_Attribution_Type__c = 'Customisation';
                attribution.User__c = ordCus.CreatedById;
                attribution.cs_Sale_Amount__c = ordCus.Total_price__c;
                csAttListToInsert.add(attribution);
            }
        }
        system.debug('---csAttListToInsert---'+csAttListToInsert);
        insert csAttListToInsert; 
    }
    
    public static void amendmentForOcToCreateCsAttribution(List<Order_Customisations_POE__c> newOcList, Map<Id,Order_Customisations_POE__c> oldOcMap, Map<Id,Order_Customisations_POE__c> newOcMap){
        Map<Id, Order_Customisations_POE__c> ocIdVocMap = new Map<Id, Order_Customisations_POE__c>();
          Map<Id, Id> ocVsConsultantIdMap = new Map<Id, Id>();
         List<CS_Attribution_POE__c> csAttributeList = new List<CS_Attribution_POE__c>();
         List<CS_Attribution_POE__c> csAttributeListToUpdate = new List<CS_Attribution_POE__c>();
         Set<Id> createdByUserIds = new set<Id>();
         
         for(Order_Customisations_POE__c ordCus : [select Id,Total_price__c,mp_tad_order__c,Order_Line_Item__c,Status__c,LastModifiedById from Order_Customisations_POE__c where Id IN :newOcList ]){
             
             ocIdVocMap.put(ordCus.Id, ordCus);
             createdByUserIds.add(ordCus.LastModifiedById);
             ocVsConsultantIdMap.put(ordCus.Id, ordCus.LastModifiedById);
        
         }
         
        system.debug('ocVsConsultantIdMap '+ocVsConsultantIdMap);
     
     for(CS_Attribution_POE__c attribute : [Select Id, cs_Order_Customisation__c, User__c,cs_Sale_Amount__c,cs_status__c from CS_Attribution_POE__c where cs_Order_Customisation__c IN :ocVsConsultantIdMap.keySet() AND cs_status__c = 'Sold' ]){
           if(attribute != null && newOcMap.get(attribute.cs_Order_Customisation__c) != oldOcMap.get(attribute.cs_Order_Customisation__c) && newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c != oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c  ){
         if(attribute != null && ocIdVocMap.get(attribute.cs_Order_Customisation__c).LastModifiedById == attribute.User__c){
             
             if(ocVsConsultantIdMap.containskey(attribute.cs_Order_Customisation__c)){
                 
                 ocVsConsultantIdMap.remove(attribute.cs_Order_Customisation__c);
             }
             
                  attribute.cs_Sale_Amount__c =  newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c >= oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c ? attribute.cs_Sale_Amount__c +(newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c - oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c)  : calculatefinalSaleAmount(newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c,oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c, attribute.cs_Sale_Amount__c ) ;
                 //attribute.cs_status__c = newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c >= oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c ? 'On Hold' : 'Sold';  
                                                                                                                                                                                                                      
                                                                                                                                                                                                                      
           
         }  else {
             
             if(newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c < oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c){
                   attribute.cs_Sale_Amount__c =  calculatefinalSaleAmount(newOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c,oldOcMap.get(attribute.cs_Order_Customisation__c).Total_price__c, attribute.cs_Sale_Amount__c );
                               
         }
         }     
     
      
     }
         csAttributeListToUpdate.add(attribute);
     }
  
          if(!ocVsConsultantIdMap.isEmpty()){
             for(Id ocId : ocVsConsultantIdMap.keySet()){
                 CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
                 cs.cs_Order_Customisation__c = ocId;
                 cs.cs_Sale_Amount__c = ocIdVocMap.get(ocId).Total_price__c != null && (ocIdVocMap.get(ocId).Total_price__c - oldOcMap.get(ocId).Total_price__c ) > 0 ? (ocIdVocMap.get(ocId).Total_price__c - oldOcMap.get(ocId).Total_price__c ) : 0.00;
                 cs.cs_Attribution_Type__c = 'Customisation';
                 cs.TAD_Order__c = ocIdVocMap.get(ocId).mp_tad_order__c;
                 cs.User__c = ocIdVocMap.get(ocId).LastModifiedById;
                  cs.cs_status__c = 'Sold';
               
                 cs.cs_OLI__c = ocIdVocMap.get(ocId).Order_Line_Item__c;
           
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
             
         }catch(exception ex){
             Database.RollBack(sp);
         }
     }
     
     public static void cancellationAttribution(List<Order_Customisations_POE__c> newOcRecords){
         Set<Id> createdByUserIds = new set<Id>();
         Map<Id,Set<Id>> ocMapvsCancelledConsultant = new  Map<Id,Set<Id>>();
         List<CS_Attribution_POE__c> attributeList = new List<CS_Attribution_POE__c>();
         List<CS_Attribution_POE__c> attributeListWithNoSold = new List<CS_Attribution_POE__c>();
          List<CS_Attribution_POE__c> attributeListWithNoCancelled = new List<CS_Attribution_POE__c>();
          Map<Id,Set<Id>> OcMapvsSoldConsultant = new  Map<Id,Set<Id>>();
         
        
         for(CS_Attribution_POE__c attribute : [Select Id, cs_Order_Customisation__c, User__c, cs_status__c from CS_Attribution_POE__c where cs_Order_Customisation__c IN : newOcRecords AND cs_status__c = 'Cancelled' AND cs_Attribution_Type__c = 'Customisation']){
             if(!ocMapvsCancelledConsultant.containskey(attribute.cs_Order_Customisation__c)){
                 ocMapvsCancelledConsultant.put(attribute.cs_Order_Customisation__c, new Set<Id>{attribute.User__c} );    
             }else{
                 Set<Id> attrIds = ocMapvsCancelledConsultant.get(attribute.cs_Order_Customisation__c);
                 attrIds.add(attribute.User__c);
                 ocMapvsCancelledConsultant.put(attribute.cs_Order_Customisation__c, attrIds ); 
             }
             
         }
         for(CS_Attribution_POE__c attribute : [Select Id, User__c, cs_Order_Customisation__c, cs_Order_Customisation__r.Cancellation_Amount__c, TAD_Order__c, cs_Sale_Amount__c, cs_Order_Customisation__r.Total_price__c,  cs_status__c , cs_OLI__c from CS_Attribution_POE__c where cs_Order_Customisation__c IN : newOcRecords AND cs_Attribution_Type__c = 'Customisation' AND  cs_status__c = 'Sold']){
            
            if(!OcMapvsSoldConsultant.containskey(attribute.cs_Order_Customisation__c)){
                 OcMapvsSoldConsultant.put(attribute.cs_Order_Customisation__c, new Set<Id>{attribute.User__c} );    
             }else{
                 Set<Id> attrIds = OcMapvsSoldConsultant.get(attribute.cs_AddOn__c);
                 attrIds.add(attribute.User__c);
                 OcMapvsSoldConsultant.put(attribute.cs_Order_Customisation__c, attrIds ); 
             }
             if(ocMapvsCancelledConsultant.get(attribute.cs_Order_Customisation__c) == null || !ocMapvsCancelledConsultant.get(attribute.cs_Order_Customisation__c).contains(attribute.User__c) ){
               
                 system.debug('attribute cancelled '+attribute);
                 system.debug('attribute amount cancelled '+attribute.cs_Order_Customisation__r.Cancellation_Amount__c );
                 system.debug('attribute amount sale '+attribute.cs_Sale_Amount__c );
                 CS_Attribution_POE__c newAttr = new CS_Attribution_POE__c();
                 newAttr.cs_status__c = 'Cancelled';
                 newAttr.User__c = attribute.User__c;
                 newAttr.cs_Order_Customisation__c = attribute.cs_Order_Customisation__c;
                 newAttr.cs_original_sale_amount__c = attribute.cs_Order_Customisation__r.Total_price__c;
                 newAttr.cs_cancelled_amount__c = attribute.cs_Order_Customisation__r.Cancellation_Amount__c > 0.00 ? attribute.cs_Order_Customisation__r.Cancellation_Amount__c : 0.00 ;
                 Decimal cancelledamount = ( ( attribute.cs_Order_Customisation__r.Cancellation_Amount__c / attribute.cs_Order_Customisation__r.Total_price__c)*100) / 100;
                 system.debug('cancelledamount' +cancelledamount);
                 newAttr.cs_Sale_Amount__c =  attribute.cs_Order_Customisation__r.Cancellation_Amount__c > 0.00  ? attribute.cs_Sale_Amount__c * cancelledamount  : 0.00; 
                 newAttr.CS_Attribution__c = attribute.Id;
                 newAttr.cs_Attribution_Type__c = 'Customisation';
                 newAttr.TAD_Order__c = attribute.TAD_Order__c;
                 newAttr.cs_OLI__c = attribute.cs_OLI__c;
                 attributeList.add(newAttr);
                 
                 
             }
         }
         for(Order_Customisations_POE__c oc : [Select id,  mp_tad_order__c, Total_price__c, CreatedBy.Id, LastModifiedBy.Id, Order_Line_Item__c from Order_Customisations_POE__c where Id IN : newOcRecords]){
             if(OcMapvsSoldConsultant.get(oc.Id) == null || !OcMapvsSoldConsultant.get(oc.Id).contains(oc.LastModifiedById)){
             
                 CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
                 
                 cs.cs_Sale_Amount__c =  0.00;
                 cs.cs_Attribution_Type__c = 'Customisation';
                 cs.TAD_Order__c = oc.mp_tad_order__c;
                 cs.User__c = oc.LastModifiedById;
                 cs.cs_status__c = 'Sold';
                 cs.cs_OLI__c = oc.Order_Line_Item__c;

                 cs.cs_Order_Customisation__c = oc.Id;
                 attributeListWithNoSold.add(cs);
                           
         }
         system.debug('attributeList '+attributeList);
       
         try{
            if(!attributeList.isEmpty() ){
            system.debug('attributeList --' +attributeList);
                upsert attributeList;
                }
                if(!attributeListWithNoSold.isEmpty()){
                     system.debug('attributeListWithNoSold --' +attributeListWithNoSold);
                    insert attributeListWithNoSold;
                    
                }
                
                for(CS_Attribution_POE__c cs : attributeListWithNoSold){
                     CS_Attribution_POE__c cancelledCs = new CS_Attribution_POE__c();
                        cancelledCs.cs_AddOn__c = cs.cs_AddOn__c;
                        cancelledCs.cs_Sale_Amount__c =  cs.cs_Sale_Amount__c;
                        cancelledCs.cs_Attribution_Type__c = cs.cs_Attribution_Type__c;
                        cancelledCs.TAD_Order__c = cs.TAD_Order__c;
                        cancelledCs.User__c = cs.User__c;
                        cancelledCs.cs_status__c = 'Cancelled';
                        //cancelledCs.;
                        cancelledCs.CS_Attribution__c = cs.Id;
                        cancelledCs.cs_OLI__c = cs.cs_OLI__c;
                        cancelledCs.cs_Order_Customisation__c = cs.cs_Order_Customisation__c;
                        attributeListWithNoCancelled.add(cancelledCs);
                        
                        system.debug(' cancelledCs '+cancelledCs.User__c);
                    
                
                }
                if(!attributeListWithNoCancelled.isEmpty()){
                    system.debug('attributeListWithNoCancelled --'+attributeListWithNoCancelled);
                        insert attributeListWithNoCancelled;
                    }
            
             
         }catch(exception ex ){
             system.debug('ex exception '+ex);
             // Database.RollBack(sp);
         }
         }
         
     }
    */
    public static Decimal calculatefinalSaleAmount(Decimal newAmount, Decimal oldAmount, Decimal consultantSaleAmount){
        Decimal percentamount = newAmount/oldAmount;
        system.debug('percentamount '+percentamount);
        Decimal consultantSaleAmountNew = consultantSaleAmount != null ? (consultantSaleAmount*percentamount) : 0.00;
        return consultantSaleAmountNew;
    }
    public static void calculateCreditUsed(List<Order_Customisations_POE__c> newOcList){
        System.debug('newOcList---'+newOcList);
          Map<Id,Order_Customisations_POE__c> idVsCustomisationMap = new Map<Id,Order_Customisations_POE__c>();
        List<Order_Customisations_POE__c> ocListToUpdate = new List<Order_Customisations_POE__c>();
  
       for(Order_Customisations_POE__c ord : [Select Id, Name ,Credit_Utilized__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_amount_outstanding__c,Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c, Total_price__c,Order_Line_Item__r.ordexp_TAD_Order__c from Order_Customisations_POE__c where Id IN : newOcList ]){
           
           idVsCustomisationMap.put(ord.Id,ord);
       }
       
        for(Order_Customisations_POE__c cust : newOcList){
            
           if(idVsCustomisationMap.get(cust.Id).Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c != 0){
                System.debug('Inside for----');
                 if((idVsCustomisationMap.get(cust.Id).Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c - cust.Total_price__c) >= 0){
                System.debug('Inside If---');
                    cust.Credit_Utilized__c =  cust.Total_price__c;
                     System.debug('cust.Credit_Utilized__c ----'+cust.Credit_Utilized__c );
               
            }else{
                System.debug('Inside else----');
                 cust.Credit_Utilized__c = idVsCustomisationMap.get(cust.Id).Order_Line_Item__r.ordexp_TAD_Order__r.Total_Credit_Remaining__c;
             
            }
            }
     
        }
         
      
    } 
}