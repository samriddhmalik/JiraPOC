({
    doInit : function(component, event, helper) {
        helper.loadAddOn(component);
    },
    
    navigateToRecord : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": index,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },  
})