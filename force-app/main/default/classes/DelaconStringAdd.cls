public class DelaconStringAdd {
    
    public static  void GetDetailsFromCase(List<tad_order__c> newTadOrderList){
        String DelaconString = '';
        Set<Id> CaseID = new Set<Id>();
        Set<Id> TaskId = new Set<Id>();
        Set<Id> AccountId = new Set<Id>();
        Set<Id> TadOrderId = new Set<Id>();
        List<tad_order__c> UpdatedTadOrderList =new List<tad_order__c>();
        for (tad_order__c tad : newTadOrderList){
            if(tad.Delacon_String__c == null ){
                TadOrderId.add(tad.Id);
                system.debug('Purchase Date----11'+tad.ordexp_purchase_date__c);  
            }           
        }
        
        List<tad_order__c> UpdatedTadOrderList1 =[Select Id,Name,Delacon_String__c,ordexp_purchase_date__c from tad_order__c where Id in:TadOrderId];
        // system.debug('TadOrderId Date----11'+TadOrderId);
        
        List<Case> CaseList = [Select Id,CaseNumber,Account_Name__c,AccountId,Origin,L1__c,Task_Record_Id__c,TAD_Order__c,TAD_Order__r.ordexp_gross_amount_final__c,TAD_Order__r.ordexp_purchase_date__c,CreatedDate from Case where TAD_Order__c in: TadOrderId AND L1__c = 'New Bookings' AND Task_Record_Id__c !='' AND Origin ='Phone' ];
        system.debug('CaseList ----16'+CaseList);
        
        if(!CaseList.isEmpty()){
            //For Getting the Account Name for (Checking the tad order exist or not in system) and Task Id Map
            for(Case cs :CaseList){
                AccountId.add(cs.AccountId);
                TaskId.add(cs.Task_Record_Id__c) ;
            }
            
            List<Task> TaskList = [Select Id,Subject,DELAPLA__PLA_Call_Id__c,WhatId,DELAPLA__PLA_Call_Result__c,DELAPLA__PLA_Call_Start_Time__c,DELAPLA__PLA_Caller_Phone_Number__c,CreatedDate from Task where Id in: TaskId AND DELAPLA__PLA_Call_Id__c !='' order by createdDate desc];
            system.debug('TaskList ---18'+TaskList);
            
            Map<String,Task> TaskMap =new Map<String,Task>();
            Map<Id,Integer> AccountMap =new Map<Id,Integer>();
            Map<Id,String> tadorderstringMap =new Map<Id,String>();
            
            List<Task>selectedTSList =new List<Task>();
            Set<Id>Tsids =new Set<Id>();
            for(Task ts :TaskList){
                TaskMap.put(String.ValueOf(ts.Id),ts);
                /* if(!Tsids.contains(ts.WhatId)) {
Tsids.add(ts.WhatId);
selectedTSList.add(ts);
TaskMap.put(ts.Id,ts);
}*/
            }
            
            system.debug('TaskMap---47--'+TaskMap);
            system.debug('AccountId---46--'+AccountId);
            // system.debug('selectedTSList---47--'+selectedTSList);
            
            
            
            
            
            //--------For Getting the TadOrder If allredy in system-----------
            List<tad_order__c> tadOrderAccList = [Select Id,Name,ordexp_account__c from tad_order__c where ordexp_account__c in: AccountId AND (ordexp_master_status__c ='Secured' OR ordexp_master_status__c ='In Progress' OR ordexp_master_status__c ='Travelled')];
            system.debug('tadOrderAccList---48--'+tadOrderAccList);            
            if(!tadOrderAccList.isEmpty()){
                integer i=0;
                for(tad_order__c td : tadOrderAccList){
                    i=i+1;
                    AccountMap.put(td.ordexp_account__c,i);
                } 
                system.debug('i---47--'+i);   
            }
            //--------------End ---------
            system.debug('AccountMap--'+AccountMap); 
            
            
            for(Case cs :CaseList){
                
                Task t = TaskMap.get(cs.Task_Record_Id__c);
                if(t != null){
                    system.debug('Task--T---47--'+t);
                    DateTime createddate=   cs.CreatedDate;
                    DateTime tadtime =cs.TAD_Order__r.ordexp_purchase_date__c;
                    String grossamount = String.valueOf(cs.TAD_Order__r.ordexp_gross_amount_final__c);
                    String delaconCallId   = t.DELAPLA__PLA_Call_Id__c;
                    Long dt1Long = createddate.getTime();
                    system.debug('dt1Long'+dt1Long);
                    Long dt2Long = tadtime.getTime();
                    system.debug('dt2Long'+dt2Long);
                    Long milliseconds = dt2Long - dt1Long;
                    Long seconds = milliseconds / 1000;
                    Long minutes = seconds / 60;
                    Long hours = minutes / 60;
                    Long days = hours / 24;
                    Integer noOfTadOrder = AccountMap.get(cs.AccountId);
                    String noOfTadOrderExist = 'N';
                    if(noOfTadOrder > 1){
                        noOfTadOrderExist='R';
                    }
                    
                    system.debug('NoOfTadOrder---47--'+noOfTadOrder);
                    // ------For add the condition to delacon string --------- TadOrderPurchaseDate - CaseCreationDate less than to DelaconCOnversionNumber
                    Integer conversionDay =Integer.ValueOf(System.Label.Delacon_conversion_days);
                    system.debug('conversionDay---47--'+conversionDay);
                    
                    String dtt =t.DELAPLA__PLA_Caller_Phone_Number__c;
                    system.debug('dtt-----------'+dtt);
                    String phoneNo=dtt.replaceFirst( '^0+', '');
                    system.debug('phoneNo-----------'+phoneNo);
                    
                    if(days<conversionDay && t != null) {
                        String NewDate ='';
                        String plaStartTime = t.DELAPLA__PLA_Call_Start_Time__c != null ? t.DELAPLA__PLA_Call_Start_Time__c:'';
                        //String dateTimeStr = t.DELAPLA__PLA_Call_Start_Time__c.format('dd/MM/yyyy hh:mm:ss');
                        // system.debug('dateTimeStr---47--'+dateTimeStr);  
                        if(plaStartTime != ''){
                            String pT = plaStartTime.replaceAll('-', '');
                            string[] splitted = pT.split(' ');
                            NewDate = splitted[0]+' '+splitted[1]+'.'+splitted[2]; 
                            system.debug('NewDate---47--'+NewDate);   
                        }
                        
                        
                        DelaconString = '-1,'+'+61'+phoneNo+','+NewDate+','+grossamount+',BQ|GA|ADWORDS'+','+delaconCallId +','+ noOfTadOrderExist;  
                        system.debug('DelaconString---47--'+DelaconString);  
                    }             
                    tadorderstringMap.put(cs.TAD_Order__c,DelaconString); 
                    
                }
                
            }
            system.debug('tadorderstringMap---'+tadorderstringMap);
            Set<String> setOfIDs = new Set<String>();
            for (tad_order__c tad : UpdatedTadOrderList1){                
                String sttad=  tadorderstringMap.get(tad.Id); 
                if(sttad !='' || sttad != null){                    
                    setOfIDs.add(sttad+'#'+tad.Id +'#'+tad.ordexp_purchase_date__c);                 
                    
                }
                
                
            }
            if(!setOfIDs.isEmpty()){
              //  DelaconStringAdd.futureCalloutMethod(setOfIDs); 
            }
                   
            
        }      
        
        
    }
    
    /*
    @Future(callout =True)
    public static void futureCalloutMethod(Set<String> idSet){
        system.debug('idSet----28->'+idSet);
             
        List<tad_order__c> updateTadOrder = new List<tad_order__c>();
        for(String str : idSet){
            String[] splitted = str.split('#');
            String delaconString =splitted[0];
            Id tadOrderid =Id.valueOf(splitted[1]);
            String purchasedate = splitted[2];
            
            Http http = new Http();           
            HttpRequest request = new HttpRequest();     
            String endPointUrl = System.Label.DelaconTrackingUrl;          
            String authToken = System.Label.DelaconAuth;
            system.debug('request----41->'+endPointUrl);
            system.debug('request----41->'+authToken);
            request.setEndpoint(endPointUrl);            
            request.setMethod('POST');
            request.setHeader('Auth', authToken);
            request.setHeader('Content-Type', 'text/plain');
            
            request.setBody(delaconString);
            system.debug('request----41->'+request.getBody());
            HttpResponse response = http.send(request);
           // system.debug('response----39->'+response);                
            String responseBody = response.getBody();
            system.debug('response--body string--39->'+responseBody);      
            
            tad_order__c tadorder = new tad_order__c(); 
            tadorder.Id =tadOrderid;
            tadorder.Delacon_String__c =delaconString;
            tadorder.Delacon_Sale_converted_Date__c = DateTime.valueOf(purchasedate);
            tadorder.Delacon_Api_Status__c = responseBody;
            updateTadOrder.add(tadorder);
            
            
            
        }
        
        system.debug('updateTadOrder--197->'+updateTadOrder); 
        if(!updateTadOrder.isEmpty()){
            update updateTadOrder;
        }
        
        
    }*/
}