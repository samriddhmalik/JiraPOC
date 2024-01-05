({
    doInit : function(component, event, helper) {
        helper.getTadOrderDetails(component,event,helper);
    },
    
    handleChange : function(component, event, helper){
        helper.fetchChangedValues(component,event,helper);
    },
    
    sendApproval : function(component, event, helper){
        
        component.set("v.disableSubmitButton",true);
        var values = component.get("v.value");
        var otherReason = component.get("v.otherReason");
        var surchargeAmount = component.get("v.surchargeAmount");
        
        if(values.length === 0){
            helper.showToast(component, "Error!", "error","dismissible","You need to select an action to proceed!");
            component.set("v.disableSubmitButton",false);
        }else if(values.includes("Other") && (otherReason == '' || otherReason == null)){
            helper.showToast(component, "Error!", "error","dismissible","You must enter a reason if you're selecting other");
            component.set("v.disableSubmitButton",false);
        }else if(surchargeAmount == 0 || surchargeAmount < 0){
            helper.showToast(component, "Error!", "error","dismissible","Surcharge Amount must be greater than 0");
            component.set("v.disableSubmitButton",false);
        }else{
            helper.createTADSurchargeRecord(component,event,helper);
        }
    }
})