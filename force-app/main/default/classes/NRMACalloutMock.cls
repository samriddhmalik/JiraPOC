@isTest
global class NRMACalloutMock implements WebServiceMock {
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
    ) {
        mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType response_x = new mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType();
//        Map<String, mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType> response_map_x = new Map<String, mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType>();
        response_x.MemberStatus = 'True';
        response_x.IdType = 'P';
        response.put('response_x', response_x);
    }
}