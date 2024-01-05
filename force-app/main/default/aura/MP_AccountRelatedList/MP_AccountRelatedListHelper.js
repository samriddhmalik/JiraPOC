({
    getPurchaserDetails : function(component, event) {
   
        var action = component.get("c.accountHistoryDetails");
        action.setParams({
            "newAcc": component.get("v.recordId")
         
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
              var records = response.getReturnValue();
                console.log('Line--11-->'+JSON.stringify(records));
                component.set("v.accList",records);
               
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
     
    
})