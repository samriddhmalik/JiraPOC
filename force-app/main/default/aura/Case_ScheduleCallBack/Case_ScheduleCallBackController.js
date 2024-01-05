({
    doInit: function(component, event, helper) {
        helper.getInitDetails(component, event, helper);     
    },
   
	Submit : function(component, event, helper) {
		helper.Submit(component, event, helper);
	},
    
    onChange: function (cmp, evt, helper) {
           var selectedBrand = cmp.find('brandName').get('v.value');
            if(selectedBrand  == 'none'){
                alert('Please select the brand!'); 
                 //after alert, List should be set as blank component.set("v.lstRecords", []);
            }else{
                //server call to @aura method
                //get result and assign to lstRecords
                 component.set("v.lstRecords", result);
              }
       }
  
    
})