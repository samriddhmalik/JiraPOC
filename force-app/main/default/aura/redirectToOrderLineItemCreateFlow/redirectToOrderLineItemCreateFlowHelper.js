({
    
    reloadPreviousPage: function(component,event,helper){
        location.reload();
    },
    
    callFlowNow : function(component,event,helper){
      //  component.set("v.redirectrender",true);
        console.log('Entering callFlowNow');
        var flow = component.find("flowId");
        console.log("flow "+flow);
        var parentRecordId = component.get("v.parentRecordId");
        console.log('parentRecordId'+parentRecordId);
        var inputVariables = [
            {
                name : "recordId",
                type : "String",
                value : parentRecordId
            },
        ];
            
            // In that component, start your flow. Reference the flow's Unique Name.        
            flow.startFlow("Create_OrderLineItem",inputVariables);
            },
            
            navigateToPopup : function(component,event,helper,valueToBePassed){
                console.log('valueToBePassed'+valueToBePassed);
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
                            console.log('valueToBePassed1'+valueToBePassed);
                            var navigateEvent = $A.get("e.force:navigateToComponent");
                            navigateEvent.setParams({
                            componentDef: "c:createNewOliOrAddonPopupComponent",
                            componentAttributes :{"gettingTheTADOrderRecordID": valueToBePassed}
                            });
                            navigateEvent.fire();
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
            
    verifyTheOrderStatus : function(component,event,helper,tadOrderId){
            
        var action = component.get("c.fetchTadOrderStatus");
        action.setParams({
            "orderId" : tadOrderId
        });
         action.setCallback(this,function(response){
          
            var state = response.getState();
            var result = response.getReturnValue();         
            if(state === "SUCCESS"){
                   if(result == 'Cancelled'){
               console.log('cancel')
                   component.set("v.renderErrorMsgForCancelledOrder",true);
                   }/*else if(result == 'Price has changed.'){
            console.log('price')
                     component.set("v.renderErrorMsgForPriceChange",true);
                  }*/else{
             this.callFlowNow(component, event, helper,tadOrderId);
            }
            }
        });
        $A.enqueueAction(action);
       
        	
    }
})