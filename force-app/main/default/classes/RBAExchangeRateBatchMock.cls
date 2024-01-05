@isTest
public class RBAExchangeRateBatchMock implements HttpCalloutMock 
{
	public HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test", "rates" : {"AUD":1.66,"NZD":1.78,"USD":1.16}}');
        res.setStatusCode(200);
        return res;
    }
}