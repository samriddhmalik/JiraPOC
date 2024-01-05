({
	doInit : function(component, event, helper) {
	
       
        var recivedPaxIdString = component.get("v.paxIdList");
        console.log('recivedPaxIdString--'+recivedPaxIdString);
         
			recivedPaxIdString = recivedPaxIdString.replace(/,\s*$/, "");
        console.log('After Trim--'+recivedPaxIdString);
        
        
        if(recivedPaxIdString != null || recivedPaxIdString != ''){
         console.log('Entering if now!');
         var action = component.get("c.fetchNickNames");
            action.setParams({
               
                "SelectedPaxIds" : recivedPaxIdString
                
            });
            action.setCallback(this, function(response){
                
                var result = response.getReturnValue();
                var state = response.getState();
                console.log('result result'+ JSON.stringify(result));
                
                if(state === "SUCCESS"){
				component.set("v.selectedPaxInfo",result);
				component.set("v.showThisNow",true);
				}
               
            });
            $A.enqueueAction(action);
         
        }  
	},
    
    nextScreen : function(component, event, helper) {
        
        helper.getInsuranceType(component,event,helper);
        helper.getCoverType(component,event,helper);
    },
     previousPolicyScreen : function(component, event, helper) {
        
       component.set("v.showNextScreen",false); 
       component.set("v.showThisNow",true); 
    },
    
    saveRecord : function(component,event,helper){
        
        helper.validateAndSaveRecords(component,event,helper);
    },
    closeModal : function(component, event, helper){
        
        $A.get("e.force:closeQuickAction").fire();
        helper.navigateToRecord(component, event, helper);
    },
    
    previousScreen : function(component,event,helper){
        // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();
      // Fire that action
      var navigate = component.get('v.navigateFlow');
      navigate(actionClicked);
    }
    

})