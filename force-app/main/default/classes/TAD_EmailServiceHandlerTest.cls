/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_EmailServiceHandlerTest class-
* Purpose: Test Class for unit test coverage of TAD_EmailServiceHandler class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Bharat J   <bharat.joshi@psagtechnologies.com>
* @maintainedBy   Samrat M, Bharat J
* @version        2.0
* @created        2019-05-30
* @modified       2019-08-30
* @systemLayer    Service
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

@isTest(SeeAllData=False)
private class TAD_EmailServiceHandlerTest {
    //Test Method for main class
    
    @testSetup static void setUpMethod() {
        List<RecordType> RTCase = TADUtils.getRecordType('Customisation Enquiry');
        system.debug('rtcase'+RTCase[0]);
        
        Contact con= TestDataFactory.testContact('test1@test11.com');
        insert con;
        
        Case caseObj = TestDataFactory.createCase(con,'Email');
        caseObj.Type__c = 'General Enquiry';
        caseObj.Type = 'General Enquiry';
        caseObj.mp_Customer_Request__c = 'Test';
        caseObj.RecordTypeId = RTCase[0].Id;
        insert caseObj;
        
    }
    static testMethod void TestinBoundEmail() {
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Case caseObj = [SELECT Id,CaseNumber FROM Case where Type__c = 'General Enquiry' LIMIT 1];
        
        // setup the data for the email
        email.subject = 'Create Contact Case#'+caseObj.CaseNumber;
        email.fromName = 'Test Contact';
        String[] addressCustmisations = new String[] {
            Label.TAD_Customisation_FromEmail
                }; //Address for Sales Admin Queue
                    String[] addressSales = new String[] {
                        Label.TAD_SalesAdmin_FromEmail
                            }; //Address for Priority Queue
                                String[] addressPriority = new String[] {
                                    Label.TAD_Priority_FromEmail
                                        }; //Address for Feedback Queue
                                            String[] addressFeedback = new String[] {
                                                Label.TAD_Feedback_FromEmail
                                                    }; //Address for Logistics Queue
                                                        String[] addressLogistics = new String[] {
                                                            Label.TAD_Logistics_FromEmail
                                                                }; //Address for Flights Queue
                                                                    String[] addressFlights = new String[] {
                                                                        Label.TAD_Flights_FromEmail
                                                                            }; //Address for Visa Insurance Queue
                                                                                String[] addressVisa = new String[] {
                                                                                    Label.TAD_VisaInsurance_FromEmail
                                                                                        };
                                                                                            
                                                                                            email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'email body\n2225256325\nTitle';
        env.fromAddress = 'test@abc.com';
        
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {
            attachment
                };
                    
                    // add an Text atatchment
                    Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] {
            attachmenttext
                };
                    
                    //Test Customisations
                    email.toAddresses = addressCustmisations;
        // call the email service class and test it with the data in the testMethod
        TAD_EmailServiceHandler testInbound = new TAD_EmailServiceHandler();
        testInbound.handleInboundEmail(email, env);
        
        //Test Sales admin
        email.toAddresses = addressSales;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);
        
        //Test Priority
        email.toAddresses = addressPriority;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);
        
        //Test feedback
        email.toAddresses = addressFeedback;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);
        
        //Test logistics
        email.toAddresses = addressLogistics;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);        
        
        //Test flights
        email.toAddresses = addressFlights;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);        
        
        //Test visa insurance
        email.toAddresses = addressVisa;
        // call the email service class and test it with the data in the testMethod
        
        testInbound.handleInboundEmail(email, env);
    }
}