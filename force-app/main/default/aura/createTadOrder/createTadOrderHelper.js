({
    getAccountDetails : function(component, event, helper,getAccountid,tadOrderData,iscase) {
        
        var action = component.get("c.fetchAccountDetailsApex");
        action.setParams({
            'getAccountid': getAccountid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('ACCresult'+JSON.stringify(result));
                
                if(result.ShippingPostalCode==null ||  result.ShippingPostalCode==''){
                    component.set("v.showPostal",true);
                     component.set("v.postcodeValidity",false);
                }else{
                    component.set("v.showPostal",false);
                     component.set("v.postcodeValidity",true);
                }
                
                if(iscase=='nonCase'){
                    component.set("v.accountName", result.Id);
                    var tadOrderData = {'recordType': 'TAD','accountId': result.Id,'accountName':result.Name,'dealId': '','dealName': '','optionId': '','departureDateId': '','departureDateName': '','startDateSiteMinder': null,'endDateSiteMinder': null}; 
                    component.set("v.tadOrderData",tadOrderData);
                    component.set("v.isAccount", true);  
                }
                
            } 
        });
        $A.enqueueAction(action); 
    },
    
    fetchDealRecordsHelper : function(component, event, helper,getInputkeyWord) {
        
        var recordTypeValue = component.get("v.tadOrderData").recordType;
        console.log('tadRecord'+recordTypeValue);
        var action = component.get("c.fetchDealValuesApex");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'recordTypeValue':recordTypeValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.searchedDeal", storeResponse);
            } 
        });
        $A.enqueueAction(action); 
    },
    
    fetchAccountRecordsHelper : function(component, event, helper,getInputkeyWord) {
        
        var action = component.get("c.fetchAccountValuesApex");
        action.setParams({
            'searchKeyWord': getInputkeyWord
           });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.searchedAccount", storeResponse);
            } 
            var searchedAccountHelper = component.get("v.searchedAccount", storeResponse);
            console.log('Line66 '+JSON.stringify(searchedAccountHelper));
        });
        $A.enqueueAction(action); 
    },
    
    getAvailableOptions: function(component,event,helper,dealId){
        
        var tadRecord = component.get("v.tadOrderData");
        
        var action = component.get("c.getAvailableOptionsApex");
        action.setParams({
            "dealId" : dealId,
            "recordType" : tadRecord.recordType
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.optionsList",result.relatedFieldsList);
                component.set("v.allocationBy",result.dealAllocationBy);
                component.set("v.isSiteMinder",result.isSiteMinder);
                if(result.dealAllocationBy=='Deal'){
                    this.fetchAllocationHelper(component,event,helper,result.dealAllocationBy);   
                }
                
            }
        });
        $A.enqueueAction(action);  
    },
    
    fetchAllocationHelper: function(component,event,helper,allocationBy){
        console.log('fetch allocation1'+allocationBy);
        var tadOrderData = component.get("v.tadOrderData");
        console.log('tadOrderData1'+JSON.stringify(tadOrderData));
        var action = component.get("c.getAllocationData");
        action.setParams({
            "allocationBy" : allocationBy,
            "tadOrderDataRec" : tadOrderData
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.subOptionValuesList",result.subOptionValues);
                component.set("v.allocationData",result.allocationData);
                component.set("v.allocationYearMonthMap",result.yearMonthMap);
                
                var years = [];
                for ( var key in result.yearMonthMap ) {
                    years.push({text:key, value:key});
                }
                  console.log('years'+JSON.stringify(years));
                component.set("v.allocationYearList",years);
            }
        });
        $A.enqueueAction(action);  
    },
    
    saveTadOrder: function(component,event,helper,tadOrderData){
        var isSiteMinder = component.get("v.isSiteMinder");
        
        console.log('tadOrderData',tadOrderData);
        var action = component.get("c.saveTadOrderApex");
        action.setParams({
            "tadOrderDataRec" : tadOrderData,
            "isSiteMinder" : isSiteMinder,
            "postalCode" : component.get("v.postalCode")
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                var mySpinner = component.find("mySpinner");
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                component.set("v.storeTheTADOrderRecordId",result);
                var action1 = component.get("c.TagOrderToSavedDeal");
        action1.setParams({
            "tadOrderId" : component.get("v.storeTheTADOrderRecordId"),
            "SavedDealId" : component.get("v.SavedDealID")
        });
        action1.setCallback(this, function(response) {
     });
        $A.enqueueAction(action1);  
            }
        });
        $A.enqueueAction(action);  
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
    
    callTheOLIFlow : function(component,event,helper){
        
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
                ).then(
                // resolve handler
                $A.getCallback(function(response) {
                    
                    var tadOrderId = component.get("v.storeTheTADOrderRecordId");
                    var navigateEvent = $A.get("e.force:navigateToComponent");
                    navigateEvent.setParams({
                        componentDef: "c:redirectToOrderLineItemCreateFlow",
                        componentAttributes :{"parentRecordId": tadOrderId},
                        focused: true
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
                setTimeout(function(){ 
                    helper.checkLoading(component,event,helper, oldTab);
                 }, 1000);      
            }
        	else {
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
    
    validateSiteminderStartDate : function(component,event,helper,tadOrderData){
        console.log('Getting TadOrderData --- > '+JSON.stringify(tadOrderData));
        
    }
    
    
})