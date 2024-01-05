/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 01-28-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class TAD_SplitOliForMultiplePaxController {
    
    public class mainrecordataWrapper{ 
        
        @AuraEnabled  public Boolean isStay {get;set;}
        @AuraEnabled  public list<recordataWrapper> recdata {get;set;}
        
    }
    public class recordataWrapper{ 
        @AuraEnabled  public String oliname {get;set;}
        @AuraEnabled  public boolean check {get;set;}
        @AuraEnabled  public Id oliId {get;set;}
        @AuraEnabled  public List<picklistValues> cusList {get;set;}
        
    }
    
    public class picklistValues{
        @AuraEnabled  public String label {get;set;}
        @AuraEnabled  public String value {get;set;} 
    }
    
    @AuraEnabled 
    public static Boolean validatePricingModelApex(Id tadOrderId,Id oliId,Integer twinCount){
        System.debug('twinCount'+twinCount);
        System.debug('oliId'+oliId);
        System.debug('tadOrderId'+tadOrderId);
        Boolean success = true;
        Map<String,Integer> supOptionTwinMap = new Map<String,Integer>();
        List<order_line_item__c> oliList = [Select id , Name,Sub_Options__c,PAX_Qty__c, Pricing_Model__c  from order_line_item__c where ordexp_TAD_Order__c =: tadOrderId AND OLI_Status__c != 'Cancelled'];
        order_line_item__c oliRec ;
        for(order_line_item__c ol : oliList){
            if(ol.id!=oliId){
                if(ol.Pricing_Model__c=='Twin'){
                    if(supOptionTwinMap.get(ol.Sub_Options__c)==null){
                        supOptionTwinMap.put(ol.Sub_Options__c,integer.valueof(ol.PAX_Qty__c));   
                    }else{
                        Integer pax =  supOptionTwinMap.get(ol.Sub_Options__c);
                        supOptionTwinMap.put(ol.Sub_Options__c,integer.valueof(ol.PAX_Qty__c)+pax); 
                    }   
                } 
            }else{
                oliRec= ol;
            }
        }
        
        if(twinCount!=0){
            Integer existingcount = 0;
            if(supOptionTwinMap.get(oliRec.Sub_Options__c)!=null){
                existingcount= supOptionTwinMap.get(oliRec.Sub_Options__c) ;
            }
            
            Integer count =  twinCount + existingcount; 
            System.debug('count'+count);
            System.debug('Mod'+math.mod(count,2));
            if (math.mod(count,2)==0){
                success = true;  
            }else{
                success = false; 
            }
        }
        
        return success;
        
    }
    
    @AuraEnabled 
    public static mainrecordataWrapper fetchAvailableOli(Id tadOrderId){
        mainrecordataWrapper mn=new mainrecordataWrapper();
        List<recordataWrapper> wrapList = new List<recordataWrapper>();
        mn.isStay=false;
        for(order_line_item__c oli : [Select Id,Pricing_Model__c, Name ,Departure_cities__r.city__c,ordexp_TAD_Order__r.ordexp_deal_type__c,ordexp_TAD_Order__c, PAX_Qty__c, Sub_Options__r.Name, (select Id,first_name__c, last_name__c, dob__c, Email__c, Order_Line_Item__c, ordexp_PAX_Nickname__c from Passengers_POE__r ), (select Id from Order_Customisations_POE__r where Status__c != 'Accepted_and_Paid') from order_line_item__c where ordexp_TAD_Order__c =: tadOrderId AND OLI_Status__c != 'Cancelled']){
            system.debug('oli.Order_Customisations_POE__r.size() '+oli.Order_Customisations_POE__r.size());
            if(oli.Pricing_Model__c=='QTY' ){
                mn.isStay=true;
            }
            
            if(oli.Passengers_POE__r.size() > 1 ){
                recordataWrapper wrap = new recordataWrapper();
                wrap.oliId = oli.Id;
                wrap.check=false; 
                wrap.oliname = oli.Name+'--'+oli.Departure_cities__r.city__c+'--'+String.valueOf(oli.PAX_Qty__c) +'--'+oli.Sub_Options__r.Name;
                List<picklistValues> pickList = new List<picklistValues>();
                for(customer_POE__c cus : oli.Passengers_POE__r){
                    picklistValues pick = new picklistValues();
                    if(cus.first_name__c==null){
                        pick.label = cus.ordexp_PAX_Nickname__c;   
                    }else{
                        pick.label = cus.first_name__c +' '+  cus.last_name__c +'--'+cus.dob__c;
                    }
                    
                    pick.value=cus.id;
                    pickList.add(pick);
                }
                wrap.cusList = pickList;
                wrapList.add(wrap);
            }
        }
        mn.recData=wrapList;
        system.debug('wrapList  '+wrapList);
        return mn;
    }
    
    @AuraEnabled 
    public static void splitoliWithPax(String selectedIds, String oliId,String newModel, String oldModel,String tadId){
        
        
        String []  cusIds = selectedIds.split(',');
        Set<id> oliIds = new Set<id>();
        oliIds.add(oliId);
        List<order_line_item__c> ListToInsertOli = new  List<order_line_item__c>();
        List<order_line_item__c> ListToUpdateOli = new  List<order_line_item__c>();
        List<customer_POE__c> ListToUpdatePax = new  List<customer_POE__c>();
        List<AddOn__c> ListToUpdateAddon = new  List<AddOn__c>();
        List<AddOn__c> ListToDeleteAddon = new  List<AddOn__c>();
        Set<Id> updatedpaxIds = new Set<id>();
        String soql = TAD_SplitOliForMultiplePaxController.getCreatableFieldsSOQL('order_line_item__c','id='+'\''+ oliId + '\'' );
        
        order_line_item__c oli = (order_line_item__c)Database.query(soql);
        
        // Ritu Credit Utilized
        Decimal  creditUtilize = oli.Credit_Utilized__c;
        //@Ritu Nagi
        TAD_Order__c order = [SELECT Id, ordexp_amount_outstanding__c FROM TAD_Order__c WHERE Id =:oli.ordexp_TAD_Order__c];
        Decimal totalAmountOutStanding = order.ordexp_amount_outstanding__c;
        // Ritu Credit Utilized ends
        
        String numbervalue = String.valueOf( Integer.valueOf(oli.PAX_Qty__c - cusIds.size()));
        oli.PAX_Quantity__c = numbervalue;
        oli.Quantity__c=numbervalue;
        oli.Pricing_Model__c=oldModel;
        oli.isSplit__c = true;
        ListToUpdateOli.add(oli);
        
        order_line_item__c newtempOli = oli.clone(false, true);
        newtempOli.PAX_Quantity__c = String.valueOf(cusIds.size());
        newtempOli.quantity__c = String.valueOf(cusIds.size());
        newtempOli.Pricing_Model__c=newModel;
        newtempOli.OLI_Status__c='On Hold';
        newtempOli.Source_OLI__c = oli.Id;
        
        // Ritu Credit Utilized
        if(oli.OLI_Status__c == 'On Hold'){
            newtempOli.SplitBeforeSecured__c =true;
        }
        // Ritu Credit Utilized ends
        
        system.debug('newtempOli '+newtempOli);
        List<Allocation__c> aloOverridden = new List<Allocation__c> ();
        if(newtempOli != null){
            
            ListToInsertOli.add(newtempOli);
            // insert newtempOli;
            //update oli;
            //  try{
            //update ListToUpdateOli;
            OrderLineItemTriggerHandler.runOnce = false;
            aloOverridden = orderCancellationFormController.findAllcoationRecord(ListToUpdateOli);
            insert ListToInsertOli;
            oliIds.add(newtempOli.Id);
            
            if(!cusIds.isEmpty()){
                
                List<customer_POE__c> cusList = [Select id ,Order_Line_Item__c  from customer_POE__c where  Id In:cusIds];
                for(customer_POE__c pax : cusList){
                    pax.Order_Line_Item__c = newtempOli.Id;
                    ListToUpdatePax.add(pax);
                }
                system.debug('ListToUpdatePax '+ListToUpdatePax);
                if(!ListToUpdatePax.isEmpty()){
                    update ListToUpdatePax;
                }
                //List<AddOn__c> fetchAddOnListWithPax = [select Id, Order_Line_Item__c, Passenger__c from AddOn__c where Customisation__c = null AND Passenger__c IN :  cusIds];
                for(AddOn__c addOn : [select Id, Order_Line_Item__c, Passenger__c from AddOn__c where Customisation__c = null AND Passenger__c IN :  cusIds]){
                    system.debug('addOn '+addOn);
                    addOn.Order_Line_Item__c= newtempOli.Id;
                    ListToUpdateAddon.add(addOn);
                }  
                system.debug('ListToUpdateAddon '+ListToUpdateAddon);
                if(!ListToUpdateAddon.isEmpty())
                    update ListToUpdateAddon;
            } 
            
            // Cancel OL for Split OLI
            List<order_line_POE__c> olToCancel = [Select id, Order_Line_Item__c from order_line_POE__c where Order_Line_Item__c =:oliId];
            for(order_line_POE__c ol : olToCancel){
                ol.Status__c='Cancelled';
            }
            update olToCancel;

            
        }  
        // return false;
        String alloData ='';
        if(aloOverridden!=null){
            for(Allocation__c acc : aloOverridden){
                alloData=alloData+';'+acc.id;
            }
        }
        
        TAD_SplitOliForMultiplePaxController.splitoliWithPaxUpdate(selectedIds,oliId,newModel,oldModel,tadId,alloData);
        
        //@Ritu Nagi for population Credit Utilize
        if(creditUtilize != null){
            populateCreditUtilize(totalAmountOutStanding,newtempOli,oli,cusIds.size(),oli.PAX_Qty__c,creditUtilize);  
        }
    }
    
    //@Ritu Nagi Credit Method
    public static void populateCreditUtilize(Decimal totalAmountOutStanding, order_line_item__c newOli,order_line_item__c oldOli,Integer noOfSelectedIds, Decimal oldPax, Decimal creditUt){
        Decimal newSplitOLIFirstPax = Decimal.valueOf(oldOli.PAX_Quantity__c);
        Double newSplitOLISecondPax = noOfSelectedIds;
        
        Decimal utilizePerPax = creditUt/oldPax ;
        Decimal updateExPaxUtilise = utilizePerPax*newSplitOLIFirstPax;
        Decimal newlySplitPaxUtilise = utilizePerPax*newSplitOLISecondPax;
        
        
        List<order_line_item__c> oliToUpdateForCreditUtilize = new List<order_line_item__c>();
        newOli.Credit_Utilized__c = newlySplitPaxUtilise;   
        oldOli.Credit_Utilized__c = updateExPaxUtilise;
        oliToUpdateForCreditUtilize.add(newOli);
        oliToUpdateForCreditUtilize.add(oldOli);
        
        update oliToUpdateForCreditUtilize;
        
    }
    
    @future(callout=true)
    public static void splitoliWithPaxUpdate(String selectedIds, String oliId,String newModel, String oldModel,String tadId,String allRollback){
        String []  cusIds = selectedIds.split(',');
        
        Set<id> oliIds = new Set<id>();
        oliIds.add(oliId);
        List<order_line_item__c> ListToInsertOli = new  List<order_line_item__c>();
        List<order_line_item__c> ListToUpdateOli = new  List<order_line_item__c>();
        List<customer_POE__c> ListToUpdatePax = new  List<customer_POE__c>();
        List<AddOn__c> ListToUpdateAddon = new  List<AddOn__c>();
        List<AddOn__c> ListToDeleteAddon = new  List<AddOn__c>();
        Set<Id> updatedpaxIds = new Set<id>();
        String soql = TAD_SplitOliForMultiplePaxController.getCreatableFieldsSOQL('order_line_item__c','id='+'\''+ oliId + '\'' );
        system.debug('soql '+soql);
        order_line_item__c oli = (order_line_item__c)Database.query(soql);
        system.debug('oli here after query '+oli);
        String numbervalue = String.valueOf( Integer.valueOf(oli.PAX_Qty__c - cusIds.size()));
        oli.PAX_Quantity__c = numbervalue;
        oli.Quantity__c=numbervalue;
        oli.Pricing_Model__c=oldModel;
        oli.isSplit__c = true;
        ListToUpdateOli.add(oli);
        
        List<Allocation__c> accList = new List<Allocation__c>();
        if(allRollback!=''){
            String []  alloList = allRollback.split(';');
            accList = [Select id , Override_Allocation__c from Allocation__c where Id IN: alloList];
        }
        
        if(!ListToUpdateOli.isEmpty()){
            update ListToUpdateOli; 
            if(!accList.isEmpty()){
                orderCancellationFormController.rollbackOverrideAllo(accList);
            }
        }
        
        // Re fire OL sync Process
        Set<id> oliIdSet = new Set<id>();
        Set<id> addonsId = new  Set<id>();
        Set<id> dealIds = new  Set<id>();
        Order_Line_Item__c olRecordForOlSync = [Select id,name, Deal__c ,OLI_Status__c, (Select id,name , AddOn_Status__c  from AddOns__r where (AddOn_Status__c='Active' OR AddOn_Status__c='Secured') ) from Order_Line_Item__c where id =:oliId limit 1];
        oliIdSet.add(olRecordForOlSync.id);
        dealIds.add(olRecordForOlSync.Deal__c);
        
        for(AddOn__c add : olRecordForOlSync.AddOns__r){
            addonsId.add(add.id);
        }
        
        if(oliId!=null && /*PSAG - 341 */ (olRecordForOlSync.OLI_Status__c == 'Active' || olRecordForOlSync.OLI_Status__c == 'Secured')){
            orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliIdSet,dealIds,2);
        }
        if(!addonsId.isEmpty()){
            orderLineRecordsCreationUpdation.createOrderLinesForAddons(addonsId,dealIds);
        } 
        
        //Re-Sync Process ends
        
    }
    
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        
        String selects = '';
        
        if (whereClause == null || whereClause == ''){ return null; }
        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                // field is creatable
                selectFields.add(fd.getName());
                
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
            
        }
        
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        
    }
}