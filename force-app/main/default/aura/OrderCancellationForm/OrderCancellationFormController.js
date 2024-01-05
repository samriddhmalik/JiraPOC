({
    
    doInit : function (component, event, helper){ 
        var content1 = "<p>Before we can begin actioning your Cancellation request, we need you to confirm acknowledgment of your understanding and acceptance of our cancellation process and policy as follows.!</p></br><p>As per our Terms & Conditions, our deals are non-refundable and we recommend approaching your Travel Insurance provider to assess any claims you may be eligible for, prior to confirming this request.</p></br><p>Once confirmed, we can then proceed to cancel your booking and issue you with any documentation you may require for a potential claim with your insurance provider.</p>";
        var content2="<h3>ACKNOWLEDGEMENT:</h3></br><ul><li>Please confirm that you have read, understood and accept TripADeal's Cancellation and Refund Policy in full.(Pax to Answer YES)</li><li>You understand that immediately upon confirming this Cancellation you will have authorised TripADeal to cancel all elements of the Order for the cancelling passenger(s). (Pax to Answer YES)</li><li>Please confirm number of passengers cancelling - (Pax to advise number)</li><li>Please confirm passengers cancelling; (Pax to advise for each cancelling passenger - FULL NAME, DOB, PASSPORT NUMBER)</li><li>Please confirm whether TripADeal will be required to provide cancellation confirmation documentation to support any relevant insurance claims of the affected cancelling passenger(s) (Pax to advise Yes or No)</li></ul>";
        var content3 = "<p>By confirming this cancellation request this is a final decision not to proceed with the travel arrangements and we will be cancelling partial / all components of your package. Do you wish to proceed? (Pax to advise final confirmation)</p>";
        var finalContent = content1 + content2 +content3;
        component.set("v.richtext", finalContent);
        component.set("v.oldRefundReason",'');
        component.set("v.disableReason",false);
        helper.fetchPicklistFieldsRefundStatus(component, event, helper);
        helper.fetchPicklistFieldsRefundReason(component, event, helper);
        helper.minNotMetCheck(component, event, helper);
        helper.fetchRecordsApproval(component, event, helper);
        helper.fetchAllRecords(component, event, helper,'Order'); 
        helper.fetchRecordsApprovalHistory(component, event, helper);
        
    },
    
    onSendCouponButtonPressed : function(component,event,helper){
        var idForRow = event.getSource().get('v.value');
        console.log("Row No : " + idForRow);
        
        var fetchTheSelectedIndex = component.get("v.recordsDataApprovalHistory");
        var selectedRecord = fetchTheSelectedIndex[idForRow];
        
        
        helper.callingSendCouponButtonClick(component,event,helper,selectedRecord);
        
    },
    
    sectionCollapse :  function(component, event, helper){
        var str = event.currentTarget.getAttribute("class");
        var index = event.currentTarget.dataset.rowIndex;
        var classname = 'slds-is-open';
        var flag = str.includes(classname);
        var acc = component.get("v.recordsDataApprovalHistory");
        if(flag) {
            str = str.replace(classname,"");
            acc[index].isCollapse = false;
        }
        else {
            str = str + ' '+ classname;
            acc[index].isCollapse = true;
        }
        event.currentTarget.setAttribute("class",str);
        component.set("v.recordsDataApprovalHistory",acc);
    },
    
    //Modal for Confirmation Screen
    closeModal :  function(component, event, helper){
        component.set("v.confirmationScreen", 'false');
    },
    
    //Modal for Confirmation Screen
    closeDeleteModal :  function(component, event, helper){
        component.set("v.confirmationScreenDelete", false);
    },
    
    // Cancels Order for Min Not type of cancellation
    deleteRecordsConfirmation : function (component, event, helper){
        component.set("v.confirmationScreenDelete", true);
    },
    
    // Cancels Order for Min Not type of cancellation
    deleteRecords : function (component, event, helper){
        var recData = component.get("v.recordsDataDelete");
        helper.deletedSelectedRecords(component, event, helper,recData);
    },
    
    // Cancellation from Confirmation Screen
    cancelOrder :  function(component, event, helper){
        var buttonValue = component.get("v.cancelButtonSelection");
        var recData = component.get("v.recordsData");
        var recDataApproval = component.get("v.recordsDataApproval");//PBP-63
        console.log('recDataApproval '+JSON.stringify(recDataApproval));
         console.log('Line--76--> '+JSON.stringify(recData));
        if(buttonValue==1){
            helper.saveAndCancelRecords(component, event, helper,recData); 
        }
        if(buttonValue==2){
            helper.submitRecordsForApproval(component, event, helper,recData);  
        }
        //PBP-63 start
        if(buttonValue==3){
            helper.sendForApprovalInProgress(component, event, helper,recDataApproval);
        }//PBP-63 Stop
    },
    
    primaryScreen : function (component, event, helper){
        component.set("v.cancellationLevel",'');
    },
    
    // Fetches records for Cancellation based on level
    getRequestedRecords : function (component, event, helper){
        component.set("v.documentationBox",false);
        component.set("v.isCustomAccepted",false);
        
        component.set("v.validatedForCustomerAccept", false);
        var level = component.get("v.cancellationLevel");
        helper.fetchRecords(component, event, helper,level); 

    },
    
    // Cancels record and send for Documentaion
    requestDocumentation : function (component, event, helper){
        var button = 1;
        var recData = component.get("v.recordsData");
        helper.validateSelectedFields(component, event, helper,recData,button);
    },
    
    // Cancels record and Send for approval
    sendApproval : function (component, event, helper){
        var button = 2;
        var recData = component.get("v.recordsData");
        var reDataAll = component.get("v.recordsDataAll");
        var cancellationLevel = component.get("v.cancellationLevel");
        var creditCancellation = component.get("v.creditTypeCancellation");
        let checkedData = []
        recData.forEach(obj=>{if(obj.check == true){
                                           checkedData.push(obj.Id);     
                                               }})
        let recOli = [];
        let oliAddonfiteredArr = reDataAll.filter(obj1 => !((obj1.hasOwnProperty('oliId') && checkedData.includes(obj1.oliId)) || checkedData.includes(obj1.Id)));
        for(let i = 0; i< oliAddonfiteredArr.length; i++){
            if((oliAddonfiteredArr[i].level == 'OLI' || oliAddonfiteredArr[i].level == 'AddOn') && oliAddonfiteredArr[i].oliAddonStatus == 'On Hold'){
                recOli.push(oliAddonfiteredArr[i]);
            }
        }
        let creditInPccc = component.get("v.creditAmount");
        console.log('CreditInPccc',creditInPccc);
        if(recOli.length ==0  && creditInPccc>0 && cancellationLevel == 'OLI'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Order must have atleast 1 OLI or Addon in "On Hold" status for Credit type cancellation.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();

        }else if(creditInPccc>0 && cancellationLevel == 'Order'){
                helper.showToast(component, "Error!", "error","dismissible","For Complete Order cancellation Credit is not allowed.");
            }
        else{
            helper.validateSelectedFields(component, event, helper,recData,button);
        }
        //helper.validateSelectedFields(component, event, helper,recData,button);
    },
    
    // Send for approval post documentaion or Re-sumbit rejected approvals
    sendForApprovalInProgress : function (component, event, helper){
        helper.fetchAllRecords(component, event, helper,'Order');
        var button = 3;
        var recData = component.get("v.recordsDataApproval");
        let creditInPccc = component.get("v.creditAmountApproval");
        var cancellationLevel = component.get("v.cancellationLevel");
        var reDatall = component.get("v.recordsDataAll");
        console.log('reDataAll',reDatall);
        let checkedData = [];
        let recOli = [];
        if(reDatall.length > 0){
        recData.forEach(obj=>{if(obj.check == true){
                                           checkedData.push(obj.Id);     
                                               }})
        let oliAddonfiteredArr = reDatall.filter(obj1 => !((obj1.hasOwnProperty('oliId') && checkedData.includes(obj1.oliId)) || checkedData.includes(obj1.Id)));
             console.log('reDataAll',oliAddonfiteredArr);
        for(let i = 0; i< oliAddonfiteredArr.length; i++){
            if((oliAddonfiteredArr[i].level == 'OLI' || oliAddonfiteredArr[i].level == 'AddOn') && oliAddonfiteredArr[i].oliAddonStatus == 'On Hold'){
                recOli.push(oliAddonfiteredArr[i]);
            }
        }   
            }
        if(recOli.length ==0  && creditInPccc>0 && cancellationLevel == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Order must have atleast 1 OLI or Addon in "On Hold" status for Credit type cancellation.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();

        }
        else{
            helper.validateSelectedFields(component, event, helper,recData,button);
        }
    },
    
    
    // Cancels Order for Min Not type of cancellation
    minNotMetCancellation : function (component, event, helper){
        var button = 4;
        var recData = component.get("v.recordsData");
        helper.validateSelectedFields(component, event, helper,recData,button);
    },
    
    // Auto populates refund value based on refund type
    autoPopulateRefund : function (component, event, helper){
        component.set('v.creditTypeCancellation',false);
        var recData = component.get("v.recordsData");
        var idForRow = event.getSource().get('v.name');
        var valueRow = event.getSource().get('v.value');
        var flag = false;
        for(var i = 0; i < recData.length; i++) {
            if(valueRow=='Full Refund' || valueRow=='Partial Refund' || valueRow=='Full Coupon' || valueRow=='Partial Coupon') {
                flag = true;
            }
        }
        component.set("v.enableApproval",flag);
        
        switch(valueRow){
            case 'Full Refund':
                recData[idForRow].refund=recData[idForRow].price;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Full Credit':
                recData[idForRow].credit=recData[idForRow].price;
                recData[idForRow].refund=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Full Coupon':
                recData[idForRow].coupon=recData[idForRow].price;
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                break;
            case 'No Refund/Credit':
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Partial Credit':
                recData[idForRow].refund=0.00;
                recData[idForRow].coupon=0.00;
                recData[idForRow].credit='';
                break;
            case 'Partial Coupon':
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon='';
                break;
            case 'Partial Refund':
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                recData[idForRow].refund='';
                break;
            default :
                recData[idForRow].refund='';
                recData[idForRow].credit='';
                recData[idForRow].coupon='';
        }
        /*if(valueRow=='Full Refund' || valueRow=='Full Credit'|| valueRow=='Full Coupon'){
            recData[idForRow].refund=recData[idForRow].price;
        }else if(valueRow=='No Refund/Credit'){
            recData[idForRow].refund=0.00;
        }else{
            recData[idForRow].refund=null;
        }*/
        component.set("v.recordsData",recData);
        console.log('line--170-->'+valueRow);
        
        if(valueRow =='Full Credit' || valueRow =='Partial Credit' || (valueRow =='Partial Refund/Coupon/Credit')){
            component.set('v.creditTypeCancellation',true);
        }
        helper.calculateRefund(component, event, helper,recData);        
    },
    
    // Auto populates refund value based on refund type for Min Not Met Process
    minNotMetStatusValidation : function (component, event, helper){
        var recData = component.get("v.recordsData");
        var valueRow = event.getSource().get('v.value');
        var canOptions = component.get("v.minNotMetRefundOptions");
        var errorMsg = true;
        
        for(var i = 0; i < canOptions.length; i++){
            if(valueRow==canOptions[i]){
                errorMsg=false;
                break;
            }
        }
        
        if(errorMsg==true){
            recData[0].status='';
            component.set("v.recordsData",recData);
            helper.showToast(component, "Error!", "error","dismissible","This Refund Option is not allowed!");  
        }else{
            for(var i = 0; i < recData.length; i++){
                recData[i].status = valueRow;
                if(valueRow=='Full Refund' || valueRow=='Full Credit'|| valueRow=='Full Coupon'){
                    recData[i].refund=recData[i].price;
                }else{
                    recData[i].refund=null;
                }
                if((i+1)==recData.length){
                    console.log('Inside calculation'+JSON.stringify(recData));
                    helper.calculateRefund(component, event, helper,recData);   
                }
            }
            component.set("v.recordsData",recData); 
        }
    },
    
    sendCoupon : function(component, event, helper) {
        console.log('coupon sent called');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    autoPopulateRefundApproval : function (component, event, helper){
        var recData = component.get("v.recordsDataApproval");
        var idForRow = event.getSource().get('v.name');
        var valueRow = event.getSource().get('v.value');
        
        switch(valueRow){
            case 'Full Refund':
                recData[idForRow].refund=recData[idForRow].price;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Full Credit':
                recData[idForRow].credit=recData[idForRow].price;
                recData[idForRow].refund=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Full Coupon':
                recData[idForRow].coupon=recData[idForRow].price;
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                break;
            case 'No Refund/Credit':
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                break;
            case 'Partial Credit':
                recData[idForRow].refund=0.00;
                recData[idForRow].coupon=0.00;
                recData[idForRow].credit='';
                break;
            case 'Partial Coupon':
                recData[idForRow].refund=0.00;
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon='';
                break;
            case 'Partial Refund':
                recData[idForRow].credit=0.00;
                recData[idForRow].coupon=0.00;
                recData[idForRow].refund='';
                break;
            default :
                recData[idForRow].refund='';
                recData[idForRow].credit='';
                recData[idForRow].coupon='';
        }
        /*/if(valueRow=='No Refund/Credit'){
            recData[idForRow].refund=0;
        }else if(valueRow=='Full Refund' || valueRow=='Full Credit'|| valueRow=='Full Coupon'){
           recData[idForRow].refund=recData[idForRow].price;
        }else{
            recData[idForRow].refund=null;
        }*/
        component.set("v.recordsDataApproval",recData);
        helper.calculateRefundApproval(component, event, helper,recData);        
    },
    
    totalRefund : function (component, event, helper){
        var recData = component.get("v.recordsData");
        var idForRow = event.getSource().get('v.name');
        
        if(!$A.util.isUndefined(recData[idForRow].refund)){
            if((Number(recData[idForRow].refund) + Number(recData[idForRow].credit) + Number(recData[idForRow].coupon))>Number(recData[idForRow].price)){
                helper.showToast(component, "Error!", "error","dismissible","Amount can't be greater than price!");  
                recData[idForRow].refund= component.get("v.refundAmount");
                recData[idForRow].credit= component.get("v.creditAmount");
                recData[idForRow].coupon= component.get("v.coupounAmount");
                component.set("v.recordsData",recData); 
            }else{
                helper.calculateRefund(component, event, helper,recData);  
            }      
        }  
    },
    
    totalRefundApproval : function (component, event, helper){
        var recData = component.get("v.recordsDataApproval");
        var idForRow = event.getSource().get('v.name');
        
        if(!$A.util.isUndefined(recData[idForRow].refund)){
            if((Number(recData[idForRow].refund) + Number(recData[idForRow].credit) + Number(recData[idForRow].coupon))>Number(recData[idForRow].price)){
                helper.showToast(component, "Error!", "error","dismissible","Amount can't be greater than price!");  
                recData[idForRow].refund= component.get("v.refundAmountApproval");
                recData[idForRow].credit= component.get("v.creditAmountApproval");
                recData[idForRow].coupon= component.get("v.coupounAmountApproval");
                component.set("v.recordsDataApproval",recData); 
            }else{
                console.log('Approval Sum'+JSON.stringify(recData));
                helper.calculateRefundApproval(component, event, helper,recData);  
            }    
        }  
    },
    
       checkChilds : function (component, event, helper){
           console.log('Line--260-->');
        var recData = component.get("v.recordsData");
        var level = component.get("v.cancellationLevel");
        
        var idForRow = event.getSource().get('v.name');
        var valueRow = event.getSource().get('v.value');
             console.log('Line--266-->'+valueRow);
        // clear unchecked values
        if(valueRow==false){
            recData[idForRow].refundReason=null;
            recData[idForRow].status=null;
            recData[idForRow].refund=null; 
        }
        // checked values
        if(valueRow==true){
            for(var i = 0; i < recData.length; i++){
                if(recData[i].check==true && i!=idForRow){
                    recData[idForRow].refundReason=recData[i].refundReason;
                } 
            }
        }
        
        // checking all childs
        if(valueRow==true && level=='OLI'){
            var oliId =recData[idForRow].Id;
            for(var i = 0; i < recData.length; i++){
                if(recData[i].oliId==oliId){
                    recData[i].check=true;  
                    recData[i].refundReason=recData[idForRow].refundReason;
                } 
            }
            component.set("v.recordsData",recData);
        }
        
        else if(valueRow==false && level=='OLI'){
            var recId =recData[idForRow].oliId;
            
            if($A.util.isUndefined(recId)){
                var oliId =recData[idForRow].Id;
                for(var i = 0; i < recData.length; i++){
                    if(recData[i].oliId==oliId){
                        recData[i].check=false; 
                        recData[i].refundReason='';
                    } 
                } 
            }else{
                recData[idForRow].check=true;  
            }  
        }
        
        component.set("v.recordsData",recData);
    }, 
    
      checkChilds1 : function (component, event, helper){
        var recData = component.get("v.recordsDataDelete");
        var level = component.get("v.cancellationLevel");
        
        var idForRow = event.getSource().get('v.name');
        var valueRow = event.getSource().get('v.value');
        // clear unchecked values
        if(valueRow==false){
            recData[idForRow].refundReason=null;
            recData[idForRow].status=null;
            recData[idForRow].refund=null; 
        }
        // checked values
        if(valueRow==true ){
            for(var i = 0; i < recData.length; i++){
                if(recData[i].check==true && i!=idForRow){
                    recData[idForRow].refundReason=recData[i].refundReason;
                } 
            }
        }
         console.log('Inside255'+valueRow);
        // checking all childs
        if(valueRow==true  && recData[idForRow].level=='OLI'){//&& level=='OLI'
            console.log('Inside258');
            var oliId =recData[idForRow].Id;
            for(var i = 0; i < recData.length; i++){
                if(recData[i].oliId==oliId){
                    recData[i].check=true;  
                    recData[i].refundReason=recData[idForRow].refundReason;
                } 
                console.log('line263'+recData[i].level);
                 if(recData[i].oliId==oliId && recData[i].level=='AddOn'){
                         recData[i].check=true; 
                     console.log(' reccheck', recData[i].check);
                    }
                
            }
            
            component.set("v.recordsData",recData);
            
        }
        
        else if(valueRow==false  && recData[idForRow].level=='OLI'){// && level=='OLI'){
            var recId =recData[idForRow].oliId;
             
            if(!$A.util.isUndefined(recId)){
                var oliId =recData[idForRow].Id;
                for(var i = 0; i < recData.length; i++){
                    if(recData[i].oliId==oliId){
                        recData[i].check=false; 
                        recData[i].refundReason='';
                    } 
                     if(recData[i].oliId==oliId && recData[i].level=='AddOn'){
                         recData[i].check=false; 
                     console.log(' reccheck', recData[i].check);
                    }
                    
                     
                } 
              
            }else{
                recData[idForRow].check=true;  
            }  
        }
        
        component.set("v.recordsDataDelete",recData);
    }, 
    
    onCheck :  function(component, event, helper){
        var flag=  component.find("checkbox").get("v.value");
        console.log('flag -- '+flag)
        component.set("v.isCustomAccepted",flag);
    },
    
    onCheckInProgress :  function(component, event, helper){
        var flag=  component.find("checkbox").get("v.value");
        console.log('flag -- '+flag)
        component.set("v.isCustomAcceptedInProgress",flag);
    },
    
    autoCheckPendingDocs : function (component, event, helper){
        var recData = component.get("v.recordsDataApproval");
        var documentationReceived = component.get("v.documentationReceived");
        
        for(var i = 0; i < recData.length; i++){
            if(documentationReceived==true){
                if(recData[i].approvalStage=='Pending Documentation'){  
                    recData[i].check=true;
                }   
            }else if(documentationReceived==false){
                if(recData[i].approvalStage=='Pending Documentation'){  
                    recData[i].check=false;
                }
            }
        } 
        helper.calculateRefundApproval(component, event, helper,recData);
        component.set("v.recordsDataApproval",recData);        
    },
    populateOthersReason : function (component, event, helper){
        var recData = component.get("v.recordsData");
        var level = component.get("v.cancellationLevel");
        
        var idForRow = event.getSource().get('v.name');
         var valueRow = event.getSource().get('v.value');

        // checking all rows checked
        if(valueRow != ''){
            for(var i = 0; i < recData.length; i++){
                if(recData[i].check==true){
                    recData[i].refundReason=recData[idForRow].refundReason;  
                } 
            }
            component.set("v.recordsData",recData); 
        }
        if(valueRow == ''){
            for(var i = 0; i < recData.length; i++){
                if(recData[i].check==true){
                    recData[i].refundReason='';  
                } 
            }
            component.set("v.recordsData",recData); 
        }
    }
})