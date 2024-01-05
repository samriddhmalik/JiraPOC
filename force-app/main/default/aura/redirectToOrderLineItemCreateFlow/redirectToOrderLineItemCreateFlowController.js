({
    init : function(component, event, helper) {
        
        var checkIfParenRecordIdExists = component.get("v.parentRecordId");
        console.log('checkIfParenRecordIdExists'+checkIfParenRecordIdExists);
        
        var recordId = component.get("v.recordId");
        console.log('recordId'+recordId);
        
        if(!$A.util.isUndefinedOrNull(recordId) && $A.util.isUndefinedOrNull(checkIfParenRecordIdExists)){
            component.set("v.parentRecordId",recordId);
            component.set("v.quickActionRender",true);
            helper.verifyTheOrderStatus(component,event,helper,recordId);  
            //helper.callFlowNow(component, event, helper);  
        }else if(!$A.util.isUndefinedOrNull(checkIfParenRecordIdExists) && $A.util.isUndefinedOrNull(recordId)){
            console.log('The TAD Order Id already exists!');
            component.set("v.redirectrender",true);
            helper.callFlowNow(component, event, helper);	
        }else if($A.util.isUndefinedOrNull(checkIfParenRecordIdExists) && $A.util.isUndefinedOrNull(recordId)){  
            var pageRef = component.get("v.pageReference");
            console.log('pageRef'+pageRef);    
            var state = pageRef.state;
            var base64Context = state.inContextOfRef;
            
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            if(addressableContext!=null){
                component.set("v.parentRecordId", addressableContext.attributes.recordId);
                component.set("v.redirectrender",true);
                helper.callFlowNow(component, event, helper); 
            }   
        }else{
            console.log('It wont enter this ever!');
        } 
    },
    
    handleStatusChange : function (component, event,helper) {
        if(event.getParam("status") === "FINISHED") {
            
            var outputVar;
            var outputVariables = event.getParam("outputVariables");
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                console.log('outputVar '+JSON.stringify(outputVar));
                if(outputVar.name === "recordId") {
                    
                    var valueToBePassed = outputVar.value;
                    console.log('valueToBePassed'+valueToBePassed);
                    helper.navigateToPopup(component, event,helper,valueToBePassed);
                }
            }
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