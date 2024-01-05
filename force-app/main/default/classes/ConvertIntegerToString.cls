global class ConvertIntegerToString {
     
    
    @InvocableMethod(label='Invoke Apex for AddOn Creation')
    public static List<Results> GetCount (List<Requests> requests)
    {   
        Requests OBJRequests = requests[0];
        Integer i = OBJRequests.RequestInt;
        list<String> lstint = new list<String>();
        for(integer k=0 ; k<i ; k++){
            lstint.add(String.valueof(k));
        }
               
        List<Results> resultsList = new List<results>();
        Results curResult = new Results();
        curResult.RequestResult = lstint; 
        resultsList.add(curResult);
        return resultsList;
    }
    
    global class Requests {
        @InvocableVariable
        global Integer RequestInt;
    }
    
    global class Results {
        @InvocableVariable
        global list<String> RequestResult;
    }
}