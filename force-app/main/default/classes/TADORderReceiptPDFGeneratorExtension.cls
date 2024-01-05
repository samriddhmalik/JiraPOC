public class TADORderReceiptPDFGeneratorExtension {
    
    public final TAD_Order__c  ord{get;set;}
    
    public string paidByName{get;set;}
    public string paidByEmail{get;set;}
    public string receiptNumber{get;set;}
    public Date transactionDate{get;set;}
    public string paymentMethod{get;set;}
    public Decimal originalAmount{get;set;}
    public Decimal surchargeAmount{get;set;}
    public Decimal sumOfOriginalAndSurcharge{get;set;}
    public string transactionIdentifier{get;set;}
    public string currencyCode{get;set;}
    
    public TADORderReceiptPDFGeneratorExtension(ApexPages.StandardController controller){
        
        this.ord = (TAD_Order__c)controller.getRecord();
        
        List<Payment_Transaction_POE__c> ptList = [Select Id,Name,transaction_date__c,Email__c ,currency_code__c ,transaction_idenifier__c ,amount_surcharge__c,amount_original__c,method__c, paid_by_email__c ,paid_by_name__c  from Payment_Transaction_POE__c where ordexp_tad_order__c =:ord.Id Order by CreatedDate DESC Limit 1];
        System.debug('ptList'+ptList);
        for(Payment_Transaction_POE__c pt: ptList){
            
            paidByName = pt.paid_by_name__c;
            paidByEmail = pt.paid_by_email__c;
            receiptNumber = pt.Name;
            transactionDate = pt.transaction_date__c;
            paymentMethod = pt.method__c;
            originalAmount = pt.amount_original__c;
            
            surchargeAmount = pt.amount_surcharge__c;
            if(pt.amount_surcharge__c == 0 || pt.amount_surcharge__c == null ){
                sumOfOriginalAndSurcharge = pt.amount_original__c;
                surchargeAmount = 0.00;
            }
            else{
                sumOfOriginalAndSurcharge = pt.amount_original__c + pt.amount_surcharge__c;
                surchargeAmount = pt.amount_surcharge__c;
            }
            transactionIdentifier = pt.transaction_idenifier__c;
            currencyCode = pt.currency_code__c;
        }
        
    }
}