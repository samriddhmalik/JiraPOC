({
    doInit : function (component, event, helper){ 
        var recordId=component.get("v.recordId");
        helper.fetchAllocationHelper(component, event, helper,recordId);  
    },
    
    getMonths: function(component, event, helper) {
        var allocationYear = component.get("v.allocationYear");
        var allocationYearMonthMap = component.get("v.allocationYearMonthMap");
        console.log('allocationYearMonthMap'+JSON.stringify(allocationYearMonthMap));
        var months=[];
        for ( var key in allocationYearMonthMap ) {
            if(key==allocationYear){
                var recordYear = allocationYearMonthMap[key];
                for ( var key1 in recordYear ) {
                    months.push({text:recordYear[key1], value:key1});  
                }
            }
        }
        component.set("v.allocationMonthList",months);
        component.set("v.filteredAllocationData",null);
    },
    
    filterAllocation: function(component, event, helper) {
        var allocationYear = component.get("v.allocationYear");
        var allocationMonth = component.get("v.allocationMonth");
        var allocationData = component.get("v.allocationData");
        
        var allocation=[];
        for(var i = 0; i < allocationData.length; i++){
            if(allocationData[i].allocationMonth==allocationMonth && allocationData[i].allocationYear==allocationYear){
                allocation.push(allocationData[i]);
            }
        }
        
        component.set("v.filteredAllocationData",allocation);  
    },
    
    showAllocation: function(component, event, helper) {
        component.set("v.selectAllocation",true);  
    },
    
    updateDepartureDate: function(component, event, helper) {
        var hssSurcharge = component.get("v.hssAmount"); 
        
        var selectedItem = event.currentTarget;
        var idForRow = selectedItem.dataset.record;
        
        var allocationData = component.get("v.filteredAllocationData");
        var tadOrderData = component.get("v.tadOrderData");
        
        tadOrderData.ordexp_departure_date__r.Name=allocationData[idForRow].dateName;
        tadOrderData.ordexp_departure_date__c=allocationData[idForRow].dateId;
        tadOrderData.ordexp_departure_date__r.date__c=allocationData[idForRow].departureDate;
        tadOrderData.ordexp_departure_date__r.ordexp_return_date__c=allocationData[idForRow].returnDate;
        
        helper.getAeSbRecordsHelper(component, event, helper,tadOrderData);
        
        component.set("v.tadOrderData",tadOrderData); 
        component.set("v.selectAllocation",false); 
        component.set("v.selectAesbChange",true);
    },
    
    // comeneted For PBP-237
    
    closePopup: function(component, event, helper) {
        //var recordId=component.get("v.recordId");
        //helper.resetOrderStatus(component, event, helper,recordId);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    updateTadOrder: function(component, event, helper) {
        var aesbData = component.get("v.aeSbInfo");
        var dateError = false;
        if(!$A.util.isEmpty(aesbData)){
            console.log('aesbData'+JSON.stringify(aesbData));
            for(var i = 0; i < aesbData.length; i++){
                if((Date.parse(aesbData[i].minDate)<=Date.parse(aesbData[i].aeSbDate)) && (Date.parse(aesbData[i].maxDate) >= Date.parse(aesbData[i].aeSbDate))){
                    
                }else{
                    helper.showToast(component, "Error!", "error","dismissible","AE/SB Dates are not in correct range please update them.");  
                    dateError = true; 
                    break;
                } 
            } 
        }
        
        if(dateError==false){
            helper.updateTadOrderRecords(component, event, helper);  
        }
        
    },
    
    confirmTadOrder: function(component, event, helper) {
        helper.confirmTadOrderHelper(component, event, helper);
    },
    
    closePopupRevert: function(component, event, helper) {
        
        helper.closePopupRevertHelper(component, event, helper); 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire();
        
    },
    
    
})