public class orderCancellationFormController {
    
    public class recordDataWrapper{
        @AuraEnabled  public Id Id {get;set;}
        @AuraEnabled  public Id oliId {get;set;}
        @AuraEnabled  public Boolean check {get;set;}
        @AuraEnabled  public String level {get;set;}
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public Decimal price {get;set;}
        @AuraEnabled  public String oliAddonStatus {get;set;}
        @AuraEnabled  public String status {get;set;}
        @AuraEnabled  public String refundReason {get;set;}
        @AuraEnabled  public Decimal refund {get;set;}
        @AuraEnabled  public Decimal credit {get;set;}
        @AuraEnabled  public Decimal coupon {get;set;}
        @AuraEnabled  public String approvalStage {get;set;}
        @AuraEnabled  public String paxName {get;set;}
    }
    
    public class ApprovalHistoryWrapper{
        @AuraEnabled  public String approvalName {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public string canRefId {get;set;}
        @AuraEnabled  public string refundReason {get;set;}
        @AuraEnabled  public string cancellationStatus {get;set;}
        @AuraEnabled  public Boolean sendCouponButton {get;set;}
        @AuraEnabled  public List<recordDataWrapper> oliAddonData {get;set;}
    }
    
    public class minNotMetCheckData{
        @AuraEnabled  public String minMetState {get;set;}
        @AuraEnabled  public List<String> minNotMetOptions {get;set;}
        @AuraEnabled  public Set<string> refundOptions {get;set;}
        @AuraEnabled  public Boolean enableSendCouponButton {get;set;}
        @AuraEnabled  public List<recordDataWrapper > oliToDelete {get;set;}
    }
    public class OliAmountData{
        public Decimal creditAmount {get;set;}
        public Decimal couponAmount {get;set;}
        public Decimal refundAmount {get;set;}
    }
    // This method verifies Initial order status 
    @AuraEnabled
    public static minNotMetCheckData verifyMinNotMetApprovalStatus (String recId){ 
        
        minNotMetCheckData minData = new minNotMetCheckData();
        Set<string> refundOptions = new Set<string>();
        
        TAD_Order__c tadRec = [Select id,(Select id,name,orderxp_total_amount__c,OLI_Status__c from Order_Line_Items_orders__r where (OLI_Status__c='Secured' OR OLI_Status__c='Active')  ),FF_status_Batch__c,ordexp_departure_date__r.ordexp_Options_availbale_to_customers__c,ordexp_total_payment_received__c, ordexp_departure_date__r.MinNotMetApproval__c,ordexp_master_status__c   from TAD_Order__c  where id=:recId];
        List<order_line_item__c> oliHoldOnes = [Select id,name,orderxp_total_amount__c,OLI_Status__c, (Select Id,Order_Line_Item__c, Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Refund_Status__c,Passenger__r.ordexp_PAX_Nickname__c from AddOns__r where AddOn_Status__c='On Hold')   from order_line_item__c where OLI_Status__c='On Hold' AND ordexp_TAD_Order__c =: tadRec.id ];
        List<AddOn__c> addonList=[Select Id,Order_Line_Item__c, order_line_item__r.Name,Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Refund_Status__c,Passenger__r.ordexp_PAX_Nickname__c from AddOn__c where AddOn_Status__c='On Hold' and order_line_item__r.ordexp_TAD_Order__c=: recId and order_line_item__r.OLI_Status__c!='On Hold'];
        
        Boolean hasPermission = FeatureManagement.checkPermission('Feature_Access_Delete_OLI'); 
        
        if(tadRec.ordexp_master_status__c=='On Hold' && hasPermission==true ){
            minData.minMetState = 'On Hold'; 
            if(tadRec.Order_Line_Items_orders__r.size()!=0){
                minData.minMetState = 'Proceed Cancellation';  
            }
            List<recordDataWrapper> wrapList = new List<recordDataWrapper>();
            for( order_line_item__c oliRec :oliHoldOnes){
                recordDataWrapper data = new recordDataWrapper();
                data.check = false;
                data.Id=oliRec.id;
                data.oliId=oliRec.id;
                data.level='OLI';
                data.name=oliRec.Name;
                data.price=oliRec.orderxp_total_amount__c;
                data.oliAddonStatus=oliRec.OLI_Status__c;
                wrapList.add(data);
                system.debug('addonr'+oliRec.AddOns__r);
                  for(AddOn__c add : oliRec.AddOns__r){
                    recordDataWrapper data1 = new recordDataWrapper();
                    data1.Id=add.id;
                    data1.oliId=add.Order_Line_Item__c;
                    data1.level='AddOn';
                    data1.name=add.Name +'-'+add.RecordType.Name;
                    data1.price=add.ordexp_amount__c;
                    data1.oliAddonStatus=add.AddOn_Status__c;
                    data1.paxName = add.Passenger__r.ordexp_PAX_Nickname__c;
                    data1.check=false;
                   system.debug('Data173'+data1);
                    wrapList.add(data1);   
                }
                
            }
          
              for(AddOn__c add : addonList){
                    recordDataWrapper data1 = new recordDataWrapper();
                    data1.Id=add.id;
                    data1.oliId=add.Order_Line_Item__c;
                    data1.level='AddOn';
                    data1.name=add.Name +'-'+add.RecordType.Name+'|'+add.order_line_item__r.Name;
                    data1.price=add.ordexp_amount__c;
                    data1.oliAddonStatus=add.AddOn_Status__c;
                    data1.paxName = add.Passenger__r.ordexp_PAX_Nickname__c;
                    data1.check=false;
                   system.debug('Data173'+data1);
                    wrapList.add(data1);   
                }
            minData.oliToDelete=wrapList;
        }
        else if(tadRec.ordexp_master_status__c=='Cancelled'){
            minData.minMetState = 'MinCancelled';
            if(tadRec.ordexp_departure_date__r.MinNotMetApproval__c=='Processed'){
                minData.enableSendCouponButton = true;
            }else{
                minData.enableSendCouponButton = false;
            }
            
        } 
        else if(tadRec.ordexp_departure_date__r.MinNotMetApproval__c=='Rejected'){
            minData.minMetState = 'Not Required'; 
        }
        else if(tadRec.ordexp_departure_date__r.MinNotMetApproval__c=='In Progress'){
            minData.minMetState = 'Initiated'; 
        }
        else if(tadRec.ordexp_departure_date__r.MinNotMetApproval__c=='Not Required'||tadRec.ordexp_departure_date__r.MinNotMetApproval__c==''||tadRec.ordexp_departure_date__r.MinNotMetApproval__c==null){
            minData.minMetState = 'Not Required'; 
        }
        else if(tadRec.ordexp_departure_date__r.MinNotMetApproval__c=='Processed'){
            minData.minMetState = 'Processed';
            String []  minOptions;
            if(tadRec.ordexp_departure_date__r.ordexp_Options_availbale_to_customers__c!=null){
                minOptions = tadRec.ordexp_departure_date__r.ordexp_Options_availbale_to_customers__c.split(';');
                for(String op :minOptions){
                    if(op.contains('Credit') || op.contains('deal')||op.contains('Deal') ){
                        refundOptions.add('Full Credit');
                        refundOptions.add('Partial Credit');
                    }
                    if(op.contains('Refund')){
                        refundOptions.add('Full Refund');
                        refundOptions.add('Partial Refund');  
                    }
                    if(op.contains('Coupon')){
                        refundOptions.add('Full Coupon');
                        refundOptions.add('Partial Coupon'); 
                    }
                }   
            }
            minData.refundOptions=refundOptions;
            minData.minNotMetOptions=minOptions;
        }
        
        return minData;  
    }
    
