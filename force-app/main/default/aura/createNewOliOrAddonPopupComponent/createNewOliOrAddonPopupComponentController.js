({
	submitDetailsToCallOLIFlow : function(component,event,helper){
    	helper.callTheOLIFlow(component,event,helper);
    },
    
    submitDetailsToCallAddOnFlow : function(component,event,helper){
        helper.callTheAddOnFlow(component,event,helper);
    },
    
    closeModal1 : function(component,event,helper){
        helper.closeModal(component,event,helper)
    },
    
    
    loading : function(component,event,helper){
        helper.loading(component,event,helper);
    },
     
    loaded : function(component,event,helper){
    	helper.loaded(component,event,helper);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var tabId = response.tabId;                
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: 'OLI and Add On'
            
            });
            
            workspaceAPI.setTabIcon({
                tabId: tabId, 
                icon: 'custom:custom90',
                iconAlt: 'New Record'
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
})