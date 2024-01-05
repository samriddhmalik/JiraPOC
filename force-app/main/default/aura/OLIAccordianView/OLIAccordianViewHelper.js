({
	loadAddOn : function(component) {
                var oID = component.get("v.recordId");
        var action = component.get("c.getOLI");
        action.setParams({ orderId :  oID});
        action.setCallback(this, function(a) {
            component.set("v.accList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },	
})