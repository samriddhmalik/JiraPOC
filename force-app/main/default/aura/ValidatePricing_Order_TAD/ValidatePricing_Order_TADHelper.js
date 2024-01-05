({
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, event, helper) {
        component.set("v.validating",false);
    },
    
    
    oliPricingModel: function (component, event, helper) {
        var recId =component.get("v.recordId");
        console.log('getAmounts');
        var action = component.get("c.updateOrder");
        action.setParams({  orderId : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse'+JSON.stringify(storeResponse));
                this.hideSpinner(component);
                if(storeResponse.validate=='fail'){
                    console.log('storeResponse: '+storeResponse);
                    console.log('class: '+component.find("oilModel")) ;
                    component.set('v.failFlag',true);
                    $A.util.removeClass(component.find("oilModel"), 'slds-hide');
                    $A.util.addClass(component.find("oilModel"), 'slds-show');
                }else if(storeResponse.validate=='failQuote'){ //sso-74 status=quote validation fails
                    console.log('storeResponse: '+storeResponse);
                    console.log('class: '+component.find("oilModel2")) ;
                    component.set('v.failFlag',true);
                    $A.util.removeClass(component.find("oilModel2"), 'slds-hide');
                    $A.util.addClass(component.find("oilModel2"), 'slds-show');
                }
                else{
                      
                    this.addOnPricingModel(component, event, helper);
                    component.set("v.iframeUrl",storeResponse.sourceUrl);
                    component.set("v.payLineiframeUrl",storeResponse.paylineURL);
                }
                
            }    
            
        });
        $A.enqueueAction(action);
    },
    
    
    addOnPricingModel: function (component, event, helper){
        var action = component.get('c.validateOrder');
        action.setParams({
            "id" : component.get("v.recordId")   
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                console.log(response);
                var result = response.getReturnValue();
                console.log('**json res55:'+JSON.stringify(result));
                if(result.status)
                {
                    $A.util.removeClass(component.find("addOnModel"), 'slds-hide');
                    $A.util.addClass(component.find("addOnModel"), 'slds-show');
                    component.set('v.failFlag',true);   
                }
                else
                {	
                 component.set('v.accountName', result.Name); 
                 component.set('v.accountEmail',result.email);
                 component.set('v.recordType',result.recordType);   
                 component.set('v.successFlag',true);
                 $A.get('e.force:refreshView').fire();
                }
                var recType = component.get('v.recordType',result.recordType);
                if(recType == 'Hotel'){
                    component.set('v.recordTypeHotel',false);
                }else{
                     component.set('v.recordTypeHotel',true);
                }
                console.log('recordType here '+recType);
                console.log('recordTypeHotel '+component.get('v.recordTypeHotel'));
            }
        });
        $A.enqueueAction(action);	
    },
    
    redirectToPayment : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var successFlag = component.get("v.successFlag");
        console.log('recordId here '+recordId);
        var recordDetail  = component.get("v.simpleRecord");
        console.log('here in recordDetail' +recordDetail);
        console.log('recordError '+component.get("v.recordError"));
        var paxId = recordDetail.ordexp_account__c;
        console.log("here in paxId "+paxId);
        var oname = recordDetail.Name;
        var amt = recordDetail.ordexp_amount_outstanding__c;
        var recordTypeName = recordDetail.RecordType.Name;
        console.log('recordTypeName '+recordTypeName);
        var accountEmail  = component.get("v.accountEmail");
        var accountName  = component.get("v.accountName");
        if(accountEmail == 'undefined' || accountEmail == null){
            accountEmail = '';
        }if(accountName == 'undefined' || accountName == null){
            accountName = '';
        }
        //var 
        var  linkToRedirect ;
        if(successFlag == true){
            if(recordTypeName == 'TNZ' || recordTypeName == 'WT'){
                linkToRedirect= '/apex/PayPXHostedPaymentPOE?referenceId='+recordId+'&amt='+amt;
            }else{
                linkToRedirect = '/apex/NewFlexiPaymentPOE?paxid='+paxId+'&oid='+recordId+'&oname='+oname+'&amt='+amt+'&sub='+recordTypeName+'&paxName='+accountName+'&paxEmail='+accountEmail;
            }
            
            console.log("linkToRedirect here "+linkToRedirect);
            if(!$A.util.isUndefinedOrNull(linkToRedirect)){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": linkToRedirect,   
                });
                urlEvent.fire();
                
                $A.get("e.force:closeQuickAction").fire();
            }
            
        }
        
        
    },
    
    getTheQantasUrl : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ABTest_AuraChildComp",
            componentAttributes: {
                iframeUrl : component.get("v.iframeUrl")
            }
        });
        evt.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    getThePaylineURL : function(component, event, helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ABTest_AuraChildComp",
            componentAttributes: {
                iframeUrl : component.get("v.payLineiframeUrl")
            }
        });
        evt.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
        getThePaytoURL: function (component, event, helper) {
        var recId =component.get("v.recordId");
        console.log('getAmounts');
        var action = component.get("c.payToOrder");
        action.setParams({  orderId : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('rsult 169:'+JSON.stringify(result));
                var recType = component.get('v.recordType');
                console.log('rsult 171:'+recType);
                if(result.returnStatus == true){
                    console.log('inside this 173');
                    component.set('v.paytoUrl',result.returnurl);
                    window.open(result.returnurl, '_blank');
                }else if(result.returnStatus == false && recType == 'Hotel'){
                    console.log('inside this 177 ');
                    component.set('v.paytoUrl',result.returnurl);
                    window.open(result.returnurl, '_blank');
                 }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'There is no payment outstanding.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();  
                }
                 
            }
        });
            $A.enqueueAction(action);	
     }
   
})