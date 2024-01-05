({
    doInit : function(component, event, helper) {
        helper.verifyUserRole(component, event, helper);
        helper.getpicklist(component, event, helper);
        component.set("v.AUD","AUD ");
    },
    
    handleCancel : function(component, event, helper){
        helper.closeQuickAction(component, event, helper);
    },
    
    handleSubmit : function(component, event, helper){
        helper.saveCancellation(component, event, helper);
    },
    
    //pbp-227
     // this function automatic call by aura:waiting event  
    showSpinner : function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
    //pbp-227
})