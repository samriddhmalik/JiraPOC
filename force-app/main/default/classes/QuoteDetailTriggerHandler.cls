/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADOrderTriggerHandler
* Purpose: Apex Class Used for QuoteDetailTrigger .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Bharat Joshi  <bharat.joshi@psagtechnologies.com>

* @version        2.0
* 
* @modified       2020-02-28
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */


public class QuoteDetailTriggerHandler {
    
    public static void populateFieldValues(List<mp_Quote_Detail_POE__c> newQuoteDetail){
        Map<Id,Account> idAccountMap = new  Map<Id,Account>();
        Map<String,RBA_Exchange_Rate__c> currCodeVsRbaExchangeMap = new  Map<String,RBA_Exchange_Rate__c>();
        Set<Id> accIds = new Set<Id>();
        
        List<RBA_Exchange_Rate__c> rbaExchangeList = [Select id,Name,currency_code__c,exchange_rate__c from RBA_Exchange_Rate__c ];
        
        if(rbaExchangeList != null){
            
            for(RBA_Exchange_Rate__c rba:rbaExchangeList)
            {
                currCodeVsRbaExchangeMap.put(rba.Name,rba);
            }
            
            System.debug('#### currCodeVsRbaExchangeMap : ' + currCodeVsRbaExchangeMap);
        }
        
        
        
        for(mp_Quote_Detail_POE__c Qdetail : newQuoteDetail){
            
            accIds.add(Qdetail.Merchant__c);            
        }
        System.debug('#### accIds : ' + accIds);
        
        List<Account> accList = [Select id,name,Payment_Currency__c, CurrencyIsoCode, Company_Email__c, c2g__CODAAccountTradingCurrency__c from Account where id IN:accIds] ;
        
        for(Account acc:accList){
            
            idAccountMap.put(acc.id,acc);
        }
        System.debug('#### idAccountMap : ' + idAccountMap);
        
        Set<Id> orderCustomisationSet = new Set<Id>();
        Map<Id,String> orderCustomTADOrderMap = new Map<Id,String>();
        Map<Id,String> quoteDetailTADPriceMap = new Map<Id,String>();
        for(mp_Quote_Detail_POE__c qd : newQuoteDetail)
        {
            orderCustomisationSet.add(qd.mp_Order_Customisation__c);
        }
        System.debug('#### orderCustomisationSet : ' + orderCustomisationSet);
        
        for(Order_Customisations_POE__c oc : [Select id,recordType.Name, mp_tad_order__c, mp_tad_order__r.RecordTypeId, mp_tad_order__r.RecordType.DeveloperName from Order_Customisations_POE__c where id in: orderCustomisationSet])
        {
            orderCustomTADOrderMap.put(oc.Id,oc.mp_tad_order__r.RecordType.DeveloperName);
            quoteDetailTADPriceMap.put(oc.Id,oc.recordType.Name);
        }
        System.debug('#### orderCustomTADOrderMap : ' + orderCustomTADOrderMap);
        
        for(mp_Quote_Detail_POE__c qd :newQuoteDetail){
            String merchantCurrency = '';
            if(idAccountMap.get(qd.Merchant__c) != null){
                merchantCurrency= idAccountMap.get(qd.Merchant__c).CurrencyIsoCode;
                System.debug('#### merchantCurrency : ' + merchantCurrency);
                qd.CurrencyIsoCode = idAccountMap.get(qd.Merchant__c).CurrencyIsoCode;
                qd.Merchant_Email__c = idAccountMap.get(qd.Merchant__c).Company_Email__c;
                qd.mp_Merchant_Currency__c = merchantCurrency;
            }
            String recType = '';
            if(orderCustomTADOrderMap.get(qd.mp_Order_Customisation__c) == 'TAD' || orderCustomTADOrderMap.get(qd.mp_Order_Customisation__c) == 'TC')
            {
                recType = 'AUD';
            }
            else if(orderCustomTADOrderMap.get(qd.mp_Order_Customisation__c) == 'TNZ' || orderCustomTADOrderMap.get(qd.mp_Order_Customisation__c) == 'WT')
            {
                recType = 'NZD';
            }
            String rbaExKey = recType +  merchantCurrency;
            System.debug('#### rbaExKey : ' + rbaExKey);
            
            if(currCodeVsRbaExchangeMap.containsKey(rbaExKey)){
                
                qd.RBA_Exchange_Rate__c =  currCodeVsRbaExchangeMap.get(rbaExKey).id;
            }
            if(quoteDetailTADPriceMap.get(qd.mp_Order_Customisation__c) == 'Miscellaneous'){
                qd.CurrencyIsoCode = 'AUD';
                qd.TAD_Price__c =qd.mp_Merchant_Price__c;
            }
            else
            {
            if(qd.mp_Merchant_Price__c != null && merchantCurrency != null && currCodeVsRbaExchangeMap.get(rbaExKey) != null)
            {
                qd.CurrencyIsoCode = 'AUD';
                qd.TAD_Price__c = (((qd.mp_Merchant_Price__c / currCodeVsRbaExchangeMap.get(rbaExKey).exchange_rate__c)) * 11/10).setScale(2);               
            }
            }
            System.debug('#### qd : ' + qd);
            
        }
        
    }
    
    
    
