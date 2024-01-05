({
    getPassengerDetails : function(component, event) {
   
        var action = component.get("c.passengerHistoryDetails");
        action.setParams({
            "newPass": component.get("v.recordId")
         
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
              var records = response.getReturnValue();
                console.log('Line--11-->'+JSON.stringify(records));
                component.set("v.passList",records);
               
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