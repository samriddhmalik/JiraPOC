({
    doInit: function(component, event, helper) {        
        helper.checkDealType(component, helper,event);   
    },
    
    searchAccount : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchKeyWord");  
        if( getInputkeyWord.length > 1 ){
            helper.searchHelper(component,event,getInputkeyWord);
        }else{
            component.set("v.listOfSearchRecords", null );  
        }
    },
    
    showModal : function(component, event, helper){
        component.set("v.isOpen", 'true');
        component.set("v.isButtonView", 'false');
        
    },
    closeModal :  function(component, event, helper){
         component.set("v.isOpen", 'false');
         component.set("v.isButtonView", 'true');
    },
  
    selectRecord : function(component, event, helper){
        var objectId = event.currentTarget.dataset.id;
        var objectLabel = event.currentTarget.innerText;
        console.log('objectId: '+objectId);
        $A.util.removeClass(component.find("inputPill"), 'slds-hide');
        $A.util.addClass(component.find("inputPill"), 'slds-show');
       // $A.util.removeClass(component.find("inputPillLabel"), 'slds-hide');
       // $A.util.addClass(component.find("inputPillLabel"), 'slds-show');
        
        $A.util.removeClass(component.find("inputField"), 'slds-show');
        $A.util.addClass(component.find("inputField"), 'slds-hide');
        
        component.set("v.cruiseCabinRecord.cruise_company__c", objectId);
        component.set("v.selectedRecord", objectLabel);
        component.set("v.listOfSearchRecords", null ); 
        
        
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        $A.util.removeClass(component.find("inputPill"), 'slds-show');
        $A.util.addClass(component.find("inputPill"), 'slds-hide');
       // $A.util.removeClass(component.find("inputPillLabel"), 'slds-show');
        //$A.util.addClass(component.find("inputPillLabel"), 'slds-hide');
        
        $A.util.removeClass(component.find("inputField"), 'slds-hide');
        $A.util.addClass(component.find("inputField"), 'slds-show');
        
        component.set("v.selectedRecord",''); 
        component.set("v.SearchKeyWord",''); 
    },
    
    saveClick :function(component,event,helper){
        var referenceNumber = component.find("referenceNumber");
        var referenceNumberValue = referenceNumber.get("v.value");
        var shipName = component.find("shipName");
        var shipNameValue = shipName.get("v.value");
        var shipSailDate = component.find("shipSailDate");
        var shipSailDateValue = shipName.get("v.value");
        var cabinPrice = component.find("cabinPrice");
        var cabinPriceValue = shipName.get("v.value");
        var cabinNumbers = component.find("cabinNumbers");
        var cabinNumbersValue = shipName.get("v.value");
       // var accountSearch = component.find("accSearch");
       // var accountSelected = component.get("v.selectedRecord");
        var cruiseCompanyPickList = component.find("cruiseCompanyPickList").get("v.value");
        console.log('cruiseCompanyPickList cruiseCompanyPickList cruiseCompanyPickList'+cruiseCompanyPickList);
        var proceed = 'Yes';   
       	
        
        if(cruiseCompanyPickList == '' || cruiseCompanyPickList == "null"){
            console.log('entered if');
            helper.showToast(component,"Company Type missing.","error","Please select a Company Type!");
            var proceed = 'No';
        }
        else{
            console.log('entered else');
        }
        
        
        if($A.util.isUndefinedOrNull(referenceNumberValue) || $A.util.isEmpty(referenceNumberValue)){
            var proceed = 'No';
            referenceNumber.set("v.errors", [{message:"Please enter the Reference Number"}]);  
        }else{
            referenceNumber.set("v.errors", null);	
        }
        if($A.util.isUndefinedOrNull(shipNameValue) || $A.util.isEmpty(shipNameValue)){
            var proceed = 'No';
            shipName.set("v.errors", [{message:"Please enter the Ship Name"}]);  
        }else{
            shipName.set("v.errors", null);	
        }
        if($A.util.isUndefinedOrNull(shipSailDateValue) || $A.util.isEmpty(shipSailDateValue)){
            var proceed = 'No';
            shipSailDate.set("v.errors", [{message:"Please enter the Ship Sail date"}]);  
        }else{
            shipSailDate.set("v.errors", null);	
        }
        if($A.util.isUndefinedOrNull(cabinPriceValue) || $A.util.isEmpty(cabinPriceValue)){
            var proceed = 'No';
            cabinPrice.set("v.errors", [{message:"Please enter the Cabin Price"}]);  
        }else{
            cabinPrice.set("v.errors", null);	
        }
        if($A.util.isUndefinedOrNull(cabinNumbersValue) || $A.util.isEmpty(cabinNumbersValue)){
            var proceed = 'No';
            cabinNumbers.set("v.errors", [{message:"Please enter the Cabin Numbers"}]);  
        }else{
            cabinNumbers.set("v.errors", null);	
        }
        if(proceed=='Yes'){
           helper.createCabins(component,event,helper); 
        }
        
    }
    
})