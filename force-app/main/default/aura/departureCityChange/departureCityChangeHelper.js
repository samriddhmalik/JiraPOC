({
    fetchOliAddonDataHelper : function(component, event, helper,recordId) {
        
        var action = component.get("c.getOliAddonDataApex");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.oliAddonData",result.oliAddonData);
                component.set("v.depCityOptions",result.depCityValues);
                component.set("v.depCityStopoverMap",result.depCityStopoverMap);
                component.set("v.hssAmountOriginal",result.citySurcharge);
                component.set("v.isPaymentRecived",result.isPaymentRecived);//PSAG - 229
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
    
    calculateRefundHelper : function(component, event, helper,oliAddonData) {
        
        var cityData = component.get("v.depCityOptions");
        var hssAmountOriginal = component.get("v.hssAmountOriginal");
        var newAmount=0;
        for(var i = 0; i < oliAddonData.length; i++){
            if(oliAddonData[i].type=='OLI'){
                for(var j = 0; j < cityData.length; j++){
                    if(cityData[j].value==oliAddonData[i].departureCity){
                        newAmount=newAmount+ (Number(cityData[j].citySurcharge)*Number(oliAddonData[i].paxQty)); 
                    } 
                }  
            } 
        } 
        console.log('newAmount'+newAmount);
        
        if(newAmount<hssAmountOriginal){
            component.set("v.refundAmount",hssAmountOriginal-newAmount);  
        }else{
            component.set("v.refundAmount",0);   
        } 
    },
    
    updateDepartureCityHelper : function(component, event, helper,mySpinner) {
        
        var cityData = component.get("v.oliAddonData");
        var refundAmount = component.get("v.refundAmount");
        var orderId = component.get("v.recordId");
        var resendBoolean = component.find("confirmationResendCheckbox").get("v.value");
        console.log('resendBoolean'+resendBoolean);
        
        
        var action = component.get("c.updateDepCityApex");
        action.setParams({
            'cityData': cityData,
            'refundAmount': refundAmount,
            'orderId': orderId,
            'resendPurchaseConfirmation': resendBoolean
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                this.showToast(component, "Success!", "success","dismissible","Departure City changed succesfully!");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }else if(state==="ERROR"){
                var errorMsg = action.getError()[0].message;
                this.showToast(component, "Error!", "error","dismissible",errorMsg); 
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