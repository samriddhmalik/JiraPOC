({
    getSourceURL : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var action = component.get("c.getIframeURL");
        action.setParams({
            "recordId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            
            if(state === "SUCCESS"){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:ABTest_AuraChildComp",
                    componentAttributes: {
                        iframeUrl : result
                    }
                });
                evt.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } 
        });
        $A.enqueueAction(action);
    }
})