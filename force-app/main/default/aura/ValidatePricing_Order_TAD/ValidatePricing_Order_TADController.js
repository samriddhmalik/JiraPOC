({
    doInit: function (component, event, helper) {
        helper.oliPricingModel(component,helper,event);  // Populates Total amount, cabin Numbers , checks if Oli are correct
        //helper.addOnPricingModel(component,helper,event);
        helper.showSpinner(component);
        
    },
    
    close :function(){
        
        var closeEvent = $A.get("e.force:closeQuickAction");
        
        if(closeEvent){
            
            closeEvent.fire();
            
        } else{
            
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
            
        }
        $A.get('e.force:refreshView').fire();  
        
    },
    
    paymentFormOpen :function(component, event, helper){
        
        helper.redirectToPayment(component, event, helper); 
        
    },
    
    openSourceURL : function(component, event, helper){
        helper.getTheQantasUrl(component, event, helper);
    },
    
    openPaylineSourceURL : function(component, event, helper){
        helper.getThePaylineURL(component, event, helper);
    },
     PayTo : function(component, event, helper){
        helper.getThePaytoURL(component, event, helper);
    }
})