({
    getInitDetails : function(component, event, helper) {
        var recId = component.get("v.recordId");  
        var action = component.get("c.getInitialData");
        action.setParams({   
            "recordId" : recId   
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();  
            if(state === "SUCCESS"){
                component.set("v.mainWrapper",result);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCardDetails : function(component, event, helper){
        var resultsToast = $A.get("e.force:showToast");
        var mainWrap = component.get("v.mainWrapper");
        
        if(mainWrap.creditCardNumber == '' || mainWrap.creditCardNumber ==null){
            
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card number value"
            });
            resultsToast.fire();
            
        }else if(mainWrap.cardExpiryDate =='' || mainWrap.cardExpiryDate ==null ){
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card expiry date value"
            });
            resultsToast.fire();
            console.log('Please add card cardExpiryDate');
        }else if(mainWrap.creditCardCCV =='' || mainWrap.creditCardCCV ==null ){
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card ccv value"
            });
            resultsToast.fire();
            
        }else{
            var action = component.get("c.whichCC");
            action.setParams({   
                "payment" : mainWrap  
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();  
                
                console.log('result---'+JSON.stringify(result));
                console.log('result-Message--'+result.message);
                if(state === "SUCCESS"){
                    component.set("v.mainWrapper",result);
                    
                    if(result.isValidCard){
                        resultsToast.setParams({
                            "title": "Success!",
                            "message": "Update surcharge successfully"
                        });  
                    }else{
                        resultsToast.setParams({
                            "title": "Error!",
                            "message": result.message
                        });  
                    }
                    
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action);
            
        }
    },
    
    doPayment : function(component,event, helper){
        var mainWrap = component.get("v.mainWrapper");
        var resultsToast = $A.get("e.force:showToast");
        console.log('MainWrap----'+JSON.stringify(mainWrap));
        
        if(mainWrap.creditCardNumber =='' || mainWrap.creditCardNumber ==null){
            
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card number value"
            });
            resultsToast.fire();
            
        }else if(mainWrap.cardExpiryDate =='' || mainWrap.cardExpiryDate ==null){
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card expiry date value"
            });
            resultsToast.fire();
            console.log('Please add card cardExpiryDate');
        }else if(mainWrap.creditCardCCV =='' || mainWrap.creditCardCCV ==null){
            resultsToast.setParams({
                "title": "Error!",
                "message": "Please enter credit card ccv value"
            });
            resultsToast.fire();
            
        }else{
            component.set("v.IsSpinner",true);
            var action = component.get("c.makePayment");
            action.setParams({   
                "payment" : mainWrap  
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();  
                if(state === "SUCCESS"){
                    // component.set("v.mainWrapper",result);
                    console.log('result---'+JSON.stringify(result));
                    component.set("v.IsSpinner",false);
                    
                    resultsToast.setParams({
                        //"title": "Success!",
                        "message": result.message
                    });
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action);
            
        }
        
        
        
    },
    
       
})