    // This method gets records required for re-approval 
    @AuraEnabled
    public static List<recordDataWrapper> fetchReordDataApexApproval (String recId){
        
        String recIdsubstring = recId.substring(0,15);
        
        List<recordDataWrapper> wrap = new List<recordDataWrapper>();
        Set <String> approvalStatus = new Set<string>();
        approvalStatus.add('Pending Documentation');
        approvalStatus.add('CS Rejected');
        approvalStatus.add('Finance Rejected');
        
        List<order_line_item__c> olitems = [Select Id ,ordexp_approval_status__c,Refund_Amount__c,Coupon_Amount__c,OLI_Credit_Amount__c, Name, ordexp_suboption_amount__c,Total_surcharge__c,HSS_Amount__c,ordexp_city_surcharge_amount__c,Cancellation_Amount__c,Refund_Status__c,Refund_Reason__c,OLI_Status__c
                                            from order_line_item__c where ordexp_TAD_Order__c =: recId AND ordexp_approval_status__c IN:approvalStatus];
        
        List<AddOn__c> addOnsItems = [Select Id,Refund_Reason__c,Addon_Refund_Amount__c,Addon_Coupon_Amount__c, Addon_Credit_Amount__c,ordexp_approval_status__c,Order_Line_Item__c,Cancellation_Amount__c,TAD_Order_Id__c, Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Refund_Status__c from AddOn__c where TAD_Order_Id__c=:recIdsubstring AND ordexp_approval_status__c IN:approvalStatus];
        
        List<Order_Customisations_POE__c> customisationItems = [Select Id, Type__c, Status__c, Refund_Reason__c, ordexp_approval_status__c, Order_Line_Item__c, Cancellation_Amount__c, mp_tad_order__c, Name, RecordType.Name, Refund_Status__c, Total_price__c from Order_Customisations_POE__c where mp_tad_order__c=:recIdsubstring AND ordexp_approval_status__c IN:approvalStatus and Status__c != 'Declined'];
        
        
        
        for(order_line_item__c oli : olitems){
            recordDataWrapper data = new recordDataWrapper();
            if(oli.ordexp_approval_status__c=='CS Rejected' || oli.ordexp_approval_status__c=='Finance Rejected'){
                data.check=true;   
            }else{
                data.check=false; 
            }
            data.Id=oli.id;
            data.level='OLI';
            data.name=oli.Name;
            data.price=oli.ordexp_suboption_amount__c+oli.Total_surcharge__c+ oli.HSS_Amount__c +oli.ordexp_city_surcharge_amount__c;
            data.oliAddonStatus=oli.OLI_Status__c;
            data.refundReason=oli.Refund_Reason__c;
            data.status=oli.Refund_Status__c;
            data.refund=oli.Refund_Amount__c;
            data.coupon = oli.Coupon_Amount__c;
            data.credit = oli.OLI_Credit_Amount__c;
            data.approvalStage=oli.ordexp_approval_status__c;
            wrap.add(data);
        } 
        for(AddOn__c add : addOnsItems){
            recordDataWrapper data1 = new recordDataWrapper();
            if(add.ordexp_approval_status__c=='CS Rejected' || add.ordexp_approval_status__c=='Finance Rejected'){
                data1.check=true;   
            }else{
                data1.check=false; 
            } 
            data1.Id=add.id;
            data1.level='AddOn';
            data1.oliId=add.Order_Line_Item__c;
            data1.name=add.Name +'-'+add.RecordType.Name;
            data1.price=add.ordexp_amount__c;
            data1.oliAddonStatus=add.AddOn_Status__c;
            data1.refundReason=add.Refund_Reason__c;
            data1.status=add.Refund_Status__c;
            data1.refund=add.Addon_Refund_Amount__c;
            data1.coupon = add.Addon_Coupon_Amount__c;
            data1.credit = add.Addon_Credit_Amount__c;
            data1.approvalStage=add.ordexp_approval_status__c;
            wrap.add(data1);   
        } 
        for(Order_Customisations_POE__c oc : customisationItems) {
            recordDataWrapper data2 = new recordDataWrapper();
            if(oc.ordexp_approval_status__c=='CS Rejected' || oc.ordexp_approval_status__c=='Finance Rejected'){
                data2.check=true;   
            }else{
                data2.check=false; 
            } 
            data2.Id=oc.id;
            data2.level='Customisation';
            data2.oliId=oc.Order_Line_Item__c;
            data2.name=oc.Name;
            data2.price=oc.Total_price__c;
            data2.oliAddonStatus=oc.Status__c;
            data2.refundReason=oc.Refund_Reason__c;
            data2.status=oc.Refund_Status__c;
            data2.refund=oc.Cancellation_Amount__c;
            data2.approvalStage=oc.ordexp_approval_status__c;
            wrap.add(data2);   
        }
        system.debug('wrap185'+wrap);
        return wrap; 
    }
    
