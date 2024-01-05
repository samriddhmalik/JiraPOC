({
    getAvailableOliRecords : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.fetchAvailableOli");
        action.setParams({
            "tadOrderId" : recordId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS" && response.getReturnValue().recdata != null && response.getReturnValue().recdata  != ''){
                component.set("v.availableOli", true);
                component.set("v.noOli", false);
                var result = response.getReturnValue() ;
                console.log("result  "+JSON.stringify(result));
                component.set("v.availableOliList", result.recdata);
                component.set("v.isStay",result.isStay);
                console.log("isStay  "+component.get("v.isStay"));
            }else{
                component.set("v.noOli", true);
                component.set("v.availableOli", false);
            }
        });
        $A.enqueueAction(action); 
    },

    validatePricingModelHelper : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var selectedOliId = component.find('selectedId').get('v.value');
        var twinCount =0;
        if(component.find('newPricingModel').get('v.value')=='Twin'){
            twinCount = twinCount + component.get("v.newPaxCount");
        }
        if(component.find('oldPricingModel').get('v.value')=='Twin'){
            twinCount = twinCount + component.get("v.oldPaxCount");
        }
        
        console.log('twinCount'+twinCount);
        var action = component.get("c.validatePricingModelApex");
        action.setParams({
            "tadOrderId" : recordId,
            "oliId" : selectedOliId,
            "twinCount" :twinCount
        });
        action.setCallback(this, function(response) {
            console.log('response:'+response.getReturnValue());
            if(response.getState() === "SUCCESS" && response.getReturnValue() ==false){
                this.showToast(component, "Error!", "error","dismissible","There is a issue with pricing model make sure there are even twin passengers for selected suboption.");
            }else{
                var selectedPax = component.get("v.SelectedpaxId");
                this.splitOli(component,helper,selectedPax); 
            }
        });
        $A.enqueueAction(action); 
    },

    getRequestedRecord : function(comp, event, helper){
        comp.set("v.isSelected", true);
        var selectedOliId = comp.find('selectedId').get('v.value');
        console.log("selectedOliId "+selectedOliId);
        var listOfwrap = comp.get("v.availableOliList");
        listOfwrap.forEach(function myFunction(item, index){
            if(item.oliId == selectedOliId){
                comp.set("v.paxOptions",item.cusList);
                var cusSize = item.cusList.length;
                comp.set("v.oldPaxCount",cusSize);
                comp.set("v.defaultPaxCount",Number(cusSize));
            }
        });
        console.log("isStay  "+comp.get("v.isStay"));
    },
    
     splitOli :  function(component,helper, selectedPax){
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var selectedPax = component.get("v.SelectedpaxId");
        var recordId =  component.find('selectedId').get('v.value');
        var oldModel =  component.find('oldPricingModel').get('v.value'); 
        var newModel =  component.find('newPricingModel').get('v.value'); 
        console.log('selectedPax'+selectedPax+' '+'recordId'+recordId+' '+'oldModel'+oldModel+' '+'newModel'+newModel+' ');        
        var action=component.get("c.splitoliWithPax");
        action.setParams({
            selectedIds:selectedPax.toString(),
            oliId : recordId.toString(),
            newModel : newModel.toString(),
            oldModel : oldModel.toString()
        });
        action.setCallback(this,function(e){
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                console.log("result "+result);
                    this.showToast(component, "Success!", "success","dismissible","You have successfully splited the Order!");
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    $A.get('e.force:refreshView').fire();
                    dismissActionPanel.fire();
            }else{
                this.showToast(component, "Error!", "error","dismissible","There is a issue please contact System Admin.!");
            } 
        });
        $A.enqueueAction(action);
    },
    showToast: function(component, title, toastType,mode, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message,
            "mode":mode
        });
        toastEvent.fire();
    }
})