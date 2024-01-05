public class cloneDealRecords {
    
   public class recordDataWrapper{
        @AuraEnabled  public string dealId {get;set;}
        @AuraEnabled  public string dealName {get;set;}
   }
    
    @AuraEnabled
    public static recordDataWrapper cloneDealApex (String recId){
        
        // Create Deal Record
        String dealSoql = getCreatableFieldsSOQL('Deal__c','id='+'\''+ recId + '\'' );
        Deal__c dealRec = (Deal__c)Database.query(dealSoql);        
        Deal__c dealRecToInsert = dealRec.clone(false, true);
        dealRecToInsert.ownerId  =userinfo.getUserId();
        dealRecToInsert.Cloned_From__c =recId;
        dealRecToInsert.Deal_Status__c ='On Hold'; 
        dealRecToInsert.Status__c='Pending';
        dealRecToInsert.Status_NZ__c='Pending';
        dealRecToInsert.URL__c =null;
        if(test.isRunningTest()){
           dealRecToInsert.name='8455'; 
        }
        insert dealRecToInsert;
        
        Deal__c dealNew = [Select id,name from Deal__c where id =:dealRecToInsert.id];
        recordDataWrapper data = new recordDataWrapper();
        data.dealId =dealNew.id;
        data.dealName =dealNew.name;
        
        // Create Option Record
        
        Map<id,options__c>opToInsert = new Map<id,options__c>();
        
        String optionSoql = getCreatableFieldsSOQL('options__c','Active__c  =true and Deal__c='+'\''+ recId + '\'' );
        List<options__c> OptionRec = (List<options__c>)Database.query(optionSoql);
        
        for(options__c opp :OptionRec ){
            options__c inst = opp.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            inst.Cloned_From__c =opp.id;
            opToInsert.put(opp.id,inst);
        }        
        
        Database.insert (opToInsert.values(),false );
        // Create Sub Option Record
        
        Map<id,sub_options__c>subOpToInsert = new Map<id,sub_options__c>();
        
        String subOptionSoql = getCreatableFieldsSOQL('sub_options__c','Active__c  =true and options__r.Deal__c='+'\''+ recId + '\'' );
        List<sub_options__c> subOptionRec = (List<sub_options__c>)Database.query(subOptionSoql);

        for(sub_options__c sub :subOptionRec ){
            sub_options__c inst = sub.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            inst.options__c = opToInsert.get(sub.options__c).id;
            inst.Cloned_From__c =sub.id;
            subOpToInsert.put(sub.id,inst);
        }        
        
        Database.insert (subOpToInsert.values(),false );
        
        // Create Departure City Record
        
        Map<id,departure_cities__c	>depCityToInsert = new Map<id,departure_cities__c	>();
        
        String depCitySoql = getCreatableFieldsSOQL('departure_cities__c','Active__c  =true and  Deal__c='+'\''+ recId + '\'' );
        List<departure_cities__c	> depCityRec = (List<departure_cities__c	>)Database.query(depCitySoql);
        
        for(departure_cities__c	 dep :depCityRec ){
            departure_cities__c	 inst = dep.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            depCityToInsert.put(dep.id,inst);
        }        
        
        Database.insert (depCityToInsert.values(),false );
        
               
        // Create Itinerary Activity Records
        Map<id,Itinerary_Activity__c > itiActToInsert = new Map<id,Itinerary_Activity__c >();
        
        String itiActSoql = getCreatableFieldsSOQL('Itinerary_Activity__c','deal__c='+'\''+ recId + '\'' );
        List<Itinerary_Activity__c> itiActRec = (List<Itinerary_Activity__c>)Database.query(itiActSoql);
        
        for(Itinerary_Activity__c itiAct :itiActRec ){
            Itinerary_Activity__c  inst = itiAct.clone(false, true);
            inst.name__c ='testRec'+itiAct.name;
            inst.deal__c  = dealRecToInsert.id;
            inst.ownerId  =userinfo.getUserId();
            itiActToInsert.put(itiAct.id,inst);
        }        
        System.debug('itiActivity'+itiActToInsert);
        
        Database.insert (itiActToInsert.values(),false );
        
        
        // Create Itinerary Records
        Map<id,Itinerary__c> itiToInsert = new Map<id,Itinerary__c>();
        
        String itiSoql = getCreatableFieldsSOQL('Itinerary__c','Deal__c='+'\''+ recId + '\'' );
        List<Itinerary__c> itiRec = (List<Itinerary__c>)Database.query(itiSoql);
        
        for(Itinerary__c iti :itiRec ){
            Itinerary__c   inst = iti.clone(false, true);
            inst.Deal__c  = dealRecToInsert.id;
            inst.ownerId  =userinfo.getUserId();
            inst.itinerary_activity__c    = iti.itinerary_activity__c  !=null ? itiActToInsert.get(iti.itinerary_activity__c).id  : null;
            itiToInsert.put(iti.id,inst);
        }        
        
        Database.insert (itiToInsert.values(),false );
        
        // Create Land Activity Record
        
        Map<id,land_activity__c>landActivityToInsert = new Map<id,land_activity__c>();
        
        String landSoql = getCreatableFieldsSOQL('land_activity__c','Active__c  =true and Deal__c='+'\''+ recId + '\'' );
        List<land_activity__c> landRec = (List<land_activity__c>)Database.query(landSoql);
        
        for(land_activity__c land :landRec ){
            land_activity__c inst = land.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            inst.itinerary_activity__c    = land.itinerary_activity__c  !=null ? itiActToInsert.get(land.itinerary_activity__c).id  : null;
            landActivityToInsert.put(land.id,inst);
        }        
        
        Database.insert (landActivityToInsert.values(),false );
        
        // Create AE/SB Record
        
        Map<id,AE_SB__c >aesbToInsert = new Map<id,AE_SB__c >();
        
        String aesbSoql = getCreatableFieldsSOQL('AE_SB__c','Active__c  =true and   linked_deal__c='+'\''+ recId + '\'' );
        List<AE_SB__c > aesbRec = (List<AE_SB__c >)Database.query(aesbSoql);
        System.debug('aesbRec'+aesbRec);
        for(AE_SB__c  aesb :aesbRec ){
            AE_SB__c  inst = aesb.clone(false, true);
            inst.name__c ='testRec'+aesb.name;
            inst.linked_deal__c = dealRecToInsert.id;
            inst.Deal__c =aesb.Deal__c!=null ?dealRecToInsert.id : null  ;
            inst.Option__c  = aesb.Option__c  !=null?opToInsert.get(aesb.Option__c ).id  : null;
            inst.ownerId  =userinfo.getUserId();
            aesbToInsert.put(aesb.id,inst);
        }  
             
        Database.insert (aesbToInsert.values(),false );

        // Create Airline Upgrade Record
        
        Map<id,airline_upgrade__c>airlineToInsert = new Map<id,airline_upgrade__c>();
        
        String airlineSoql = getCreatableFieldsSOQL('airline_upgrade__c','Active__c  =true and   Deal__c='+'\''+ recId + '\'' );
        List<airline_upgrade__c> airlineRec = (List<airline_upgrade__c>)Database.query(airlineSoql);
        
        for(airline_upgrade__c  air :airlineRec ){
            airline_upgrade__c  inst = air.clone(false, true);
            inst.name='testRec'+air.name;
            inst.Deal__c = dealRecToInsert.id;
            airlineToInsert.put(air.id,inst);
        }        
        
         Database.insert (airlineToInsert.values(),false );

        //Create Attached inclusion
        
        Map<id,Attached_Inclusions__c > attIncToInsert = new Map<id,Attached_Inclusions__c >();
        
        String attIncSoql = getCreatableFieldsSOQL('Attached_Inclusions__c','Deal__c='+'\''+ recId + '\'' );
        List<Attached_Inclusions__c > attIncRec = (List<Attached_Inclusions__c >)Database.query(attIncSoql);
        
        for(Attached_Inclusions__c   air :attIncRec ){
            Attached_Inclusions__c   inst = air.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            attIncToInsert.put(air.id,inst);
        }        
        
         Database.insert (attIncToInsert.values(),false );
        
        // Create stopover Record
        
        Map<id,stopover__c >stopOverToInsert = new Map<id,stopover__c >();
        
        String stopSoql = getCreatableFieldsSOQL('stopover__c','Deal__c='+'\''+ recId + '\'' );
        List<stopover__c > stopRec = (List<stopover__c >)Database.query(stopSoql);
        
        for(stopover__c  stop :stopRec ){
            stopover__c  inst = stop.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            stopOverToInsert.put(stop.id,inst);
        }        
        
        Database.insert (stopOverToInsert.values(),false );
        
        // Create subStopOver Record
        
        Map<id,sub_stopover__c  >subStopOverToInsert = new Map<id,sub_stopover__c >();
        
        String subStopSoql = getCreatableFieldsSOQL('sub_stopover__c','Active__c  =true and   Deal__c='+'\''+ recId + '\'' );
        List<sub_stopover__c > subStopRec = (List<sub_stopover__c >)Database.query(subStopSoql);
        
        for(sub_stopover__c  sub :subStopRec ){
            sub_stopover__c  inst = sub.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            inst.ownerId  =userinfo.getUserId();
            inst.stopover__c = stopOverToInsert.get(sub.stopover__c)!=null?stopOverToInsert.get(sub.stopover__c).id : null;
            subStopOverToInsert.put(sub.id,inst);
        }        
        
        Database.insert (subStopOverToInsert.values(),false );
        
        // Stopover DepartureCity
        Map<id,StopOver_Departure_Cities__c >stopCityToInsert = new Map<id,StopOver_Departure_Cities__c  >();
        
        String stopCitySoql = getCreatableFieldsSOQL('StopOver_Departure_Cities__c','ordexp_sub_stopover__r.Deal__c='+'\''+ recId + '\'' );
        List<StopOver_Departure_Cities__c> stopCityRec = (List<StopOver_Departure_Cities__c>)Database.query(stopCitySoql);
        
        for(StopOver_Departure_Cities__c  stopCity :stopCityRec ){
            StopOver_Departure_Cities__c  inst = stopCity.clone(false, true);
            inst.ordexp_departure_cities__c = depCityToInsert.get(stopCity.ordexp_departure_cities__c)!=null?depCityToInsert.get(stopCity.ordexp_departure_cities__c).id : null;
            inst.ordexp_sub_stopover__c   = subStopOverToInsert.get(stopCity.ordexp_sub_stopover__c)!=null?subStopOverToInsert.get(stopCity.ordexp_sub_stopover__c).id : null;
            stopCityToInsert.put(stopCity.id,inst);
        }        
        
        Database.insert (stopCityToInsert.values(),false );
        
        
        // Create Cancellation Policy
        Map<id,Cancellation_Policy__c> canPolicyInsert = new Map<id,Cancellation_Policy__c>();
        
        String canPolicySoql = getCreatableFieldsSOQL('Cancellation_Policy__c','Deal__c='+'\''+ recId + '\'' );
        List<Cancellation_Policy__c> canPolicyRec = (List<Cancellation_Policy__c>)Database.query(canPolicySoql);
        
        for(Cancellation_Policy__c  canPolicy :canPolicyRec ){
            Cancellation_Policy__c   inst = canPolicy.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            canPolicyInsert.put(canPolicy.id,inst);
        }        
        
        Database.insert (canPolicyInsert.values(),false );
        
        // Create Cancellation Policy Terms
        Map<id,Policy_Term__c > canPolicyTermInsert = new Map<id,Policy_Term__c >();
        
        String canPolicyTermSoql = getCreatableFieldsSOQL('Policy_Term__c','Cancellation_Policy__r.Deal__c='+'\''+ recId + '\'' );
        List<Policy_Term__c > canPolicyTermRec = (List<Policy_Term__c >)Database.query(canPolicyTermSoql);
        
        for(Policy_Term__c   canPolicyTerm :canPolicyTermRec ){
            Policy_Term__c    inst = canPolicyTerm.clone(false, true);
            inst.Cancellation_Policy__c = canPolicyTerm.Cancellation_Policy__c  !=null?canPolicyInsert.get(canPolicyTerm.Cancellation_Policy__c).id  : null;
            canPolicyTermInsert.put(canPolicyTerm.id,inst);
        }        
        
        Database.insert (canPolicyTermInsert.values(),false );


        // Create Media Records
        Map<id,media__c > mediaToInsert = new Map<id,media__c >();
        
        String mediaSoql = getCreatableFieldsSOQL('media__c','Deal__c='+'\''+ recId + '\'' );
        List<media__c> mediaRec = (List<media__c>)Database.query(mediaSoql);
        
        for(media__c   media :mediaRec ){
            media__c   inst = media.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            mediaToInsert.put(media.id,inst);
        }        
        
        Database.insert (mediaToInsert.values(),false );
        
        
        // Clone Files and Attachment
        List<ContentDocumentLink> toBeClonedContentDocumentLinks = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink where LinkedEntityId=:recId];
        for(ContentDocumentLink cdl : toBeClonedContentDocumentLinks){
            cdl.Id=null;
            cdl.LinkedEntityId = dealRecToInsert.id;
        }
        
        insert toBeClonedContentDocumentLinks;
        
        // Clone Deal Draft Record
        Map<id,Deal_Draft__c  > draftToInsert = new Map<id,Deal_Draft__c  >();
        
        String draftSoql = getCreatableFieldsSOQL('Deal_Draft__c','Deal__c='+'\''+ recId + '\'' );
        List<Deal_Draft__c > draftRec = (List<Deal_Draft__c >)Database.query(draftSoql);
        
        for(Deal_Draft__c    draft :draftRec ){
            Deal_Draft__c    inst = draft.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            draftToInsert.put(draft.id,inst);
        }        
        
        Database.insert (draftToInsert.values(),false );
        
        // Clone Deal Team
        Map<id,Deal_Team__c> dealTeamToInsert = new Map<id,Deal_Team__c>();
        
        String dealTeamSoql = getCreatableFieldsSOQL('Deal_Team__c','Deal__c='+'\''+ recId + '\'' );
        List<Deal_Team__c > dealTeamRec = (List<Deal_Team__c>)Database.query(dealTeamSoql);
        
        for(Deal_Team__c  team :dealTeamRec ){
            Deal_Team__c  inst = team.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            dealTeamToInsert.put(team.id,inst);
        }        
        
        Database.insert (dealTeamToInsert.values(),false );
        
        // Clone Deal Contacts
        Map<id,Deal_Contacts__c > dealConToInsert = new Map<id,Deal_Contacts__c >();
        
        String dealConSoql = getCreatableFieldsSOQL('Deal_Contacts__c','Deal__c='+'\''+ recId + '\'' );
        List<Deal_Contacts__c  > dealConRec = (List<Deal_Contacts__c >)Database.query(dealConSoql);
        
        for(Deal_Contacts__c   dealCon :dealConRec ){
            Deal_Contacts__c   inst = dealCon.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            dealConToInsert.put(dealCon.id,inst);
        }        
        
        Database.insert (dealConToInsert.values(),false );
        
        // Clone Deal Transfers
        Map<id,Transfer__c> transferToInsert = new Map<id,Transfer__c>();
        
        String transferSoql = getCreatableFieldsSOQL('Transfer__c','Deal__c='+'\''+ recId + '\'' );
        List<Transfer__c> transferRec = (List<Transfer__c>)Database.query(transferSoql);
        
        for(Transfer__c  transfer :transferRec ){
            Transfer__c  inst = transfer.clone(false, true);
            inst.Deal__c = dealRecToInsert.id;
            transferToInsert.put(transfer.id,inst);
        }        
        
        Database.insert (transferToInsert.values(),false );
        
        
        // Create Allocation Records
         
        
        String statusDD = 'Online' ; 
       /* Map<id,Allocation__c  > alloToInsert = new Map<id,Allocation__c  >();
        
        String alloSoql = getCreatableFieldsSOQL('Allocation__c','departure_date__c >' + String.valueOf(Date.today()).removeEnd(' 00:00:00')  +'  AND deal__c='+'\''+ recId + '\''  );
        system.debug('alloSoql'+alloSoql);
        List<Allocation__c> alloRec = (List<Allocation__c>)Database.query(alloSoql);
        
        for(Allocation__c  allo :alloRec ){
            Allocation__c  inst = allo.clone(false, true);
            inst.name__c ='testRec'+allo.name;
            inst.deal__c = dealRecToInsert.id;
            inst.ownerId  =userinfo.getUserId();
            alloToInsert.put(allo.id,inst);
        }        
        
        Database.insert (alloToInsert.values(),false );*/

        // Create Component Record
        Map<id,Component__c  >compToInsert = new Map<id,Component__c  >();
        
        String compSoql = getCreatableFieldsSOQL('Component__c','LinkedDeal_D_O_S__c='+'\''+ recId + '\'' );
        List<Component__c  > compRec = (List<Component__c  >)Database.query(compSoql);
        
        for(Component__c   comp :compRec ){
            
            if( (comp.Deal__c!=null) || (comp.Options__c !=null && opToInsert.get(comp.Options__c)!=null ) || (comp.Sub_Options__c !=null && subOpToInsert.get(comp.Sub_Options__c)!=null ) 
              || (comp.AE_SB__c  !=null && aesbToInsert.get(comp.AE_SB__c)!=null ) || (comp.City__c  !=null && depCityToInsert.get(comp.City__c)!=null ) || (comp.Land_Activity__c  !=null && landActivityToInsert.get(comp.Land_Activity__c)!=null )
              || (comp.Stopover__c  !=null && subStopOverToInsert.get(comp.Stopover__c)!=null ) || (comp.Airline_Upgrade__c  !=null && airlineToInsert.get(comp.Airline_Upgrade__c)!=null ) 
              ){
                Component__c   inst = comp.clone(false, true);
                String compName = 'testRec'+comp.name;
                Integer length = compName.length();
                inst.name__c =compName.substring(0,(length-10));
                inst.Deal__c = comp.Deal__c!=null?dealRecToInsert.id  : null;
                inst.Options__c  = comp.Options__c !=null?opToInsert.get(comp.Options__c).id  : null;
                inst.Sub_Options__c   = comp.Sub_Options__c  !=null?subOpToInsert.get(comp.Sub_Options__c).id  : null;
                inst.AE_SB__c   = comp.AE_SB__c  !=null?aesbToInsert.get(comp.AE_SB__c).id  : null;
                inst.City__c   = comp.City__c  !=null?depCityToInsert.get(comp.City__c).id  : null;
                inst.Land_Activity__c   = comp.Land_Activity__c  !=null?landActivityToInsert.get(comp.Land_Activity__c).id  : null;
                inst.Stopover__c   = comp.Stopover__c  !=null?subStopOverToInsert.get(comp.Stopover__c).id  : null;
                inst.Airline_Upgrade__c    = comp.Airline_Upgrade__c   !=null?airlineToInsert.get(comp.Airline_Upgrade__c).id  : null;
                inst.Cancellation_Policy__c = comp.Cancellation_Policy__c  !=null?canPolicyInsert.get(comp.Cancellation_Policy__c).id  : null;
                inst.LinkedDeal_D_O_S__c = dealRecToInsert.id;
                inst.Cloned_From__c =comp.id;
                compToInsert.put(comp.id,inst);  
            }
            
        }        
        Database.executeBatch(new batchToCreateComponentPricing(compToInsert.values()), 1);
        
        // Fire Dep Date Creation
        
        Database.executeBatch(new batchToCreateDepDateCloneDeal(recId), 1);
        
        //Database.insert (compToInsert.values(),false );
        
        // Create Component Pricing
        /*
        Map<id,Component_Pricing__c> compPriceToInsert = new Map<id,Component_Pricing__c>();
        
        String compPriceSoql = getCreatableFieldsSOQL('Component_Pricing__c','LinkedDeal_D_O_S__c='+'\''+ recId + '\'' );
        List<Component_Pricing__c> compPriceRec = (List<Component_Pricing__c>)Database.query(compPriceSoql);
        
        for(Component_Pricing__c   compp :compPriceRec ){
            if(compp.Component__c != null && compToInsert.get(compp.Component__c)!=null){
                Component_Pricing__c   inst = compp.clone(false, true);
                inst.Component__c   = compp.Component__c !=null?compToInsert.get(compp.Component__c).id  : null;
                inst.LinkedDeal_D_O_S__c = dealRecToInsert.id;
                compPriceToInsert.put(compp.id,inst); 
            }
        }        
        
        Database.insert (compPriceToInsert.values(),false );
         */
        
        
        // Create Departure Date Records
       // Map<id,departures_dates__c> depToInsert = new Map<id,departures_dates__c>();      
       // String depSoql = getCreatableFieldsSOQL('departures_dates__c','date__c >'  + String.valueOf(Date.today()).removeEnd(' 00:00:00')  +    '  AND Deal_for_Reporting__c='+'\''+ recId + '\'' + '  AND online_status__c = '+'\''+ statusDD + '\''   );
       // List<departures_dates__c> depRec = (List<departures_dates__c>)Database.query(depSoql);
        
        /*
        for(departures_dates__c  dep :depRec ){
            if( (dep.Deal__c!=null)  || (dep.options__c !=null && opToInsert.get(dep.options__c)!=null ) || (dep.sub_options__c !=null && subOpToInsert.get(dep.sub_options__c)!=null ) ){
                departures_dates__c  inst = dep.clone(false, true);
                //inst.Allocation_Table__c  = dep.Allocation_Table__c !=null?alloToInsert.get(dep.Allocation_Table__c).id  : null;
                inst.Deal__c   = dep.Deal__c  != null ? dealRecToInsert.id:null;
                inst.Deal_for_Reporting__c   = dealRecToInsert.id;
                inst.Linked_Deal_D_O_S__c    = dep.Linked_Deal_D_O_S__c!= null ?dealRecToInsert.id:null;
                inst.options__c   = dep.options__c !=null ? opToInsert.get(dep.options__c).id  : null;
                inst.Cloned_From__c =dep.Allocation_Table__c;
                inst.sub_options__c   = dep.sub_options__c !=null ? subOpToInsert.get(dep.sub_options__c).id  : null;
                inst.ownerId  =userinfo.getUserId();
                depToInsert.put(dep.id,inst);   
            }
        }    */    
        
       // Database.executeBatch(new batchToCreateDepDateCloneDeal(dealNew), 1);
        
        
        return data;
    }
    
    @AuraEnabled
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