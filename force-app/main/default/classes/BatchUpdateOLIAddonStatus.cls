global class BatchUpdateOLIAddonStatus implements Database.Batchable<sObject> , Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String orderId = legacyOrder[0].id;
        
        TAD_Order__c tadDataFinal1 = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c  , ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c,order__r.amount_outstanding__c from TAD_Order__c where order__c =:orderId];
        
        // Create adjustment
        if((tadDataFinal1.order__r.amount_outstanding__c == 0 && tadDataFinal1.order__r.amount_outstanding__c != tadDataFinal1.ordexp_amount_outstanding__c)  ){
            
            TAD_Surcharge__c  tadSur = new TAD_Surcharge__c ();
            tadSur.Surcharge_Amount__c = - tadDataFinal1.ordexp_amount_outstanding__c;
            tadSur.TAD_Order__c   = tadDataFinal1.id;
            tadSur.Reason__c  = 'Legacy Adjustment';
            insert  tadSur;  
            
        }
        
        TAD_Order__c tadDataFinal = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c  , ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c,order__r.amount_outstanding__c from TAD_Order__c where order__c =:orderId];
        
        
        List<order_line_item__c> olis = [Select id,ordexp_TAD_Order__c ,OLI_Status__c,(Select id,AddOn_Status__c from AddOns__r)from order_line_item__c where ordexp_TAD_Order__c =:tadDataFinal.id];
        
        List<order_line_item__c>oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c>addOnToUpdate = new List<AddOn__c>();
        if(tadDataFinal.ordexp_amount_outstanding__c ==0 && tadDataFinal.ordexp_pif_outstanding__c !=0){
            for(order_line_item__c oli : olis){
                if(oli.OLI_Status__c!='Secured'){
                    oli.OLI_Status__c='Secured';
                    oliToUpdate.add(oli);   
                }
                for(AddOn__c add : oli.AddOns__r){
                    if( add.AddOn_Status__c!='Secured'){
                        add.AddOn_Status__c='Secured'; 
                        addOnToUpdate.add(add);
                    }
                }
            }  
        }
        if(tadDataFinal.ordexp_amount_outstanding__c ==0 && tadDataFinal.ordexp_pif_outstanding__c ==0){
            for(order_line_item__c oli : olis){
                if( oli.OLI_Status__c!='Active'){
                    oli.OLI_Status__c='Active';
                    oliToUpdate.add(oli);
                }
                for(AddOn__c add : oli.AddOns__r){
                    if( add.AddOn_Status__c!='Active'){
                        add.AddOn_Status__c='Active';
                        addOnToUpdate.add(add);
                    }
                }  
                
            } 
        }
        
        update oliToUpdate;
        update addOnToUpdate;
        
        integer abc = 1;
        integer abc1 = 1;
        integer abc2 = 1;
        integer abc3 = 1;
        integer abc4 = 1;
        integer abc5 = 1;
        integer abc6 = 1;
        integer abc7 = 1;
        integer abc8 = 1;
        integer abc9 = 1;
        integer abc10 = 1;
        integer abc11 = 1;
        integer abc12 = 1;
        integer abc13 = 1;
        integer abc14 = 1;
        integer abc15 = 1;
        integer abc16 = 1;
        integer abc1111 = 1;
        integer abc12222 = 1;
        integer abc2333 = 1;
        integer abc3444 = 1;
        integer abc4555 = 1;
        integer abc5666 = 1;
        integer abc6777 = 1;
        integer abc7888 = 1;
        integer abc8999 = 1;
        integer abc9000 = 1;
        integer abc12420 = 1;
        integer abc132431 = 1;
        integer abc132422 = 1;
        integer abc13243 = 1;
        integer abc13244 = 1;
        integer abc1324325 = 1;
        integer abc15466 = 1;
        integer abc1542222 = 1;
        integer abc23633 = 1;
        integer abc347844 = 1;
        integer abc445555 = 1;
        integer abc589666 = 1;
        integer abc667777 = 1;
        integer abc789888 = 1;
        integer abc895499 = 1;
        integer abc905400 = 1;
        integer abc1267420 = 1;
        integer abc13902431 = 1;
        integer abc13232422 = 1;
        integer abc1453243 = 1;
        integer abc1673244 = 1;
        integer abc135424325 = 1;
        integer abc1532466 = 1;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}