({
    getOrderData : function(component, event, helper,recordId) {
        
        var action = component.get("c.validateOrderStatusApex");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.proceedCheck",result.proceedCheck);
                component.set("v.changeStatus",result.changeStatus);
            } 
        });
        $A.enqueueAction(action); 
    },
    
    getOLIData : function(component, event, helper,recordId) {
        
        var action = component.get("c.validateOliStatusApex");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.proceedCheckOli",result);
            }
            console.log('getOLIData result '+result);
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
    temOrdStatus: function(component, event, helper,recordId) {

        var action = component.get("c.changeStatusToOnHold");
        action.setParams({
            'recId': recordId
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
    
})