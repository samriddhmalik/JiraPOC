({
    
    
    doInit : function (component, event, helper)
    {
        var recordId = component.get("v.recordId");
        console.log('recordId in INIT from beginning'+recordId);
        
        if($A.util.isUndefinedOrNull(recordId)){
            var pageRef = component.get("v.pageReference");
            console.log('pageRef'+pageRef);    
            var state = pageRef.state;
            var base64Context = state.inContextOfRef;
            
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            if(addressableContext!=null){
                component.set("v.recordId", addressableContext.attributes.recordId); 
            }      
        }
        
        var action = component.get("c.idPassToCheckSObject");
        console.log('recID recID recID'+component.get("v.recordId"));
        action.setParams({
            
            "recId" : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            component.set("v.sOobjectName",result.sObjectName);
            console.log('STATEEE'+' '+state+' '+'RESULTTT'+' '+JSON.stringify(result.sObjectName));	
            if(state === 'SUCCESS'){
                if(result.sObjectName === 'TAD_Order__c'){
                    helper.fetchListOfOLI(component,event,helper);
                }else if(result.sObjectName === 'Order_Customisations_POE__c'){
                    if(result.saveAndSend == true){
                        
                        component.set("v.oliSelect",false);
                        component.set("v.ifOLIisSelected",false);
                        component.set("v.showAddOn",false);
                        component.set("v.OLIDetails",false); 
                        component.set("v.makeItReadOnly",true); 
                        
                        component.set("v.mainHeader",'Viewing Order Customisation Record');
                        component.set("v.finalOCDataWrapperForSavedAndSend",result);
                        component.set("v.sObjectId",result.tadOrderId);
                        helper.getReadOnlyColumns(component,event,helper); 
                    }else{
                        helper.fetchTheSavedAndSendOrderCustomisationData(component,event,helper,recordId);
                    }    
                }else{
                    console.log('This should never happen. The record does not belong to TAD Order or Order Customisation.');
                }
                
                
            }
            
        });
        $A.enqueueAction(action);
        
        
        
        
        
    },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    updateQuoteDetails: function(component, event, helper) {
        var readOnlyQuoteDetailsColumns = component.get("v.readOnlyQuoteDetailsColumns");
        var readOnlyQuoteDetailData = component.get("v.readOnlyQuoteDetailData");
        var draftValues = event.getParam('draftValues');
        var param = []; var qd = {};
        qd.Id = draftValues[0].Id;
        qd.Quote_Approval_Status__c = draftValues[0].requestStatus;
        param.push(qd);                           
        var action = component.get("c.saveQuoteDetails");
        action.setParams({qd: param});
        action.setCallback(this, function(response){
        });
        $A.enqueueAction(action);
        
    },
    
    onControllerFieldChange: function(component, event, helper) {
        console.log('called');
        helper.onControllerFieldChangeHelper(component, event, helper);
    },
    
    selectPAX  : function (component, event, helper)
    {
        helper.selectPAXForOLI(component, event, helper); 
    },
    
    addOnConfirmation : function (component, event, helper)
    {
        var getMasterWrap = component.get("v.finalOCDataWrapper");
        component.set("v.ifOLIisSelected",false);
        var isAddOnAvailable = component.find("isAddOnAvailable");
        if(isAddOnAvailable.get("v.checked")) {
            component.set("v.showAddOn",true);
            component.set("v.isAddOnAvailable",true);
        }
        else {
            component.set("v.showAddOn",false);
            component.set("v.isAddOnAvailable",false);
            helper.addOnSubmitted(component, event, helper);
            helper.assignPicklistValuesOnMainOCScreen(component,event,helper,getMasterWrap);
        }
    },
    
    addOnSubmitted : function (component, event, helper)
    {  
        var getMasterWrap = component.get("v.finalOCDataWrapper");
        component.set("v.ifOLIisSelected",false);
        var selectedAddOn = component.find("selectAddOn").get("v.value");
        if(selectedAddOn != '') {
            helper.addOnSubmitted(component, event, helper);
            helper.assignPicklistValuesOnMainOCScreen(component,event,helper,getMasterWrap);
        }
        else {
            component.find("selectAddOn").showHelpMessageIfInvalid();
        }
        
    },
    
    
    fetchOrderCustomisationRecordTypes  : function (component, event, helper)
    {  
        var orderlineId = component.find("oliPickList").get("v.value");
        var recId = component.get("v.recordId");
        
        if(orderlineId == '' || orderlineId == '--- NONE ---'){
            helper.showToast(component,"Error!", "error",'Please select an Order Line Item to proceed');
        }else{
            
            var action = component.get("c.verifyThePaxInOLI");
            action.setParams({
                
                "oliId":orderlineId
                
            });
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                var result = response.getReturnValue();
                console.log("STATEEE"+state);
                console.log("RESULTTT"+JSON.stringify(result));
                
                if(state === "SUCCESS"){
                    if(result.toBeReturned == true){
                        helper.fetchAddOnPicklist(component, event, helper, orderlineId);
                        component.set("v.oliName",result.oliName);
                        helper.fetchAllTheDataRequiredForNewCreation(component,event,helper,recId);
                    }
                    else{
                        helper.showToast(component, "Error!", "error", "There are no PAX in this Order Line Item"); 
                        
                    }
                }
                else{
                    console.log('This should never arise');
                }
            });
            
            $A.enqueueAction(action);  
        } 
    },
    
    back: function (component, event, helper)
    {
        component.set("v.oliSelect",true);
        component.set("v.showAddOn",false);
        component.set("v.ifOLIisSelected",false); 
        component.set("v.OLIDetails",false);  
    },
    
    save: function (component, event, helper)
    {
            component.set("v.finalOCDataWrapper.btnText","Save");
            helper.saveFunctionality(component,event,helper);   
           
    },
    
    saveAndSend: function (component, event, helper)
    {
            component.set("v.finalOCDataWrapper.btnText","SaveAndSend");
            helper.saveFunctionality(component,event,helper);
        
    },
    
    saveAndNew: function (component, event, helper)
    {
        component.set("v.finalOCDataWrapper.btnText","SaveAndNew");
        helper.saveFunctionality(component,event,helper);
    },
    
    controllerMethodToPreviewWithoutFlights : function (component,event,helper){
        helper.previewingCustomerQuoteWithoutFlightDetails(component,event,helper);
    },
    
    sendQuote: function (component, event, helper)
    {	
        
        var flightQuote = component.get("v.AttachFlightQuote");
        var sendQuote = component.get("v.sendQuoteToCustomer");
        
        console.log('In sendQuote '+component.get("v.recordId") + ' ' + component.get("v.consolidatedPriceToBeSent") + ' '+ component.get("v.selectedQuoteDetailsForStatusUpdate"));
        
        if(sendQuote==true && flightQuote==false ){
            console.log('entering for sendQuote as true');
            component.set("v.previewMinModalWithoutFlight",true);
            
            
        }
        else if(sendQuote==false && flightQuote==false){
            helper.showToast(component, "Error!", "error", "One of the above two checkbox need to be selected");
        }
            else{
                component.set("v.openPnr",true);
                component.set("v.buttonTextValue","SendQuote");  
            }
    },
    
    sendQuoteWithoutFlightDetails : function(component,event,helper){
        
        var action = component.get("c.sendQuoteEmailToCustomer");
        var additionalDetails = component.find("addInfoWithoutFlights").get("v.value");
        
        if($A.util.isUndefinedOrNull(additionalDetails)){
            console.log('Entering if for additionalDetails');
            additionalDetails ='';
        }   
        
        console.log(component.get("v.recordId") + ' ' + component.get("v.consolidatedPriceToBeSent") + ' '+ component.get("v.selectedQuoteDetailsForStatusUpdate"));
        action.setParams({
            'recId' : component.get("v.recordId"),
            'previewQuote' : false,
            'consolidatedAmountToBeSent' : component.get("v.consolidatedPriceToBeSent"),
            'quoteDetailsIdToBeUpdated' : component.get("v.selectedQuoteDetailsForStatusUpdate"),
            'additionalInformation' : additionalDetails
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('statestatestate'+state);
            if(state === "SUCCESS"){
                helper.showToast(component, "Success!", "success", "The Quote details have been sent to the Account Holder");
                component.set("v.previewQuote",false);
                helper.redirectToTADOrderRecord(component,event,helper);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    sendPnr: function (component, event, helper)
    {
        
        var pnr= component.find("pnrVal").get("v.value");
        
        helper.callPNRandEmail(component,pnr,helper);
        
    },
    
    PreviewPnr: function (component, event, helper)
    {
        
        var pnr= component.find("pnrVal").get("v.value");
        console.log('pnr'+pnr);
        
        helper.callPNRandPreview(component,pnr,helper);
        
    },
    
    buttonDisable: function (component, event, helper)
    {
        var elem = event.getSource().get('v.value').length;
        if(elem==0){
            component.set("v.sendQuotePNREnable",true);
            component.set("v.disableBackButtonWithFlights",true);
        }
    },
    
    closeModal : function(component, event, helper)
    {
        console.log('##Start of CloseModal');
        helper.closeModal(component);
        
    },
    
    getSelectedName : function(component,event,helper){
        helper.rowSelectionOnLDT(component,event,helper);
    },
    
    getSelectedPaxName : function(component,event,helper){
        helper.rowSelectionOnLDTforPAX(component,event,helper);
    },
    
    getSelectedRows: function(component, event,helper) {
        var rows = component.get("v.selectedRows");
        console.log('rows:'+rows);
    },
    
    approveOC: function(component, event,helper) {
        helper.approveOCHelper(component,event,helper);
    },
    
    goBackToAdditionalDetailPopup : function(component,event,helper){
        component.set("v.previewQuote",false);
        component.set("v.quotePreviewString",null);
        component.set("v.disableBackButtonWithoutFlights",true);
        component.set("v.disableSendQuoteWithoutFlights",true);
    },
    
    goBackToAdditionalDetailFlightsPopup : function(component,event,helper){
        
        component.set("v.quotePreviewStringForflightData",null);
        component.set("v.sendQuotePNREnable",true);
        component.set("v.disableBackButtonWithFlights",true);
        component.set("v.previewFlightDetailsOfPNR",false);
    },
    
    redirectToTADOrder : function(component,event,helper){
        
        helper.redirectToOrder(component,event,helper);
        
    }
    
})