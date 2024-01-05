public without sharing class TAD_CaseForFinance {
    
    public class caseRecords{
        @auraenabled public string id{GET;SET;}
        @auraenabled public string CaseNumber{GET;SET;}
        @auraenabled public string Subject{GET;SET;}
        @auraenabled public string Origin{GET;SET;}
        
    }
    
    @auraenabled
    public static List<caseRecords> getCaseRecord(string caseNumber){
        List<caseRecords> caseWraper = new List<caseRecords>(); 
        string searchCase = '%'+ caseNumber +'%';
        
        system.debug('searchCase:- '+ searchCase);
        
        List<case> CasesListNumber = [SELECT id, CaseNumber, Subject, Origin  FROM Case  WHERE CaseNumber LIKE : searchCase ];
        if(!string.isBlank(caseNumber) ){
            system.debug('caseNumber:- '+caseNumber);
            for(case cs : CasesListNumber){
                caseRecords wrap = new caseRecords();
                wrap.id = cs.id;
                wrap.caseNumber = cs.caseNumber;
                wrap.Subject = cs.Subject;
                wrap.Origin = cs.Origin;
                caseWraper.add(wrap);
                
            }            
        }
        
        
        system.debug('CasesListNumber:- '+ CasesListNumber);
        
        try{
            if(!caseWraper.isEmpty()){
                return caseWraper;    
            }else{
                return null;
            }
            
        }catch(exception ex){
            system.debug('ERROR MESAGE:- '+ EX.getMessage());
            throw new AuraHandledException('Error In CASE List ');
        }
        
        
    }
    
}