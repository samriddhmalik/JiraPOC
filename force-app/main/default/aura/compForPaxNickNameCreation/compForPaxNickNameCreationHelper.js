({
	calltheInitFlow : function(component,event,helper) {
        console.log("Calling helper");
		component.set("v.booleanToShow",true);
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
    
    createPaxRecords : function(component,event,helper){
        
        var oliId = component.get("v.orderLineItemId");
        var wrapperDataToBeSent = component.get("v.listOfNumbersForIteration");
        var tadOrderId = component.get("v.tadOrderId");
        
        var action = component.get("c.createPaxUsingNicknames");
        action.setParams({
            "paxCountAndNicknames" : wrapperDataToBeSent,
            "orderLineItemId" : oliId,
            "tadOrderId" : tadOrderId
        });
        
        action.setCallback(this,function(response){
          
            var state = response.getState();
            console.log('state'+state);
            
            if(state === "SUCCESS"){
                component.set("v.successMessageBoolean",true);
                component.set("v.booleanToShow",false);       
            }
        });
        $A.enqueueAction(action);
    },
    
    onButtonPressed: function(component, event, helper) {
      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();
      // Fire that action
      var navigate = component.get('v.navigateFlow');
      navigate(actionClicked);
   },
})