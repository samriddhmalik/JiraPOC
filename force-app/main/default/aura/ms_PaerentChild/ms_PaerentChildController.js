({
getValueFromLwc : function(component, event, helper) {
    console.log('hiiiii 01');
		//component.set("v.inputValue",event.getParam('value'));
    console.log("this is value==>",event.getParam('value'));
     var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
     $A.get('e.force:refreshView').fire();
	},	
})