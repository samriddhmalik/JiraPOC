({
    doInit : function (component, event, helper){  
        var recordId=component.get("v.tadOrderId");
          var getSourceObject = component.get("v.sourceObject");
             if(getSourceObject == "Case")
            {
                component.set("v.btnlabel",'Back');
                
            }
        helper.prepopulateRequiredData(component, event, helper,recordId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log('all = '+JSON.stringify(response));
            
        });
        
        var getSourceObject = component.get("v.sourceObject");
             if(getSourceObject == "Case")
            {
                 
            }
            else
            {
        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var tabId = response.tabId;                
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: 'Create New OLI'
                
            });
            
            workspaceAPI.setTabIcon({
                tabId: tabId, 
                icon: 'custom:custom90',
                iconAlt: 'order line item  c'
            });
        })
        .catch(function(error) {
            console.log(error);
        });
                
                  }
    },
    
    fetchAllocation : function (component, event, helper){  
        var tadOrderData = component.get("v.oliRecordData");
        var isSiteminder = component.get("v.isSiteminder");
        
        if(isSiteminder==true){
            var occupancyDetails = component.get("v.occupancyDetails");
            var subOptionId = component.get("v.oliRecordData.subOptionId");
            for(var i = 0; i < occupancyDetails.length; i++ ){
                if(occupancyDetails[i].subOptionId==subOptionId){
                    component.set("v.occupancyDetailsView",occupancyDetails[i]); 
                    break;
                }
            }  
            
        }
        var subOptionId = component.get("v.oliRecordData.subOptionId");
        var subOptionList = component.get("v.subOptionList");
        for(var i = 0; i < subOptionList.length; i++ ){
            if(subOptionList[i].value==subOptionId){
                if(subOptionList[i].paxCount>1){
                    component.set("v.oliRecordData.isQty",true); 
                    component.set("v.oliRecordData.isStay",true); 
                }
                break;
            }
        } 
        
        helper.fetchAllocationHelper(component, event, helper,tadOrderData);
    },
    
    validateAndSaveOLI: function(component, event, helper) {
        var tadOrderData = component.get("v.oliRecordData");
        var isSiteminder = component.get("v.isSiteminder");
        var aldata = component.get("v.AllocationData");
        
        console.log('tadOrderData',JSON.stringify(tadOrderData));
        console.log('aldata',JSON.stringify(aldata));
        var remainingalloc='';
        if(tadOrderData.isQty==true){
            tadOrderData.pricingModel='QTY';
        }
        var departureCityList = component.get("v.departureCityList");
        var proceed =true;
        for(var i=0;i<aldata.length;i++){
            if(aldata[i].dateId==tadOrderData.ddDateId){
                remainingalloc=aldata[i].remainingAllocation;
                break;
            }
            
        }
        if(isSiteminder==true){
            tadOrderData.departureCityId = departureCityList[0].value;
        }
        
        if(tadOrderData.isStay==false && (tadOrderData.subOptionId==''||tadOrderData.departureCityId==''||tadOrderData.pricingModel=='' || tadOrderData.paxQty=='')){
            proceed =false; 
            helper.showToast(component, "Error!", "error","dismissible","All visible fields must be filled.");
        }
        else if(tadOrderData.isStay==true && (tadOrderData.subOptionId==''||tadOrderData.departureCityId==''||tadOrderData.pricingModel=='' || tadOrderData.quantity=='')){
            proceed =false; 
            helper.showToast(component, "Error!", "error","dismissible","All visible fields must be filled.");  
        }
            else if(Number(tadOrderData.quantity)>Number(remainingalloc)){
                proceed =false; 
                helper.showToast(component, "Error!", "error","dismissible","PaxQty must be less than remaining Allocation."); 
            }
        if(proceed ==true){
            var mySpinner = component.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
            helper.saveOliRecord(component, event, helper,tadOrderData);
        } 
    },
    updateDateValue: function(component, event, helper) {
        var oliRecordData = component.get("v.oliRecordData");
        var allocationData = component.get("v.AllocationData");
        
        if(oliRecordData.allocationBy=='Deal'||oliRecordData.allocationBy=='Option'){
            if(oliRecordData.ddDateValue!=allocationData[0].dateValue){
                helper.showToast(component, "Error!", "error","dismissible","Allocation Not Available for this Departure Date");      
                oliRecordData.paxQty= '';
            }else{
                oliRecordData.ddDateId= allocationData[0].dateId;
            }
        }else if(oliRecordData.allocationBy=='Sub option'){
            if(oliRecordData.ddDateValue!=allocationData[0].dateValue){
                helper.showToast(component, "Error!", "error","dismissible","Allocation Not Available for this Departure Date");      
                oliRecordData.paxQty= '';
            }else{
                oliRecordData.ddDateId= allocationData[0].dateId;
            }
        }
        component.set("v.oliRecordData",oliRecordData);  
    },
    
    navigateToRecord : function(component, event, helper) {
         //  113 to 124 for case flow
        var parentRecordId = component.get("v.tadOrderId");
         
          var getSourceObject = component.get("v.sourceObject");
             if(getSourceObject == "Case")
            {
                 var compEvent = component.getEvent("sampleComponentEvent");
             compEvent.setParams({
            "message" : 'From OLI',
            "TadOrderId": parentRecordId
        });
        compEvent.fire();
            }
        else{
        helper.navigateToRecord(component, event, helper);
            
        }
        
    }, 
    
    loading : function(component,event,helper){
        helper.loading(component,event,helper);
    },
    
    loaded : function(component,event,helper){
        helper.loaded(component,event,helper);
    },
    
})