global class PaymentDataBatch implements Database.Batchable<sObject>, Database.Stateful {

    private list<Payment_Transaction_POE__c> paymentListToInsert;
	global list<Database.SaveResult> saveResultList;
    global string LogString='Tad Order,Status,Amount\n';
    global string csvLogString;
    public PaymentDataBatch(list<Payment_Transaction_POE__c> paymentList) {
        paymentListToInsert = paymentList;
    }

    global Iterable<Payment_Transaction_POE__c> start(Database.BatchableContext BC) {
        return paymentListToInsert;
    }

    global void execute(Database.BatchableContext BC, List<Payment_Transaction_POE__c> paymentListToInsert) {
        system.debug('paymentListToInsert '+paymentListToInsert);
       	Database.SaveResult[] srList = database.insert(paymentListToInsert, false);
        system.debug('srList '+srList);
        saveResultList=srList;
        list<string> orderNo = new list<string>();
        list<Decimal> paymentAmt = new list<Decimal>();
        list<string> result = new list<string>();
        for(Database.SaveResult sr : srList){
            if(!sr.isSuccess()){
				result.add('Failed');
            }else{
                result.add('Success');
            }         
        }
        
        for(Payment_Transaction_POE__c pt:paymentListToInsert){
            orderNo.add(pt.Order_No__c);
            paymentAmt.add(pt.amount_charged__c);
        }
        system.debug('orderNo '+orderNo);
        system.debug('result '+result);
        if(orderNo.size()==result.size()){
            for(integer i=0; i<orderNo.size(); i++){
                LogString+=orderNo[i]+','+result[i]+','+'$'+paymentAmt[i]+'\n';
            }
        }
        system.debug('LogString '+LogString);
        
    }   

    global void finish(Database.BatchableContext BC) {
        system.debug('LogString in finish '+LogString);
        map<String, String> result = new map<String, String> ();
		try{
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(LogString);
        String csvName = 'StatusReport.csv';
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        String cLabel=System.Label.Payment_Status_Report;
            system.debug('cLabel '+cLabel);
            String[] toAddresses=cLabel.split(',');
            system.debug('toAddresses '+toAddresses);
       // String[] toAddresses = new String[]{'kushagra@psagtechnologies.com', 'divyanshee.bansal@psagtechnologies.com', 'akshat.jain@psagtechnologies.com'};
            String subject = 'Payment Transaction Upload Status report';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('PFA a file with status of payment transactions uploaded.');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        email.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        if (r[0].success) {
            System.debug('The email was sent successfully.');
            result.put('SUCCESS', 'The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + r[0].errors[0].message);
            result.put('ERROR', 'The email failed to send: ' + r[0].errors[0].message);
        }
    }
    catch(Exception EX)
    {
        System.debug('The email failed to send: ' + Ex.getMessage());
        result.put('ERROR', 'The email failed to send: ' + Ex.getMessage());
    }        
        
    }
}