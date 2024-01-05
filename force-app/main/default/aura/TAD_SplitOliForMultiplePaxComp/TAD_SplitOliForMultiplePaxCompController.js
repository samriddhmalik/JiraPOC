({
    doInit : function(component, event, helper) {
        helper.getAvailableOliRecords(component, event);
    },
    getRequestedRecords  : function(component, event, helper){
        helper.getRequestedRecord(component, event, helper);
    },
    
    handlePaxChange: function(component, event, helper){
        var selectedOptionValue = event.getParam("value");
        component.set("v.SelectedpaxId", selectedOptionValue);
        var optionList = selectedOptionValue.toString().split(",");
        if($A.util.isEmpty(selectedOptionValue)){
            var cusSize =0;
        }else{
            var cusSize = optionList.length;            
        }
        component.set("v.newPaxCount", cusSize);
        var paxCount = component.get("v.defaultPaxCount");
        component.set("v.oldPaxCount", paxCount-cusSize);
    },
    
    doTheDmlForNewOli : function(component, event, helper){
        var oldModel =  component.find('oldPricingModel').get('v.value'); 
        var newModel =  component.find('newPricingModel').get('v.value'); 
        if(oldModel=='' || newModel==''){
            helper.showToast(component, "Error!", "error","dismissible","Pricing Model can't be blank."); 
        }else if(component.find('newPricingModel').get('v.value')!='' && component.find('oldPricingModel').get('v.value')!='' ){
            helper.validatePricingModelHelper(component, event, helper);
        }
    },

    closeModal : function(component,event,helper){
        $A.get("e.force:closeQuickAction").fire();
    }
    
    
    
})