({
    doInit : function (component, event, helper){ 
        var recordId=component.get("v.recordId");
        helper.fetchOliAddonDataHelper(component, event, helper,recordId);  
    },
    
    updateDepartureCity: function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        helper.updateDepartureCityHelper(component, event, helper,mySpinner); 
    },
    
    closePopup: function(component, event, helper) {
         //comented for PBP-236 & PBP-237
        //var recordId=component.get("v.recordId");
        //helper.resetOrderStatus(component, event, helper,recordId); 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    validateStopoverInfo : function (component, event, helper){
        var idForRow = event.getSource().get('v.name');
        var depCityStopoverMap=component.get("v.depCityStopoverMap");
        //console.log('depCityStopoverMap'+JSON.stringify(depCityStopoverMap));
        var oliAddonData=component.get("v.oliAddonData");
        // console.log('oliAddonData'+JSON.stringify(oliAddonData));
        var recData = oliAddonData[idForRow];
        var oliId;
        var cityId;
        var disableConfirm = 'false';
        
        for(var i = 0; i < oliAddonData.length; i++){
            
            if(oliAddonData[i].type=='OLI'){
                oliId=oliAddonData[i].recordId; 
                cityId=oliAddonData[i].departureCity;   
            }
            else if(oliAddonData[i].type=='AddOn' && (oliAddonData[i].addOnOliId==oliId)){
                var availability='false' ;
                var stopover = depCityStopoverMap[cityId];    
                if(!$A.util.isUndefined(stopover)){
                    for(var j = 0; j < stopover.length; j++){
                        if(oliAddonData[i].stopoverId == stopover[j]){
                            availability='true';
                            break;
                        }  
                    }
                    
                    if(availability=='true'){
                        oliAddonData[i].addonMessage='Available';
                    }else{
                        oliAddonData[i].addonMessage='Not Available, Please Cancel.';
                        disableConfirm = 'true';
                    }    
                }else{
                    oliAddonData[i].addonMessage='Not Available, Please Cancel.';
                    disableConfirm = 'true';
                }
            }
        }
        
        if(disableConfirm=='true'){
            component.set("v.disableConfirm",true);  
        }else{
            component.set("v.disableConfirm",false);
            component.set("v.disableResendPCButton",false);
        }
        
        helper.calculateRefundHelper(component, event, helper,oliAddonData);
        component.set("v.oliAddonData",oliAddonData);        
    },
})