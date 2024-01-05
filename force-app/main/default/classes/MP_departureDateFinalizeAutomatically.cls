global class MP_departureDateFinalizeAutomatically implements Database.Batchable < sobject >,Database.Stateful {
    global set<Id> listofDeptIds = new set<Id>();
       global set<Id> DeptIdSet = new set<Id>();
      
       global Database.QueryLocator start(Database.BatchableContext bc) {
           String Query;
           Date dt = system.today();
           String NotificationLabel = System.Label.MP_Batch_Notification;
   
           
           List<departures_dates__c> deptlist = [select Id,Name,Deal_for_Reporting__r.Name from departures_dates__c where BC_Due__c =:dt AND  date__c >= TODAY AND  (Approved_to_Run_Under_Mins__c = True OR min_numbers_met__c = True) AND (online_status__c = 'Offline - Auto' OR online_status__c = 'Offline - Manual')];
           system.debug('deptlist112-8-->'+deptlist);
           
           for(departures_dates__c d:deptlist){
               
               listofDeptIds.add(d.Id);
               
               
           }
            system.debug('listofDeptIds--->'+listofDeptIds);
           
           if(NotificationLabel == 'true'){
               Query = 'Select Id,Name,BC_Due__c,finalise_date__c from departures_dates__c WHERE Id =: listofDeptIds';
           }
           else{
               Query = 'Select Id,Name,BC_Due__c,finalise_date__c from departures_dates__c WHERE Id =: NotificationLabel';
               
           }
           
           return Database.getquerylocator(Query);
       }
       
       global void execute(Database.BatchableContext bc, List < departures_dates__c > deptDateList) {
           List<departures_dates__c> updateDeptList = New List<departures_dates__c>();
           system.debug('deptDateList--');
           for(departures_dates__c dept : deptDateList){
               system.debug('dept--->'+dept);
               if(dept.finalise_date__c == false){
               dept.finalise_date__c = True;
               }
               DeptIdSet.add(dept.Id);
               system.debug('DeptIdSet--33->'+DeptIdSet);
               updateDeptList.add(dept);
           }
           system.debug('DeptIdSet--35->'+DeptIdSet);
           update updateDeptList;
   
       }
       
       global void finish(database.BatchableContext bc) {
           MP_BCAvailableNotification.publishedDealEmailToMerchant(listofDeptIds);
       }
        
       
   }