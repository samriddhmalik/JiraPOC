({
    getDataToDisplay: function(component,event,helper){
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.fetchDataToDisplay");
        
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.recordsDataMerchant",result.recordsDataMerchant);
                component.set("v.recordsDataMerchantTerms",result.recordsDataMerchantTerms);
            }
        });
        $A.enqueueAction(action);  
    },
})