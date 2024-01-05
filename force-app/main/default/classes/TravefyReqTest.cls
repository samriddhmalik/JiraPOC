@istest
public class TravefyReqTest {
		static testmethod void TestData(){
            
            List<String> image = new List<String>();
            image.add('Large');
            
            List<TravefyReq.TripEvent> listTripEvent = new List<TravefyReq.TripEvent>();
            TravefyReq.TripEvent trEvent = TestDataFactory.travefyReqTripEvent();
            trEvent.images=image;
            listTripEvent.add(trEvent);
             
            List<TravefyReq.TripDay> listTripDay = new List<TravefyReq.TripDay>();
            TravefyReq.TripDay trDay = new TravefyReq.TripDay();
            trDay.dateString='20-01-2019';
            trDay.title='Test';
            trDay.tripEvents=listTripEvent;
            listTripDay.add(trDay);
            
            TravefyReq.Trip tr = TestDataFactory.travefyReqTrip();
            tr.tripDays=listTripDay;
            
            List<TravefyReq.TripUser>listTripUser = new List<TravefyReq.TripUser>();
            TravefyReq.TripUser trUser = new TravefyReq.TripUser();
            trUser.email='xyz@gmail.com';
            trUser.fullName = 'Peter TAD';
            trUser.role='Analyst';
            listTripUser.add(trUser);
            
            TravefyReq.TripUsers trUsers = new TravefyReq.TripUsers();
            trUsers.tripUsers=listTripUser;
            
           TravefyReq.getTripAsJSON(tr);
           TravefyReq.getTripUsersAsJSON(trUsers);
            
        }
}