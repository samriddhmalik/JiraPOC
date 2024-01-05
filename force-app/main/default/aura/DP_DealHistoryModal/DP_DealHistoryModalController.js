({
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModal: function(component, event, helper) { 
        component.set("v.isModalOpen", false);
    },
    
    openVFPage: function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        var dealID = component.get('v.recordId');
        window.open('/apex/DP_DealBuildHistoryPage?id='+dealID);
        dismissActionPanel.fire();
    },
    
    closeCmp: function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})