({
	  doInit : function (component, event, helper){ 
		 var recordId=component.get("v.recordId");
		 if(recordId){
			helper.getOliStatus(component);
            helper.fetchOrderStaus(component);
		 }
	},
    
    handleCancel : function(component, event, helper) {
		component.set('v.editChangeType',"")
	},
    handleClose : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
	},
})