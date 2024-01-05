public class ItineraryDateSupportv3 {

    public Date oneStartDate {get;set;}
    public Date oneEndDate {get;set;}
    public Date twoStartDate {get;set;}
    public Date twoEndDate {get;set;}
    public Date threeStartDate {get;set;}
    public Date threeEndDate {get;set;}
    public Date fourStartDate {get;set;}
    public Date fourEndDate {get;set;}
    public Date fiveStartDate {get;set;}
    public Date fiveEndDate {get;set;}
    public Date sixStartDate {get;set;}
    public Date sixEndDate {get;set;}
    public Date sevenStartDate {get;set;}
    public Date sevenEndDate {get;set;}
    public Date eightStartDate {get;set;}
    public Date eightEndDate {get;set;}
    public Date nineStartDate {get;set;}
    public Date nineEndDate {get;set;}
    public Date tenStartDate {get;set;}
    public Date tenEndDate {get;set;}

    public Date oneStartDateNz {get;set;}
    public Date oneEndDateNz {get;set;}
    public Date twoStartDateNz {get;set;}
    public Date twoEndDateNz {get;set;}
    public Date threeStartDateNz {get;set;}
    public Date threeEndDateNz {get;set;}
    public Date fourStartDateNz {get;set;}
    public Date fourEndDateNz {get;set;}
    public Date fiveStartDateNz {get;set;}
    public Date fiveEndDateNz {get;set;}
    public Date sixStartDateNz {get;set;}
    public Date sixEndDateNz {get;set;}
    public Date sevenStartDateNz {get;set;}
    public Date sevenEndDateNz {get;set;}
    public Date eightStartDateNz {get;set;}
    public Date eightEndDateNz {get;set;}
    public Date nineStartDateNz {get;set;}
    public Date nineEndDateNz {get;set;}
    public Date tenStartDateNz {get;set;}
    public Date tenEndDateNz {get;set;}

    public Integer oneEndNumber {get;set;}
    public Integer twoEndNumber {get;set;}
    public Integer threeEndNumber {get;set;}
    public Integer fourEndNumber {get;set;}
    public Integer fiveEndNumber {get;set;}
    public Integer sixEndNumber {get;set;}
    public Integer sevenEndNumber {get;set;}
    public Integer eightEndNumber {get;set;}
    public Integer nineEndNumber {get;set;}
    public Integer tenEndNumber {get;set;}

    public Integer oneEndNumberNz {get;set;}
    public Integer twoEndNumberNz {get;set;}
    public Integer threeEndNumberNz {get;set;}
    public Integer fourEndNumberNz {get;set;}
    public Integer fiveEndNumberNz {get;set;}
    public Integer sixEndNumberNz {get;set;}
    public Integer sevenEndNumberNz {get;set;}
    public Integer eightEndNumberNz {get;set;}
    public Integer nineEndNumberNz {get;set;}
    public Integer tenEndNumberNz {get;set;}

    
    public ItineraryDateSupportv3(Date departureDate, Map<String,List<Itinerary__c>> itinList) {

        for (String s : itinList.keySet()) {
            if (s == '1') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    oneStartDate = departureDate;
                    oneEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            oneEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    oneStartDateNz = departureDate;
                    oneEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            oneEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '2') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    twoStartDate = departureDate;
                    twoEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            twoEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    twoStartDateNz = departureDate;
                    twoEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            twoEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '3') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    threeStartDate = departureDate;
                    threeEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            threeEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    threeStartDateNz = departureDate;
                    threeEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            threeEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '4') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    fourStartDate = departureDate;
                    fourEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            fourEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    fourStartDateNz = departureDate;
                    fourEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            fourEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '5') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    fiveStartDate = departureDate;
                    fiveEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            fiveEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    fiveStartDateNz = departureDate;
                    fiveEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            fiveEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '6') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    sixStartDate = departureDate;
                    sixEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            sixEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    sixStartDateNz = departureDate;
                    sixEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            sixEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '7') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    sevenStartDate = departureDate;
                    sevenEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            sevenEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    sevenStartDateNz = departureDate;
                    sevenEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            sevenEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '8') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    eightStartDate = departureDate;
                    eightEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            eightEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    eightStartDateNz = departureDate;
                    eightEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            eightEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '9') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    nineStartDate = departureDate;
                    nineEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            nineEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    nineStartDateNz = departureDate;
                    nineEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            nineEndNumberNz = endDayNumber;
                        }
                    }
                }
            } else if (s == '10') {
                List<Itinerary__c> itinAu = new List<Itinerary__c>();
                List<Itinerary__c> itinNz = new List<Itinerary__c>();
                for (Itinerary__c i : itinList.get(s)) {
                    if (i.country_context__c == 'AU') {
                        itinAu.add(i);
                    }
                    if (i.country_context__c == 'NZ') {
                        itinNz.add(i);
                    }
                }
                if (itinAu.size() > 0) {
                    tenStartDate = departureDate;
                    tenEndDate = departureDate.addDays(itinAu.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinAu[0].Day_number__c);
                    for (Itinerary__c i : itinAu) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            tenEndNumber = endDayNumber;
                        }
                    }
                }
                if (itinNz.size() > 0) {
                    tenStartDateNz = departureDate;
                    tenEndDateNz = departureDate.addDays(itinNz.size() - 1);
                    Integer startDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    Integer endDayNumber = Integer.valueOf(itinNz[0].Day_number__c);
                    for (Itinerary__c i : itinNz) {
                        if (i.Day_number__c > endDayNumber) {
                            endDayNumber = Integer.valueOf(i.Day_number__c);
                            tenEndNumberNz = endDayNumber;
                        }
                    }
                }
            }
        }
    }

    public Date startDateForContext(String context, String country) {
        Date result;
        switch on context {
            when '1' {
                if (country == 'AU') {
                    result = oneStartDate;
                } else if (country == 'NZ') {
                    result = oneStartDateNz;
                }
            }
            when '2' {
                if (country == 'AU') {
                    result = twoStartDate;
                } else if (country == 'NZ') {
                    result = twoStartDateNz;
                }
            }
            when '3' {
                if (country == 'AU') {
                    result = threeStartDate;
                } else if (country == 'NZ') {
                    result = threeStartDateNz;
                }
            }
            when '4' {
                if (country == 'AU') {
                    result = fourStartDate;
                } else if (country == 'NZ') {
                    result = fourStartDateNz;
                }
            }
            when '5' {
                if (country == 'AU') {
                    result = fiveStartDate;
                } else if (country == 'NZ') {
                    result = fiveStartDateNz;
                }
            }
            when '6' {
                if (country == 'AU') {
                    result = sixStartDate;
                } else if (country == 'NZ') {
                    result = sixStartDateNz;
                }
            }
            when '7' {
                if (country == 'AU') {
                    result = sevenStartDate;
                } else if (country == 'NZ') {
                    result = sevenStartDateNz;
                }
            }
            when '8' {
                if (country == 'AU') {
                    result = eightStartDate;
                } else if (country == 'NZ') {
                    result = eightStartDateNz;
                }
            }
            when '9' {
                if (country == 'AU') {
                    result = nineStartDate;
                } else if (country == 'NZ') {
                    result = nineStartDateNz;
                }
            }
            when '10' {
                if (country == 'AU') {
                    result = tenStartDate;
                } else if (country == 'NZ') {
                    result = tenStartDateNz;
                }
            }
        }
        return result;
    }

    public Date endDateForContext(String context, String country) {

        Date result;
        switch on context {
            when '1' {
                if (country == 'AU') {
                    result = oneEndDate;
                } else if (country == 'NZ') {
                    result = oneEndDateNz;
                }
            }
            when '2' {
                if (country == 'AU') {
                    result = twoEndDate;
                } else if (country == 'NZ') {
                    result = twoEndDateNz;
                }
            }
            when '3' {
                if (country == 'AU') {
                    result = threeEndDate;
                } else if (country == 'NZ') {
                    result = threeEndDateNz;
                }
            }
            when '4' {
                if (country == 'AU') {
                    result = fourEndDate;
                } else if (country == 'NZ') {
                    result = fourEndDateNz;
                }
            }
            when '5' {
                if (country == 'AU') {
                    result = fiveEndDate;
                } else if (country == 'NZ') {
                    result = fiveEndDateNz;
                }
            }
            when '6' {
                if (country == 'AU') {
                    result = sixEndDate;
                } else if (country == 'NZ') {
                    result = sixEndDateNz;
                }
            }
            when '7' {
                if (country == 'AU') {
                    result = sevenEndDate;
                } else if (country == 'NZ') {
                    result = sevenEndDateNz;
                }
            }
            when '8' {
                if (country == 'AU') {
                    result = eightEndDate;
                } else if (country == 'NZ') {
                    result = eightEndDateNz;
                }
            }
            when '9' {
                if (country == 'AU') {
                    result = nineEndDate;
                } else if (country == 'NZ') {
                    result = nineEndDateNz;
                }
            }
            when '10' {
                if (country == 'AU') {
                    result = tenEndDate;
                } else if (country == 'NZ') {
                    result = tenEndDateNz;
                }
            }
        }
        return result;
    }
}