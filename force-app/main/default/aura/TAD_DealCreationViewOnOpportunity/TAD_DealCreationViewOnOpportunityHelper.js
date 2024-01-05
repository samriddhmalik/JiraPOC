({
    checkForOpportunityStage : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.checkForOpportunityStage");
        console.log("here in check"+recordId);
        action.setParams({
            "RecordId":recordId
            
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS' && response.getReturnValue() != null){
                console.log("here in response "+ JSON.stringify(response.getReturnValue()));
                component.set("v.isButtonView", 'true');
                var result = response.getReturnValue();
                var sfdcmap = [];
                for(var key in result){
                    sfdcmap.push({key: key, value : result[key]});
                    if(result[key] == 'TAD Deal'){
                        component.set("v.selectedValue", key);
                    }
                }
                component.set("v.mapOfRecordType", sfdcmap);
            }
        });
        $A.enqueueAction(action);
    },
    getDealType :function(component, event, helper){
        var action = component.get("c.getMultiPiklistValues");
        action.setCallback(this, function(response) {
            console.log('response======>30==='+response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                console.log('result======>34==='+ result.length);
                
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                console.log('plValues======>43==='+ plValues);
                
                component.set("v.DealTypeList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    getDateFlights :function(component, event, helper){
        var action = component.get("c.getPiklistValues");
        action.setCallback(this, function(response) {
            console.log('response======>53==='+response.getReturnValue());
            
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.DateFlight", plValues);
            }
        });
        $A.enqueueAction(action);
    },
    
    navigateToRecordCreation : function(component, event, helper) {
        var selectedRecordTypeId = component.find("recordTypePickList").get("v.value");
        console.log('selectedRecordTypeId '+selectedRecordTypeId);
        
        /*var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef: "c:Tad_DealCreationFromOpportunity",
            //componentAttributes :{ //your attribute}
        });
       
    evt.fire();*/
        
        var createRecordEvent = $A.get("e.force:createRecord");
        
        
        
        if(selectedRecordTypeId != null && selectedRecordTypeId != 'undefined' && selectedRecordTypeId != '' ){//if recordTypeId is supplied, then set recordTypeId parameter
            if(createRecordEvent){ //checking if the event is supported
                var recordId = component.get("v.recordId");
                createRecordEvent.setParams({
                    
                    "entityApiName": "Deal__c",
                    
                    "recordTypeId": selectedRecordTypeId,
                    
                    "defaultFieldValues": {
                        
                        "Opportunity__c": recordId
                        
                    }	 
                    
                    
                    
                });
                
            } 
            
            createRecordEvent.fire();
            component.set("v.isOpen", 'false');
            component.set("v.isButtonView", 'true');
            
        }else{
            var selectedRecordTypeIdNew = component.find("recordTypePickList");
            console.log("here in else");
            
            
        }
        
        
        /*var recordId = component.get("v.recordId");
        var action = component.get("c.dealCreationFromOpp");
        console.log("here in check"+recordId);
        action.setParams({
            "RecordId":recordId
            
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log("here in response "+ JSON.stringify(response.getReturnValue()));
                component.set("v.isButtonView", 'true');
                var result = response.getReturnValue();
                
                component.set("v.mapOfRecordType", sfdcmap);
            }
        });
        $A.enqueueAction(action);*/
    },
    
    isDealExist : function(component, event, helper){
        var action = component.get("c.checkDeal");
        var recordId = component.get("v.recordId");
        action.setParams({
            "RecordId":recordId
            
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('SUCCESS');
                var result = response.getReturnValue();
                console.log('result-->'+result);
                if(result == 'any'){
                    console.log('result-146->'+JSON.stringify(result));
                    component.set("v.OppFieldBlank",'true');
                    
                }
                else if(result==null || result ==''){
                    console.log('result-150->'+JSON.stringify(result));
                    component.set("v.isOpen", 'true');
                    component.set("v.isButtonView", 'false');
                }
                    else{
                        console.log('result-156->'+JSON.stringify(result));
                        component.set("v.isDealExist", 'true');
                        var q = component.set("v.dealName", JSON.stringify(result[1]));
                        console.log('Line--166-->'+q);
                    }
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    isOppFieldPopulated : function(component, event, helper){
        var action = component.get("c.CheckOppFieldPopulated");
        var recordId = component.get("v.recordId");
        action.setParams({
            "RecordId":recordId
            
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('SUCCESS');
                var result = response.getReturnValue();
                console.log('result-135->'+result);
                if(result){
                    console.log('result-137->'+result);
                    component.set("v.isDealExist", 'true');
                }
                else{
                    component.set("v.isOpen", 'true');
                    component.set("v.isButtonView", 'false');
                }
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    dealCreationFromOpportunity : function(component, event, helper){
        console.log('Line---124-->');
        var selectedValues = component.get("v.selectedDealType");
        var selectedDateValues = component.get("v.selectedDateFlight");
        var selectedRecordTypeId = component.find("recordTypePickList").get("v.value");
        console.log('selectedRecordTypeId '+selectedRecordTypeId);
        var action = component.get("c.dealCreationFromOpportunity");
        console.log('Line--208-->');
        var recordId = component.get("v.recordId");
        
        console.log('Line---197-->'+recordId);
        console.log('Line---198-->'+selectedValues);
        console.log('Line---199-->'+selectedDateValues);
        action.setParams({
            "RecordId":recordId,
            "SelectDealType" : selectedValues.toString(),
            "dealId":component.get("v.dealIdValue"),
            "SelectedDateFlight": selectedDateValues
            
        });
         component.set("v.spinner", true); 
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                
                toastEvent.setParams({
                    "title": "Success!",
                    "duration":"5000",
                    "key": "info_alt",
                    "type": "success",
                    "mode": "pester",
                    "message": "Deal Is Created successfully."
                });
                toastEvent.fire();
                console.log('SUCCESS---Line--208');
                var result = response.getReturnValue();
                console.log('result---Line--231'+result);
                component.set("v.isOpen",'false');
                component.set("v.openmodel",'false');             
                
                dismissActionPanel.fire();  
             	$A.get('e.force:refreshView').fire(); 
            }
        });
        $A.enqueueAction(action);
    }
})