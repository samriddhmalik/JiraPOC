({
    prepopulateRequiredData: function(component,event,helper,recordId){
        
        var action = component.get("c.getRequiredData");
        action.setParams({
            "recId" : recordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.oliRecordData",result.oliData); 
                component.set("v.subOptionList",result.subOptionData);
                component.set("v.departureCityList",result.depCityData);
                component.set("v.paxNumberList",result.paxQtyList); 
                component.set("v.isSiteminder",result.isSiteminder);
                component.set("v.occupancyDetails",result.occupancyDetails);
            }
        });
        $A.enqueueAction(action);  
    },
    
    fetchAllocationHelper: function(component,event,helper,olData){
        
        console.log('olDataLog'+JSON.stringify(olData));
        var action = component.get("c.fetchAllocationApex");
        action.setParams({
            "olData" : olData
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                if($A.util.isEmpty(result)){
                    helper.showToast(component, "Error!", "error","dismissible","Allocation is not available for this subOption.");
                    component.set(" v.oliRecordData.subOptionId",'');
                }else{
                   component.set("v.AllocationData",result);  
                }
            }
        });
        $A.enqueueAction(action);  
    },
    
    saveOliRecord: function(component,event,helper,olData){
        
        var action = component.get("c.validateAllocation");
        action.setParams({
            "olData" : olData
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                var resp = response.getReturnValue();
                var mySpinner = component.find("mySpinner");
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                if(resp.errorState == 'error') {
                    var respError = resp.errorMessage;
                    var errorWrap = [];
                    var flag = false;
                    var label1 = $A.get("$Label.c.OrderLineItem_error_oneOrMore");
                    var label2 = $A.get("$Label.c.OrderLineItem_error_noOfAllocations");
                    errorWrap.push(label1);
                    errorWrap.push(label2);
                    for(var i=0;i<=errorWrap.length;i++) {
                        if(respError.includes(errorWrap[i])) {
                           component.set("v.showError",errorWrap[i]);
                            flag=true;
                        }
                    }
                    if(!flag) {
                        component.set("v.showError",respError);
                    }
                    console.log('set');
                }
                else {
                    component.set("v.showError",'');
                    component.set("v.numberOfTimesToIterate",result.paxQty);
                    component.set("v.orderLineItemId",result.oliId);
                    component.set("v.tadOrderId",result.orderId);
                    this.onButtonPressed(component, event, helper);
                    
                }
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
    onButtonPressed: function(component, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        
        // Fire that action
        var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
    },
    
    navigateToRecord : function(component, event, helper) {
        
        var workspaceAPI = component.find("workspace");
        var oldTab;
        workspaceAPI.getFocusedTabInfo().then(
                // resolve handler
                $A.getCallback(function(response) {
                    
            	oldTab = response.tabId;
                }),
         
                // reject handler
                $A.getCallback(function(error) {
                    console.log("Error ", error);
                })
            )
            .then(
                // resolve handler
                $A.getCallback(function(response) {
                    var oliRecordData = component.get("v.oliRecordData");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": oliRecordData.orderId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire(); 
				})
                )
                .then(
                    // resolve handler
                    $A.getCallback(function(response) {
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            helper.closeWorkspaceHelper(component, event, helper, oldTab);
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                        
                	})
            	); 
    }, 
    
    closeWorkspaceHelper : function(component,event,helper, oldTab){
        var workspaceAPI = component.find("workspace");
        if(oldTab == '') {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
            	helper.checkLoading(component,event, helper, focusedTabId);
            })
            .catch(function(error) {
                console.log(error);
            });
    	}
        else {
            	helper.checkLoading(component,event,helper, oldTab);
        }
    },
    
    checkLoading : function(component,event,helper, oldTab){
        var workspaceAPI = component.find("workspace");
        var isLoading = component.get("v.isLoading");
            if(isLoading) 
            {
                console.log('loading done');
                setTimeout(function(){ 
                    helper.checkLoading(component,event,helper, oldTab);
                 }, 100);      
            }
        	else {
                console.log('prepare closing Tab');
            	helper.closePrevTab(component,event,helper, oldTab, 20);
        	}
        
	},
    
    closePrevTab : function(component,event,helper, oldTab, iterate){ 
        var workspaceAPI = component.find("workspace");
		if(iterate > 0)
        {
             setTimeout(function(){ 
                 
                try
                {
                	console.log("Trying Tab Close");
                    workspaceAPI.closeTab({tabId: oldTab});
                }
                 catch(e){
                     console.log("Tab Closed");
                     iterate = 0;
                 }
                helper.closePrevTab(component,event,helper, oldTab, iterate - 1);
             }, 1000);
        }
    },
    
    loading : function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
    	component.set("v.isLoading",false);
    },
    
    loaded : function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
        $A.util.addClass(mySpinner, 'slds-hide');
        $A.util.removeClass(mySpinner, 'slds-show');
        component.set("v.isLoading",true);
    }
})