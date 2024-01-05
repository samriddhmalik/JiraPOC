({
    createOrderLineHelper : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        var action = component.get("c.createOrderLineApex");
        console.log('recId'+recId);
        action.setParams({
            "dealRecId" :  recId   
        });
        action.setCallback(this, function(response) {
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state == "SUCCESS") {
                this.showToast(component, "Success!", "success","dismissible","Order Lines records Synced successfully.");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else {
                this.showToast(component, "Error!", "error","dismissible","Order Lines records Sync failed.");
                
            }        
        });
        $A.enqueueAction(action);
    },
    
    checkAccessHelper : function(component,event,helper){
        
        var recId = component.get("v.recordId");
        var action = component.get("c.checkAccessUserApex");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result==true){
                component.set("v.disableButton",false);
            }else{
                component.set("v.disableButton",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
    createDtDtlRecordsHelper : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        var action = component.get("c.createDtDtlRecordsApex");
        console.log('recIdDt'+recId);
        
        action.setParams({
            "compRecId" :  recId  
        });
        action.setCallback(this, function(response) {
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state == "SUCCESS") {
                this.showToast(component, "Success!", "success","dismissible","DT and DTL records created successfully.");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else {
                this.showToast(component, "Error!", "error","dismissible","DT and DTL records creation failed");
            }        
        });
        $A.enqueueAction(action);
    },
    
    validateIfRecordsExist : function(component,event,helper){
        
        var recId = component.get("v.recordId");
        var action = component.get("c.validateIfRecordsExistApex");
        console.log('recIdDt'+recId);
        
        action.setParams({
            "compRecId" :  recId  
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result==3){
                this.showToast(component, "Error!", "error","dismissible","Component Pricing missing for the component.");
            }else if(result==1){
                component.set("v.createOLButton",false);
            }else if(result==2){
                component.set("v.createDTLButton",false);
            }else{
                this.showToast(component, "Error!", "error","dismissible","DT/DTL/OL records already exist for this Component.");
            }
            
        });
        $A.enqueueAction(action);
    },
    */
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