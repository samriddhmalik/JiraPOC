({
    getOrder: function(component,event,helper){
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.getOrder");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('result.name',result.name);
                component.set("v.Name",result.name);
                component.set("v.price",result.price);
                component.set("v.outstanding",result.outstanding);
                if(!$A.util.isUndefined(result.name)){
                    component.set("v.showrecords",true);
                }
                else{
                    component.set("v.showmessage",true);
                }
            }
            else{
                console.log('result.name');
            }
        });
        $A.enqueueAction(action);  
    },
    expiretad : function(component,event,helper){
        
        var recId = component.get("v.recordId");
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        var action = component.get("c.expireOrder");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('order expired succesfully');
                this.showToast(component, "Success!", "success","dismissible","You have expired the Order!.");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }
            else{
                
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