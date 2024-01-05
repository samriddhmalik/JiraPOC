@RestResource(urlmapping='/settingUserCreationTAD/*')
global class MobileAppTADUserCreation {
    global class mainWrapper{
        global String UserId{get;set;}
        global String Email{get;set;}
        global String Password{get;set;}
        global String Phone{get;set;}
        global string Lastname{get;set;}
        global string userEncodedImage{get;set;}
    }
    global class result{
        global string personAccountId{get;set;}
        global string email{get;set;}
        global string fullName{get;set;}
        global string message{get;set;}
        global string AttachmentId{get;set;}
    }
    
    
    @HttpPost
    global Static result usercreation(mainWrapper userData)
    {
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<Account> actList=[SELECT Id,TAD_Email__c,LastName from Account where TAD_Email__c=:userData.Email];
        
        
        
        If(actList.size()>0){
            result rslt=new result();
            rslt.message='User Exist!';
            rslt.personAccountId=actList[0].id;
            rslt.email=actList[0].TAD_Email__c;
            rslt.fullname=actList[0].LastName;
            return rslt;
        }
        else{
            Account Act=New Account();
            Act.LastName=userData.Lastname;
            Act.PersonEmail=userData.Email;
            Act.TAD_UserId__c=userData.UserId;
            Act.TAD_Password__c=userData.Password;
            Act.TAD_Email__c=userData.Email;
            Act.RecordTypeId=RCTPersonAccount[0].id ;
            Act.Phone=userData.Phone;
            Insert Act;
            
            result res=new result();
            if(userData.userEncodedImage!=null && userData.userEncodedImage!='' ){
                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf(userData.userEncodedImage);
                attachment.Name = 'TADUserProfile';
                attachment.ParentId = Act.Id;
                insert attachment;
                res.AttachmentId=attachment.Id;
            }
            
            
            res.personAccountId=Act.id;
            res.message='Success';
            res.email=Act.TAD_Email__c;
            res.fullname=Act.LastName;
            
            
            return res;
        }
    }
}