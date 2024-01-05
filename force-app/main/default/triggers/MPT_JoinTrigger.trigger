trigger MPT_JoinTrigger on MPT_JOIN__c (before insert) {

    MPT_JoinTriggerHandler.updateCurrencyField(trigger.new);
}