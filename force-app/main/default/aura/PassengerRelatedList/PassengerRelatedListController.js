({
    //Get Related Docs
    doInit : function(component, event, helper) {
        helper.getPassengerDetails(component, event);
        var recordId = component.get("v.recordId");
        console.log('Lne--6-->'+recordId);
       
    },
     
    
})