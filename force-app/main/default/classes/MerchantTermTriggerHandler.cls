public class MerchantTermTriggerHandler {

 
    public static void preventLastRecordDeletion(Map<Id,Merchant_Terms__c> mptOldMap){
        System.debug('mptOldMap---'+mptOldMap);
        Map<Id,List<Merchant_Terms__c>> MPTJoinVsMtMap = new  Map<Id,List<Merchant_Terms__c>>();
        Map<Id,List<Merchant_Terms__c>> MPTJoinVsMtMapToDelete = new  Map<Id,List<Merchant_Terms__c>>();
        Set<Id> mptJoinIdSet = new  Set<Id>();
        for(Merchant_Terms__c mpt: mptOldMap.values()){
            
            mptJoinIdSet.add(mpt.MPT_Join__c);
        }
        
        		for(Merchant_Terms__c mterms : mptOldMap.values()){
            if(MPTJoinVsMtMapToDelete.containsKey(mterms.MPT_Join__c)){
                 List<Merchant_Terms__c> mtListToDelete = MPTJoinVsMtMapToDelete.get(mterms.MPT_Join__c);
                mtListToDelete.add(mterms);
               
            }else{
                
                List<Merchant_Terms__c> mtListToDelete = new List<Merchant_Terms__c>();
                mtListToDelete.add(mterms);
                MPTJoinVsMtMapToDelete.put(mterms.MPT_Join__c, mtListToDelete);
            }
        }
        System.debug('MPTJoinVsMtMapToDelete--'+MPTJoinVsMtMapToDelete);
  		for(Merchant_Terms__c mt : [Select id,Name,MPT_Join__c from Merchant_Terms__c where MPT_Join__c IN : mptJoinIdSet ]){
            if(MPTJoinVsMtMap.containsKey(mt.MPT_Join__c)){
                 List<Merchant_Terms__c> mtList = MPTJoinVsMtMap.get(mt.MPT_Join__c);
                mtList.add(mt);
               
            }else{
                
                List<Merchant_Terms__c> mtList = new List<Merchant_Terms__c>();
                mtList.add(mt);
                MPTJoinVsMtMap.put(mt.MPT_Join__c, mtList);
            }
        }
        
        System.debug('MPTJoinVsMtMap---'+MPTJoinVsMtMap);
        for(Id joinId : MPTJoinVsMtMap.keySet()){
            for(Merchant_Terms__c mpt : MPTJoinVsMtMap.get(joinId)){
                System.debug('MPTJoinVsMtMap.get(joinId).size()---'+MPTJoinVsMtMap.get(joinId).size());
                   System.debug('MPTJoinVsMtMapToDelete.get(joinId).size()---'+MPTJoinVsMtMapToDelete.get(joinId).size());
                if(MPTJoinVsMtMap.get(joinId).size() == MPTJoinVsMtMapToDelete.get(joinId).size()){
                    
                    Merchant_Terms__c actualRecord = mptOldMap.get(mpt.Id);
                   actualRecord.addError('Cannot delete the last record of payment terms. Please edit the existing record');
                }
                
            }
        }
    }
    
    public static void restrictRecordDeletionHavingMptJoin(List<Merchant_Terms__c> mptOldList){
        
        Set<Id> mptJoinIds = new Set<Id>();
        
        for(Merchant_Terms__c mpt : mptOldList){
            
            mptJoinIds.add(mpt.MPT_Join__c);
            system.debug('mptJoinIds--'+mptJoinIds);
        }
        
	 	List<Component__c> compList = [Select Id,Name,MPT_JOIN__c from Component__c where MPT_JOIN__c IN : mptJoinIds ];
        system.debug('compList----'+compList);
        Set<Id> mptJoinIdscomp = new Set<Id>();
        
        for(Component__c comp :compList){
            
            mptJoinIdscomp.add(comp.MPT_JOIN__c);
            system.debug('mptJoinIdscomp---'+mptJoinIdscomp);
        }
        for(Merchant_Terms__c mpt1 : mptOldList){
            system.debug('mpt1--'+mpt1);
       
            if(mptJoinIdscomp.contains(mpt1.MPT_Join__c)) {
                
                mpt1.adderror('You cannot delete this Merchant Term record');
                    
                }
                
            
              
                
            }
        }
    
     public static void updateName(List<Merchant_Terms__c> mtList){
        
        Set<String> setMptId = new Set<String>();
        List<MPT_JOIN__c> lstToUpdateMPT = new List<MPT_JOIN__c>(); 
		For(Merchant_Terms__c mt : mtList)
		{
			setMptId.add(mt.MPT_Join__c);
		}

		List<MPT_JOIN__c> listMptJoin = [select Id,Name,Deal__c,Deal__r.Name ,Account_Name__c,(select Id,Amount__c from Merchant_Terms__r) from MPT_JOIN__c where Id IN :setMptId ];

		For(MPT_JOIN__c mp : listMptJoin)
		{
              String conAmount = '';
			List<Merchant_Terms__c> lstMT = mp.Merchant_Terms__r;
			for(Merchant_Terms__c mpt :lstMT)
		{
            conAmount += String.valueOf(mpt.Amount__c)+'/';
            system.debug('conAmount---'+conAmount);
          }
            conAmount = conAmount.removeEnd('/');
             mp.Name = mp.Deal__r.Name+ '-' +mp.Account_Name__c+'-'+conAmount;
            
            lstToUpdateMPT.add(mp);
            System.debug('lstToUpdateMPT--'+lstToUpdateMPT);
		}
         Update lstToUpdateMPT;
    	}
    

}