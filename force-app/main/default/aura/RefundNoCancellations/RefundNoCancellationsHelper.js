({
    verifyUserRole : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var recId = component.get("v.recordId");
        var action = component.get('c.verifyUser');
        action.setParams({
            "userId" : userId,
            "tadOrderId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.initWrapper",result);
                console.log('Result with all the data is : '+JSON.stringify(result));
                component.set("v.finalWrapper", result.finalWrapper);
                if(result.isValidUser == true){
                    component.set("v.validUserBoolean", true);
                    component.set("v.inValidUser", false);
                }else{
                    component.set("v.validUserBoolean", false);
                    component.set("v.inValidUser", true);
                }
            }
        });
        $A.enqueueAction(action);
        
        
       
    },
    
    getpicklist :function(component, event, helper)
    {
         var action = component.get("c.getPicklistvalues");
        action.setParams({
            "objectName" : 'order_line_item__c',
            "field_apiname" : 'Refund_Reason__c'
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('picklist'+JSON.stringify(result));
                component.set("v.addOnRefundReason",result); 
            } 
        });
        $A.enqueueAction(action);
    },
    closeQuickAction : function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    saveCancellation : function(component, event, helper){
        var finalWrapper = component.get("v.finalWrapper");
        console.log('finalWrapper -- > '+JSON.stringify(finalWrapper));
        console.log('finalWrapper.totalAmountOutstanding'+finalWrapper.totalAmountOutstanding);
        var initWrapper=component.get("v.initWrapper");
        
        var filledallrqrd=true;
        if(finalWrapper.addOnOrOLI=="None" || finalWrapper.addOnOrOLI=="" || finalWrapper.couponOrRefund=="None" || finalWrapper.couponOrRefund=="" ||finalWrapper.refundAmount==0.00 ){
            filledallrqrd=false;
              this.showToast(component, "Error!", "error","dismissible","Please Fill All The Required Fields!");
        }
        else if(finalWrapper.reasonOfRefund.startsWith("Customer")){
            filledallrqrd=false;
              this.showToast(component, "Error!", "error","dismissible","Wrong cancellation reason. All customer-reason cancellations must be processed through the ‘Request Cancellation’ action button!");
        }
        else if(finalWrapper.refundAmount<0.00){
            filledallrqrd=false;
              this.showToast(component, "Error!", "error","dismissible","Refund Can't Be Negative!");
        }
        if(filledallrqrd==true){
            component.set("v.disableafterFirstClick",true);
        var action = component.get('c.saveCancellationRecord');
        action.setParams({
            "finalWrap" : finalWrapper
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
           		console.log('result in saveCancellation ==>'+result);
                console.log('state in saveCancellation ==>'+state);
                this.showToast(component, "Success!", "success","dismissible","You have created a Cancellation record successfully.");
                helper.closeQuickAction(component, event, helper);
            }
        });
        $A.enqueueAction(action); 
        }
       
        
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