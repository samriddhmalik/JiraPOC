({
	doInit : function(component, event, helper) {
		 var getSourceObject = component.get("v.sourceObject");
             if(getSourceObject == "Case")
            {
                component.set("v.btnlabel",'Back');
                
            }

        var tadDealId = component.get("v.dealId");
        let parentRecordId = component.get("v.tadOrderId");
        console.log('tadDealId---'+tadDealId);
        var action = component.get("c.fetchAddonRT");
        action.setParams({
               
                "dealId" : tadDealId,
               "orderId" : parentRecordId
                
            });
        action.setCallback(this, function(response){
            
            var result = response.getReturnValue();
            var state = response.getState();
             if(state === "SUCCESS"){
				component.set("v.recType",result);
				}
            
        });
         $A.enqueueAction(action);
            
      },
    
     navigateToRecord : function(component, event, helper) {   var getSourceObject = component.get("v.sourceObject");
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
        helper.navigateToRecord(component, event, helper);
         }
         
    }, 
       navigateToFlow : function(component, event, helper) {
        helper.navigateToFlow(component, event, helper);
         
    },
    
    
})