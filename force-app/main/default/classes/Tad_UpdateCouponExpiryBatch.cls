public class Tad_UpdateCouponExpiryBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Expiry_Date__c,usable_count__c,usage_count__c,balance_remaining__c
            FROM coupon__c
            WHERE Is_Agent_Coupon__c = true
        ]);
    }

    public void execute(Database.BatchableContext context, List<coupon__c> scope) {
        List<coupon__c> couponsToUpdate = new List<coupon__c>();

        for (coupon__c coupon : scope) {
            Date newExpiryDate = coupon.Expiry_Date__c.addMonths(1);
            
            couponsToUpdate.add(new coupon__c(
                Id = coupon.Id,
                Expiry_Date__c = newExpiryDate,
                usable_count__c = 5+coupon.usage_count__c,
                Discount__c = 100,
                Status__c = 'Enabled'
            ));
        }

        update couponsToUpdate;
    }

    public void finish(Database.BatchableContext context) {
    }
}