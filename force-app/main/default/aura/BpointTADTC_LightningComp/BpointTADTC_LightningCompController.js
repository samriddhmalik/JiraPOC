({
	doInit : function(component, event, helper) {
        console.log('Entering Init ==>');
        helper.getInitDetails(component,event,helper);
	},
    
    updateSurcharges : function(component, event, helper) {
        helper.getCardDetails(component,event,helper);
	},
    
     makeFinalPayment : function(component, event, helper) {
        helper.doPayment(component,event,helper);
	},
    
     closeModal : function(component, event, helper){
        
        var getSourceObject = component.get("v.sourceObject");
        var parentRecordId = component.get("v.recordId");
        if(getSourceObject == "Case")
        {
            var compEvent = component.getEvent("sampleComponentEvent");
            compEvent.setParams({
                "message" : 'From Paymethod Cancel',
                "TadOrderId": parentRecordId
            });
            compEvent.fire();
        }
     }
    
})