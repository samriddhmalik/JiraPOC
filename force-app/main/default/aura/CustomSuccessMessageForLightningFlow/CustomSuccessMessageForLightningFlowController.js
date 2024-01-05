({
	init : function(component, event, helper) {
		console.log('called');
	},
    
    handleClose : function(component, event, helper) {
        console.log('here in close')
        $A.get("e.force:closeQuickAction").fire();
        helper.switchTab(component,event,helper);
    },
    
    
})