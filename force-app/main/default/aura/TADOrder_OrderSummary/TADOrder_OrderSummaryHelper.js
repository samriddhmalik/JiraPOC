({
	fetchDetails : function(component, event, helper) {
		
        var action = component.get("c.fetchSummary");
        action.setParams({
            
            "recId" : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            console.log('STATEEE'+' '+state+' '+'RESULTTT'+JSON.stringify(result));
            
            if(state === "SUCCESS"){
                component.set("v.TADDetails",result);
            }          
        });
        
        $A.enqueueAction(action);
        
	},
    
    fetchOLIRec : function(component, event, helper) {
		
        var action = component.get("c.fetchOLIRec");
        action.setParams({
            
            "recId" : component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            console.log('STATEEE 2'+' '+state+' '+'RESULTTT'+JSON.stringify(result));
            
            if(state === "SUCCESS"){
                component.set("v.OLIDetails",result);
            }          
        });
        
        $A.enqueueAction(action);
        
	}
})