/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* dealTriggerHandler
* Purpose: Apex Class Used for dealTrigger .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>

* @version        1.0
*
* @modified       2020-12-17
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class dealTriggerHandler {
    
    /* public static void sendEmailNotification(List<Deal__c> newDealList){
Set<Id> dealIdSet = new Set<Id>();
Set<Id> merchantIdSet = new Set<Id>();
Set<Id> mptJIdSet = new Set<Id>();
For(Deal__c d : newDealList ){

dealIdSet.add(d.Id);

}        
List<Component__c> compList = [Select Id,Name,Merchant_Name__c,LinkedDeal_D_O_S__c,MPT_JOIN__c,MPT_JOIN__r.Total_Amount__c from Component__c where LinkedDeal_D_O_S__c IN: dealIdSet];

For(Component__c com : compList){

if(com.MPT_JOIN__c == null){

merchantIdSet.add(com.Merchant_Name__c);
}else if(com.MPT_JOIN__r.Total_Amount__c != 100){

merchantIdSet.add(com.Merchant_Name__c);                
}
}
List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
List<Account> accList = [Select Id,Name from Account where Id IN:merchantIdSet];
for(Account acc: accList){

Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'vintichittora192@gmail.com'};
mail.setToAddresses(toAddresses);
mail.setSubject('Merchant doesn’t have payment terms');
String body = 'Please'+','+ 'create merchant payment terms for the merchant:'+' '+ acc.Name;
body += +' '+ URL.getSalesforceBaseUrl().toExternalForm()+ '/'+acc.Id;
mail.setHtmlBody(body);
mails.add(mail);
}
Messaging.sendEmail(mails); 
} */
    public static void populateToandFroDate(List<Deal__c> newDealList){
        Id batchJobId = Database.executeBatch(new PopulateDealFromToBatch(), 1); 
    }
    
    public static void validateComponent(List<Deal__c> newDealList){
        Set<Id> dealIdSet = new Set<Id>();
        
        for(Deal__c d : newDealList ){
            
            dealIdSet.add(d.Id);
            
        }        
        Map<Id,Deal__c> deals = new Map<Id,Deal__c>([select id,(select id from Components1__r) from Deal__c where id in:dealIdSet]);
        for(Deal__c d: newDealList){
            if(deals.get(d.Id).Components1__r.size() == 0)
                d.addError('Deal cannot be published without components. Please create a component.');
        }
    }
    public static void validateCost(List<Deal__c> newDealList){
        Set<Id> dealIdSet = new Set<Id>();
        for(Deal__c d : newDealList ){
            dealIdSet.add(d.Id);
        }        
        Map<Id,Deal__c> deals = new Map<Id,Deal__c>([select id,(select id,Cost__c,solo_rate_total__c from Component_Pricing__r) from Deal__c where id in:dealIdSet]);
        for(Deal__c d: newDealList){
            for(Component_Pricing__c cp : deals.get(d.Id).Component_Pricing__r){
                if(cp.Cost__c == null || cp.solo_rate_total__c == null || cp.Cost__c == 0 || cp.solo_rate_total__c == 0)
                    d.addError('Please enter cost in Component Pricing');
            }
        }
    }
    
    //PBP - 208 Start
    public static void cloneDealRecordHandle(List<Deal__c> newDealList){
        
        for(Deal__c deal : newDealList){
            deal.Deal_Status__c = 'BDM - Deal Draft In Progress';
            deal.Status__c = Null;
            deal.Status_NZ__c = Null;
            deal.Deal_Draft__c = Null;//PBP - 242
            deal.Cruise_Cabin_Booked_by__c = 'None';//PBP - 242
            deal.Cruise_Cabin_Allocation_Status__c = 'None';//PBP - 242
        }
    }//PBP - 208 Stop
    
    //PBP - 211 Start
    public static void populateLogisticInfoFromDraft(Set<String> dealDraftIds){
        
        Map<String,Deal_Draft__c> dealDraftMap = New Map<String, Deal_Draft__c>();
        
        If(!dealDraftIds.isEmpty()){
            List<Deal_Draft__c> fetchDealDraftWithDeal = [SELECT Id,Logistics_Information__c,Logistics_Information_NZ__c FROM Deal_Draft__c WHERE Id IN : dealDraftIds];
            
            for(Deal_Draft__c dDraft : fetchDealDraftWithDeal){
                dealDraftMap.put(dDraft.Id,dDraft);
            }
        }
        
        
        List<Deal__c> DealList = [SELECT Id,Deal_Draft__c FROM Deal__c WHERE Deal_Draft__c IN : dealDraftIds];
        if(!DealList.isEmpty()){
            for(Deal__c deal : DealList){
                if(!dealDraftMap.isEmpty()){
                    system.debug('--> '+string.valueof(dealDraftMap.get(deal.Deal_Draft__c).Logistics_Information__c));
                    if(dealDraftMap.get(deal.Deal_Draft__c).Logistics_Information__c != Null){
                        deal.Logistics_Information__c = dealDraftMap.get(deal.Deal_Draft__c).Logistics_Information__c.stripHtmlTags(); 
                    }
                }
            }
            system.debug('DealList '+DealList);
            update DealList;
        }
    }
    //PBP - 211 Stop
    
    //PSAG - 245 Start
    public static void MapCountryRegionContinent(List<deal__c> dealList){
        set<string>countrySet = new set<string>();
        for(deal__c d:dealList){
            List <string> primarycountries = d.Primary_Country__c.split(';');
            countrySet.addall(primarycountries);
        }
        
        List<Country_Information__mdt> countrymetadata = [SELECT id, Continent__c, Country__c, Region__c FROM Country_Information__mdt WHERE Country__c In:countrySet  ];
        
        for(deal__c d : dealList){
            set<string> regionset = new set<string>();
            set<string> continentset = new set<string>();
            for(Country_Information__mdt mtdt:countrymetadata){
                if(d.Primary_Country__c.containsIgnoreCase(mtdt.Country__c)){
                    regionset.add(mtdt.Region__c);
                    continentset.add(mtdt.Continent__c);
                }
            }
            system.debug('String.join(new List<String>(continentset):-  '+ String.join(new List<String>(continentset), ';') + '    String.join(new List<String>(regionset):-  '+ String.join(new List<String>(regionset), ';'));
            d.Primary_Continent__c =  String.join(new List<String>(continentset), ';');
            d.Primary_Region__c =  String.join(new List<String>(regionset), ';');
        }
    }
    //PSAG - 245 Stop
    
    public static void AddHtmlTagSummary(Set<Id> dealIdset){
        
        
        List<Deal__c> dealList = [SELECT Id,Summary__c FROM Deal__c WHERE Id IN : dealIdset];
        List<deal__c> dealupdateList = new List<deal__c>();
        
        system.debug('Summary 158----'+dealList) ;
        String HtmlTag = System.Label.Deal_By_noe_choose_date_html;
        for(deal__c d : dealList){
            if(d.Summary__c != Null){
                String S =d.Summary__c ;
                system.debug('Summary 158----'+S) ;
                //system.debug('Test----'+S.startsWith('<div')) ;
                if(!S.startsWith('<div')) {
                    d.Summary__c= HtmlTag+'\n'+S; 
                    dealupdateList.add(d);  
                }
                
            }else{
                d.Summary__c= HtmlTag;
                dealupdateList.add(d); 
            }
            
        }
        
        system.debug('dealupdateList 174----'+dealupdateList) ;
        if(!dealupdateList.isEmpty()){
            update DealList; 
        }
        
        
    }
}