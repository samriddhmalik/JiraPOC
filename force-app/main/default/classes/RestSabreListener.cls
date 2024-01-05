@RestResource(urlMapping='/pnrevents/*')
global class RestSabreListener {

    @HttpPost
    global static void handlePost() {
        try {

            RestContext.response.statusCode = 202;
            String webhookBody = RestContext.request.requestBody.toString();
            SabrePNRUpdateInboundRequest.PNRCHNG pnrChange = SabrePNRUpdateInboundRequest.parsePnrChange(webhookBody);

            if (pnrChange.notificationType == 'PNRCHNG') {
                String pnrName = pnrChange.locator;

                PNR__c pnr = [SELECT Id, Name, Order__c FROM PNR__c WHERE Name = :pnrName];

                PNR__c newPnr = new PNR__c();
                newPnr.Name = pnrName;
                newPnr.Order__c = pnr.Order__c;

                //delete pnr;
                System.debug('pnr to delete: ' + pnr);
                //insert newPnr;
                System.debug('newPnr to insert ' + newPnr);
            }

        } catch (Exception e) {
            //do some error handling
            System.debug('pnrevents POST Listener no good');
            RestContext.response.statusCode = 202;
        }
    }

    @HttpGet
    global static void handleGet() {

        // Purely for Sabre validation
        RestContext.response.statusCode = 202;

    }

}