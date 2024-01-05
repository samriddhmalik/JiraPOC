({
    minNotMetCheck: function(component,event,helper){
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.verifyMinNotMetApprovalStatus");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('resultMin'+JSON.stringify(result));
                if(result.minMetState=='Processed'){
                    component.set("v.minNotMetOptions",result.minNotMetOptions);
                    component.set("v.minNotMetRefundOptions",result.refundOptions);
                    this.fetchRecords(component,event,helper,'Order'); 
                }
                if(result.enableSendCouponButton == true){
                    component.set("v.sendCouponColumnHide",true);
                }
                 component.set("v.minNotMetApprovalState",result);
             
               
                component.set("v.recordsDataDelete",result.oliToDelete);
            }
        });
        $A.enqueueAction(action);  
    },
    
     deletedSelectedRecords: function(component,event,helper,recData){
        var recId = component.get("v.recordId");
         console.log('recId'+recId)
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
              
        var action = component.get("c.deleteRecordsApex");
        
        var dataFinal=[];
         for(var i = 0; i < recData.length; i++){
             if(recData[i].check==true ){  
                 dataFinal.push(recData[i]);  
             }
         } 
        
        action.setParams({
            "recId" : recId,
            "recData" : dataFinal
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","You have deleted the records.");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
        
    },
     fetchRecords: function(component,event,helper,level){
        console.log('fetchRecords');
        component.set("v.recordsData",null);
        var reason = component.get("v.oldRefundReason");
        var recId = component.get("v.recordId");
        
        var action = component.get("c.fetchReordDataApex");
        action.setParams({
            "recId" : recId,
            "level" : level
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            let addOnRefundReason = component.get("v.addOnRefundReason");
            var filteredRecords = [];
            if(state === "SUCCESS"){
                
                if(level=='Order'){
                    component.set("v.editableCheckbox",true); 
                }else{
                    component.set("v.editableCheckbox",false);  
                }
                console.log('data2:'+JSON.stringify(result));
                if(reason != '' && addOnRefundReason.includes(reason)){
                    for(var i = 0; i < result.length; i++){
                        result[i].refundReason = reason;
                    }
                    component.set("v.disableReason",true);
                }
                for(var i = 0; i < result.length; i++){
                        if(result[i].oliAddonStatus != 'On Hold'){
                            filteredRecords.push(result[i]);
                        }
                    }
                if(component.get("v.recordsDataAll").length == 0){
                   component.set("v.recordsDataAll",result);
                   }
                component.set("v.recordsData",filteredRecords); 
            }
        });
        $A.enqueueAction(action);  
    },
    
    fetchAllRecords: function(component,event,helper,level){
        var recId = component.get("v.recordId");
        var action = component.get("c.fetchReordDataApex");
        action.setParams({
            "recId" : recId,
            "level" : level
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                   component.set("v.recordsDataAll",result);
            }
        });
        $A.enqueueAction(action);  
    },
    
    
    fetchRecordsApproval: function(component,event,helper){
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.fetchReordDataApexApproval");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('result'+JSON.stringify(result));
                for(var i = 0; i < result.length; i++){
                    if(result[i].approvalStage=='Pending Documentation'){
                        component.set("v.documentationRequired",true);
                        break; 
                    } 
                }
                
                component.set("v.recordsDataApproval",result);
                this.calculateRefundApproval(component, event, helper,result);
            }
        });
        $A.enqueueAction(action);  
    },
    
    fetchRecordsApprovalHistory: function(component,event,helper){
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.fetchReordDataApexApprovalHistory");
        action.setParams({
            "recId" : recId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            
            console.log('result for Approval History : '+JSON.stringify(result));
            
            if(state === "SUCCESS"){
                for(var i=0;i<result.length;i++) {
                    result[i].isCollapse = false;
                    if((result[i].cancellationStatus != 'Approved-Not Processed') && (result[i].cancellationStatus != 'Processed'))
                        component.set("v.oldRefundReason",result[i].refundReason);
                }
                component.set("v.recordsDataApprovalHistory",result);
            }
        });
        $A.enqueueAction(action);  
    },
    
    fetchPicklistFieldsRefundStatus: function(component,event,helper){
        
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            "objectName" : 'AddOn__c',
            "field_apiname" : 'Refund_Status__c'
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('picklist'+JSON.stringify(result));
                component.set("v.addOnRefundStatus",result); 
            } 
        });
        $A.enqueueAction(action);  
    },
    
    fetchPicklistFieldsRefundReason: function(component,event,helper){
        
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            "objectName" : 'AddOn__c',
            "field_apiname" : 'Refund_Reason__c'
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            if(state === "SUCCESS"){
                console.log('picklist'+JSON.stringify(result));
                component.set("v.addOnRefundReason",result); 
            } 
        });
        $A.enqueueAction(action);  
    },
    
    calculateRefund : function (component, event, helper , dataRecords){
        
        var recData = dataRecords;
        var refundAmount = 0 ;
        var creditAmount = 0 ;
        var coupounAmount = 0 ;
        for(var i = 0; i < recData.length; i++){
            if(recData[i].check==true && !$A.util.isUndefined(recData[i].refund)){
                if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Refund' || recData[i].status =='Partial Refund') ){
                    refundAmount=Number(refundAmount) + Number(recData[i].refund);  
                }
                else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Credit' || recData[i].status =='Partial Credit') ){
                    creditAmount=Number(creditAmount) + Number(recData[i].credit);  
                }
                    else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Coupon' || recData[i].status =='Partial Coupon') ){
                        coupounAmount=Number(coupounAmount) + Number(recData[i].coupon);  
                    }else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Partial Refund/Coupon/Credit')){
                        coupounAmount=Number(coupounAmount) + Number(recData[i].coupon);
                        creditAmount=Number(creditAmount) + Number(recData[i].credit); 
                        refundAmount=Number(refundAmount) + Number(recData[i].refund);
                    }
            }
        }
        component.set("v.refundAmount",refundAmount);
        component.set("v.creditAmount",creditAmount);
        component.set("v.coupounAmount",coupounAmount);
        
    },
    
    calculateRefundApproval : function (component, event, helper , dataRecords){
        
        var recData = dataRecords;
        var refundAmount = 0 ;
        var creditAmount = 0 ;
        var coupounAmount = 0 ;
        for(var i = 0; i < recData.length; i++){
            if(!$A.util.isUndefined(recData[i].refund) && recData[i].check==true){
                if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Refund' || recData[i].status =='Partial Refund') ){
                    refundAmount=Number(refundAmount) + Number(recData[i].refund);  
                }
                else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Credit' || recData[i].status =='Partial Credit') ){
                    creditAmount=Number(creditAmount) + Number(recData[i].credit);  
                }
                    else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Full Coupon' || recData[i].status =='Partial Coupon') ){
                        coupounAmount=Number(coupounAmount) + Number(recData[i].coupon);  
                    }else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Partial Refund/Coupon/Credit')){
                        coupounAmount=Number(coupounAmount) + Number(recData[i].coupon);
                        creditAmount=Number(creditAmount) + Number(recData[i].credit); 
                        refundAmount=Number(refundAmount) + Number(recData[i].refund);
                        }
                    }else if(!$A.util.isUndefined(recData[i].status) && (recData[i].status =='Partial Refund/Coupon/Credit')){
                        coupounAmount=Number(coupounAmount) + Number(recData[i].coupon);
                        creditAmount=Number(creditAmount) + Number(recData[i].credit); 
                        refundAmount=Number(refundAmount) + Number(recData[i].refund);
                    }
            }
        component.set("v.refundAmountApproval",refundAmount);
        component.set("v.creditAmountApproval",creditAmount);
        component.set("v.coupounAmountApproval",coupounAmount);
        
    },
    
    saveAndCancelRecords: function(component,event,helper,recData){
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        
        var cancelOrder = false;
        if(!$A.util.isEmpty(component.get("v.cancelButtonSelection"))){
            var cancelOrder = true;
        }
        
        var action = component.get("c.saveAndCancel");
        action.setParams({
            "recId" : recId,
            "recData" : recData,
            "cancelOrder" :cancelOrder
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Your cancellation request has been submitted successfully");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }else if(state === "ERROR"){
                var errors = action.getError();
                console.log('here in error '+JSON.stringify(errors));
                errors.forEach(function(error){
                    console.log('here in '+error);
                    // this.showToast(component, "Error!", "error", "pester", JSON.stringify(error));
                    
                }); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    submitRecordsForApproval: function(component,event,helper,recData){
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        var isCustomerAccepted = component.get("v.isCustomAccepted");
        var cancelOrder = false;
          console.log('Line--291--> '+JSON.stringify(recData));
        if(!$A.util.isEmpty(component.get("v.cancelButtonSelection"))){
            var cancelOrder = true;
        }
        var action = component.get("c.submitForApproval");
        action.setParams({
            "recId" : recId,
            "recData" : recData,
            "cancelOrder" :cancelOrder,
            "isCustomerAccepted":isCustomerAccepted
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","Your cancellation request has been submitted successfully");
                component.set('v.confirmationScreen',false);
                $A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }else if(state === "ERROR"){
                var errors = action.getError();
                errors.forEach(function(error){
                    console.log('here in error '+error);
                    //   this.showToast(component, "Error!", "error", "pester", JSON.stringify(error));
                    
                });
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    //PBP-63 Start
    //replace recData to recDataApproval
    sendForApprovalInProgress: function(component,event,helper,recDataApproval){
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        var isCustomAcceptedInProgress =  component.get("v.isCustomAcceptedInProgress");
        var documentationReceived = component.get("v.documentationReceived");
        console.log('recDataApproval '+JSON.stringify(recDataApproval));
        console.log('recId '+recId);
        console.log('isCustomAcceptedInProgress '+isCustomAcceptedInProgress);
        var action = component.get("c.sendForApprovalPostDocumentation");
        
        var dataFinal=[];
        for(var i = 0; i < recDataApproval.length; i++){
            
            if((recDataApproval[i].approvalStage=='Pending Documentation') && documentationReceived ==false ){  
            }else{
                dataFinal.push(recDataApproval[i]);  
            }
        } 
        console.log('dataFinal '+JSON.stringify(dataFinal));
        action.setParams({
            "recId" : recId,
            "recData" : dataFinal,
            "isCustomAccepted": isCustomAcceptedInProgress
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","You have submitted the cancellation request for approval!");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }else if(state === "ERROR"){
                var errors = action.getError();
                
                errors.forEach(function(error){
                    console.log('here in  '+error);
                    // this.showToast(component, "Error!", "error", "pester", JSON.stringify(error));
                    
                });
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    minNotMetCancelOrder: function(component,event,helper,recData){
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var recId = component.get("v.recordId");
        
        var action = component.get("c.cancelCompleteOrder");
        action.setParams({
            "recId" : recId,
            "recData" : recData
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            var state = response.getState(); 
            if(state === "SUCCESS"){
                this.showToast(component, "Success!", "success","dismissible","You have successfully cancelled the Order!");
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showToast: function(component, title, toastType,mode, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message,
            "mode":mode
        });
        toastEvent.fire();
    },
    
    validateSelectedFields: function(component, event, helper,recData,button) {
        console.log('button  '+button);
        var check = true;
        var checkEmpty = true;
        var confirmationScreen = true;
        var containCredit = false;
        var creditAmount = component.get("v.creditAmount");
        
        var cancellationLevel = component.get("v.cancellationLevel");
        console.log('cancellationLevel',cancellationLevel);
        var checkRecordsTodelete = component.get("v.recordsDataDelete");
        console.log('1');
        for(var i = 0; i < recData.length; i++){
            if(recData[i].check==true){
                check=false;
                if(recData[i].refund<0 || recData[i].credit<0 || recData[i].coupon<0){
                    this.showToast(component, "Error!", "error","dismissible","Negative amount not allowed"); 
                    return;
                }
                if((recData[i].refund + recData[i].credit + recData[i].coupon) <= 0 && recData[i].status.includes('Partial')){
                    this.showToast(component, "Error!", "error","dismissible","Entered amount cannot be less than or equal to 0.00"); 
                    return;
                }
                if( $A.util.isEmpty(recData[i].refundReason) || $A.util.isEmpty(recData[i].status) || $A.util.isEmpty(recData[i].refund) || $A.util.isEmpty(recData[i].credit) || $A.util.isEmpty(recData[i].coupon)){
                    checkEmpty=false;
                    break;
                }   
            }
            if(recData[i].check==false){
                confirmationScreen=false;  
                console.log('2');
            }
            if((recData[i].status=='Full Credit' || recData[i].status=='Partial Credit' || recData[i].status=='Partial Refund/Coupon/Credit') && containCredit == false && creditAmount>0){
                containCredit=true;  
            }
            
        }
        
        console.log('checkRecordsTodelete'+checkRecordsTodelete);
        if(!$A.util.isEmpty(checkRecordsTodelete)){
            containCredit=false;
            confirmationScreen=false;
        }
        
        if((cancellationLevel=='' || cancellationLevel=='Addon') && button != 3){
            confirmationScreen=false;   
        }
        console.log('confirmationScreen '+confirmationScreen);
        if(check==true){
            this.showToast(component, "Error!", "error","dismissible","You need to select a record first");  
        }
        else if(checkEmpty==false){
            this.showToast(component, "Error!", "error","dismissible","All visible fields are required");  
        }
            else if(confirmationScreen==true && button!=4 && containCredit!=true ){
                if(containCredit==true){
                    this.showToast(component, "Error!", "error","dismissible","For Complete Order cancellation Credit is not allowed.");
                }else{
                    var isCustomAccepted = component.get("v.isCustomAccepted");
                    var isCustomAcceptedInProgress = component.get("v.isCustomAcceptedInProgress");//PBP-63
					console.log('button '+button);
                    if(isCustomAccepted){ 
                        component.set("v.confirmationScreen",true);
                        component.set("v.cancelButtonSelection",button);     
                    }if(isCustomAcceptedInProgress){//PBP-63
                        // Start Worked on card Psag-53
                        if (button == 3){
                            component.set("v.confirmationScreen",false); //Psag-53
                          this.sendForApprovalInProgress(component, event, helper,recData);
                       }else{
                            component.set("v.confirmationScreen",true);//PBP-63
                       }
                         //End Card Psag-53    
                        component.set("v.cancelButtonSelection",button);//PBP-63
                    }else{
                        component.set("v.validatedForCustomerAccept", true);
                        component.set("v.validatedForCustomerAcceptInProgress", true);//PBP-63
                        this.showToast(component, "Info Message", "info","dismissible","Please accept the terms and conditions!"); 
                    }   
                }
            }
                else{
                    if(button==1){
                        var isCustomAccepted = component.get("v.isCustomAccepted");
                        if(isCustomAccepted){
                            this.saveAndCancelRecords(component, event, helper,recData);     
                        }else{
                            component.set("v.validatedForCustomerAccept", true);
                            this.showToast(component, "Info Message", "info","dismissible","Please accept the terms and conditions!"); 
                        }
                        
                    }else if(button==2){
                        var isCustomAccepted = component.get("v.isCustomAccepted");
                        console.log('isCustomAccepted '+isCustomAccepted);
                        if(isCustomAccepted){
                            this.submitRecordsForApproval(component, event, helper,recData);
                        }else{
                            component.set("v.validatedForCustomerAccept", true);
                            this.showToast(component, "Info Message", "info","dismissible","Please accept the terms and conditions!"); 
                        }
                    }else if(button==3){
                        var isCustomAcceptedInProgress = component.get("v.isCustomAcceptedInProgress");
                        if(isCustomAcceptedInProgress){
                            this.sendForApprovalInProgress(component, event, helper,recData);
                        }else{
                            component.set("v.validatedForCustomerAcceptInProgress", true);
                            this.showToast(component, "Info Message", "info","dismissible","Please accept the terms and conditions!"); 
                        }
                        
                    }else if(button==4){
                        var isCustomAcceptedInProgress = component.get("v.isCustomAcceptedInProgress");
                        this.minNotMetCancelOrder(component, event, helper,recData);
                    }
                }
    },
    
    callingSendCouponButtonClick : function(component,event,helper,selectedRecord){
        
        var action = component.get("c.settingSendCouponTrue");
        action.setParams({
            "canRefId" :  selectedRecord.canRefId   
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                this.showToast(component, "Success!", "success","dismissible","Your Order Comms Record was created successfully.");
                component.set("v.confirmationScreen", 'false');
                selectedRecord.sendCouponButton = true;
            } else {
                console.log('Couldnot saved'+JSON.stringify(response));
            }        
        });
        $A.enqueueAction(action);
    }
    
})