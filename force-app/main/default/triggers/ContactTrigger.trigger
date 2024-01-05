trigger ContactTrigger on Contact (after update) {
    
    if(trigger.isafter &&  trigger.isupdate)
    {
        List<Contact> conList = new List<Contact>();
        for(Contact ca:trigger.new){
            if((ca.Phone != trigger.oldMap.get(ca.Id).Phone) || (ca.Email != trigger.oldMap.get(ca.Id).Email)){
                conList.add(ca);
            }
        }
        
        /** LOGIC 1 - This Method would 1) Update Phone Number & Email Of user on conat update*** 
* *********************/ 
        if(!conList.isEmpty()){
            MP_UpdatePhoneNumber.updatephone(conList);   
        }
    }
}