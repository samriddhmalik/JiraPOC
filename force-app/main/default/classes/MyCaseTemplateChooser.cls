global class MyCaseTemplateChooser implements Support.EmailTemplateSelector {
    // Empty constructor 
    global MyCaseTemplateChooser() {    }

    // The main interface method 
    global ID getDefaultEmailTemplateId(ID caseId) {
        // Select the case we're interested in, choosing any fields that are relevant to our decision
        Case c = [SELECT Subject,Status FROM Case WHERE Id=:caseId];

        EmailTemplate et;

        if (c.Status == 'New'){
            et = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'Case_Feed_Default_for_Status_New_Custom'];
           	system.debug('et'+et);
            return et.id;
           }
        // Return the ID of the template selected
        else{
            return null;
        }
        
    }
}