({
    
    doInit: function(component, event, helper){
        var getSourceObject = component.get("v.sourceObject");
        if(getSourceObject == "Case")
        {
            component.set("v.btnlabel",'Back');
            
        }  
        var tadOderRecordId = component.get("v.recordId");
        console.log('tadOderRecordId',tadOderRecordId);
        component.set("v.tadOrderId",tadOderRecordId);
        helper.fetchTADOrderDetails(component,event,helper,tadOderRecordId);
        
    },
    
    
    ontotalPassengerChange: function (component, event, helper) {
        
        var passlist =  component.find("select2-id").get("v.value");
        component.set("v.totalpassenger",passlist);
        component.set("v.CancellationPassname1",'');
        component.set("v.CancellationPassname2",'');
        component.set("v.CancellationPassname3",'');
        component.set("v.CancellationPassname4",'');
        component.set("v.CancellationPassname5",'');
        component.set("v.CancellationPassname6",'');
        component.set("v.CancellationPassname7",'');
        component.set("v.CancellationPassname8",'');
        component.set("v.CancellationPassname9",'');
        component.set("v.CancellationPassname10",'');
        component.set("v.CancellationPassname11",'');
        component.set("v.CancellationPassname12",'');
        component.set("v.CancellationPassname13",'');
        component.set("v.CancellationPassname14",'');
        component.set("v.CancellationPassname15",'');
        component.set("v.CancellationPassname16",'');
        component.set("v.missedPart",'');
        component.set("v.reason",'');
        
        
        if(passlist ==1 ){
            component.set("v.One",true); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
            
        }
        if(passlist == 2 ){
            component.set("v.One",false); 
            component.set("v.Two",true); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false); 
        }
        if(passlist == 3 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",true); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 4 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",true); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 5 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",true); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 6){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",true); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        
        if(passlist == 7 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",true); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 8  ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",true); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);   
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 9 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",true); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist ==10 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",true);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist ==11 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",true); 
            
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        
        if(passlist ==12 ){
            
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",true); 
            
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
            
        }
        if(passlist ==13 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",true); 
            
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==14 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",true); 
            component.set("v.eleven",false); 
            
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==15 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",true); 
            
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==16 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",true);  
        }
        
        if(passlist == null || passlist == '' || passlist == undefined){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        console.log('Line29 '+passlist);
    },
    
    ontotalPassengerChangeCancellation: function (component, event, helper) {
        
        var passlist =  component.find("select1-id").get("v.value");
        console.log('Line--334-->'+passlist);
        component.set("v.totalpassengerCancellation",passlist);
        component.set("v.CancellationPassname1",'');
        component.set("v.CancellationPassname2",'');
        component.set("v.CancellationPassname3",'');
        component.set("v.CancellationPassname4",'');
        component.set("v.CancellationPassname5",'');
        component.set("v.CancellationPassname6",'');
        component.set("v.CancellationPassname7",'');
        component.set("v.CancellationPassname8",'');
        component.set("v.CancellationPassname9",'');
        component.set("v.CancellationPassname10",'');
        component.set("v.CancellationPassname11",'');
        component.set("v.CancellationPassname12",'');
        component.set("v.CancellationPassname13",'');
        component.set("v.CancellationPassname14",'');
        component.set("v.CancellationPassname15",'');
        component.set("v.CancellationPassname16",'');
        component.set("v.Cancellationamount",'');
        component.set("v.TotalClaimableAmount",'');
        
        if(passlist ==1 ){
            component.set("v.One",true); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
            
        }
        if(passlist == 2 ){
            component.set("v.One",false); 
            component.set("v.Two",true); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 3 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",true); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 4 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",true); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 5 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",true); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 6){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",true); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        
        if(passlist == 7 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",true); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 8  ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",true); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);   
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist == 9 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",true); 
            component.set("v.Ten",false); 
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist ==10 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",true);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        if(passlist ==11 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",true); 
            
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        
        if(passlist ==12 ){
            
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",true); 
            
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
            
        }
        if(passlist ==13 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",true); 
            
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==14 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",true); 
            component.set("v.eleven",false); 
            
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==15 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",true); 
            
            component.set("v.sixteen",false);  
            
        }
        if(passlist ==16 ){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",true);  
        }
        if(passlist == null || passlist == '' || passlist == undefined){
            component.set("v.One",false); 
            component.set("v.Two",false); 
            component.set("v.Three",false); 
            component.set("v.Four",false); 
            component.set("v.Five",false); 
            component.set("v.Six",false); 
            component.set("v.Seven",false); 
            component.set("v.Eight",false); 
            component.set("v.Nine",false); 
            component.set("v.Ten",false);  
            component.set("v.eleven",false); 
            component.set("v.twelve",false); 
            component.set("v.thirteen",false); 
            component.set("v.fourteen",false); 
            component.set("v.fifteen",false); 
            component.set("v.sixteen",false);  
        }
        console.log('Line29 '+passlist);
    },
    
    
    onCommChange: function (component, event, helper) {
        console.log("Entered In Deal");
        var comm = component.find("sendCommPicklist").get("v.value");
        
        console.log("Line--19-->"+comm);
        if(comm == 'Partial Cancellation'){
            
            component.set("v.PartialCancellation",true);
        }
        else{
            component.set("v.PartialCancellation",false);
        }
        if(comm == 'Interrupted Tour'){
            
            component.set("v.Interrupted",true);
        }
          else{
            component.set("v.Interrupted",false);
        }
        if(comm == 'Customer Quote Order Communications'){
            component.set("v.isSendQuote",true);
            component.set("v.quoteDetailsForCustomer",'We are excited to assist you in planning your next holiday with TripADeal.');
     
        }
      
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    previewCancellationComm : function (component,event,helper){
        console.log('inside this')
        component.set("v.onClickPreviewOrSendcancellation",true);
        helper.previewCancellationComm(component,event,helper);
    },
    
    
    sendCommcancellation : function (component,event,helper)
    {
        var isSendQuote = component.get("v.isSendQuote");
        component.set("v.onClickPreviewOrSendcancellation",false);

        if(isSendQuote == true){
            component.set("v.spinner",true);
            console.log('123 :-  ');
            helper.sendCustomerQuoteDetails(component,event,helper);//PSAG - 114 
        }else{
            helper.sendCommcancellation(component,event,helper);
        }
    },
    
    previewComm : function (component,event,helper){
        component.set("v.onClickPreviewOrSend",true);
        helper.previewComm(component,event,helper);
    },
    
    
    sendComm : function (component,event,helper)
    {
        console.log('line--297');
        component.set("v.onClickPreviewOrSend",false);
        helper.sendComm(component,event,helper);
    },
    
    handleNumberChange : function (component,event,helper)
    {
        var Num =  component.get("v.value");
        console.log("Stardt Date:"+component.get("v.pass"));
        console.log('Line--52-->'+JSON.stringify(Num));
    },
    
    
    /*

     * closing quickAction modal window

     * */
    
    closeModal : function(component, event, helper){
        console.log('##Start of CloseModal');
        var getSourceObject = component.get("v.sourceObject");
        var parentRecordId = component.get("v.recordId");
        if(getSourceObject == "Case")
        {
            var compEvent = component.getEvent("sampleComponentEvent");
            compEvent.setParams({
                "message" : 'From Paymethod Cancel',
                "TadOrderId": parentRecordId
            });
            compEvent.fire();
        }
        else{ 
            helper.closeModal();
        }
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModelCancellation: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpencancellation", false);
    },
    closeModel1: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
})