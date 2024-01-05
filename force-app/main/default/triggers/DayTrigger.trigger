/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* DayTriggerHandler-
* Purpose: Trigger to update logic for Day
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Vinti C   <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Vinti C   <vinti.chittora@psagtechnologies.com>
* @maintainedBy   Vinti C   <vinti.chittora@psagtechnologies.com>
* @version        1.0
* @created        2020-01-30 
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */


trigger DayTrigger on Day__c (After update) {

    if(trigger.isAfter && trigger.isUpdate){
        
        DayTriggerHandler.SendEmailOnAccomAssign(Trigger.new);
    }
}