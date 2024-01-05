@isTest
global class OTA_TravelClick_HotelResNotifRQ_Mock implements HttpCalloutMock {

     global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/xml');
        response.setBody('<OTA_HotelResNotifRS Version="1.0" TimeStamp="2016-05-26T11:11:50-04:00" EchoToken="1466531393" xmlns="http://www.opentravel.org/OTA/2003/05"> <Success /> <HotelReservations> <HotelReservation ResStatus="Committed"> <ResGlobalInfo> <HotelReservationIDs> <HotelReservationID ResID_Type="13" ResID_Value="Max12345" /> </HotelReservationIDs> </ResGlobalInfo> </HotelReservation> </HotelReservations> </OTA_HotelResNotifRS>');
        response.setStatusCode(200);
        return response; 
    }
}