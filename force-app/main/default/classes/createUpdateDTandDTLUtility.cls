public class createUpdateDTandDTLUtility {
    
    
    // Method is called from orderlineTrigger on OL Insert
    public static void createDTRecordsAndDTOLs(Set<Id> OLIids){
        /*
List<order_line_POE__c> newOLList=[Select id,Name,TAD_Order__r.ordexp_purchase_date__c,TAD_Order__r.ordexp_deal_type__c,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.Deal__c,TAD_Order__c,Component__r.LinkedDeal_D_O_S__c,OL_Type__c,Component__r.Component_Type__c ,Component__r.MPT_JOIN__c ,mp_merchant__c,tad_order__r.RecordType.Name,ff_DT_archetype__c,ff_Merchant_Currency__c,mp_merchant__r.Merchant_Type__c,Gross_Cost__c,Status__c,Home_Rate__c,Dual_Rate__c, CurrencyIsoCode from order_line_POE__c where Id IN:OLIids];

Set<Id> dealIds = new Set<Id>();
Set<Id> merchantIds = new Set<Id>();
for(order_line_POE__c olIterate : newOLList) {
if(olIterate.OL_Type__c == 'Component' && !olIterate.ff_DT_archetype__c.contains('Populate Merchant Type')){
System.debug('ValueOl1'+olIterate.ff_DT_archetype__c);
String []  value = olIterate.ff_DT_archetype__c.split(';');
System.debug('ValueOl'+value);
dealIds.add(olIterate.Order_Line_Item__r.Deal__c);
merchantIds.add(value[1]);
}
}

Set<String> dTArchetype = new Set<String>();

if(!merchantIds.isEmpty() || !dealIds.isEmpty()){
List<Deal_Transaction__c> dtsCreated = [Select id , ff_DT_archetype__c  from  Deal_Transaction__c  WHERE (Deal__c  IN: dealIds OR Account__c IN: merchantIds) AND Primary_Dt__c=true];
System.debug('dtsCreated'+dtsCreated);
for(Deal_Transaction__c dts : dtsCreated){
dTArchetype.add(dts.ff_DT_archetype__c);
}  

Map<String,Deal_Transaction__c> dtToInsert = new Map<String,Deal_Transaction__c>();

for(order_line_POE__c ol : newOLList) {
System.debug('olIds'+ol.name);
if((!dTArchetype.contains(ol.ff_DT_archetype__c)) && ol.OL_Type__c == 'Component'){
String []  value = ol.ff_DT_archetype__c.split(';');

if(value[0]!='' && value[1]!='' && ol.Component__r.MPT_JOIN__c!=null){
// Creates DT FOR SLE Merchant
if(ol.mp_merchant__r.Merchant_Type__c==TAD_Constants.singleLineExpense){
Deal_Transaction__c dt = new Deal_Transaction__c();
dt.Account__c =value[1];
dt.RecordTypeId=TADUtils.getRecordTypeList('Single_Line_Expense','Deal_Transaction__c'); 
if(ol.tad_order__r.RecordType.Name==TAD_Constants.TAD || ol.tad_order__r.RecordType.Name==TAD_Constants.TC){
dt.Company__c=Label.AU_DT_Company ;
dt.Entity__c='Trip A Deal Pty Limited';
}else{
dt.Company__c=Label.NZ_DT_Company ;
dt.Entity__c='TripADeal (NZ) Limited';  
}
dt.Deal__c =value[2] ;
dt.Dual_Rate__c = ol.Dual_Rate__c;
dt.Deal_Rate__c = ol.Home_Rate__c;
dt.Departure_Date__c=value[3];
dt.Status__c =TAD_Constants.dtStatusActive;
dt.CurrencyIsoCode=ol.ff_Merchant_Currency__c;
dt.ff_MPT_JOIN__c =ol.Component__r.MPT_JOIN__c;
dt.Component__c =value[4];
dt.ff_Component_Type__c=ol.Component__r.Component_Type__c;
System.debug('dtRec'+dt);
dtToInsert.put(ol.ff_DT_archetype__c,dt);   
}
// Creates DT FOR SLE Merchant Ends

// Creates DT FOR MLE Merchant
else if(ol.mp_merchant__r.Merchant_Type__c==TAD_Constants.multiLineExpense){
Deal_Transaction__c dt = new Deal_Transaction__c();
dt.Account__c =value[1];
dt.RecordTypeId=TADUtils.getRecordTypeList('Multi_Line_Expense','Deal_Transaction__c'); 
if(ol.tad_order__r.RecordType.Name==TAD_Constants.TAD || ol.tad_order__r.RecordType.Name==TAD_Constants.TC){
dt.Company__c=Label.AU_DT_Company ;
dt.Entity__c='Trip A Deal Pty Limited';
}else{
dt.Company__c=Label.NZ_DT_Company ;
dt.Entity__c='TripADeal (NZ) Limited';
}
//dt.Deal__c =value[1] ;
//dt.Departure_Date__c=value[2];
dt.Status__c =TAD_Constants.dtStatusActive;
dt.CurrencyIsoCode=ol.ff_Merchant_Currency__c;
//dt.ff_MPT_JOIN__c =ol.Component__r.MPT_JOIN__c;
dt.ff_Proxy__c = true;
dt.Is_Perpetual__c =true;
// dt.ff_Component_Type__c=mptJoinsMapCmpType.get(value[0]);
System.debug('dtRec'+dt);
dtToInsert.put(ol.ff_DT_archetype__c,dt);     
}
// Creates DT FOR MLE Merchant Ends
}
}
}

if(!dtToInsert.isEmpty()){
insert dtToInsert.values();
}


List<Deal_Transaction__c> dtsCreatedAll = [Select id, Account__c ,ff_MPT_JOIN__c,Departure_Date__c,CurrencyIsoCode, ff_DT_archetype__c,Departure_Date__r.date__c,ff_Merchant_Type__c ,(Select id from DTTermsJunctions__r) from  Deal_Transaction__c  WHERE (Deal__c  IN: dealIds OR Account__c IN: merchantIds) AND Primary_Dt__c=true];
System.debug('dtsCreatedAll'+dtsCreatedAll);
Map<Id,MPT_JOIN__c> mptJoinMap = new Map<Id,MPT_JOIN__c>([Select id , name , Account__c ,(Select id , Amount__c ,Payment_Due__c ,Days9__c  from Merchant_Terms__r) from MPT_JOIN__c WHERE Account__c  IN: merchantIds ]);

Map<String,Deal_Transaction__c> dtMap = new Map<String,Deal_Transaction__c>();
List<DTTermsJunction__c> dtOltermsToInsert = new List<DTTermsJunction__c>();
for(Deal_Transaction__c dts : dtsCreatedAll){
dtMap.put(dts.ff_DT_archetype__c,dts);
if(dts.DTTermsJunctions__r.size()==0 && dts.ff_Merchant_Type__c=='Single Line Expense' && dts.ff_MPT_JOIN__c!=null ){
List<Merchant_Terms__c> mtrList = mptJoinMap.get(dts.ff_MPT_JOIN__c).Merchant_Terms__r;   
for(Merchant_Terms__c mt : mtrList){
DTTermsJunction__c dtj = new DTTermsJunction__c();
dtj.Deal_Transaction__c =dts.id;
dtj.CurrencyIsoCode =dts.CurrencyIsoCode;
dtj.Merchant_Terms__c =mt.id;
dtOltermsToInsert.add(dtj);
}
}
}
insert dtOltermsToInsert;

Map<String,DTTermsJunction__c> dtTermMap = new Map<String,DTTermsJunction__c>();
List<DTTermsJunction__c> termJunction = [Select id,Deal_Transaction__c,Merchant_Terms__c from DTTermsJunction__c where Deal_Transaction__c IN: dtsCreatedAll];
for(DTTermsJunction__c dtm : termJunction){
dtTermMap.put(dtm.Merchant_Terms__c+';'+dtm.Deal_Transaction__c,dtm);
}    

List<DTOrderLineJunction__c> dtOlToInsert = new List<DTOrderLineJunction__c>();
List<Deal_Transaction_Line__c> dtlToInsert = new List<Deal_Transaction_Line__c>();

for(order_line_POE__c ol1 : newOLList) {
// Code for DTL Junction creation for SLE merchant
if(ol1.mp_merchant__r.Merchant_Type__c==TAD_Constants.singleLineExpense && dtMap.get(ol1.ff_DT_archetype__c)!=null && ol1.Component__r.MPT_JOIN__c!=null){
List<Merchant_Terms__c> mtrList = mptJoinMap.get(ol1.Component__r.MPT_JOIN__c).Merchant_Terms__r;
for(Merchant_Terms__c mt : mtrList){
DTOrderLineJunction__c dtOl = new DTOrderLineJunction__c();
dtOl.ff_Deal_Transaction__c = dtMap.get(ol1.ff_DT_archetype__c).id;
dtOl.DTTermsJunction__c  = dtTermMap.get(mt.id+';'+dtMap.get(ol1.ff_DT_archetype__c).id).id;
dtOl.ff_order_line__c =ol1.id;
dtOl.Merchant_Terms__c=mt.id;
dtOl.CurrencyIsoCode=ol1.CurrencyIsoCode;
dtOl.ff_OL_Gross_Cost__c =(ol1.Gross_Cost__c==null?0:ol1.Gross_Cost__c*mt.Amount__c)/100;
dtOl.ff_Status__c  =ol1.Status__c;
dtOlToInsert.add(dtOl); 
}
}
// Code for DTL creation for SLE merchant ends

// Code for DTL creation for MLE merchant
if(ol1.mp_merchant__r.Merchant_Type__c==TAD_Constants.multiLineExpense && dtMap.get(ol1.ff_DT_archetype__c)!=null && ol1.Component__r.MPT_JOIN__c!=null){

List<Merchant_Terms__c> mtrList = mptJoinMap.get(ol1.Component__r.MPT_JOIN__c).Merchant_Terms__r;

for(Merchant_Terms__c mt : mtrList){ 
Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
dtlNew.Deal_Transaction__c =dtMap.get(ol1.ff_DT_archetype__c).id;
dtlNew.Status__c =TAD_Constants.dtStatusActive;
dtlNew.Expected_Amount__c =(ol1.Gross_Cost__c==null?0:ol1.Gross_Cost__c*mt.Amount__c)/100;
dtlNew.Departure_Date__c =ol1.TAD_Order__r.ordexp_departure_date__c;
dtlNew.ff_order_line__c =ol1.id;
dtlNew.Deal__c = ol1.Component__r.LinkedDeal_D_O_S__c;
dtlNew.TAD_Order__c = ol1.TAD_Order__c;
dtlNew.Payment_Terms__c =mt.id;
dtlNew.CurrencyIsoCode = dtMap.get(ol1.ff_DT_archetype__c).CurrencyIsoCode;
dtlNew.Deal_Rate__c = ol1.Home_Rate__c;
dtlNew.Dual_Rate__c = ol1.Dual_Rate__c;
dtlNew.RecordTypeId=TADUtils.getRecordTypeList('Multi_Line_Expense','Deal_Transaction_Line__c');   
if(mt.Payment_Due__c=='Days prior to departure' ){
dtlNew.Transaction_Date__c =  ol1.TAD_Order__r.ordexp_departure_date__r.date__c.addDays(-Integer.valueOf(mt.Days9__c==null?0:mt.Days9__c)) ;
}else if(mt.Payment_Due__c=='Days after departure'){
dtlNew.Transaction_Date__c =  ol1.TAD_Order__r.ordexp_departure_date__r.date__c.addDays(Integer.valueOf(mt.Days9__c==null?0:mt.Days9__c)) ;
}else if(mt.Payment_Due__c=='Date of departure'){
dtlNew.Transaction_Date__c =  ol1.TAD_Order__r.ordexp_departure_date__r.date__c;
}else if(mt.Payment_Due__c=='On Confirmation' && (ol1.TAD_Order__r.ordexp_deal_type__c.containsIgnoreCase('cruise')||ol1.TAD_Order__r.ordexp_deal_type__c.containsIgnoreCase('travel'))){	
dtlNew.Transaction_Date__c =  ol1.TAD_Order__r.ordexp_departure_date__r.date__c.addDays(-Integer.valueOf(mt.Days9__c==null?0:mt.Days9__c)) ;	
}else if(mt.Payment_Due__c=='On Confirmation' && ol1.TAD_Order__r.ordexp_deal_type__c.containsIgnoreCase('stay')){	
dtlNew.Transaction_Date__c =  ol1.TAD_Order__r.ordexp_purchase_date__c.date();
}
dtlNew.Description__c =dtlNew.Transaction_Date__c+' | '+ mt.Amount__c+'%';
dtlToInsert.add(dtlNew);

}
}   
// Code for DTL creation for MLE merchant ends

}

if(!dtOlToInsert.isEmpty()){
insert dtOlToInsert;
}
if(!dtlToInsert.isEmpty()){
insert dtlToInsert;
}
}
*/
    }
    
    // Method is called from departuredateTrigger
    
    public static void updateDTRecordsfromDepartureDate(List<departures_dates__c> newDDList , Map<Id,departures_dates__c> oldDDMap){
        /*
Set <Id> ddIds = new Set <Id>();
for(departures_dates__c dd : newDDList) {
if(dd.MinNotMetApproval__c  != oldDDMap.get(dd.id).MinNotMetApproval__c && dd.MinNotMetApproval__c=='Processed'){
ddIds.add(dd.id);
}
}

if(!ddIds.isEmpty()){
List<Deal_Transaction__c> dtToCancel = [Select id , ff_DT_archetype__c  from  Deal_Transaction__c  WHERE Departure_Date__c IN: ddIds];
List<order_line_POE__c> olToCancel = [Select id , Name,Departure_date__c  from  order_line_POE__c  WHERE Departure_date__c  IN: ddIds];

if(!dtToCancel.isEmpty()){
for(Deal_Transaction__c dt : dtToCancel) {
dt.Status__c=TAD_Constants.dtStatusCancelled;
}
update dtToCancel; 
}    

if(!olToCancel.isEmpty()){
for(order_line_POE__c ol : olToCancel) {
ol.Status__c =TAD_Constants.dtStatusCancelled;
}
update olToCancel; 
}      
} 
*/
}



// This method updates junction for SLE type Merchant and DTL for MLE on Cancellation
public static void updateDTOrderLineJunctionRecords(List<order_line_POE__c> newOLList, Map<Id,order_line_POE__c> oldOLMap ){
/*
Set<id> olCancelledSLE = new Set<id>();
Set<id> olCancelledMLE = new Set<id>();
List<order_line_POE__c> updateDTOLForSLE = new List<order_line_POE__c> ();
for(order_line_POE__c ol : newOLList){
if((ol.Status__c!=oldOLMap.get(ol.id).Status__c) && ol.Status__c==TAD_Constants.dtStatusCancelled && ol.Merchant_Type__c==TAD_Constants.singleLineExpense){
olCancelledSLE.add(ol.id); 
}
if((ol.Status__c!=oldOLMap.get(ol.id).Status__c) && ol.Status__c==TAD_Constants.dtStatusCancelled && ol.Merchant_Type__c==TAD_Constants.multiLineExpense){
olCancelledMLE.add(ol.id); 
}
if((ol.Gross_Cost__c !=oldOLMap.get(ol.id).Gross_Cost__c) && ol.OL_Type__c == 'Component' && ol.Merchant_Type__c==TAD_Constants.singleLineExpense){
updateDTOLForSLE.add(ol); 
}
}

// This method Updates DTOL for SLE Type merchant
if(!updateDTOLForSLE.isEmpty()){
List<DTOrderLineJunction__c> dtolList = [Select id,ff_order_line__c,ff_Status__c from DTOrderLineJunction__c Where ff_order_line__c IN:updateDTOLForSLE AND ff_Status__c!='Cancelled'];

for(order_line_POE__c ol : updateDTOLForSLE){
for(DTOrderLineJunction__c dtol : dtolList){
if(dtol.ff_order_line__c == ol.id){
dtol.ff_OL_Gross_Cost__c=ol.Gross_Cost__c;   
}
}  
}
update dtolList;
}

// This method cancels SLE Type merchant
if(!olCancelledSLE.isEmpty()){
List<DTOrderLineJunction__c> dtolList = [Select id,ff_Status__c from DTOrderLineJunction__c Where ff_order_line__c IN:olCancelledSLE AND ff_Status__c!='Cancelled'];

for(DTOrderLineJunction__c dtol : dtolList){
dtol.ff_Status__c=TAD_Constants.dtStatusCancelled;  
}

update dtolList;
}

// This method cancels MLE Type merchant
if(!olCancelledMLE.isEmpty()){
System.debug('olCancelledMLE'+olCancelledMLE);
List<Deal_Transaction_Line__c> dtlCancelList = [Select id,Payment_Terms__c,Deal_Transaction__r.CurrencyIsoCode ,Deal_Transaction__r.Original_Deal_Transaction__c ,TAD_Order__c,Deal__c,Amount__c,Status__c,Deal_Transaction_Draft__c,Description__c,ff_order_line__c,Transaction_Date__c,RecordTypeId,Deal_Transaction__r.ff_Proxy__c,Deal_Transaction__c,Expected_Amount__c,Departure_Date__c,Payment_Terms__r.Amount__c from Deal_Transaction_Line__c Where ff_order_line__c IN:olCancelledMLE AND Status__c!='Cancelled'];
System.debug('dtlCancelList'+dtlCancelList);
List<Deal_Transaction_Line__c> dtlToInsert = new List<Deal_Transaction_Line__c>();
for(Deal_Transaction_Line__c dtl : dtlCancelList){
System.debug('dtl.ff_Proxy__c'+dtl.Deal_Transaction__r.ff_Proxy__c);
if(dtl.Deal_Transaction__r.ff_Proxy__c==true && dtl.Deal_Transaction_Draft__c==null){
dtl.Status__c=TAD_Constants.dtStatusCancelled;    
}else{
dtl.Status__c=TAD_Constants.dtStatusActive;

Deal_Transaction_Line__c dtlNew = new Deal_Transaction_Line__c();
dtlNew.Deal_Transaction__c =dtl.Deal_Transaction__r.Original_Deal_Transaction__c;
dtlNew.CurrencyIsoCode = dtl.Deal_Transaction__r.CurrencyIsoCode;
dtlNew.Status__c =TAD_Constants.dtStatusActive;
dtlNew.ff_order_line__c =dtl.ff_order_line__c;
dtlNew.Deal__c =dtl.Deal__c;
dtlNew.Payment_Terms__c =dtl.Payment_Terms__c;
dtlNew.TAD_Order__c =dtl.TAD_Order__c;
dtlNew.Expected_Amount__c =-dtl.Expected_Amount__c;
dtlNew.Departure_Date__c =dtl.Departure_Date__c;
dtlNew.RecordTypeId=dtl.RecordTypeId;   
dtlNew.Transaction_Date__c=dtl.Transaction_Date__c;
dtlNew.Description__c = 'Credit Note - '+' | '+ dtl.Payment_Terms__r.Amount__c+'%';
dtlToInsert.add(dtlNew);
}
}
update dtlCancelList;
insert dtlToInsert;
}
*/
    }
    //@future 
    public static void updateDtOlRecordsAsInvoiced( Set<String> dtIds , Set<String> termsIds   ){
        /*
List<DTOrderLineJunction__c > dtOlList = [select id , name , ff_Is_Invoiced__c  from DTOrderLineJunction__c where ff_Deal_Transaction__c IN:dtIds AND Merchant_Terms__c IN:termsIds AND ff_Is_Invoiced__c=false AND ff_Status__c!='Cancelled'];
for(DTOrderLineJunction__c dtol : dtOlList){
dtol.ff_Is_Invoiced__c=true;
}
update dtOlList;
*/
    }
    
    public static void createUpdateDTLRecordsNonInvoiced( List<DTTermsJunction__c>  dtTerm ){
        /*
Set<String> dtlImpacted = new Set<String>();
Set<String> dtIds = new Set<String>();
for(DTTermsJunction__c terms :dtTerm ){
dtlImpacted.add(terms.DTL_Reference_SLE__c );
dtIds.add(terms.Deal_Transaction__c );
}


List<Deal_Transaction_Line__c> dtlList = [select id , Status__c, Payment_Terms__c  from Deal_Transaction_Line__c where Status__c='Active' AND Payable_Invoice__c=null AND DTL_Reference_SLE__c IN: dtlImpacted AND ff_credit_note__c=false];

List<Deal_Transaction_Line__c> dtlToUpdate = new List<Deal_Transaction_Line__c>();
List<Deal_Transaction_Line__c> dtlToInsert = new List<Deal_Transaction_Line__c>();

Map<String,String> termsVsdtlId = new Map<String,String>();
Map<String,String> termsVsdtlId1 = new Map<String,String>();
for(Deal_Transaction_Line__c dtl : dtlList){
dtl.Status__c=TAD_Constants.dtStatusSuperseded;
dtlToUpdate.add(dtl); 
termsVsdtlId.put(dtl.Payment_Terms__c,dtl.id );
}

for(DTTermsJunction__c dtl : dtTerm){          
Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
dtlNew.Deal_Transaction__c =dtl.Deal_Transaction__c ;
if(dtl.Non_Invoiced_DTOLs__c==0){
dtlNew.Status__c =TAD_Constants.dtStatusCancelled;
}else{
dtlNew.Status__c =TAD_Constants.dtStatusActive;
}
//dtlNew.Status__c =TAD_Constants.dtStatusActive;
dtlNew.Expected_Amount__c =dtl.Non_Invoiced_DTOLs__c ;
dtlNew.Departure_Date__c =dtl.DT_Departure_Date__c  ;
dtlNew.CurrencyIsoCode =dtl.CurrencyIsoCode  ;
dtlNew.Deal__c = dtl.DT_Deal__c ;
dtlNew.Original_Deal_Transaction_Line__c =termsVsdtlId.get(dtl.Merchant_Terms__c );
dtlNew.Payment_Terms__c = dtl.Merchant_Terms__c ;
dtlNew.RecordTypeId=TADUtils.getRecordTypeList('Single_Line_Expense','Deal_Transaction_Line__c');   
if(dtl.Mpt_Payment_Due__c =='Days prior to departure' ){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(-Integer.valueOf(dtl.MT_Days__c ==null?0:dtl.MT_Days__c)) ;
}else if(dtl.Mpt_Payment_Due__c =='Days after departure'){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(Integer.valueOf(dtl.MT_Days__c==null?0:dtl.MT_Days__c)) ;
}else if(dtl.Mpt_Payment_Due__c =='Date of departure'){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c;
}else if(dtl.Mpt_Payment_Due__c=='On Confirmation' ){	
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(-Integer.valueOf(dtl.MT_Days__c==null?0:dtl.MT_Days__c)) ; 
}
dtlNew.Description__c =dtlNew.Transaction_Date__c+' | '+ dtl.Amount__c+'%';
termsVsdtlId1.put(dtlNew.Payment_Terms__c,dtlNew.id);
dtlToInsert.add(dtlNew); 
}
if(!dtlToInsert.isEmpty()){
List<Database.SaveResult> results = Database.insert(dtlToInsert);
} 
if(!dtlToUpdate.isEmpty()){
for(Deal_Transaction_Line__c dtlll : dtlToUpdate){
dtlll.Replacement_Deal_Transaction_Line__c =termsVsdtlId1.get(dtlll.Payment_Terms__c);
}
update dtlToUpdate;  
} */
    }
    
    public static void createDTLRecordsInvoicedAdjustment( List<DTTermsJunction__c>  dtTerm ){
        /*
Set<String> dtlImpacted = new Set<String>();
for(DTTermsJunction__c terms :dtTerm ){
dtlImpacted.add(terms.DTL_Reference_SLE__c );
}

Map<String,Deal_Transaction_Line__c> dtlInfoMap = new Map<String,Deal_Transaction_Line__c>();

List<Deal_Transaction_Line__c> dtlList = [select id , Status__c,DTL_Reference_SLE__c from Deal_Transaction_Line__c where Status__c='Active' AND Payable_Invoice__c =null AND DTL_Reference_SLE__c IN: dtlImpacted AND ff_credit_note__c =true];
for(Deal_Transaction_Line__c dtl : dtlList){
dtlInfoMap.put(dtl.DTL_Reference_SLE__c,dtl);  
}

List<Deal_Transaction_Line__c> dtlToUpsert = new List<Deal_Transaction_Line__c>();

for(DTTermsJunction__c dtl : dtTerm){  
Deal_Transaction_Line__c dtlNew =  new Deal_Transaction_Line__c();
if(dtlInfoMap.get(dtl.DTL_Reference_SLE__c)!=null){
dtlNew.id=dtlInfoMap.get(dtl.DTL_Reference_SLE__c).id;
}else{
dtlNew.Deal_Transaction__c =dtl.Deal_Transaction__c ;
}
dtlNew.Status__c =TAD_Constants.dtStatusActive;
dtlNew.Expected_Amount__c = - dtl.Invoiced_DTOLs_Cancelled__c  ;
dtlNew.Departure_Date__c =dtl.DT_Departure_Date__c  ;
dtlNew.Deal__c = dtl.DT_Deal__c ;
dtlNew.Payment_Terms__c = dtl.Merchant_Terms__c ;
dtlNew.CurrencyIsoCode = dtl.CurrencyIsoCode;
dtlNew.ff_credit_note__c=true;
dtlNew.RecordTypeId=TADUtils.getRecordTypeList('Single_Line_Expense','Deal_Transaction_Line__c');   
if(dtl.Mpt_Payment_Due__c =='Days prior to departure' ){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(-Integer.valueOf(dtl.MT_Days__c ==null?0:dtl.MT_Days__c)) ;
}else if(dtl.Mpt_Payment_Due__c =='Days after departure'){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(Integer.valueOf(dtl.MT_Days__c==null?0:dtl.MT_Days__c)) ;
}else if(dtl.Mpt_Payment_Due__c =='Date of departure'){
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c;
}else if(dtl.Mpt_Payment_Due__c=='On Confirmation' ){	
dtlNew.Transaction_Date__c =  dtl.Departure_Date_Date__c.addDays(-Integer.valueOf(dtl.MT_Days__c==null?0:dtl.MT_Days__c)) ;	
}
dtlNew.Description__c ='Credit Note - '+' | '+ dtl.Amount__c+'%';
dtlToUpsert.add(dtlNew); 

}

if(!dtlToUpsert.isEmpty()){
upsert dtlToUpsert;  
} 
*/
    }
    
    public static void rollUpDTlFieldValues( List<Deal_Transaction_Line__c>  dtlNew ){
        /*
Set<String> dtIds = new Set<String>();
for(Deal_Transaction_Line__c dtl : dtlNew){
dtIds.add(dtl.Deal_Transaction__c);
}

List<AggregateResult> aggrDTLList = [Select Deal_Transaction__c, SUM(Net_Amount__c )netAmt ,SUM(Taxable_Amount__c )taxAmt ,SUM(Tax_Free_Amount__c )taxFree FROM Deal_Transaction_Line__c where Deal_Transaction__c  IN: dtIds  GROUP BY Deal_Transaction__c ];

List<Deal_Transaction__c> dtToUpdate = new List<Deal_Transaction__c>();
for(AggregateResult agr :aggrDTLList){
Deal_Transaction__c dt = new Deal_Transaction__c();
dt.id = (Id)agr.get('Deal_Transaction__c');
dt.Net_Amount_Rollup__c  = (Decimal)agr.get('netAmt');
dt.Taxable_Amount_Rollup__c  = (Decimal)agr.get('taxAmt');
dt.Tax_Free_Amount_Rollup__c  = (Decimal)agr.get('taxFree');
dtToUpdate.add(dt);
}
update dtToUpdate;
*/
    }
    
    public static void updateDtlStatusField( List<Deal_Transaction_Line__c>  dtlNew ){
        /*
Set<Id> dtIds = new Set<Id>();
for(Deal_Transaction_Line__c dtl :dtlNew){
dtIds.add(dtl.Deal_Transaction__c);
}
Id dtlRecTypeId = Schema.SObjectType.Deal_Transaction_Line__c.getRecordTypeInfosByName().get('Sale Transaction').getRecordTypeId();

Id recTypeId = Schema.SObjectType.Deal_Transaction__c.getRecordTypeInfosByName().get('Sale Transaction').getRecordTypeId();
Map<Id,Deal_Transaction__c> dtRecord = new Map<Id,Deal_Transaction__c>([select id,Status_formula__c,RecordTypeId from Deal_Transaction__c where Id in: dtIds AND RecordTypeId = :recTypeId]);
if(dtRecord.values().size() > 0){
for(Deal_Transaction_Line__c dtl :dtlNew){
if(dtl.RecordTypeId == dtlRecTypeId)
dtl.Status__c = dtRecord.get(dtl.Deal_Transaction__c).Status_formula__c;
}
}
*/
    }
    
}