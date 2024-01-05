public class MP_ProfileDetailsOnCommunity {
    
    public class mainWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String Username;
        @AuraEnabled public String Name;
        @AuraEnabled public String Email;
        @AuraEnabled public String Phone;
        @AuraEnabled public String Address;
        @AuraEnabled public String Street;
        @AuraEnabled public String City;
        @AuraEnabled public String State;
        @AuraEnabled public String Country;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String TimeZone;
        @AuraEnabled public String Language;
        @AuraEnabled public Boolean isEmailEnable;
        @AuraEnabled public Boolean isPIFSettingsEnabled;

     
    }
    
        @AuraEnabled(cacheable=true)
        public static List<mainWrapper> getUser() {
            Id ids= Userinfo.getUserId();
            
  List<User> a= [SELECT Id,Username,Name,contact.PIFSummary_Enabled__c,Email,Street,City,State,PostalCode,contact.isEnableNotification__c,
          Country,tolabel(TimeZoneSidKey),tolabel(LocaleSidKey),contact.Phone FROM User where id=:ids LIMIT 1];
            List<mainWrapper> def = new List<mainWrapper>();
            mainWrapper abc = new mainWrapper();
            abc.Id=a[0].id;
            system.debug('Id '+abc.Id);
             abc.Username=a[0].Username;
            system.debug('Username '+ abc.Username);
             abc.Name=a[0].Name; 
            system.debug('Name '+ abc.Name);
             abc.Email=a[0].Email;
            system.debug('Email '+abc.Email);
            abc.Address= a[0].Street+', '+a[0].City+'\n'+a[0].State+' - '+a[0].PostalCode+'\n'+a[0].Country ;
            system.debug('Address '+abc.Address);
             abc.Street=a[0].Street;
            system.debug('Street '+abc.Street);
             abc.City=a[0].City;
            system.debug(' City '+abc.City);
             abc.State=a[0].State;
            system.debug('State '+abc.State);
            abc.PostalCode=a[0].PostalCode;
            system.debug('PostalCode '+abc.PostalCode);
             abc.Country=a[0].Country;
            system.debug('Country '+abc.Country);
             abc.TimeZone=a[0].TimeZoneSidKey; 
            system.debug('TimeZoneSidKey '+abc.TimeZone);
             abc.Language=a[0].LocaleSidKey;
            system.debug('LocaleSidKey '+abc.Language);
            abc.Phone=a[0].contact.Phone;
             system.debug('Phone '+a[0].contact.Phone);
            abc.isEmailEnable=a[0].contact.isEnableNotification__c;
            abc.isPIFSettingsEnabled=a[0].contact.PIFSummary_Enabled__c;

            system.debug('main wrapper  '+abc);
                def.add(abc);
                return def;
  }
    
     @AuraEnabled
    Public static void sendEmailEnable(ID userID,Boolean chklistValue,String phnData)
    {
        system.debug('line no 64'+userID);
        system.debug('line no 65'+chklistValue);
        system.debug('line no 66'+phnData);
        List<User> a= [SELECT Id,ContactId FROM User where id=:userID LIMIT 1];
        
       List<Contact> con = new List<Contact>();
        Contact c= [SELECT Id,isEnableNotification__c,Phone FROM Contact where id=:a[0].ContactId LIMIT 1];
        c.Phone=phnData;
        //c.Email = 'abc@gmail.com';
        c.isEnableNotification__c = chklistValue;
        con.add(c);
        update con;
        system.debug('con'+con);
        
        
    }

        @AuraEnabled
    Public static void enablePIFSummary(ID userID,Boolean isPifSummaryEnabled)
    {
        System.debug('userID='+userID);
        List<User> a= [SELECT Id,ContactId FROM User where id=:userID LIMIT 1];
        
        List<Contact> con = new List<Contact>();
        Contact c= [SELECT Id,isEnableNotification__c,PIFSummary_Enabled__c,Phone FROM Contact where id=:a[0].ContactId LIMIT 1];
        c.PIFSummary_Enabled__c = isPifSummaryEnabled;
        con.add(c);
        update con;
        system.debug('con'+con);
        
        /*Contact contact = [SELECT Id,isEnableNotification__c,PIFSummary_Enabled__c,Phone FROM Contact where id=:a[0].ContactId LIMIT 1];
        if(contact.PIFSummary_Enabled__c == true){
            schedulePIFSummary();
        }*/
        
        
        
        
    }
    
    @AuraEnabled
     Public static void changePasswordEmail(String userID)
    {
        system.debug('changePasswordEmail');
        system.debug('Line no 187'+userID);

        List<User> testUser = [Select id,Name,Email,AccountId,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND Id=:userID];
        for(User u : testUser){
            System.resetPassword(u.Id, true);

        }
       
    }

}