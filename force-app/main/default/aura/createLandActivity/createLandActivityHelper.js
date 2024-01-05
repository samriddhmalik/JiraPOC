({
    saveLandActivity : function(c,e,h) {
        var landActivityObj = {'Name':c.get('v.getName'),'order_filter__c':c.get('v.getOrderFilter'),'Deal__c':c.get('v.getDeal'),
                               'Activity_time_of_day__c':c.get('v.getActivity'),'title__c':c.get('v.getTitle'),'site__c':c.get('v.getSite'),
                               'price__c':c.get('v.getTwinPrice'),'price_nz__c':c.get('v.getTwinPriceNZD'),'solo_price__c':c.get('v.getSoloPrice'),
                               'solo_price_nz__c':c.get('v.getSoloPriceNZD'),'fee_application__c':c.get('v.getFeeApp'),'itinerary__c':c.get('v.getItry'),
                               'type__c':c.get('v.getType'),'Active__c':c.get('v.getActive'),'itinerary_activity__c':c.get('v.getItryActivity'),
                               'Sold__c':c.get('v.getSold'),'Sold_A__c':c.get('v.getSoldA'),'Sold_B__c':c.get('v.getSoldB'),
                               'Sold_C__c':c.get('v.getSoldC'),'data_refresh__c':c.get('v.getDataRefresh'),'Site_Order__c':c.get('v.getSiteOrder'),
                               'CurrencyIsoCode':c.get('v.getCurrency')}
        var mySpinner = c.find("mySpinner");
        $A.util.removeClass(mySpinner, 'slds-hide');
        $A.util.addClass(mySpinner, 'slds-show');
        var action = c.get("c.saveLandActivity");
        action.setParams({
            'landActivityList': JSON.stringify(landActivityObj)
        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS'){
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                c.set("v.landActivityId",result);
                this.showToast(c,'Success!','success','dismissible','Airline Upgrade has been created successfully.');
                if(c.get("v.isNext")==true){
                    c.set("v.isLandActivity",false);
                    c.set("v.isLandNext",true);
                }else{
                    c.find('ssfield').forEach(function(f) {
                    f.reset();
                        });
                } 
            }
            else{
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                this.showToast(c,'Error!','error','dismissible','Required fields are missing.')
            }
        });
        $A.enqueueAction(action); 
    },
    showToast: function(c, title,toastType, mode, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "mode":mode,
            "type":toastType
        });
        toastEvent.fire();
    },
    validateAesbFields: function(c,e,h) {
        return c.find('ssfield').reduce(function (validSoFar, field){
            return validSoFar && field.reportValidity();
        }, true);
    }
})