public class payableInvoiceTriggerHandler {
	@future
    public static void createInvoiceLineMapping(list<string> pinList){
        
        list<string> pinId = new list<string>();
        list<string> expId = new list<string>();
        list<string> olId = new list<string>();
        list<string> uniqKey = new list<string>();
        List<Invoice_Line_Mapping__c> ILMtoInsert = new List<Invoice_Line_Mapping__c>();
        
        /*for(c2g__codaPurchaseInvoice__c pin:pinList){
            pinId.add(pin.id);
        }*/
        
        list<c2g__codaPurchaseInvoiceExpenseLineItem__c> expList = [SELECT Id,Unique_Key_for_Mapping__c, Name,CurrencyIsoCode, Deal__c,Deal__r.name, Departure_Date__c, Departure_Date__r.name, TAD_Order__c,TAD_Order__r.name, c2g__PurchaseInvoice__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Deal__r.name, c2g__PurchaseInvoice__r.TAD_Order__r.name FROM c2g__codaPurchaseInvoiceExpenseLineItem__c where c2g__PurchaseInvoice__c In :pinList];
        system.debug('expList '+expList);
        for(c2g__codaPurchaseInvoiceExpenseLineItem__c exp:expList){
			expId.add(exp.id);
			uniqKey.add(exp.Unique_Key_for_Mapping__c);       
        }
        system.debug('uniqKey '+uniqKey);
        list<order_line_POE__c> olList = [Select id, name, tad_order__c, tad_order__r.name, Unique_Key_for_Order_Mapping__c, Unique_Key_for_DealDD_Mapping__c, status__c from order_line_POE__c where  (Unique_Key_for_DealDD_Mapping__c IN: uniqKey  OR Unique_Key_for_Order_Mapping__c IN: uniqKey) AND Status__c!='Cancelled'];
        system.debug('uniqKey '+olList);
        for(order_line_POE__c ol2:olList){
            olId.add(ol2.id);
        }
        if(!olList.isEmpty()){
            for(c2g__codaPurchaseInvoiceExpenseLineItem__c exp1:expList){
                for(order_line_POE__c ol:olList){
                    if((ol.Unique_Key_for_DealDD_Mapping__c==exp1.Unique_Key_for_Mapping__c || ol.Unique_Key_for_Order_Mapping__c== exp1.Unique_Key_for_Mapping__c)){
                        Invoice_Line_Mapping__c ILM = new Invoice_Line_Mapping__c();
                        ILM.Payable_Invoice_Expense_Line_Item__c =exp1.id;
                		ILM.Payable_Invoice__c = exp1.c2g__PurchaseInvoice__c;
                		ILM.Order_Line__c = ol.id;
                        ILMtoInsert.add(ILM);
                    }
                }
            }
        }
        List<Invoice_Line_Mapping__c> existingList =[select Id,name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice__c,Order_Line__c from Invoice_Line_Mapping__c where Payable_Invoice__c IN : pinId AND Payable_Invoice_Expense_Line_Item__c IN: expId AND Order_Line__c IN :olId ];  
        system.debug('existingList:- '+existingList);
        
        try{
            Delete existingList;
            insert ILMtoInsert;
            system.debug('ILMtoInsert:- '+ILMtoInsert);
        }catch(exception ex){
            system.debug('Exception Occurred '+ex.getMessage());
        }
    }
}