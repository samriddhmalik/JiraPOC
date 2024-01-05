public class MP_CaseCommunityLayout {

    @Auraenabled(cacheable=true)
    Public Static List<Case> caseCommunityLayout(String CaseId){
        List<Case> caseList = [Select Id, Subject, Description, Priority, CaseNumber, Status,Contact.Name From Case Where Id =: CaseId];
        return caseList;
    }
    
}