    // This method gets Cancellation records which are in progress
    @AuraEnabled
    public static List<ApprovalHistoryWrapper> fetchReordDataApexApprovalHistory (String recId){
        
        Map<id,Cancellation_Refund_POE__c> canRefMap = new Map<id,Cancellation_Refund_POE__c>([Select id,Name,Approval_Status__c,Total_Cancellation_Amount__c,createdDate from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId ]);
        
        List<Cancellation_Refund_POE__c> canRef = [Select id,Name,Approval_Status__c,Total_Cancellation_Amount__c,createdDate,Refund_Reason__c,
                                                   (Select Id ,ordexp_approval_status__c, Name, ordexp_suboption_amount__c,Total_surcharge__c,HSS_Amount__c ,OLI_Credit_Amount__c,Refund_Amount__c,Coupon_Amount__c,ordexp_city_surcharge_amount__c,Cancellation_Amount__c,Refund_Status__c,Refund_Reason__c,OLI_Status__c from Order_Line_Items__r), 
                                                   (Select Id,Refund_Reason__c,ordexp_approval_status__c,Order_Line_Item__c,Order_Line_Item__r.Name,Cancellation_Amount__c, Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Refund_Status__c,Addon_Refund_Amount__c,Addon_Coupon_Amount__c,Addon_Credit_Amount__c from AddOns__r), 
                                                   (Select Id,Type__c,Refund_Reason__c,ordexp_approval_status__c,Order_Line_Item__c,Order_Line_Item__r.Name,Cancellation_Amount__c, Name, Status__c, Total_price__c, Refund_Status__c from Order_Customisations_POE__r),
                                                   (Select id, Send__c from coupon__r limit 1) 
                                                   from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId /*PSAG - 176 */AND Cancellation_Type__c != 'Refund No Cancellation'];
        
        
        List<ApprovalHistoryWrapper> wrapData = new List<ApprovalHistoryWrapper>();
        
        for(Cancellation_Refund_POE__c can :canRef){
            
            ApprovalHistoryWrapper  wrap = new ApprovalHistoryWrapper();
            wrap.approvalName= can.Name+' | '+ can.Approval_Status__c+' | '+ can.Total_Cancellation_Amount__c;
            wrap.canRefId = can.Id;
            wrap.refundReason = can.Refund_Reason__c;
            wrap.cancellationStatus = can.Approval_Status__c;
            for(coupon__c cp : can.coupon__r){
                wrap.sendCouponButton = cp.Send__c;
            }
            
            List<recordDataWrapper> recDataList = new List<recordDataWrapper> ();
            
            for(order_line_item__c oli : can.Order_Line_Items__r){
                if(oli.Refund_Status__c != 'Refund without Cancellation'){//PSAG - 176
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oli.id;
                data.level='OLI';
                data.name=oli.Name;
                data.price=oli.ordexp_suboption_amount__c+oli.Total_surcharge__c+oli.HSS_Amount__c +oli.ordexp_city_surcharge_amount__c;
                data.status=oli.Refund_Status__c;
                data.refund=oli.Refund_Amount__c;
                data.coupon = oli.Coupon_Amount__c;
                data.credit = oli.OLI_Credit_Amount__c;    
                data.approvalStage=oli.ordexp_approval_status__c;
                recDataList.add(data);
                }
            } 
            for(AddOn__c add : can.AddOns__r){
                if(add.Refund_Status__c != 'Refund without Cancellation'){//PSAG - 176
                recordDataWrapper data1 = new recordDataWrapper();
                data1.Id=add.id;
                data1.level='AddOn';
                data1.name=add.Order_Line_Item__r.Name+' | '+add.Name +'-'+add.RecordType.Name;
                data1.price=add.ordexp_amount__c;
                data1.status=add.Refund_Status__c;
                data1.refund=add.Addon_Refund_Amount__c;
                data1.coupon = add.Addon_Coupon_Amount__c;
                data1.credit = add.Addon_Credit_Amount__c;
                data1.approvalStage=add.ordexp_approval_status__c;
                recDataList.add(data1); 
                }
            }
            
            
            for(Order_Customisations_POE__c oc : can.Order_Customisations_POE__r){
                if(oc.Refund_Status__c != 'Refund without Cancellation'){//PSAG - 176
                recordDataWrapper data2 = new recordDataWrapper();
                data2.Id=oc.id;
                data2.level='Customisation';
                data2.name=oc.Name;
                data2.type=oc.Type__c;
                data2.price=oc.Total_price__c;
                data2.status=oc.Refund_Status__c;
                data2.refund=oc.Cancellation_Amount__c;
                data2.approvalStage=oc.ordexp_approval_status__c;
                recDataList.add(data2);  
                }
            }
            wrap.oliAddonData=recDataList;
            wrapData.add(wrap);
        }
        return wrapData; 
    }
    
    // This method get records for cancellation based on level selected
    @AuraEnabled
    public static List<recordDataWrapper> fetchReordDataApex (Id recId, String level){
        system.debug('entered in fetchReordDataApex');
        List<recordDataWrapper> wrap = new List<recordDataWrapper>();
        
        if(level=='Order' || level=='OLI'){
            
            List<order_line_item__c> olitems = [Select Id, Name,orderxp_total_amount__c ,orderxp_addons_amount__c ,ordexp_total_customisations_amount__c , ordexp_suboption_amount__c,Total_surcharge__c ,HSS_Amount__c ,ordexp_city_surcharge_amount__c,OLI_Status__c,(select Id, Name, Total_price__c, Status__c, Order_Line_Item__c, Type__c from Order_Customisations_POE__r where Status__c !='Cancelled'), (Select Id,Order_Line_Item__c, Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Refund_Status__c,Passenger__r.ordexp_PAX_Nickname__c from AddOns__r where AddOn_Status__c !='Cancelled' ),(select id,ordexp_PAX_Nickname__c,name from Passengers_POE__r) from order_line_item__c where ordexp_TAD_Order__c =: recId AND OLI_Status__c !='Cancelled'];
            Set<Id> ocId = new Set<Id>();
            for(order_line_item__c oli : olitems)
                for(Order_Customisations_POE__c oc : oli.Order_Customisations_POE__r)
                ocId.add(oc.id);
            
            List<OC_PAX_Junction__c> ocPaxJunc = [select id,ordexp_Order_Customisation__c,ordexp_Passengers__r.ordexp_PAX_Nickname__c from OC_PAX_Junction__c where ordexp_Order_Customisation__c in : ocId];
            Map<Id,String> mapOCpax = new Map<Id,String>();
            for(OC_PAX_Junction__c p : ocPaxJunc){
                String paxName = mapOCpax.get(p.ordexp_Order_Customisation__c);
                if(paxName == null)
                    paxName= p.ordexp_Passengers__r.ordexp_PAX_Nickname__c ;
                else
                    paxName= paxName + ', '+ p.ordexp_Passengers__r.ordexp_PAX_Nickname__c ;
                
                mapOCpax.put(p.ordexp_Order_Customisation__c,paxName);
            }
            
            for(order_line_item__c oli : olitems){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oli.id;
                data.level='OLI';
                data.name=oli.Name;
                data.price=oli.orderxp_total_amount__c - oli.orderxp_addons_amount__c -oli.ordexp_total_customisations_amount__c  ;
                data.oliAddonStatus=oli.OLI_Status__c;
                if(level=='Order'){
                    data.check=true;    
                }else{
                    data.check=false;   
                }
                wrap.add(data);
                data.paxName = '';
                for(integer i=0;i<oli.Passengers_POE__r.size();i++){
                    if(i==0)
                        data.paxName= oli.Passengers_POE__r[i].ordexp_PAX_Nickname__c ;
                    else
                        data.paxName= data.paxName + ', '+ oli.Passengers_POE__r[i].ordexp_PAX_Nickname__c ;
                }
                
                for(AddOn__c add : oli.AddOns__r){
                    recordDataWrapper data1 = new recordDataWrapper();
                    data1.Id=add.id;
                    data1.oliId=add.Order_Line_Item__c;
                    data1.level='AddOn';
                    data1.name=add.Name +'-'+add.RecordType.Name;
                    data1.price=add.ordexp_amount__c;
                    data1.oliAddonStatus=add.AddOn_Status__c;
                    data1.paxName = add.Passenger__r.ordexp_PAX_Nickname__c;
                    if(level=='Order'){
                        data1.check=true;    
                    }else{
                        data1.check=false;   
                    }
                    wrap.add(data1);   
                }
                for(Order_Customisations_POE__c oc : oli.Order_Customisations_POE__r){
                    recordDataWrapper data2 = new recordDataWrapper();
                    data2.Id=oc.Id;
                    data2.oliId=oc.Order_Line_Item__c;
                    data2.level='Customisation';
                    data2.name=oc.Name;
                    data2.type=oc.Type__c;
                    data2.price=oc.Total_price__c;
                    data2.oliAddonStatus=oc.Status__c;
                    data2.paxName = mapOCpax.get(oc.Id);
                    if(level=='Order'){
                        data2.check=true;    
                    }else{
                        data2.check=false;   
                    }
                    wrap.add(data2);   
                }
            }  
            
        }
        
        if(level=='Addon'){
            
            List<AddOn__c> addOn = [Select Id, Name,AddOn_Status__c,RecordType.Name,ordexp_amount__c,Order_Line_Item__r.Name,Refund_Status__c,Passenger__r.ordexp_PAX_Nickname__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c =: recId AND AddOn_Status__c!='Cancelled' AND AddOn_Status__c!='On Hold' ];
            for(AddOn__c add : addOn ){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=add.id;
                data.level='AddOn';
                data.name=add.Order_Line_Item__r.Name +' | '+add.Name +'-'+add.RecordType.Name;
                data.price=add.ordexp_amount__c;
                data.oliAddonStatus=add.AddOn_Status__c;
                data.check=false;
                data.paxName = add.Passenger__r.ordexp_PAX_Nickname__c;
                wrap.add(data);
            }  
            List<OC_PAX_Junction__c> ocPaxJunc = [select id,ordexp_Order_Customisation__c,ordexp_Passengers__r.ordexp_PAX_Nickname__c from OC_PAX_Junction__c where ordexp_Order_Customisation__r.Order_Line_Item__r.ordexp_TAD_Order__c =: recId AND (ordexp_Order_Customisation__r.Status__c!='Cancelled' AND ordexp_Order_Customisation__r.Status__c != 'Declined')];
            Map<Id,String> mapOCpax = new Map<Id,String>();
            for(OC_PAX_Junction__c p : ocPaxJunc){
                String paxName = mapOCpax.get(p.ordexp_Order_Customisation__c);
                if(paxName == null)
                    paxName= p.ordexp_Passengers__r.ordexp_PAX_Nickname__c ;
                else
                    paxName= paxName + ', '+ p.ordexp_Passengers__r.ordexp_PAX_Nickname__c ;
                
                mapOCpax.put(p.ordexp_Order_Customisation__c,paxName);
            }
            
            List<Order_Customisations_POE__c> ocs = [Select Id, Name, Type__c, Status__c, RecordType.Name,Total_price__c,Order_Line_Item__r.Name,Refund_Status__c from Order_Customisations_POE__c where Order_Line_Item__r.ordexp_TAD_Order__c =: recId AND (Status__c!='Cancelled' AND Status__c != 'Declined' AND Status__c='Accepted_and_Paid' )];
            for(Order_Customisations_POE__c oc : ocs ){
                recordDataWrapper data = new recordDataWrapper();
                data.Id=oc.id;
                data.level='Customisation';
                data.name=oc.Name;
                data.type=oc.Type__c;
                data.price=oc.Total_price__c;
                data.oliAddonStatus=oc.Status__c;
                data.check=false;
                data.paxName = mapOCpax.get(oc.Id);
                wrap.add(data);
            }  
        }
        system.debug('wrap384'+wrap);
        return wrap;
    }
    
