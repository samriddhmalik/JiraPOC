({
	getOliStatus : function(component, event, helper) {
        let recordId=component.get("v.recordId");
		var action = component.get('c.getOliStatus');
		action.setParams({orderId: recordId});
		action.setCallback(this, function(response){
			let state = response.getState();
			if(state ==='SUCCESS'){
				let oliStatus = response.getReturnValue();
                let showPartialoption = oliStatus.every(item => { return item.OLI_Status__c && item.OLI_Status__c == 'On Hold';});
				 component.set("v.showPartialoption",showPartialoption);
			}
		});
		$A.enqueueAction(action);
		
	},
    fetchOrderStaus : function(component, event, helper) {
        let recordId=component.get("v.recordId");
        var action = component.get('c.getOrderInfo');
        action.setParams({orderId: recordId});
        action.setCallback(this, function(response){
        	let state = response.getState();
			if(state ==='SUCCESS'){
				let orderStatus = response.getReturnValue();
                if(orderStatus[0].ordexp_master_status__c != 'Cancelled' && orderStatus[0].Total_Payment_Coupon__c >0){
                    component.set("v.showRefundNoCancellation",true);
                }else{
                    component.set("v.showRefundNoCancellation",false);
                }
			}
		});
		$A.enqueueAction(action);
    }
})