({
    doInit : function(component, event, helper) {
        component.set("v.redirectrender1",true);
            var recordId=component.get("v.recordId");
            var flow = component.find("flowId2");
            console.log('recordId==='+recordId);
        
        
        // For create tad order from Saved Deal by Munesh
         var getSourceObject = component.get("v.sObjectName");
        
        if(getSourceObject == "Saved_Deals__c"){
             var action = component.get("c.TadOrdercreation");
        action.setParams({
            'saveddealId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('result303'+JSON.stringify(result));
                
              console.log('tadorder--->'+result.tadOrderId)
                component.set('v.AccountId',result.accountId);
                 component.set('v.accountName',result.accountName);
                 component.set('v.DealName',result.dealName);
                 component.set('v.tadOrderId',result.tadOrderId);
                 component.set('v.DealId',result.dealId);
                 component.set('v.caseID',result.caseId);
                 component.set('v.SavedDealID',result.savedDealId);
              if(result.savedDealStatus == "Closed Converted" || result.savedDealStatus == "Closed Not Converted"){
                 helper.showToast(component, "Error!", "error","","Order cannot be created as the Saved deal is already closed");   
                console.log('tadorder--->'+result.savedDealStatus)
              }else if($A.util.isUndefinedOrNull(result.caseId)){
                helper.showToast(component, "Error!", "error","","There is no cases attached on the same saved deal, So can't create tad order"); 
              }else if(!$A.util.isUndefinedOrNull(result.tadOrderId)){
                  console.log('tadorder--- from not undefined>')
                helper.showToast(component, "Error!", "error","","TAD Order already linked with this Saved Deal");      
              } else{
                  component.set("v.sourceObject",'Case');
             component.set("v.redirectrender1",false);
            component.set("v.showOrderComp", true);
              }
                                     
            } 
             }
                          );
        $A.enqueueAction(action);  
            /////   Create TadOrder from saved deal  end
            
        }else{
      var inputVariables = [
                {
                    name : "VarToStoreCaseIdToBePassed",
                    type : "String",
                    value : recordId
                }
                ];
               flow.startFlow("Case_Flow_For_Agent",inputVariables);
           }
            
           
    },
    
    handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("message");
        var TadOrderId = event.getParam("TadOrderId");
        component.set("v.storeTheTADOrderRecordId", TadOrderId);
        var dealId = component.get("v.DealId");
        var dealName = component.get("v.DealName");
        var SavedDealID = component.get("v.SavedDealID");
        
        var accId = component.get("v.AccountId")
        var accName = component.get("v.accountName")
        var caseId = component.get("v.caseID");
        
        if(valueFromChild =='From TadOrder Cancel')
        { 
            component.set("v.redirectrender1",true);
            
            component.set("v.showOrderComp", false);
            var flow = component.find("flowId2");
            console.log('caseId==='+caseId);
            
            var inputVariables = [
                {
                    name : "VarToStoreDealIdToBePassed",
                    type : "String",
                    value : dealId
                },
                {
                    name : "VarToStoreDealNameToBePassed",
                    type : "String",
                    value : dealName
                },
                {
                    name : "VarToStoreAccountIdToBePassed",
                    type : "String",
                    value : accId
                },
                {
                    name : "VarToStoreAccountNameToBePassed",
                    type : "String",
                    value : accName
                },
                {
                    name : "VarToStoreCaseIdToBePassed",
                    type : "String",
                    value : caseId
                },
                {
                    name : "VarToStoreSavedDealIdToBePassed",
                    type : "String",
                    value : SavedDealID
                }
            ];
            
            
            // In that component, start your flow. Reference the flow's Unique Name. 
              var getSourceObject = component.get("v.sObjectName");  
            console.log('line no====>110');   
            if(getSourceObject == "Saved_Deals__c"){
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
            }else{
                 flow.startFlow("Case_Flow_For_Agent",inputVariables);
            }
           
            
            
        }
        
        if(valueFromChild =='From TadOrder')
        {
            component.set("v.showOrderComp", false);
            
            component.set("v.isModalOpenOLI", true);
        }
        if(valueFromChild =='From OLI')
        {
            component.set("v.redirectrender", false);
            component.set("v.isCaseOLIAddon",true); 
        }
        if(valueFromChild =='From AddOn')
        {
            component.set("v.redirectrender", false);
            component.set("v.isCaseOLIAddon",true);    
        }
        if(valueFromChild =='From Paymethod Cancel')
        {
            component.set("v.isPaymentmethod",true);
            component.set("v.couponComponent",false); 
            component.set("v.bpointComponent",false);    
            component.set("v.sendCommsComponent",false);    
            
        }
        if(valueFromChild =='From Coupon Applied')
        {
           helper.afterPayment(component, event, helper);
        }
        
    },
    handleNo : function(component,event,helper){
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        component.set("v.isCaseOLIAddon",false); 
        
        component.set("v.isModalOpenOLI", false);
        component.set("v.ispayment",false); 
        component.set("v.redirectrender1",true);
        var flow = component.find("flowId2");
        var dealId = component.get("v.DealId");
        var dealName = component.get("v.DealName");
        var SavedDealID = component.get("v.SavedDealID");
        
        
        var accId = component.get("v.AccountId")
        var accName = component.get("v.accountName")
        var caseId = component.get("v.caseID");
        
        console.log('parentRecordId'+parentRecordId);
        var inputVariables = [
            {
                name : "OrderId",
                type : "String",
                value : parentRecordId
            },
            {
                name : "VarToStoreDealIdToBePassed",
                type : "String",
                value : dealId
            },
            {
                name : "VarToStoreDealNameToBePassed",
                type : "String",
                value : dealName
            },
            {
                name : "VarToStoreAccountIdToBePassed",
                type : "String",
                value : accId
            },
            {
                name : "VarToStoreAccountNameToBePassed",
                type : "String",
                value : accName
            },
            {
                name : "VarToStoreCaseIdToBePassed",
                type : "String",
                value : caseId
            },
            {
                name : "VarToStoreSavedDealIdToBePassed",
                type : "String",
                value : SavedDealID
            }
        ];
        
        // In that component, start your flow. Reference the flow's Unique Name.  
         if(parentRecordId != null){
           component.set("v.successTadOrder",true); 
           component.set("v.tadOrder",parentRecordId); 
        }else{
            flow.startFlow("Case_Flow_For_Agent",inputVariables); 
        }
        
    },
    
     navigateToRecord : function(component, event, helper) {
        helper.navigateToRecord(component, event, helper);
    },
    callFlowNow : function(component,event,helper){
        component.set("v.redirectrender",true);
        component.set("v.isCaseOLIAddon",false); 
        component.set("v.isModalOpenOLI",false); 
        
        component.set("v.isModalOpenOLI", false);
        console.log('Entering callFlowNow');
        var flow = component.find("flowId");
        console.log("flow "+flow);
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        console.log('parentRecordId'+parentRecordId);
        var inputVariables = [
            {
                name : "recordId",
                type : "String",
                value : parentRecordId
            },
            {
                name : "SourceObject",
                type : "String",
                value : 'Case'
            }
        ];
        
        // In that component, start your flow. Reference the flow's Unique Name.        
        flow.startFlow("Create_OrderLineItem",inputVariables);
    },
    
    handleStatusChange : function (component, event,helper) {
        if(event.getParam("status") === "FINISHED") {
            component.set("v.isCaseOLIAddon",true); 
            
            component.set("v.redirectrender",false);
            
        }
    },
    callFlowNow1 : function(component,event,helper){
        component.set("v.isCaseOLIAddon",false); 
        component.set( "v.redirectrender",true);
        
        var parentRecordId = component.get("v.storeTheTADOrderRecordId"); 
        var flow = component.find("flowId");
        console.log("flow "+flow);
        
        var inputVariables = [
            {
                name : "recordId",
                type : "String",
                value : parentRecordId
            },
            {
                name : "SourceObject",
                type : "String",
                value : 'Case'
            }
            
        ];
        
        // In that component, start your flow. Reference the flow's Unique Name.        
        flow.startFlow("Create_New_AddOn_Updated",inputVariables);
    },
    
    callpayment:function(component,event,helper){ 
        component.set("v.ispayment",true); 
        component.set("v.isCaseOLIAddon",false);
        
    },
    
    payYes:function(component,event,helper){ 
        component.set("v.ispayment",false); 
        component.set("v.isPaymentmethod",true); 
        var opts=[
            {'label': 'Credit Card', 'value': 'Credit Card'},
            {'label': 'Poli/B-Pay', 'value': 'Poly/B-Pay'},
            {'label': 'Coupon', 'value': 'Coupon'},
            {'label': 'QFF Redeem', 'value': 'QFF Redeem'},
            {'label': 'Pay with Payline', 'value': 'Pay with Payline'}
            
        ];
        component.set("v.options",opts); 
        var parentRecordId = component.get("v.storeTheTADOrderRecordId"); 
        
        var action = component.get("c.fetchAmmount");
        action.setParams({
            'ordId': parentRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.ammount",result.OutstandingAmount);
            } 
            console.log("v.ammount===>"+component.get("v.ammount"));
        });
        $A.enqueueAction(action);  
        
    },
    handleChange: function (component, event) {
        var changeValue = event.getParam("value");
        component.set("v.methodvalue",changeValue);
        // alert(changeValue);
    },
    nextPayment: function (component, event,helper) {
        var changeValue =  component.get("v.methodvalue"); 
        
        var recid=  component.get("v.storeTheTADOrderRecordId");
        if(changeValue=='Coupon'){
            console.log('recid507',recid);
            component.set("v.isPaymentmethod",false);
            component.set("v.couponComponent",true);
        }
        if(changeValue=='Credit Card'){
            console.log('recid507',recid);
            component.set("v.isPaymentmethod",false);
            component.set("v.bpointComponent",true);
        }
        
        if(changeValue=='Poly/B-Pay'){
            console.log('recid507',recid);
            component.set("v.isPaymentmethod",false);
            component.set("v.sendCommsComponent",true);
        }
        if(changeValue=='QFF Redeem'){
            console.log('recid507',recid);
            component.set("v.isPaymentmethod",false);
            component.set("v.OpenIframe",true);

            helper.getPaymentDetails(component,event,helper);
        }
        if(changeValue=='Pay with Payline'){
            helper.callThePaylineMethod(component, event, helper);
        }
    },
    handleBack : function(component,event,helper){
        var parentRecordId = component.get("v.storeTheTADOrderRecordId");
        component.set("v.isPaymentmethod",false); 
        
        component.set("v.ispayment",true); 
    },
    
    
    
    
    afterPayment : function(component, event, helper){
         helper.afterPayment(component, event, helper);
        
        },
    
    
       handleStatusChangeAgent : function (component, event,helper) {
           console.log('in status change');
        if(event.getParam("status") === "FINISHED") {
            
            var outputVar;
            var outputVariables = event.getParam("outputVariables");
          //  console.log('VarToStoreDealNameToBePassed====='+outputVariables[VarToStoreDealNameToBePassed]);
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                console.log('outputVar '+JSON.stringify(outputVar));
                  if(outputVar.name=='VarToStoreAccountIdToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.AccountId",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                  if(outputVar.name=='VarToStoreAccountNameToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.accountName",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                
                  if(outputVar.name=='VarToStoreCaseIdToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.caseID",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                
                  if(outputVar.name=='VarToStoreDealIdToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.DealId",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                
                  if(outputVar.name=='VarToStoreDealNameToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.DealName",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                
                  if(outputVar.name=='VarToStoreSavedDealIdToBePassed')  
                  {
                         var valueToBePassed = outputVar.value;
                 		component.set("v.SavedDealID",valueToBePassed);  
                       console.log('valueToBePassed======'+valueToBePassed);
                  }
                
                 
                    
            }
            
             component.set("v.sourceObject",'Case');
          
             component.set("v.redirectrender1",false);
            component.set("v.showOrderComp", true);
        
            
        }
    }
 
    
    
})