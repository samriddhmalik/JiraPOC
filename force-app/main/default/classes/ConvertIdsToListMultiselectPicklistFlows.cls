global class ConvertIdsToListMultiselectPicklistFlows {
		
    @InvocableMethod(label='Invoke Apex for MultiSelectPicklist Flows')
     public static List<Results> GetCount (List<Requests> requests)
     {    
         Requests OBJRequests = requests[0];
         
         List<String> idsList = OBJRequests.idsString.split(';');
         
         List<Results> resultsList = new List<results>();
         Results curResult = new Results();
         curResult.RequestResult = idsList; 
         resultsList.add(curResult);
         return resultsList;
     }
     
    global class Requests {
         @InvocableVariable
         global String idsString;
     }
    
    global class Results {
         @InvocableVariable
         global list<String> RequestResult;
     }
}