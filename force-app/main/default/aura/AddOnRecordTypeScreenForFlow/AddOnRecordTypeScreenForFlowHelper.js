({
	 navigateToRecord : function(component, event, helper) {
        
        var workspaceAPI = component.find("workspace");
        var oldTab;
        workspaceAPI.getFocusedTabInfo().then(
                // resolve handler
                $A.getCallback(function(response) {
                    
            	oldTab = response.tabId;
                }),
         
                // reject handler
                $A.getCallback(function(error) {
                    console.log("Error ", error);
                })
            )
            .then(
                // resolve handler
                $A.getCallback(function(response) {
                    var tadOrdId = component.get("v.tadOrderId");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": tadOrdId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire(); 
				})
                )
                .then(
                    // resolve handler
                    $A.getCallback(function(response) {
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            helper.closeWorkspaceHelper(component, event, helper, oldTab);
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                        
                	})
            	); 
    }, 
    
    navigateToFlow : function(component, event, helper){
        
        var selectedVal = component.find("recordType").get("v.value");
        console.log("selectedVal--"+selectedVal);
        var proceed =true;
         if(selectedVal== ''){
            proceed =false; 
            this.showToast(component, "Error!", "error","dismissible","All visible fields must be filled.");
         }
        if(proceed ==true){
            
            component.set("v.selectedRT",selectedVal);
             console.log("selectedValRT--"+component.get("v.selectedRT"));
             this.onButtonPressed(component, event, helper);
        }
    },
    
     onButtonPressed: function(component, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        
        // Fire that action
        var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
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