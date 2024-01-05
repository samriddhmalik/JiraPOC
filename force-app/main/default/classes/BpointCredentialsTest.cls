@isTest
public with sharing class BpointCredentialsTest {

    @isTest
    public static void testBpointCredentials() {

        String pafAuth = BpointCredentials.getPafAuthorization();
        String allAuth = BpointCredentials.getAllAuthorization();
        String tadAuth = BpointCredentials.getTadAuthorization();

        System.assert(pafAuth != null);
        System.assert(allAuth != null);
        System.assert(tadAuth != null);

        String subP = 'PAF';
        String subA = 'Allstar';
        String subT = 'TAD';
        String subNa = 'Na';

        String testP = BpointCredentials.getSubAuthHeader(subP);
        String testA = BpointCredentials.getSubAuthHeader(subA);
        String testT = BpointCredentials.getSubAuthHeader(subT);
        String testNa = BpointCredentials.getSubAuthHeader(subNa);

        System.assertEquals(pafAuth,testP);
        System.assertEquals(allAuth,testA);
        System.assertEquals(tadAuth,testT);
        System.assertEquals('NOTAVALIDRESULT',testNa);
    }
}