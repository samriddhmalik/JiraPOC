({
	saveDepCity : function(component, event, helper) {
        var mySpinner = component.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
        var name = component.get("v.depName");
        var deal = component.get("v.deal");
        var orderFilter = component.get("v.orderFilter");
        var feeApplication = component.get("v.feeApplication");
        var site = component.get("v.site");
        var city = component.get("v.city");
        var surcharge = component.get("v.surcharge");
        var surchargeNZD = component.get("v.surchargeNZD");
        var herokuId = component.get("v.herokuId");
        var currencyCode = component.get("v.currency");
        var dataRefresh = component.get("v.dataRefresh");
        var isActive = component.get("v.isActive");
        var depCityData = component.get("v.depCityData");
        depCityData.depName = name;
        depCityData.dealId = deal;
        depCityData.orderFilter = orderFilter;
        depCityData.feeApplication = feeApplication;
        depCityData.site = site;
        depCityData.city = city;
        depCityData.surcharge = surcharge;
        depCityData.surchargeNZD = surchargeNZD;
        depCityData.herokuId = herokuId;
        depCityData.currencyCode = currencyCode;
        depCityData.dataRefresh = dataRefresh;
        depCityData.isActive = isActive;
       
        var action = component.get("c.saveDepCity");
        action.setParams({
            'depCityData': depCityData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state == 'SUCCESS'){
            $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
            console.log('result',result)
            component.set("v.depCityId",result);
            this.showToast(component,'Success!','success','dismissible','Departure City has been created successfully.')
            if(component.get("v.isNext")==true){
                    component.set("v.isDepCity",false);
                     component.set("v.isDepNext",true);
                }else{
                    component.find('depfield').forEach(function(f) {
                    f.reset();
                        });
                    console.log(component.get("v.deal"))
                }
            }else{
                $A.util.removeClass(mySpinner, 'slds-show');
            $A.util.addClass(mySpinner, 'slds-hide');
                 this.showToast(component,'Error!','error','dismissible','Required fields are missing.')
            }
        });
        $A.enqueueAction(action); 
	},

        showToast: function(component, title,toastType, mode, message) {
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
        return c.find('depfield').reduce(function (validSoFar, field){
            return validSoFar && field.reportValidity();
        }, true);
    }
})