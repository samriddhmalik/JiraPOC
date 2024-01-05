({
	 navigateToRecord : function(component, event, helper) {
        
        var workspaceAPI = component.find("workspace");
        var oldTab;
          var getSourceObject = component.get("v.sourceObject");
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
                    
                      console.log("getSourceObject",getSourceObject);
               
                
                if(getSourceObject == "Case"){
                    var compEvent = component.getEvent("sampleComponentEvent");
                    compEvent.setParams({
                        "message" : 'From AddOn',
                        "TadOrderId": tadOrdId
                    });
                    compEvent.fire();
                    
                }else{
                    
                    console.log("Resolve handler from tad by m--------"+tadOrdId);
                    	   var tadOrdId = component.get("v.tadOrderId");
        				   var navigateEvent = $A.get("e.force:navigateToComponent");
                           navigateEvent.setParams({
                           componentDef: "c:createNewOliOrAddonPopupComponent",
                           componentAttributes :{"gettingTheTADOrderRecordID": tadOrdId}
                           });
                           navigateEvent.fire(); 
                         console.log("Navigate fir --------"+tadOrdId); 
                }
                   
				})
                )
                .then(
                    // resolve handler
                    $A.getCallback(function(response) {
                          if(getSourceObject == "Case"){
                            
                        }else{
                          workspaceAPI.closeTab({tabId: oldTab});
                          console.log("Resolve handler from tab by m--------"+oldTab);
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            helper.closeWorkspaceHelper(component, event, helper, oldTab);
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                        }
                        
                	})
            	); 
    }, 
    
    closeWorkspaceHelper : function(component,event,helper, oldTab){
        var workspaceAPI = component.find("workspace");
        if(oldTab == '') {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
            	helper.checkLoading(component,event, helper, focusedTabId);
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
    
    getInsuranceType : function(component, event, helper) {
        
        
        var action = component.get("c.fetchInsuranceType");
        
        action.setCallback(this,function(response){
          
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state'+state);
              console.log('result--'+result);
            if(state === "SUCCESS"){
                component.set("v.insuranceType",result);
                     
            }
            
             });
            
            $A.enqueueAction(action);
            
    },
    
    	getCoverType : function(component, event, helper) {
        
        
        var action = component.get("c.fetchCoverType");
        
        action.setCallback(this,function(response){
          
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state'+state);
            console.log('result--'+result);
            
            if(state === "SUCCESS"){
                console.log('inside cover type');
                component.set("v.coverType",result);
                component.set("v.showNextScreen",true); 
                component.set("v.showThisNow",false); 
                     
            }
            
             });
            
            $A.enqueueAction(action);
            
    },
    
    validateAndSaveRecords : function(component,event,helper){
        
        var selectedinsurance = component.find("InsType").get("v.value");
        var selectedcover = component.find("CovType").get("v.value");
        var cost = component.get("v.inputCost");
        var selectedPaxAndPolicyNo = component.get("v.selectedPaxInfo");
        var oliId = component.get("v.orderLineItemId");
        console.log("selectedinsurance---"+selectedinsurance);
         console.log("selectedcover---"+selectedcover);
         console.log("cost---"+cost);
         console.log("selectedPaxAndPolicyNo---"+JSON.stringify(selectedPaxAndPolicyNo));
          console.log("oliId---"+oliId);
        
        if(selectedinsurance != '' && selectedcover != ''  && cost != null ){
            
            console.log('---inside if---');
            var action = component.get("c.saveInsuranceRecord");
            
            action.setParams({
                 
                "paxInfoList" : selectedPaxAndPolicyNo,
                "coverType" : selectedcover,
                "insuranceType" : selectedinsurance,
                "cost" : cost,
                "oliId" : oliId
            });
             console.log('outside set params--');
            action.setCallback(this, function(response){
                 console.log('inside callback--');
                 var state = response.getState();
                 var result = response.getReturnValue();
                 console.log('result--'+result);

                if(state === "SUCCESS"){
                    
             
                      component.set("v.showSuccessScreen",true);
                     component.set("v.showNextScreen",false);
                    component.set("v.tadOrderId",result);
            }
                
                console.log('statestate'+state);
              
				 });
            $A.enqueueAction(action);
            
        }else{
            
             this.showToast(component, "Error!", "error","dismissible","Ensure all required fields have been entered");
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
    

	
})