({
    init : function(component, event, helper) {
        
        //     var a = component.get('c.callFlowNow');
        //      $A.enqueueAction(a);
        //      var url = window.location.href; 
        //    var value = url.substr(0,url.lastIndexOf('/') + 1);
        //   console.log('value'+value);
        
        var workspaceAPI = component.find("workspace");
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        if(addressableContext!=null){
            component.set("v.parentRecordId", addressableContext.attributes.recordId);
            console.log('AccountId'+JSON.stringify(addressableContext.attributes.recordId)); 
            var getAccountid = component.get("v.parentRecordId");
            console.log('getAccountid'+getAccountid);
            
            if($A.util.isUndefinedOrNull(getAccountid)){
                console.log('Its empty');
                var a = component.get('c.callFlowNow');
                $A.enqueueAction(a);
                
            }else{
                console.log('its not empty');
                helper.callTadOrderCreateFlow(component,event,helper);
            }
            
        }  
        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var tabId = response.tabId;                
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: 'Create New OLI 5'
            
            });
            
            workspaceAPI.setTabIcon({
                tabId: tabId, 
                icon: 'custom:custom90',
                iconAlt: 'order line item  c'
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        
    },
    
    callFlowNow : function(component,event,helper){
        console.log('Entering callFlowNow');
        var flow = component.find("flowId");
        // In that component, start your flow. Reference the flow's Unique Name.        
        flow.startFlow("Create_New_Order");
    },
    
    handleStatusChange : function (component, event) {
        if(event.getParam("status") === "FINISHED") {
            console.log('StoreNewlyCreatedTADOrderId '+JSON.stringify(event.getParam("outputVariables")));
            var outputVar;
            var outputVariables = event.getParam("outputVariables");
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                console.log('outputVar '+outputVar);
                if(outputVar.name === "StoreNewlyCreatedTADOrderId") {
                    component.set("v.storeTheTADOrderRecordId",outputVar.value);
                    component.set("v.isModalOpen",true);
                }
            }
        }
    },
    
    handleClose : function(component, event, helper) {
        
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        console.log('parentRecordId2'+parentRecordId);
        console.log('Entering handleClose now!');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });

        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": parentRecordId,
            "isredirect" : false,
            "slideDevName": "related"
        });
        urlEvent.fire();
        
    },
    
    submitDetailsToCallOLIFlow : function(component,event,helper){
        helper.callTheOLIFlow(component,event,helper);
    },
    
    loading : function(component,event,helper){
        component.set("v.isLoading",true);
    },
     
    loaded : function(component,event,helper){
    	component.set("v.isLoading",false);
    },
    
})