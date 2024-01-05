({
    doInit : function (c, e, h){
         var workspaceAPI = c.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            c.set("v.isConsoleApp", response);
            if(response == true){
            workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            c.set("v.tabId",focusedTabId);
        })
        .catch(function(error) {
            console.log(error);
        });
            }
        })
        var pageRef = c.get("v.pageReference");
        console.log(pageRef);
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        if(!$A.util.isUndefinedOrNull(base64Context)){
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
                var addressableContext = JSON.parse(window.atob(base64Context));
                console.log('addressableContext',addressableContext)
                if(addressableContext!=null){
                    var getDealId = addressableContext.attributes.recordId;
                    console.log('getDealId::'+getDealId);
                    if(!$A.util.isUndefinedOrNull(getDealId)){
                        c.set("v.getDeal", getDealId);
                        c.set("v.recId", getDealId);
                        c.set("v.fromDealPage", true);
                    } 
                }
            }
        }
    },
    handleLandActivitySave : function(c,e,h){
        let allValid = h.validateAesbFields(c, e, h);
        if (!allValid){
            h.showToast(c,'Error!','error','dismissible','Required fields are missing.')
        }else{
         h.saveLandActivity(c,e,h);       
        }
        
    },
    handleLandActivityNext : function(c,e,h){
        let allValid = h.validateAesbFields(c, e, h);
        if (!allValid){
            h.showToast(c,'Error!','error','dismissible','Required fields are missing.')
        }else{
            c.set("v.isNext",true);
            h.saveLandActivity(c,e,h);
        }
    },
    checkIsActive : function(c,e,h){
        c.set('v.getIsActive',!c.get('v.getIsActive'));
    },
    checkDataRefresh : function(c,e,h){
        c.set('v.getDataRefresh',!c.get('v.getDataRefresh'));
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
                objectApiName: 'land_activity__c',
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