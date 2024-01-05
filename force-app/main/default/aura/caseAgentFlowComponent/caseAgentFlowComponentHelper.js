({
    
    
    getPaymentDetails : function(component,event,helper){
        console.log('result293');
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        console.log('result295==='+parentRecordId);
        
        var action = component.get("c.fetchAmmount");
        action.setParams({
            'ordId': parentRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('result303'+JSON.stringify(result));
                
                console.log('result303'+result.QFFUrl);
                component.set('v.iframeUrl',result.QFFUrl);
                this.getTheQantasUrl(component, event, helper);
                
            } 
            
        }
                          );
        $A.enqueueAction(action);  
    },
    
    
    getTheQantasUrl : function(component, event, helper){
        console.log('result 318');
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ABTest_AuraChildComp",
            componentAttributes: {
                iframeUrl : component.get("v.iframeUrl")
            }
        });
        evt.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    afterPayment : function(component, event, helper)
    {
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        var dealId = component.get("v.DealId");
        var dealName = component.get("v.DealName");
        var accId = component.get("v.AccountId");
        var accName = component.get("v.accountName");
        var caseId = component.get("v.caseID");
        var SavedDealID = component.get("v.SavedDealID");
        
        console.log("dealId===>62"+dealId);
        console.log("dealName===>62"+dealName);
        
        
        var action = component.get("c.fetchAmmount");
        action.setParams({
            'ordId': parentRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log("Result61===>62"+JSON.stringify(result));
                console.log("OutstandingAmount===>62"+result.OutstandingAmount);
                component.set("v.ammount",result.OutstandingAmount);
                
                console.log("v.ammount===>45"+component.get("v.ammount"));
                
            } 
            console.log("v.ammount===>47"+component.get("v.ammount"));
            
            
            if(component.get("v.ammount")>0)
            {
                component.set("v.isPaymentmethod",true);
                component.set("v.OpenIframe",false);
                component.set("v.couponComponent",false);
                
            }
            else{
                console.log("accId===>62"+accId);
                console.log("accName===>62"+accName);
                console.log("caseId===>62"+caseId);
                console.log("SavedDealID===>62"+SavedDealID);
                
                component.set("v.redirectrender1",true);
                component.set("v.couponComponent",false);
                component.set("v.OpenIframe",false);
                
                console.log('parentRecordId'+parentRecordId);
                var flow = component.find("flowId2");
                var inputVariables = [
                    {
                        name : "OrderId",
                        type : "String",
                        value : parentRecordId
                    },
                    {
                        name : "VarToStoreDealIdToBePassed",
                        type : "String",
                        value : dealId
                    },
                    {
                        name : "VarToStoreDealNameToBePassed",
                        type : "String",
                        value : dealName
                    },
                    {
                        name : "VarToStoreAccountIdToBePassed",
                        type : "String",
                        value : accId
                    },
                    {
                        name : "VarToStoreAccountNameToBePassed",
                        type : "String",
                        value : accName
                    },
                    {
                        name : "VarToStoreCaseIdToBePassed",
                        type : "String",
                        value : caseId
                    },
                    {
                        name : "VarToStoreSavedDealIdToBePassed",
                        type : "String",
                        value : SavedDealID
                    }
                ];
                
                // In that component, start your flow. Reference the flow's Unique Name.  
                console.log('line no====>60Helper'+JSON.stringify(inputVariables));      
                flow.startFlow("Case_Flow_For_Agent",inputVariables);
                
                
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
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
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
                    
                    var valueRecord = component.get("v.storeTheTADOrderRecordId");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    console.log('valueRecord -- '+valueRecord);
                    navEvt.setParams({
                        "recordId": valueRecord,
                        "slideDevName": "detail",
                        focus:true
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
    
    
    callThePaylineMethod : function(component, event, helper){
        var tadOrderId = component.get("v.storeTheTADOrderRecordId");
        var action = component.get("c.getThePaylineURL");
        action.setParams({
            'tadOrderRecordId': tadOrderId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('result result result Payline ==> '+result);
            if (state === "SUCCESS") {
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:ABTest_AuraChildComp",
                    componentAttributes: {
                        iframeUrl : result
                    }
                });
                evt.fire();
            }  
        });
        $A.enqueueAction(action);  
    }    
})