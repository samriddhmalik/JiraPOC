({
    doInit : function(component, event, helper) {
        helper.getTheInitialData(component, event, helper);
    },
    
    addNewRow: function(component, event, helper) {
        let listOfDealInclusions = component.get("v.listOfDealInclusions");
        helper.createRow(component, listOfDealInclusions);
    },
    
    removeRow: function(component, event, helper) {
        let toBeDeletedRowIndex = event.getSource().get("v.name");
        let listOfDealInclusions = component.get("v.listOfDealInclusions");
        
        let newListOfDealInclusions = [];
        for (let i = 0; i < listOfDealInclusions.length; i++) {
            let tempRecord = Object.assign({}, listOfDealInclusions[i]); //cloning object
            if (tempRecord.index !== toBeDeletedRowIndex) {
                newListOfDealInclusions.push(tempRecord);
            }
        }
        
        for (let i = 0; i < newListOfDealInclusions.length; i++) {
            newListOfDealInclusions[i].index = i + 1;
        }
        
        component.set("v.listOfDealInclusions", newListOfDealInclusions);
    },
    
    removeAllRows: function(component, event, helper) {
        let listOfDealInclusions = [];
        helper.createRow(component, listOfDealInclusions);
    },
    
    createDealInclusions: function(component, event, helper) {
        
        /*var count = 0;
        var initWrapperObj = component.get("v.initWrapper");
        var getTheInclusionsList = component.get("v.listOfDealInclusions");
        for(var i = 0; i < getTheInclusionsList.length ; i++){
            if(getTheInclusionsList[i].RecordTypeId == initWrapperObj.highlightsRecordId){
                count = count + 1;
            }
        }
        
        var sum = count + initWrapperObj.countOfHighlightedInclusions;*/
        
       // if(sum < 5){
            let action = component.get("c.insertAttachedInclusions");
            action.setParams({
                "jsonOfListOfAttachedInclusions": JSON.stringify(component.get("v.listOfDealInclusions")),
                "recordId" : component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                let listOfDealInclusions = [];
                helper.createRow(component, listOfDealInclusions);
                const toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: "Deal Inclusions successfully created!",
                    type: "success",
                    duration: '2000',
                });
                toastEvent.fire();
            });
            $A.enqueueAction(action);
        }
        /* else{
            const toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: "You already have "+initWrapperObj.countOfHighlightedInclusions+" Attached Inclusions of Hightlight type. Max count is 4.",
                    type: "error",
                    duration: '5000',
                });
                toastEvent.fire();
        }
    }*/
    
})