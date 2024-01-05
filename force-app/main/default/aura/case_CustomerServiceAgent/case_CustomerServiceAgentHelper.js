({
	 getInitDetails : function(component, event, helper) {
        var recId = component.get("v.recordId");  
         
          console.log("recIdttt---------"+recId);
        var action = component.get("c.fetchResult");
        action.setParams({   
            "recordId" : recId   
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue(); 
            if(state === "SUCCESS"){ 
                console.log("Result--"+result.length)
                 component.set("v.mainWrapper",result);
               
  console.log("Result---------"+JSON.stringify(result))
            }
        });
        $A.enqueueAction(action);
    },
    
    closeFocusedTabAndOpenNewTab : function(component, event, helper) {
        var afList = component.get('v.mainWrapper');
          console.log("EV-----"+event.srcElement.id);
    var affiliation = event.srcElement.id;
         var workspaceAPI = component.find("workspace");
          console.log("affiliation-----"+affiliation);
        
         var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '#/sObject/'+event.srcElement.id+'/view',
            focus: true
        });
        

    }
    
})