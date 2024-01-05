({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
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
        
               var linkToRedirect = '/apex/NewFlexiPayment?paxid='+paxId+'&oid='+recordId+'&oname='+oname+'&amt='+amt+'&sub='+recordTypeName;
        		console.log("linkToRedirect "+linkToRedirect);
        var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": linkToRedirect,   
        });
       urlEvent.fire();
       
            $A.get("e.force:closeQuickAction").fire();
         
        

        
    }
})