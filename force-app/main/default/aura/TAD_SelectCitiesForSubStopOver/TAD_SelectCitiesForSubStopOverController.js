({
    init: function (cmp, event, helper) {
        console.log('component.get("v.sObjectName")   '+cmp.get("v.sObjectName"));
        helper.fetchActiveCity(cmp,event, helper);
    },

    handleChange: function (cmp, event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
		
        
    },
    
    createSubstopOverDeptCity :  function(cmp, event, helper){
        helper.createSubstopOverDeptCity(cmp, event, helper);
    },
    close :function(cmp, event, helper){
      helper.close(cmp, event, helper);
        
    }
});