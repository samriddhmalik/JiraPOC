public class RefundNoCancellationsController {

    public class initWrapper{
        @AuraEnabled public Boolean isValidUser {get;set;}
        @AuraEnabled public Double totalPrice {get;set;}
        @AuraEnabled public Double totalPaymentReceived {get;set;}
        @AuraEnabled public Double totalCouponAmount {get;set;}
        @AuraEnabled public Double totalAmountOutstanding {get;set;}
        @AuraEnabled public List<OLIData> OLIData {get;set;}
        @AuraEnabled public List<AddOnData> AddOnData {get;set;}
        @AuraEnabled public List<String> olisAndAddOns {get;set;}
        @AuraEnabled public finalWrapper finalWrapper {get;set;}
    }
    
    public class OLIData{
        @AuraEnabled public string recordId;
        @AuraEnabled public string recordName;
    }
    
    public class AddOnData{
        @AuraEnabled public string recordId;
        @AuraEnabled public string recordName;
    }
    
    public class finalWrapper{
        @AuraEnabled public string addOnOrOLI {get;set;}
        @AuraEnabled public Double refundAmount {get;set;}
        @AuraEnabled public string recordId {get;set;}
        @AuraEnabled public string tadOrderId {get;set;}
        @AuraEnabled public string couponOrRefund {get;set;}
        @AuraEnabled public string reasonOfRefund {get;set;}
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname){
        
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry pv : picklistValues) {
            if(pv.label!='Internal - Offload'){
            optionlist.add(pv.getLabel());
            }
        }
        system.debug('optionlist--->'+optionlist);
        
        return optionlist;
        
    } 
    @AuraEnabled
    public static initWrapper verifyUser(String userId, String tadOrderId){
        
        List<String> listOfStatuses = new List<String>{'Secured', 'Active'};
        initWrapper initWrapperInstance = new initWrapper();
        system.debug('tadOrderId --> '+tadOrderId);
        
        finalWrapper finalWrapperInstance = new finalWrapper();
        finalWrapperInstance.addOnOrOLI = '';
        finalWrapperInstance.refundAmount = 0.00;
        finalWrapperInstance.recordId = '';
        finalWrapperInstance.tadOrderId = tadOrderId;
        finalWrapperInstance.couponOrRefund = '';
        finalWrapperInstance.reasonOfRefund = 'Deal Price Incorrect';
        
        initWrapperInstance.finalWrapper = finalWrapperInstance;
        
		User userDetails = [Select Profile.Name, UserRole.Name FROM User where Id =: userId];        
        if(userDetails.Profile.Name == 'System Administrator' || userDetails.UserRole.Name == 'Customer Service Manager' || userDetails.UserRole.Name == 'Accounts Officer'){
            system.debug('Entered if');
            initWrapperInstance.isValidUser = true;
            TAD_Order__c order = [Select id, Name, ordexp_total_price__c,ordexp_amount_outstanding__c, ordexp_total_payment_rollup__c, Total_Coupon_Amount__c from TAD_Order__c where id =:tadOrderId]; 
            initWrapperInstance.totalPrice = order.ordexp_total_price__c;
            initWrapperInstance.totalPaymentReceived = order.ordexp_total_payment_rollup__c;
            initWrapperInstance.totalCouponAmount = order.Total_Coupon_Amount__c;
            initWrapperInstance.totalAmountOutstanding = order.ordexp_amount_outstanding__c;
            List<Order_Line_Item__c> listOfOLI = [Select id, Name, ordexp_oli_name__c, OLI_Status__c, ordexp_TAD_Order__c  from Order_Line_Item__c where OLI_Status__c in: listOfStatuses AND ordexp_TAD_Order__c =:tadOrderId];       
            List<OLIData> oliDataList = new List<OLIData>();    
            List<String> oliAndAddons = new List<String>();
            if(!listOfOLI.isEmpty()){            
                for(Order_Line_Item__c oli : listOfOLI){
                  
                    OLIData OLIDataInstance = new OLIData();
                    OLIDataInstance.recordId = oli.Id;
                    OLIDataInstance.recordName = oli.ordexp_oli_name__c.split('>')[1].split('<')[0];
                    oliDataList.add(OLIDataInstance);
                }
                initWrapperInstance.OLIData = oliDataList;
                oliAndAddons.add('OLI');
            }
            
            List<AddOn__c> listOfAddon = [Select id, Name,ordexp_AddOn_Name__c, AddOn_Status__c, Order_Line_Item__c from AddOn__c where AddOn_Status__c in: listOfStatuses AND Order_Line_Item__r.ordexp_TAD_Order__c =:tadOrderId];
            List<AddOnData> AddOnDataList = new List<AddOnData>();
            System.debug('listOfAddon'+listOfAddon.size());
            if(!listOfAddon.isEmpty()){            
                for(AddOn__c addOn : listOfAddon){
                  
                    AddOnData AddOnDataInstance = new AddOnData();
                    AddOnDataInstance.recordId = addOn.Id;
                    AddOnDataInstance.recordName = addOn.ordexp_AddOn_Name__c.split('>')[1].split('<')[0];
                    AddOnDataList.add(AddOnDataInstance);
                }
                initWrapperInstance.AddOnData = AddOnDataList;
                oliAndAddons.add('AddOn');
            }
            initWrapperInstance.olisAndAddOns = oliAndAddons;
            
        }else{
            initWrapperInstance.isValidUser = false;
        }
        
        return initWrapperInstance;
    }
    
    @AuraEnabled
    public static void saveCancellationRecord(finalWrapper finalWrap){
        
        system.debug('finalWrap ==> '+finalWrap);
        Cancellation_Refund_POE__c cancellation = new Cancellation_Refund_POE__c ();
        cancellation.Refund_Reason__c = finalWrap.reasonOfRefund;
        cancellation.Cancellation_Type__c = 'Refund No Cancellation';
        cancellation.ordexp_tad_order__c = finalWrap.tadOrderId;
        cancellation.Approval_Status__c='Pending Finance Approval';
        cancellation.Type__c='Refund Required';
        if(finalWrap.couponOrRefund == 'Refund'){
            cancellation.Refund_Amount__c = finalWrap.refundAmount; 
        }
        
        if(finalWrap.couponOrRefund == 'Coupon'){
            cancellation.Coupon_Amount__c = finalWrap.refundAmount; 
        }
        
        cancellation.Linked_to_OLI_AddOn__c = finalWrap.addOnOrOLI;       
        cancellation.OLI_AddOn_Id__c = finalWrap.recordId;
        insert cancellation;
    }
    
}