({
    doInit : function(component, event, helper) {
        var inputNumber = component.get("v.numberOfTimesToIterate");
        console.log('inputNumber'+inputNumber);
        var OLIId = component.get("v.orderLineItemId");
        console.log('OLIId'+OLIId);
        var tadOrderId = component.get("v.tadOrderId"); 
        console.log('tadOrderId'+tadOrderId);
        var ifBoolean = component.get("v.ifHotelRecordTypeBoolean"); 
        console.log('ifHotelRecordTypeBoolean'+ifBoolean);
        
        var numbersToBeIterated =component.get("v.listOfNumbersForIteration");
        var i;
        for (i = 1; i<= inputNumber;i++){
            numbersToBeIterated.push({
                "value":""
            });
        }
        component.set("v.listOfNumbersForIteration",numbersToBeIterated);
        console.log('numbersToBeIterated'+numbersToBeIterated);
        helper.calltheInitFlow(component,event,helper);
    },
    
    createNewPAXInfoPass : function(component,event,helper){
        
        var inputValues = component.get("v.listOfNumbersForIteration");
        console.log('inputvalues for i'+ JSON.stringify(inputValues));
        var inputNumber = component.get("v.numberOfTimesToIterate");
        var i;
        var booleanToProceed = true;
        var namesToBeSent = [];
        var ifBoolean = component.get("v.ifHotelRecordTypeBoolean"); 
        console.log('ifHotelRecordTypeBoolean'+ifBoolean);
        for(i=0 ; i<inputNumber ; i++){
            console.log('i paxname'+JSON.stringify(inputValues[i].paxName));
            if(ifBoolean == true){
                if(inputValues[i].paxName == null || inputValues[i].paxName == "" || inputValues[i].dobMonth == null || inputValues[i].dobMonth == "" || inputValues[i].dobYear == null || inputValues[i].dobYear == ""){
                    console.log('Sorry,please enter all the values!');
                    helper.showToast(component, "Error!", "error","dismissible","You must enter all the all the fields in case you wish to proceed!");
                    booleanToProceed = false;
                    break;
                }
            }
            
            if(ifBoolean == false){
                if(inputValues[i].paxName == null || inputValues[i].paxName == ""){
                    helper.showToast(component, "Error!", "error","dismissible","You must enter all the all the fields in case you wish to proceed!");
                    booleanToProceed = false;
                }
            }
            
        }
        
        if(booleanToProceed == true){
            console.log('Entering boolean to proceed for true condition!');
            helper.createPaxRecords(component,event,helper);
            helper.onButtonPressed(component,event,helper);
        }else{
            console.log('You might not have entered all the PAX names!');
        }
        
        
        
    } 
})