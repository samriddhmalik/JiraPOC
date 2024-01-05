public class orderLineMappingController {
    
    public class getAllExpense {
        @AuraEnabled public boolean check{get;set;}
        @AuraEnabled public string Name{get;set;}
        @AuraEnabled public string TadOrder{get;set;}
        @AuraEnabled public string Account{get;set;}
        @AuraEnabled public integer Index{get;set;}
        @AuraEnabled public string ExpId{get;set;}
        @AuraEnabled public string deal{get;set;}
        @AuraEnabled public string depDate{get;set;}
        @AuraEnabled public decimal netvalue{get;set;}
        @AuraEnabled public List<getAllOLine> expOLList{get;set;}
        @AuraEnabled public string pinCurrency{get;set;}
        @AuraEnabled public decimal olsubtotal{get;set;}
    }
    
    public class getAllCredit {
        @AuraEnabled public boolean check{get;set;}
        @AuraEnabled public string Name{get;set;}
        @AuraEnabled public string TadOrder{get;set;}
        @AuraEnabled public string Account{get;set;}
        @AuraEnabled public integer Index{get;set;}
        @AuraEnabled public string crId{get;set;}
        @AuraEnabled public List<getAllOLine> crolList{get;set;}
    }
    
    public class getAllOLine{
        @AuraEnabled public boolean check{get;set;}
        @AuraEnabled public string Name{get;set;}
        @AuraEnabled public string oli{get;set;}
        @AuraEnabled public string Account{get;set;}
        @AuraEnabled public decimal grossCost{get;set;}
        //@AuraEnabled public decimal grossRoll{get;set;}
        @AuraEnabled public string olId{get;set;}
        @AuraEnabled public string expId{get;set;}
        @AuraEnabled public string PINID{get;set;}
        @AuraEnabled public string crId{get;set;}
        @AuraEnabled public integer Indexchild{get;set;}
        @AuraEnabled public string AccountId{get;set;}
        @AuraEnabled public string cmptype {get;set;}
        @AuraEnabled public string deal{get;set;}
        @AuraEnabled public string tadorder {get;set;}
        @AuraEnabled public string depdt{get;set;}
        @AuraEnabled public string paxQty{get;set;}
        @AuraEnabled public string curency{get;set;}
        @AuraEnabled public string status{get;set;}  
    }
    
    public class AllIdsTOMap{
        @AuraEnabled public string crId{get;set;}
        @AuraEnabled public string olId{get;set;}
        @AuraEnabled public string expId{get;set;}
        @AuraEnabled public string PINID{get;set;}
        
    }
    
    
    public class olitoDelete{
        @AuraEnabled public string olids{get;set;}
        @AuraEnabled public string PINIDs{get;set;}
        @AuraEnabled public string expId{get;set;}
    }
    
    @AuraEnabled
    public static List<getAllExpense> getExpeneLineRecords(string PINId)
    {
        system.debug('PINId:-'+ PINId );
        List<getAllExpense> ExItemList = new List<getAllExpense>();
        integer rowIndex = 1;
        List<c2g__codaPurchaseInvoiceExpenseLineItem__c> getExpLine = [SELECT Id,Departure_Date__r.name,Deal__r.name, name,c2g__NetValue__c, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__r.Id, c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE c2g__PurchaseInvoice__r.Id =:PINId ];
        
        Map<string, Map<Decimal, List<getAllOLine> > > valuesToMap = New Map<string, Map<Decimal, List<getAllOLine> > >();
        Set<String> expenseIdSet = New Set<String>();
        
        for(c2g__codaPurchaseInvoiceExpenseLineItem__c Ex: getExpLine){
            expenseIdSet.add(ex.Id);
        }
        
        if(!expenseIdSet.isEmpty()){
            valuesToMap = getrelatedOrderLines(expenseIdSet);
        }
        try
        {
            for(c2g__codaPurchaseInvoiceExpenseLineItem__c Ex: getExpLine ){
                getAllExpense pEx = new getAllExpense();
                //pEx.expOLList =  MapTogetAllOLine.get(Ex.Id);
                //pEx.olsubtotal = countofOL(Ex.Id);
                Map<Decimal,List<getAllOLine>> subtotal_OLListMap= valuesToMap.get(Ex.Id);
                
                for(Decimal Key : subtotal_OLListMap.keyset() ){
                    pEx.olsubtotal = Key;
                    pEx.expOLList = subtotal_OLListMap.get(key);
                }
                pEx.check = true;
                pEx.deal = ex.Deal__r.name;
                pEx.depDate = ex.Departure_Date__r.name;
                pEx.Name = ex.Name;
                pEx.TadOrder = ex.TAD_Order__r.Name;
                pEx.Account =  ex.c2g__GeneralLedgerAccount__r.Name;
                pEx.ExpId = ex.Id;
                pEx.pinCurrency = ex.c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name;
                pEx.netvalue = ex.c2g__NetValue__c;
                pEx.Index = rowIndex;
                
                
                
                ExItemList.add(pEx);
                rowIndex++;
            }
            return ExItemList;
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*  @AUraEnabled
public static string getCreditLineRecords(string PINId){

system.debug('PINId:-'+ PINId );
List<getAllCredit> crItemList = new List<getAllCredit>();
integer rowIndex = 0;
try
{ List<c2g__codaPurchaseInvoiceExpenseLineItem__c> getExpLine = [SELECT Id, name, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__r.Id ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE c2g__PurchaseInvoice__r.Id =:PINId ];

for(c2g__codaPurchaseInvoiceExpenseLineItem__c Ex: getExpLine ){
getAllCredit cr = new getAllCredit();
cr.CrOLList =  getrelatedOrderLines(Ex.Id);
cr.check = false;
cr.Name = ex.Name;
cr.TadOrder = ex.TAD_Order__r.Name;
cr.Account =  ex.c2g__GeneralLedgerAccount__r.Name;
cr.Index = rowIndex;
crItemList.add(cr);
rowIndex++;
}
return json.serialize(crItemList);
}
catch (exception e){
throw new AuraHandledException(e.getMessage());
}

}
*/
    //@AuraEnabled 
    /*  public static integer  countofOL(string ExpOrCrID){

integer countOL = 0;


Map< ID, string> PINacc = new Map<ID, string>();
Map<Id,string> MapDeal =  new Map<Id , string>();
map<Id,string> MapDepDt = new map<ID, string>();
map<Id,string> MapOrder = new map<Id,string>();


//for Payable Invoice Expense Line Item
List<c2g__codaPurchaseInvoiceExpenseLineItem__c> EXPList = [SELECT Id, Name,CurrencyIsoCode, c2g__GeneralLedgerAccount__c, c2g__GeneralLedgerAccount__r.name, Deal__c,Deal__r.name, Departure_Date__c, Departure_Date__r.name, TAD_Order__c,TAD_Order__r.name, c2g__PurchaseInvoice__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Deal__r.name, c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.c2g__Account__r.name, c2g__PurchaseInvoice__r.TAD_Order__c, c2g__PurchaseInvoice__r.TAD_Order__r.name, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.Departure_Date__r.name FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE Id =:ExpOrCrID LIMIT 1 ]; 

if(!EXPList.isEmpty() && EXPList.size()>0 ){
for(c2g__codaPurchaseInvoiceExpenseLineItem__c ex: EXPList)
{


if(ex.c2g__PurchaseInvoice__r.c2g__Account__c != null){
PINacc.put(ex.c2g__PurchaseInvoice__r.c2g__Account__c, ex.c2g__PurchaseInvoice__r.c2g__Account__r.name);
}

if(ex.TAD_Order__c!=null){
MapOrder.put(ex.TAD_Order__c,ex.TAD_Order__r.name);
}else if(ex.c2g__PurchaseInvoice__r.TAD_Order__c!=null){
MapOrder.put(ex.c2g__PurchaseInvoice__r.TAD_Order__c,ex.c2g__PurchaseInvoice__r.TAD_Order__r.name);
}

if(MapOrder.isEmpty()){

if(ex.Deal__c!=null){
MapDeal.put(ex.Deal__c, ex.Deal__r.name);
}else if(ex.c2g__PurchaseInvoice__r.Deal__c !=null){

MapDeal.put(ex.c2g__PurchaseInvoice__r.Deal__c, ex.c2g__PurchaseInvoice__r.Deal__r.name);

}

if(ex.Departure_Date__c!=null){
MapDepDt.put(ex.Departure_Date__c, ex.Departure_Date__r.name);
}else if(ex.c2g__PurchaseInvoice__r.Departure_Date__c!=null){
MapDepDt.put(ex.c2g__PurchaseInvoice__r.Departure_Date__c, ex.c2g__PurchaseInvoice__r.Departure_Date__r.name);                
}

}
}

if(MapOrder.isEmpty()){

//List<order_line_POE__c> expOlList = [SELECT Id,Status__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.name, Deal__c,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,TAD_Order__c,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c from Invoice_Line_Mapping__r) FROM order_line_POE__c WHERE(mp_merchant__c in:PINacc.keyset()) AND Deal__c IN:MapDeal.keyset() AND Order_Line_Item__r.ordexp_departure_date__c IN: MapDepDt.keyset()];
for(order_line_POE__c ol: [SELECT Id,Status__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.name, Deal__c,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,TAD_Order__c,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__r.Id from Invoice_Line_Mapping__r) FROM order_line_POE__c WHERE(mp_merchant__c in:PINacc.keyset()) AND Deal__c IN:MapDeal.keyset() AND Order_Line_Item__r.ordexp_departure_date__c IN: MapDepDt.keyset()] )
{



if(ol.Invoice_Line_Mapping__r.size()>0){

for(Invoice_Line_Mapping__c ILM : ol.Invoice_Line_Mapping__r ){
if(ILM.Payable_Invoice_Expense_Line_Item__r.Id == ExpOrCrID  ){
countOl++;
}
}
}


}            

}else{
List<order_line_POE__c> expOlList = [SELECT Id,Status__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.name, Deal__c,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,TAD_Order__c,TAD_Order__r.name,Quantity__c, (select ID, name from Invoice_Line_Mapping__r) FROM order_line_POE__c WHERE(mp_merchant__c in:PINacc.keyset()) AND TAD_Order__c IN:MapOrder.keyset()];

for(order_line_POE__c ol:  [SELECT Id,Status__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.name, Deal__c,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,TAD_Order__c,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__r.Id from Invoice_Line_Mapping__r) FROM order_line_POE__c WHERE(mp_merchant__c in:PINacc.keyset()) AND TAD_Order__c IN:MapOrder.keyset()] )
{


if(ol.Invoice_Line_Mapping__r.size()>0){

for(Invoice_Line_Mapping__c ILM : ol.Invoice_Line_Mapping__r ){
if( ILM.Payable_Invoice_Expense_Line_Item__r.Id == ExpOrCrID  ){
countOl++;
}
}
}  
}            
}            
}


try 
{  
system.debug(countOL);
return countOL;

}catch (exception e){
throw new AuraHandledException(e.getMessage());
}      


}*/
    
    //@AuraEnabled
    public static Map<string, Map<Decimal, List<orderLineMappingController.getAllOLine> > > getrelatedOrderLines(Set<String> expenseIdSet){
        system.debug('getrelatedOrderLines Called with expenseIdSet:-  '+expenseIdSet);
        Map<string, Map<Decimal, List<getAllOLine> > > valuesToMap = new Map<string, Map<Decimal, List<getAllOLine> > >();
        
        
        
        Map<ID, string> expenseKeyMap = new Map<ID, string>();
        Map<string, string>expenseKeyKeyMap= New Map<string, string>();
        Map<string, List<order_line_POE__c>> OLKeyMap = New Map<string, List<order_line_POE__c>>();
        
        //for Payable Invoice Expense Line Item
        List<c2g__codaPurchaseInvoiceExpenseLineItem__c> EXPList =[SELECT Id,Unique_Key_for_Mapping__c, Name,CurrencyIsoCode, c2g__GeneralLedgerAccount__c, c2g__GeneralLedgerAccount__r.name, Deal__c,Deal__r.name, Departure_Date__c, Departure_Date__r.name, TAD_Order__c,TAD_Order__r.name, c2g__PurchaseInvoice__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Deal__r.name, c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.c2g__Account__r.name, c2g__PurchaseInvoice__r.TAD_Order__c, c2g__PurchaseInvoice__r.TAD_Order__r.name, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.Departure_Date__r.name FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE Id IN : expenseIdSet] ; 
        
        
        for(c2g__codaPurchaseInvoiceExpenseLineItem__c ex: EXPList)
        {
            if(ex.id != null ){    
                
                expenseKeyMap.put(ex.Id, ex.Unique_Key_for_Mapping__c);
                expenseKeyKeyMap.put(ex.Unique_Key_for_Mapping__c, ex.Unique_Key_for_Mapping__c );
                
                system.debug('expenseKeyMap :-  '+expenseKeyMap );
                system.debug('expenseKeyKeyMap :-  '+expenseKeyKeyMap );
            }
        }
        
        
        Map<Id,order_line_POE__c > AllOlMap = new Map<Id,order_line_POE__c>([SELECT Id,Status__c,Unique_Key_for_Order_Mapping__c,Unique_Key_for_DealDD_Mapping__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.Id,mp_merchant__r.name, Deal__c,Deal__r.Id,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_departure_date__r.id,TAD_Order__c,TAD_Order__r.id,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__r.Id from Invoice_Line_Mapping__r) FROM order_line_POE__c WHERE (Unique_Key_for_DealDD_Mapping__c IN: expenseKeyMap.values()  OR Unique_Key_for_Order_Mapping__c IN: expenseKeyMap.values()) AND Status__c!='Cancelled' ]);
        
        List<order_line_POE__c> AllOList =AllOlMap.values() ;
        
        system.debug('AllOList Size:-  '+ AllOList.size());
        
        List<getAllOLine> wrapperOLList = new List<getAllOLine>();
        
        for(order_line_POE__c ordLine: AllOList ){
            
            
            If(!OLKeyMap.containskey(ordLine.Unique_Key_for_Order_Mapping__c) ){
                List<order_line_POE__c> InitialOlList= new List<order_line_POE__c> ();
                InitialOlList.add(ordLine);                
                OLKeyMap.put(ordLine.Unique_Key_for_Order_Mapping__c,InitialOlList);
                
            }else{
                List<order_line_POE__c> OlList1=OLKeyMap.get(ordLine.Unique_Key_for_Order_Mapping__c);
                OlList1.add(ordLine);
                OLKeyMap.Put(ordLine.Unique_Key_for_Order_Mapping__c,OlList1);
            }
            
            If(!OLKeyMap.containskey(ordLine.Unique_Key_for_DealDD_Mapping__c) ){
                List<order_line_POE__c> InitialOlList= new List<order_line_POE__c> ();
                InitialOlList.add(ordLine);                
                OLKeyMap.put(ordLine.Unique_Key_for_DealDD_Mapping__c,InitialOlList); 
                
            }else{
                List<order_line_POE__c> OlList2=OLKeyMap.get(ordLine.Unique_Key_for_DealDD_Mapping__c);
                OlList2.add(ordLine);
                OLKeyMap.Put(ordLine.Unique_Key_for_DealDD_Mapping__c,OlList2);
            }
        }
        
        
        
        for(c2g__codaPurchaseInvoiceExpenseLineItem__c exp : EXPList)
        {	
            Map<Decimal, List<getAllOLine>> Subtotal_OlListMap = new  Map<Decimal, List<getAllOLine>>();
            Decimal subtotal =0.00;
            integer INDEX = 0;
            List<getAllOLine> olList = new List<getAllOLine>();  
            If(OLKeyMap.containskey(exp.Unique_Key_for_Mapping__c))
            {
                List<order_line_POE__c> OlListToMap = OLKeyMap.get(exp.Unique_Key_for_Mapping__c);   
                if(!OlListToMap.isEmpty())
                {
                    for(order_line_POE__c ol: OlListToMap ){
                        
                        getAllOLine OLtoShow = new getAllOLine();
                        OLtoShow.grossCost = ol.Gross_Cost__c;
                        OLtoShow.Name = ol.Name;
                        OLtoShow.oli = ol.Order_Line_Item__r.name;
                        OLtoShow.AccountId = ol.mp_merchant__c;
                        OLtoShow.Account = ol.mp_merchant__r.name;
                        OLtoShow.olId= ol.Id;
                        OLtoShow.cmptype= ol.Component__r.name;
                        OLtoShow.deal= ol.Deal__r.name;
                        OLtoShow.tadorder= ol.TAD_Order__r.name;
                        OLtoShow.depdt= ol.departures_dates__r.name;
                        OLtoShow.paxQty= ol.Quantity__c;
                        OLtoShow.expId =exp.Id;
                        OLtoShow.curency=ol.CurrencyIsoCode;
                        OLtoShow.status = ol.Status__c;
                        OLtoShow.PINID =exp.c2g__PurchaseInvoice__r.Id;  
                        OLtoShow.Indexchild = INDEX;
                        OLtoShow.check = false;
                        
                        if(ol.Invoice_Line_Mapping__r.size()>0){
                            
                            for(Invoice_Line_Mapping__c ILM : ol.Invoice_Line_Mapping__r ){
                                if( ILM.Payable_Invoice_Expense_Line_Item__r.Id == exp.Id  ){
                                    OLtoShow.check = true;
                                    subtotal = subtotal + ol.Gross_Cost__c;
                                }
                            }
                        }
                        olList.add(OLtoShow);
                        INDEX++;
                    }
                }
            }
            Subtotal_OlListMap.put(subtotal, olList);
            valuesToMap.put(exp.Id, Subtotal_OlListMap);
        }
        
        try 
        {  
            
            system.debug(valuesToMap);
            return valuesToMap;
            
        }catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }    
    }
    
    
    @AuraEnabled
    public static void CreateEXPInvoiceMapping(List<AllIdsTOMap> idsToMap ){
        
        List<Invoice_Line_Mapping__c> ILMtoInsert = new List<Invoice_Line_Mapping__c>();
        List<string>expid= new List<string>();
        List<string> PINID = new List<string>();
        List<string>olId = new List<String>();
        
        
        if(!idsToMap.isEmpty() && idsToMap.size()>0)
        {
            
            for(AllIdsTOMap ids : idsToMap){
                Invoice_Line_Mapping__c ILM = new Invoice_Line_Mapping__c();
                ILM.Payable_Invoice_Expense_Line_Item__c =ids.expId;
                ILM.Payable_Invoice__c = ids.PINID;
                ILM.Order_Line__c = ids.olId;
                ILMtoInsert.add(ILM);
                
                
                expid.add(ids.expId);
                PINID.add(ids.PINID);
                olId.add(ids.olId);                
                
            }
        }
        List<Invoice_Line_Mapping__c> existingList =[select Id,name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice__c,Order_Line__c from Invoice_Line_Mapping__c where Payable_Invoice__c IN : PINID AND Payable_Invoice_Expense_Line_Item__c IN: expId AND Order_Line__c IN :olId ];  
        system.debug('existingList:- '+existingList);
        
        try{
            Delete existingList;
            insert ILMtoInsert;
            system.debug('ILMtoInsert:- '+ILMtoInsert);
        }
        catch(exception ex){
            system.debug('Exception OrderLineInsert:- '+ex.getMessage());
            throw new AuraHandledException('Error in OrderLine');
        }
    }
    
    /* @AuraEnabled
public static void CreateCrInvoiceMapping(List<AllIdsTOMap> idsToMap  ){

List<Invoice_Line_Mapping__c> ILMtoInsert = new List<Invoice_Line_Mapping__c>();

if(!idsToMap.isEmpty() && idsToMap.size()>0)
{
for(AllIdsTOMap ids : idsToMap){         
Invoice_Line_Mapping__c ILM = new Invoice_Line_Mapping__c();
ILM.Payable_Credit_Note_Expense_Line_Item__c =ids.crId;
ILM.Payable_Invoice__c = ids.PINID;
ILM.Order_Line__c = ids.olId;
ILMtoInsert.add(ILM);
}
try{
insert ILMtoInsert;
system.debug('ILMtoInsert:- '+ILMtoInsert);
}
catch(exception ex){
system.debug('Exception OrderLineInsert:- '+ex.getMessage());
throw new AuraHandledException('Error in OrderLine');
}
}
}*/
    
    @Auraenabled
    public static void DeleteMappingRecord(List<olitoDelete> olIdsToDelete){
        
        system.debug('DeleteMappingRecord:-'+olIdsToDelete);
        List<string> deleteOlId = new List<string>();
        List<string> deletePINID = new List<string>();
        List<string> deleteExpId = new List<string>();
        //deleteOlId.addAll(olIdsToDelete.olids);
        for(olitoDelete olid : olIdsToDelete)
        {
            deleteOlId.add(olid.olids);
            deletePINID.add(olid.PINIDs);
            deleteExpId.add(olid.expId);
        }
        
        List<Invoice_Line_Mapping__c> invoiceMappingtoDelete = [select Id, name, Payable_Credit_Note_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__c from Invoice_Line_Mapping__c where (Order_Line__c IN : deleteOlId) AND(Payable_Invoice__c IN : deletePINID) AND (Payable_Invoice_Expense_Line_Item__c IN:deleteExpId )];
        
        system.debug('invoiceMappingtoDelete:- '+invoiceMappingtoDelete);
        
        if(!invoiceMappingtoDelete.isEmpty() && invoiceMappingtoDelete.size()>0)
        {
            
            delete invoiceMappingtoDelete;
            system.debug('DeleteMappingRecord:- ');
            
        }
    }
}