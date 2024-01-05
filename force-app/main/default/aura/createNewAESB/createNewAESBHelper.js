({
    saveAESB : function(c,e,h) {
        var aesbObj ={'Name':c.get('v.getName'),'linked_deal__c':c.get('v.getLinkedDeal'),'Type__c':c.get('v.getType'),'Option__c':c.get('v.getOption'),
                          'Deal__c':c.get('v.getDeal'),'City__c':c.get('v.getCity'),'Accom__c':c.get('v.getIsAccom'),'Night_Ticket__c':c.get('v.getNights'),
                          'Price__c':c.get('v.getPrice'),'price_nz__c':c.get('v.getPriceNZD'),'Includes__c':c.get('v.getIncludes'),'Target_Invoice_Price__c':c.get('v.getInvoice'),
                          'Target_Sell_Price__c':c.get('v.getSellPrice'),'image__c':c.get('v.getImage'),'Blockout__c':c.get('v.getBlockout'),'fee_application__c':c.get('v.getFeeApp'),
                          'name__c':c.get('v.getNamec'),'data_refresh__c':c.get('v.getDataRefresh'),'order_filter__c':c.get('v.getOrderFilter'),'Order__c':c.get('v.getOrder'),'Active__c':c.get('v.getIsActive'),'CurrencyIsoCode':c.get('v.getCurrency')}
        var mySpinner = c.find("mySpinner");
            $A.util.removeClass(mySpinner, 'slds-hide');
            $A.util.addClass(mySpinner, 'slds-show');
        var action = c.get("c.saveAesbData");
        action.setParams({
            'aebsList': JSON.stringify(aesbObj)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS'){
                $A.util.removeClass(mySpinner, 'slds-show');
                $A.util.addClass(mySpinner, 'slds-hide');
                this.showToast(c,'Success!','success','dismissible','AE/SB has been created successfully.')
                c.set("v.aesbId",result);
                console.log('result',result)
                if(c.get("v.isNext")==true){
                     c.set("v.isAesb",false);
                     c.set("v.isAesbNext",true);
                }else{
                    c.find('aesbfield').forEach(function(f) {
                    f.reset();
                        });
                }
            }else{
                var errorMsg = JSON.stringify(response.getError());
                if(errorMsg.includes('duplicate value found')){
                      $A.util.removeClass(mySpinner, 'slds-show');
                 $A.util.addClass(mySpinner, 'slds-hide');
                    this.showToast(c,'Error!','error','dismissible','Duplicate record found.')
                }
                else if(errorMsg.includes('Please nominate either &quot;Deal&quot;')){
                      $A.util.removeClass(mySpinner, 'slds-show');
                 $A.util.addClass(mySpinner, 'slds-hide');
                    this.showToast(c,'Error!','error','dismissible','Please nominate either "Deal" OR "Option" to save this record but not both.')
                }
                else{
                    $A.util.removeClass(mySpinner, 'slds-show');
                 $A.util.addClass(mySpinner, 'slds-hide');
                 this.showToast(c,'Error!','error','dismissible','Required fields are missing.')
                }
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
        console.log('validity called')
        return c.find('aesbfield').reduce(function (validSoFar, field){
            console.log('inner bock')
            return validSoFar && field.reportValidity();
        }, true);
    }
})