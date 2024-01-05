({
    
    fetchListOfOLI: function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        console.log('recId in fetchOLI method '+recId);
        var action = component.get("c.fetchOLIRec");
        action.setParams({
            
            "recId" : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            
            var oli = response.getReturnValue();
            console.log('OLI List'+JSON.stringify(oli));
            var state = response.getState();
            
            if(state === "SUCCESS"){
                
                if(oli.orderMasterStatus == 'Travelled' || oli.orderMasterStatus == 'Cancelled'){
                    console.log('This might be a cancelled order.');
                    component.set("v.initErrorMessage","Order Customisation can be created for TAD Orders with Master Status of 'On Hold', 'Secured', 'In Progress' and 'Temporary Hold' only."); 
                    component.set("v.proceedCheck", false); 
                }else{
                    
                    if(oli.mapOfOLIAndId != null){
                        component.set("v.proceedCheck", true);
                        component.set("v.lstOfOli", oli.mapOfOLIAndId);  
                        var oliList = [];
                        for(var key in oli.mapOfOLIAndId){
                            
                            oliList.push(oli.mapOfOLIAndId[key]);
                            
                        }
                        component.set("v.flightTickted", oliList[0].ordexp_TAD_Order__r.ordexp_flights_ticketed__c);
                        component.set("v.lstOfOli", oliList);
                        console.log('#OLI:'+JSON.stringify(oliList));
                    }else{
                        component.set("v.initErrorMessage","There are no Order Line Items for this Order. Create an Order Line Item to create the customisation") 
                        component.set("v.proceedCheck", false);
                    }   
                }
            } 
            else{
                //  this.showToast(component,"Error!", "error",'There are no Order Line Items for this Order. Create an Order Line Item to create the customisation');
                console.log('This should never happen');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    saveFunctionality :function(component,event,helper){
        
        var fetchingNewWrapperVariable = component.get("v.finalOCDataWrapper");
        console.log('fetchingNewWrapperVariable fetchingNewWrapperVariable fetchingNewWrapperVariable '+JSON.stringify(fetchingNewWrapperVariable));
        console.log('concatMerchantAndComponentDetails '+JSON.stringify(fetchingNewWrapperVariable.concatMerchantAndComponentDetails));
        console.log('paxIds '+JSON.stringify(fetchingNewWrapperVariable.paxIds));
        console.log('customConsultantName '+JSON.stringify(fetchingNewWrapperVariable.customConsultantName));
        console.log('recordType '+JSON.stringify(fetchingNewWrapperVariable.recordType));
        console.log('customType '+JSON.stringify(fetchingNewWrapperVariable.customType));
        console.log('reqDetails '+JSON.stringify(fetchingNewWrapperVariable.reqDetails));
        
        if(fetchingNewWrapperVariable.paxIds == '' || fetchingNewWrapperVariable.paxIds == null ||  fetchingNewWrapperVariable.recordType == "--- None ---" || fetchingNewWrapperVariable.customType == "--- None ---" || fetchingNewWrapperVariable.customConsultantName == "--- NONE ---" || fetchingNewWrapperVariable.customConsultantName == '' || $A.util.isEmpty(fetchingNewWrapperVariable.reqDetails)){
            this.showToast(component,"Error!", "error",'Missing required fields. Please complete the form before saving');      
        }else if(fetchingNewWrapperVariable.concatMerchantAndComponentDetails =='' || fetchingNewWrapperVariable.concatMerchantAndComponentDetails ==null){
            this.showToast(component,"Error!", "error",'Please select the related merchants');
            }
        else{
            
            var action = component.get('c.onSaveBtnClickFunc')
            action.setParams({
                "orderCusCreationWrapper" : fetchingNewWrapperVariable
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var result = response.getReturnValue();
                
                console.log('state from the new Helper method created!'+result);
                
                if(state === "SUCCESS"){
                    if(result.toBeReturnedBoolean == true){
                        console.log("This Save and New is working fine now!!!");
                        helper.navigate(component,event,helper,result.recordId); 
                    }else{
                        this.closeModal(component,event,helper);
                        this.showToast(component, "Success!", "success", "You have successfully created the Order Customisation"); 
                        helper.redirectToTADOrderRecord(component,event,helper,'null'); 
                    }
                }
                else{
                    console.log('There might be some error!');
                }
                
            });
            $A.enqueueAction(action);  
        }  
    }, 
    fetchTheSavedAndSendOrderCustomisationData: function(component,event,helper,recordId){
        
        var action = component.get("c.fetchDetailsOfOrderCustomisation");
        action.setParams({
            "ordCusId" : recordId 
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            console.log('state for fetchTheSavedAndSendOrderCustomisationData'+state);
            console.log('result for fetchTheSavedAndSendOrderCustomisationData'+JSON.stringify(result));
            console.log('result for fetchTheSavedAndSendOrderCustomisationData'+JSON.stringify(result.customType));
            if(state === "SUCCESS"){
                
                this.settingColumnsForPAXAndComponents(component, event, helper, 'OC',result);
                component.set("v.depnedentFieldMap",result.getDependentMap);
                this.setRecordTypeList(component,event,helper,result,result.getDependentMap);
                this.setCustomisationTypeList(component,event,helper,result,result.getDependentMap);
                
            }
            
        });
        $A.enqueueAction(action);
        
    }, 
    
    setRecordTypeList : function(component,event,helper,masterOCWrapper,dependentMap){
        var listOfkeys = [];
        var ControllerField = [];
        
        for (var singlekey in dependentMap) {
            listOfkeys.push(singlekey);
        }
        if (listOfkeys != undefined && listOfkeys.length > 0) {
            ControllerField.push('--- None ---');
        }
        for (var i = 0; i < listOfkeys.length; i++) {
            ControllerField.push(listOfkeys[i]);
        }
        component.set("v.listControllingValues", ControllerField);
    },
    
    setCustomisationTypeList : function(component,event,helper,masterOCWrapper,dependentMap){
        
        var ListOfDependentFields = dependentMap[masterOCWrapper.recordType];
        var dependentFields = [];
        component.set("v.bDisabledDependentFld" , false);
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.listDependingValues", dependentFields);
        component.set("v.finalOCDataWrapper", masterOCWrapper);
        
    },
    
    
    
    addOnSubmitted : function (component, event, helper) {
        component.set("v.OLIDetails",true);
        var showAddOn = component.get("v.showAddOn");
        if(showAddOn) {  
            component.set("v.showAddOn",false); 
            var selectedAddOn = component.find("selectAddOn").get("v.value");
            console.log('selectedAddOn'+selectedAddOn);
            component.set("v.selectedAddOn",selectedAddOn);
        }
        else {
            component.set("v.selectedAddOn","");           
        }
        
    },
    
    settingColumnsForPAXAndComponents : function (component, event, helper, StringComingFrom,allDataWrap) {
        component.set("v.showAddOn",false);
        if(StringComingFrom == 'Order'){
            component.set("v.ifOLIisSelected",true);
        }else{
            component.set("v.ifOLIisSelected",false); 
        }
        component.set("v.oliSelect",false);
        
        if(StringComingFrom == 'OC'){
            component.set("v.OLIDetails",true);
        }else{
            component.set("v.OLIDetails",false);
        }
        component.set("v.showPAXList",true);
        component.set("v.onlyShowPaxName",false);
        // component.set("v.mainHeader","Viewing Order Customisation");
        
        this.settingColumns(component,event,helper);
        component.set("v.data",allDataWrap.componentDataWrapper);
        
        this.paxColumns(component,event,helper);
        component.set("v.paxData",allDataWrap.passengerDataWrapper);
        
        var savedComponentIds = allDataWrap.savedComponentIds;
        var savedPaxIds = allDataWrap.savedPaxIds;
        
        console.log('savedComponentIds'+savedComponentIds);
        console.log('savedPaxIds'+savedPaxIds);
        
        if(!$A.util.isUndefinedOrNull(savedComponentIds)){
            var selComponentIds = [];
            selComponentIds = allDataWrap.savedComponentIds.split(',');
            component.set("v.selectedRows",selComponentIds); 
            
        }
        
        if(!$A.util.isUndefinedOrNull(savedPaxIds)){
            var selPAXIds = [];
            selPAXIds = allDataWrap.savedPaxIds.split(',');
            console.log('new new new selPAXIds'+selPAXIds);
            component.set("v.selectedPAXRows",selPAXIds); 
            
        }
    },
    
    
    
    redirectToTADOrderRecord : function (component, event, helper, recIdToRedirect) {
        var recId = '';
        if(recIdToRedirect == 'null'){
            recId = component.get("v.recordId");
        }else{
            
            var getWrap = component.get("v.finalOCDataWrapperForSavedAndSend");
            recId = getWrap.tadOrderId;
        }
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "related"
        });
        navEvt.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    navigate : function(component,event,helper,recordId){
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:CreateCustomisationFromTADOrder",
            componentAttributes: {
                recordId : recordId
            }
        });
        navigateEvent.fire(); 
    },
    
    rowSelectionOnLDT : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');
        console.log('selectedRows from Component and Merchant '+selectedRows);
        var selComponentAndMerchant_Ids = [];
        
        for (var i = 0; i < selectedRows.length; i++){
            
            var a = selectedRows[i].componentId+';'+selectedRows[i].componentMerchantId;
            selComponentAndMerchant_Ids.push(a); 
            
        }
        
        component.set("v.selectedRowComponentAndMerchantId",selComponentAndMerchant_Ids);
        component.set("v.finalOCDataWrapper.concatMerchantAndComponentDetails",selComponentAndMerchant_Ids);
        
        console.log('selectedRowComponentAndMerchantId'+component.get("v.selectedRowComponentAndMerchantId"));
        
    },
    
    rowSelectionOnLDTforPAX : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');
        console.log('selectedRows from PAX '+selectedRows);
        var selPAX_Ids = [];
        for (var i = 0; i < selectedRows.length; i++){
            
            var a = selectedRows[i].paxId;
            selPAX_Ids.push(a);   
        }
        
        
        component.set("v.selectedPAXIds",selPAX_Ids);
        component.set("v.finalOCDataWrapper.paxIds",selPAX_Ids);
        component.set("v.finalOCDataWrapper.selectedPAXQuantity",selPAX_Ids.length);
        console.log('selPAX_Ids'+component.get("v.selectedPAXIds"));  
    },
    
    fetchAllData: function(component,event,helper){
        
        // Tad Order New Customisation
        var orderlineId = component.find("oliPickList").get("v.value");
        component.set("v.attForOliIdSave",orderlineId);
        var tadId = component.get("v.recordId");
        // Tad Order View Customisation
        var oliOCid= component.get("v.oliIdForOC");
        var tadOCid= component.get("v.tadOrderIdForOC");
        
        if(!($A.util.isUndefined(orderlineId) && $A.util.isUndefined(tadId)) ){
            var  oliId =  orderlineId;
            var  tadOrderId =  tadId;
            
        }
        if(!($A.util.isUndefined(oliOCid) && $A.util.isUndefined(tadOCid)) ){
            var  oliId =  oliOCid;
            var  tadOrderId = tadOCid;
        }
        
        var action = component.get("c.fetchAllData");
        action.setParams({
            
            "oliId" : oliId,
            "recId" : tadOrderId          
        }); 
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            //   console.log("STATEEE"+state);
            //   console.log("result"+JSON.stringify(result));
            
            if(state === "SUCCESS"){
                
                component.set("v.oliSelect",false);
                component.set("v.ifOLIisSelected",true);
                component.set("v.showPAXList",true);
                component.set("v.onlyShowPaxName",false);
                
                this.settingColumns(component,event,helper); 
                component.set("v.data",result.componentWrapList);
                console.log('Testing for stored Component Ids:::'+result.storedComponentIds);
                
                console.log('test1 Component Data'+JSON.stringify(result.componentWrapList));  
                
                this.paxColumns(component,event,helper);
                component.set("v.paxData",result.paxListWrapList); 
                console.log('test test test test'+JSON.stringify(result.paxListWrapList)); 
                
                
                component.set("v.tadOrderName",result.tadOrderName);
                component.set("v.oliName",result.oliName);
                component.set("v.paxNo",result.paxNo);
                
                //   this.getTheExistingOrdCustomData(component,event,helper);
                
                
            }
            
            
            
            else{
                this.showToast(component,"Error!", "error",'There are no PAX on this Order Line Item');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    fetchRecordType: function(component, event, helper){
        
        var selectedOLI = component.find("oliPickList").get("v.value");
        console.log('SELECTEDOLIII'+selectedOLI);
        
        component.set("v.attForOliIdSave",selectedOLI);
        
        var selectdOLIfromOC = component.get("v.oliIdForOC");
        console.log('selectdOLIfromOC'+selectdOLIfromOC);
        
        if(($A.util.isEmpty(selectedOLI) || selectedOLI == "--- NONE ---") && $A.util.isEmpty(selectdOLIfromOC)){
            this.showToast(component,"Error!", "error",'Please select an Order Line Item to proceed');
        }else{
            component.set("v.oliSelect",false);
            component.set("v.ifOLIisSelected",true);
            // this.fetchOrderComponentValues(component,event,helper);
            var action = component.get("c.fetchRecordTypeValues");
            action.setParams({
                "objectName" : "Order_Customisations_POE__c"
            });
            action.setCallback(this, function(response) {
                
                
                console.log('response from failing method'+JSON.stringify(response.getReturnValue()));
                var mapOfRecordTypes = response.getReturnValue();
                
                component.set("v.mapOfRecordType", mapOfRecordTypes);
                var recordTypeList = [];
                for(var key in mapOfRecordTypes){
                    
                    if(mapOfRecordTypes[key])
                        recordTypeList.push(mapOfRecordTypes[key]);
                    
                }
                if(recordTypeList.length == 0){//Object does not have any record types
                } else{
                    component.set("v.lstOfRecordType", recordTypeList);
                    //this.setOCData(component,event,helper);
                }
            });
            
            $A.enqueueAction(action);        
        }
        
    },
    //Added By Abhinav 
    fetchAddOnPicklist : function(component,event,helper,orderlineId){  
        console.log('var orderlineId'+ orderlineId);  
        var action = component.get("c.getAddOnPicklist");
        action.setParams({
            'OLIId': orderlineId
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); console.log(JSON.stringify(response));
            var result = response.getReturnValue();
            console.log('STATE FOR COMPONENT TYPE RETURN - - '+state);
            console.log('Result For - - '+response.getReturnValue());
            if (state === "SUCCESS"){
                component.set("v.addOnOptions", result);
                //  this.getTheExistingOrdCustomData(component,event,helper);
                console.log('RESULTSSS FOR COMPONENT TYPES'+JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchComponentTypePicklist : function(component,event,helper){
        //    console.log("Entering fetchComponentTypePicklist now");
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Order_Customisations_POE__c",
            'field_apiname': "Type__c",
            'nullRequired': false
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('STATE FOR COMPONENT TYPE RETURN'+state);
            if (state === "SUCCESS"){
                component.set("v.pickListOptions", result);
                //   this.getTheExistingOrdCustomData(component,event,helper);
                console.log('RESULTSSS FOR COMPONENT TYPES'+JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
    },
    
    /* fetchOrderCustomConsultantName : function(component,event,helper){
var action = component.get("c.getPicklistvalues");
action.setParams({
'objectName': "Order_Customisations__c",
'field_apiname': "Customisation_Consultant_Name__c",
'nullRequired': false
});
action.setCallback(this, function(a) {
var state = a.getState();
console.log('State for Cusom Consultant NAme'+state);
if (state === "SUCCESS"){
    
    component.set("v.customConsultantPicklistOption", a.getReturnValue());
    this.getTheExistingOrdCustomData(component,event,helper);
}
});
$A.enqueueAction(action);
},  */
    
    fetchRequestedDetailsPicklist : function(component,event,helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Order_Customisations_POE__c",
            'field_apiname': "Requested_Details__c",
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('State for requested Details'+state);
            if (state === "SUCCESS"){
                
                component.set("v.requestedDetailsPicklistOption", a.getReturnValue());
                //     this.getTheExistingOrdCustomData(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    noteOnlyVisibilityField : function(component,event,helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Order_Customisations_POE__c",
            'field_apiname': "Note_only_visibility__c",
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                
                component.set("v.noteOnlyVisibilityOption", a.getReturnValue());
                //     this.getTheExistingOrdCustomData(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchOrderCustomisationStatus : function(component,event,helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Order_Customisations_POE__c",
            'field_apiname': "Status__c",
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            console.log('State for Cusom Status'+state);
            if (state === "SUCCESS"){ 
                console.log('Customisation Status'+JSON.stringify(result))
                component.set("v.lstOfOCStatus", a.getReturnValue());
                //       this.getTheExistingOrdCustomData(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    }, 
    
    setOCData : function(component,event,helper){
        
        component.set("v.showPAXList",false);
        component.set("v.onlyShowPaxName",true);
        var data = component.get("v.customizationData"); 
        console.log('data: '+JSON.stringify(data));
        
        var selComponentIds = [];
        var concatIds = component.get("v.selectedRowComponentAndMerchantId"); 
        console.log('concatIds'+concatIds.length);
        
        if(concatIds.length === 0){
            console.log('This null check works fine;');
            if(typeof(data.storedComponentIds) === 'undefined' || typeof(data.storedComponentIds) === null){
                console.log('You are in a mess!'); 
            }else{
                selComponentIds = data.storedComponentIds.split(',');
                
                component.set("v.mainHeader","Viewing Order Customisation");
                console.log('selComponentIds in setOCData'+selComponentIds);
                component.set("v.selectedRows",selComponentIds);
                component.set("v.sendComponentIds",selComponentIds);    
            }   
        }  
        
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        //this.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        
        
        
        component.find("recordTypePickList").set("v.value",data.recordTypeName);
        component.set("v.recordAndCutomTypeOnLoad",data.recordTypeName);
        
        this.onControllerFieldChangeHelper(component,event,helper);
        component.set("v.bDisabledDependentFld",false);  
        
        component.find("pickListOption").set("v.value",data.orderCustomType);  
        component.set("v.customTypeOnload",data.orderCustomType);
        
        if(!$A.util.isUndefined(data.noteVisibility)){
            component.find("noteOnlyVisibility").set("v.value",data.noteVisibility);   
        }
        component.find("customConsultantPickListOption").set("v.value",data.customConsultantName);
        component.set("v.paxNameInReadOnly",data.paxName);
        component.find("requestedDetails").set("v.value",data.requestedDetails);
        // component.find("paxPickList").set("v.value",data.paxId);
        
    },
    
    onControllerFieldChangeHelper : function(component,event,helper){
        console.log('Entering in onControllerFieldChangeHelper!@#$%%^^^');
        var controllerValueKey = component.get("v.recordAndCutomTypeOnLoad");
        var customTypeValue = component.get("v.customTypeOnload");
        console.log('controllerValueKey in helper'+controllerValueKey+' '+customTypeValue);
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);
                helper.fetchDepValues(component, ListOfDependentFields);
                component.find("pickListOption").set("v.value") == customTypeValue;
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
        
    },
    
    settingColumns: function(component,event,helper){
        component.set("v.bccolumns",[{label: 'Component', fieldName: 'componentType', type: 'text',sortable:true},
                                     {label: 'Component Type', fieldName: 'componentTypeName', type: 'text',sortable:true},
                                     {label: 'Merchant Name', fieldName: 'MerchantName', type: 'text',sortable:true}])
        
    },
    
    getReadOnlyColumns: function(component,event,helper){
        component.set("v.readOnlycolumns",[{label: 'Component', fieldName: 'componentType', type: 'text',sortable:true},
                                           {label: 'Component Type', fieldName: 'componentTypeName', type: 'text',sortable:true},
                                           {label: 'Merchant Name', fieldName: 'MerchantName', type: 'text',sortable:true}])
    },
    
    getReadOnlyQuoteDetailsColumns: function(component,event,helper){
        component.set("v.readOnlyQuoteDetailsColumns",[
            {label: 'Merchant Name', fieldName: 'merchantName', type: 'text'},
            {label: 'Quote Status', fieldName: 'requestStatus', type: 'text'},
            {label: 'Merchant Quoted Details', fieldName: 'merchantQuoteDetails', type: 'text'},
            {label: 'Merchant Decline Reason', fieldName: 'merchantDeclineReason', type: 'text'},
            {label: 'Quote Available For', fieldName: 'quoteAvailableFor', type: 'text'},
            {label: 'Merchant Price', fieldName: 'merchantPrice', type: 'currency',cellAttributes: { alignment: 'left' }},
            {label: 'Merchant Currency', fieldName: 'merchantCurrency', type: 'text'},                  
            {label: 'TAD Price', fieldName: 'tadPrice', type: 'currency',cellAttributes: { alignment: 'left' }}])
        
    },
    
    paxColumns: function(component,event,helper){
        component.set("v.paxColumns",[{label: 'PAX', fieldName: 'paxName', type: 'text',sortable:true},
                                      {label: 'First Name', fieldName: 'paxFirstName', type: 'text',sortable:true},
                                      {label: 'Last Name', fieldName: 'paxLastName', type: 'text',sortable:true}])
        
        var tempPAX = component.get("v.paxColumns");
        console.log('tempPAX tempPAX '+JSON.stringify(tempPAX));
    },
    
    /*    getTheExistingOrdCustomData : function(component,event,helper){
        var action = component.get("c.fetchExistingOCData");
        action.setParams({
            'recId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            console.log('STEATEEE'+' '+state+' '+'RESULTTT'+JSON.stringify(result));
            
            if (state === "SUCCESS"){ 
                component.set("v.oliSelect",false);
                component.set("v.ifOLIisSelected",true);
                component.set("v.mainHeader","Order Customisation View");
                
                //  component.set("v.oliIdForOC",result.oliId);
                //  component.set("v.tadOrderIdForOC",result.tadOrderId);
                
                console.log('Component_IDs__c'+result.storedComponentIds);
                console.log('CustomType'+result.orderCustomType);
                //   component.find("pickListOption").set("v.value",result.orderCustomType);
                
                component.set("v.customizationData",result);
                this.setOCData(component,event,helper);
                component.set("v.bDisabledDependentFld",false);
            }
            else{
                console.log('This shit failed');
            }
        });
        $A.enqueueAction(action);
    },  */
    
    
    closeModal : function(component){
        component.set('v.openPnr',false);
        component.set('v.previewQuote',false);
        component.set("v.sendQuotePNREnable",true);
        component.set("v.disableSendQuoteWithoutFlights",true);
        component.set("v.disableBackButtonWithoutFlights",true);
        component.set("v.disableBackButtonWithFlights",true);
        
        
        component.set("v.previewMinModalWithoutFlight",false);
        var closeEvent = $A.get("e.force:closeQuickAction");
        component.set("v.quotePreviewStringForflightData",null);
        component.set("v.dataPNR",null);
        if(closeEvent){
            closeEvent.fire();
        } else{
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
        }     
    },
    
    showToast: function(component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message
        });
        toastEvent.fire();
    },
    
    
    callPNRandPreview : function (component,pnr,helper)
    {
        component.set('v.columnsPNR', [
            {label: 'Airline', fieldName: 'Airline', type: 'text'},
            {label: 'FlightNo.', fieldName: 'FlightNo', type: 'text'},
            {label: 'Booking Class', fieldName: 'bookingClass', type: 'text'},
            {label: 'Date & Time', fieldName: 'dateTimeValue', type: 'date'},
            {label: 'Departure', fieldName: 'departure', type: 'text'},
            {label: 'Duration', fieldName: 'duration', type: 'text'},
            {label: 'ExtraInfo', fieldName: 'extrainfo', type: 'text'},
        ]);
            
            var additionalDetails = component.find("addInfoWithFlights").get("v.value");
            console.log('Entering if for additionalDetails 123456789');
            if($A.util.isUndefinedOrNull(additionalDetails)){
            console.log('Entering if for additionalDetails');
            additionalDetails ='';
            }   
            
            
            var action = component.get("c.callPNRcAPI");
            action.setParams({
            'pnrVal' : pnr,
            'recId' : component.get("v.recordId"),
            'sendMail':false,
            'consolidatedAmountToBeSent' : component.get("v.consolidatedPriceToBeSent"),
            'additionalInformation' : additionalDetails
            });
            action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            console.log('state : '+state);
            console.log('Result : '+JSON.stringify(result));
            if (state === "SUCCESS"){
            if(result != null){
            component.set("v.previewFlightDetailsOfPNR",true);
            component.set("v.quotePreviewStringForflightData",result);
            component.set("v.sendQuotePNREnable",false);
            component.set("v.disableBackButtonWithFlights",false);
            }else{
            this.showToast(component, "Error!", "error", "The PNR entered has an error. Please check this and try again");
            }
            }else{
            console.log('Should ideally never enter this!');
            }
            
            });
            $A.enqueueAction(action);
            
            },
            
            callPNRandEmail : function (component,pnrVal,helper)
            {
            
            var additionalDetails = component.find("addInfoWithFlights").get("v.value");
            console.log('Entering if for additionalDetails 123456789');
            if($A.util.isUndefinedOrNull(additionalDetails)){
            console.log('Entering if for additionalDetails');
            additionalDetails ='';    
            }
            var action = component.get("c.callPNRcAPI");
            action.setParams({
            
            "pnrVal" : pnrVal,
            'recId' : component.get("v.recordId"),
            'sendMail' : true,
            'consolidatedAmountToBeSent': component.get("v.consolidatedPriceToBeSent"),
            'quoteDetailsIdToBeUpdated' : component.get("v.selectedQuoteDetailsForStatusUpdate"),
            'additionalInformation' : additionalDetails
            
            });
            action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result = response.getReturnValue();
            console.log("STATEEE"+state);
            console.log("RESULTTT"+JSON.stringify(result));
            
            if(state === "SUCCESS"){
            
            component.set("v.openPnr",false);
            this.showToast(component, "Success!", "success", "The Quote details have been sent to the Account Holder");
            component.set("v.sendQuotePNREnable",true);
            component.set("v.quotePreviewStringForflightData",null);
            helper.redirectToTADOrderRecord(component,event,helper); 
            }
            
            
            });
            
            $A.enqueueAction(action);
            
            },
            
            
            /*fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
// call the server side function  
var action = component.get("c.getDependentMap");
// pass paramerters [object definition , contrller field name ,dependent field name] -
// to server side function 
action.setParams({
'objDetail' : objDetails,
'contrfieldApiName': controllerField,
'depfieldApiName': dependentField 
});
//set callback   
action.setCallback(this, function(response) {
if (response.getState() == "SUCCESS") {
//store the return response from server (map<string,List<string>>)  
var StoreResponse = response.getReturnValue();

// once set #StoreResponse to depnedentFieldMap attribute 
component.set("v.depnedentFieldMap",StoreResponse);

// create a empty array for store map keys(@@--->which is controller picklist values) 
var listOfkeys = []; // for store all map keys (controller picklist values)
            var ControllerField = []; // for store controller picklist value to set on lightning:select. 
            
            // play a for loop on Return map 
            // and fill the all map key on listOfkeys variable.
            for (var singlekey in StoreResponse) {
listOfkeys.push(singlekey);
}

//set the controller field value for lightning:select
if (listOfkeys != undefined && listOfkeys.length > 0) {
ControllerField.push('--- None ---');
}

for (var i = 0; i < listOfkeys.length; i++) {
ControllerField.push(listOfkeys[i]);
}  
// set the ControllerField variable values to country(controller picklist field)
component.set("v.listControllingValues", ControllerField);
}else{
alert('Something went wrong..');
}
});
$A.enqueueAction(action);
}, */
            
            
            
            fetchDepValues: function(component, ListOfDependentFields) {
            // create a empty array var for store dependent picklist values for controller field  
            var dependentFields = [];
                      dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
    
    approveOCHelper : function(component,event,helper){
        
        var recID = component.get("v.recordId");
        console.log('recID'+recID);
        var qdIds = component.get("v.selectedQuoteDetailsForStatusUpdate");
        console.log('qdIds'+qdIds);
        var action = component.get("c.updateQuoteDetailStatus");
        action.setParams({
            'recID': recID,
            'quoteDetailIds': qdIds
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            console.log('State for Cusom Status'+state);
            if (state === "SUCCESS"){
                if(result=='paid'){
                    this.showToast(component, "Info!", "success", "Credit is applied for this Customisation!");   
                }
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);  
    }, 
    
    previewingCustomerQuoteWithoutFlightDetails : function (component,event,helper) {
        var additionalDetails = component.find("addInfoWithoutFlights").get("v.value");
        console.log('additionalDetails additionalDetails'+additionalDetails);
        
        if($A.util.isUndefinedOrNull(additionalDetails)){
            console.log('Entering if for additionalDetails');
            additionalDetails ='';
        }   
        
        var action = component.get("c.sendQuoteEmailToCustomer");
        action.setParams({
            'recId' : component.get("v.recordId"),
            'previewQuote' : true,
            'consolidatedAmountToBeSent' : component.get("v.consolidatedPriceToBeSent"),
            'quoteDetailsIdToBeUpdated' : component.get("v.selectedQuoteDetailsForStatusUpdate"),
            'additionalInformation' : additionalDetails
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            console.log('statestatestate'+state);
            if(state === "SUCCESS"){
                component.set("v.quotePreviewString",result);
                component.set("v.previewQuote",true);
                component.set("v.disableSendQuoteWithoutFlights",false);
                component.set("v.disableBackButtonWithoutFlights",false);
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    redirectToOrder : function (component,event,helper){
        
        var tadOrderId = component.get("v.sObjectId");
        console.log('tadOrderId'+tadOrderId);
        
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": tadOrderId,
            "slideDevName": "related"
        });
        urlEvent.fire();
    },
    
    fetchAllTheDataRequiredForNewCreation : function(component,event,helper,recordId){
        
        //component.set("v.sObjectId",recordId);
        var orderlineId = component.find("oliPickList").get("v.value");
        console.log('orderlineId to be set in the new wrapper: '+orderlineId);
        
        var action = component.get("c.fetchAllTheDataForOCCreation");
        action.setParams({
            
            "recId" : recordId,
            "orderLineItemId" : orderlineId
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            console.log('STATEEE'+' '+state+' '+'RESULTTT for the new wrapper created'+' '+JSON.stringify(result));	
            if(state === 'SUCCESS'){
                component.set("v.finalOCDataWrapper",result);
                this.settingColumnsForPAXAndComponents(component, event, helper, 'Order',result);
               // this.assignPicklistValuesOnMainOCScreen(component,event,helper,result);
            }            
        });
        $A.enqueueAction(action);  
        
    },
    
    assignPicklistValuesOnMainOCScreen : function(component,event,helper,masterOCWrapper){
        
        var StoreResponse = masterOCWrapper.getDependentMap;
        console.log('StoreResponse StoreResponse StoreResponse'+StoreResponse);
        component.set("v.depnedentFieldMap",StoreResponse);
        var listOfkeys = [];
        var ControllerField = [];
        
        for (var singlekey in StoreResponse) {
            listOfkeys.push(singlekey);
        }
        
        if (listOfkeys != undefined && listOfkeys.length > 0) {
            ControllerField.push('--- None ---');
        }
        
        for (var i = 0; i < listOfkeys.length; i++) {
            ControllerField.push(listOfkeys[i]);
        }
        component.set("v.listControllingValues", ControllerField);
        
    },
    
    
    onControllerFieldChangeHelper : function(component,event,helper){
        
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }	
    }
    
})