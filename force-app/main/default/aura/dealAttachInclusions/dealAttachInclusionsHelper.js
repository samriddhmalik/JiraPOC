({
	getTheInitialData : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var action = component.get("c.getInitDetails");
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                if(result.isDealObject == false){
                    component.set("v.showBothField",true);
                }else{
                    component.set("v.showBothField",false);
                }
                component.set("v.initWrapper", result);
            }
        });
        $A.enqueueAction(action);  
	},
    
    createRow: function(component, listOfDealInclusions) {
        let dealInclusionObject = {};
        if(listOfDealInclusions.length > 0) {
            dealInclusionObject.index = listOfDealInclusions[listOfDealInclusions.length - 1].index + 1;
        } else {
            dealInclusionObject.index = 1;
        }
        dealInclusionObject.RecordTypeId = null;
        dealInclusionObject.Publishing_Inclusions__c  = null;
        dealInclusionObject.Text__c  = null;
        listOfDealInclusions.push(dealInclusionObject);
        component.set("v.listOfDealInclusions", listOfDealInclusions);
    }
})