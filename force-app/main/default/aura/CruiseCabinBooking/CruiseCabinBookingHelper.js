({
    checkDealType:function(component,helper,event) {
        
       var portalName = $A.get("{!$Label.c.Merchant_Portal_Name}"); 
       var isMerchant = window.location.toString().includes(portalName);
        console.log('isMerchant'+isMerchant);
       
        var recId =component.get("v.recordId");
        console.log('recId:'+recId);
        var action = component.get("c.getOrderData");
        action.setParams({  recId : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state:'+state);
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                var stringItems = response.getReturnValue();
                component.set("v.proceed", stringItems.proceed);
                console.log('Cabins:'+stringItems.cabinQty);
                console.log('Is booked by PArtner::'+stringItems.cruiseCabinBookedByPartner);
                
                var isPArtnerBooked = stringItems.cruiseCabinBookedByPartner;
                if(isPArtnerBooked == true && isMerchant==true){
                    console.log('Entering if condition');
                    component.set("v.isCruisePartnerBooked",true);
                    component.set("v.merchantButton",true);
                }
                else{
                    component.set("v.isCruisePartnerBooked",false);
                }
                
                if(isMerchant==false){
                  component.set("v.merchantButton",false);  
                }
                
                
                this.fetchCompanyTypePicklist(component,event,helper);
                if(stringItems.proceed==true){
                    component.set("v.cabinQuantity",stringItems.cabinQty);
                   // component.find("cabinQuantity").set("v.value",stringItems.cabinQty);
                }
            }
        });
        $A.enqueueAction(action);	
    },
    
    fetchCompanyTypePicklist : function(component,event,helper){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Cruise_Cabin_Booking_POE__c",
            'field_apiname': "mp_Cruise_Company__c",
            'nullRequired': false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('State for Cusom Consultant NAme'+state);
            if (state === "SUCCESS"){
                
                component.set("v.lstOfCruiseCompany", a.getReturnValue());
               
            }
            });
        $A.enqueueAction(action);
    },
    
    searchHelper : function(component,event,getInputkeyWord) {
        console.log('getInputkeyWord: '+getInputkeyWord);
        var action = component.get("c.fetchLookUpValues"); 
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });   
        action.setCallback(this, function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse: '+JSON.stringify(storeResponse));
                if (storeResponse.length > 0) {
                    component.set("v.listOfSearchRecords", storeResponse);
                }                 
            }
            
        }); 
        $A.enqueueAction(action);
        
    },
    
    createCabins : function(component,helper,event) {
        
        var recId =component.get("v.recordId");
        var cruiseCabinRecord = component.get("v.cruiseCabinRecord");
        var cabinQuantity = component.get("v.cabinQuantity");
        var cabinNumbers = component.get("v.cabinNumbers");
        var partnerBooked = component.get("v.isCruisePartnerBooked");
        var cruiseCompanyName = component.find("cruiseCompanyPickList").get("v.value");
        console.log('partnerBooked'+partnerBooked);
        
        console.log('cabinInfo'+JSON.stringify(cruiseCabinRecord));
        console.log('cabinNumbers'+JSON.stringify(cabinNumbers));
       
        
        var action = component.get("c.createCabinRecord");
        action.setParams({  recId : recId,
                          cruiseCabinRecord : cruiseCabinRecord,
                          cabinQuantity : cabinQuantity,
                          cabinNumbers : cabinNumbers,
                          partnerBooked : partnerBooked });
        action.setCallback(this, function(response) {
            console.log('State:'+response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var stringItems = response.getReturnValue();
                if(stringItems=='cabinMismatch'){
                    this.showToast(component, "Error!", "error", "Cabin Numbers and Cabin Quantity doesn't match.");  
                }else{
                    component.set("v.isOpen", 'false');
                    this.showToast(component, "Success!", "success", "Cabin Record Successfully Created");
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();  
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showToast: function(component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message
        });
        toastEvent.fire();
    },
    
})