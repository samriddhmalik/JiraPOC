({
    doInit : function (component, event, helper){ 
        
        var recordId=component.get("v.recordId");
        helper.getOrderData(component, event, helper,recordId);
        helper.getOLIData(component, event, helper,recordId);
        
    },
    
    closePopup: function(component, event, helper) {
        console.log('Inside Close');
        var recordId=component.get("v.recordId");
        helper.resetOrderStatus(component, event, helper,recordId); 
    },
    temOrdStatusCntrl: function(component, event, helper) {
        console.log('Inside Close');
        var recordId=component.get("v.recordId");
        helper.temOrdStatus(component, event, helper,recordId); 
    },
    
})