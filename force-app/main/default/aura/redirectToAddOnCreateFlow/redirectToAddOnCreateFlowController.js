({
		init : function(component, event, helper) {
		
        console.log('Entering callFlowNow with OLI Id');
        var workspaceAPI = component.find("workspace");
        var gettingTheTADOrderRecordID = component.get("v.gettingTheTADOrderRecordID");
        console.log('gettingTheTADOrderRecordID'+gettingTheTADOrderRecordID);
        if($A.util.isUndefinedOrNull(gettingTheTADOrderRecordID)){
            component.set("v.quickActionRender",true);
            console.log('entering if');
            var reId = component.get("v.recordId");
            //PBP - 215 Start
            //helper.verifyTheOrderStatus(component,event,helper,reId);    
            helper.verifyTheOrderSubStatus(component,event,helper,reId);
            //PBP - 215 Stop
        }else{
            component.set("v.redirectrender",true);
            console.log('entering else');
            helper.callTheAddOnFlowNow(component,event,helper,gettingTheTADOrderRecordID);
        }
        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var tabId = response.tabId;                
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: 'Create New Add On'
            
            });
            
            workspaceAPI.setTabIcon({
                tabId: tabId, 
                icon: 'custom:custom83',
                iconAlt: 'AddOn  c'
            });
        })
        .catch(function(error) {
            console.log(error);
        });
	},
    
    
    handleStatusChange : function (component, event,helper) {
        if(event.getParam("status") === "FINISHED") {
        	helper.navigateToPopup(component, event,helper);
       
        }
    },
    
    loading : function(component,event,helper){
        component.set("v.isLoading",true);
    },
     
    loaded : function(component,event,helper){
    	component.set("v.isLoading",false);
    },
    
    closeModal : function(component,event,helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire(); 
    }
 
})