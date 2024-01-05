({
    getTadOrderDetails : function(component,event,helper){
        var recId = component.get("v.recordId");
        var action = component.get("c.getInitDetails");
        action.setParams({
            "tadOrderID" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            
            if(state === "SUCCESS"){
                component.set("v.tadOrderNumber",result.tadOrderName);
                component.set("v.tadOrderCurrISOCode",result.tadCurrISOCode);
            } 
        });
        $A.enqueueAction(action);
    },
    
    fetchChangedValues : function(component,event, helper){
        var values = component.get("v.value");
        if(values.includes("AE/SB + 30 days") && values.length > 0){          
            component.set('v.surchargeAmount',150);
        }else{
            component.set('v.surchargeAmount',100);
        }
        
        if(values.length === 0){
            component.set('v.surchargeAmount',0);
        }
        
        if(values.includes("Other")){
            component.set("v.reasonForOtherBoolean",true);
        }else{
            component.set("v.reasonForOtherBoolean",false);
        }
    },
    
    createTADSurchargeRecord : function (component,event, helper){
        var values = component.get("v.value");
        var recId = component.get("v.recordId");
        var otherReason = component.get("v.otherReason");
        var surchargeAmount = component.get("v.surchargeAmount");
        var currencyISOCode = component.get("v.tadOrderCurrISOCode");
        
        var action = component.get("c.createTADSurchargeRecord");
        action.setParams({
            "tadOrderId" : recId,
            "listOfActions" : values,
            "otherReason" : otherReason,
            "surchargeAmount" : surchargeAmount,
            "currencyIsoCode" : currencyISOCode
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            var closeEvent = $A.get("e.force:closeQuickAction");
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Your TAD Surcharge Record has been created successfully.");
                closeEvent.fire();
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