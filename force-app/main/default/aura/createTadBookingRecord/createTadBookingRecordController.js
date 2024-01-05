({
	doInit : function(component, event, helper) {
         helper.fetchPickListVal(component, 'Booked_Component_Type__c', 'compTyp');
         component.set("v.objectAPIName","account");
         component.set("v.IconName","standard:account");
         component.set("v.selectedRecord","{!v.selectedLookUpRecord}");
         component.set("v.label","Account Name");
		  var recordId = component.get("v.recordId");
        
        console.log('recordId in INIT from beginning'+recordId);
         var action = component.get("c.fetchTADOrderNameAndDD");
         action.setParams({
            
            "recId" : component.get("v.recordId")
            
        });
       action.setCallback(this, function(response) {
            
            var result = response.getReturnValue();
            var state = response.getState();
            
            console.log('STATEEE'+' '+state+' '+'RESULTTT for the new wrapper created'+' '+JSON.stringify(result));	
            if(state === 'SUCCESS'){
                component.set("v.finalDataWrapper",result);
           helper.settingColumnsForPAX(component, event, helper,result);
            }            
        });
        $A.enqueueAction(action);  
	},
    
    testMethod : function(component,event,helper){
        console.log('testr 123');
    },
    
    onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
      // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent'+JSON.stringify(selectedAccountGetFromEvent));
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
  onChange : function(component,event,handler){
      
    var GstIncluded = component.find("isGst").get("v.value");
    if(GstIncluded == 'Yes'){
        
         component.set("v.showGstAmount", 'true');
    }else{
        
         component.set("v.showGstAmount", 'false');
    }
 
},
     getSelectedPaxName : function(component,event,helper){
        helper.rowSelectionforPAX(component,event,helper);
    },
  
     saveTADBookingRecord : function(component, event, helper)
    {
      var isGstIncluded = component.find("isGst").get("v.value");
      var gstAmt = component.get("v.enteredGstAmnt");
       if(isGstIncluded == 'Yes' && gstAmt == null){
          console.log('inside error');
        helper.showToast(component, "Error!", "error", "Please enter GST Amount");
        component.set("v.loaded",true);
       }else{
           
             helper.saveTADBookingRecord(component,event,helper);
             console.log('##Start of saveTADBookingRecord');
       }
      },
      closeModal : function(component){
      var closeEvent = $A.get("e.force:closeQuickAction");
    	 closeEvent.fire();
          $A.get('e.force:refreshView').fire();
        },
})