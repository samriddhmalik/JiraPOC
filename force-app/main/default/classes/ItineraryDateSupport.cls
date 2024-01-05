public class ItineraryDateSupport {

    public Date mainStartDate {get;set;}
    public Date mainEndDate {get;set;}
    public Date preXStartDate {get;set;}
    public Date pstXStartDate {get;set;}
    public Date pstXEndDate {get;set;}
    public Date upgradeStartDate {get;set;}
    public Date upgradeEndDate {get;set;}

    public Integer mainEndNumber {get;set;}
    public Integer preXEndNumber {get;set;}
    public Integer pstXStartNumber {get;set;}
    public Integer pstXEndNumber {get;set;}
    public Integer upgradeStartNumber {get;set;}
    public Integer upgradeEndNumber {get;set;}

    public ItineraryDateSupport(Date departureDate, Map<String,List<Itinerary__c>> itinList, Integer prexCrossoverInteger) {

        for (String s : itinList.keySet()) {
            if (s == 'Pre Extension') {
                if (itinList.get(s).size() > 0) {
                    preXStartDate = departureDate - (itinList.get(s).size() - prexCrossoverInteger);
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            preXEndNumber = endDayNumber;
                        }
                    }
                }
            } else if (s == 'Main Package') {
                if (itinList.get(s).size() > 0) {
                    mainStartDate = departureDate;
                    mainEndDate = departureDate.addDays(itinList.get(s).size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            mainEndNumber = endDayNumber;
                        }
                    }
                }
            } else if (s == 'Post Extension') {
                if (itinList.get(s).size() > 0) {
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c < startDayNumber) {
                            startDayNumber = Integer.valueOf(i.Day_number__c);
                            pstXStartNumber = startDayNumber;
                        } else {
                            pstXStartNumber = startDayNumber;
                        }
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            pstXEndNumber = endDayNumber;
                        } else {
                            pstXEndNumber = endDayNumber;
                        }
                    }
                    pstXStartDate = departureDate.addDays(startDayNumber - 1);
                    pstXEndDate = departureDate.addDays(endDayNumber - 1);
                }
            } else if (s == 'Upgrade') {
                if (itinList.get(s).size() > 0) {
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c < startDayNumber) {
                            startDayNumber = Integer.valueOf(i.Day_number__c);
                            upgradeStartNumber = startDayNumber;
                        }
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            upgradeEndNumber = endDayNumber;
                        }
                    }
                    upgradeStartDate = departureDate.addDays(startDayNumber - 1);
                    upgradeEndDate = departureDate.addDays(endDayNumber - 1);
                }
            }
        }
    }

    public ItineraryDateSupport(Date departureDate, Map<String,List<Itinerary__c>> itinList) {

        for (String s : itinList.keySet()) {
            if (s == 'Pre Extension') {
                if (itinList.get(s).size() > 0) {
                    preXStartDate = departureDate - (itinList.get(s).size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            preXEndNumber = endDayNumber;
                        }
                    }
                }
            } else if (s == 'Main Package') {
                if (itinList.get(s).size() > 0) {
                    mainStartDate = departureDate;
                    mainEndDate = departureDate.addDays(itinList.get(s).size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            mainEndNumber = endDayNumber;
                        }
                    }
                }
            } else if (s == 'Post Extension') {
                if (itinList.get(s).size() > 0) {
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c < startDayNumber) {
                            startDayNumber = Integer.valueOf(i.Day_number__c);
                            pstXStartNumber = startDayNumber;
                        } else {
                            pstXStartNumber = startDayNumber;
                        }
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            pstXEndNumber = endDayNumber;
                        } else {
                            pstXEndNumber = endDayNumber;
                        }
                    }
                    pstXStartDate = departureDate.addDays(startDayNumber - 1);
                    pstXEndDate = departureDate.addDays(endDayNumber - 1);
                }
            } else if (s == 'Upgrade') {
                if (itinList.get(s).size() > 0) {
                    Integer startDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinList.get(s)[0].Day_number__c);
                    for (Itinerary__c i : itinList.get(s)) {
                        if (i.Day_number__c < startDayNumber) {
                            startDayNumber = Integer.valueOf(i.Day_number__c);
                            upgradeStartNumber = startDayNumber;
                        }
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            upgradeEndNumber = endDayNumber;
                        }
                    }
                    upgradeStartDate = departureDate.addDays(startDayNumber - 1);
                    upgradeEndDate = departureDate.addDays(endDayNumber - 1);
                }
            }
        }
    }

    public Date startDateForContext(String context) {
        Date result;
        switch on context {
            when 'Pre Extension', 'Both Extensions' {
                result = preXStartDate;
            }
            when 'Main Package', 'Post Extension', 'Upgrade' {
                result = mainStartDate;
            }
        }
        return result;
    }
}