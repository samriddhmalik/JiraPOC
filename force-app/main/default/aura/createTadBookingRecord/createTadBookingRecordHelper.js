({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
     fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getBookedComponentTypes");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
     settingColumnsForPAX : function (component, event, helper, allDataWrap){
        
         this.paxColumns(component,event,helper);
        component.set("v.paxData",allDataWrap.passengerDataWrapper);
      
    },
     paxColumns: function(component,event,helper){
        component.set("v.paxColumns",[{label: 'PAX', fieldName: 'paxName', type: 'text',sortable:true},
                                      {label: 'First Name', fieldName: 'paxFirstName', type: 'text',sortable:true},
                                      {label: 'Last Name', fieldName: 'paxLastName', type: 'text',sortable:true}])
        
        var tempPAX = component.get("v.paxColumns");
        console.log('tempPAX tempPAX '+JSON.stringify(tempPAX));
    },
     rowSelectionforPAX : function(component,event,helper){
        var selectedRows = event.getParam('selectedRows');
        console.log('selectedRows from PAX '+selectedRows);
        var selPAX_Ids = [];
        for (var i = 0; i < selectedRows.length; i++){
            
            var a = selectedRows[i].paxId;
            selPAX_Ids.push(a);   
        }
        
        
        component.set("v.selectedPAXIds",selPAX_Ids);
     //   component.set("v.saveRecordDataWrapper.paxIds",selPAX_Ids);
         
        console.log('selPAX_Ids'+component.get("v.selectedPAXIds"));  
    },
    saveTADBookingRecord : function(component,event,helper){
        component.set("v.loaded",false);
       var accId = component.get("v.selectedRecord.Id");
        var componenttype = component.get("v.compType");
        var referenceNum = component.get("v.refNumber");
        var cost = component.get("v.enteredCost");
        var allPax = component.get("v.selectedPAXIds");
        var orderId = component.get("v.recordId");
        var isGstIncluded = component.find("isGst").get("v.value");
        var gstAmt = component.get("v.enteredGstAmnt");
        console.log('accId--'+accId);
         console.log('componenttype--'+componenttype);
         console.log('referenceNum--'+referenceNum);
         console.log('cost--'+cost);
         console.log('allPax--'+allPax);
         console.log('orderId--'+orderId);
        
        var action = component.get("c.createTADBookingRecord");
        action.setParams({
            
            "accId" : accId,
            "orderId" : orderId,
            "paxIds" : allPax,
            "comType" : componenttype,
            "referenceNum" : referenceNum,
            "Cost" : cost,
            "gstAmount" : gstAmt,
            "isGst" : isGstIncluded
            
        });
		    action.setCallback(this, function(response) {
                 var state = response.getState();
                var result = response.getReturnValue();
                console.log("state---"+state);
                 console.log("result---"+result);
            if (response.getState() == "SUCCESS") {
              
                this.showToast(component, "Success!", "success", "TAD Booking Record has been created successfully! Please create Credit Card Payment record");
                component.set("v.loaded",true);
                var navEvt = $A.get("e.force:navigateToSObject");
    			navEvt.setParams({
      			"recordId": result,
 
    			});
    		navEvt.fire();
        }else if(state === "ERROR"){
            var errors = action.getError();
            var err = JSON.stringify(errors[0]);
            
            console.log('here in error '+JSON.stringify(errors));
            console.log(err);
        console.log(response.getError());
                alert(err);
            component.set("v.loaded",true);
            }
        });
        $A.enqueueAction(action);
    },
       showToast: function(component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": toastType,
            "message": message
        });
        toastEvent.fire();
    },
    
})