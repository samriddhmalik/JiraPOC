({
    doInit : function(component, event, helper)
    { 
        var getRecordList = component.get("v.recordList");
        console.log('getRecordList getRecordList getRecordList'+JSON.stringify(getRecordList));
        var opts = [];
        var OCStatus = component.get("v.OCStatus");
        helper.fetchPicklistValuesForAvailableFor(component,event,helper);
        //  helper.fetchPicklistValuesForQuoteStatus(component,event,helper);
        console.log('readOnlyOcStatus'+OCStatus);
        if(OCStatus != 'Customer Approved') {
            opts = [{ value: "", label: "None" },
                    { value: "Approve", label: "Quote Received" },
                    { value: "Decline", label: "Quote Decline"}]; 
        } else {
            opts = [{ value: "CustomerApproved", label: "Quote Accepted"}];
            
        }
        component.set('v.requestStatusOptions', opts);
    },
    
    doChange : function(component, event, helper)
    { 
        var opts = [];
        var OCStatus = component.get("v.OCStatus");
        console.log('readOnlyOcStatus 2'+OCStatus);
        if(OCStatus != 'Customer Approved') {
            opts = [{ value: "", label: "None" },
                    { value: "Approve", label: "Quote Received" },
                    { value: "Decline", label: "Quote Decline"}]; 
        } else {
            opts = [{ value: "CustomerApproved", label: "Quote Accepted"}];
            
        }
        component.set('v.requestStatusOptions', opts);
    },
    
    confirmEdit : function(component, event, helper)
    {
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.valkey;
        var recordList = component.get("v.recordList");
        var isEditing = component.get("v.isEditing");
        component.set("v.isEditing",true);
        if(!isEditing) {
            var Pending = component.get("v.Pending");
            var OCStatus = component.get("v.OCStatus");console.log('1');
            var CustomerApproved = component.get("v.CustomerApproved");console.log('2');
            if((recordList[index].requestStatus == Pending || recordList[index].requestStatus == 'Quote Requested') || (OCStatus == 'Customer Approved' && (recordList[index].requestStatus != CustomerApproved || recordList[index].requestStatus != 'Quote Accepted'))) {
                console.log('3'); 	
                component.set("v.recordListBackup",JSON.parse(JSON.stringify(recordList)));
                console.log('4');
                recordList[index].requestStatusEditabale = true;console.log('5');
                component.set("v.currentIndex",index);  console.log('6');
            }     console.log('7');
        }console.log('8');
        console.log('---'+JSON.stringify(recordList));
        component.set("v.recordList", recordList);
    },
    
    changeRequestStatus : function(component, event, helper) {
        var requestStatus = component.find("requestStatusId").get("v.value");
        console.log('requestStatus'+requestStatus);
        var Approve = component.get("v.Approve");
        var Decline = component.get("v.Decline");
        if(requestStatus == Approve) {
            helper.accept(component,event,helper,requestStatus);
        }
        else if(requestStatus == Decline) {
            helper.decline(component,event,helper,requestStatus);
        }
    },
    
    saveEdit : function(component, event, helper) {
        var index = component.get("v.currentIndex");
        var recordList = component.get("v.recordList");
        
        var qd = {}; var errorFlag=false;
        qd.Id = recordList[index].Id;
        qd.Quote_Approval_Status__c = recordList[index].requestStatus;
        console.log('Approve'+recordList[index].requestStatus);
        
        var Approve = component.get("v.Approve");
        var Decline = component.get("v.Decline");
        
        if(recordList[index].requestStatus == Approve) {
            if(recordList[index].merchantQuoteDetails != '' && recordList[index].merchantQuoteDetails != undefined) {
                qd.mp_Merchant_Quoted_Details__c = recordList[index].merchantQuoteDetails;
            } else {
                component.find("merchantQuoteDetailsId").showHelpMessageIfInvalid();
                errorFlag = true;
            }
            if(recordList[index].quoteAvailableFor != '' && recordList[index].quoteAvailableFor != undefined) {
                qd.Available_For__c = recordList[index].quoteAvailableFor;
            } else {
                component.find("quoteAvailableForId").showHelpMessageIfInvalid();
                errorFlag = true;
            }
            if(recordList[index].merchantPrice != '' && recordList[index].merchantPrice != undefined) {
                qd.mp_Merchant_Price__c = recordList[index].merchantPrice;
            } else {
                component.find("merchantPriceId").showHelpMessageIfInvalid();
                errorFlag = true;
            }
        } 
        else if(recordList[index].requestStatus == Decline) {
            
            if(recordList[index].merchantDeclineReason != '' && recordList[index].merchantDeclineReason != undefined) {
                qd.mp_Quote_Decline_Reason__c = recordList[index].merchantDeclineReason;
            } else {
                component.find("merchantDeclineReasonId").showHelpMessageIfInvalid();
                errorFlag = true;
            }
        }
        
        console.log('sending Param'+JSON.stringify(qd));
        if(!errorFlag) {
            
            recordList[index].requestStatusEditabale = undefined;
            recordList[index].merchantQuoteDetailsEditabale = undefined;
            recordList[index].merchantDeclineReasonEditabale = undefined;
            recordList[index].quoteAvailableForEditabale = undefined;
            recordList[index].merchantPriceEditabale = undefined;
            
            console.log('recordList'+JSON.stringify(recordList[index]));
            
            
            var action = component.get("c.saveCustomisation");
            action.setParams({
                
                "qd" : qd
                
            });
            action.setCallback(this, function(response) {
                if(response.getReturnValue() == true) {
                    console.log('saved'+JSON.stringify(response));
                    window.location.reload();
                } else {
                    console.log('Couldnot saved'+JSON.stringify(response));
                }        
            });
            $A.enqueueAction(action);
        }
        
    },
    
    cancelEdit : function(component, event, helper) {
        var recordListBackup = component.get("v.recordListBackup");
        component.set("v.recordList",recordListBackup);
        var index = component.get("v.currentIndex");
        component.set("v.currentIndex",-1);  
        component.set("v.isEditing",false);
        helper.resetEdit(component,event,helper,index);
        
    },
    
    onButtonPressed : function(component,event,helper){
        
        var idForRow = event.getSource().get('v.value');
        console.log("Row No : " + idForRow);
        var getTheList = component.get("v.recordList");
        console.log("getTheList " + JSON.stringify(getTheList));
        var getTheRecord = getTheList[idForRow];
        console.log("getTheRecord " + JSON.stringify(getTheRecord));
        console.log('Individual Records'+getTheRecord.Id+' '+getTheRecord.merchantName);
        component.set("v.recordListSingle",getTheRecord);
        component.set("v.recordListSingle2",getTheRecord);
        helper.openTheModal(component,event,helper);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false
        var toSetToNull = component.get("v.recordListSingle2");  
        component.set("v.recordListSingle",toSetToNull);
        component.set("v.isModalOpen", false);
        
    },
    
    submitDetails : function(component,event,helper){
        var getTheObjectDetail = component.get("v.recordListSingle");
        console.log('getTheObjectDetail'+JSON.stringify(getTheObjectDetail));
        
        if(getTheObjectDetail.merchantQuoteApprovalStatus == 'Decline'){
            if(getTheObjectDetail.merchantDeclineReason == null || getTheObjectDetail.merchantDeclineReason == ''){
                helper.showToast(component, "Error!", "error", "If you wish to decline, you must fill the Merchant Decline Reason.");
            }else{
            helper.updateTheQuoteDetailRecord(component,event,helper);
        }
        }else if(getTheObjectDetail.requestStatus == "Quote Received"){
            if(getTheObjectDetail.merchantQuoteDetails == null || getTheObjectDetail.requestStatus == '' || getTheObjectDetail.merchantPrice == null || getTheObjectDetail.merchantPrice == ''){
                helper.showToast(component, "Error!", "error", "Please enter Merchant Quoted Details and Merchant Price for 'Quote Received' Status.");
            }else{
                helper.updateTheQuoteDetailRecord(component,event,helper);
            }
        }else{
            helper.updateTheQuoteDetailRecord(component,event,helper);
        }
        
    },
    
    addTheCheckedRows : function(component,event,helper){
        var idForRow = event.getSource().get('v.name');
        var listReceivedOnInit = component.get("v.recordList");
        var consolidatedPrice = 0;
        var selectedQuotedetailsId = [];
        
        var j = 0;
        var k = 0;
        
        for(var i = 0; i < listReceivedOnInit.length ; i++){
            if(listReceivedOnInit[i].check == true){
                consolidatedPrice = consolidatedPrice + listReceivedOnInit[i].tadPrice;
                selectedQuotedetailsId.push(listReceivedOnInit[i].Id);
                j++;
            }
            
            if(listReceivedOnInit[i].requestStatus != 'Quote Decline' && listReceivedOnInit[i].merchantQuoteApprovalStatus != 'Decline' && listReceivedOnInit[i].tadPrice > 0){
                k++;
            }
        } 
        
        if(j == k){
            component.find("masterRecordSelector").set("v.value",true);
        }else{
            component.find("masterRecordSelector").set("v.value",false);
        }
        component.set("v.selectedQuoteDetailsId",selectedQuotedetailsId);
        component.set("v.consolidatedPriceToBeSent", consolidatedPrice);
        
    },
    
    checkAllTheEnabledCheckboxes : function(component,event,helper){
        var isChecked = component.find("masterRecordSelector").get("v.value");
        console.log('isChecked isChecked isChecked'+isChecked);
        component.set("v.masterCheckboxSelect",isChecked);
        
        var listReceivedOnInit = component.get("v.recordList");
        console.log('listReceivedOnInit listReceivedOnInit'+JSON.stringify(listReceivedOnInit[0]));
        
        var consolidatedPrice = 0;
        var selectedQuotedetailsId = [];
        
        for(var i = 0; i < listReceivedOnInit.length ; i++){
                if(listReceivedOnInit[i].requestStatus != 'Quote Decline' && listReceivedOnInit[i].merchantQuoteApprovalStatus != 'Decline' && listReceivedOnInit[i].tadPrice > 0){
                    console.log('Entering for 1');
                    listReceivedOnInit[i].check = isChecked;
                    selectedQuotedetailsId.push(listReceivedOnInit[i].Id);
                    consolidatedPrice = consolidatedPrice + listReceivedOnInit[i].tadPrice;
                }     
            } 
        
        component.set("v.recordList",listReceivedOnInit);
        component.set("v.selectedQuoteDetailsId",selectedQuotedetailsId);
        component.set("v.consolidatedPriceToBeSent", consolidatedPrice);
        
    }
})