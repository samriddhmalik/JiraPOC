public class MP_UpdatePhoneNumber {
    public static void updatephone(List<Contact> conList){
         List<User> uslist = new List<User>();
    
    for(Contact ct : [select Id,Name,(select Id,Name,Phone,Email from Users where Profile.Name = 'Partner Community Plus User'),Phone,Email from Contact where id in : conList]){
        for(User u : ct.Users){
            u.Phone = ct.Phone;
            u.Email = ct.Email;
            uslist.add(u);
            
        }
    }
        if(uslist.size()>0){
            update uslist;
            
        }
        
    }
      @future(callout=true)
        public static void updatephoneUser(set<id> userId){
         List<Contact> conlist = new List<Contact>();
                   Set<String> consetID = new Set<String>();
  
         List<User> testUser = [Select id,Name,Email,AccountId,ContactId,Contact.AccountId,Phone, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND Id=:userId];
            for(User usr : testUser){
                contact ct=new contact();
                 ct.Phone = usr.Phone;
                 ct.Email = usr.Email;
                ct.id=usr.ContactId;
                conlist.add(ct);
            }
            
          


        if(conlist.size()>0){
            update conlist;
            
        }
        
    }
    
     
   
}