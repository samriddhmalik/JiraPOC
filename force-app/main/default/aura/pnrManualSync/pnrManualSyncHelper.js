({
    initiateCalloutToMicroservice : function(component, event, helper){
        
        var recordId = component.get("v.recordId");
        console.log('recordId ==> '+recordId);
        
        var reasonForReSync = component.get("v.reasonValue");
        console.log('reasonForReSync ==> '+reasonForReSync);
        
        var action = component.get("c.makeCallOutToMicroservice");
        action.setParams({
            'recId': recordId,
            'reasonForSync': reasonForReSync
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State for requested Details'+state);
            var result = response.getReturnValue();
            
            if (state === "SUCCESS"){  
                console.log('Its a success.');
                console.log('response-----1243'+JSON.stringify(result) );
                console.log('responsejson'+JSON.stringify(response));
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "message": "Your record will be updated shortly"
                });
                resultsToast.fire();
                
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    }
})