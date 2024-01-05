({
	init : function(component, event, helper) {
        console.log("Called");
        helper.fetchDetails(component,event,helper);
        helper.fetchOLIRec(component,event,helper);
	},
    
    collapseClose : function(component, event, helper) {
        console.log("collapseClose");
        component.set("v.isCollapsed",true);
        var toggle = component.find("orderSummary");
        $A.util.toggleClass(toggle, "toggle");
        $A.util.toggleClass(toggle, "layoutWidth");
	},
    
    collapseOpen : function(component, event, helper) {
        console.log("collapseOpen");
        component.set("v.isCollapsed",false);
        var toggle = component.find("orderSummary");
        $A.util.toggleClass(toggle, "toggle");
        $A.util.toggleClass(toggle, "layoutWidth");
        
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