({
	agentWorkloadChange : function(cmp,event) {
		console.log("Workload changed.");
        
         var action = cmp.get('c.getServiceStatus');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.spWrapper', response.getReturnValue());
                var spWrapperResult=cmp.get('v.spWrapper');
        var configuredCapacity = event.getParam('configuredCapacity');
        var previousWorkload = event.getParam('previousWorkload');
        var newWorkload = event.getParam('newWorkload');
        console.log('##SP:'+JSON.stringify(spWrapperResult));
        console.log(configuredCapacity);
        console.log(previousWorkload);
        console.log(newWorkload);
        if(configuredCapacity-newWorkload==0)
        {
            var omniAPI = cmp.find("omniToolkit");
        omniAPI.setServicePresenceStatus({statusId: spWrapperResult.busyStatusId}).then(function(result) {
            console.log('Current statusId is: ' + result.statusId);
            console.log('Channel list attached to this status is: ' + result.channels); 
        }).catch(function(error) {
            console.log(error);
        });
        }
        else if((configuredCapacity-previousWorkload==0) && (configuredCapacity-newWorkload!=0))
        {
             var omniAPI = cmp.find("omniToolkit");
        omniAPI.setServicePresenceStatus({statusId: spWrapperResult.availableStatusId}).then(function(result) {
            console.log('Current statusId is: ' + result.statusId);
            console.log('Channel list attached to this status is: ' + result.channels); 
        }).catch(function(error) {
            console.log(error);
        });
        }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
	},
    agentWorkAccepted : function(cmp,event) {
        var workItemId = event.getParam('workItemId');
        console.log('work Accepted Work Item Id'+workItemId);
      
        var action = cmp.get('c.changeCaseStatus');
        action.setParams({ workItemId :workItemId});

        action.setCallback(this, function(response) {
          
        });
        $A.enqueueAction(action);
    }
})