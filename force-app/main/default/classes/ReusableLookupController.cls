public with sharing class ReusableLookupController {
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if(inputWrapper != null){
                String fieldsToQuery = 'SELECT Id, ';
                if(string.isNotBlank(inputWrapper.fieldApiName)){
                    fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
                }
                if(string.isNotBlank(inputWrapper.otherFieldApiName)){
                    fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
                }
                String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName;
                String filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'%' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' ';
                if(String.isNotBlank(inputWrapper.selectedRecordId)) {
                    query += ' WHERE Id = \''+ inputWrapper.selectedRecordId + '\'';
                }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                    query += ' WHERE '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                    query += ' AND ' + filterCriteria;
                } 
                else {
                    query += ' WHERE '+ filterCriteria;
                }
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                for(SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                    String splitField = (String)s.get(inputWrapper.fieldApiName);
                    List<String> splitFieldBySpace = splitField.split(' ');
                    //DP-54 start
                    if(inputWrapper.objectApiName == 'Publishing_Inclusions__c'){    
                        List<String> splitFutherImage = splitFieldBySpace[4].split('=');
                        String publishImage = splitFutherImage[1].replace('"','');
                        //wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                        String imgURL = System.Label.Instance_Link+publishImage;
                        wrap.subField = imgURL; 
                        //String concatentateField = splitFieldBySpace[0] +' '+ '<img src ='+'\"'+imgURL+'\"'+'></img>';
                    }
                    //DP-54 End
                    wrap.mainField = splitFieldBySpace[0];
                    
                    // wrap.objectIcon = getIconName('Publishing_Inclusions__c');
                    wrap.id = (String)s.get('id');
                    returnWrapperList.add(wrap);
                }
                return returnWrapperList;
            }
            return null;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    
    @AuraEnabled(cacheable=true)
    public static String getIconName(String sObjectName){
        system.debug('sObjectName:: '+sObjectName);
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
        
        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        system.debug('iconName:: '+u);
        return u;
    }
    
    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        @AuraEnabled public String objectIcon{get;set;}
        @AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String selectedRecordId{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
    }
}