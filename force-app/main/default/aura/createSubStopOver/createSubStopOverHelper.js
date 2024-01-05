({
    saveStopOver : function(c,e,h) {
        var stopOverObj ={'Name':c.get('v.getName'),'order_filter__c':c.get('v.getOrderFilter'),'stopover__c':c.get('v.getStopOver'),'Blockout__c':c.get('v.getBlockOut'),
                          'Deal__c':c.get('v.getDeal'),'type__c':c.get('v.getType'),'site__c':c.get('v.getSite'),'Destination__c':c.get('v.getDestination'),
                          'Price__c':c.get('v.getPTwin'),'price_nz__c':c.get('v.getPTwinNZD'),'Includes__c':c.get('v.getIncludes'),'Price_Solo__c':c.get('v.getPriceSolo'),
                          'Price_Solo_nz__c':c.get('v.getPriceSoloNZD'),'fee_application__c':c.get('v.getFeeApp'),'Image__c':c.get('v.getImage'),'Active__c':c.get('v.getIsActive'),
                          'nights__c':c.get('v.getNights'),'CurrencyIsoCode':c.get('v.getCurrency')}
        var mySpinner = c.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
        var action = c.get("c.getSubStopOverData");
        action.setParams({
            'stopoverList': JSON.stringify(stopOverObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS'){
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                this.showToast(c,'Success!','success','dismissible','Sub stopover has been created successfully.')
                c.set("v.ssId",result);
                console.log('result',result)
                if(c.get("v.isNext")==true){
                    c.set("v.isStopover",false);
                     c.set("v.isSubNext",true);
                    /*console.log('Next button');
                    var navService = c.find("navService");
                    var pageRef = {
                       type: 'standard__component',
                       attributes: {
                           componentName: 'c__createDepartureCity',
                                   },
                        state: {
                              ssId : c.get("v.ssId")
                        },
                       };
                     navService.navigate(pageRef,true);*/
                }else{
                    c.find('ssfield').forEach(function(f) {
                    f.reset();
                        });
                }
            }else{
                 $A.util.removeClass(mySpinner, 'slds-show');
                 $A.util.addClass(mySpinner, 'slds-hide');
                 this.showToast(c,'Error!','error','dismissible','Required fields are missing.')
            }
        });
        $A.enqueueAction(action); 
    },
    showToast: function(c, title,toastType, mode, message) {
            console.log('show/toast called')
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