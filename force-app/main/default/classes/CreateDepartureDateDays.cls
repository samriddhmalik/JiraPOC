public class CreateDepartureDateDays {
    
    public static void createDays(Id ddId){
        
        Set<String> orderStatuses = new Set<String>();
        
        if(test.isRunningTest()){
            orderStatuses.add('On Hold'); 
                }else{
                    orderStatuses.add('In Progress');       
                        }
        Set<String> coachColors = new Set<String>();
        Set<String> subOptionIds = new Set<String>();
        Set<String> siteInfo = new Set<String>();
        
        departures_dates__c dddates = [Select id ,Deal_for_Reporting__r.site__c , Deal_for_Reporting__c ,date__c from departures_dates__c where id=:ddId];
        if(dddates.Deal_for_Reporting__r.site__c.contains('AU')){
            siteInfo.add('AU'); 
        }
        if(dddates.Deal_for_Reporting__r.site__c.contains('NZ')){
            siteInfo.add('NZ'); 
        }
        
        List<order_line_item__c> oliList = [select id ,Sub_Options__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.mp_Coach_Color__c  from order_line_item__c where ordexp_departure_date__c=:ddId];
        
        for(order_line_item__c colors : oliList ){
            coachColors.add(colors.ordexp_TAD_Order__r.mp_Coach_Color__c==null?'None':colors.ordexp_TAD_Order__r.mp_Coach_Color__c);
            subOptionIds.add(colors.Sub_Options__c);   
        }
        
        List<sub_options__c> subOptionsList = [SELECT Id, options__r.itinerary_context__c,itinerary_context__c,hotel_context__c FROM sub_options__c WHERE Id IN:subOptionIds];        
        System.debug('subOptionsList'+subOptionsList);
        List<Itinerary__c> itins = [SELECT Id, Itinerary__c, Day_number__c, hr__c, Min__c, Meals_Included__c, itinerary_context__c, itinerary_activity__c, title__c, body__c, accomodation__c, country_context__c FROM Itinerary__c  WHERE Deal__c = :dddates.Deal_for_Reporting__c Order BY Day_number__c ASC ];
        System.debug('itins'+itins);
        List<Day_POE__c > daysCreated = new List<Day_POE__c >();
        
        Integer dateCounter = 0;
        Date departureDate = dddates.date__c;
        for(String color : coachColors){
            for(sub_options__c so : subOptionsList) {
                for(String site :siteInfo){
                    for(Itinerary__c inIts : itins ){
                        if(inIts.Itinerary__c==so.options__r.itinerary_context__c && inIts.country_context__c==site){
                            date daydate = dddates.date__c.AddDays(dateCounter);
                            Day_POE__c  day = new Day_POE__c ();
                            day.date__c = daydate ;
                            day.departures_dates__c = dddates.id;
                            day.accommodation_class__c = so.hotel_context__c;
                            day.sub_option__c = so.id;
                            day.Coach_Color__c = color;
                            day.Itinerary__c = inIts.id;
                            day.Site__c =site;
                            daysCreated.add(day);
                            
                            dateCounter = dateCounter+1;   
                        }  
                    }
                    dateCounter = 0;
                }
            }  
        }
        
        //System.debug('daysCreated'+daysCreated);        
        insert  daysCreated;
    }  
    
}