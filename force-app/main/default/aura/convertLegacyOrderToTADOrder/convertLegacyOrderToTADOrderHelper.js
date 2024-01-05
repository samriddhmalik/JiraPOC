({
    getOrderDetails : function(component,event,helper){
        
        var recordId = component.get("v.recordId");
        console.log('recordId ===> '+recordId);
        
        var action = component.get("c.getTheLegacyOrderInitialDetails");
        action.setParams({
            "recId" : recordId
        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            console.log('recData'+JSON.stringify(result));
            component.set("v.orderInfo",result);
        });
        $A.enqueueAction(action);        
        
    },
    
    
    convertTADOrder : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.createTadOrder");
        action.setParams({
            "recId" : recordId
        });
        action.setCallback(this, function(response){
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('resultValue'+JSON.stringify(result));
            if(state == "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Order Successfully Created");
                component.set("v.orderInfo.button1",true);
                component.set("v.orderInfo.orderExists",result.orderExists);
                component.set("v.orderInfo.orderNumber",result.orderNumber);
                component.set("v.orderInfo.orderid",result.orderid);
                component.set("v.orderInfo.conversionError",result.errorMessage);
                component.set("v.orderInfo.conversionSuccess",result.successMessage);
                console.log('orderid'+component.get("v.orderInfo").orderid);
                
            }else{
                this.showToast(component, "error!", "error","dismissible","Order Creation Failed!"); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    convertOLIRecord : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.createOliRecord");
        action.setParams({
            "orderId" : recordId
        });
        action.setCallback(this, function(response){
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            if(state == "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","OLI Successfully Created");
                component.set("v.orderInfo.button2",true);
                component.set("v.orderInfo.conversionError",result.errorMessage);
                component.set("v.orderInfo.conversionSuccess",result.successMessage);
            }else{
                this.showToast(component, "error!", "error","dismissible","OLI Creation Failed!"); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    convertAddonRecord : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.createPAXandAddon");
        action.setParams({
            "orderId" : recordId
        });
        action.setCallback(this, function(response){
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            if(state == "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Addon Successfully Created");
                component.set("v.orderInfo.button3",true);
                component.set("v.orderInfo.conversionError",result.errorMessage);
                component.set("v.orderInfo.conversionSuccess",result.successMessage);
            }else{
                this.showToast(component, "error!", "error","dismissible","Addon Creation Failed!"); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    convertObjectRecord : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.createRemainingObject");
        action.setParams({
            "orderId" : recordId
        });
        action.setCallback(this, function(response){
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            if(state == "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Related Objects Successfully Created");
                component.set("v.orderInfo.button4",true);
                component.set("v.orderInfo.conversionError",result.errorMessage);
                component.set("v.orderInfo.conversionSuccess",result.successMessage);
            }else{
                this.showToast(component, "error!", "error","dismissible","Related Objects Creation Failed!"); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    convertpaymentRecord : function(component,event,helper){
        
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.createSurchargePaymentCoupon");
        action.setParams({
            "orderId" : recordId
        });
        action.setCallback(this, function(response){
            
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState();
            var result = response.getReturnValue();
            
            if(state == "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Payments Successfully Created");
                component.set("v.orderInfo.button5",true);
                component.set("v.orderInfo.conversionError",result.errorMessage);
                component.set("v.orderInfo.conversionSuccess",result.successMessage);
            }else{
                this.showToast(component, "error!", "error","dismissible","Payments Creation Failed!"); 
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
    
    closeModal : function(component,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})