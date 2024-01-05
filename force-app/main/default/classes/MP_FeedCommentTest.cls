@isTest
public class MP_FeedCommentTest {
    
    @testSetup static void setup() {
        
        Account acmc = new Account (
            Name = 'newAcfsc1'
        );
        
        insert acmc;
        Contact conObj = new Contact (
            AccountId = acmc.id,
            FirstName = 'Testt',
            LastName = '1234'
        );
        
        insert conObj;
        
    }
    
    @isTest
    public static void testFeedForPartnerUser(){
        MP_CaseCommentSource.isCaseCommentedFromSalesforce = true;
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
        Contact con = [Select Id,Name from Contact limit 1];  
        User newUser = new User( email='Test123@gmail.com',
                                profileid = p.Id, 
                                UserName='Testt1234@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Testt',
                                isActive = true,
                                LastName = '1234');
        insert newUser; 
        
        
        
        System.runAs(newUser){
            Case caseObj = new Case();
            caseObj.ContactId = con.Id;
            caseObj.RecordTypeId = TADUtils.getRecordType('Logistics (Partner)')[0].id;
            caseObj.Subject = 'Testing Case';
            insert caseObj;
            
            FeedItem feed = new FeedItem ();
            feed.parentid = caseObj.Id;
            feed.type = 'ContentPost';
            feed.Body = 'Hello';
            insert feed;
            
            FeedItem feedMention = new FeedItem ();
            feedMention.parentid = caseObj.Id;
            feedMention.type = 'ContentPost';
            feedMention.Body = '@Test 123 Hello';
            insert feedMention;
            
            List<FeedComment> feedLst = new List<FeedComment>();
            FeedComment feedObj = new FeedComment();
            feedObj.FeedItemId = feed.Id;
            feedObj.CommentBody = 'Executed from Test clas';
            feedLst.add(feedObj);
            
            FeedComment feedObjMention = new FeedComment();
            feedObjMention.FeedItemId = feedMention.Id;
            feedObjMention.CommentBody = '@Test 123 Hello';
            feedLst.add(feedObjMention);
            
            insert feedLSt;
            
            Test.startTest();
            MP_FeedComment.feedcommentfromcase(caseObj.Id);
            MP_FeedComment.insertFeedComment(caseObj.Id,'Test Body');
            Test.stopTest();
            
        }        
        
    }     
    
