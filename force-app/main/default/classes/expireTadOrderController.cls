public class expireTadOrderController {
    
    public class recordDataWrapper{
        @AuraEnabled  public double outstanding {get;set;}
        @AuraEnabled  public double price {get;set;}
        @AuraEnabled  public String name {get;set;}
        
    }
    
    @AuraEnabled
    public static recordDataWrapper getOrder (String recId){ 
        List<TAD_Order__c> tadRec = [Select id,Name,ordexp_total_payment_rollup__c,ordexp_amount_outstanding__c,ordexp_total_price__c  from TAD_Order__c  where id=:recId and ordexp_total_payment_received__c =0 and Total_Order_OLI_Coupon__c =0];
        recordDataWrapper rw=new recordDataWrapper();
        if(!tadRec.isEmpty()){
            rw.outstanding=tadRec[0].ordexp_amount_outstanding__c;
            rw.Name=tadRec[0].Name;
            rw.price=tadRec[0].ordexp_total_price__c;
        }
        return rw;
        
    }
    
    @AuraEnabled
    public static void expireOrder (String recId){ 
        TAD_Order__c tadRec = new TAD_Order__c(id=recId);
        tadRec.ordexp_master_status__c='Cancelled';
        tadRec.ordexp_sub_status__c='Expired/Time out';
        tadRec.ordexp_Order_Cancelled__c=true;
        tadRec.Order_Cancelled_On__c=date.today();
        
        update tadRec;
    }
    
}