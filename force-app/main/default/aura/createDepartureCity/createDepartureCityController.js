({
    doInit : function (component, event, helper){ 
        var depCityData = {'depName': '','dealId': '','orderFilter': '','feeApplication': '','site': '','city': '','surcharge': 0.00,'surchargeNZD': 0.00,'herokuId': '','currencyCode': '','dataRefresh':false,'isActive':true};
        component.set("v.depCityData", depCityData); 
         var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            component.set("v.isConsoleApp", response);
            if(response == true){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            component.set("v.tabId",focusedTabId);
        })
        .catch(function(error) {
            console.log(error);
        });
            }
        })
        
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var ssId = pageRef.state.ssId;
        if(!$A.util.isUndefinedOrNull(ssId)){
            component.set("v.isDepCity",false);
            component.set("v.isComponent",true); 
            component.set("v.stopover",ssId); 
        }
        var base64Context = state.inContextOfRef;
        console.log('base64Context',base64Context)
        if(!$A.util.isUndefinedOrNull(base64Context)){
              if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
                var addressableContext = JSON.parse(window.atob(base64Context));
                  console.log('addressableContext',addressableContext)
              if(addressableContext!=null){
                var getDealId = addressableContext.attributes.recordId;
                if(!$A.util.isUndefinedOrNull(getDealId)){
                    component.set("v.fromDealPage", true);
                    component.set("v.deal", getDealId);
                    component.set("v.recId", getDealId);
                } 
            }
            }
        } 
        
    },
	handleDepSave : function(component, event, helper){
        let allValid = helper.validateAesbFields(component, event, helper);
        if (!allValid){
             helper.showToast(component,'Error!','error','dismissible','Required fields are missing.')
        }else{
            helper.saveDepCity(component, event, helper);
        }
       
	},
   handleDepNext : function(component, event, helper) {
       let allValid = helper.validateAesbFields(component, event, helper);
          if (!allValid){
            helper.showToast(component,'Error!','error','dismissible','Required fields are missing.')
        }else{
         component.set("v.isNext",true);
         helper.saveDepCity(component, event, helper);   
        }
              
   },
    getActiveCheckedValue : function(c,e,h){
        c.set('v.isActive',!c.get('v.isActive'));
    },
    getDataCheckedValue : function(c,e,h){
        c.set('v.dataRefresh',!c.get('v.dataRefresh'));
    },
    handleCancel : function(c,e,h){
        var navService = c.find("navService");
        if(c.get('v.isConsoleApp') == true){
            var workspaceAPI = c.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
        }else if(c.get('v.fromDealPage') == true){
            var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Deal__c',
                recordId: c.get('v.recId'),
                actionName: 'view'
            }
        };
            navService.navigate(pageReference);
            $A.get('e.force:refreshView').fire();
        }else{
             var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'departure_cities__c',
                actionName: 'list'
            }
        };
            navService.navigate(pageReference);
            $A.get('e.force:refreshView').fire();
        }
    },
    closePreviousTab: function(c,e,h){
        $A.get('e.force:refreshView').fire();
        var focusedTabId = c.get('v.tabId');
        var workspaceAPI = c.find("workspace");
        workspaceAPI.closeTab({tabId: focusedTabId});
    }
})