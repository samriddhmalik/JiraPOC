({
    
    fetchAllocationHelper: function(component,event,helper,recordId){
        console.log('recordId'+recordId);
        var action = component.get("c.getAllocationDataDateChange");
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('DoInitResult'+JSON.stringify(result.orderData));
                component.set("v.allocationData",result.allocationData);
                component.set("v.allocationYearMonthMap",result.yearMonthMap);
                component.set("v.tadOrderData",result.orderData);
                var returnValueClone = Object.assign({}, result.orderData);
                console.log('returnValueClone'+JSON.stringify(returnValueClone));
                component.set("v.originalTadOrderData",returnValueClone);
                component.set("v.originalTadOrderDataDate",result.orderData.ordexp_departure_date__r.date__c);
                component.set("v.originalDateRecord",result.orderData.ordexp_departure_date__c);
                component.set("v.hssAmount",result.hssSurcharge);
                component.set("v.orderInfoSection",result.orderInfoSection);
                component.set("v.nightInfo",result.nightInfo);
                component.set("v.isPaymentRecived",result.isPaymentRecived);//PSAG - 200
                
                var years = [];
                for ( var key in result.yearMonthMap ) {
                    years.push({text:key, value:key});
                }
                component.set("v.allocationYearList",years);
            }
        });
        $A.enqueueAction(action);  
    },
    
    getAeSbRecordsHelper : function(component, event, helper,tadOrderData) {
        console.log('tadOrderData1'+JSON.stringify(tadOrderData));
        var action = component.get("c.getAeSbRecordsApex");
        action.setParams({
            'tadOrderData': tadOrderData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.aeSbInfo",result);
            } 
        });
        $A.enqueueAction(action); 
    },
    
    updateTadOrderRecords : function(component, event, helper,tadOrderData) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var tadOrderData = component.get("v.tadOrderData");
        var resendPurchaseBoolean = false;
        
        var action = component.get("c.updateDDChangeRecordsApex");
        action.setParams({
            'tadOrderData': tadOrderData,
            'originalTadOrderDataDate' : null,
            'isCancel' : 'false'
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                //$A.get('e.force:refreshView').fire();
                component.set("v.refundAmount",result.refundAmount);
                component.set("v.outstandingAmount",result.outstandingAmount);
                component.set("v.prePostUpdate",true);
                component.set("v.isPaymentRecived",result.isPaymentRecived);//PSAG - 200
                
            }else if(state==="ERROR"){
                var errorMsg = action.getError()[0].message;
                this.showToast(component, "Error!", "error","dismissible",errorMsg); 
            } 
        });
        $A.enqueueAction(action); 
    },
    
    resetOrderStatus : function(component, event, helper,recordId) {
        
        var action = component.get("c.resetOrderStatusApex");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            } 
        });
        $A.enqueueAction(action); 
    },
    
    confirmTadOrderHelper : function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var tadOrderData = component.get("v.tadOrderData");
        var aesbData = component.get("v.aeSbInfo");
        var refundAmount = component.get("v.refundAmount");
        
        var action = component.get("c.confirmTadOrderApex");
        action.setParams({
            'tadOrderData': tadOrderData,
            'aesbData': aesbData,
            'refundAmount': refundAmount,
            'originalDepDate': component.get("v.originalDateRecord")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                
                this.showToast(component, "Success!", "success","dismissible","Departure date changed succesfully!");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            } 
        });
        $A.enqueueAction(action); 
    },
    
    closePopupRevertHelper : function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var originalTadOrderData = component.get("v.originalTadOrderData");
        var originalTadOrderDataDate = component.get("v.originalTadOrderDataDate");
        
        console.log('originalTadOrderData'+JSON.stringify(originalTadOrderData));
        console.log('originalTadOrderDataDate'+originalTadOrderDataDate);
        var action = component.get("c.updateDDChangeRecordsApex");
        action.setParams({
            'tadOrderData': originalTadOrderData,
            'originalTadOrderDataDate' : originalTadOrderDataDate,
            'isCancel' : 'true'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                
                this.showToast(component, "Success!", "success","dismissible","Departure date change Cancelled succesfully!");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire(); 
            } 
        }); 
        $A.enqueueAction(action); 
    },
    
    showToast: function(component, title, toastType,mode, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message,
            "mode":mode
        });
        toastEvent.fire();
    },
    
})