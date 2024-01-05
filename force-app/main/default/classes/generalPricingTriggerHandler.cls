public class generalPricingTriggerHandler {
    
    public static void updateRollUpValues(List<General_Pricing__c> gpRecords){
        
        Set<id> subOptionIds = new Set<id>();
        Set<id> depDateIds = new Set<id>();
        Set<id> depCityIds = new Set<id>();
        Set<id> airlineUpgradeIds = new Set<id>();
        Set<id> landActivityIds = new Set<id>();
        Set<id> aesbIds = new Set<id>();
        Set<id> stopOverIds = new Set<id>();
        Set<id> activeGpIds = new Set<id>();
        Map<id,General_Pricing__c> recordVsPricing = new  Map<id,General_Pricing__c>();
        
        for(General_Pricing__c gp : gpRecords){
            activeGpIds.add(gp.id);
            // GP for sub-option
            if(gp.Sub_Options__c !=null){
                subOptionIds.add(gp.Sub_Options__c);
                recordVsPricing.put(gp.Sub_Options__c,gp);                
            }
            
            // GP for depdate
            if(gp.Departures_dates__c  !=null){
                depDateIds.add(gp.Departures_dates__c);
                recordVsPricing.put(gp.Departures_dates__c,gp);                
            }
            // GP for depCity
            if(gp.Departure_City__c  !=null){
                depCityIds.add(gp.Departure_City__c);
                recordVsPricing.put(gp.Departure_City__c,gp);                
            }
            // GP for Airline Upgrade
            if(gp.Airline_Upgrade__c != null){
                airlineUpgradeIds.add(gp.Airline_Upgrade__c);
                recordVsPricing.put(gp.Airline_Upgrade__c,gp);
            }
            // GP for Airline Upgrade
            if(gp.Sub_Stopover__c != null){
                stopOverIds.add(gp.Sub_Stopover__c);
                recordVsPricing.put(gp.Sub_Stopover__c,gp);
            }
            // GP for Land Activity
            if(gp.Land_Activity__c != null){
                landActivityIds.add(gp.Land_Activity__c);
                recordVsPricing.put(gp.Land_Activity__c,gp);
            }
            // GP for AE/SB
             if(gp.AE_SB__c != null){
                aesbIds.add(gp.AE_SB__c);
                recordVsPricing.put(gp.AE_SB__c,gp);
            }
            
        }
        
        // GP Sub Option Logic
        if(!subOptionIds.isEmpty()){
            list<Sub_Options__c> subList = [Select id, Price1__c ,solo_surcharge__c  ,price_nz__c ,solo_surcharge_nz__c  from Sub_Options__c where id in:subOptionIds];
            System.debug('subList'+subList);
            for(Sub_Options__c sub : subList){
                sub.Price1__c=recordVsPricing.get(sub.id).Price_AUD__c;
                sub.solo_surcharge__c=recordVsPricing.get(sub.id).Solo_Surcharge_AUD__c ;
                sub.price_nz__c=recordVsPricing.get(sub.id).Price_NZD__c ;
                sub.solo_surcharge_nz__c=recordVsPricing.get(sub.id).Solo_Surcharge_NZD__c ;
            }
            
            update subList;
            
        }
        
        // GP Dep Date Logic
        if(!depDateIds.isEmpty()){
            list<Departures_dates__c> depList = [Select id, HSS_amount__c ,HSS_Cost__c  ,HSS_amount_nz__c,HSS__c,HSS_nz__c  from Departures_dates__c where id in:depDateIds];
            System.debug('depList'+depList);
            for(Departures_dates__c dep : depList){
                dep.HSS_amount__c=recordVsPricing.get(dep.id).HSS_Amount__c ;
                dep.HSS_Cost__c =recordVsPricing.get(dep.id).HSS_Cost__c ;
                dep.HSS_amount_nz__c =recordVsPricing.get(dep.id).HSS_Amount_NZ__c ;
                if(recordVsPricing.get(dep.id).HSS_Cost__c !=0){
                    dep.HSS__c = true;
                }else{
                    dep.HSS__c = false;
                }
                
                if(recordVsPricing.get(dep.id).HSS_Amount_NZ__c !=0){
                    dep.HSS_nz__c = true;
                }else{
                    dep.HSS_nz__c = false;
                }
                
            }
            update depList;
        }
        //GP DepCity logic
        if(!depCityIds.isEmpty()){
            list<departure_cities__c> depCityList = [Select id, Surcharge__c ,surcharge_nz__c from departure_cities__c where id in:depCityIds];
            for(departure_cities__c depCity :depCityList){
                depCity.Surcharge__c = recordVsPricing.get(depCity.id).Surcharge_AUD__c ;
                depCity.surcharge_nz__c = recordVsPricing.get(depCity.id).Surcharge_NZD__c ;
            }
            update depCityList;
        }
        // GP Airline Upgrade logic
        if(!airlineUpgradeIds.isEmpty()){
            list<airline_upgrade__c> airlineUpgradeList = [select id, price__c,price_nz__c from airline_upgrade__c where id In :airlineUpgradeIds];
            for(airline_upgrade__c au :airlineUpgradeList){
                au.price__c = recordVsPricing.get(au.id).Price_Airline_upgrade__c ;
                au.price_nz__c = recordVsPricing.get(au.id).Price_Airline_upgrade_NZD__c ;
            }
            update airlineUpgradeList;
        }
        // GP Stopover logic
        if(!stopOverIds.isEmpty()){
            list<sub_stopover__c> stopoverList = [select Price_Solo__c, Price__c,site__c,price_nz__c,Price_Solo_nz__c from sub_stopover__c where id In: stopOverIds];
            for(sub_stopover__c st :stopoverList){
                if(st.site__c!=null){
                if(st.site__c.contains('AU')){
                st.Price_Solo__c = recordVsPricing.get(st.id).Stopover_Solo_Price__c;
                st.Price__c = recordVsPricing.get(st.id).Stopover_Twin_Price__c;
                }
                    if(st.site__c.contains('NZ')){
                    st.Price_Solo_nz__c = recordVsPricing.get(st.id).Stopover_Solo_Price__c;
                    st.price_nz__c = recordVsPricing.get(st.id).Stopover_Twin_Price__c;
                }
            }
            }
            update stopoverList;
        }
        // GP Land Actiity logic
        if(!landActivityIds.isEmpty()){
            list<land_activity__c> laList = [select solo_price__c, price__c,site__c,price_nz__c,solo_price_nz__c from land_activity__c where id In: landActivityIds];
            for(land_activity__c la :laList){
                if(la.site__c!=null){
                if(la.site__c.contains('AU')){
                la.solo_price__c = recordVsPricing.get(la.id).LA_Solo_Price__c;
                la.price__c = recordVsPricing.get(la.id).LA_Twin_Price__c;
                }
                if(la.site__c.contains('NZ')){
                    la.solo_price_nz__c = recordVsPricing.get(la.id).LA_Solo_Price__c;
                    la.price_nz__c = recordVsPricing.get(la.id).LA_Twin_Price__c;
                }
               }
            }
            update laList;
        }
        // GP AE/SB logic
        if(!aesbIds.isEmpty()){
            list<AE_SB__c> aesbList = [select id, price__c,price_nz__c,site__c from AE_SB__c where id In :aesbIds];
            for(AE_SB__c aesb :aesbList){
                if(aesb.site__c!=null){
                aesb.price__c = recordVsPricing.get(aesb.id).AE_SB_Price__c ;
                aesb.price_nz__c = recordVsPricing.get(aesb.id).AE_SB_Price_NZD__c ;
                }
            }
            update aesbList;
        }
        
        // deactivate other active General Pricing
        Map<id,General_Pricing__c> gpRecordsToDeActivate = new Map<id,General_Pricing__c>();
        
        if(!gpRecords.isEmpty()){
            List<General_Pricing__c>  gpToUncheck = [Select id,Active__c from General_Pricing__c where (Sub_Options__c IN:subOptionIds or Departures_dates__c IN:depDateIds or Departure_City__c IN:depCityIds or Airline_Upgrade__c IN:airlineUpgradeIds or Sub_Stopover__c IN: stopOverIds or Land_Activity__c IN:landActivityIds or AE_SB__c IN:aesbIds) and  Active__c=true and id NOT IN: activeGpIds ];
            if(!gpToUncheck.isEmpty()){
                for(General_Pricing__c gp : gpToUncheck){
                    gp.Active__c=false;
                    gpRecordsToDeActivate.put(gp.id,gp);
                }
            }
        }
        /*
        if(!gpRecords.isEmpty()){
            List<General_Pricing__c>  gpToUncheck = [Select id,Active__c from General_Pricing__c where Departures_dates__c IN:depDateIds and  Active__c=true and id NOT IN: activeGpIds ];
            if(!gpToUncheck.isEmpty()){
                for(General_Pricing__c gp : gpToUncheck){
                    gp.Active__c=false;
                    gpRecordsToDeActivate.put(gp.id,gp);
                }
            }
        } 
        if(!gpRecords.isEmpty()){
            List<General_Pricing__c>  gpToUncheck = [Select id,Active__c from General_Pricing__c where Departure_City__c IN:depCityIds and  Active__c=true and id NOT IN: activeGpIds ];
            if(!gpToUncheck.isEmpty()){
                for(General_Pricing__c gp : gpToUncheck){
                    gp.Active__c=false;
                    gpRecordsToDeActivate.put(gp.id,gp);
                }
            }
        } 
        if(!gpRecords.isEmpty()){
            List<General_Pricing__c>  gpToUncheck = [Select id,Active__c from General_Pricing__c where Airline_Upgrade__c IN:airlineUpgradeIds and  Active__c=true and id NOT IN: activeGpIds ];
            if(!gpToUncheck.isEmpty()){
                for(General_Pricing__c gp : gpToUncheck){
                    gp.Active__c=false;
                    gpRecordsToDeActivate.put(gp.id,gp);
                }
            }
        } 
        */
        if(!gpRecordsToDeActivate.Isempty()){
            update gpRecordsToDeActivate.values();
        }
        
    }
    
    /*
    public static void deactivateDepDateRecord(Set<String> gpListDep){
        
        List<Departures_dates__c> depDateDisableHss = [Select id,name,(Select id from General_Pricings__r where Active__c= true)  from Departures_dates__c where id IN:gpListDep and (HSS__c=true OR HSS_nz__c=true) ];
        
        Integer gpRecordsSize;
        
        for(String depDate : depDateDisableHss ){
            
            gpRecordsSize = depDate.General_Pricings__r.size();
          
            if(){
                
                
                
            }
        }
        
        
    } */
    
}