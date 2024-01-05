({
    getInitDetails : function(component, event, helper) {
       var recordId = component.get("v.recordId"); 
           component.set("v.bccolumns",[{label: 'Subject', fieldName: 'Subject', type: 'text',sortable:true},
                                                 {label: 'SavedDeal Name', fieldName: 'savedDealName', type: 'text',sortable:true},
                                                 {label: 'Status', fieldName: 'status', type: 'text',sortable:true},
                                                 {label: 'Reminder Set', fieldName: 'reminderSet', type: 'text',sortable:true}]);
          console.log("recIdttt---------"+recordId);
        var action = component.get("c.getData");
        action.setParams({   
            recId : recordId   
        });
        action.setCallback(this, function(response) {
             console.log("state---------"+response.getState());
            var state = response.getState();
            var result = response.getReturnValue();
             console.log("state---------"+state);
            if(state === "SUCCESS"){ 
                
                console.log("Result-----init----"+JSON.stringify(result))
                console.log("Result--"+result.length)
                if(result.length>0){
                   component.set("v.isEmpty",true); 
                     component.set("v.mainWrapper",result); 
                }
                
               
  
            }
        });   
        $A.enqueueAction(action);
    },
   
    Submit : function(component, event, helper){
       
        var recordId = component.get("v.recordId");
        console.log('recordId ==> '+recordId);
        
        var selectedDay = component.get("v.days");
        var selectedTime = component.get("v.time");
        var selectedId = component.get("v.selectedId");
        console.log('days12 ==> '+selectedDay);
        console.log('time12 ==> '+selectedTime);             
       
        
  
        if(selectedDay == '-None-'){
             console.log('days12if ==> '+selectedDay);
            helper.showAcToast(component, helper,'Please select day.');
          
        }else{          
            if(selectedTime == '-None-'){
                console.log('iftime ==> '+selectedTime);
                helper.showAcToast(component, helper,'Please select time.');   
                
            }else{
                 if(selectedId == '' || selectedId == null || selectedId == undefined){ 
                     helper.showAcToast(component, helper,'Please select deal.');  
                }else{
                     component.set('v.showSpinner',true);
                     var action = component.get("c.createTask");
                   
                    action.setParams({
                        'recId': recordId,
                        'selectedDay': selectedDay,
                        'selectedTime': selectedTime,
                        'dealid': selectedId
                        
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        console.log('State for requested Details'+state);
                        var result = response.getReturnValue();
                        
                        if (state === "SUCCESS"){  
                            console.log('Its a success.');
                            console.log('response-----1243'+JSON.stringify(result) );
                            console.log('responsejson'+JSON.stringify(response));
                            if(result.length>0){
                            component.set("v.isEmpty",true); 
                            component.set("v.mainWrapper",result); 
                }
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "title": "Success!",
                                "message": "Your record has been created."
                            });
                            resultsToast.fire();
                           
                            component.set('v.showSpinner',false);
                            component.set('v.days','-None-');
                            component.set('v.time','-None-');
                            component.set('v.selectedId','');
                            // Close the action panel
                            // var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            // dismissActionPanel.fire();
                        }
                    });
                    $A.enqueueAction(action); 
                } 
            }
        }
        
        
        
    },
    
   showAcToast: function (component, helper,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
           "title": "Error!",
           "message": message
        });
        toastEvent.fire();
    },
})