({
    discardJournalHelper: function(component,event,helper){
        
        var journalIds = component.get("v.journalValueFromVf");
        var discardMessage = component.get("v.discardMessage");
        console.log('journalIds'+journalIds);
        component.set("v.displayError",'');
        component.set("v.displaySuccess",'');
        var action = component.get("c.discardJournalApex");
        action.setParams({
            "journalIds" : journalIds,
            "discardMessage" : discardMessage
        });
        
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('result'+result);
                if(result=='NotInProgress'){
                    component.set("v.displayError",'ERROR : Please make sure you have selected only In Progress journal');
                }else if(result=='NoAccess'){
                    component.set("v.displayError",'ERROR : Please make sure you have access to accounting company associated with the journal');
                }else if(result=='pass'){
                    component.set("v.displaySuccess",'SUCCESS : Journals discard scheduled succesfully!');
                }
            }
        });
        $A.enqueueAction(action);  
    },
    
    
})