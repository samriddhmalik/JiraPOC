({
    switchTab : function(component,event,helper, level){
        
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
                    
                    if( level == 'OLI') {
                        var tadOrderId = component.get("v.gettingTheTADOrderRecordID");
                        console.log('tadOrderId'+tadOrderId);
                        var navigateEvent = $A.get("e.force:navigateToComponent");
                            navigateEvent.setParams({
                            componentDef: "c:redirectToOrderLineItemCreateFlow",
                            componentAttributes :{"parentRecordId": tadOrderId}
                            });
                        navigateEvent.fire();
                    }
                    else if( level == 'AddOn') {
                        var tadOrderId = component.get("v.gettingTheTADOrderRecordID");
                        console.log('tadOrderId'+tadOrderId);
                        var navigateEvent = $A.get("e.force:navigateToComponent");
                            navigateEvent.setParams({
                            componentDef: "c:redirectToAddOnCreateFlow",
                            componentAttributes :{"gettingTheTADOrderRecordID": tadOrderId}
                            });
                            navigateEvent.fire();
                        
                    } else if(level == 'closeModal') {
                        
                        var parentRecordId = component.get("v.gettingTheTADOrderRecordID");
                        var urlEvent = $A.get("e.force:navigateToSObject");
                        urlEvent.setParams({
                            "recordId": parentRecordId,
                            "isredirect" : false,
                            "slideDevName": "related",
                            focus:true
                        });
                        urlEvent.fire();
                    }
                    
                    
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
                workspaceAPI.closeTab({tabId: focusedTabId});
                //location.reload();
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
                    //location.reload();
                }
                 catch(e){
                     console.log("Tab Closed");
                     iterate = 0;
                 }
                helper.closePrevTab(component,event,helper, oldTab, iterate - 1);
             }, 1000);
        }
    },
    
    callTheOLIFlow : function(component,event,helper){
      
        helper.switchTab(component,event,helper,'OLI');
        
    },
    
    callTheAddOnFlow : function(component,event,helper){
        
        helper.switchTab(component,event,helper,'AddOn');
        
    },
    
    closeModal : function(component,event,helper){
        helper.switchTab(component,event,helper, 'closeModal');
    },
    
    loading : function(component,event,helper){
        component.set("v.isLoading",true);
        var counter = component.get("v.counter");
        counter = counter + 1;
        component.set("v.counter",counter);
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
    },
    
    loaded : function(component,event,helper){
    	component.set("v.isLoading",false);
        var counterAtCall = component.get("v.counter");
        component.set("v.showModal",true);
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        setTimeout(function(){ 
            var isLoading = component.get("v.isLoading");
            var counterNow = component.get("v.counter");
            if(isLoading != true && counterAtCall == counterAtCall) {
                var mySpinner = component.find("mySpinner");
                $A.util.addClass(mySpinner, 'slds-hide');
                $A.util.removeClass(mySpinner, 'slds-show');
            }
            else {
                helper.doneLoading(component,event,helper);
            }
                
        }, 1000);
        
    },
                   
    doneLoading : function(component,event,helper){ 
        setTimeout(function(){ 
            var mySpinner = component.find("mySpinner");
        	$A.util.addClass(mySpinner, 'slds-hide');
        	$A.util.removeClass(mySpinner, 'slds-show');
        }, 10000);
        
    }                
    
})