    // This method gets picklist Values
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname){
        
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry pv : picklistValues) {
            //PSAG - 176 Start
            if(pv.label!='Refund without Cancellation'){
            optionlist.add(pv.getLabel());
            }
            //PSAG - 176 Stop
        }
        system.debug(optionlist);
        return optionlist;
        
    } 
    
    // This method cancels order/records if documentation is required
    @AuraEnabled
    public static void saveAndCancel(Id recId, List<recordDataWrapper> recData,Boolean cancelOrder){
        
        List<order_line_item__c> oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
        List<Order_Customisations_POE__c> customisationToUpdate = new List<Order_Customisations_POE__c>();
        
        Boolean updatePaxCount = false;
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    order_line_item__c oli = new order_line_item__c(id=data.Id);
                    oli.Cancellation_Amount__c=data.refund;
                    oli.Refund_Status__c=data.status;
                    oli.Refund_Reason__c=data.refundReason;
                    oli.OLI_Status__c='Cancelled';
                    oli.OLI_Cancelled_On__c = system.today();
                    if(data.status=='Full Credit' || data.status=='Partial Credit'){
                        //oli.ordexp_approval_status__c ='Processed';
                         oli.ordexp_approval_status__c ='Pending Documentation';  
                    }else{
                        oli.ordexp_approval_status__c ='Pending Documentation';    
                    }
                    oliToUpdate.add(oli); 
                    
                    updatePaxCount = true;
                    
                }
                if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Cancellation_Amount__c=data.refund;
                    add.Refund_Status__c=data.status;
                    add.Refund_Reason__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    add.AddOn_Cancelled_On__c = system.today();
                    if(data.status=='Full Credit' || data.status=='Partial Credit'){
                        //add.ordexp_approval_status__c ='Processed';
                          add.ordexp_approval_status__c ='Pending Documentation';   
                    }else{
                        add.ordexp_approval_status__c ='Pending Documentation';    
                    }
                    addOnToUpdate.add(add);
                }
                if(data.level=='Customisation'){
                    Order_Customisations_POE__c oc= new Order_Customisations_POE__c(id=data.Id);
                    oc.Cancellation_Amount__c=data.refund;
                    oc.Refund_Status__c=data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    oc.Order_Customisation_Cancelled_On__c = system.today();
                    if(data.status=='Full Credit' || data.status=='Partial Credit'){
                       // oc.ordexp_approval_status__c ='Processed';
                         oc.ordexp_approval_status__c ='Pending Documentation';  
                    }else{
                        oc.ordexp_approval_status__c ='Pending Documentation';    
                    }
                    customisationToUpdate.add(oc);
                }
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                List<Allocation__c> aloOverridden = findAllcoationRecord(oliToUpdate);
                update oliToUpdate;
                if(aloOverridden!=null){
                    rollbackOverrideAllo(aloOverridden); 
                }
            }
            if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            }
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        if(updatePaxCount==true){
            List<customer_POE__c> cusCount = [Select id from customer_POE__c where ordexp_tad_order__c=:recId AND Order_Line_Item__r.OLI_Status__c!='Cancelled' AND pif_final__c=true ];
            tad_order__c tadInfo = [Select id ,FF_status_Batch__c,Total_Credit_Amount__c, ordexp_amount_outstanding__c   from tad_order__c where Id=:recId Limit 1];
            
            tad_order__c tadToUpdate = new tad_order__c(id=recId);
            tadToUpdate.ordexp_pif_count__c = cusCount.size();
            if(cancelOrder==true){
                if(tadInfo.Total_Credit_Amount__c!=0 && tadInfo.ordexp_amount_outstanding__c <0){
                    tadToUpdate.ordexp_master_status__c='Temporary Hold';
                    tadToUpdate.ordexp_sub_status__c='Credit';  
                }else{
                    tadToUpdate.ordexp_Order_Cancelled__c =true;
                    tadToUpdate.ordexp_master_status__c='Cancelled';
                    tadToUpdate.Order_Cancelled_On__c = system.today();
                    tadToUpdate.ordexp_sub_status__c=orderSubStatusCheck(recData[0].refundReason,recData[0].status); 
                }
            } 
            try{
                update tadToUpdate;  
            }catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                throw new AuraHandledException(msg);   
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        } 
    }
    
    // This method is for Min not met type of cancellation where we cancel whole order
    @AuraEnabled
    public static void cancelCompleteOrder(Id recId, List<recordDataWrapper> recData){
        
        tad_order__c tadrec = [Select id,FF_status_Batch__c,currencyIsoCode from tad_order__c where id=:recId Limit 1];
        Map<Id,OliAmountData> OliAmountDataMap =  new Map<Id,OliAmountData>();
        Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c ();
        canRef.currencyIsoCode= tadrec.currencyIsoCode;
        canRef.ordexp_tad_order__c=recId;
        insert canRef; 
        
        List<order_line_item__c> oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
        List<Order_Customisations_POE__c> customisationToUpdate = new List<Order_Customisations_POE__c>();
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                 if(data.level=='OLI'){
                    order_line_item__c oli = new order_line_item__c(id=data.Id);
                    oli.Refund_Status__c=data.status;
                    oli.Refund_Reason__c=data.refundReason;
                    oli.OLI_Status__c='Cancelled';
                    oli.OLI_Cancelled_On__c = system.today();
                    oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    oli.Cancellation_Refund__c=canRef.id;
                    //oli.Coupon_Cancellation_Amount__c = data.coupon;
                    oli.OLI_Credit_Amount__c = data.credit;
                    oli.Coupon_Amount__c = data.coupon;
                    oli.Refund_Amount__c = data.refund;
                    oli.ordexp_approval_status__c ='Approved-Refund Not Processed';
                    //oli.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oli.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              oli.Cancellation_Refund__c=canRef.id;
                              oli.Coupon_Cancellation_Amount__c = data.coupon;
                              oli.Credit_Cancellation_Amount__c = data.credit;
                              oli.ordexp_approval_status__c ='Approved-Refund Not Processed';
                              //oli.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oli.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oli.Cancellation_Refund__c=canRef.id;
                             oli.Cancellation_Amount__c=data.credit;
                             oli.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             oli.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.coupon;
                            oli.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                        when else{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.refund;
                            oli.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                         }*/
                    oliToUpdate.add(oli); 
                }
                if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Refund_Status__c=data.status;
                    add.final_Cancellation_Amount__c=data.refund;
                    add.Refund_Reason__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    add.AddOn_Cancelled_On__c = system.today();
                    add.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    add.Cancellation_Refund__c=canRef.id;
                    add.ordexp_approval_status__c ='Approved-Refund Not Processed';
                    add.Addon_Credit_Amount__c = data.credit;
                    add.Addon_Coupon_Amount__c = data.coupon;
                    add.Addon_Refund_Amount__c = data.refund;
                    //add.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(add.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              add.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              add.Cancellation_Refund__c=canRef.id;
                              add.ordexp_approval_status__c ='Approved-Refund Not Processed';
                              add.Credit_Cancellation_Amount__c = data.credit;
                              //add.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(add.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             add.Cancellation_Refund__c=canRef.id;
                             add.Cancellation_Amount__c=data.credit;
                             add.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             add.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.coupon;
                            add.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                        when else{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.refund;
                            add.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                         }*/
                    addOnToUpdate.add(add);
                }
                if(data.level=='Customisation'){
                    Order_Customisations_POE__c oc= new Order_Customisations_POE__c(id=data.Id);
                    oc.Refund_Status__c=data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    oc.Order_Customisation_Cancelled_On__c = system.today();
                    oc.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    oc.Cancellation_Refund__c=canRef.id;
                    //oc.ordexp_approval_status__c ='Approved-Refund Not Processed';
                    oc.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oc.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oc.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              oc.Cancellation_Refund__c=canRef.id;
                              oc.ordexp_approval_status__c ='Approved-Refund Not Processed';
                              //oc.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oc.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oc.Cancellation_Refund__c=canRef.id;
                             oc.Cancellation_Amount__c=data.credit;
                             oc.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             oc.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.coupon;
                            oc.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                        when else{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.refund;
                            oc.ordexp_approval_status__c ='Approved-Refund Not Processed';
                             }
                         }*/
                    customisationToUpdate.add(oc);
                }
            }
        }
        
        tad_order__c tadToUpdate = new tad_order__c(id=recId);
        tadToUpdate.ordexp_master_status__c='Cancelled';
        tadToUpdate.Order_Cancelled_On__c = system.today();
       // tadToUpdate.FF_status_Batch__c =  (tadrec.FF_status_Batch__c==null?'':tadrec.FF_status_Batch__c)+';'+'Processing - Cancellation';
        //tadToUpdate.FFStatus__c = 'Processing - Cancellation';
        tadToUpdate.ordexp_Order_Cancelled__c =true;
        tadToUpdate.ordexp_pif_count__c = 0;
        tadToUpdate.ordexp_sub_status__c=orderSubStatusCheck(recData[0].refundReason,recData[0].status);
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                List<Allocation__c> aloOverridden = findAllcoationRecord(oliToUpdate);
                update oliToUpdate;
                if(aloOverridden!=null){
                    rollbackOverrideAllo(aloOverridden); 
                }
            }
            if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            }
            update tadToUpdate;
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        Cancellation_Refund_POE__c can = updateCanRefRecord(canRef,OliAmountDataMap);
        can.Approval_Status__c  ='Approved-Refund Not Processed';
        update can;
        
        
    }
    
    // This methods cancels records and sends for approval
    @AuraEnabled
    public static void submitForApproval(Id recId, List<recordDataWrapper> recData,Boolean cancelOrder, Boolean isCustomerAccepted){
        system.debug('Line--725-->'+cancelOrder);
        Map<Id,OliAmountData> OliAmountDataMap =  new Map<Id,OliAmountData>();
        List<order_line_item__c> oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
        List<Order_Customisations_POE__c> customisationToUpdate = new List<Order_Customisations_POE__c>();
        
        Boolean updatePaxCount = false;
        Boolean canRefCheck = false;
        
        Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
        for(recordDataWrapper rec : recData){
            if(/*rec.status !='Full Credit' && rec.status !='Partial Credit' && rec.status !='No Refund/Credit' &&*/ rec.check==true){
                canRefCheck=true;
                break;
            }
        }
        if(canRefCheck==true){
            canRef = canRefRecordAssignment(recId,isCustomerAccepted);  
        }
        Boolean haveCancellation = false;
        for(recordDataWrapper data :recData){
            if(data.check==true){
                haveCancellation = true;
                if(data.level=='OLI'){
                    order_line_item__c oli = new order_line_item__c(id=data.Id);
                    oli.Refund_Status__c=data.status;
                    oli.Refund_Reason__c=data.refundReason;
                    oli.OLI_Status__c='Cancelled';
                    oli.OLI_Cancelled_On__c = system.today();
                    oli.Coupon_Amount__c = data.coupon;
                    oli.Refund_Amount__c = data.refund;
                    oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    oli.Cancellation_Refund__c=canRef.id;
                    oli.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    //oli.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    //oli.Coupon_Cancellation_Amount__c = data.coupon;
                    oli.OLI_Credit_Amount__c = data.credit;
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oli.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              oli.Cancellation_Refund__c=canRef.id;
                              oli.ordexp_approval_status__c ='Pending CS Approval';
                              oli.Coupon_Cancellation_Amount__c = data.coupon;
                              oli.Credit_Cancellation_Amount__c = data.credit;
                              oli.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oli.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oli.Cancellation_Refund__c=canRef.id;
                             oli.Cancellation_Amount__c=data.credit;
                             oli.ordexp_approval_status__c ='Pending CS Approval';
                             oli.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.coupon;
                            oli.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.refund;
                            oli.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    oliToUpdate.add(oli); 
                    updatePaxCount = true;
                }
                if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Refund_Status__c=data.status;
                    add.final_Cancellation_Amount__c=data.refund;
                    add.Refund_Reason__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    add.AddOn_Cancelled_On__c = system.today();
                    add.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    add.Cancellation_Refund__c=canRef.id;
                    add.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    add.Addon_Credit_Amount__c = data.credit;
                    add.Addon_Coupon_Amount__c = data.coupon;
                    add.Addon_Refund_Amount__c = data.refund;
                    //add.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(add.Id,pccrData);
                    System.debug('Addon' + add);
                   /* switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              add.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              add.Cancellation_Refund__c=canRef.id;
                              add.ordexp_approval_status__c ='Pending CS Approval';
                              add.Credit_Cancellation_Amount__c = data.credit;
                              //add.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(add.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             add.Cancellation_Refund__c=canRef.id;
                             add.Cancellation_Amount__c=data.credit;
                             add.ordexp_approval_status__c ='Pending CS Approval';
                             add.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.coupon;
                            add.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.refund;
                            add.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    addOnToUpdate.add(add);
                    System.debug('Addontoupdate' + addOnToUpdate);
                }
                if(data.level=='Customisation'){
                    Order_Customisations_POE__c oc= new Order_Customisations_POE__c(id=data.Id);
                    oc.Refund_Status__c=data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    oc.Order_Customisation_Cancelled_On__c = system.today();
                    oc.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    oc.Cancellation_Refund__c=canRef.id;
                    oc.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    //oc.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oc.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oc.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              oc.Cancellation_Refund__c=canRef.id;
                              oc.ordexp_approval_status__c ='Pending CS Approval';
                              //oc.Withheld_Amount__c = data.Price - (data.refund + data.coupon + data.credit);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oc.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oc.Cancellation_Refund__c=canRef.id;
                             oc.Cancellation_Amount__c=data.credit;
                             oc.ordexp_approval_status__c ='Pending CS Approval';
                             oc.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.coupon;
                            oc.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.refund;
                            oc.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    customisationToUpdate.add(oc);
                }
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                List<Allocation__c> aloOverridden = findAllcoationRecord(oliToUpdate);
                update oliToUpdate;
                if(aloOverridden!=null){
                    rollbackOverrideAllo(aloOverridden); 
                }
            }
            if(!addOnToUpdate.isEmpty()){
                system.debug('line968'+ addOnToUpdate);
                update addOnToUpdate;
                
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            }
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        tad_order__c tadToUpdate = new tad_order__c();
        tadToUpdate.id = recId;
        
        tad_order__c tadInfo = [Select id ,FF_status_Batch__c,Total_Credit_Amount__c, ordexp_amount_outstanding__c   from tad_order__c where Id=:recId Limit 1];
        
        if(updatePaxCount==true){
            system.debug('Line--869-->'+updatePaxCount);
            List<customer_POE__c> cusCount = [Select id from customer_POE__c where ordexp_tad_order__c=:recId AND Order_Line_Item__r.OLI_Status__c!='Cancelled' AND pif_final__c=true];
            tadToUpdate.ordexp_pif_count__c = cusCount.size();
            if(cancelOrder==true){
                  system.debug('Line--873-->'+cancelOrder);
                if(tadInfo.Total_Credit_Amount__c!=0 && tadInfo.ordexp_amount_outstanding__c <0){
                     system.debug('Line--875-->'+cancelOrder);
                    tadToUpdate.ordexp_master_status__c='Temporary Hold';
                    tadToUpdate.ordexp_sub_status__c='Credit';  
                }else{
                     system.debug('Line--879-->'+cancelOrder);
                    tadToUpdate.ordexp_Order_Cancelled__c =true;
                    tadToUpdate.ordexp_master_status__c='Cancelled';
                    tadToUpdate.ordexp_sub_status__c=orderSubStatusCheck(recData[0].refundReason,recData[0].status); 
                }
            } 
           // tadToUpdate.FF_status_Batch__c =  (tadInfo.FF_status_Batch__c==null?'':tadInfo.FF_status_Batch__c)+';'+'Processing - Cancellation';
            //tadToUpdate.FFStatus__c = 'Processing - Cancellation';
            tadToUpdate.Order_Cancelled_On__c = system.today();
            //try{
                update tadToUpdate;
           /* }catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                throw new AuraHandledException(msg);
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }*/
        }else if(haveCancellation=true){
           // tadToUpdate.FFStatus__c = 'Processing - Cancellation';
           // tadToUpdate.FF_status_Batch__c =  (tadInfo.FF_status_Batch__c==null?'':tadInfo.FF_status_Batch__c)+';'+'Processing - Cancellation';
            tadToUpdate.Order_Cancelled_On__c = system.today();
            update tadToUpdate;
        }
        
        if(canRefCheck==true){
            Cancellation_Refund_POE__c can = updateCanRefRecord(canRef,OliAmountDataMap);
            if(can.Refund_Amount__c + can.Coupon_Amount__c + can.Credit_Amount__c == 0){
                can.Approval_Status__c='Processed';
            }else{
                can.Approval_Status__c='Pending CS Approval';
            }
            update can;
        }
        
    }   
    
    @AuraEnabled
    public static void sendForApprovalPostDocumentation(Id recId, List<recordDataWrapper> recData, Boolean isCustomAccepted){
        
        List<order_line_item__c> oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c> addOnToUpdate = new List<AddOn__c>();
        List<Order_Customisations_POE__c> customisationToUpdate = new List<Order_Customisations_POE__c>();
        Map<Id,OliAmountData> OliAmountDataMap =  new Map<Id,OliAmountData>();
        Boolean canRefCheck = false;
        Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
        
        for(recordDataWrapper rec : recData){
            if(/*rec.status !='Full Credit' && rec.status !='Partial Credit' && rec.status !='No Refund/Credit' && */ rec.check==true){
                canRefCheck=true;
                break;
            }
        }
        if(canRefCheck==true){
            canRef = canRefRecordAssignment(recId, isCustomAccepted);  
        }
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    order_line_item__c oli = new order_line_item__c(id=data.Id);
                    oli.Refund_Status__c=data.status;
                    oli.Refund_Reason__c=data.refundReason;
                    oli.OLI_Status__c='Cancelled';
                    oli.OLI_Cancelled_On__c = system.today();
                    oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                    oli.Cancellation_Refund__c=canRef.id;
                    oli.Coupon_Amount__c = data.coupon;
                    oli.Refund_Amount__c = data.refund;
                    oli.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    //oli.Coupon_Cancellation_Amount__c = data.coupon;
                    oli.OLI_Credit_Amount__c = data.credit;
                    //oli.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oli.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oli.Cancellation_Amount__c=data.refund + data.coupon + data.credit;
                              oli.Cancellation_Refund__c=canRef.id;
                              oli.ordexp_approval_status__c ='Pending CS Approval';
                              oli.Coupon_Cancellation_Amount__c = data.coupon;
                              oli.Credit_Cancellation_Amount__c = data.credit;
                              //oli.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oli.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oli.Cancellation_Refund__c=canRef.id;
                             oli.Cancellation_Amount__c=data.credit;
                             oli.ordexp_approval_status__c ='Pending CS Approval';
                             oli.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.coupon;
                            oli.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            oli.Cancellation_Refund__c=canRef.id;
                            oli.Cancellation_Amount__c=data.refund;
                            oli.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    oliToUpdate.add(oli); 
                }
                if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    add.Refund_Status__c=data.status;
                    add.final_Cancellation_Amount__c=data.refund;
                    add.Refund_Reason__c=data.refundReason;
                    add.AddOn_Status__c='Cancelled';
                    add.AddOn_Cancelled_On__c = system.today();
                    add.Cancellation_Amount__c=data.refund + data.credit + data.coupon;
                    add.Cancellation_Refund__c=canRef.id;
                    add.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    add.Addon_Credit_Amount__c = data.credit;
                    add.Addon_Coupon_Amount__c = data.coupon;
                    add.Addon_Refund_Amount__c = data.refund;
                    //add.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(add.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              add.Cancellation_Amount__c=data.refund + data.credit + data.coupon;
                              add.Cancellation_Refund__c=canRef.id;
                              add.ordexp_approval_status__c ='Pending CS Approval';
                              add.Credit_Cancellation_Amount__c = data.credit;
                              //add.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(add.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             add.Cancellation_Refund__c=canRef.id;
                             add.Cancellation_Amount__c=data.credit;
                             add.ordexp_approval_status__c ='Pending CS Approval';
                             add.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.coupon;
                            add.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            add.Cancellation_Refund__c=canRef.id;
                            add.Cancellation_Amount__c=data.refund;
                            add.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    addOnToUpdate.add(add);
                }
                if(data.level=='Customisation'){
                    Order_Customisations_POE__c oc= new Order_Customisations_POE__c(id=data.Id);
                    oc.Refund_Status__c=data.status;
                    oc.Refund_Reason__c=data.refundReason;
                    oc.Status__c='Cancelled';
                    oc.Order_Customisation_Cancelled_On__c = system.today();
                    oc.Cancellation_Amount__c=data.refund + data.coupon;
                    oc.Cancellation_Refund__c=canRef.id;
                    oc.ordexp_approval_status__c =(data.refund + data.coupon + data.credit)==0?'Processed':'Pending CS Approval';
                    //oc.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                    OliAmountData pccrData = new OliAmountData();
                    pccrData.creditAmount = data.credit;
                    pccrData.couponAmount = data.coupon;
                    pccrData.refundAmount = data.refund;
                    OliAmountDataMap.put(oc.Id,pccrData);
                    /*switch on data.status{
                        when 'Partial Refund/Coupon/Credit'{
                              oc.Cancellation_Amount__c=data.refund + data.coupon;
                              oc.Cancellation_Refund__c=canRef.id;
                              oc.ordexp_approval_status__c ='Pending CS Approval';
                              //oc.Withheld_Amount__c = data.Price - (data.refund + data.credit + data.coupon);
                              OliAmountData pccrData = new OliAmountData();
                              pccrData.creditAmount = data.credit;
                              pccrData.couponAmount = data.coupon;
                              pccrData.refundAmount = data.refund;
                              OliAmountDataMap.put(oc.Id,pccrData);
                             }
                        when 'Full Credit','Partial Credit'{
                             oc.Cancellation_Refund__c=canRef.id;
                             oc.Cancellation_Amount__c=data.credit;
                             oc.ordexp_approval_status__c ='Pending CS Approval';
                             oc.Withheld_Amount__c = data.Price - data.credit;
                             }
                        when 'Full Coupon','Partial Coupon'{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.coupon;
                            oc.ordexp_approval_status__c ='Pending CS Approval';
                             }
                        when else{
                            oc.Cancellation_Refund__c=canRef.id;
                            oc.Cancellation_Amount__c=data.refund;
                            oc.ordexp_approval_status__c ='Pending CS Approval';
                             }
                         }*/
                    customisationToUpdate.add(oc);
                }
            }
        }
        
        String msg = '';
        try{
            if(!oliToUpdate.isEmpty()){
                List<Allocation__c> aloOverridden = findAllcoationRecord(oliToUpdate);
                update oliToUpdate;
                if(aloOverridden!=null){
                    rollbackOverrideAllo(aloOverridden); 
                }
            }
            if(!addOnToUpdate.isEmpty()){
                update addOnToUpdate;
            }
            if(!customisationToUpdate.isEmpty()){
                update customisationToUpdate;
            }
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);  
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        if(canRefCheck==true){
            Cancellation_Refund_POE__c can = updateCanRefRecord(canRef, OliAmountDataMap);
            if(can.Refund_Amount__c + can.Coupon_Amount__c + can.Credit_Amount__c == 0){
                can.Approval_Status__c='Processed';
            }else{
                can.Approval_Status__c='Pending CS Approval';
            }
            update can;
        }
    } 
    
    private static Cancellation_Refund_POE__c updateCanRefRecord (Cancellation_Refund_POE__c canRef, Map<Id,OliAmountData> OliAmountDataMap){
        
        Decimal refundAmount =0;
        Decimal coupounAmount =0;
        Decimal creditAmount =0;
        String cancelledInfo='';
        String reason='';
        List<Cancellation_Refund_POE__c> canRefList = [Select id,Name,
                                                       (Select Id ,Name,Cancellation_Amount__c,orderxp_total_amount__c,Refund_Status__c,Refund_Reason__c from Order_Line_Items__r), 
                                                       (Select Id,Name,Cancellation_Amount__c,ordexp_amount__c,Refund_Status__c,RecordType.Name,Refund_Reason__c from AddOns__r), 
                                                       (Select Id,Name,Cancellation_Amount__c,Refund_Status__c,Refund_Reason__c from Order_Customisations_POE__r)
                                                       from Cancellation_Refund_POE__c where Id=:canRef.Id ];
        
        for(Cancellation_Refund_POE__c can :canRefList){
            for(order_line_item__c oli : can.Order_Line_Items__r){
                if(oli.Refund_Status__c=='Full Coupon' || oli.Refund_Status__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+oli.Cancellation_Amount__c;   
                }else if(oli.Refund_Status__c=='Full Refund' || oli.Refund_Status__c=='Partial Refund'){
                    refundAmount=refundAmount+oli.Cancellation_Amount__c;
                }
                else if(oli.Refund_Status__c=='Full Credit' || oli.Refund_Status__c=='Partial Credit'){
                    creditAmount=creditAmount+oli.Cancellation_Amount__c;
                } else if(oli.Refund_Status__c =='Partial Refund/Coupon/Credit'){
                    coupounAmount=coupounAmount+ OliAmountDataMap.get(oli.Id).couponAmount;
                    refundAmount=refundAmount+OliAmountDataMap.get(oli.Id).refundAmount;
                    creditAmount=creditAmount+OliAmountDataMap.get(oli.Id).creditAmount;
                }
                
                cancelledInfo=cancelledInfo+oli.Name+'\n';
                if(oli.Refund_Reason__c != null)
                    reason = oli.Refund_Reason__c;
            } 
            for(AddOn__c add : can.AddOns__r){
                if(add.Refund_Status__c=='Full Coupon' || add.Refund_Status__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+add.Cancellation_Amount__c;   
                }else if(add.Refund_Status__c=='Full Refund' || add.Refund_Status__c=='Partial Refund'){
                    refundAmount=refundAmount+add.Cancellation_Amount__c;
                }
                else if(add.Refund_Status__c=='Full Credit' || add.Refund_Status__c=='Partial Credit'){
                    creditAmount=creditAmount+add.Cancellation_Amount__c;
                }else if(add.Refund_Status__c =='Partial Refund/Coupon/Credit'){
                    coupounAmount=coupounAmount+ OliAmountDataMap.get(add.Id).couponAmount;
                    refundAmount=refundAmount+OliAmountDataMap.get(add.Id).refundAmount;
                    creditAmount=creditAmount+OliAmountDataMap.get(add.Id).creditAmount;
                }
               
                cancelledInfo=cancelledInfo+'AddOn - '+add.RecordType.Name+' | '+add.Name+'\n';
                if(add.Refund_Reason__c != null)
                    reason = add.Refund_Reason__c;
            }
            for(Order_Customisations_POE__c oc : can.Order_Customisations_POE__r){
                if(oc.Refund_Status__c=='Full Coupon' || oc.Refund_Status__c=='Partial Coupon'){
                    coupounAmount=coupounAmount+oc.Cancellation_Amount__c;   
                }else if(oc.Refund_Status__c=='Full Refund' || oc.Refund_Status__c=='Partial Refund'){
                    refundAmount=refundAmount+oc.Cancellation_Amount__c;
                }
                else if(oc.Refund_Status__c=='Full Credit' || oc.Refund_Status__c=='Partial Credit'){
                    creditAmount=creditAmount+oc.Cancellation_Amount__c;
                }else if(oc.Refund_Status__c =='Partial Refund/Coupon/Credit'){
                    coupounAmount=coupounAmount+ OliAmountDataMap.get(oc.Id).couponAmount;
                    refundAmount=refundAmount+OliAmountDataMap.get(oc.Id).refundAmount;
                    creditAmount=creditAmount+OliAmountDataMap.get(oc.Id).creditAmount;
                }
                cancelledInfo=cancelledInfo+'Order Customisation - '+oc.Name+'\n';
                if(oc.Refund_Reason__c != null)
                    reason = oc.Refund_Reason__c;
            }
        }
        Cancellation_Refund_POE__c  canRefData = new  Cancellation_Refund_POE__c();
        canRefData.Id=canRef.Id;
        canRefData.Refund_Amount__c=refundAmount;
        canRefData.Coupon_Amount__c =coupounAmount;
        canRefData.Credit_Amount__c = creditAmount;
        canRefData.Cancelled_Records_Information__c =cancelledInfo;
        canRefData.CS_Refund_Rejection_Reason__c  ='';
        canRefData.Finance_Refund_Rejection_Reason__c   ='';
        canRefData.Type__c = refundAmount>0? 'Refund Required': 'No Refund Required';
        canRefData.Cancellation_Type__c ='Cancellation'; 
        canRefData.Refund_Reason__c = reason;
        return canRefData;
    }
    
    private static String orderSubStatusCheck (String refundReason,String refundStatus ){
        String subStatus='';
        
        if(refundReason.contains('Offload')){
            subStatus='Offloaded'; 
        }
        else if(refundReason.contains('Min Numbers')){
            if(refundStatus.contains('Credit')){
                subStatus='Min Number - Credit issued';
            }else{
                subStatus='Mins Not Met';  
            }
        }
        else if(refundReason.contains('Internal')){
            subStatus='Internal'; 
        }
        else if(refundReason.contains('Customer')){
            subStatus='Customer Request'; 
        }
        else if(refundReason.contains('External')){
            subStatus='External'; 
        }
        return subStatus;
    } 
    
    private static Cancellation_Refund_POE__c canRefRecordAssignment (Id recId, Boolean isCustomerAccepted  ){
        Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c ();
        
        Set<String> approvalStatus = new Set<String>();
        approvalStatus.add('Approved-Refund Not Processed');
        approvalStatus.add('Processed');
        
        List<Cancellation_Refund_POE__c> canRefFindList = [Select id,Refund_Amount__c,Coupon_Amount__c,Cancelled_Records_Information__c from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId AND Approval_Status__c NOT IN:approvalStatus];
        tad_order__c tadrec = [Select id,currencyIsoCode from tad_order__c where id=:recId Limit 1];
        
        if(canRefFindList.isEmpty()){
            canRef.ordexp_tad_order__c=recId;
            canRef.currencyIsoCode=tadrec.currencyIsoCode;
            canRef.Customer_Accepts__c = isCustomerAccepted;
            canRef.Cancellation_Type__c ='Cancellation'; 
            insert canRef;   
            
        }else{
            canRef = canRefFindList[0];
            ProcessInstanceWorkitem[] workItems = [ SELECT Id
                                                   FROM ProcessInstanceWorkitem 
                                                   WHERE ProcessInstance.TargetObjectId =: canRef.id
                                                   AND ProcessInstance.Status = 'Pending' ]; 
            
            if(!workItems.isEmpty()){
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
                pwr.setAction('Removed');
                pwr.setWorkItemId(workItems[0].id);   
                Approval.ProcessResult result = Approval.process(pwr);
            }
            canRef.Approval_Status__c=''; 
            update canRef; 
        }
        System.debug('canRefController'+canRef);
        return canRef;
    }
    
    @AuraEnabled
    public static void settingSendCouponTrue(String canRefId){
        
        
        coupon__c couponToBeUpdated = [Select id, Send__c from coupon__c where ordexp_CancellationRefund__c =: canRefId];
        couponToBeUpdated.Send__c = true;
        update couponToBeUpdated; 
        
    }
    @AuraEnabled
    public static void deleteRecordsApex(String recId,List<recordDataWrapper> recData){
        System.debug('recId'+recId);
        List<order_line_item__c> oliToDelete = new List<order_line_item__c>();
        List<AddOn__c> addOnToDelete = new List<AddOn__c>();
        
        for(recordDataWrapper data :recData){
            if(data.check==true){
                if(data.level=='OLI'){
                    order_line_item__c oli = new order_line_item__c(id=data.Id);
                    oliToDelete.add(oli);
                }
                if(data.level=='AddOn'){
                    AddOn__c add= new AddOn__c(id=data.Id);
                    addOnToDelete.add(add);
                }
            }
        }
        
        if(!addOnToDelete.isEmpty()){
          Database.delete(addOnToDelete, false);  
        }
        if(!oliToDelete.isEmpty()){
          Database.delete(oliToDelete, false);  
        }
        
        if(!oliToDelete.isEmpty()){
            List<customer_poe__c> paxToDelete = [Select id from customer_poe__c where order_line_item__c IN :oliToDelete];
            delete paxToDelete;
        }
       
		Decimal price = 0   ;     
        tad_order__c tadOrder = [Select id , name ,(Select id , orderxp_total_amount__c  from Order_Line_Items_orders__r) from tad_order__c where id=:recId];
        for(order_line_item__c oli : tadOrder.Order_Line_Items_orders__r){
           price= price+ oli.orderxp_total_amount__c;
        }
        
        tad_order__c tad = new tad_order__c();
        tad.id=recId;
        tad.ordexp_gross_amount__c =price;
        update tad;
        
    }
    
    // To override -ve allocation for cancelled OLI is already cancelled
    public static List<Allocation__c> findAllcoationRecord(List<order_line_item__c> oliRecsForAllo){
        
        integer alloR = 4;
        
        Set<string> alloToOveride = new Set<string>();
        List<Order_Night_POE__c > onsForAllo = [Select id , Allocation__c  from Order_Night_POE__c where Order_Line_Item__c  IN:oliRecsForAllo  and Allocation__r.Remaining__c <:alloR ];
        for(Order_Night_POE__c onss : onsForAllo){
            alloToOveride.add(onss.Allocation__c); 
        }
        System.debug('alloToOveride'+alloToOveride);
        if(!alloToOveride.isEmpty()){
            
            List<Allocation__c> accUpdate = new List<Allocation__c> ();
            for(string data : alloToOveride){
                Allocation__c  acc = new Allocation__c ();
                acc.Override_Allocation__c=true;
                acc.id=data;
                accUpdate.add(acc);
            }
            
            update accUpdate;
            return accUpdate;
        }else{
            return null;
        }
        
        
    }
    
    // To rollback override -ve allocation 
    public static void rollbackOverrideAllo(List<Allocation__c> allRollback){
        
        List<Allocation__c> accUpdate = new List<Allocation__c> ();
        for(Allocation__c data : allRollback){
            data.Override_Allocation__c=false;
            accUpdate.add(data);
        }
        
        update accUpdate; 
        
    }
       
}