global class customercPagedResult {

    @AuraEnabled
    public Integer pageSize { get; set; }

    @AuraEnabled
    public Integer page { get; set; }

    @AuraEnabled
    public Integer total { get; set; }

    @AuraEnabled
    public List<customer__c> products { get; set; }

}