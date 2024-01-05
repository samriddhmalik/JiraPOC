public class linkProxyDTLwithNewDT {
    
     
    public class dtlRecords{
        @AuraEnabled  public Id Id {get;set;}
        @AuraEnabled  public Id dtId{get;set;}
        @AuraEnabled  public String dtlName {get;set;}
        @AuraEnabled  public String deal {get;set;}
        @AuraEnabled  public String company {get;set;}
        @AuraEnabled  public String departureDate {get;set;}
        @AuraEnabled  public String orderNumber {get;set;}
        @AuraEnabled  public Decimal amount {get;set;}
        @AuraEnabled  public String merchantCurrency {get;set;}
        @AuraEnabled  public Decimal invoiceAmount {get;set;}
        @AuraEnabled  public Boolean allocation {get;set;}
    }
    
    public class filterPage{
        @AuraEnabled  public Id merchantId {get;set;}
        @AuraEnabled  public String merchantName {get;set;}
        @AuraEnabled  public String invoiceNumber {get;set;}
        @AuraEnabled  public Date invoiceDate {get;set;}
        @AuraEnabled  public Decimal subTotal {get;set;}
        @AuraEnabled  public Decimal totalGST {get;set;}
        @AuraEnabled  public Decimal totalAmount {get;set;}
        @AuraEnabled  public Decimal selectedDTLAmount {get;set;}
        @AuraEnabled  public Decimal difference {get;set;}
        @AuraEnabled  public Date dateFrom {get;set;}
        @AuraEnabled  public Date dateTo {get;set;}
        @AuraEnabled  public String companyId {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public String departuredateId {get;set;}
        @AuraEnabled  public String orderNumber {get;set;}
    }
    
    public class picklistValues{
        @AuraEnabled  public String label {get;set;}
        @AuraEnabled  public String value {get;set;} 
    }
    
    public class draftDtAndDtls{
        @AuraEnabled  public Boolean draftExist {get;set;}
        @AuraEnabled  public String draftRecId {get;set;}
        @AuraEnabled  public List<dtlRecords> allocatedDtl {get;set;}
        @AuraEnabled  public List<dtlRecords> dtlRecordsDraft {get;set;}
        @AuraEnabled  public filterPage filterPageDraft {get;set;}
    }
    
    public class doInitWrap{
        @AuraEnabled  public Id merchantId {get;set;}
        @AuraEnabled  public String merchantName {get;set;}
        @AuraEnabled  public String merchantType {get;set;}
        @AuraEnabled  public List<picklistValues> companyValues {get;set;}
        @AuraEnabled  public draftDtAndDtls draftDtAndDtlsRecs {get;set;}
    }
    
    @AuraEnabled 
    public static doInitWrap doInitDefaultData(String merchantId){
        
        doInitWrap wrap = new doInitWrap();
        
        Account accountRecs = [Select id , Name, Merchant_Type__c   from Account  Where Id =: merchantId Limit 1];
        wrap.merchantId=accountRecs.id;
        wrap.merchantName=accountRecs.Name;
        wrap.merchantType=accountRecs.Merchant_Type__c;
        
        List<picklistValues> pickList = new List<picklistValues>();
        picklistValues pv = new picklistValues();
        pv.label='--None--';
        pv.value='';
        pickList.add(pv);
        
        List<c2g__codaCompany__c> compData = [Select id , name from c2g__codaCompany__c ];
        for(c2g__codaCompany__c com : compData){
            picklistValues val = new picklistValues();
            val.label =com.Name;
            val.value =com.id;  
            pickList.add(val);
        }
        
        wrap.companyValues=pickList;
        
        // Return Draft Info from DT records
        draftDtAndDtls dtDraft = new draftDtAndDtls(); 
        
        List<Deal_Transaction__c> dtrec = [Select id,Tax_Amount__c,Amount_Rollup__c, Account__c,ff_Filter_Info_Fields__c,Vendor_Invoice_Number__c,RecordTypeId,Company__c,Deal__c,Departure_Date__c,Status__c,CurrencyIsoCode,ff_MPT_JOIN__c,ff_Component_Type__c from Deal_Transaction__c Where Account__c =: merchantId AND Status__c ='Draft' Limit 1 ];
        System.debug('dtrec'+dtrec);
        if(!dtrec.isEmpty()){
            dtDraft.draftRecId=dtrec[0].id;
            dtDraft.draftExist=true;
            
            List<String> filterData =  dtrec[0].ff_Filter_Info_Fields__c.split(';');
            filterPage fp = new filterPage();
            fp.dateFrom = Date.valueOf(filterData[0]);
            fp.dateTo = Date.valueOf(filterData[1]);
            fp.invoiceNumber = dtrec[0].Vendor_Invoice_Number__c;
            fp.companyId = dtrec[0].Company__c;
            fp.merchantId = dtrec[0].Account__c;
            fp.totalGST = dtrec[0].Tax_Amount__c;
            
            List<Deal_Transaction_Line__c> dtlData = [Select id , name,Deal__r.name,Departure_Date__r.date__c,Deal_Transaction__c,Deal_Transaction_Draft__c,Deal_Transaction__r.Company__r.Name,
                                                      ff_Order_Line__r.TAD_Order__r.Name,Expected_Amount__c,Amount__c ,CurrencyIsoCode from Deal_Transaction_Line__c Where Deal_Transaction__r.Account__c =: fp.merchantId AND 
                                                      Deal_Transaction__r.Company__c=:fp.companyId AND (Transaction_Date__c >=: fp.dateFrom) AND (Transaction_Date__c <=: fp.dateTo) AND Status__c= 'Active' AND Deal_Transaction__r.ff_Proxy__c =true AND Is_Allocated__c=false];
            
            List<dtlRecords> allocatedDtl = new  List<dtlRecords>();
            List<dtlRecords> dtlDataList = new List<dtlRecords> ();
            
            Decimal amountDraft = 0;
            for(Deal_Transaction_Line__c dtl : dtlData){
                dtlRecords dtlr = new  dtlRecords();
                dtlr.Id=dtl.id;
                dtlr.dtId=dtl.Deal_Transaction__c;
                dtlr.dtlName=dtl.name;
                dtlr.deal=dtl.Deal__r.name;
                dtlr.company=dtl.Deal_Transaction__r.Company__r.Name;
                dtlr.departureDate=String.valueof(dtl.Departure_Date__r.date__c);
                dtlr.orderNumber=dtl.ff_Order_Line__r.TAD_Order__r.Name;
                dtlr.amount=dtl.Expected_Amount__c;
                dtlr.merchantCurrency=dtl.CurrencyIsoCode;
                dtlr.invoiceAmount=(dtl.Amount__c==null?0:dtl.Amount__c);
                if(dtl.Deal_Transaction_Draft__c!=null){
                    amountDraft=amountDraft+(dtl.Amount__c==null?0:dtl.Amount__c);
                    dtlr.allocation=true;
                    allocatedDtl.add(dtlr);
                }else{
                    dtlr.allocation=false;  
                }
                dtlDataList.add(dtlr);
            } 
            dtDraft.allocatedDtl=allocatedDtl;
            dtDraft.dtlRecordsDraft=dtlDataList;
            
            fp.selectedDTLAmount = amountDraft ;
            fp.totalAmount = amountDraft ;
            
            dtDraft.filterPageDraft=fp;
        }else{
            dtDraft.draftExist=false;
        }
        
        wrap.draftDtAndDtlsRecs=dtDraft;
        
        return wrap;
    }
    
    @AuraEnabled 
    public static List<picklistValues> getDepartureDatesApex(String dealId){
        System.debug('dealId'+dealId);
        List<departures_dates__c > getDtRecs = [Select id , Name,date__c from departures_dates__c  Where Linked_Deal_D_O_S__c =: dealId];
        
        List<picklistValues> ddPickList = new List<picklistValues>();
        picklistValues pv = new picklistValues();
        pv.label='--None--';
        pv.value='';
        ddPickList.add(pv);
        
        for(departures_dates__c  dd :getDtRecs){
            picklistValues pv1 = new picklistValues();
            pv1.label=String.valueof(dd.date__c);
            pv1.value=dd.Id;
            ddPickList.add(pv1);
        }
        System.debug('ddPickList'+ddPickList);
        return ddPickList;
    }
    
    @AuraEnabled
    public static List<dtlRecords> getFilteredDTLList(filterPage dataRec,List<dtlRecords> allocatedDtl){
        System.debug('Inside DTL'+dataRec);
        System.debug('Inside allocatedDtl'+allocatedDtl);
        
        Set<String> allocatedDtlSet = new Set<String>();
        for(dtlRecords dta :allocatedDtl){
            allocatedDtlSet.add(dta.Id);
        }
        
        String merchantId =dataRec.merchantId;
        String companyId =dataRec.companyId;
        Date dateFrom =dataRec.dateFrom;
        Date dateTo =dataRec.dateTo;
        String dealId ='';
        String departuredateId ='';
        
        String query = 'Select id , name,Deal__r.name,Departure_Date__c,Deal__c,Departure_Date__r.date__c,Deal_Transaction__c,Deal_Transaction__r.Company__r.Name,'+
            'ff_Order_Line__r.TAD_Order__r.Name,Expected_Amount__c ,CurrencyIsoCode,ff_Order_Line__r.Component_Name__c from Deal_Transaction_Line__c where Deal_Transaction__r.Account__c =: merchantId AND '+
            'Deal_Transaction__r.Company__c=:companyId AND (Transaction_Date__c >=: dateFrom) AND (Transaction_Date__c <=: dateTo) AND Status__c= \'Active\' AND Deal_Transaction__r.ff_Proxy__c =true AND Is_Allocated__c=false ';
        
        List<String> orders = new List<String>();
        if(dataRec.orderNumber !='' && dataRec.orderNumber !=null ){
            orders = dataRec.orderNumber.split(',');
            query = query+ ' AND ff_Order_Line__r.TAD_Order__r.Name IN:orders' ;
        }
        
        if(dataRec.departuredateId !='' && dataRec.departuredateId != null){
            departuredateId=dataRec.departuredateId;
            query = query+ ' AND Departure_Date__c =:departuredateId';
        }
        
        if(dataRec.dealId !='' && dataRec.dealId !=null){
            dealId=dataRec.dealId;
            query = query+ ' AND Deal__c=:dealId' ;
        }
        System.debug('queryRec'+query);
        List<Deal_Transaction_Line__c> dtlData = Database.query(query);
        
        List<dtlRecords> dtlDataList = new List<dtlRecords> ();
        for(Deal_Transaction_Line__c dtl : dtlData){
            dtlRecords dtlr = new  dtlRecords();
            dtlr.Id=dtl.id;
            dtlr.dtId=dtl.Deal_Transaction__c;
            dtlr.dtlName=dtl.name;
            dtlr.deal=dtl.Deal__r.name;
            dtlr.company=dtl.ff_Order_Line__r.Component_Name__c;
            dtlr.departureDate=String.valueof(dtl.Departure_Date__r.date__c);
            dtlr.orderNumber=dtl.ff_Order_Line__r.TAD_Order__r.Name;
            dtlr.amount=dtl.Expected_Amount__c;
            dtlr.merchantCurrency=dtl.CurrencyIsoCode;
            dtlr.invoiceAmount=0;
            if(allocatedDtlSet.contains(dtl.id)){
                dtlr.allocation=true; 
                dtlr.invoiceAmount=dtl.Expected_Amount__c;
            }else{
                dtlr.allocation=false;
                dtlr.invoiceAmount=0;
            }
            
            dtlDataList.add(dtlr);
        }
        
        return dtlDataList;
        
    }
    
    @AuraEnabled
    public static void createDtRecordDraftCall(List<dtlRecords> dtlrecs,filterPage dataRec,String draftId){
        System.debug('dtlrecs'+dtlrecs);
        System.debug('dataRec'+dataRec);
        System.debug('draftId'+draftId);
        if(!dtlrecs.isEmpty()){
            
            Deal_Transaction__c dtrec = new Deal_Transaction__c();
            dtrec.ff_Filter_Info_Fields__c =dataRec.dateFrom+';'+dataRec.dateTo;
            dtrec.ff_Proxy__c=false;
            dtrec.Status__c ='Draft';
            dtrec.RecordTypeId=TADUtils.getRecordTypeList('Multi_Line_Expense','Deal_Transaction__c');
            dtrec.Vendor_Invoice_Number__c =dataRec.invoiceNumber;
            dtrec.Account__c =dataRec.merchantId;
            dtrec.Company__c =dataRec.companyId;
            dtrec.Tax_Amount__c= dataRec.totalGST;
            if(draftId!=''){
                dtrec.id=draftId;
            }
            upsert dtrec;
            
            Set<Id> dtlIds = new Set<Id>();
            for(dtlRecords dtl : dtlrecs){
                if(dtl.allocation==true){
                    dtlIds.add(dtl.id);  
                }
            }
            
            Map<Id,Deal_Transaction_Line__c> dtlMap = new Map<Id,Deal_Transaction_Line__c>([Select id ,Deal_Transaction__c  ,Status__c , Departure_Date__c ,ff_Order_Line__c ,RecordTypeId,Transaction_Date__c,Description__c from Deal_Transaction_Line__c Where Id IN:dtlIds OR Deal_Transaction_Draft__c=:dtrec.id ] );
            
            List<Deal_Transaction_Line__c> dtlToupdate = new  List<Deal_Transaction_Line__c>();         
            for(dtlRecords dtl : dtlrecs){
                if(dtl.allocation==true){
                    Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
                    dtlNew.id =dtl.id;
                    dtlNew.Expected_Amount__c =dtl.amount;
                    dtlNew.Amount__c  =dtl.invoiceAmount;
                    dtlNew.Deal_Transaction_Draft__c =dtrec.id;
                    dtlToupdate.add(dtlNew);
                }else{
                    Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
                    dtlNew.Expected_Amount__c =0;
                    dtlNew.Amount__c  =0;
                    dtlNew.id =dtl.id;
                    dtlNew.Deal_Transaction_Draft__c =null;
                    dtlToupdate.add(dtlNew); 
                }
            }
            
            update dtlToupdate;  
        }        
    }
    
    @AuraEnabled
    public static void createDtRecordsApex(List<dtlRecords> dtlrecs,filterPage dataRec,String draftId){
        System.debug('dtlrecs'+dtlrecs);
        System.debug('dataRec'+dataRec);
        Id DTId;
        for(dtlRecords dt : dtlrecs){
            
             DTId = dt.dtId;
            Break;
        }
        
        if(!dtlrecs.isEmpty()){
            
            Deal_Transaction__c dtrec = new Deal_Transaction__c();
            dtrec.ff_Filter_Info_Fields__c =dataRec.dateFrom+';'+dataRec.dateTo;
            dtrec.ff_Proxy__c=false;
            dtrec.Status__c ='Active';
            dtrec.RecordTypeId=TADUtils.getRecordTypeList('Multi_Line_Expense','Deal_Transaction__c');
            dtrec.Vendor_Invoice_Number__c =dataRec.invoiceNumber;
            dtrec.Account__c =dataRec.merchantId;
            dtrec.Company__c =dataRec.companyId;
            dtrec.Tax_Amount__c= dataRec.totalGST;
            dtrec.Transaction_Date__c =dataRec.invoiceDate;
            dtrec.Original_Deal_Transaction__c = DTId;
            if(draftId!=''){
                dtrec.id=draftId;
            }
            upsert dtrec;
            
            Set<Id> dtlIds = new Set<Id>();
            for(dtlRecords dtl : dtlrecs){
                if(dtl.allocation==true){
                    dtlIds.add(dtl.id);  
                }
            }
            
            Map<Id,Deal_Transaction_Line__c> dtlMap = new Map<Id,Deal_Transaction_Line__c>([Select id , Status__c ,TAD_Order__c,Deal__c , Departure_Date__c ,ff_Order_Line__c ,RecordTypeId,Transaction_Date__c,Description__c from Deal_Transaction_Line__c Where Id IN:dtlIds] );
            
            List<Deal_Transaction_Line__c> dtlToInsert = new  List<Deal_Transaction_Line__c>();         
            for(dtlRecords dtl : dtlrecs){
                if(dtl.allocation==true){
                    Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
                    dtlNew.Deal_Transaction__c =dtrec.id;
                    dtlNew.Status__c =dtlMap.get(dtl.Id).Status__c;
                    dtlNew.Expected_Amount__c =dtl.amount;
                    dtlNew.Amount__c  =dtl.invoiceAmount;
                    dtlNew.Original_Deal_Transaction_Line__c =dtl.Id;
                    dtlNew.TAD_Order__c  =dtlMap.get(dtl.Id).TAD_Order__c;
                    dtlNew.Deal__c =dtlMap.get(dtl.Id).Deal__c;
                    dtlNew.Departure_Date__c =dtlMap.get(dtl.Id).Departure_Date__c;
                    dtlNew.ff_Order_Line__c =dtlMap.get(dtl.Id).ff_Order_Line__c;
                    dtlNew.RecordTypeId=dtlMap.get(dtl.Id).RecordTypeId;
                    dtlNew.Transaction_Date__c=dataRec.invoiceDate;
                    dtlNew.Description__c=dtlMap.get(dtl.Id).Description__c;
                    dtlNew.Deal_Transaction_Draft__c=null;
                    dtlToInsert.add(dtlNew);
                }
            }
      
            
            insert dtlToInsert;
            
            Map<String,String> originalVsReplacementMap = new Map<String,String>();
            for(Deal_Transaction_Line__c  dtlRec : dtlToInsert){
                originalVsReplacementMap.put(dtlRec.Original_Deal_Transaction_Line__c,dtlRec.id);
            }
            
            for(Deal_Transaction_Line__c dtlp : dtlMap.values()){
                dtlp.Deal_Transaction_Draft__c=null;
                dtlp.Is_Allocated__c =true; 
                dtlp.Transaction_Date__c=dataRec.invoiceDate;
                dtlp.Status__c =TAD_Constants.dtStatusSuperseded; 
                dtlp.Replacement_Deal_Transaction_Line__c=originalVsReplacementMap.get(dtlp.id);
            }
            
            update dtlMap.values();   
        }        
    }
    
}