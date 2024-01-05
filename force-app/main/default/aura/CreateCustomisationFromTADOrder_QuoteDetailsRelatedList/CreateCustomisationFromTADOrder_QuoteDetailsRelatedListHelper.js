({
    decline : function(component, event, helper, requestStatus) {
        var index = component.get("v.currentIndex");
        var recordList = component.get("v.recordList");
        recordList[index].requestStatus = requestStatus;
        recordList[index].merchantQuoteDetailsEditabale = false;
        recordList[index].merchantDeclineReasonEditabale = true;
        recordList[index].quoteAvailableForEditabale = false;
        recordList[index].merchantPriceEditabale = false;
        component.set("v.recordList",recordList);
    },
    
    accept : function(component, event, helper, requestStatus) {
        var index = component.get("v.currentIndex");
        var recordList = component.get("v.recordList");
        recordList[index].requestStatus = requestStatus;
        recordList[index].merchantQuoteDetailsEditabale = true;
        recordList[index].merchantDeclineReasonEditabale = false;
        recordList[index].quoteAvailableForEditabale = true;
        recordList[index].merchantPriceEditabale = true;
        component.set("v.recordList",recordList);
    },
    
    resetEdit : function(component, event, helper, index) {
        var recordListBackup = component.get("v.recordListBackup");
        var recordList = component.get("v.recordList");
        recordList[index].requestStatusEditabale = false;
        recordList[index].merchantQuoteDetailsEditabale = false;
        recordList[index].merchantDeclineReasonEditabale = false;
        recordList[index].quoteAvailableForEditabale = false;
        recordList[index].merchantPriceEditabale = false;
        component.set("v.recordList",recordList);
    },
    
    openTheModal : function(component,event,helper){
        component.set("v.isModalOpen",true);
    },
    
    updateTheQuoteDetailRecord : function(component,event,helper){
        var getTheObjectDetail = component.get("v.recordListSingle");
        console.log('getTheObjectDetail'+JSON.stringify(getTheObjectDetail));
               
            console.log('Entering else');
            var action = component.get("c.updateTheQuoteDetail");
            action.setParams({
                'qdWrapper': getTheObjectDetail
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                console.log('STATE FOR COMPONENT TYPE RETURN'+state);
                if (state === "SUCCESS"){
                    component.set("v.isModalOpen",false);
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action); 
        
    },
    
    fetchPicklistValuesForAvailableFor : function(component,event,helper){
        
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "mp_Quote_Detail_POE__c",
            'field_apiname': "Available_For__c",
            'nullRequired': true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('STATE FOR COMPONENT TYPE RETURN'+state);
            if (state === "SUCCESS"){
                component.set("v.quoteDetailAvailableForPicklist", result);
                console.log('RESULTSSS FOR COMPONENT TYPES'+JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
    },
    
  /*  fetchPicklistValuesForQuoteStatus : function(component,event,helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "mp_Quote_Detail__c",
            'field_apiname': "Quote_Approval_Status__c",
            'nullRequired': true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('STATE FOR COMPONENT TYPE RETURN'+state);
            if (state === "SUCCESS"){
                component.set("v.quoteDetailStatusPicklist", result);
                console.log('RESULTSSS FOR COMPONENT TYPES'+JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
    },  */
    
    showToast: function(component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message
        });
        toastEvent.fire();
    },
    
})