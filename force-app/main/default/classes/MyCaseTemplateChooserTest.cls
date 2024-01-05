@isTest
private class MyCaseTemplateChooserTest {

    static testMethod void testChooseTemplate() {
    
        MyCaseTemplateChooser chooser = new MyCaseTemplateChooser();

        // Create a simulated case to test with
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Please help me through this!';
        Database.insert(c);
            
        // Make sure the proper template is chosen for this subject
        Id actualTemplateId = chooser.getDefaultEmailTemplateId(c.Id);
        EmailTemplate expectedTemplate = 
          [SELECT id FROM EmailTemplate WHERE DeveloperName = 'Case_Feed_Default_for_Status_New_Custom'];
        Id expectedTemplateId = expectedTemplate.Id;
        System.assertEquals(actualTemplateId, expectedTemplateId);
  
    }
}