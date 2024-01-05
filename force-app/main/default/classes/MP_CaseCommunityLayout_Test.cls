@isTest
public class MP_CaseCommunityLayout_Test {

    @isTest
    Static void caseMethod(){
        Case c = new Case();
        c.Subject = 'Hello';
        c.Description = 'Test';
        insert c;
        
        MP_CaseCommunityLayout.caseCommunityLayout(c.Id);
        
    }
}