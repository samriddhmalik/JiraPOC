({
    cloneDealHelper : function(component, event, helper) {
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.cloneDealApex");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.dealId",result.dealId);
                component.set("v.dealName",result.dealName);
            }else{
                 this.showToast(component, "Error!", "error","dismissible","Deal Cloning Failed!");  
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
    }
})