({
    
    switchTab : function(component,event,helper){
        
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
                    
                    var tadOrderId = component.get("v.gettingTheTADOrderRecordID");
                    console.log('TAD Order Id in create ADdOn Flow'+tadOrderId); 
                    
                    var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:createNewOliOrAddonPopupComponent",
                        componentAttributes :{"gettingTheTADOrderRecordID": tadOrderId}
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
    
    navigateToPopup : function(component,event,helper){
    	helper.switchTab(component,event,helper);    
        
    },
    
    callTheAddOnFlowNow : function(component,event,helper,tadOrderRecordId){

        component.set("v.gettingTheTADOrderRecordID",tadOrderRecordId);
        
        var flow = component.find("flowId");
        console.log("flow "+flow);
        
        var inputVariables = [
            {
                name : "recordId",
                type : "String",
                value : tadOrderRecordId
            },
        ];
            
            // In that component, start your flow. Reference the flow's Unique Name.        
            flow.startFlow("Create_New_AddOn_Updated",inputVariables);
    },
            
    verifyTheOrderStatus : function(component,event,helper,tadOrderId){
            
        var action = component.get("c.fetchTadOrderStatus");
        action.setParams({
            "orderId" : tadOrderId
        });
         action.setCallback(this,function(response){
          
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state'+state+result);
            
            if(state === "SUCCESS"){
            if(result == 'Cancelled'){
                 component.set("v.renderErrorMsgForCancelledOrder",true);
            	 
            }
            else{
            	this.callTheAddOnFlowNow(component,event,helper,tadOrderId);
            	
            	
            }
            }
        });
        $A.enqueueAction(action);
       
        	
    },
       //PBP - 215 Start
            
       verifyTheOrderSubStatus : function(component,event,helper,tadOrderId){
        	
            var action = component.get("c.OrderSubStatus");
        	action.setParams({
            "orderId" : tadOrderId
        	});
         action.setCallback(this,function(response){
          
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state'+state+result);
            
            if(state === "SUCCESS"){
            if(result == true){
                 component.set("v.renderErrorMsgForBC_SentOrders",true);
            }
            else{
            		this.verifyTheOrderStatus(component,event,helper,tadOrderId);
            }
            }
        });
           $A.enqueueAction(action);
    }, 
            
    //PBP-215 ended

})