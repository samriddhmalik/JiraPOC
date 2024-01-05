public class ordercSearchController {

    @AuraEnabled
    public static PagedResult findAll(String searchKey, Decimal pageNumber) {
        Integer pageSize = 12;
        String key = '%' + searchKey + '%';
        Integer offset = ((Integer)pageNumber - 1) * pageSize;

        PagedResult r =  new PagedResult();
        r.pageSize = pageSize;
        r.page = (Integer) pageNumber;
        r.total = [SELECT count() FROM order__c
        WHERE (Name LIKE :key OR full_name_purchaser__c LIKE :key OR email_purchaser__c LIKE :key OR agent_name__c LIKE :key OR old_NRMA_order_number__c LIKE :key) AND agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserName())];
        r.products = [SELECT Id, Name, RecordTypeId, old_NRMA_order_number__c ,TC_Booking_Status__c, full_name_purchaser__c, email_purchaser__c, Deal_ID__c, Deal_and_Option__c, description__c, grand_total__c, agent_name__c FROM order__c
        WHERE (Name LIKE :key OR full_name_purchaser__c LIKE :key OR email_purchaser__c LIKE :key OR agent_name__c LIKE :key OR old_NRMA_order_number__c LIKE :key) AND agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserName())
        ORDER BY NAME LIMIT 12 OFFSET :offset];
        System.debug(r);
        return r;
    }

    @AuraEnabled
    public static PagedResult defaultOrders (Decimal pageNumber) {
        Integer pageSize = 12;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        
        PagedResult r =  new PagedResult();
        r.pageSize = pageSize;
        r.page = (Integer) pageNumber;
        r.total = [SELECT count() FROM order__c WHERE agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserName())];
        r.products = [SELECT Id, Name, RecordTypeId, old_NRMA_order_number__c ,TC_Booking_Status__c, full_name_purchaser__c, email_purchaser__c, Deal_ID__c, Deal_and_Option__c, description__c, grand_total__c, agent_name__c FROM order__c WHERE agency_id__c IN (SELECT Id FROM Account WHERE PersonEmail = :UserInfo.getUserName())];
        return r;
    }
}