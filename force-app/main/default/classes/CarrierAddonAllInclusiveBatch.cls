global class CarrierAddonAllInclusiveBatch implements Database.Batchable<sObject>  {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select id , name  from deal__c where id not in(select deal__c from carrier__c)]);
    }

    global void execute(Database.BatchableContext bc, List<deal__c> scope) {
		list<carrier__c> carrierToInsert = new list<carrier__c>();
        set<id> dealId = new set<id>();
        for(deal__c d:scope){
            system.debug('d '+d);
            carrier__c c=new carrier__c();
			c.deal__c = d.id;
			c.Carrier_Group__c = 'All Inclusive Airlines';
			carrierToInsert.add(c);  
            dealId.add(d.id);
        }
        insert carrierToInsert;
        list<ae_sb__c> aesb = [Select id, name, deal__c from ae_sb__c where deal__c in:dealId];
        list<sub_stopover__c> substopover = [Select id, name, deal__c from sub_stopover__c where deal__c in:dealId];
        list<airline_upgrade__c> aup = [Select id, name, deal__c from airline_upgrade__c where deal__c in:dealId];
        
        list<carrier_addon_junction__c> caj = new list<carrier_addon_junction__c>();
        //aesb type carrier addon junction
        for(carrier__c ca1:carrierToInsert){
            for(ae_sb__c a:aesb){
                if(ca1.Deal__c==a.deal__c){
                    carrier_addon_junction__c c1 = new carrier_addon_junction__c();
                	c1.Deal__c = a.deal__c;
                    c1.ae_sb__c = a.id;
                    c1.Carrier__c = ca1.Id;
                    caj.add(c1);
                }
            }
        }
        //substopover type caj
        for(carrier__c ca2:carrierToInsert){
            for(sub_stopover__c ss:substopover){
                if(ca2.Deal__c==ss.deal__c){
                    carrier_addon_junction__c c2 = new carrier_addon_junction__c();
                	c2.Deal__c = ss.deal__c;
                    c2.sub_stopover__c = ss.id;
                    c2.Carrier__c = ca2.Id;
                    caj.add(c2);
                }
            }
        }
        //airlineupgrade type caj
        for(carrier__c ca3:carrierToInsert){
            for(airline_upgrade__c au:aup){
                if(ca3.Deal__c==au.deal__c){
                    carrier_addon_junction__c c3 = new carrier_addon_junction__c();
                	c3.Deal__c = au.deal__c;
                    c3.airline_upgrade__c = au.id;
                    c3.Carrier__c = ca3.Id;
                    caj.add(c3);
                }
            }
        }
        insert caj;
    }

    global void finish(Database.BatchableContext bc) {

    }
}