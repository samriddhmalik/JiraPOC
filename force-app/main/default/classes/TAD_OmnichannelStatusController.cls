/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_OmnichannelStatusController class-
* Purpose: Return the Service Presence Status ID to be used in Aura Component for Agent
* status change on full capacity.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-08-26
* @modified       
* @systemLayer    Service
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public with Sharing class TAD_OmnichannelStatusController {
    
    /*** TAD Service Status Wrapper ***/
    public class TAD_ServiceStatusWrapper{
        
        @auraEnabled public String availableStatusId {get;set;}
        @auraEnabled public String busyStatusId {get;set;}
    }
    
    /** This method returns the Id for Available & Busy Presence Status**/
    @AuraEnabled
    public static TAD_ServiceStatusWrapper getServiceStatus()
    {
        system.debug('##inside Wrapper');
        TAD_ServiceStatusWrapper wrapper = new TAD_ServiceStatusWrapper();
        List<String> statusDevName = new List<String>();
        statusDevName.add(Label.TAD_OmniAvailable);
        statusDevName.add(Label.TAD_OmniBusy);
        List<ServicePresenceStatus> spList = [select Id,developerName from ServicePresenceStatus where developerName in :statusDevName];
        if(spList.size()>0)
        {
            for(ServicePresenceStatus sp : spList)
            {
                if(sp.developerName==Label.TAD_OmniAvailable)
                {
                    
                    wrapper.availableStatusId=String.valueOf(sp.Id).substring(0, 15);
                }
                if(sp.developerName==Label.TAD_OmniBusy)
                {
                    wrapper.busyStatusId=String.valueOf(sp.Id).substring(0, 15);
                }
                
            }
            
        }
         system.debug('##Exit Wrapper:'+wrapper);
     /*   case c = [select id,OwnerId,Status,Origin from case where Origin='Web' and Status='New' order by createddate desc limit 1];
        string cid = c.OwnerId;
        if(cid.startsWith('005'))
        {
           c.Status = 'Working';
            update c;
        }
        */
        return wrapper;
    }
    
     @AuraEnabled
    public static void changeCaseStatus(Id workItemId)
    {
        System.debug('workItemId=='+workItemId);
        
        case c = [Select id,status from case where id=:workItemId];
        if(c.Status=='New')
        {
        c.Status = 'Working';
        c.Id=workItemId;
        update c;
        }
    }
}