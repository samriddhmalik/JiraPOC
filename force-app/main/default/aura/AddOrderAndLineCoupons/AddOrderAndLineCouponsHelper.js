({
    fetchListOfCoupon : function(component, event, helper, getInputkeyWord) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        
        var action = component.get("c.fetchTADDealCoupon");
        action.setParams({
            "ordId" : component.get("v.recordId"),
            "Keyword" : getInputkeyWord
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            
            if(response.getState() == 'SUCCESS'){
                var data = response.getReturnValue();
                component.set('v.selectedCoupon', null);
                // console.log('data - data - data'+JSON.stringify(data));
                component.set("v.selectedCoupon",data);
                var recordTypeVar = component.get("v.orderRecordType"); 
                  console.log('recordTypeVar '+recordTypeVar);
                if((recordTypeVar == 'TAD' || recordTypeVar == 'TC') && data.currency_code__c == 'NZD' && data.Status__c == 'Enabled' && data.Usage__c != 'Multi'){
                    component.set("v.hideThisForConversion", false);
                    component.set("v.showConversionMessage", true);                      
                }else{
                    component.set("v.hideThisForConversion", true);
                    component.set("v.showButton", true);
                }
                //PSAG - 255 Start
                console.log('Coupon '+JSON.stringify(data.Is_percentage_based__c));
                if(data.Is_percentage_based__c == true){
                    component.set("v.hideDiscoundPercentage ", data.Is_percentage_based__c);
                    component.set("v.discoundPercentage ", data.Discount_percentage__c);
                }
                //PSAG - 255 Stop
                
                $A.util.removeClass(component.find("inputPill"), 'slds-hide');
                $A.util.addClass(component.find("inputPill"), 'slds-show');
                $A.util.removeClass(component.find("inputField"), 'slds-show');
                $A.util.addClass(component.find("inputField"), 'slds-hide');
                $A.util.removeClass(component.find("couponInfo"), 'slds-hide');
                $A.util.addClass(component.find("couponInfo"), 'slds-show');
                $A.util.removeClass(component.find("couponDetails"), 'slds-hide');
                $A.util.addClass(component.find("couponDetails"), 'slds-show');
                
            }else{
                var errors = action.getError();
                console.log('Line 49 data '+JSON.stringify(errors));
                console.log('Line 49 data '+JSON.stringify(errors[0].message));
                 if(errors[0].message === 'singleMultiCouponExist'){
                    this.showToast(component, "Error!", "error","dismissible","Only one percentage/multi/single based coupon can be applied on an order"); 
                }else if (errors[0].message === 'percentageCouponHotel'){
                     this.showToast(component, "Error!", "error","dismissible","Percentage coupon can't be applied on Hotel Stays"); 
                }else if(errors[0].message === 'couponDisabled'){
                    this.showToast(component, "Error!", "error","dismissible","Coupon is already used!"); 
                }else if(errors[0].message === 'NoUseThisTypeOfCouon'){
                    this.showToast(component, "Error!", "error","dismissible","You can't use promotion Coupon if promtion coupon already used on order."); 
                }else{
                  this.showToast(component, "Error!", "error","dismissible","Please re-check the voucher code"); 
                }
            } 
        });
        $A.enqueueAction(action);
        
    },
    fetchOrderLineItem : function(component, event, helper){
        var action = component.get("c.fetchOrderLineItem");
        
        action.setParams({
            "OrderId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            
            if(response.getState() == 'SUCCESS' && response.getReturnValue() != null && response.getReturnValue() != '' ){
                var data = response.getReturnValue();
                //console.log('DataOLI'+JSON.stringify(data));
                component.set("v.lstOfOli",data);
                var opt = [
                    {'label': 'TAD Order', 'value': 'TAD'},
                    //{'label': 'Order Line Item', 'value': 'OLI'}
                ]
                    component.set("v.options",opt);
                    }
                    else{
                    var opt = [
                    {'label': 'TAD Order', 'value': 'TAD'}
                ]
                component.set("v.options",opt);
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
            "mode":mode,
            "duration" : 50
        });
        toastEvent.fire();
    },
    
    oliPricingModel: function (component, event, helper) {
        var recId =component.get("v.recordId");
        var action = component.get("c.checkOliPax");
        action.setParams({  dealId : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.orderRecordType",storeResponse.recordType);
                if(storeResponse=='fail'){
                    component.set('v.validation','failed');
                    $A.util.removeClass(component.find("oilModel"), 'slds-hide');
                    $A.util.addClass(component.find("oilModel"), 'slds-show');
                }
                else{
                    this.addOnPricingModel(component, event, helper);
                }
                
            }    
            
        });
        $A.enqueueAction(action);
    },
    
    addOnPricingModel: function (component, event, helper){
        var action = component.get('c.checkAddonPriceModel');
        action.setParams({
            "id" : component.get("v.recordId")   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result)
                {
                    $A.util.removeClass(component.find("addOnModel"), 'slds-hide');
                    $A.util.addClass(component.find("addOnModel"), 'slds-show');
                    component.set('v.validation','failed');   
                }
                else
                {	
                    component.set('v.validation','success');
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);	
    },
        initialRecordTypeChecking: function (component, event, helper){
        var action = component.get('c.initialRecordTypeChecking');
        action.setParams({
            "id" : component.get("v.recordId")   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('Line--182-->'+result);
               if((result == 'TAD') || (result == 'TC'))
                {
                    console.log('Line--185-->'+result);
                    component.set('v.orderRecordType',result);
                
                    this.fetchOrderLineItem(component,event,helper);
                    this.oliPricingModel(component,helper,event); 
                    
                }
                else
                {	
                    console.log('Line--191-->'+result);
                    component.set("v.openCouponformfromHotel",true);
                    this.fetchOrderLineItem(component,event,helper);
                    this.hotelRecordType(component,helper,event);
                    
                }
            }
        });
        $A.enqueueAction(action);	
    },
    
        
    hotelRecordType: function (component, event, helper){
        var action = component.get('c.checkCouponForHotelRecord');
        action.setParams({
            "id" : component.get("v.recordId")   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('Line--153-->'+result);
                if(result)
                {
                    /*console.log('Line--156-->'+result);
                    $A.util.removeClass(component.find("hotelModel"), 'slds-hide');
                    $A.util.addClass(component.find("hotelModel"), 'slds-show');
                    component.set('v.validation','failed');*/
                    
                    component.set('v.validation','success');
                    $A.get('e.force:refreshView').fire();
                }
                else
                {	
                    console.log('Line--163-->'+result);
                    console.log('Line--156-->'+result);
                    $A.util.removeClass(component.find("hotelModel"), 'slds-hide');
                    $A.util.addClass(component.find("hotelModel"), 'slds-show');
                    component.set('v.validation','failed');
                    
                    /*component.set('v.validation','success');
                    $A.get('e.force:refreshView').fire();*/
                }
            }
        });
        $A.enqueueAction(action);	
    },
    
    finalConversionStep : function(component, event, helper){
        var getInputkeyWord = component.find("coupSearch").get("v.value"); 
        var action = component.get('c.convertCouponToAUD');
        component.set("v.selectedCoupon", null);
        action.setParams({
            "couponCode" : getInputkeyWord   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('new coupon response ====>'+JSON.stringify(result));
                component.set("v.hideThisForConversion", true);
                component.set("v.showButton", true);
                
                this.showToast(component, "Success!", "success","dismissible","Coupon has been converted successfully. Please click on Apply Coupon to apply again.");
                
                
              //   $A.get('e.force:refreshView').fire();
                component.set("v.selectedCoupon", result);
                component.set("v.isModalOpen", false);
                component.set("v.showConversionMessage", false);
                component.set("v.test1", false);
                
                 console.log('ShowButton 244 ===> '+component.get("v.showButton"));
                console.log('reprinting 1 ===> '+component.get("v.selectedCoupon"));
                console.log("printing message value ===>"+component.get("v.showCouponInformation"));
                component.set("v.test2", true);
                $A.util.removeClass(component.find("inputPill"), 'slds-hide');
                $A.util.addClass(component.find("inputPill"), 'slds-show');
                $A.util.removeClass(component.find("inputField"), 'slds-show');
                $A.util.addClass(component.find("inputField"), 'slds-hide');
                $A.util.removeClass(component.find("couponInfo"), 'slds-hide');
                $A.util.addClass(component.find("couponInfo"), 'slds-show');
                $A.util.removeClass(component.find("couponDetails"), 'slds-hide');
                $A.util.addClass(component.find("couponDetails"), 'slds-show');
                
            }
        });
        $A.enqueueAction(action);
    }
    
})