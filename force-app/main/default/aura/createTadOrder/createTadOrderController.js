({
    doInit : function (component, event, helper){ 
        
        var tadOrderData;
          var recordId=component.get("v.recordId");
        console.log('recordId'+recordId);
        var getSourceObject = component.get("v.sourceObject");
        var getCaseId = component.get("v.caseID");
        console.log('caseID8===='+getCaseId);
        console.log('getSourceObject-----'+getSourceObject);
        
        var sObjectName = component.get("v.sObjectName");
        console.log('Log 1'+sObjectName);
        var recordId; 
      
        console.log('Log 2');
        var tadOrderData; 
        
        if(!$A.util.isUndefinedOrNull(recordId)  && sObjectName != "Saved_Deals__c"){
            console.log('Log 3');
            tadOrderData  = {'recordType': '','accountId': '','accountName': '','dealId': '','dealName': '','optionId': '','departureDateId': '','departureDateName': '','startDateSiteMinder': null,'endDateSiteMinder': null};
            component.set("v.tadOrderData", tadOrderData);  
        } 
        if($A.util.isUndefinedOrNull(recordId) && getSourceObject != "Case" && sObjectName != "Saved_Deals__c"){
            
            console.log('Log 4');
            var pageRef = component.get("v.pageReference");
            console.log('pageRef ==>'+JSON.stringify(pageRef));
            var state = pageRef.state;
            var base64Context = state.inContextOfRef;
            
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            
            if(addressableContext!=null){
                var getAccountid = addressableContext.attributes.recordId;
                console.log('getAccountid'+getAccountid);
                if(!$A.util.isUndefinedOrNull(getAccountid)){
                     console.log('GetAccount if'+getAccountid);
                    helper.getAccountDetails(component,event,helper,getAccountid,tadOrderData,'nonCase'); 
                }else{
                    console.log('GetAccount else'+getAccountid);
                    var tadOrderData = {'recordType': '','accountId': '','accountName': '','dealId': '','dealName': '','optionId': '','departureDateId': '','departureDateName': '','startDateSiteMinder': null,'endDateSiteMinder': null};
                    component.set("v.tadOrderData", tadOrderData);  
                }
            }     
        }
        
         // For create tad order from Saved Deal by Munesh
         
        console.log('Log 56');
        if(sObjectName == "Saved_Deals__c"){
            console.log('Log 56');
             var action = component.get("c.TadOrdercreation");
        action.setParams({
            'saveddealId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('result303'+JSON.stringify(result));
              
              
            var dealId = result.dealId;
            var accountId = result.accountId;
            var accountName = result.accountName;
            var DealName = result.dealName;
            component.set("v.SavedDealID", result.savedDealId); 
            component.set("v.caseID", result.caseId);     
            console.log('log 53===>'+dealId+' '+accountId+' '+accountName+' '+DealName);
            tadOrderData  = {'recordType': 'TAD','accountId': accountId,'accountName': accountName,'dealId': dealId,'dealName': DealName,'optionId': '','departureDateId': '','departureDateName': '','startDateSiteMinder': null,'endDateSiteMinder': null};
            component.set("v.tadOrderData", tadOrderData);  
            //  component.set("v.isNotCase", false); 
            
            
            var dealLookupPill = component.find("dealLookupPill");
            $A.util.removeClass(dealLookupPill, 'slds-hide');
            $A.util.addClass(dealLookupPill, 'slds-show');
            
            var dealLookupField = component.find("dealLookupField");
            $A.util.removeClass(dealLookupField, 'slds-show');
            $A.util.addClass(dealLookupField, 'slds-hide');
            
            helper.getAvailableOptions(component, event, helper,dealId);
            
            
            component.set("v.isCase", true);
                       
            } 
             }
                          );
        $A.enqueueAction(action);  
            /////   Create TadOrder from saved deal  end
            
        }
        
         if(getSourceObject == "Case" && $A.util.isUndefinedOrNull(recordId)){
            console.log('Log 5 from case');
            var dealId = component.get("v.DealId");
            var accountId = component.get("v.AccountId");
            var accountName = component.get("v.accountName");
            var DealName = component.get("v.DealName");
            console.log('log 53===>'+dealId+' '+accountId+' '+accountName+' '+DealName);
            helper.getAccountDetails(component,event,helper,accountId,tadOrderData,'');
            tadOrderData  = {'recordType': 'TAD','accountId': accountId,'accountName': accountName,'dealId': dealId,'dealName': DealName,'optionId': '','departureDateId': '','departureDateName': '','startDateSiteMinder': null,'endDateSiteMinder': null};
            component.set("v.tadOrderData", tadOrderData);  
            //  component.set("v.isNotCase", false); 
            
            
            var dealLookupPill = component.find("dealLookupPill");
            $A.util.removeClass(dealLookupPill, 'slds-hide');
            $A.util.addClass(dealLookupPill, 'slds-show');
            
            var dealLookupField = component.find("dealLookupField");
            $A.util.removeClass(dealLookupField, 'slds-show');
            $A.util.addClass(dealLookupField, 'slds-hide');
            
            helper.getAvailableOptions(component, event, helper,dealId);
            
            
            component.set("v.isCase", true);
        }           
    },
    
    // Deal Lookup Field Code
    fetchDealRecords : function(component,event,helper){
        var getInputkeyWord = component.get("v.SearchKeyWord"); 
        if( getInputkeyWord.length > 0 ){
            helper.fetchDealRecordsHelper(component,event,helper,getInputkeyWord);
        }else{
            component.set("v.searchedDeal",null); 
        } 
    }, 
    
     fetchAccountRecords : function(component,event,helper){
        var getInputkeyWord = component.get("v.SearchAccKeyWord"); 
        console.log('Line140 '+getInputkeyWord);
        if( getInputkeyWord.length > 0 ){
            helper.fetchAccountRecordsHelper(component,event,helper,getInputkeyWord);
        }else{
            component.set("v.searchedAccount",null); 
        } 
        var searchedAccount = component.get("v.searchedAccount",null);
        console.log('Line146 '+searchedAccount);
    },   
    
    loading : function(component,event,helper){
        component.set("v.isLoading",true);
    },
    
    loaded : function(component,event,helper){
        component.set("v.isLoading",false);
    },
    
    selectRecord : function(component, event, helper){      
        var selectedItem = event.currentTarget;
        var idForRow = selectedItem.dataset.record;
        var dealData = component.get("v.searchedDeal");
        
        console.log('Selected Deal'+JSON.stringify(dealData[idForRow]));
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.dealId=dealData[idForRow].Id;
       
        tadOrderData.dealName=dealData[idForRow].Deal_ID_Title__c;
        component.set("v.tadOrderData",tadOrderData);
        
        component.set("v.searchedDeal",null);
        
        var dealLookupPill = component.find("dealLookupPill");
        $A.util.removeClass(dealLookupPill, 'slds-hide');
        $A.util.addClass(dealLookupPill, 'slds-show');
        
        var dealLookupField = component.find("dealLookupField");
        $A.util.removeClass(dealLookupField, 'slds-show');
        $A.util.addClass(dealLookupField, 'slds-hide');
        
        helper.getAvailableOptions(component, event, helper,dealData[idForRow].Id);
    },
    
    selectAccRecord : function(component, event, helper){      
        var selectedItem = event.currentTarget;
        var idForRow = selectedItem.dataset.record;
        var AccData = component.get("v.searchedAccount");
        
        console.log('Selected Account'+JSON.stringify(AccData[idForRow]));
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.accountId=AccData[idForRow].Id;
         var accId =  tadOrderData.accountId;
        console.log('Line167 '+accId);
         helper.getAccountDetails(component,event,helper,accId,tadOrderData,'nonCase');
        tadOrderData.accountName=AccData[idForRow].Name;
        console.log('postalcode acc'+AccData[idForRow].ShippingPostalCode);
        component.set("v.tadOrderData",tadOrderData);
        
        /*code to check account postal code
        if(AccData[idForRow].ShippingPostalCode==null ||  AccData[idForRow].ShippingPostalCode=='' || $A.util.isUndefined(AccData[idForRow].ShippingPostalCode)){
            component.set("v.showPostal",true);
            component.set("v.postcodeValidity",false);
        }else{
            component.set("v.showPostal",false);
            component.set("v.postcodeValidity",true);
        }
        
        component.set("v.searchedAccount",null);
        */
        var AccountLookupPill = component.find("AccountLookupPill");
        $A.util.removeClass(AccountLookupPill, 'slds-hide');
        $A.util.addClass(AccountLookupPill, 'slds-show');
        
        var AccountLookupField = component.find("AccountLookupField");
        $A.util.removeClass(AccountLookupField, 'slds-show');
        $A.util.addClass(AccountLookupField, 'slds-hide');
        
    },
    
    
    clearDeal: function(component, event, helper) {
        
        var dealLookupPill = component.find("dealLookupPill");
        $A.util.removeClass(dealLookupPill, 'slds-show');
        $A.util.addClass(dealLookupPill, 'slds-hide');
        
        var dealLookupField = component.find("dealLookupField");
        $A.util.removeClass(dealLookupField, 'slds-hide');
        $A.util.addClass(dealLookupField, 'slds-show');
        
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.dealId='';
        tadOrderData.dealName='';
        tadOrderData.departureDateId='';
        tadOrderData.departureDateName='';
        component.set("v.tadOrderData",tadOrderData);
        
        component.set("v.optionsList",null);
        component.set("v.allocationMonthList",null);
        component.set("v.allocationMonth",'');
        component.set("v.allocationYear",'');
        component.set("v.allocationYearList",null);
        component.set("v.filteredAllocationData",null);
        component.set("v.SearchKeyWord",'');
        component.set("v.subOptionValuesList",null);
        component.set("v.subOptionSelected",'');
        component.set("v.isSiteMinder",null);
    },
    // Deal Lookup Field Code
    // 
     clearAcc: function(component, event, helper) {
        
        var AccountLookupPill = component.find("AccountLookupPill");
        $A.util.removeClass(AccountLookupPill, 'slds-show');
        $A.util.addClass(AccountLookupPill, 'slds-hide');
        
        var AccountLookupField = component.find("AccountLookupField");
        $A.util.removeClass(AccountLookupField, 'slds-hide');
        $A.util.addClass(AccountLookupField, 'slds-show');
        
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.accountId='';
        tadOrderData.accountName='';
        component.set("v.tadOrderData",tadOrderData);
        
        component.set("v.SearchAccKeyWord",'');
    },
    
    updateTadOrderRecordAccount: function(component, event, helper) {
        var accountId = component.find("accountName").get("v.value");
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.accountId=accountId;
        component.set("v.tadOrderData",tadOrderData);
         console.log('this is in event');
         var Acid = component.get("v.tadOrderRecord.ordexp_account__c");
        console.log('this is in event Acid'+Acid);
       console.log('this is in event accountId'+accountId);
       var action = component.get("c.showPostalCode");
        action.setParams({
            'AccId': accountId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
                component.set("v.showPostal",result);
             console.log('result=='+result);
        });
        $A.enqueueAction(action); 
 
    },   
    
    fetchAllocation: function(component, event, helper) {
        var allocationBy = component.get("v.allocationBy");
        if(allocationBy=='Option'||allocationBy=='Sub option'){
            component.set("v.allocationMonthList",null);
            component.set("v.allocationYearList",null);
            component.set("v.tadOrderData.departureDateName",null);
            component.set("v.filteredAllocationData",null);
            component.set("v.allocationMonth",'');
            component.set("v.allocationYear",'');
            helper.fetchAllocationHelper(component, event, helper,allocationBy);  
        }
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
        var getSubOptionId = component.get("v.subOptionSelected");
        var allocationData = component.get("v.allocationData");
 
        component.set("v.tadOrderData.subOptionId",getSubOptionId);        
        
        var allocation=[];
        for(var i = 0; i < allocationData.length; i++){
            if(getSubOptionId!='' && allocationYear!='' && allocationMonth!='' ){
                if(allocationData[i].allocationMonth==allocationMonth && allocationData[i].allocationYear==allocationYear && allocationData[i].subOptionId ==getSubOptionId){
                    allocation.push(allocationData[i]);  
                } 
            }else if (allocationYear!='' && allocationMonth!=''){
                if(allocationData[i].allocationMonth==allocationMonth && allocationData[i].allocationYear==allocationYear){
                    allocation.push(allocationData[i]);
                }
            }
        }
        
        component.set("v.filteredAllocationData",allocation);  
    },
    
    updateDepartureDate: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var idForRow = selectedItem.dataset.record;
        
        var allocationData = component.get("v.filteredAllocationData");
        var tadOrderData = component.get("v.tadOrderData");
        tadOrderData.departureDateName=allocationData[idForRow].DateValue;
        tadOrderData.departureDateId=allocationData[idForRow].dateId;
        
        component.set("v.tadOrderData",tadOrderData);  
    },
    
    checkStartDate: function(component,event,helper){
        
        var tadOrderData = component.get("v.tadOrderData");
        if((tadOrderData.subOptionId == null || tadOrderData.subOptionId == '') && (tadOrderData.startDateSiteMinder != null || tadOrderData.startDateSiteMinder != '')){
            helper.showToast(component, "Error!", "error","dismissible","Please select the Sub Option before selecting the Start Date.");
            tadOrderData.startDateSiteMinder = '';
            component.set("v.tadOrderData",tadOrderData);  
        }else if(new Date(tadOrderData.startDateSiteMinder) != null || new Date(tadOrderData.startDateSiteMinder) != ''){
            helper.validateSiteminderStartDate(component,event,helper,tadOrderData);
        }
        
    },
    
    checkEndDate: function(component, event, helper) {
        var tadOrderData = component.get("v.tadOrderData");
        if(new Date(tadOrderData.startDateSiteMinder) > new Date(tadOrderData.endDateSiteMinder)){
            helper.showToast(component, "Error!", "error","dismissible","End Date can't be less than Start Date.");   
            tadOrderData.endDateSiteMinder='';
            component.set("v.tadOrderData",tadOrderData);   
        }
        
    },
    
    validateAndSaveTadOrder: function(component, event, helper) {
        var tadOrderData = component.get("v.tadOrderData");
        console.log('tadOrderData'+JSON.stringify(tadOrderData));
        var isSiteMinder = component.get("v.isSiteMinder");
        var proceed =true;
        var orderPostalCode = component.get("v.postalCode");
        var postcodeValidity = component.get("v.postcodeValidity");
        var showPostal = component.get("v.showPostal");
        
        if(tadOrderData.recordType==''||tadOrderData.accountId==''|| tadOrderData.dealId==''||tadOrderData.optionId=='' || (orderPostalCode == '' && showPostal==true)){
            proceed =false; 
            helper.showToast(component, "Error!", "error","dismissible","All visible fields must be filled.");  
        }
        if((tadOrderData.departureDateId =='' && isSiteMinder!=true) || (orderPostalCode == '' && showPostal==true)){
            proceed =false;
            helper.showToast(component, "Error!", "error","dismissible","All visible fields must be filled."); 
        }
        if((tadOrderData.startDateSiteMinder ==null || tadOrderData.endDateSiteMinder ==null || (orderPostalCode == '' && showPostal==true)) && isSiteMinder==true){
            proceed =false;
            helper.showToast(component, "Error!", "error","dismissible","All visible fields must be filled."); 
        }if(postcodeValidity==false){
            proceed =false;
            helper.showToast(component, "Error!", "error","dismissible","Please enter correct postcode."); 
        }
        
      /*  var filteredAllocationData = component.get("v.filteredAllocationData");
        if($A.util.isUndefined(filteredAllocationData) || $A.util.isEmpty(filteredAllocationData)){
            helper.showToast(component, "Error!", "error","dismissible","Please re-check if allocation is available for this date."); 
        	proceed =false;
        } */
        
        if(isSiteMinder==true && proceed==true){
            // Record to get dates list
            var getDates = function(startDate, endDate) {
                var dates = [],
                    currentDate = startDate,
                    addDays = function(days) {
                        var date = new Date(this.valueOf());
                        date.setDate(date.getDate() + days);
                        return date;
                    };
                while (currentDate <= endDate) {
                    var dd = currentDate.getDate();
                    var mm = currentDate.getMonth()+1; 
                    var yyyy = currentDate.getFullYear();
                    if(dd<10) 
                    {
                        dd='0'+dd;
                    } 
                    if(mm<10) 
                    {
                        mm='0'+mm;
                    } 
                    dates.push(yyyy+'-'+mm+'-'+dd);
                    currentDate = addDays.call(currentDate, 1);
                }
                return dates;
            };
            
            var datesList = getDates(new Date(tadOrderData.startDateSiteMinder), new Date(tadOrderData.endDateSiteMinder)-1);                                                                                                           
            console.log('datesList'+datesList);
            var dateFound =false; 
         /*   for(var i = 0; i < datesList.length; i++){
                for(var j = 0; j < filteredAllocationData.length; j++){
                    if(datesList[i]==filteredAllocationData[j].DateValue){
                        dateFound=true;
                        break;
                    }else{
                        dateFound=false;
                    } 
                }
                if(dateFound==false){
                    proceed =false;
                    helper.showToast(component, "Error!", "error","dismissible","Please re-check if allocation is available for this date."); 
                    break;
                }
            }  */
        }
        // getting dates list ends
        console.log('proceed'+proceed);
        if(proceed ==true){
            var mySpinner = component.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
            helper.saveTadOrder(component, event, helper,tadOrderData);
        }
    },
    
    navigateToRecord : function(component, event, helper) {
        helper.navigateToRecord(component, event, helper);
    }, 
    
    openModal: function(component, event, helper) {
        //    var sObjectNamee = component.get("v.sObjectName");
         console.log('Log 1-->>--- '+component.get("v.sObjectName"));
       // console.log('sObjectNamee 1>> '+sObjectNamee);
        var getSourceObject = component.get("v.sourceObject");
         console.log('getSourceObject 1>> '+getSourceObject);
      
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        var getCaseId = component.get("v.caseID");
        console.log('openModal'+parentRecordId);
         console.log('getCaseId--'+getCaseId);
        if(getSourceObject == "Case"){
                        
            var action = component.get("c.tagOrdertoCase");
            action.setParams({
                "tadId" : parentRecordId,
                "caseId" : getCaseId
            });
            
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState(); 
                if(state === "SUCCESS"){
                    var getSourceObject = component.get("v.sourceObject");
                    if(getSourceObject == "Case")
                    {
                        var compEvent = component.getEvent("sampleComponentEvent");
                        compEvent.setParams({
                            "message" : 'From TadOrder',
                            "TadOrderId": parentRecordId
                        });
                        compEvent.fire();
                    }
                    
                }
            });
            $A.enqueueAction(action);  
        }
        else
        {
            component.set("v.isModalOpen",true); 
        } 
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen",false); 
    },
    
    closeWorkspace: function(component, event, helper) {
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        
        var getSourceObject = component.get("v.sourceObject");
        if(getSourceObject == "Case")
        {
            var compEvent = component.getEvent("sampleComponentEvent");
            compEvent.setParams({
                "message" : 'From TadOrder Cancel',
                "TadOrderId": parentRecordId
            });
            compEvent.fire();
        }
        else
        {
            helper.closeWorkspaceHelper(component,event,helper,'');
        }
    },
    
    submitDetailsToCallOLIFlow : function(component,event,helper){
        helper.callTheOLIFlow(component,event,helper);
    },
   
    validatePostCode: function(component, event, helper) {
        var validity = event.getSource().get("v.validity");
        console.log('validity1'+validity.valid); //returns true
        if(validity.valid==true){
            component.set("v.postcodeValidity",true);
        }else{
            component.set("v.postcodeValidity",false);
        }
        
    },
    
    
})