/* ────────────────────────────────────────────────────────────────────────────────────────────────
* LiveChatTranscriptTriggerHandler -
* Purpose: Handler to trigger class which will update Contact on Transcript created from Live AGENT
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        2.0
* @created        2019-06-16
* @modified       2019-09-05  (Changes by Samrat M. for Showing WebSite Prefix in Chat Window)
* @systemLayer    Service
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class LiveChatTranscriptTriggerHandler {
    
    public static Boolean runOnce=true; //Restrict Recursive Trigger Execution.
	
    /** Method to update Contact on Transcript from case ***/
    public static List<LiveChatTranscript> updateContactOnTranscript(List<LiveChatTranscript> transList)
    {
        List<LiveChatTranscript> transTemp = new List<LiveChatTranscript>();
       system.debug('##TransList:'+transList);
        Map<Id,LiveChatTranscript> transMap = new Map<Id,LiveChatTranscript>();
        for(LiveChatTranscript trans: transList)
        {
            transMap.put(trans.CaseId,trans);
            
        }
        
       List<Case> caseList=[select id,contactId from case where id in:transMap.keySet()];
       system.debug('Livechat --caseList -->:'+caseList);
        for(Case c: caseList)
        {
          
            LiveChatTranscript trans = transMap.get(c.Id);
            if(trans.Status == 'Missed'){               
               delete c; 
                
            }else{
            Integer indexVal = transList.indexOf(trans);                          
            trans.ContactId=c.ContactId;
            transTemp.add(trans);
            }
            
        }
      
        return transTemp;
        
    }
    
    /** Method to update ReferrerURI based on Vistor Location on ChatTranscript ***/
    public static void updateReferrerUri(List<LiveChatTranscript> transList)
    {
        for(LiveChatTranscript trans : transList)
        {
            if(trans.location.contains(Label.NZ_Site_Label))
            {
            trans.ReferrerUri=Label.Newzealand_Site_Prefix; 
            }
            if(trans.location.contains(Label.AU_Site_Label))
            {
            trans.ReferrerUri=Label.Australia_Site_Prefix; 
            }
            else
            {
                String location = trans.location.substringAfterLast(','); //default location/country of visitor if not from AU or NZ
                trans.ReferrerUri = location; 
            }
           
        }
    }
    
}