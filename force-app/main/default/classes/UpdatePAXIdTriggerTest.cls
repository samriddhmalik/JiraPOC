@isTest
public class UpdatePAXIdTriggerTest {
    
    private static testmethod void testTriggerEntry() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Deal'];

        List<RecordType> pprtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = pprtList[0].Id;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
		
        insert account;
        
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = rtList[0].Id;
        deal.site__c = 'AU';
        deal.Merchant__c = account.Id;
        deal.Name = '1234';
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.title__c = '12day';
        deal.description__c = '10 Day 2 for 1 China|Standard|12th November|2017|Brisbane|1';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Cruise_Cabin_Booked_by__c = 'TAD';
        insert deal;
        Id dealId = deal.Id;

        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;

        options__c options = new options__c();
        options.Name = 'option-1234';
        options.site__c = 'AU';
        options.Deal__c = dealId;
        options.title__c = 'options-title';
        insert options;

        Id optionsId = options.Id;

        sub_options__c subOptions = new sub_options__c();
        subOptions.Name = 'suboption-option-1234';
        subOptions.site__c = 'AU';
        subOptions.options__c = optionsId;
        subOptions.title__c = 'subOptions-title';
        subOptions.price__c = 100;
        subOptions.STD_OPT__c = 'Standard';
        subOptions.Active__c = true;
        insert subOptions;

        Id subOptionsId = subOptions.Id;
        departures_dates__c departures_dates = new departures_dates__c();
        departures_dates.Name = '2018-04-24';
        departures_dates.site__c = 'AU';
        departures_dates.Deal__c = dealId;
        departures_dates.options__c = optionsId;
        departures_dates.sub_options__c = subOptionsId;
        departures_dates.allocation__c = 15;
        departures_dates.date__c = Date.newInstance(2018,04,24);
        departures_dates.Active__c = true;
        departures_dates.approve_zero_hss__c = true;
        insert departures_dates;

        Id departures_dates_Id = departures_dates.Id;
        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = dealId;
        departure_cities.site__c = 'AU';
        departure_cities.city__c = 'Sydney';
        departure_cities.Name = 'Sydney-1234';
        insert departure_cities;

        Id departure_cities_Id = departure_cities.Id;
        user__c user = new user__c(First_Name__c='Harry', Last_Name__c='Potter');
        user.email__c = 'pete.j.russell@gmail.com';
        insert user;
        Id userId = user.Id;

        Account acct = new Account(LastName='User', FirstName='TAD', PersonEmail='pete.j.russell@tripadeal.com.au');
        insert acct;
        Id acctId = acct.Id;

        order__c o = new order__c(
                email_purchaser__c = 'pete.j.russell@gmail.com',
                user_id__c = userId,
                Account__c = acctId,
                allocation_status__c = 'Secured',
                order_status__c = 'Confirmed',
                deal__c = dealId,
                update_order__c = 'All Good!',
                options__c = optionsId,
                sub_options__c = subOptionsId,
                departures_dates__c = departures_dates_Id,
                departure_cities__c = departure_cities_Id,
                confirmation_email_sent__c = true,
                Passenger_Confirmation_Email_Sent__c = true,
                qty__c = 2
        );
        insert o;
        Id orderId = o.Id;

        customer__c pax = New customer__c();
        pax.Email__c = 'pete.j.russell@gmail.com';
        pax.order__c = orderId;
        insert pax;
        Id pax_Id = pax.Id;
        
        List<customer__c> paxList = [SELECT Name FROM customer__c WHERE Id = :pax_Id];
           
        contact__c contact =  New contact__c();
        contact.reference_number__c = paxList[0].Name;
        contact.email__c = 'peter@tripadeal.com.au';
        contact.customer__c = pax_Id;
        insert contact;
        Id contact_Id = contact.id;
        
        System.debug('I am causing a pause');
       
        List<contact__c> contactList = [SELECT customer__c FROM contact__c WHERE Id = :contact_Id];
        
        System.assertEquals(pax_Id, contactList[0].customer__c);

    }
}