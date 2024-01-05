({
    doinitHelper : function(component, event, helper) {
        var rec = component.get('v.recordId');
        console.log('rec '+rec);
        
        var action = component.get("c.Dealvalidationreport");
        action.setParams({
            "recordId" : rec
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            
            console.log('result for Approval History : '+JSON.stringify(result));
            
            if (state === "SUCCESS") {
                //PSAG-242 start
                if(JSON.stringify(result) != '[]' ){
                    component.set("v.suboptionData",result);
                    component.set("v.isSuccess",false);
                }else{
                    
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                //PSAG-242 End
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Congratulations, Deal has been Successfully Validated!",
                    "type": "success"
                });
                
                
            }else if(state === "ERROR"){
                component.set("v.isSuccess",false);
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error, Error in Deal Validation!",
                    "type": "error"
                });
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire(); 
            }
            toastEvent.fire(); 
            
        });
        $A.enqueueAction(action);  
    }
})