    public static void settingOrdCustomStatus(List<mp_Quote_Detail_POE__c> quoteDetailList ,Map<Id, mp_Quote_Detail_POE__c> quoteOldmap){
        
        Set<ID> initalListOrderCus = new Set<ID>();
        List<mp_Quote_Detail_POE__c> listOfQD = new LIST<mp_Quote_Detail_POE__c>();
        Map<Id,Order_Customisations_POE__c> mapOfOcToUpdate = new  Map<Id,Order_Customisations_POE__c>();
        
        for(mp_Quote_Detail_POE__c qd: quoteDetailList){
            if(qd.Quote_Approval_Status__c != quoteOldmap.get(qd.Id).Quote_Approval_Status__c && (qd.Quote_Approval_Status__c == 'Decline' || qd.Quote_Approval_Status__c == 'CustomerApproved')){
                initalListOrderCus.add(qd.mp_Order_Customisation__c);
            }
        } 
        List <Order_Customisations_POE__c> ocList = [Select id ,Status__c,(Select id ,Quote_Approval_Status__c from Quote_Details__r) from Order_Customisations_POE__c where id IN:initalListOrderCus ];
        
        for(Order_Customisations_POE__c oc: ocList){
            for( mp_Quote_Detail_POE__c  quote: oc.Quote_Details__r){
                if(quote.Quote_Approval_Status__c=='CustomerApproved' || quote.Quote_Approval_Status__c=='Decline' ){
                    mapOfOcToUpdate.put(oc.id,oc);    
                }else{
                    if(mapOfOcToUpdate.get(oc.id) != null){
                        mapOfOcToUpdate.remove(oc.id); 
                        break;
                    }else{
                        break;
                    }
                } 
            } 
        }
        
        
        if(!mapOfOcToUpdate.isEmpty()){
            List<Order_Customisations_POE__c> ocToUpdate = new List<Order_Customisations_POE__c>();
            
            for (Order_Customisations_POE__c oc : mapOfOcToUpdate.Values()){
                
                Boolean isApproved = false;
                
                for( mp_Quote_Detail_POE__c  quote: oc.Quote_Details__r){
                    if(quote.Quote_Approval_Status__c=='CustomerApproved'){
                        isApproved=true;
                        break;
                    } 
                }
                if(isApproved==true){
                    Order_Customisations_POE__c ocRec = new Order_Customisations_POE__c();
                    ocRec.id =oc.id;
                    ocRec.Status__c='Customer Approved';
                    ocToUpdate.add(ocRec);   
                }else{
                    Order_Customisations_POE__c ocRec1 = new Order_Customisations_POE__c();
                    ocRec1.id =oc.id;
                    ocRec1.Status__c='Declined';
                    ocToUpdate.add(ocRec1);   
                } 
            }
            
            if(!ocToUpdate.isEmpty()){
                update ocToUpdate;
            }
            
        }
        
    }
    
    
    
    public class innerwrap{
        
        public Order_Customisations_POE__c oc{get;set;}
        public List<mp_Quote_Detail_POE__c> mqd{get;set;}
        
    } 
}