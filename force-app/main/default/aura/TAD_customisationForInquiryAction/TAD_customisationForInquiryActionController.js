({
	init : function(component, event, helper) {
        
      /*  
         var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
         var addressableContext = JSON.parse(window.atob(base64Context));
        if(addressableContext !=null){
            component.set("v.parentRecordId", addressableContext.attributes.recordId);
             console.log('AccountId'+JSON.stringify(addressableContext.attributes.recordId)); 
        }*/
        var getAccountid = component.get("v.recordId");
            console.log('getAccountid'+getAccountid);
            var sobjectType = component.get("v.sobjecttype");
        console.log("sobjectType "+sobjectType)
            if($A.util.isUndefinedOrNull(getAccountid)  ){
                console.log('Its empty');
                var a = component.get('c.callFlowNow');
                $A.enqueueAction(a);
                
            }else{
                console.log('its not empty');
                helper.callTadOrderCreateFlow(component,event,helper,getAccountid);
            }
		
	},
     callFlowNow : function(component,event,helper){
        console.log('Entering callFlowNow');
        var flow = component.find("flowId");
        // In that component, start your flow. Reference the flow's Unique Name.        
        flow.startFlow("Create_Customisation_Enquiry_Case");
    },
    
    
    
   
})