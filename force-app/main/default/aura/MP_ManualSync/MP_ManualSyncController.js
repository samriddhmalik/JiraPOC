({
	Confirm : function(component, event, helper) {
		helper.initiateCalloutToMicroservice(component, event, helper);
	},
    
    Cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire() 
    }
})