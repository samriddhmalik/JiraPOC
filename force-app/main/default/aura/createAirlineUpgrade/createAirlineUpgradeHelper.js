({
	saveAirUpgrade : function(c,e,h) {
        var airUpgradeObj = {'Name':c.get('v.getName'),'Deal__c':c.get('v.getDeal'),'site__c':c.get('v.getSite'),
                            'Active__c':c.get('v.getIsActive'),'CurrencyIsoCode':c.get('v.getCurrency'),'Airline__c':c.get('v.getAirline'),
                            'Cabin__c':c.get('v.getCabin'),'price__c':c.get('v.getPrice'),'price_nz__c':c.get('v.getPriceNZ'),
                            'Flight_Price_Type__c':c.get('v.getFlightPriceType')}
        var mySpinner = c.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
        var action = c.get("c.saveAirineUpgrade");
        action.setParams({
            'airUpgradeList': JSON.stringify(airUpgradeObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS'){
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                c.set("v.airlineId",result);
                this.showToast(c,'Success!','success','dismissible','Airline Upgrade has been created successfully.')
                if(c.get("v.isNext")==true){
                    c.set("v.isAirline",false);
                    c.set("v.isAirNext",true);
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
            console.log('inner bock')
            return validSoFar && field.reportValidity();
        }, true);
    }
})