public class customercSearchController {

    @AuraEnabled
    public static customercPagedResult findAll(String searchKey, Decimal pageNumber) {
        Integer pageSize = 12;
        String key = '%' + searchKey + '%';
        Integer offset = ((Integer)pageNumber - 1) * pageSize;

        customercPagedResult r =  new customercPagedResult();
        r.pageSize = pageSize;
        r.page = (Integer) pageNumber;
        r.total = [SELECT count() FROM customer__c
        WHERE (Name LIKE :key OR first_name__c LIKE :key OR last_name__c LIKE :key OR order__r.Name LIKE :key) AND agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserEmail())];
        r.products = [SELECT Id, Name, first_name__c, last_name__c, dob__c, order__r.Id, order__r.Name, link_to_full_name__c, pif_final__c FROM customer__c
        WHERE (Name LIKE :key OR first_name__c LIKE :key OR last_name__c LIKE :key OR order__r.Name LIKE :key) AND agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserEmail())
        ORDER BY NAME LIMIT 12 OFFSET :offset];
        System.debug(r);
        return r;
    }
}