    @isTest
    public static void testFeedForNonPartnerUser(){
        UserRole obj=new UserRole(Name= 'Salesforce Admin'); 
        insert obj; 
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Contact con = [Select Id,Name from Contact limit 1];  
        
        String orgId=UserInfo.getOrganizationId(); 
        
        User newUser=new User(firstname = 'Testt', 
                              lastName = '1234', 
                              email = 'Testt14rgsd234@gmail.com', 
                              Username = 'Testt3dsfsdew1234@gmail.com', 
                              EmailEncodingKey = 'ISO-8859-1', 
                              Alias = 'ABCD', 
                              TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US', 
                              LanguageLocaleKey = 'en_US', 
                              ProfileId = pf.Id, 
                              isActive = true,
                              //ContactId = con.Id,
                              UserRoleId = obj.Id); 
        
        
        System.runAs(newUser){
            Case caseObj = new Case();
            caseObj.ContactId = con.Id;
            caseObj.Subject = 'Testing Case for Iternal User';
            insert caseObj;
            
            ContentVersion contentVersion = new ContentVersion(
                Title          = 'a picture',
                PathOnClient   = 'Pic.jpg',
                VersionData    = Blob.valueOf('Test Content'),
                IsMajorVersion = true);
            insert contentVersion;
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            //create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = caseObj.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
            
            FeedItem feed = new FeedItem ();
            feed.parentid = caseObj.Id;
            feed.type = 'ContentPost';
            feed.Body = 'Hello';
            insert feed;
            
            FeedItem feedMention = new FeedItem ();
            feedMention.parentid = caseObj.Id;
            feedMention.type = 'ContentPost';
            feedMention.Body = '@Testt 1234 Hello';
            insert feedMention;
            
            String sendImagComment = '<img src="sfdc://'+documents[0].Id+'"></img>';

            List<FeedComment> feedLst = new List<FeedComment>();
            FeedComment feedObj = new FeedComment();
            feedObj.FeedItemId = feed.Id;
            feedObj.CommentBody = sendImagComment;
            feedLst.add(feedObj);
            
            FeedComment feedObjMention = new FeedComment();
            feedObjMention.FeedItemId = feedMention.Id;
            feedObjMention.CommentBody = '@Testt 1234 Hello';
            String fileinfo = '[{"fileName":"SalesReportData (17).csv","fileContent":"RGVhbCxPcmRlciBOdW1iZXIsQWNjb3VudCBOYW1lLFRvdXIgRGVwYXJ0dXJlIERhdGUsU3RhcnQgRGF0ZSxDb21wb25lbnQgTmFtZSxQYXggVHJhdmVsbGluZyxSb29tL0NhYmluIFJlcXVpcmVkLFJvb20vQ2FiaW4gQ29uZmlndXJhdGlvbgoiMzYwMCIsIk8tMDI1MDIiLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wMi0xNyIsIjIwMjItMDItMTciLCJMYW5kIFRvdXItMTcgRGF5IEFudGFyY3RpY2EgRXhwZWRpdGlvbiBDcnVpc2UiLCIyIiwiMiIsIlNvbG8iCiIzNjAwIiwiTy0wMjUwMiIsIlNhbXJpZGRoTWFsaWsiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjQiLCIyIiwiVHdpbiIKIjM2MDAiLCJPLTAyNTAyIiwiU2FtcmlkZGhNYWxpayIsIjIwMjItMDItMTciLCIyMDIyLTAyLTIwIiwiTGFuZCBBY3Rpdml0eS1UaWdyZSAmIERlbHRhIHdpdGggQm9hdCBSaWRlLTM2MDAiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMzA5MCIsIlBob25lIEEgRmxpZ2h0IFB0eSBMdGQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NiIsIkR3YXluZSBCaXJ0bGVzIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjIiLCJTb2xvIgoiMzczMiIsIk8tMDMwODYiLCJEd2F5bmUgQmlydGxlcyIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAzMDg3IiwiQ2FybG9zIFNhbmNoZXoiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA4NyIsIkNhcmxvcyBTYW5jaGV6IiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMDYiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMiIsIjEiLCJUd2luIgoiMzczMiIsIk8tMDMwODkiLCJSaWNoYXJkIEpvaG5zdG9uIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTAiLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMiIsTi9BLE4vQQoiMzczMiIsIk8tMDMwNjciLCJBZGFtIEJlbm5ldHQiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIyIiwiMSIsIlR3aW4iCiIzNzMyIiwiTy0wMzA2NyIsIkFkYW0gQmVubmV0dCIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgMzogUmlvIERlIEphbmVpcm8gQW5ncmEgRG9zIFJlaXMgSXNsYW5kcyBCb2F0IFRvdXItMzczMiIsIjEiLE4vQSxOL0EKIjM3MzIiLCJPLTAyNzg3IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMjY1OSIsIlJlbnUiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxOTUwIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTk1MCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDciLCJMYW5kIEFjdGl2aXR5LURheSAzOiBSaW8gRGUgSmFuZWlybyBBbmdyYSBEb3MgUmVpcyBJc2xhbmRzIEJvYXQgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5NTAiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzczMiIsIk8tMDE5MjgiLCJHZWV0YSIsIjIwMjMtMDEtMDYiLCIyMDIzLTAxLTA2IiwiTGFuZCBUb3VyLTI1IERheSBBbnRhcmN0aWNhICYgU291dGggQW1lcmljYSIsIjIiLCIyIiwiU29sbyIKIjM3MzIiLCJPLTAxOTI4IiwiR2VldGEiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0xMCIsIkxhbmQgQWN0aXZpdHktRGF5IDM6IFJpbyBEZSBKYW5laXJvIEFuZ3JhIERvcyBSZWlzIElzbGFuZHMgQm9hdCBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTkyOCIsIkdlZXRhIiwiMjAyMy0wMS0wNiIsIjIwMjMtMDEtMTMiLCJMYW5kIEFjdGl2aXR5LURheSA4OiBDb2xvbmlhIGRlbCBTYWNyYW1lbnRvLCBVcnVndWF5IERheSBUb3VyLTM3MzIiLCIyIixOL0EsTi9BCiIzNzMyIiwiTy0wMTc3OSIsIkFiaGluYXYgSm9zaGkiLCIyMDIzLTAxLTA2IiwiMjAyMy0wMS0wNiIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMC41IiwiVHdpbiIKIjM3MzIiLCJPLTAxNjczIiwiR2VldGEiLCIyMDIzLTAyLTAzIiwiMjAyMy0wMi0wMyIsIkxhbmQgVG91ci0yNSBEYXkgQW50YXJjdGljYSAmIFNvdXRoIEFtZXJpY2EiLCIxIiwiMSIsIlNvbG8iCiIzNzMyIiwiTy0wMTY3NCIsIkdlZXRhIiwiMjAyMy0wMi0wMyIsIjIwMjMtMDItMDMiLCJMYW5kIFRvdXItMjUgRGF5IEFudGFyY3RpY2EgJiBTb3V0aCBBbWVyaWNhIiwiMSIsIjEiLCJTb2xvIgoiMzczMiIsIk8tMDE2NzQiLCJHZWV0YSIsIjIwMjMtMDItMDMiLCIyMDIzLTAyLTEwIiwiTGFuZCBBY3Rpdml0eS1EYXkgODogQ29sb25pYSBkZWwgU2FjcmFtZW50bywgVXJ1Z3VheSBEYXkgVG91ci0zNzMyIiwiMSIsTi9BLE4vQQoiMzQ4NSIsIk8tMDA3MDciLCJTYW1yaWRkaE1hbGlrIiwiMjAyMi0wNS0xNSIsIjIwMjItMDUtMTUiLCJMYW5kIFRvdXItMTIgRGF5IEFyZ2VudGluYSwgQ2hpbGUgJiBCcmF6aWwiLCIxIiwiMSIsIlNvbG8iCiIzNjAwIiwiTy0wMjU1NCIsIkFsY2hlbXkgRE1DICBBcmdlbnRpbmEiLCIyMDIyLTAyLTE3IiwiMjAyMi0wMi0xNyIsIkxhbmQgVG91ci0xNyBEYXkgQW50YXJjdGljYSBFeHBlZGl0aW9uIENydWlzZSIsIjIiLCIyIiwiU29sbyIK"}]';
            
            feedLst.add(feedObjMention);
            
            
            insert feedLSt;
            
            Test.startTest();
            MP_CaseCommentSource.isCaseCommentedFromSalesforce = true;
            MP_FeedCommentTriggerHandler.insertFeedComment(caseObj.Id,'Hi Merchant',fileinfo);
            MP_FeedCommentTriggerHandler.feedcommentfromcase(caseObj.Id);
            MP_FeedCommentTriggerHandler.testdata();
            Test.stopTest();
            
        }        
        
    } 
}