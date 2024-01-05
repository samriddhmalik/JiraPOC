public class flightCustomisation {

    public class CarrierAddon{
        @auraenabled public Id addon{get;set;}
        @auraenabled public string carrier{get;set;}
        @auraenabled public string type{get;set;}
    }
    
    public class AESB{
        @auraenabled public Id Id{get;set;}
        @auraenabled public string name{get;set;}
        @auraenabled public string active{get;set;}
        @auraenabled public string site{get;set;}
    }
    
    public class SubStopover{
        @auraenabled public Id Id{get;set;}
        @auraenabled public string name{get;set;}
        @auraenabled public string active{get;set;}
        @auraenabled public string site{get;set;}
    }
    
    public class AirLineUpgrade{
        @auraenabled public Id Id{get;set;}
        @auraenabled public string name{get;set;}
        @auraenabled public string active{get;set;}
        @auraenabled public string site{get;set;}
    }
    
    @auraenabled(cacheable=true)
    public static deal__c getDealData (string recordId ){
        deal__c deal=[Select id, name from deal__c  where Id=:recordId];
        system.debug('deal__c  '+deal);
        return deal;
    }
    
    @auraenabled(cacheable=true)
    public static list<string> getCarriers (string recordId ){
        list<carrier__c> carr=[Select id, name, carrier_group__c from carrier__c where Deal__c=:recordId ORDER BY carrier_group__c ASC ];
        system.debug('carrier__c '+carr);
        list<string> toReturn = new list<string>();
        for(carrier__c c:carr){
            if(c.carrier_group__c=='Premium Carrier(Either Singapore Airlines, Cathay Pacific, Emirates or Qantas)'){
                if(!toReturn.contains('Premium Carrier')){
                    toReturn.add('Premium Carrier');
                }
            }
            else if(!toReturn.contains(c.carrier_group__c)){              
                toReturn.add(c.carrier_group__c);
            }
            	
        }
        //toReturn = toReturn.sort();
        return toReturn;
    }
    
    @auraenabled(cacheable=true)
    public static list<carrier_addon_junction__c > getCarrierAddons (string recordId ){
        list<carrier_addon_junction__c > caradd=[Select id, name, AE_SB__c, airline_upgrade__c, Carrier__c, Carrier__r.Carrier_group__c,/* stopover__c,*/ sub_stopover__c from carrier_addon_junction__c  where Deal__c=:recordId];
        system.debug('carrier_addon_junction__c  '+caradd);
        return caradd;
    }
    
    @auraenabled(cacheable=true)
    public static list<AESB> getAESB (string recordId ){
        list<AE_SB__c> aesbList=[Select id, name, active__c,site__c from AE_SB__c where Deal__c=:recordId];
        list<AESB> aesb = new list<AESB>();
        for(AE_SB__c a:aesbList){
            AESB as1 = new AESB();
            as1.id = a.id;
            as1.name = a.name;
            if(a.active__c==true){
                as1.active='-active';
            }else{
                  as1.active='-inactive';
                 }
            as1.site='-'+a.site__c;
            aesb.add(as1);
        }
        system.debug('aesb '+aesb);
        return aesb;
    }
    
    @auraenabled(cacheable=true)
    public static list<AirLineUpgrade> getAirLineUpgrade (string recordId ){
        list<airline_upgrade__c> airlineUpgradeList=[Select id, name, active__c, site__c from airline_upgrade__c where Deal__c=:recordId];
        list<AirLineUpgrade> airlineUpgrade = new list<AirLineUpgrade>();
        for(airline_upgrade__c a:airlineUpgradeList){
            AirLineUpgrade au = new AirLineUpgrade();
            au.id = a.id;
            au.name = a.name;
            if(a.active__c==true){
                au.active='-active';
            }else{
                  au.active='-inactive';
                 }
            au.site='-'+a.site__c;
            airlineUpgrade.add(au);
        }
        system.debug('airlineUpgrade '+airlineUpgrade);
        return airlineUpgrade;
    }
    
   /* @auraenabled(cacheable=true)
    public static list<stopover__c> getStopOver (string recordId ){
        list<stopover__c> stopOver=[Select id, name from stopover__c where Deal__c=:recordId];
        system.debug('stopOver '+stopOver);
        return stopOver;
    }*/
    
    @auraenabled(cacheable=true)
    public static list<SubStopover> getSubStopOver (string recordId ){
        list<sub_stopover__c> substopOverList=[Select id, name, active__c, site__c from sub_stopover__c where Deal__c=:recordId];
        list<SubStopover> substopOver = new list<SubStopover>();
        for(sub_stopover__c s:substopOverList){
            SubStopover sst = new SubStopover();
            sst.id = s.id;
            sst.name = s.name;
            if(s.active__c==true){
                sst.active='-active';
            }else{
                  sst.active='-inactive';
                 }
            sst.site='-'+s.site__c;
            substopOver.add(sst);
        }
        system.debug('sub_stopover__c '+substopOver);
        return substopOver;
    } 
    @auraenabled()
    public static Boolean saveRecords (list<CarrierAddon>saveList, string recordId ){
        system.debug('saveList15 '+saveList);
        list<carrier__c> carList = [Select id, name, Carrier_Group__c, Carrier_Price__c from carrier__c where Deal__c=:recordId];
        system.debug('carList17 '+carList);
        list<Carrier_Addon_Junction__c> toSave = new list<Carrier_Addon_Junction__c>();
        for(CarrierAddon ca:saveList){
            for(carrier__c car:carList){
                if(ca.carrier == car.Carrier_Group__c){
                    Carrier_Addon_Junction__c caj = new Carrier_Addon_Junction__c();
                    caj.Deal__c = recordId;
                    caj.carrier__c = car.id;
                    if(ca.type=='aesb'){
                        caj.AE_SB__c = ca.addon;
                    }
                    else if(ca.type=='stopOver'){
                        //caj.stopover__c = ca.addon;
                        caj.sub_stopover__c = ca.addon;
                    }else if(ca.type == 'airlineUpgrade'){
                        caj.airline_upgrade__c = ca.addon;
                    }
                    toSave.add(caj);
                }
            }
        }
        system.debug('toSave '+toSave);
        try{
            database.insert(toSave);
            return true;
        }catch(exception e){
            system.debug('an exception occurred '+e.getMessage());
            return false;
        }
        
    }
    
    @auraenabled()
    public static Boolean deleteRecords (list<CarrierAddon>delList, string recordId ){
        system.debug('delList15 '+delList);
        list<carrier__c> carList = [Select id, name, Carrier_Group__c, Carrier_Price__c from carrier__c where Deal__c=:recordId];
        system.debug('carList17 '+carList);
        list<Carrier_Addon_Junction__c> todelete = new list<Carrier_Addon_Junction__c>();
        list<Carrier_Addon_Junction__c> CarAddList = [Select id, name, Deal__c, carrier__c, carrier__r.carrier_group__c, AE_SB__c,/* stopover__c,*/ sub_stopover__c, airline_upgrade__c from Carrier_Addon_Junction__c where deal__c=:recordId];
        for(CarrierAddon ca:delList){
            for(Carrier_Addon_Junction__c cad:CarAddList){
                if(ca.type=='aesb'){
                    if(cad.carrier__r.carrier_group__c==ca.carrier && cad.AE_SB__c==ca.addon){
                        if(!todelete.contains(cad))
                        todelete.add(cad);
                    }
                }else if(ca.type=='stopOver'){
                    if(cad.carrier__r.carrier_group__c==ca.carrier && cad.sub_stopover__c==ca.addon){
                        if(!todelete.contains(cad))
                        todelete.add(cad);
                    }
                }else if(ca.type=='airlineUpgrade'){
                    if(cad.carrier__r.carrier_group__c==ca.carrier && cad.airline_upgrade__c==ca.addon){
                        if(!todelete.contains(cad))
                        todelete.add(cad);
                    }
                }              
            }
        }
        system.debug('toDelete '+todelete);
        try{
            database.delete(todelete);
            return true;
        }catch(exception e){
            system.debug('an exception occurred '+e.getMessage());
            return false;
        }
    }
    
}