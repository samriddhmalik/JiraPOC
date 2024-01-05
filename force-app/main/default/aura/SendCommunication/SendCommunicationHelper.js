({
    
    closeModal : function(){
        
        var closeEvent = $A.get("e.force:closeQuickAction");
        
        if(closeEvent){
            
            closeEvent.fire();
            
        } else{
            
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
            
        }
        
    },
    
    sendComm : function (component,event,helper)
    {
        var comType = component.find("sendCommPicklist").get("v.value");
        var passAffected = component.get("v.totalpassenger");
        //  var paxImpacted = component.get("v.paxImp");
        var missedPart = component.get("v.missedPart");
        var reason = component.get("v.reason");
        var Interrupted = false;
        var ordId = component.get("v.tadOrderId");
        var previewTadInterrupted =  component.get("v.onClickPreviewOrSend");
        var previewTI = false;
        var ValidDetails = false;
        var paxAffected;
        var totalPax = '';
        var passCount = component.get("v.totalpassenger");
        if(passCount == 1 && component.get("v.CancellationPassname1") != ''){
            totalPax = component.get("v.CancellationPassname1");
        }
        if(passCount == 2 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != ''){
            totalPax = component.get("v.CancellationPassname1") + ',' +component.get("v.CancellationPassname2");
        }
        if(passCount == 3 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3");
        }
        if(passCount == 4 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != '' && component.get("v.CancellationPassname4") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4");
        }
        if(passCount == 5  && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5");
        }
        if(passCount == 6 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6");
        }
        if(passCount == 7 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname27")+',' + component.get("v.CancellationPassname7");
        }
        if(passCount == 8 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8");
        }
        if(passCount == 9 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9");
        }
        if(passCount == 10 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10");
        }
        if(passCount == 11 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11");
        }
        if(passCount == 12 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12");
        }
        if(passCount == 13 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13");
        }
        if(passCount == 14 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14");
        }
        if(passCount == 15 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15");
        }
        if(passCount == 16 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' && component.get("v.CancellationPassname16") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15")+',' + component.get("v.CancellationPassname16");
        }
        
        console.log('line83 '+totalPax);  
        
        if(comType == 'Interrupted Tour'){
            Interrupted = true;
        }
        if(comType == "---None---"){
            
            this.showToast(component, "Error!", "error","Please select a communication type");
        }
        else{
            if(Interrupted== true){
                if(passAffected > 16){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please Fill Valid Passenger Affected.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else{
                    paxAffected = passAffected;
                    ValidDetails = true;
                }
                console.log('line110 '+totalPax);
                if(ValidDetails == true){
                    if(paxAffected != undefined && missedPart != undefined && reason != undefined){
                        var action = component.get('c.saveCommsFromOrderForInterruptedTour'); 
                        action.setParams({
                            "recId" : ordId,
                            "commType" : comType,
                            'paxAffected' : paxAffected,
                            'paxName':totalPax,
                            'missedPart' : missedPart,
                            'reason' : reason
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if(state === 'SUCCESS') {
                                
                                console.log('Success--')
                                this.closeModal();
                                this.showToast(component, "Success!", "success","Order Communication has been saved successfully");
                                
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message:'Please Fill All The Values Before Send.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            }
            else{
                var action = component.get('c.saveCommsFromOrder'); 
                action.setParams({
                    "recId" : ordId,
                    "commType" : comType
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === 'SUCCESS') {
                        
                        console.log('Success--')
                        this.closeModal();
                        this.showToast(component, "Success!", "success","Order Communication has been saved successfully");
                        
                    }
                });
                $A.enqueueAction(action);
            } 
        }
        
    },
    
    
    sendCommcancellation : function (component,event,helper)
    {
        var comType = component.find("sendCommPicklist").get("v.value");
        
        var cancelledPass = component.get("v.totalpassengerCancellation");
        
        var cancellationAmount = component.get("v.Cancellationamount");
        var claimableAmount = component.get("v.TotalClaimableAmount");
        var PartialCancellation = false;
        var ordId = component.get("v.tadOrderId");
        var ValidDetailsCancellation = false;
        var cancelledPassdata;
        var totalPax = '';
        var passCount = component.get("v.totalpassengerCancellation");
        if(passCount == 1 && component.get("v.CancellationPassname1") != ''){
            totalPax = component.get("v.CancellationPassname1");
        }
        if(passCount == 2 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != ''){
            totalPax = component.get("v.CancellationPassname1") + ',' +component.get("v.CancellationPassname2");
        }
        if(passCount == 3 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3");
        }
        if(passCount == 4 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != '' && component.get("v.CancellationPassname4") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4");
        }
        if(passCount == 5  && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5");
        }
        if(passCount == 6 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6");
        }
        if(passCount == 7 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname27")+',' + component.get("v.CancellationPassname7");
        }
        if(passCount == 8 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8");
        }
        if(passCount == 9 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9");
        }
        if(passCount == 10 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10");
        }
        if(passCount == 11 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11");
        }
        if(passCount == 12 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12");
        }
        if(passCount == 13 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13");
        }
        if(passCount == 14 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14");
        }
        if(passCount == 15 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15");
        }
        if(passCount == 16 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' && component.get("v.CancellationPassname16") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15")+',' + component.get("v.CancellationPassname16");
        }
        
        
        
        
        
        if(comType == 'Partial Cancellation'){
            PartialCancellation = true;
        }
        if(comType == "---None---"){
            
            this.showToast(component, "Error!", "error","Please select a communication type");
        }
        else{
            if(PartialCancellation== true){
                if(cancelledPass > 17){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please Fill Valid Passenger Affected.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else{
                    cancelledPassdata = cancelledPass;
                    ValidDetailsCancellation = true;
                }
                if(ValidDetailsCancellation == true){
                    console.log('Line158 '+cancelledPass);
                    console.log('Line159 '+cancellationAmount);
                    console.log('Line160 '+claimableAmount);
                    if(cancelledPass != undefined && cancellationAmount != undefined && claimableAmount != undefined){
                        var action = component.get('c.saveCommsFromOrderForPartialCancellation'); 
                        action.setParams({
                            "recId" : ordId,
                            "commType" : comType,
                            'cancelledPassdata' : cancelledPass,
                            'cancellationAmountdata' : cancellationAmount,
                            'claimableAmountdata' : claimableAmount,
                            'paxName':totalPax
                            
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if(state === 'SUCCESS') {
                                
                                console.log('Success--')
                                this.closeModal();
                                this.showToast(component, "Success!", "success","Order Communication has been saved successfully");
                                
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message:'Please Fill All The Values Before Send.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            }
            else{
                var action = component.get('c.saveCommsFromOrder'); 
                action.setParams({
                    "recId" : ordId,
                    "commType" : comType
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state === 'SUCCESS') {
                        
                        console.log('Success--')
                        this.closeModal();
                        this.showToast(component, "Success!", "success","Order Communication has been saved successfully");
                        
                    }
                });
                $A.enqueueAction(action);
            } 
        }
        
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
    
    fetchTADOrderDetails : function(component,event,helper,tadOderRecordId){
        
        var action = component.get("c.initForCreatingOrderComms");
        
        action.setParams({
            "recordId" : tadOderRecordId
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState(); 
            console.log('result result result'+JSON.stringify(result));
            if(state === "SUCCESS"){
                component.set("v.tadOrderInitCheck",result);
                if(result.sendOrderCommsEnableCheck == true && result.existingComms == true){
                    component.set("v.showTheCommsPicklist",true);
                    component.set("v.showNoOrderComms",false);
                    component.set("v.showOrderCommsBlocked",false);
                }else if(result.sendOrderCommsEnableCheck == false && result.existingComms == true){
                    component.set("v.showTheCommsPicklist",false);
                    component.set("v.showOrderCommsBlocked",true);
                }else if(result.sendOrderCommsEnableCheck == true && result.existingComms == false){
                    component.set("v.showTheCommsPicklist",false);
                    component.set("v.showNoOrderComms",true);
                }else{
                    console.log('This probably would never happen');
                }
                
                //PSAG 114 And 115 Start
                if(result.isSendQuoteToCustomer == true || result.QuoteDetailsForCustomer != null){
                    component.set("v.quoteDetailsForCustomer",result.QuoteDetailsForCustomer);
                }
                //PSAG 114 And 115 End
            }
        });
        $A.enqueueAction(action);  
    },
    
    previewCancellationComm : function (component,event,helper) {
        console.log('Line--98-->');
        var totalPax = '';
        var cancelledPass = component.get("v.totalpassengerCancellation");
        var passCount = component.get("v.totalpassengerCancellation");
        if(passCount == 1 && component.get("v.CancellationPassname1") != ''){
            totalPax = component.get("v.CancellationPassname1");
        }
        if(passCount == 2 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != ''){
            totalPax = component.get("v.CancellationPassname1") + ',' +component.get("v.CancellationPassname2");
        }
        if(passCount == 3 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3");
        }
        if(passCount == 4 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != '' && component.get("v.CancellationPassname4") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4");
        }
        if(passCount == 5  && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5");
        }
        if(passCount == 6 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6");
        }
        if(passCount == 7 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname27")+',' + component.get("v.CancellationPassname7");
        }
        if(passCount == 8 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8");
        }
        if(passCount == 9 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9");
        }
        if(passCount == 10 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10");
        }
        if(passCount == 11 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11");
        }
        if(passCount == 12 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12");
        }
        if(passCount == 13 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13");
        }
        if(passCount == 14 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14");
        }
        if(passCount == 15 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15");
        }
        if(passCount == 16 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' && component.get("v.CancellationPassname16") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15")+',' + component.get("v.CancellationPassname16");
        }
        
        var cancellationAmount = component.get("v.Cancellationamount");
        var claimableAmount = component.get("v.TotalClaimableAmount");
        var previewTadPartialCancellation =  component.get("v.onClickPreviewOrSendcancellation");
        var previewTI =  false;
        console.log('Line--98-->'+totalPax);
        console.log('Line--104-->'+cancellationAmount);
        console.log('Line--105-->'+claimableAmount);
        
        console.log('Line--107-->'+component.get("v.recordId"));
        
        if(previewTadPartialCancellation == true){
            previewTI = true;
        }else{
            previewTI = false;
        }
        console.log('Line--118-->'+cancelledPass);
        if(cancellationAmount != undefined && claimableAmount != undefined && cancelledPass !=undefined && totalPax !='' && cancellationAmount != '' && claimableAmount != '' && cancelledPass != ''){
            var action = component.get("c.PartialCancellationPreview");
            action.setParams({
                'recId' : component.get("v.recordId"),
                'previewQuote' : previewTI,
                'cancelledPassdata' : cancelledPass,
                'cancellationAmountdata' : cancellationAmount,
                'claimableAmountdata' : claimableAmount,
                'paxName': totalPax
                
            });
            action.setCallback(this, function(response) {
                
                var result = response.getReturnValue();
                var state = response.getState();
                console.log('state-->'+state);
                if(state === "SUCCESS"){
                    console.log('Line--136-->'+result)
                    component.set("v.CancellationTadString",result);
                    component.set("v.CancellationTad",true);
                    component.set("v.isModalOpencancellation", true);
                    //component.set("v.disableSendQuoteWithoutFlights",false);
                    //component.set("v.disableBackButtonWithoutFlights",false);
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please Fill All The Values Before Preview.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                } 
            });
            
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please Fill All The Values Before Preview.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        } 
        
    },
    
    previewComm : function (component,event,helper) {
        
        var totalPax = '';
        var cancelledPass = component.get("v.totalpassenger");
        var passCount = component.get("v.totalpassenger");
        console.log('Line--395-->'+passCount);
        if(passCount == 1 && component.get("v.CancellationPassname1") != ''){
            totalPax = component.get("v.CancellationPassname1");
        }
        if(passCount == 2 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != ''){
            totalPax = component.get("v.CancellationPassname1") + ',' +component.get("v.CancellationPassname2");
        }
        if(passCount == 3 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3");
        }
        if(passCount == 4 && component.get("v.CancellationPassname1") != '' && component.get("v.CancellationPassname2") != '' && component.get("v.CancellationPassname3") != '' && component.get("v.CancellationPassname4") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4");
        }
        if(passCount == 5  && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5");
        }
        if(passCount == 6 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6");
        }
        if(passCount == 7 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname27")+',' + component.get("v.CancellationPassname7");
        }
        if(passCount == 8 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != ''){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8");
        }
        if(passCount == 9 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9");
        }
        if(passCount == 10 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10");
        }
        if(passCount == 11 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11");
        }
        if(passCount == 12 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12");
        }
        if(passCount == 13 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13");
        }
        if(passCount == 14 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14");
        }
        if(passCount == 15 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15");
        }
        if(passCount == 16 && component.get("v.CancellationPassname1") != ''  && component.get("v.CancellationPassname2") != ''  && component.get("v.CancellationPassname3") != ''  && component.get("v.CancellationPassname4") != ''  && component.get("v.CancellationPassname5") != '' && component.get("v.CancellationPassname6") != '' && component.get("v.CancellationPassname7") != '' && component.get("v.CancellationPassname8") != '' && component.get("v.CancellationPassname9") != '' && component.get("v.CancellationPassname10") != '' && component.get("v.CancellationPassname11") != '' && component.get("v.CancellationPassname12") != ' '&& component.get("v.CancellationPassname13") != '' && component.get("v.CancellationPassname14") != ''  && component.get("v.CancellationPassname15") != '' && component.get("v.CancellationPassname16") != '' ){
            totalPax = component.get("v.CancellationPassname1") +','+ component.get("v.CancellationPassname2") + ',' + component.get("v.CancellationPassname3") + ',' + component.get("v.CancellationPassname4")+',' + component.get("v.CancellationPassname5")+',' + component.get("v.CancellationPassname6")+',' + component.get("v.CancellationPassname7")+',' + component.get("v.CancellationPassname8")+',' + component.get("v.CancellationPassname9")+',' + component.get("v.CancellationPassname10")+',' + component.get("v.CancellationPassname11")+',' + component.get("v.CancellationPassname12")+',' + component.get("v.CancellationPassname13")+',' + component.get("v.CancellationPassname14")+',' + component.get("v.CancellationPassname15")+',' + component.get("v.CancellationPassname16");
        }
        
        
        var passAffected = component.get("v.pass");
        var paxImpacted = component.get("v.paxImp");
        var missedPart = component.get("v.missedPart");
        var reason = component.get("v.reason");
        var previewTadInterrupted =  component.get("v.onClickPreviewOrSend");
        var previewTI = false;
        var ValidDetails = false;
        var paxAffected;
        
        console.log('Line--109-->'+missedPart);
        
        console.log('Line--111-->'+reason);
        
        if(passAffected > 16){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please Fill Valid Passenger Affected.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else{
            paxAffected = passAffected;
            ValidDetails = true;
        }
        if(previewTadInterrupted == true){
            console.log('line--437-->');
            previewTI = true;
        }
        else{
            previewTI = false;  
        }
        console.log('Line496 '+totalPax);
        if(ValidDetails == true){
            if(passCount != undefined && missedPart != undefined && reason != undefined && missedPart != '' && reason != '' && totalPax != ''){
                var action = component.get("c.sendInterruptedTourPreview");
                action.setParams({
                    'recId' : component.get("v.recordId"),
                    'previewQuote' : previewTI,
                    'paxAffected' : passCount,
                    'paxImpacted' : paxImpacted,
                    'missedPart' : missedPart,
                    'reason' : reason,
                    'paxname' : totalPax
                });
                action.setCallback(this, function(response) {
                    
                    var result = response.getReturnValue();
                    var state = response.getState();
                    console.log('state-->'+state);
                    if(state === "SUCCESS"){
                        console.log('Line--136-->'+result)
                        component.set("v.PreviewTadString",result);
                        component.set("v.previewTad",true);
                        component.set("v.isModalOpen", true);
                        
                        
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message:'Please Check Issue.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                });
                
                $A.enqueueAction(action);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Please Fill All The Values Before Preview.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }
        
    },
    
    //PSAG 114 And 115 Start
    sendCustomerQuoteDetails : function (component,event,helper){
        var ordId = component.get("v.tadOrderId");
        var comType = component.find("sendCommPicklist").get("v.value");
        var varCustomerQuoteDetails =  component.find("CustomerQuoteDetails").get("v.value");
        
        console.log('Button Clicked');
        var action = component.get('c.saveCommsFromSendQuoteToCustomer'); 
        action.setParams({
            "recId" : ordId,	
            "commType" : comType,
            "QuoteDetailsForCustomer" : varCustomerQuoteDetails
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            console.log('Result '+result);
            if(state === 'SUCCESS') {
                if(result == true){
                    component.set("v.spinner",false);
                    console.log('Success--')
                    this.closeModal();
                    this.showToast(component, "Success!", "success","Order Communication has been saved successfully");
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Unsuccessful!. Please ensure you have completed all required field to send this quote',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.spinner",false);
                }
            }
        });
        $A.enqueueAction(action);
    }//PSAG 114 And 115 Stop    
    
    
    
})