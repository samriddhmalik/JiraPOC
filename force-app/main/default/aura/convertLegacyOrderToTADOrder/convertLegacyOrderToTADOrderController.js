({
    doInit : function(component, event, helper){
        helper.getOrderDetails(component,event,helper);
    },
    
    convertTADOrder : function(component, event, helper){
        helper.convertTADOrder(component,event,helper);
    },
    convertOLIRecord : function(component, event, helper){
        if(component.get("v.orderInfo.button1")==true){
           helper.convertOLIRecord(component,event,helper);  
        }else{
           helper.showToast(component, "Error!", "error","dismissible","Please check previous buttons first.");
        }
    },
    convertAddonRecord : function(component, event, helper){
        if( (component.get("v.orderInfo.button1")==true) &&  (component.get("v.orderInfo.button2")==true) ){
           helper.convertAddonRecord(component,event,helper); 
        }else{
           helper.showToast(component, "Error!", "error","dismissible","Please check previous buttons first.");
        }
        
    },
    convertObjectRecord : function(component, event, helper){
        if((component.get("v.orderInfo.button1")==true) &&  (component.get("v.orderInfo.button2")==true) && (component.get("v.orderInfo.button3")==true)){
           helper.convertObjectRecord(component,event,helper);  
        }else{
           helper.showToast(component, "Error!", "error","dismissible","Please check previous buttons first.");
        }
    },
    convertpaymentRecord : function(component, event, helper){
        if((component.get("v.orderInfo.button1")==true) &&  (component.get("v.orderInfo.button2")==true)  &&  (component.get("v.orderInfo.button3")==true) &&  (component.get("v.orderInfo.button4")==true)){
          helper.convertpaymentRecord(component,event,helper); 
        }else{
           helper.showToast(component, "Error!", "error","dismissible","Please check previous buttons first.");
        }
    },
    
    closeModal : function(component, event, helper){
        helper.closeModal(component);   
    },
    
    navigateToRecord : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var index = component.get("v.orderInfo");
        console.log('index'+JSON.stringify(index));
        console.log('index1'+index.orderid);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": index.orderid,
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
})