({
    init : function(cmp, event, helper) {
        var getSourceObject = cmp.get("v.sourceObject");
        if(getSourceObject == "Case")
        {
            cmp.set("v.btnlabel",'Back');
            
        }   
        // Figure out which buttons to display
        var availableActions = cmp.get('v.availableActions');
        for (var i = 0; i < availableActions.length; i++) {
            /*  if (availableActions[i] == "Cancel") {
            cmp.set("v.canCancel", true);
         }else */ if (availableActions[i] == "BACK") {
             cmp.set("v.canBack", true);
         } else if (availableActions[i] == "NEXT") {
             cmp.set("v.canNext", true);
         } else if (availableActions[i] == "FINISH") {
             cmp.set("v.canFinish", true);
             cmp.set("v.canCancel",false); 
         }
      }
      },
    
    onButtonPressed: function(cmp, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        // Fire that action
        var navigate = cmp.get('v.navigateFlow');
        navigate(actionClicked);
    },
    
    handleClose : function(component, event, helper) {
        var getSourceObject = component.get("v.sourceObject");
        var parentRecordId = component.get("v.tadOrderId");
        if(getSourceObject == "Case")
        {
            var compEvent = component.getEvent("sampleComponentEvent");
            compEvent.setParams({
                "message" : 'From AddOn',
                "TadOrderId": parentRecordId
            });
            compEvent.fire();
        }
        else{ 
            
            console.log('here in close')
            $A.get("e.force:closeQuickAction").fire();
            
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({tabId: focusedTabId});
            })
            .catch(function(error) {
                console.log(error);
            });
        }
    }
})