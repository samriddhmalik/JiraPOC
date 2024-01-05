({
    
    doInit : function(component, event, helper) {
        var getSourceObject = component.get("v.sourceObject");
        if(getSourceObject == "Case")
        {
            component.set("v.btnlabel",'Back');
            
        }
        
        console.log('recordId---4--',component.get("v.recordId"));
        helper.initialRecordTypeChecking(component,event,helper);

    },
    
    searchCoupon : function(component, event, helper){
        
        var getInputkeyWord = component.find("coupSearch").get("v.value"); 
        console.log('getInputkeyWord:'+getInputkeyWord);
        helper.fetchListOfCoupon(component,event,helper,getInputkeyWord);
        
    },
    
    openapplycouponform : function(component, event, helper){
          console.log('Line--41-Ajit->');
        component.set("v.openCouponform",true);
        
    },
    
    clear :function(component,event,helper){
        console.log('here in clear');
        $A.util.removeClass(component.find("inputPill"), 'slds-show');
        $A.util.addClass(component.find("inputPill"), 'slds-hide');
        $A.util.removeClass(component.find("inputField"), 'slds-hide');
        $A.util.addClass(component.find("inputField"), 'slds-show');
        $A.util.removeClass(component.find("couponInfo"), 'slds-show');
        $A.util.addClass(component.find("couponInfo"), 'slds-hide');
        $A.util.removeClass(component.find("couponDetails"), 'slds-show');
        $A.util.addClass(component.find("couponDetails"), 'slds-hide');
        $A.util.removeClass(component.find("newCoupon"), 'slds-show');
        $A.util.addClass(component.find("newCoupon"), 'slds-hide');
        component.set("v.selectedCoupon",''); 
        component.set("v.selectedOli",'');
        component.set("v.coupounAppValue",'');
        component.find("coupSearch").set("v.value",'');
        
    },
    
    showOrderLineList :  function(component, event, helper){
        
        var value = component.get("v.coupounAppValue")
        console.log('coupounAppValue'+value);
        $A.util.removeClass(component.find("newCoupon"), 'slds-hide');
        $A.util.addClass(component.find("newCoupon"), 'slds-show');
        if( value == 'OLI' ){
            console.log('under if===OLI');
            // component.set("v.showButton", false);
            
            $A.util.removeClass(component.find("listView"), 'slds-hide');
            $A.util.addClass(component.find("listView"), 'slds-show');
            // $A.util.removeClass(component.find("saveButton"), 'slds-show');
            //  $A.util.addClass(component.find("saveButton"), 'slds-hide');
            $A.util.removeClass(component.find("TAD"), 'slds-show');
            $A.util.addClass(component.find("TAD"), 'slds-hide');
            $A.util.removeClass(component.find("Amount"), 'slds-show');
            $A.util.addClass(component.find("Amount"), 'slds-hide');
        }else if(value == 'TAD'){
            //console.log('under if===TAD');
            //component.set("v.showButton", false);
            
            $A.util.removeClass(component.find("listView"), 'slds-show');
            $A.util.addClass(component.find("listView"), 'slds-hide');
            //  $A.util.removeClass(component.find("saveButton"), 'slds-hide');
            //  $A.util.addClass(component.find("saveButton"), 'slds-show');
            $A.util.removeClass(component.find("TAD"), 'slds-hide');
            $A.util.addClass(component.find("TAD"), 'slds-show');
            $A.util.removeClass(component.find("OLI"), 'slds-show');
            $A.util.addClass(component.find("OLI"), 'slds-hide');
            $A.util.removeClass(component.find("Amount"), 'slds-hide');
            $A.util.addClass(component.find("Amount"), 'slds-show');
            component.set("v.selectedOli",'');
        }
            //PSAG - 255 Start
            var isDiscountCoupon = component.get("v.hideDiscoundPercentage");
            var vardiscoundPercentage = component.get("v.discoundPercentage");
            var outstandingAmt = component.get("v.orderDetails.ordexp_amount_outstanding__c");
            console.log('isDiscountCoupon '+isDiscountCoupon+' vardiscoundPercentage '+vardiscoundPercentage+' outstandingAmt '+outstandingAmt);
            var discoundPercentageValue = (vardiscoundPercentage*outstandingAmt)/100;
            console.log('discoundPercentageValue '+discoundPercentageValue);
            component.set("v.couponAmount ", discoundPercentageValue);
            //PSAG - 255 Stop        
    },
    
    enableDisableButton :  function(component, event, helper){
        
        var value = component.get("v.selectedOli")
        if( value != '' ){
            console.log('under if===');
            component.set("v.showButton", true);
            
            // $A.util.removeClass(component.find("saveButton"), 'slds-hide');
            //  $A.util.addClass(component.find("saveButton"), 'slds-show');
            $A.util.removeClass(component.find("OLI"), 'slds-hide');
            $A.util.addClass(component.find("OLI"), 'slds-show');
            $A.util.removeClass(component.find("Amount"), 'slds-hide');
            $A.util.addClass(component.find("Amount"), 'slds-show');
        }else{
            console.log('under else===');
            component.set("v.showButton", false);
            
            //  $A.util.removeClass(component.find("saveButton"), 'slds-show');
            //  $A.util.addClass(component.find("saveButton"), 'slds-hide');
            $A.util.removeClass(component.find("OLI"), 'slds-show');
            $A.util.addClass(component.find("OLI"), 'slds-hide');
            $A.util.removeClass(component.find("Amount"), 'slds-show');
            $A.util.addClass(component.find("Amount"), 'slds-hide');
        }
        
    },
    
    
    closeModal : function(component,event,helper){
        
        var getSourceObject = component.get("v.sourceObject");
        var parentRecordId = component.get("v.recordId");
        if(getSourceObject == "Case")
        {
            var compEvent = component.getEvent("sampleComponentEvent");
            compEvent.setParams({
                "message" : 'From Paymethod Cancel',
                "TadOrderId": parentRecordId
            });
            compEvent.fire();
        }
        else{
            
            var closeEvent = $A.get("e.force:closeQuickAction");
            
            if(closeEvent){
                
                closeEvent.fire();
                
            } else{
                
                alert('force:closeQuickAction event is not supported in this Ligthning Context');
                
            }
        }
    },
    saveClick : function(component,event,helper){
        
        var recId = component.get("v.recordId");
        var coupounLevel = component.get("v.coupounAppValue");
        var coupoun = component.get("v.selectedCoupon");
        var oliSelected = component.get("v.selectedOli");
        var value = component.get("v.couponAmount");
        var couponDiscount = component.get("v.selectedCoupon.Discount__c");
        var outstandingAmt = component.get("v.orderDetails.ordexp_amount_outstanding__c");
        var orderValue = component.get("v.orderDetails.ordexp_gross_amount__c");
        var balanceRemaining = component.get("v.selectedCoupon.balance_remaining__c");
        var couponType = component.get("v.selectedCoupon.Usage__c");
        var lstOli = component.get("v.lstOfOli");
        var minOrderValue = component.get("v.selectedCoupon.Min_order_value__c");
        var oliOutstanding;
        for(var i=0;i<lstOli.length;i++){
            if(lstOli[i].Id == oliSelected){
                oliOutstanding = lstOli[i].orderxp_total_amount__c;
                break;
            }
        }
        console.log('hiiiii.....'+value+' outst '+outstandingAmt);
        
        //PSAG - 255 Start
        var isDiscountCoupon = component.get("v.hideDiscoundPercentage");
        var vardiscoundPercentage = component.get("v.discoundPercentage");
        var discoundPercentageValue = (vardiscoundPercentage*outstandingAmt)/100;
        var discoundPercentageValidationCheck = true;
        console.log('isDiscountCoupon '+JSON.stringify(isDiscountCoupon)+' vardiscoundPercentage '+JSON.stringify(isDiscountCoupon)+' discoundPercentageValue '+JSON.stringify(discoundPercentageValue));
        if(isDiscountCoupon == true && (vardiscoundPercentage != null || vardiscoundPercentage != undefind) && value > discoundPercentageValue){
            helper.showToast(component, "Error!", "error","dismissible","Coupon amount "+value+" is incorrect for Partner Discount Coupon Type!");
            discoundPercentageValidationCheck = false;
        }
        //PSAG - 255 Stop
        
               if(discoundPercentageValidationCheck == true){
            var recordTypeCheck = component.get("v.openCouponformfromHotel");
            if(recordTypeCheck == false){
                            if( value == '' || (coupounLevel == 'TAD' && (value > couponDiscount || value > outstandingAmt))){
                helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
            }
            else if(minOrderValue != '' && orderValue < minOrderValue){
                helper.showToast(component, "Error!", "error","dismissible","Minimum order value is not met to apply the coupon!");
            }
                else if(coupounLevel == 'OLI' && (value > couponDiscount || value > outstandingAmt || value > oliOutstanding)){
                    helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
                }
                    else if(couponType == 'Balance' && value > balanceRemaining){
                        helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
                    }
                        else{
                            component.set("v.loaded",false);
                            console.log('DataSave'+recId+'-'+coupounLevel+'-'+coupoun+'-'+oliSelected);
                            var action = component.get("c.saveOLICoupon");
                            
                            action.setParams({
                                "recId" : recId,
                                "coupounLevel" : coupounLevel,
                                "coupoun"	: coupoun,
                                "oliSelected" : oliSelected,
                                "discountAmount" : value
                            });
                            console.log('Before call back--');
                            action.setCallback(this, function(response) {
                                
                                console.log('After call back--'+response.getReturnValue());
                                if(response.getState() == 'SUCCESS'){
                                    var saveStatus = response.getReturnValue();
                                    console.log('saveStatus--'+saveStatus);
                                    if(saveStatus == 'True'){
                                        
                                        helper.showToast(component, "Success!", "success","dismissible","Coupon Applied Successfully!"); 
                                        component.set("v.loaded",true);
                                        
                                        var getSourceObject = component.get("v.sourceObject");
                                        var parentRecordId = component.get("v.recordId");
                                        if(getSourceObject == "Case")
                                        {
                                            var compEvent = component.getEvent("sampleComponentEvent");
                                            compEvent.setParams({
                                                "message" : 'From Coupon Applied',
                                                "TadOrderId": parentRecordId
                                            });
                                            compEvent.fire();
                                        }
                                        
                                        $A.get('e.force:refreshView').fire();
                                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                        dismissActionPanel.fire();
                                    }else if(saveStatus == 'rctError'){
                                            helper.showToast(component, "Error!", "error","dismissible","The coupon currency doesn't match the order currency so the coupon cannot be applied on this order"); 
                                            component.set("v.loaded",true);
                                     }else{
                                        
                                        helper.showToast(component, "Error!", "error","dismissible","This coupon has been used"); 
                                        component.set("v.loaded",true);
                                    }
                                }else if(response.getState() == "ERROR"){
                                    
                                    var errors = action.getError();
                                    var str = JSON.stringify(errors[0].message);
                                    var err = str.replace('\\n', '');
                                    helper.showToast(component, "Error!", "error","dismissible",err);
                                    component.set("v.loaded",true); 
                                }                    
                            });
                            $A.enqueueAction(action);
                            
                        }
            }
            else{
            if( value == '' || (coupounLevel == 'TAD' && (value > couponDiscount))){
                helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
            }
            else if(minOrderValue != '' && orderValue < minOrderValue){
                helper.showToast(component, "Error!", "error","dismissible","Minimum order value is not met to apply the coupon!");
            }
                else if(coupounLevel == 'OLI' && (value > couponDiscount || value > outstandingAmt || value > oliOutstanding)){
                    helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
                }
                    else if(couponType == 'Balance' && value > balanceRemaining){
                        helper.showToast(component, "Error!", "error","dismissible","Coupon amount is incorrect!");
                    }
                        else{
                            component.set("v.loaded",false);
                            console.log('DataSave'+recId+'-'+coupounLevel+'-'+coupoun+'-'+oliSelected);
                            var action = component.get("c.saveOLICoupon");
                            
                            action.setParams({
                                "recId" : recId,
                                "coupounLevel" : coupounLevel,
                                "coupoun"	: coupoun,
                                "oliSelected" : oliSelected,
                                "discountAmount" : value
                            });
                            console.log('Before call back--');
                            action.setCallback(this, function(response) {
                                
                                console.log('After call back--'+response.getReturnValue());
                                if(response.getState() == 'SUCCESS'){
                                    var saveStatus = response.getReturnValue();
                                    console.log('saveStatus--'+saveStatus);
                                    if(saveStatus == 'True'){
                                        
                                        helper.showToast(component, "Success!", "success","dismissible","Coupon Applied Successfully!"); 
                                        component.set("v.loaded",true);
                                        
                                        var getSourceObject = component.get("v.sourceObject");
                                        var parentRecordId = component.get("v.recordId");
                                        if(getSourceObject == "Case")
                                        {
                                            var compEvent = component.getEvent("sampleComponentEvent");
                                            compEvent.setParams({
                                                "message" : 'From Coupon Applied',
                                                "TadOrderId": parentRecordId
                                            });
                                            compEvent.fire();
                                        }
                                        
                                        $A.get('e.force:refreshView').fire();
                                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                        dismissActionPanel.fire();
                                    }else if(saveStatus == 'rctError'){
                                            helper.showToast(component, "Error!", "error","dismissible","The coupon currency doesn't match the order currency so the coupon cannot be applied on this order"); 
                                            component.set("v.loaded",true);
                                     }else{
                                        
                                        helper.showToast(component, "Error!", "error","dismissible","This coupon has been used"); 
                                        component.set("v.loaded",true);
                                    }
                                }else if(response.getState() == "ERROR"){
                                    
                                    var errors = action.getError();
                                    var str = JSON.stringify(errors[0].message);
                                    var err = str.replace('\\n', '');
                                    helper.showToast(component, "Error!", "error","dismissible",err);
                                    component.set("v.loaded",true); 
                                }                    
                            });
                            $A.enqueueAction(action);
                            
                        }
            }
        			}
    },
    closePopup :function(){
        
        var closeEvent = $A.get("e.force:closeQuickAction");
        
        closeEvent.fire();
        
        $A.get('e.force:refreshView').fire();  
        
    },
    
    convertCoupon : function(component, event, helper){
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    doFinalConversion : function(component, event, helper){
        helper.finalConversionStep(component, event, helper);
        
    }
})