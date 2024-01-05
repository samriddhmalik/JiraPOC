public without sharing class CreateCustomFromTADOrder {
    
    public class initWrapperForCancelledAndTravelledOrders {
        
        @AuraEnabled public Map<Id, Order_line_item__c> mapOfOLIAndId {get;set;}
        @AuraEnabled public string orderMasterStatus {get;set;} 
        
    }

     public class quoteDetailWrapper{
        @AuraEnabled public Id Id {get;set;}
        @AuraEnabled public string merchantName {get;set;}
        @AuraEnabled public string requestStatus {get;set;}
        @AuraEnabled public string merchantQuoteDetails {get;set;}
        @AuraEnabled public string merchantDeclineReason {get;set;}
        @AuraEnabled public string quoteAvailableFor {get;set;}
        @AuraEnabled public decimal merchantPrice {get;set;}
        //@AuraEnabled public string merchantCurrency {get;set;}
        @AuraEnabled public String merchantCurrency {get;set;}
        @AuraEnabled public decimal tadPrice {get;set;}
        @AuraEnabled public string tadCurrency {get;set;}
        @AuraEnabled public string merchantQuoteApprovalStatus {get;set;}
        @AuraEnabled public Boolean check {get;set;}
    }
    
    public class getInitWrapper{
        
        @AuraEnabled  public string sObjectName {get;set;}
        @AuraEnabled  public List<componentDataWrapper> componentWrapList {get;set;}
        @AuraEnabled  public List<quoteDetailWrapper> quoteDetailWrapList {get;set;}
        @AuraEnabled  public String oliID {get;set;}
        @AuraEnabled  public String tadOrderId {get;set;}
        @AuraEnabled  public Boolean saveAndSend {get;set;}
        @AuraEnabled  public String RTName {get;set;}
        @AuraEnabled  public String ocType {get;set;}
        @AuraEnabled  public String orderName {get;set;}
        @AuraEnabled  public String oliName {get;set;}
        @AuraEnabled  public String consultantName {get;set;}
        @AuraEnabled  public String paxName {get;set;} 
        @AuraEnabled  public String ocStatus {get;set;} 
        @AuraEnabled  public String requestedDetails {get;set;}
        @AuraEnabled public string tadOrderCurrency {get;set;}
        @AuraEnabled  public Decimal customPrice {get;set;}
        
    }
    
    public class orderCustomisationWrapper{
        
        @AuraEnabled  public string recordTypeName {get;set;}
        @AuraEnabled  public string recordTypeID {get;set;}
        @AuraEnabled  public string orderCustomType {get;set;}
        @AuraEnabled  public string oliName {get;set;}
        @AuraEnabled  public string oliId {get;set;}
        @AuraEnabled  public string paxName {get;set;}
        @AuraEnabled  public string paxId {get;set;}
        @AuraEnabled  public string tadOrderName {get;set;}
        @AuraEnabled  public string tadOrderId {get;set;}
        @AuraEnabled  public string customConsultantName {get;set;} 
        @AuraEnabled  public string requestedDetails {get;set;}
        @AuraEnabled  public string ocStatus {get;set;}
        @AuraEnabled  public string storedComponentIds {get;set;}
        @AuraEnabled  public string noteVisibility {get;set;}
        
        
    }

    public class getAllDataWrapper{
        
        //   @AuraEnabled  public List<customer_POE__c> PaxList {get;set;}
        @AuraEnabled  public List<paxListWrapper> paxListWrapList {get;set;}
        @AuraEnabled  public List<componentDataWrapper> componentWrapList {get;set;}
        @AuraEnabled  public Order_line_item__c oliData {get;set;}
        @AuraEnabled  public String tadOrderName {get;set;}
        @AuraEnabled  public String oliName {get;set;}
        @AuraEnabled  public Decimal paxNo {get;set;}
        @AuraEnabled  public Decimal totalPriceOnOrderCustomisation {get;set;}
        @AuraEnabled  public String storedComponentIds {get;set;}
    }
    
    public class componentDataWrapper{
        @AuraEnabled  public Id id {get;set;}
        @AuraEnabled  public string MerchantName {get;set;}
        @AuraEnabled  public string componentType {get;set;}
        @AuraEnabled  public string componentTypeName {get;set;}
        @AuraEnabled  public string componentMerchantId {get;set;}
        @AuraEnabled  public string componentId {get;set;}
        
    }
    
    public class paxListWrapper{
        
        @AuraEnabled public string paxName {get;set;}
        @AuraEnabled public string paxFirstName {get;set;}
        @AuraEnabled public string paxLastName {get;set;}
        @AuraEnabled public string paxId {get;set;}
        
    }

     public class airlineData{
        
        @AuraEnabled  public string Airline {get;set;}
        @AuraEnabled  public string FlightNo {get;set;}
        @AuraEnabled  public string bookingClass {get;set;}
        @AuraEnabled  public Date dateTimeValue {get;set;}
        @AuraEnabled  public string departure {get;set;}
        @AuraEnabled  public string duration {get;set;}
        @AuraEnabled  public string extrainfo {get;set;}
        
    }
    
    public class finalDataWrapper{
        
        @AuraEnabled public string oliId {get;set;}
        @AuraEnabled public string sObjId {get;set;}
        @AuraEnabled public string recordType {get;set;}
        @AuraEnabled public List<String> paxIds {get;set;}
        @AuraEnabled public string customConsultantName {get;set;}
        @AuraEnabled public string customType {get;set;}
        @AuraEnabled public List<String> concatMerchantAndComponentDetails {get;set;}
        @AuraEnabled public String reqDetails {get;set;}
        @AuraEnabled public String btnText {get;set;}
        @AuraEnabled public String sObjName {get;set;}
        @AuraEnabled public List<String> storedComponentIds {get;set;}
        @AuraEnabled public String noteVisibility {get;set;}
        @AuraEnabled public string tadOrderName {get;set;}
        @AuraEnabled public string orderLineItemName {get;set;}
        @AuraEnabled public Integer selectedPAXQuantity {get;set;}
        @AuraEnabled public string paxNames {get;set;}
        @AuraEnabled public Map<String, List<String>> getDependentMap {get;set;}
        @AuraEnabled public initWrapperForCancelledAndTravelledOrders initWrap {get;set;}
        @AuraEnabled public List<picklistWrapper> customConsultantWrapper {get;set;}
        @AuraEnabled public List<picklistWrapper> noteVisibilityPicklistWrapper {get;set;}
        @AuraEnabled public List<paxListWrapper> passengerDataWrapper {get;set;}
        @AuraEnabled public List<componentDataWrapper> componentDataWrapper {get;set;}
       
        @AuraEnabled public String savedComponentIds {get;set;}
        @AuraEnabled public string savedPaxIds {get;set;}
        
    }
    
    public class picklistWrapper{    
        @AuraEnabled public string picklistValue {get;set;}
        @AuraEnabled public string picklistLabel {get;set;}    
    }
    
    @AuraEnabled
    public static finalDataWrapper fetchDetailsOfOrderCustomisation (String ordCusId){
        finalDataWrapper dataWrapForOrderCus = new finalDataWrapper();
        
        Order_Customisations_POE__c orderCus = [Select id, Name, mp_tad_order__c,PAX_Qty__c, Component_IDs__c, mp_tad_order__r.Name, Requested_Details__c, ordexp_PAX_IDs__c, Order_Line_Item__c, Customisation_Consultant_Name__c, Order_Line_Item__r.Name,  Order_Line_Item__r.Deal__c, Note_only_visibility__c, Record_Type__c, Type__c from Order_Customisations_POE__c where id=:ordCusId];
        
        dataWrapForOrderCus.sObjId = ordCusId;
        dataWrapForOrderCus.sObjName = TAD_Constants.orderCustomObjName;
        dataWrapForOrderCus.savedComponentIds = orderCus.Component_IDs__c;
        dataWrapForOrderCus.savedPaxIds = orderCus.ordexp_PAX_IDs__c;
        dataWrapForOrderCus.reqDetails = orderCus.Requested_Details__c;
        dataWrapForOrderCus.customType = orderCus.Type__c;
        dataWrapForOrderCus.recordType = orderCus.Record_Type__c;
        dataWrapForOrderCus.customConsultantName = orderCus.Customisation_Consultant_Name__c;
        dataWrapForOrderCus.orderLineItemName = orderCus.Order_Line_Item__r.Name;
        dataWrapForOrderCus.tadOrderName = orderCus.mp_tad_order__r.Name;
        dataWrapForOrderCus.selectedPAXQuantity = integer.valueOf(orderCus.PAX_Qty__c);
        
        List<String> assignconcatMerchantAndComponentDetails = new List<String>();
        List<String> listToStoreAllTheComponentsAfterSplitting = new List<String>();
        
        listToStoreAllTheComponentsAfterSplitting = orderCus.Component_IDs__c.split(',');
        for(Component__c comp:[Select id,Component_Type__c,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c,ordexp_Component_Short_Name__c from Component__c where id in : listToStoreAllTheComponentsAfterSplitting]){
            assignconcatMerchantAndComponentDetails.add(comp.id+';'+comp.Merchant_Name__c);
        }            
        dataWrapForOrderCus.concatMerchantAndComponentDetails = assignconcatMerchantAndComponentDetails;
        
        List<String> assignPAXIdsDetails = new List<String>();
        List<String> listToStoreAllThePAXIdsAfterSplitting = new List<String>();

        listToStoreAllThePAXIdsAfterSplitting = orderCus.ordexp_PAX_IDs__c.split(',');
        for(String str : listToStoreAllThePAXIdsAfterSplitting){
            assignPAXIdsDetails.add(str);
        }
        dataWrapForOrderCus.paxIds = assignPAXIdsDetails;
        
        if(orderCus.Note_only_visibility__c != '' || orderCus.Note_only_visibility__c != null){
            dataWrapForOrderCus.noteVisibility = orderCus.Note_only_visibility__c;
        }
        
        Order_Customisations_POE__c exampleInstance = new Order_Customisations_POE__c();
        dataWrapForOrderCus.getDependentMap = CreateCustomFromTADOrder.getDependentMap(exampleInstance,TAD_Constants.controllingField,TAD_Constants.dependentField);
        
        Schema.DescribeFieldResult fieldResult = Order_Customisations_POE__c.Customisation_Consultant_Name__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        List<picklistWrapper> picklistWrapperList1 = new List<picklistWrapper>();
        for( Schema.PicklistEntry v : values) {
                picklistWrapper customConsultantWrap = new picklistWrapper();
                customConsultantWrap.picklistValue = v.getValue();
                customConsultantWrap.picklistLabel = v.getLabel();
                picklistWrapperList1.add(customConsultantWrap);
            }
        
        dataWrapForOrderCus.customConsultantWrapper = picklistWrapperList1;
        
        Schema.DescribeFieldResult fieldResult1 = Order_Customisations_POE__c.Note_only_visibility__c.getDescribe();
        List<Schema.PicklistEntry> values1 = fieldResult1.getPicklistValues();
        List<picklistWrapper> picklistWrapperList2 = new List<picklistWrapper>();
        for( Schema.PicklistEntry v : values1) {
                picklistWrapper customConsultantWrap = new picklistWrapper();
                customConsultantWrap.picklistValue = v.getValue();
                customConsultantWrap.picklistLabel = v.getLabel();
                picklistWrapperList2.add(customConsultantWrap);
            }
        
        dataWrapForOrderCus.noteVisibilityPicklistWrapper = picklistWrapperList2;
        
        List<componentDataWrapper> componentWrapList = new List<componentDataWrapper>();
        for(Component__c comp:[Select id,Component_Type__c,ff_Stopover_Type__c ,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c,ordexp_Component_Short_Name__c from Component__c where LinkedDeal_D_O_S__c =: orderCus.Order_Line_Item__r.Deal__c]){
            
            componentDataWrapper cdw = new componentDataWrapper();
            cdw.MerchantName = comp.Merchant_Name__r.Name;
            cdw.componentType = comp.ordexp_Component_Short_Name__c;
            if(comp.Component_Type__c=='S/Over'){
               cdw.componentTypeName=comp.ff_Stopover_Type__c; 
            }else{
              cdw.componentTypeName=comp.Component_Type__c;  
            }
            cdw.componentMerchantId = comp.Merchant_Name__c;
            cdw.componentId = comp.id;
            cdw.id = comp.id;
            componentWrapList.add(cdw);
            
        }
        dataWrapForOrderCus.componentDataWrapper = componentWrapList;
        
        List<paxListWrapper> paxListWrap = new List<paxListWrapper>();
        List<customer_POE__c> listOfPAXInOLI = [Select id,first_name__c,last_name__c,Name,Order_Line_Item__c from customer_POE__c where Order_Line_Item__c=: orderCus.Order_Line_Item__c];
        system.debug('listOfPAXInOLI'+listOfPAXInOLI);        
        for(customer_POE__c pax : listOfPAXInOLI){
            
            paxListWrapper pWrap = new paxListWrapper();
            pWrap.paxName = pax.Name;
            pWrap.paxFirstName = pax.first_name__c;
            pWrap.paxLastName = pax.last_name__c;
            pWrap.paxId = pax.Id;
            
            paxListWrap.add(pWrap);
        }   
        dataWrapForOrderCus.passengerDataWrapper = paxListWrap;
        
        
        
        return dataWrapForOrderCus;
    }
    
    @AuraEnabled
    public static finalDataWrapper fetchAllTheDataForOCCreation(String recId,String orderLineItemId){
        
        system.debug('recId '+recId);
        finalDataWrapper fdw = new finalDataWrapper();
        fdw.initWrap = CreateCustomFromTADOrder.fetchOLIRec(recId);
        fdw.oliId = orderLineItemId;
        fdw.sObjName = TAD_Constants.tadOrderObjName;
        
        Order_Customisations_POE__c exampleInstance = new Order_Customisations_POE__c();
        fdw.getDependentMap = CreateCustomFromTADOrder.getDependentMap(exampleInstance,TAD_Constants.controllingField,TAD_Constants.dependentField);
        
        Schema.DescribeFieldResult fieldResult = Order_Customisations_POE__c.Customisation_Consultant_Name__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        List<picklistWrapper> picklistWrapperList1 = new List<picklistWrapper>();
        for( Schema.PicklistEntry v : values) {
                picklistWrapper customConsultantWrap = new picklistWrapper();
                customConsultantWrap.picklistValue = v.getValue();
                customConsultantWrap.picklistLabel = v.getLabel();
                picklistWrapperList1.add(customConsultantWrap);
            }
        
        fdw.customConsultantWrapper = picklistWrapperList1;
        
        Schema.DescribeFieldResult fieldResult1 = Order_Customisations_POE__c.Note_only_visibility__c.getDescribe();
        List<Schema.PicklistEntry> values1 = fieldResult1.getPicklistValues();
        List<picklistWrapper> picklistWrapperList2 = new List<picklistWrapper>();
        for( Schema.PicklistEntry v : values1) {
                picklistWrapper customConsultantWrap = new picklistWrapper();
                customConsultantWrap.picklistValue = v.getValue();
                customConsultantWrap.picklistLabel = v.getLabel();
                picklistWrapperList2.add(customConsultantWrap);
            }
        
        fdw.noteVisibilityPicklistWrapper = picklistWrapperList2;
        
        
        
        TAD_Order__c order = [Select id, Name from TAD_Order__c where id =: recId];
        fdw.tadOrderName = order.Name;
        fdw.sObjId = recId;
         
        
        List<paxListWrapper> paxListWrap = new List<paxListWrapper>();
        List<customer_POE__c> listOfPAXInOLI = [Select id,first_name__c,last_name__c,Name,Order_Line_Item__c from customer_POE__c where Order_Line_Item__c=:orderLineItemId];
        system.debug('listOfPAXInOLI'+listOfPAXInOLI);        
        for(customer_POE__c pax : listOfPAXInOLI){
            
            paxListWrapper pWrap = new paxListWrapper();
            pWrap.paxName = pax.Name;
            pWrap.paxFirstName = pax.first_name__c;
            pWrap.paxLastName = pax.last_name__c;
            pWrap.paxId = pax.Id;
            
            paxListWrap.add(pWrap);
        }
        
        fdw.passengerDataWrapper = paxListWrap; 
        
        List<Id> listOfDeals = new List<Id>();
        order_line_item__c oliData = [Select id, Name, Deal__c from order_line_item__c where id =:orderLineItemId];
        listOfDeals.add(oliData.Deal__c);
        
        fdw.orderLineItemName = oliData.Name;
        
        List<componentDataWrapper> componentWrapList = new List<componentDataWrapper>();
        
        for(Component__c comp:[Select id,Component_Type__c,ff_Stopover_Type__c,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c,ordexp_Component_Short_Name__c from Component__c where LinkedDeal_D_O_S__c in:listOfDeals]){
            
            componentDataWrapper cdw = new componentDataWrapper();
            cdw.MerchantName = comp.Merchant_Name__r.Name;
            cdw.componentType = comp.ordexp_Component_Short_Name__c;
            if(comp.Component_Type__c=='S/Over'){
               cdw.componentTypeName=comp.ff_Stopover_Type__c; 
            }else{
              cdw.componentTypeName=comp.Component_Type__c;  
            }
            cdw.componentMerchantId = comp.Merchant_Name__c;
            cdw.componentId = comp.id;
            cdw.id = comp.id;
            componentWrapList.add(cdw);
            
        }
        fdw.componentDataWrapper = componentWrapList;
        
        return fdw;
    }
    
    @AuraEnabled        
    public static initWrapperForCancelledAndTravelledOrders fetchOLIRec(String recId){
        initWrapperForCancelledAndTravelledOrders wrapInstance = new initWrapperForCancelledAndTravelledOrders();
        
        TAD_Order__c td = [Select id, ordexp_master_status__c from TAD_Order__c where id =: recId];
        wrapInstance.orderMasterStatus = td.ordexp_master_status__c;
        
        List<Order_line_item__c>  oliList = [select name,Consolidated_With_PAX__c,deal__c,Id,Departure_cities__r.Name,PAX_Qty__c,ordexp_TAD_Order__r.ordexp_flights_ticketed__c from Order_line_item__c where ordexp_TAD_Order__c  = :recId AND OLI_Status__c!='Cancelled']; 
        Map<Id,Order_line_item__c> oliMap = new  Map<Id,Order_line_item__c>(); 
        if(oliList!=null)
        {
            for(Order_line_item__c oli : oliList)
            {
                oliMap.put(oli.Id,oli);
            }
        }
        System.debug('##OLI:'+oliMap);
        if(oliMap.size()>0){
            wrapInstance.mapOfOLIAndId = oliMap;
            //  return oliMap;   
        }else{
            wrapInstance.mapOfOLIAndId = null;
            // return null;
        }
        return wrapInstance;
    }
    
    public class oliVerificationWrap {
        @AuraEnabled public Boolean toBeReturned {get;set;}
        @AuraEnabled public String oliName {get;set;}
    }
    
    @AuraEnabled
    public static oliVerificationWrap verifyThePaxInOLI(String oliId){
        
        oliVerificationWrap oliVerWrap = new oliVerificationWrap();
        
        Boolean toBeReturned;
        List<customer_POE__c> listOfPAX = [Select id from customer_POE__c where Order_Line_Item__c =: oliId];
        if(listOfPAX.size()>0){
            oliVerWrap.toBeReturned = true;
            Order_Line_Item__c oliName = [Select id,Name from Order_Line_Item__c where id =: oliId];
            oliVerWrap.oliName = oliName.Name;
        }else{
            oliVerWrap.toBeReturned = false;
        }
        
        return oliVerWrap;
        
    }    
    
    @AuraEnabled
    public static getAllDataWrapper fetchAllData (String oliId , String recId ){
        system.debug('Entered fetchPAXRec:'+oliId+recId);
        getAllDataWrapper wrap = new getAllDataWrapper();
        
        Order_line_item__c oli = [Select id,Name,ordexp_TAD_Order__r.Name,PAX_Qty__c from Order_line_item__c where id =: oliId Limit 1];
        system.debug('oli:'+oli);
        wrap.oliData=oli;
        wrap.tadOrderName = oli.ordexp_TAD_Order__r.Name;
        wrap.oliName = oli.Name;
        wrap.paxNo = oli.PAX_Qty__c; 
        
        List<paxListWrapper> paxListWrap = new List<paxListWrapper>();        
        for(customer_POE__c pax:[Select id,first_name__c,last_name__c,Name,Order_Line_Item__c from customer_POE__c where Order_Line_Item__c=:oliId]){
            
            paxListWrapper pWrap = new paxListWrapper();
            pWrap.paxName = pax.Name;
            pWrap.paxFirstName = pax.first_name__c;
            pWrap.paxLastName = pax.last_name__c;
            pWrap.paxId = pax.Id;
            
            paxListWrap.add(pWrap);
        }
        
        wrap.paxListWrapList = paxListWrap;
        system.debug('paxListWrap paxListWrap paxListWrap'+paxListWrap);
        
        // Getting componenet Data   
        List<Id> listOfDeals = new List<Id>();
        for (TAD_Order__c td: [Select id,ordexp_deal__c from TAD_Order__c where id =:recId]){
            listOfDeals.add(td.ordexp_deal__c);
        }
        
        List<componentDataWrapper> wrapList = new List<componentDataWrapper>();
        
        for(Component__c comp:[Select id,Component_Type__c,ff_Stopover_Type__c,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c,ordexp_Component_Short_Name__c from Component__c where LinkedDeal_D_O_S__c in:listOfDeals]){
            
            componentDataWrapper cdw = new componentDataWrapper();
            cdw.MerchantName = comp.Merchant_Name__r.Name;
            cdw.componentType = comp.ordexp_Component_Short_Name__c;
            if(comp.Component_Type__c=='S/Over'){
               cdw.componentTypeName=comp.ff_Stopover_Type__c; 
            }else{
              cdw.componentTypeName=comp.Component_Type__c;  
            }
            cdw.componentMerchantId = comp.Merchant_Name__c;
            cdw.componentId = comp.id;
            cdw.id = comp.id;
            wrapList.add(cdw);
            
        }
        wrap.componentWrapList=wrapList;
        
        //  Order_Customisations_POE__c oc = [Select id, Component_IDs__c from Order_Customisations_POE__c where id =: recId];
        //  wrap.storedComponentIds = oc.Component_IDs__c;
        
        return wrap;
    }
    
    
    
    
    @AuraEnabled        
    public static Map<Id, String> fetchRecordTypeValues(String objectName){
        
        List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    
        
        Map<Id, String> recordtypemap = new Map<Id, String>();
        
        for(RecordTypeInfo rt : recordtypes){
            
            if(rt.getName() != 'Master' && rt.getName().trim() != '' )
                
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
            
        }        
        system.debug('recordtypemap recordtypemap recordtypemap'+recordtypemap); 
        return recordtypemap;
        
    }
    
    public class onSaveReturnWrapper{
        
        @AuraEnabled public Boolean toBeReturnedBoolean {get;set;}
        @AuraEnabled public string recordId {get;set;}
        
    }
    
    @AuraEnabled
    public static onSaveReturnWrapper onSaveBtnClickFunc(finalDataWrapper orderCusCreationWrapper){
        
        onSaveReturnWrapper wrapperToBeReturned = new onSaveReturnWrapper();
        
        List<Order_Customisations_POE__c> listOfOrderCus = new List<Order_Customisations_POE__c>();
        Boolean proceedToNew;
        List<order_line_POE__c> listOfOrderLines = new List<order_line_POE__c>();
        List<mp_Quote_Detail_POE__c> listOfQuoteDetails = new List<mp_Quote_Detail_POE__c>();
        List<String> listToStoreComponentIds = new List<String>();
        List<String> listToStoreMerchantIds = new List<String>();
        Map<Id,order_line_POE__c> merchantAndOrderLineMap = new Map<Id,order_line_POE__c>();
        
        String[] splitting1;
        String[] splitting2;
        String[] splitting3;
         
        for(String str : orderCusCreationWrapper.concatMerchantAndComponentDetails){
            splitting3 = str.split('\\;');
            listToStoreMerchantIds.add(splitting3[1]);
            system.debug('listToStoreMerchantIds account ids--->'+listToStoreMerchantIds);
            
        }
        
        if(orderCusCreationWrapper.sObjName == TAD_Constants.tadOrderObjName){
            for(order_line_POE__c ol:[Select id,mp_merchant__c,TAD_Order__c,mp_Merchant_Acknowledgement_Status__c from order_line_POE__c where mp_merchant__c in:listToStoreMerchantIds and TAD_Order__c=: orderCusCreationWrapper.sObjId]){
                system.debug('ol Account--->'+ol.mp_merchant__c);
                merchantAndOrderLineMap.put(ol.mp_merchant__c,ol);
            } 
        }
        else if(orderCusCreationWrapper.sObjName == TAD_Constants.orderCustomObjName){
            String tadOrderId;
            Order_Customisations_POE__c oc = [Select id, mp_tad_order__c  from Order_Customisations_POE__c where id=: orderCusCreationWrapper.sObjId];
            tadOrderId = oc.mp_tad_order__c;
            for(order_line_POE__c ol:[Select id,mp_merchant__c,TAD_Order__c,mp_Merchant_Acknowledgement_Status__c from order_line_POE__c where mp_merchant__c in:listToStoreMerchantIds and TAD_Order__c=:tadOrderId]){
                merchantAndOrderLineMap.put(ol.mp_merchant__c,ol);
            }
        }
        else{
            system.debug('Things have gone absolutely nuts');
        }     
        
        
        if(orderCusCreationWrapper.sObjName == 'TAD_Order__c') {
            if(orderCusCreationWrapper.btnText == 'Save'){
                TAD_Order__c ord = [SELECT Id,currencyIsoCode, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: orderCusCreationWrapper.sObjId];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                for(String str: orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    splitting2 = str.split('\\;');
                    listToStoreComponentIds.add(splitting2[0]);
                    
                }
                system.debug('listToStoreComponentIds'+listToStoreComponentIds);
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                String resultToCompIds;
                String separator = ',';                   
                resultToCompIds = String.join(listToStoreComponentIds,separator);
                system.debug('resultToCompIds'+resultToCompIds);
                
                
                Order_Customisations_POE__c orderCus = new Order_Customisations_POE__c();
                orderCus.mp_tad_order__c = orderCusCreationWrapper.sObjId;
                orderCus.Order_Line_Item__c = orderCusCreationWrapper.oliId;
                orderCus.currencyIsoCode=ord.currencyIsoCode;
                orderCus.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                orderCus.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
             /*   if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY){
                    orderCus.Status__c = TAD_Constants.QTNOTEONLY;   
                }
                else{
                    orderCus.Status__c = TAD_Constants.orderCustomStatusQuoteReq;   
                }  */
                
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                orderCus.RecordTypeId = recTypeId;
                system.debug('recordType'+orderCusCreationWrapper.recordType+' '+recTypeId);
                
                
                
                orderCus.Component_Type__c = String.join(compTypeNameString,';');
                orderCus.Component_IDs__c = resultToCompIds;
                orderCus.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                orderCus.Type__c = orderCusCreationWrapper.customType;
                orderCus.Save_and_Send__c = false; 
                orderCus.Record_Type__c = orderCusCreationWrapper.recordType;
                orderCus.ordexp_PAX_IDs__c = '';
                orderCus.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                
                
                for(String paxId : orderCusCreationWrapper.paxIds){
                    if(orderCus.ordexp_PAX_IDs__c == '' || orderCus.ordexp_PAX_IDs__c == null){
                        orderCus.ordexp_PAX_IDs__c = paxId;
                    }else{
                        orderCus.ordexp_PAX_IDs__c = orderCus.ordexp_PAX_IDs__c + ',' +paxId;
                    }
                }
                
                
                insert orderCus;
                
                
                
              /*  List<OC_PAX_Junction__c> listOfJunctionOCPAX = new List<OC_PAX_Junction__c>();
                for (String paxId: orderCusCreationWrapper.paxIds){
                    
                    OC_PAX_Junction__c ocPax = new OC_PAX_Junction__c();
                    ocPax.ordexp_Order_Customisation__c = orderCus.Id;
                    ocPax.ordexp_Passengers__c = paxId;
                    listOfJunctionOCPAX.add(ocPax);
                }
                
                insert listOfJunctionOCPAX; */
                //-----------------------------Implementation for Notification To TripAdeal For Cruise , StopOver and Flight component Type--------------------------------------//
                
                
                
                //------------------------------------------------------------------------------------------------------------------------------------------//
                
                wrapperToBeReturned.toBeReturnedBoolean  = false;
                wrapperToBeReturned.recordId = ord.Id;
            }
            else if(orderCusCreationWrapper.btnText == 'SaveAndSend'){  
                
                TAD_Order__c ord = [SELECT Id,currencyIsoCode, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: orderCusCreationWrapper.sObjId];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                listToStoreComponentIds = new List<String>();
                
                for(String str: orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    splitting2 = str.split('\\;');
                    listToStoreComponentIds.add(splitting2[0]);
                    
                }
                
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                
                
                Order_Customisations_POE__c orderCus = new Order_Customisations_POE__c();
                orderCus.mp_tad_order__c = orderCusCreationWrapper.sObjId;
                orderCus.Order_Line_Item__c = orderCusCreationWrapper.oliId;
                orderCus.currencyIsoCode=ord.currencyIsoCode;
                orderCus.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                orderCus.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
           
                orderCus.Component_Type__c = String.join(compTypeNameString, ';');
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                orderCus.RecordTypeId = recTypeId;
                
                orderCus.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                orderCus.Type__c = orderCusCreationWrapper.customType;
                orderCus.Save_and_Send__c = true; 
                orderCus.Record_Type__c = orderCusCreationWrapper.recordType;
                orderCus.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                orderCus.Status__c = 'Quote_Requested';
                insert orderCus; 
                
                
                
                List<OC_PAX_Junction__c> listOfJunctionOCPAX = new List<OC_PAX_Junction__c>();
                for (String paxId : orderCusCreationWrapper.paxIds){
                    
                    OC_PAX_Junction__c ocPax = new OC_PAX_Junction__c();
                    ocPax.ordexp_Order_Customisation__c = orderCus.Id;
                    ocPax.ordexp_Passengers__c = paxId;
                    listOfJunctionOCPAX.add(ocPax);
                }
                
                insert listOfJunctionOCPAX;
                
                system.debug('orderCusorderCusorderCus'+listOfOrderCus);    
                
                
                wrapperToBeReturned.toBeReturnedBoolean  = false;
                wrapperToBeReturned.recordId = ord.Id;
                
                
                
                for(String str : orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    
                    String[] splitting;
                    splitting = str.split('\\;');

                      mp_Quote_Detail_POE__c qd = new mp_Quote_Detail_POE__c();
                    qd.mp_Order_Customisation__c = orderCus.Id; 
                    qd.Merchant__c = splitting[1];
                    qd.Component__c = splitting[0];
                    if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY ){
                        qd.Quote_Approval_Status__c = TAD_Constants.QTNOTEONLY; 
                        qd.Note_Only__c=true;
                    }
                    else{
                        qd.Quote_Approval_Status__c = TAD_Constants.QTPENDING;   
                    }
                    
                    
                    listOfQuoteDetails.add(qd);
                    
            
                }
                
                insert listOfQuoteDetails;
              
                
              
            }
            else if(orderCusCreationWrapper.btnText == 'SaveAndNew'){
                TAD_Order__c ord = [SELECT Id,currencyIsoCode, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: orderCusCreationWrapper.sObjId];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                
                for(String str: orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    splitting2 = str.split('\\;');
                    listToStoreComponentIds.add(splitting2[0]);
                    
                }
                String resultToCompIds;
                String separator = ',';                   
                resultToCompIds = String.join(listToStoreComponentIds,separator);
                system.debug('resultToCompIds'+resultToCompIds);
                
                
                
                Order_Customisations_POE__c orderCus = new Order_Customisations_POE__c();
                orderCus.mp_tad_order__c = orderCusCreationWrapper.sObjId;
                orderCus.Order_Line_Item__c = orderCusCreationWrapper.oliId;
                orderCus.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                orderCus.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
                
              /*  if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY ){
                    orderCus.Status__c = TAD_Constants.QTNOTEONLY;   
                }
                else{
                    orderCus.Status__c = TAD_Constants.orderCustomStatusQuoteReq;   
                }  */
                
                orderCus.Component_IDs__c = resultToCompIds;
                
                
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                orderCus.RecordTypeId = recTypeId;
                orderCus.Component_Type__c = String.join(compTypeNameString, ';');
                orderCus.currencyIsoCode=ord.currencyIsoCode;
                orderCus.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                orderCus.Type__c = orderCusCreationWrapper.customType;
                orderCus.Save_and_Send__c = false;
                orderCus.Record_Type__c = orderCusCreationWrapper.recordType;
                
                orderCus.ordexp_PAX_IDs__c = '';
                for(String paxId : orderCusCreationWrapper.paxIds){
                    if(orderCus.ordexp_PAX_IDs__c == '' || orderCus.ordexp_PAX_IDs__c == null){
                        orderCus.ordexp_PAX_IDs__c = paxId;
                    }else{
                        orderCus.ordexp_PAX_IDs__c = orderCus.ordexp_PAX_IDs__c + ',' +paxId;
                    }
                }
                orderCus.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                insert orderCus;
              
                wrapperToBeReturned.toBeReturnedBoolean  = true;
                wrapperToBeReturned.recordId = ord.Id;
            
                
            }
            
            else{
                system.debug('None of the valid buttons were clicked!');
            }
        }
        
        else if(orderCusCreationWrapper.sObjName == 'Order_Customisations_POE__c'){
            if(orderCusCreationWrapper.btnText == 'Save'){
                
                Order_Customisations_POE__c oc = [Select id,Customisation_Consultant_Name__c,RecordTypeId,Passengers__c,Type__c,mp_tad_order__c from Order_Customisations_POE__c where id =: orderCusCreationWrapper.sObjId];
                
                TAD_Order__c ord = [SELECT Id, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: oc.mp_tad_order__c];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                oc.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                oc.RecordTypeId = recTypeId;
                oc.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                
                oc.Type__c = orderCusCreationWrapper.customType;
                oc.Save_and_Send__c = false;
                oc.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
             /*   if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY){
                    oc.Status__c = TAD_Constants.QTNOTEONLY;   
                }else{
                     oc.Status__c = TAD_Constants.orderCustomStatusQuoteReq; 
                }  */
                oc.Record_Type__c = orderCusCreationWrapper.recordType;
                for(String str: orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    splitting2 = str.split('\\;');
                    listToStoreComponentIds.add(splitting2[0]);
                    
                }
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                system.debug('listToStoreComponentIds'+listToStoreComponentIds);
                String resultToCompIds;
                String separator = ',';                   
                resultToCompIds = String.join(listToStoreComponentIds,separator);
                system.debug('resultToCompIds'+resultToCompIds);
                
                
                oc.Component_IDs__c = resultToCompIds;
                oc.Component_Type__c = String.join(compTypeNameString, ';');
                oc.ordexp_PAX_IDs__c = '';
                
                for(String paxId : orderCusCreationWrapper.paxIds){
                    if(oc.ordexp_PAX_IDs__c == '' || oc.ordexp_PAX_IDs__c == null){
                        oc.ordexp_PAX_IDs__c = paxId;
                    }else{
                        oc.ordexp_PAX_IDs__c = oc.ordexp_PAX_IDs__c + ',' +paxId;
                    }
                }
                
                oc.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                
                update oc;
                
                wrapperToBeReturned.toBeReturnedBoolean  = false;
                wrapperToBeReturned.recordId = ord.Id;
            }
            
            else if(orderCusCreationWrapper.btnText == 'SaveAndSend'){
                Order_Customisations_POE__c oc = [Select id,Customisation_Consultant_Name__c,RecordTypeId,Passengers__c,Type__c,mp_tad_order__c from Order_Customisations_POE__c where id =: orderCusCreationWrapper.sObjId];
                
                TAD_Order__c ord = [SELECT Id, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: oc.mp_tad_order__c];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                system.debug('listToStoreComponentIds'+listToStoreComponentIds);
                
                oc.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                oc.RecordTypeId = recTypeId;
                oc.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                
                oc.Type__c = orderCusCreationWrapper.customType;
                oc.Save_and_Send__c = true;
                oc.Record_Type__c = orderCusCreationWrapper.recordType;
                oc.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
             /*   if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY){
                    oc.Status__c = TAD_Constants.QTNOTEONLY;   
                }else{
                    oc.Status__c = TAD_Constants.orderCustomStatusQuoteReq;
                }  */
                oc.Component_Type__c = String.join(compTypeNameString, ';');
                
                oc.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                oc.Status__c = TAD_Constants.orderCustomStatusQuoteReq;
                update oc;
                
                List<OC_PAX_Junction__c> listOfJunctionOCPAX = new List<OC_PAX_Junction__c>();
                for (String paxId : orderCusCreationWrapper.paxIds){
                    
                    OC_PAX_Junction__c ocPax = new OC_PAX_Junction__c();
                    ocPax.ordexp_Order_Customisation__c = oc.Id;
                    ocPax.ordexp_Passengers__c = paxId;
                    listOfJunctionOCPAX.add(ocPax);
                }
                
                insert listOfJunctionOCPAX;
                
                system.debug('oc oc oc'+oc);
                system.debug('orderCusCreationWrapper.concatMerchantAndComponentDetails orderCusCreationWrapper.concatMerchantAndComponentDetails'+orderCusCreationWrapper.concatMerchantAndComponentDetails);
                if(orderCusCreationWrapper.concatMerchantAndComponentDetails.size()>0){
                    
                    List<String> listOfString = new List<String>();
                    
                    for(String str : orderCusCreationWrapper.concatMerchantAndComponentDetails){
                        String[] splitting;
                        splitting = str.split('\\;');
                        listOfString.add(splitting[1]);
                        
                         mp_Quote_Detail_POE__c qd = new mp_Quote_Detail_POE__c();
                        qd.mp_Order_Customisation__c = oc.Id;
                        qd.Merchant__c = splitting[1];
                    	qd.Component__c = splitting[0];
                        
                        if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY ){
                            qd.Quote_Approval_Status__c = TAD_Constants.QTNOTEONLY;
                            qd.Note_Only__c=true;
                        }
                        else{
                            qd.Quote_Approval_Status__c = TAD_Constants.QTPENDING; 
                        }
                        
                        listOfQuoteDetails.add(qd);
                    }
                     insert listOfQuoteDetails;
                   
                   }
     
                else{
                    system.debug('Nothing can get worse than this'); 
                }
                
                system.debug('listOfOrderLineslistOfOrderLineslistOfOrderLines'+listOfOrderLines);
                system.debug('listOfQuoteDetailslistOfQuoteDetailslistOfQuoteDetails'+listOfQuoteDetails);
                
                wrapperToBeReturned.toBeReturnedBoolean  = false;
                wrapperToBeReturned.recordId = ord.Id;
                
            }
            else if(orderCusCreationWrapper.btnText == 'SaveAndNew'){
                Order_Customisations_POE__c oc = [Select id,Customisation_Consultant_Name__c,RecordTypeId,Passengers__c,Type__c,mp_tad_order__c from Order_Customisations_POE__c where id =: orderCusCreationWrapper.sObjId];
                
                TAD_Order__c ord = [SELECT Id, ordexp_flights_ticketed__c, ordexp_master_status__c, ordexp_sub_status__c from TAD_Order__c where Id =: oc.mp_tad_order__c];
                
                orderStatusCheck(ord,orderCusCreationWrapper.customType,orderCusCreationWrapper.recordType,orderCusCreationWrapper.reqDetails);       // Updates Tad Order with Correct Status
                
                oc.Customisation_Consultant_Name__c = orderCusCreationWrapper.customConsultantName;
                
                Id recTypeId = Schema.Sobjecttype.Order_Customisations_POE__c.getRecordTypeInfosByName().get(orderCusCreationWrapper.recordType).getRecordTypeId();
                oc.RecordTypeId = recTypeId;
                oc.Requested_Details__c = orderCusCreationWrapper.reqDetails;
                
                oc.Type__c = orderCusCreationWrapper.customType;
                oc.Save_and_Send__c = false;
                oc.Note_only_visibility__c  = orderCusCreationWrapper.noteVisibility;
           /*     if(orderCusCreationWrapper.noteVisibility!=null && orderCusCreationWrapper.noteVisibility!='' && orderCusCreationWrapper.recordType == TAD_Constants.QTNOTEONLY){
                    oc.Status__c = TAD_Constants.QTNOTEONLY;   
                }else{
                    oc.Status__c = TAD_Constants.orderCustomStatusQuoteReq;
                }  */
                oc.Record_Type__c = orderCusCreationWrapper.recordType;
                for(String str: orderCusCreationWrapper.concatMerchantAndComponentDetails){
                    splitting2 = str.split('\\;');
                    listToStoreComponentIds.add(splitting2[0]);
                    
                }
                List<String> compTypeNameString = new List<String>();
                for(Component__c comp : [SELECt Id, Component_Type__c from Component__c where Id IN : listToStoreComponentIds]){
                    compTypeNameString.add(comp.Component_Type__c);
                }
                system.debug('listToStoreComponentIds'+listToStoreComponentIds);
                String resultToCompIds;
                String separator = ',';                   
                resultToCompIds = String.join(listToStoreComponentIds,separator);
                system.debug('resultToCompIds'+resultToCompIds);
                
                
                oc.Component_IDs__c = resultToCompIds;
                oc.Component_Type__c = String.join(compTypeNameString, ';');
                oc.ordexp_PAX_IDs__c = '';
                
                for(String paxId : orderCusCreationWrapper.paxIds){
                    if(oc.ordexp_PAX_IDs__c == '' || oc.ordexp_PAX_IDs__c == null){
                        oc.ordexp_PAX_IDs__c = paxId;
                    }else{
                        oc.ordexp_PAX_IDs__c = oc.ordexp_PAX_IDs__c + ',' +paxId;
                    }
                }
                
                oc.PAX_Qty__c = orderCusCreationWrapper.paxIds.size();
                
                update oc;
                wrapperToBeReturned.toBeReturnedBoolean  = true;
                wrapperToBeReturned.recordId = ord.Id;
            }
            else{
                system.debug('None of the valid buttons were clicked!');
            }
            
        }   
        
        else{
            system.debug('You went wrong throughout!');
        }
        return wrapperToBeReturned;
    }
    
    
    @AuraEnabled
    public static boolean saveCustomisation(mp_Quote_Detail_POE__c qd){
        
        system.debug('qd'+qd);
        update qd;
        return true;
    }
    
    @AuraEnabled
    public static getInitWrapper idPassToCheckSObject(Id recId){
        
        Schema.SObjectType sobjectType = recId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        getInitWrapper wrap = new getInitWrapper();
        List<componentDataWrapper> cmpWrapList = new List<componentDataWrapper>();
        List<quoteDetailWrapper> qDList = new List<quoteDetailWrapper>();
        wrap.sObjectName = sobjectName;
        
        // Order Customisation Object....
        if(sobjectName == TAD_Constants.orderCustomObjName){
            Order_Customisations_POE__c oc = [Select id ,Order_Line_Item__c,PAX_Qty__c,mp_tad_order__c,Save_and_Send__c,recordType.Name,Type__c,Customisation_Consultant_Name__c,Passenger_Name__c,Order_Line_Item__r.Name,mp_tad_order__r.Name,mp_tad_order__r.CurrencyIsoCode,toLabel(Status__c),Requested_Details__c,Total_price__c from Order_Customisations_POE__c where id=: recId];
            wrap.oliID = oc.Order_Line_Item__c;
            wrap.tadOrderId = oc.mp_tad_order__c;
            wrap.saveAndSend = oc.Save_and_Send__c;
            wrap.RTName = oc.recordType.Name;
            wrap.ocType  = oc.Type__c;
            wrap.tadOrderCurrency=oc.mp_tad_order__r.CurrencyIsoCode;
            wrap.orderName  = oc.mp_tad_order__r.Name;
            wrap.oliName = oc.Order_Line_Item__r.Name;
            wrap.consultantName = oc.Customisation_Consultant_Name__c;
            
            String concatPaxNames = '';
            for(OC_PAX_Junction__c ocPaxJunc : [Select id, ordexp_Passengers__c,ordexp_Passengers__r.Passenger_Name__c,ordexp_Order_Customisation__c from OC_PAX_Junction__c where ordexp_Order_Customisation__c=: recId]){
                
                if(concatPaxNames == '')
                    concatPaxNames = ocPaxJunc.ordexp_Passengers__r.Passenger_Name__c;
                else{
                    concatPaxNames = concatPaxNames + ' | ' + ocPaxJunc.ordexp_Passengers__r.Passenger_Name__c;
                }
                
            }
            
            wrap.paxName = concatPaxNames;
            wrap.requestedDetails = oc.Requested_Details__c;
            wrap.ocStatus = oc.Status__c;
            
            
            for(mp_Quote_Detail_POE__c qd:[Select Id, mp_Order_Customisation__r.recordType.Name, Merchant__r.currencyisoCode, Merchant__c,Merchant__r.Name,Component__r.Component_Type__c,Component__r.ff_Stopover_Type__c,Component__r.Name,Merchant__r.c2g__CODAAccountTradingCurrency__c,toLabel(Quote_Approval_Status__c), mp_Order_Customisation__c,mp_Quote_Request_Status__c,mp_Merchant_Quoted_Details__c,mp_Quote_Decline_Reason__c,Available_For__c,mp_Merchant_Price__c,Merchant_Currency__c,TAD_Currency__c,TAD_Price__c,ordexp_Merchant_Quote_Approval_Status__c from mp_Quote_Detail_POE__c where mp_Order_Customisation__c=:recId]){
                
                quoteDetailWrapper qdWrapElement = new quoteDetailWrapper();
                qdWrapElement.Id = qd.Id;
                qdWrapElement.merchantName = qd.Merchant__r.Name;
                qdWrapElement.requestStatus = qd.Quote_Approval_Status__c;
                qdWrapElement.merchantQuoteDetails = qd.mp_Merchant_Quoted_Details__c;
                qdWrapElement.merchantDeclineReason = qd.mp_Quote_Decline_Reason__c;
                qdWrapElement.quoteAvailableFor = qd.Available_For__c;
                qdWrapElement.merchantPrice = qd.mp_Merchant_Price__c;
                qdWrapElement.merchantCurrency = qd.Merchant__r.currencyisoCode;
                //qdWrapElement.tadPrice =qd.TAD_Price__c;
                if(qd.mp_Order_Customisation__r.recordType.Name == 'Miscellaneous'){
                    qdWrapElement.tadPrice =qd.mp_Merchant_Price__c;                      
                }else{
                    qdWrapElement.tadPrice =qd.TAD_Price__c; 
                }
                qdWrapElement.tadCurrency = qd.TAD_Currency__c;
                qdWrapElement.merchantQuoteApprovalStatus = qd.ordexp_Merchant_Quote_Approval_Status__c;
                qdWrapElement.check = false;
                qDList.add(qdWrapElement);
                
                componentDataWrapper cdw = new componentDataWrapper();
                cdw.MerchantName  = qd.Merchant__r.Name;
                cdw.componentType = qd.Component__r.Name;
                if(qd.Component__r.Component_Type__c=='S/Over'){
                    cdw.componentTypeName=qd.Component__r.ff_Stopover_Type__c; 
                }else{
                    cdw.componentTypeName=qd.Component__r.Component_Type__c;  
                }
                cmpWrapList.add(cdw);
                
            }
            wrap.customPrice = oc.Total_price__c;
            wrap.componentWrapList = cmpWrapList;
            wrap.quoteDetailWrapList = qDList;
            system.debug('qDList'+qDList);
        }
        
        return wrap;
        
    }
    
    @AuraEnabled
    public static List<AddOn__c> getAddOnPicklist(Id OLIId) {
        System.debug('ID= -= '+OLIId);
        List<AddOn__c> addONs = [SELECT Id, AddOn_Name__c, Add_On_Type__c FROM AddOn__c WHERE Order_Line_Item__c =: OLIId AND Add_On_Type__c != null AND AddOn_Name__c != null];
        return addOns;
    }
    
   
    
    @AuraEnabled
    public static orderCustomisationWrapper fetchExistingOCData(String recId){
        orderCustomisationWrapper ocw = new orderCustomisationWrapper();
        if(recId != null){
            
            Order_Customisations_POE__c oc = [Select id,RecordType.Name,Note_only_visibility__c,Component_IDs__c ,RecordTypeId,Type__c,Order_Line_Item__c,Order_Line_Item__r.Name,Passenger_Name__c,Passengers__c,mp_tad_order__c,mp_tad_order__r.Name,Customisation_Consultant_Name__c,Requested_Details__c,Record_Type__c from Order_Customisations_POE__c where id=: recId];
            
            
            
            ocw.recordTypeName = oc.RecordType.Name;
            // ocw.recordTypeName = oc.Record_Type__c;
            ocw.recordTypeID = oc.RecordTypeId;
            ocw.orderCustomType = oc.Type__c;
            ocw.oliName = oc.Order_Line_Item__r.Name;   
            ocw.oliId = oc.Order_Line_Item__c;
            ocw.paxName = oc.Passenger_Name__c;
            ocw.paxId = oc.Passengers__c;
            ocw.tadOrderName = oc.mp_tad_order__r.Name;
            ocw.tadOrderId = oc.mp_tad_order__c;
            ocw.customConsultantName = oc.Customisation_Consultant_Name__c;
            ocw.requestedDetails = oc.Requested_Details__c;
            ocw.storedComponentIds = oc.Component_IDs__c;
            ocw.noteVisibility = oc.Note_only_visibility__c;
            
            system.debug('ocw ocw ocw'+ocw);
            
        } 
        return ocw;    
    }
    
    
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        system.debug(picklistValues);
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getLabel());
        }
        system.debug(optionlist);
        return optionlist;
        
    }
    
    
   
    
    
    
    @auraEnabled
    public static String callPNRcAPI(String pnrVal,String recId,Boolean sendMail,Decimal consolidatedAmountToBeSent, List<String> quoteDetailsIdToBeUpdated, String additionalInformation)
    {
        
        PNR_Converter__mdt pnrMdt = [select ENDPOINT__c,PRIVATE_KEY__c,PUBLIC_KEY__c  from PNR_Converter__mdt where MasterLabel =:TAD_Constants.TAD];
        String toBeReturned;
        
        if(pnrMdt!=null)
        {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            
            req.setEndpoint(pnrMdt.ENDPOINT__c);
            req.setMethod('POST');
            req.setHeader('PUBLIC_APP_KEY', pnrMdt.PUBLIC_KEY__c);
            req.setHeader('PRIVATE_APP_KEY', pnrMdt.PRIVATE_KEY__c);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String payload = 'pnr='+EncodingUtil.urlEncode(pnrVal,'UTF-8');
            
            req.setBody(payload);
            //req.setCompressed(true); // otherwise we hit a limit of 32000
            
            try {
                res = http.send(req);
                if (res.getStatusCode() == 200) {
                    system.debug('res:'+res.getBody());
                    String repString = res.getBody().replace('"string"','"string_x"');
                    repString = repString.replace('"class"', '"class_x"');
                    repString = repString.replace('"name"', '"name_x"');
                    repString = repString.replace('"png-logo-low-res"', '"png"');
                    repString = repString.replace('"svg-logo-high-res"', '"svg"');
                    
                    system.debug('##:'+repString);
                    
                    PNRConverterJSONResponse pnrcResp = PNRConverterJSONResponse.parse(repString);
                    system.debug('pnrcResppnrcResppnrcResppnrcResp'+pnrcResp);
                    if(sendMail == true){
                        CreateCustomFromTADOrder.sendQuoteEmail(pnrcResp,recId,true,consolidatedAmountToBeSent,additionalInformation);
                        
                        toBeReturned = null;
                        
                        List<mp_Quote_Detail_POE__c> listToBeUpdated = new List<mp_Quote_Detail_POE__c>();
                        
                        
                        for(mp_Quote_Detail_POE__c quoteDetail : [Select id,Quote_Approval_Status__c from mp_Quote_Detail_POE__c where id in : quoteDetailsIdToBeUpdated]){
                            if(quoteDetail.Quote_Approval_Status__c != 'CustomerApproved'){
                            quoteDetail.Quote_Approval_Status__c = 'Quote Sent To Customer';
                            }
                            listToBeUpdated.add(quoteDetail); 
                        }
                        
                        if(!listToBeUpdated.isEmpty()){
                            update listToBeUpdated;
                        }else{
                            system.debug('This should never happen');
                        }
                        
                    }else{
                        toBeReturned = CreateCustomFromTADOrder.sendQuoteEmail(pnrcResp,recId,false,consolidatedAmountToBeSent,additionalInformation);
                    }
                    system.debug('pnrResp:' +pnrcResp.flightData);
                    system.debug('req:'+req.getBody());
                }
                
            } catch(System.CalloutException e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
            }
        }
        
        return toBeReturned;
    }
    
    
    @auraEnabled
    public static String sendQuoteEmail(PNRConverterJSONResponse resp,String recId,Boolean sendEmail,Decimal consolidatedAmount, String additionalInformation)
    {
        System.debug('PNRConverter Response:'+resp);
        String emailBodyToBeReturned;
        Order_Customisations_POE__c oc = [Select id,Total_Final_Cost__c,mp_tad_order__r.ordexp_option__r.Name,mp_tad_order__r.name,PAX_Qty__c,mp_tad_order__r.ordexp_account__r.Company_Email__c,mp_tad_order__r.ordexp_account__r.name,recordType.Name,Type__c,Customisation_Consultant_Name__c,Passenger_Name__c,mp_tad_order__r.Deal_Title__c,mp_tad_order__r.ordexp_departure_date__r.date__c  from Order_Customisations_POE__c where id=: recId  ] ;
        
        Decimal pricePerPax = consolidatedAmount/oc.PAX_Qty__c;
        
        if(oc!=null)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //set owner email
            mail.setToAddresses (new String[] { oc.mp_tad_order__r.ordexp_account__r.Company_Email__c }); 
            
            mail.setSubject('CUSTOMISATION QUOTE');
            
            //retrieve template
            EmailTemplate tempId=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'MP_MerchantQuote' LIMIT 1];
            String emailBody = tempID.HTMLValue;
            String table = '<table style="width: 100%; background:#F2FFFF;" cellpadding="0" ><tr style="border: 1px;solid #000000;"><td><b>Airline<b></td><td><b>Flight No.<b></td><td><b>Booking Class<b></td><td><b>Date & Time<b></td><td><b>Departure -Destination<b></td><td><b>Duration<b></td> <td><b>Extra Info<b></td></tr>';
            
            List<PNRConverterJSONResponse.cls_flights> flights =resp.flightData.flights;
            system.debug('flights to check for response...'+flights);
            
            if(flights.isEmpty()){
                system.debug('Flights in this case are all empty....');
                emailBodyToBeReturned = null;
            }
            else{
                for(PNRConverterJSONResponse.cls_flights fl: flights)
                {
                    String airline= '<b>Operated By:</b>'+fl.flt.operated_by;
                    String flightNo = fl.flt.flightNo;
                    String class_x = fl.flt.class_x;
                    String date_x = fl.flt.departure.string_x;
                    String departure = fl.dep.cityname+'-'+fl.dep.countryname;
                    String duration = fl.flt.duration.hours+'hours '+fl.flt.duration.minutes+'minutes';
                    string pngImg ='<img src="'+fl.flt.png+'" />&nbsp;';
                    table=table+'<tr style="border: 1px;solid #000000;"><td>'+pngImg+' '+airline+'</td><td>'+flightNo+'</td><td>'+class_x+'</td><td>'+date_x+'</td><td>'+departure+'</td><td>'+duration+'</td><td></td></tr>';
                }
                table=table+'</table>';
                
                emailbody=emailBody.replace('QUOTETABLE',table);
                emailbody=emailBody.replace('{Flight Quote Details}','Flight Quote Details');
                emailbody=emailBody.replace('{Order Number}',oc.mp_tad_order__r.name);   
                emailbody=emailBody.replace('{Account Name}',oc.mp_tad_order__r.ordexp_account__r.name);  
                emailbody=emailBody.replace('{Deal Name}',oc.mp_tad_order__r.Deal_Title__c);
                emailbody=emailBody.replace('{record type}',oc.recordType.Name);
                emailbody=emailBody.replace('{pax qty}',String.valueOf(oc.PAX_Qty__c)); 
                emailbody=emailBody.replace('{total price}',String.valueOf(consolidatedAmount)); 
                emailbody=emailBody.replace('{type}',oc.Type__c); 
                emailbody=emailBody.replace('{Deal Option}',oc.mp_tad_order__r.ordexp_option__r.Name); 
             //   emailbody=emailBody.replace('{number of pax}',String.valueOf(oc.PAX_Qty__c)); 
                emailbody=emailBody.replace('{Departure Date}',oc.mp_tad_order__r.ordexp_departure_date__r.date__c.format());
                emailbody=emailBody.replace('{Price per person}',String.valueOf(pricePerPax));
                
                
                if(additionalInformation == null || additionalInformation == ''){
                    system.debug('Entering if for Additional Info.');
                    emailbody=emailBody.replace('{ADDITIONAL DETAILS}','');
                    emailbody=emailBody.replace('{Additional Details body}','');      
                }else{
                    system.debug('Entering else for Additional Info.');
                    emailbody=emailBody.replace('{ADDITIONAL DETAILS}','ADDITIONAL DETAILS:');
                    emailbody=emailBody.replace('{Additional Details body}',additionalInformation);
                }
                
                
                emailBodyToBeReturned = emailBody;
                mail.setHtmlBody(emailBody);
                
                if(sendEmail == true){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }
        return emailBodyToBeReturned;
    }
    
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    @auraEnabled
    public static String sendQuoteEmailToCustomer(String recId, Boolean previewQuote, Decimal consolidatedAmountToBeSent,List<String> quoteDetailsIdToBeUpdated,String additionalInformation)
    {
        system.debug('additionalInformation additionalInformation'+additionalInformation);
        String toBeReturned;
        Order_Customisations_POE__c oc = [Select id,mp_tad_order__r.ordexp_option__r.Name,PAX_Qty__c,Total_Final_Cost__c,mp_tad_order__r.name,mp_tad_order__r.ordexp_account__r.PersonEmail,mp_tad_order__r.ordexp_account__r.Company_Email__c,mp_tad_order__r.ordexp_account__r.name,recordType.Name,Type__c,Customisation_Consultant_Name__c,Passenger_Name__c,mp_tad_order__r.Deal_Title__c,mp_tad_order__r.ordexp_departure_date__r.date__c  from Order_Customisations_POE__c where id=: recId  ] ;
        Decimal pricePerPax1 = consolidatedAmountToBeSent/oc.PAX_Qty__c;
        Decimal pricePerPax = pricePerPax1.setScale(2);
        
        if(oc!=null)
        {
            String toEmails = null;
            if(oc.mp_tad_order__r.ordexp_account__r.PersonEmail != null)
                toEmails = oc.mp_tad_order__r.ordexp_account__r.PersonEmail;
            else if(oc.mp_tad_order__r.ordexp_account__r.Company_Email__c != null)
                toEmails = oc.mp_tad_order__r.ordexp_account__r.Company_Email__c;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //set owner email
            mail.setToAddresses (new String[] { toEmails }); 
            
            mail.setSubject('CUSTOMISATION QUOTE');
            
            //retrieve template
            EmailTemplate tempId=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'MP_MerchantQuote' LIMIT 1];
            String emailBody = tempID.HTMLValue;
            
            emailbody=emailBody.replace('QUOTETABLE','');
            emailbody=emailBody.replace('{Flight Quote Details}','');
            emailbody=emailBody.replace('{Order Number}',oc.mp_tad_order__r.name);   
            emailbody=emailBody.replace('{Account Name}',oc.mp_tad_order__r.ordexp_account__r.Name);  
            emailbody=emailBody.replace('{Deal Name}',oc.mp_tad_order__r.Deal_Title__c);
            emailbody=emailBody.replace('{record type}',oc.recordType.Name);
            emailbody=emailBody.replace('{pax qty}',string.valueOf(oc.PAX_Qty__c)); 
            emailbody=emailBody.replace('{total price}',String.valueOf(consolidatedAmountToBeSent)); 
            emailbody=emailBody.replace('{type}',oc.Type__c); 
            emailbody=emailBody.replace('{Deal Option}',oc.mp_tad_order__r.ordexp_option__r.Name); 
          //  emailbody=emailBody.replace('{number of pax}',string.valueOf(oc.PAX_Qty__c));
            emailbody=emailBody.replace('{Price per person}',string.valueOf(pricePerPax));
            emailbody=emailBody.replace('{Departure Date}',oc.mp_tad_order__r.ordexp_departure_date__r.date__c.format());     
            if(additionalInformation == null || additionalInformation == ''){
                system.debug('Entering if for Additional Info.');
                emailbody=emailBody.replace('{ADDITIONAL DETAILS}','');
                emailbody=emailBody.replace('{Additional Details body}','');      
            }else{
                system.debug('Entering else for Additional Info.');
                emailbody=emailBody.replace('{ADDITIONAL DETAILS}','ADDITIONAL DETAILS:');
                emailbody=emailBody.replace('{Additional Details body}',additionalInformation);
            }
            
            
            if(previewQuote == false){
                mail.setHtmlBody(emailBody);
                if(toEmails != null){
                	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                toBeReturned = null;
                
                List<mp_Quote_Detail_POE__c> listToBeUpdated = new List<mp_Quote_Detail_POE__c>();
                
                
                for(mp_Quote_Detail_POE__c quoteDetail : [Select id,Quote_Approval_Status__c from mp_Quote_Detail_POE__c where id in : quoteDetailsIdToBeUpdated]){
                    if(quoteDetail.Quote_Approval_Status__c != 'CustomerApproved'){
                    quoteDetail.Quote_Approval_Status__c = 'Quote Sent To Customer';
                    }
                    listToBeUpdated.add(quoteDetail); 
                }
                
                if(!listToBeUpdated.isEmpty()){
                    update listToBeUpdated;
                }else{
                    system.debug('This should never happen');
                }
                
            }
            else{
                toBeReturned = emailbody;
            }
        }
        
        return toBeReturned;
    }
    
    public static void orderStatusCheck (TAD_Order__c ord  , String customType , String recordType ,String reqDetails){ 
        
        if( ( customType == 'Upgrade Flight Class' || customType == 'Re/New Ticket Charge' || customType == 'Misc Charge' || customType == 'Upgrade Carrier' || customType == 'Customisation AE' || customType == 'Customisation SB' || customType == 'Customisation SO')  && recordType == 'Flight Customisation' && reqDetails != 'Passenger Replacement'){
            ord.ordexp_sub_status__c = 'Flight Quote Request';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(customType == 'Ticket Changes (Corrections)'  && recordType == 'Flight Customisation'){
            ord.ordexp_sub_status__c = 'Flight Quote Request';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(customType == 'Lounge Pass' && recordType == 'Flight Customisation' && ord.ordexp_flights_ticketed__c ){
            ord.ordexp_sub_status__c = 'Initial Payment Pending';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Accommodation Booking' && (customType == 'AE Accom' || customType == 'SB Accom' || customType =='Custom Accom (AE)' || customType == 'Custom Accom (SB)' || customType == 'Pre SO' || customType == 'Post SO' || customType == 'Note Only') ){
            ord.ordexp_sub_status__c = 'Pending Customisation';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Cruise Customisation' && (customType == 'Upgrade Cabin' || customType == 'Customisation' || customType == 'Ticket Changes (Corrections)' || customType == 'Re/New Ticket Charge' ||  customType == 'Misc Charge')  ){
            ord.ordexp_sub_status__c = 'Class (Sub Option) - Cabin Upgrade';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Land Customisation' &&  (customType == 'Customisation' || customType == 'Misc Charge' || customType == 'Transfer')){
            ord.ordexp_sub_status__c = 'Pending Customisation';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Stop Over Customisation' && (customType == 'Misc Charge' || customType == 'Pre SO' ||  customType == 'Post SO' )){
            ord.ordexp_sub_status__c = 'Pending Customisation';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Flight Customisation' && customType == 'Re/New Ticket Charge' && reqDetails == 'Passenger Replacement'){
            ord.ordexp_sub_status__c = 'Replacement Passenger details pending';
            ord.ordexp_master_status__c = 'Temporary Hold';
        }else if(recordType == 'Miscellaneous' && (customType == 'Miscellaneous' || customType == 'Exclusives' )){
            ord.ordexp_master_status__c = 'Temporary Hold';
            ord.ordexp_sub_status__c = 'Initial Payment Pending';
        }
        update ord ;
    }
    
    @AuraEnabled        
    public static void updateQuoteDetailStatus(List<String> quoteDetailIds, String recId){
  
        List<mp_Quote_Detail_POE__c> quoteDetailListToBeUpdated = new List<mp_Quote_Detail_POE__c>();
        for(mp_Quote_Detail_POE__c qd : [Select id, Quote_Approval_Status__c from mp_Quote_Detail_POE__c where id in:quoteDetailIds]){
            
            qd.Quote_Approval_Status__c = 'CustomerApproved';
            quoteDetailListToBeUpdated.add(qd);
        }
        
        update quoteDetailListToBeUpdated;
    }  
    
    @AuraEnabled 
    public static void updateTheQuoteDetail(quoteDetailWrapper qdWrapper){
        
        Schema.DescribeFieldResult fieldResult = mp_Quote_Detail_POE__c.Quote_Approval_Status__c.getDescribe(); 
        
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        String statusValueToBeSet;
        
        for( Schema.PicklistEntry v : values) {
            if(qdWrapper.requestStatus == v.getLabel()){
                System.debug('Picklist API Name:' + v.getValue());
                statusValueToBeSet = v.getValue();
                break;
            }
            
        }  
        
        mp_Quote_Detail_POE__c qd = new mp_Quote_Detail_POE__c(id = qdWrapper.Id,mp_Merchant_Quoted_Details__c = qdWrapper.merchantQuoteDetails,mp_Quote_Decline_Reason__c = qdWrapper.merchantDeclineReason,mp_Merchant_Price__c = qdWrapper.merchantPrice,Available_For__c =qdWrapper.quoteAvailableFor,ordexp_Merchant_Quote_Approval_Status__c=qdWrapper.merchantQuoteApprovalStatus);
        if(qdWrapper.merchantQuoteApprovalStatus == 'Decline'){
            qd.Quote_Approval_Status__c = 'Decline';
        }else{
            qd.Quote_Approval_Status__c = statusValueToBeSet;
        }
        
        update qd;
    }
}