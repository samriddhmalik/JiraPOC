global class batchValidateOLIAddonStatus implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        if(test.isRunningTest()){
            return Database.getQueryLocator([select id, Deal_ID_Title__c,ordexp_suboption_amount__c,Total_surcharge__c,HSS_Amount__c,ordexp_city_surcharge_amount__c,Credit_Utilized__c,ordexp_TAD_Order__r.Total_Credit_Remaining__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_status_check__c, ordexp_TAD_Order__r.ordexp_master_status__c,OLI_Status__c,(Select id,AddOn_Status__c,ordexp_amount__c,Credit_Utilized__c  from AddOns__r) from order_line_item__c where ((OLI_Status__c='On Hold' and (ordexp_TAD_Order__r.ordexp_master_status__c ='Secured' or ordexp_TAD_Order__r.ordexp_master_status__c ='In Progress' )) or (OLI_Status__c='Secured' and ordexp_TAD_Order__r.ordexp_master_status__c ='In Progress') or (OLI_Status__c!='Cancelled' and ordexp_TAD_Order__r.ordexp_master_status__c ='Cancelled')) ]);
            
        }else{
            return Database.getQueryLocator([select id, Deal_ID_Title__c,ordexp_suboption_amount__c,Total_surcharge__c,HSS_Amount__c,ordexp_city_surcharge_amount__c,Credit_Utilized__c,ordexp_TAD_Order__r.Total_Credit_Remaining__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_status_check__c, ordexp_TAD_Order__r.ordexp_master_status__c,OLI_Status__c,(Select id,AddOn_Status__c,ordexp_amount__c,Credit_Utilized__c  from AddOns__r) from order_line_item__c where ((OLI_Status__c='On Hold' and (ordexp_TAD_Order__r.ordexp_master_status__c ='Secured' or ordexp_TAD_Order__r.ordexp_master_status__c ='In Progress' )) or (OLI_Status__c='Secured' and ordexp_TAD_Order__r.ordexp_master_status__c ='In Progress') or (OLI_Status__c!='Cancelled' and ordexp_TAD_Order__r.ordexp_master_status__c ='Cancelled')) and Dep_Date__c > today  ]);
            
        }
    }
    
    global void execute(Database.BatchableContext bc,List<order_line_item__c> scope){
        
        order_line_item__c oliRec = scope[0];
        Decimal totalCreditRemaining = oliRec.ordexp_TAD_Order__r.Total_Credit_Remaining__c;
        TAD_Order__c  tadRec = new TAD_Order__c();
        tadRec.id= oliRec.ordexp_TAD_Order__c;
        if(oliRec.ordexp_TAD_Order__r.ordexp_status_check__c == true){
            tadRec.ordexp_status_check__c=false; 
        }else{
            tadRec.ordexp_status_check__c=true;
        }
        update tadRec;
        
        order_line_item__c oliUpdate = new order_line_item__c();
        List<AddOn__c>  addUpdate = new List<AddOn__c> ();
        
        oliUpdate.id=oliRec.id;
        TAD_Order__c getTadOrder = [Select id,ordexp_master_status__c from TAD_Order__c where id =:tadRec.id];
        
        if(getTadOrder.ordexp_master_status__c=='Secured'){
            if(totalCreditRemaining >= (oliRec.ordexp_suboption_amount__c+oliRec.Total_surcharge__c+oliRec.HSS_Amount__c +oliRec.ordexp_city_surcharge_amount__c) && oliRec.OLI_Status__c == 'On Hold'){
                oliUpdate.Credit_Utilized__c = (oliRec.Credit_Utilized__c!=null?oliRec.Credit_Utilized__c:0) + oliRec.ordexp_suboption_amount__c+oliRec.Total_surcharge__c+oliRec.HSS_Amount__c +oliRec.ordexp_city_surcharge_amount__c;
                totalCreditRemaining = totalCreditRemaining - (oliRec.ordexp_suboption_amount__c+oliRec.Total_surcharge__c+oliRec.HSS_Amount__c +oliRec.ordexp_city_surcharge_amount__c);
            }
            oliUpdate.OLI_Status__c='Secured';
            for(AddOn__c add :oliRec.AddOns__r ){
                if(totalCreditRemaining >= add.ordexp_amount__c && add.AddOn_Status__c == 'On Hold'){
                    add.Credit_Utilized__c = (add.Credit_Utilized__c!=null?add.Credit_Utilized__c:0) + add.ordexp_amount__c;
                    totalCreditRemaining = totalCreditRemaining - add.ordexp_amount__c;
                }
               add.AddOn_Status__c='Secured';
                addUpdate.add(add);
            }
        }else if(getTadOrder.ordexp_master_status__c=='In Progress'){
            oliUpdate.OLI_Status__c='Active';
            for(AddOn__c add :oliRec.AddOns__r ){
                add.AddOn_Status__c='Active';
                addUpdate.add(add);
            }
        }else if(getTadOrder.ordexp_master_status__c=='Cancelled'){
            oliUpdate.OLI_Status__c='Cancelled';
            for(AddOn__c add :oliRec.AddOns__r ){
                add.AddOn_Status__c='Cancelled';
                addUpdate.add(add);
            }
        }
        
        update oliUpdate;
        update addUpdate;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}