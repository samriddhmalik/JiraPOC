public class MP_TotalPaxTravellingVsDepartureDate {
    
    public class  mainwrap{
        @AuraEnabled
        public string deptdate {get;set;}
        @AuraEnabled
        public Double Qty {get;set;}
    }
    @AuraEnabled(cacheable=true)
    Public Static List<mainwrap> totalPaxTravellingDetails(String dealId){
        system.debug('Entered In Apex From LWC-->'+dealId);
        
        List<mainwrap> mnList=new List<mainwrap>();
        
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        String userid = usr.Contact.AccountId;
        String dt = String.valueOf(system.today());
        Map<String, Map<String, List<order_line_POE__c>>> ordvsoli= new  Map<String, Map<String, List<order_line_POE__c>>>();
        map<String,Double> deptToqty=new map<String,Double>();

     
        List<TAD_Order__c> tadList = [Select Id,Name,ordexp_pax_travelling__c,ordexp_master_status__c,ordexp_departure_date__r.Name,ordexp_departure_date__r.date__c,(Select Id From Order_Lines_POE__r where Status__c !='Cancelled' AND Component__r.Merchant_Name__c =:userid AND MP_Start_Date__c >=TODAY Limit 1) from TAD_Order__c where (ordexp_master_status__c !='On Hold' AND ordexp_master_status__c !='Temporary Hold' AND ordexp_master_status__c !='Cancelled') AND (ordexp_deal__r.Deal_Status__c='Published' OR ordexp_deal__r.Deal_Status__c = 'On Hold' OR ordexp_deal__r.Deal_Status__c = 'Expired' ) AND ordexp_deal__r.RecordType.Name != 'Hotel' AND ordexp_departure_date__r.date__c>= TODAY AND ordexp_deal__c =:dealId Order by ordexp_departure_date__r.Name asc];
              System.debug('tadList--->'+tadList);  
        for(TAD_Order__c tad : tadList){
            if(tad.Order_Lines_POE__r.size() !=0){
            if(deptToqty.get(tad.ordexp_departure_date__r.Name)==null){
                deptToqty.put(tad.ordexp_departure_date__r.Name,0);
                
            }
            deptToqty.put(tad.ordexp_departure_date__r.Name,deptToqty.get(tad.ordexp_departure_date__r.Name)+tad.ordexp_pax_travelling__c);
        }
        }
        
        for(String s:deptToqty.keySet()){
            mainwrap mn=new mainwrap();
            mn.deptdate=s;
            mn.Qty=deptToqty.get(s);
            mnList.add(mn);
            
        }
      
        System.debug('mnList--41->'+mnList);
        return mnList;
        
    }
    
}