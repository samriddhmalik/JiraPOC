({
    fetchActiveCity : function(component, event, helper) {
        var items = [];
        var recId = component.get("v.recordId");
        
        var action = component.get("c.fetchdepartureCity");
        action.setParams({
            "stopOverId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                if(response.getReturnValue() != null){
                    console.log('result Valid'+JSON.stringify(result));
                    component.set("v.recordsData",result);
                    result.forEach(function resultFunction(item, index){
                        console.log("item -- > "+item.CityName);       
                        var item = {
                            "label": item.CityName,
                            "value": item.recordId 
                        };
                        items.push(item);    
                        
                    });
                    component.set("v.options", items);
                    component.set("v.failFlag", false);
                    component.set("v.successFlag", true);
                    $A.util.addClass(component.find("warningMessage"), 'slds-hide');
                    $A.util.removeClass(component.find("warningMessage"), 'slds-show');
                }else{
                    component.set("v.failFlag", true);
                    component.set("v.successFlag", false);
                     $A.util.removeClass(component.find("warningMessage"), 'slds-hide');
                    $A.util.addClass(component.find("warningMessage"), 'slds-show');
                }
                
                //this.calculateRefundApproval(component, event, helper,result);
            }
        });
        $A.enqueueAction(action); 
        
    },
    createSubstopOverDeptCity :  function(component, event, helper){
        var list = component.get("v.values");
        var recId = component.get("v.recordId");
        console.log(" recId -- "+recId);
        var action = component.get("c.saveDepartureCityWithStopOver");
        action.setParams({
            "stopOverId" : recId,
            "deptCityList" : list
        });
        action.setCallback(this, function(response) {
            console.log("response  "+response.getState());
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Cities assigned to StopOver successfully!");
            	helper.close(component, event, helper);
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
    },
    close :function(){
        
        var closeEvent = $A.get("e.force:closeQuickAction");
        
        if(closeEvent){
            
            closeEvent.fire();
            
        } else{
            
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
            
        }
        $A.get('e.force:refreshView').fire();  
        
    }
})