({
    validateDiscardJournal : function(component,event,helper){
        helper.discardJournalHelper(component,event,helper);
    },
    
    redirectToView : function(component, event, helper) {
        window.history.back();
    }
})