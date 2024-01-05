@RestResource(urlmapping='/settingGetTadUser/*')
global class MobileAppGetTADUser {
    global class mainWrapper{
        
        global String Email{get;set;}
        global String Password{get;set;}
        //global string AttachmentId{get;set;}
    }
    global class result{
        global string fullName{get;set;}
        global string personAccountId{get;set;}
        global string message{get;set;}
        global string email{get;set;}
        global string userEncodedImage{get;set;}
        
    }
    @Httppost
    global Static result getuser(mainWrapper userData)
    {
  
        List<Account> ActList=[SELECT Id,Name,TAD_Email__c,TAD_Password__c FROM Account WHERE  TAD_Email__c=:userData.Email AND TAD_Password__c=:userData.Password ];
       //system.debug('dtaaTad----'+ActList[0].TAD_Password__c +' ---------'+userData.Password);
        
        result rslt=new result();
       if( Actlist.size()>0 && ActList[0].TAD_Password__c.equals(userData.Password) ){
        try{
        Attachment Ac=[SELECT Id,Body,Name,ParentId FROM Attachment WHERE  Name='TADUserProfile' AND ParentID =:ActList[0].Id];
        rslt.userEncodedImage=string.valueof(Ac.Body);
            
        }
        catch(QueryException e){}
	        rslt.FullName=ActList[0].Name;
            rslt.personAccountId=Actlist[0].Id;
            rslt.Message='Success';
            rslt.email=Actlist[0].TAD_Email__c;
            return rslt;
            
        }
        else
        {
            //result rslt=new result();
            rslt.Message='No User Found Please Make Sure your Email-Id or Password is correct';
            return rslt;
        }
    }
}