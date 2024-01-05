global class SendNotificationForCompPricing Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Date yesterdays = System.today() - 1;
        List<order_line_POE__c> orderLine = [select id, Max_Price_applied__c from order_line_POE__c where Max_Price_applied__c = true and CreatedDate > :yesterdays];
        Report rep = [select id from report where name ='Order Lines having Max Price Applied'];
        String urlRep = URL.getSalesforceBaseUrl().toExternalForm() + '/' + rep.id;
        if(orderLine.size() > 0){
            String body = 'The report has new records which have Max Price applied. Below is the link to report: <br/>'+urlRep;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string [] toaddress= New string[]{'jasleen.kaur@psagtechnologies.com','kushagra@psagtechnologies.com','naresh.anand@psagtechnologies.com'};
                email.setSubject('Max Price has been applied to new Order Lines');
            email.setHtmlBody(body);
            email.setToAddresses(toaddress);
            Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
        }
    }
}