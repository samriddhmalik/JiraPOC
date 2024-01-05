@isTest
public class OTA_HotelResNotifRQTest {
    @isTest
    static void testHttpGetHotelResponseError() {
       
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        deal.Siteminder_Currency_Code__c = 'AUD';
        insert deal;        
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2022, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        order__c legorders = new order__c();
        //TestDataFactory.createOrders(acctPerson , deal , options , subOptions , dd , departureCity, RTOrderList[0].Id  );
        legorders.Sub_Options__c = subOptions.id;
        legorders.Account__c = acctPerson.id;
        legorders.RecordTypeId = RTOrderList[0].Id;
        legorders.deal__c = deal.id;
        legorders.Options__c = options.id;
        legorders.departures_dates__c = dd.id;
        legorders.SiteMinder_Start_Date__c = dd.date__c;
        legorders.SiteMinder_End_Date__c = date.newInstance(2022, 01, 02);
        legorders.qty__c = 1;
        legorders.departure_cities__c = departureCity.Id;

        legorders.SiteMinder_Start_Date__c=Date.newInstance(2022, 01, 01);
        legorders.qty__c=1;
        legorders.SiteMinder_End_Date__c=Date.newInstance(2022, 01, 02);
        /*order.is_web_order__c=true;
        order.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 1099.00,"amount_surcharge": 16.48,' +
            '"amount_charged": 1115.48,"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12345","paid_by_email": ' +
            '"pete.j.russell@gmail.com","paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "tdfrt3o1u","comments": "test comment"}}';
       */
        insert legorders;
       
       
        Integer i = 1;
       
        customer__c c = new customer__c();
        c.order__c = legorders.Id;
        c.first_name__c = String.valueOf(i);
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.dob__c = '15/10/1990';
        insert c;
       
        // creating a record for child
        customer__c c1 = new customer__c();
        c1.order__c = legorders.Id;
        c1.first_name__c = String.valueOf(i);
        c1.last_name__c = 'tester';
        c1.pif_final__c = true;
        c1.dob__c = '10/10/2019';
        insert c1;
       
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.request.params.put('tadOrderID',legorders.id);
        RestContext.response= res;
        
        
       
        Test.startTest();
        OTA_HotelResNotifRQ.getTheRoomReservationRecord();
        Test.stopTest();
       
    }
    
    @isTest
    static void testHttpGetHotelResponseError1() {
       
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        insert deal;        
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2022, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        order__c order = new order__c();
        //TestDataFactory.createOrders(acctPerson , deal , options , subOptions , dd , departureCity, RTOrderList[0].Id  );
        order.Sub_Options__c = subOptions.id;
        order.Account__c = acctPerson.id;
        order.RecordTypeId = RTOrderList[0].Id;
        order.deal__c = deal.id;
        order.Options__c = options.id;
        order.departures_dates__c = dd.id;
        order.SiteMinder_Start_Date__c = dd.date__c;
        order.SiteMinder_End_Date__c = date.newInstance(2022, 01, 02);
        order.qty__c = 1;
        order.departure_cities__c = departureCity.Id;

        order.SiteMinder_Start_Date__c=Date.newInstance(2022, 01, 01);
        order.qty__c=1;
        order.SiteMinder_End_Date__c=Date.newInstance(2022, 01, 02);
        order.option_line_price__c = 400.00;
        order.update_order__c = 'All Good!';
        insert order;
    /*    order.is_web_order__c=true;
        order.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 1099.00,"amount_surcharge": 16.48,' +
            '"amount_charged": 1115.48,"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12345","paid_by_email": ' +
            '"pete.j.russell@gmail.com","paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "t3dsrfsderdo1u","comments": "test comment"}}';
        update order;*/
       
       
        Integer i = 1;
       
        customer__c c = new customer__c();
        c.order__c = order.Id;
        c.first_name__c = String.valueOf(i);
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.dob__c = '15/10/1990';
        insert c;
       
        // creating a record for child
        customer__c c1 = new customer__c();
        c1.order__c = order.Id;
        c1.first_name__c = String.valueOf(i);
        c1.last_name__c = 'tester';
        c1.pif_final__c = true;
        c1.dob__c = '10/10/2019';
        insert c1;
       
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.request.params.put('tadOrderID',order.id);
        RestContext.response= res;
        
        
       
        Test.startTest();
        OTA_HotelResNotifRQ.getTheRoomReservationRecord();
        Test.stopTest();
       
    }
   
    @isTest
    static void coverWrapperMethods() {
       
        OTA_HotelResNotifRQ.timeStamp tp = new   OTA_HotelResNotifRQ.timeStamp();
        tp.day=1;
        tp.hour=1;
        tp.minute=1;
        tp.month=1;
        tp.second=1;
        tp.timezone=1;
        tp.year=1;
       
        OTA_HotelResNotifRQ.Results Results = new   OTA_HotelResNotifRQ.Results();
        Results.CAVV='test';
        Results.DSTransactionID='test';
        Results.ECI='test';
        Results.Enrolled='test';
        Results.PAResStatus='test';
        Results.SignatureVerification='test';
        Results.ThreeDSVersion='test';
        Results.XID='test';
       
        OTA_HotelResNotifRQ.VirtualCreditCard  VirtualCreditCard = new OTA_HotelResNotifRQ.VirtualCreditCard();
        VirtualCreditCard.isVCC=true;
        VirtualCreditCard.VCCActivationDate=Date.newInstance(2022, 01, 02);
        VirtualCreditCard.VCCCurrencyCode='test';
        VirtualCreditCard.VCCDeactivationDate=Date.newInstance(2022, 01, 02);
        VirtualCreditCard.VCCCurrentBalance=1234;  
       
        OTA_HotelResNotifRQ.CardHolderName CardHolderName = new OTA_HotelResNotifRQ.CardHolderName();
        CardHolderName.CardHolderName='test';
       
        OTA_HotelResNotifRQ.ThreeDomainSecurity ThreeDomainSecurity = new OTA_HotelResNotifRQ.ThreeDomainSecurity();
        ThreeDomainSecurity.Results=Results;
       
        OTA_HotelResNotifRQ.TPA_Extensions TPA_Extensions= new OTA_HotelResNotifRQ.TPA_Extensions();
        TPA_Extensions.VirtualCreditCard=VirtualCreditCard;
       
        OTA_HotelResNotifRQ.PaymentCard PaymentCard = new   OTA_HotelResNotifRQ.PaymentCard();
        PaymentCard.CardCode='123';
        PaymentCard.CardNumber='123';
        PaymentCard.CardType=123;
        PaymentCard.ExpireDate='123';
        PaymentCard.SeriesCode='123';
        PaymentCard.CardHolderName=CardHolderName;
        PaymentCard.ThreeDomainSecurity=ThreeDomainSecurity;
        PaymentCard.TPA_Extensions=TPA_Extensions;
       
       
        OTA_HotelResNotifRQ.Text Text= new OTA_HotelResNotifRQ.Text();
        Text.Text='123';
       
        OTA_HotelResNotifRQ.TaxDescription TaxDescription= new OTA_HotelResNotifRQ.TaxDescription();
        TaxDescription.Text=Text;
       
        List<OTA_HotelResNotifRQ.Tax> taxList = new List<OTA_HotelResNotifRQ.Tax>();
        OTA_HotelResNotifRQ.Tax  Tax = new OTA_HotelResNotifRQ.Tax();
        Tax.Amount=1;
        Tax.Code='123';
        Tax.CurrencyCode='123';
        Tax.Percentage=10;
        Tax.x_Type='123';
        Tax.TaxDescription=TaxDescription;
        taxList.add(Tax);
       
        OTA_HotelResNotifRQ.Taxes Taxes = new OTA_HotelResNotifRQ.Taxes();
        Taxes.Tax =taxList;
       
        OTA_HotelResNotifRQ.Base Base = new OTA_HotelResNotifRQ.Base();
        Base.AmountAfterTax =1;
        Base.AmountBeforeTax=1;
        Base.CurrencyCode='asd';
        Base.Taxes = Taxes;
       
        OTA_HotelResNotifRQ.RateDescription  RateDescription = new OTA_HotelResNotifRQ.RateDescription();
        RateDescription.Text='text';
       
        OTA_HotelResNotifRQ.Total Total = new OTA_HotelResNotifRQ.Total();
        Total.AmountAfterTax=123;
        Total.AmountBeforeTax=123;
        Total.CurrencyCode='123';
        Total.Taxes=Taxes;
       
        OTA_HotelResNotifRQ.Price Price= new OTA_HotelResNotifRQ.Price();
        Price.Base = Base;
        Price.RateDescription=RateDescription;
        Price.Total=Total;
       
        OTA_HotelResNotifRQ.TimeSpan  TimeSpan = new OTA_HotelResNotifRQ.TimeSpan();
        TimeSpan.endDate=Date.newInstance(2022, 01, 02);
        TimeSpan.Start=Date.newInstance(2022, 01, 02);
       
        OTA_HotelResNotifRQ.ServiceDetails ServiceDetails= new OTA_HotelResNotifRQ.ServiceDetails();
        ServiceDetails.TimeSpan=TimeSpan;
       
        OTA_HotelResNotifRQ.Service Service = new OTA_HotelResNotifRQ.Service();
        Service.Inclusive=true;
        Service.Quantity=1;
        Service.ServiceInventoryCode='123';
        Service.ServiceRPH='123';
        Service.x_Id='123';
        Service.Price = Price;
        Service.ServiceDetails=ServiceDetails;
       
        OTA_HotelResNotifRQ.Rate Rate = new  OTA_HotelResNotifRQ.Rate();
        Rate.Base=Base;
        Rate.EffectiveDate=Date.newInstance(2022, 01, 02);
        Rate.ExpireDate=   Date.newInstance(2022, 01, 02);
        Rate.RateTimeUnit='123';
        Rate.Total=Total;
        Rate.UnitMultiplier=1;
       
        OTA_HotelResNotifRQ.CityName CityName = new OTA_HotelResNotifRQ.CityName();
        CityName.Text=Text;
       
        OTA_HotelResNotifRQ.CountryName CountryName = new OTA_HotelResNotifRQ.CountryName();
        CountryName.Text=Text;
       
        OTA_HotelResNotifRQ.PostalCode PostalCode = new OTA_HotelResNotifRQ.PostalCode();
        PostalCode.Text=Text;
       
        OTA_HotelResNotifRQ.StateProv StateProv = new OTA_HotelResNotifRQ.StateProv();
        StateProv.Text = Text;
       
        List<OTA_HotelResNotifRQ.AddressLine> AddressLineList = new List<OTA_HotelResNotifRQ.AddressLine> ();
        OTA_HotelResNotifRQ.AddressLine AddressLine = new OTA_HotelResNotifRQ.AddressLine();
        AddressLine.AddressLine='134';
        AddressLineList.add(AddressLine);
       
        OTA_HotelResNotifRQ.Address Address= new OTA_HotelResNotifRQ.Address();
        Address.CityName='123';
        Address.CountryName='123';
        Address.PostalCode='123';
        Address.StateProv='123';
        Address.AddressLine =AddressLineList;
        
        OTA_HotelResNotifRQ.TransportInfo transportInfo = new OTA_HotelResNotifRQ.TransportInfo();
        transportInfo.x_Id = 'nkjdfnsgk';
        transportInfo.x_Time = system.now();
        transportInfo.x_Type = 'test';
       
       	OTA_HotelResNotifRQ.Text textForEmail = new OTA_HotelResNotifRQ.Text();
        textForEmail.Text = 'test123@test.com';
        
        OTA_HotelResNotifRQ.Email newEmail = new OTA_HotelResNotifRQ.Email();
        newEmail.Text = textForEmail;
        
        OTA_HotelResNotifRQ.Text textForCityName = new OTA_HotelResNotifRQ.Text();
        textForCityName.Text = 'Adelaide';
        
        OTA_HotelResNotifRQ.CityName newCity = new OTA_HotelResNotifRQ.CityName();
        newEmail.Text = textForCityName;
        
        OTA_HotelResNotifRQ.Text textForPostalCode = new OTA_HotelResNotifRQ.Text();
        textForPostalCode.Text = '593453';
        
        OTA_HotelResNotifRQ.PostalCode newCityPostalCode = new OTA_HotelResNotifRQ.PostalCode();
        newCityPostalCode.Text = textForPostalCode;
        
        OTA_HotelResNotifRQ.Text textForStateProvince = new OTA_HotelResNotifRQ.Text();
        textForStateProvince.Text = 'VICTORIA';
        
        OTA_HotelResNotifRQ.StateProv newCityStateProv = new OTA_HotelResNotifRQ.StateProv();
        newCityStateProv.Text = textForStateProvince;
        
		OTA_HotelResNotifRQ.Text newCountryName = new OTA_HotelResNotifRQ.Text();
        newCountryName.Text = 'Australia';
        
        OTA_HotelResNotifRQ.CountryName newCityCountryName = new OTA_HotelResNotifRQ.CountryName();
        newCityCountryName.Text = newCountryName;        
        
        List<OTA_HotelResNotifRQ.AddressLine> listOfAddressLine = new  List<OTA_HotelResNotifRQ.AddressLine>();
        
        OTA_HotelResNotifRQ.AddressLine add1 = new OTA_HotelResNotifRQ.AddressLine();
        add1.AddressLine = '211';
        listOfAddressLine.add(add1);
        
        OTA_HotelResNotifRQ.AddressLine add2 = new OTA_HotelResNotifRQ.AddressLine();
        add2.AddressLine = 'King Street';
        listOfAddressLine.add(add2);
        
        OTA_HotelResNotifRQ.AddressInfo addNew = new OTA_HotelResNotifRQ.AddressInfo();
        addNew.AddressLine = listOfAddressLine;
        addNew.CityName = newCity;
        addNew.PostalCode = newCityPostalCode;
        addNew.StateProv = newCityStateProv;
        addNew.CountryName = newCityCountryName;
        
        OTA_HotelResNotifRQ.CompanyInfo companyInfo = new OTA_HotelResNotifRQ.CompanyInfo();
        OTA_HotelResNotifRQ.TelephoneInfo teleInfo = new OTA_HotelResNotifRQ.TelephoneInfo();
        teleInfo.PhoneNumber = '264732';
        companyInfo.TelephoneInfo = teleInfo;
        companyInfo.Email = newEmail;
		companyInfo.AddressInfo = addNew;
		   
        
        OTA_HotelResNotifRQ.ArrivalTransport arrivalInfo = new OTA_HotelResNotifRQ.ArrivalTransport();
        arrivalInfo.TransportInfo = transportInfo;
        
        OTA_HotelResNotifRQ.DepartureTransport departureInfo = new OTA_HotelResNotifRQ.DepartureTransport();
        departureInfo.TransportInfo = transportInfo;
        
        OTA_HotelResNotifRQ.ResGuest resGuestDummy = new OTA_HotelResNotifRQ.ResGuest();
        resGuestDummy.ResGuestRPH = 4;
        resGuestDummy.PrimaryIndicator = true;
        resGuestDummy.ArrivalTime = time.newInstance(12, 00, 00, 00);
        resGuestDummy.ArrivalTransport = arrivalInfo;
        resGuestDummy.DepartureTransport = departureInfo;
    }
   
    @isTest
    static void legacyOrderInsert() {
      List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.Hotel_Code__c='12345';
        insert deal;        
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
       
        Set<id> setOfAllocationIds = new Set<Id>();
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
        setOfAllocationIds.add(acc.Id);
        setOfAllocationIds.add(acc1.Id);
       
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2022, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
        
        Map<Id, coupon__c> mapOfIdWithCoupons = new Map<Id, coupon__c>();
        
        coupon__c coupon = TestDataFactory.createCoupon();
        coupon.Name__c = 'testcoupon0';      
        coupon.Discount__c = 200.00;
        insert coupon;
        mapOfIdWithCoupons.put(coupon.Id, coupon);

        coupon__c coupon1 = TestDataFactory.createCoupon();
        insert coupon1;
        mapOfIdWithCoupons.put(coupon1.Id, coupon1);
    
        List<order__c> listOfOrders = new List<order__c>();
       
        order__c order = new order__c();
        //TestDataFactory.createOrders(acctPerson , deal , options , subOptions , dd , departureCity, RTOrderList[0].Id  );
        order.Sub_Options__c = subOptions.id;
        order.Account__c = acctPerson.id;
        order.RecordTypeId = RTOrderList[0].Id;
        order.deal__c = deal.id;
        order.Options__c = options.id;
        order.departures_dates__c = dd.id;
        order.SiteMinder_Start_Date__c = dd.date__c;
        order.SiteMinder_End_Date__c = date.newInstance(2022, 01, 02);
        order.qty__c = 1;
        order.departure_cities__c = departureCity.Id;
        order.status__c = 'onHoldWeb';
        order.qty__c=1;
        order.user_email__c = 'test@gmail.com';
        order.option_line_price__c = 400.00;
        order.update_order__c = 'All Good!';
        insert order;
        order.coupon__c = coupon.Id + '|' + coupon1.Id;
        order.qty__c=2;
        update order;
        
        listOfOrders.add(order);
        
        List<Order_Coupon__c> listOfOcs = new List<Order_Coupon__c>();
        
        Order_Coupon__c oc = new Order_Coupon__c();
        oc.coupon__c = coupon.Id;
        oc.order__c = order.Id;
        oc.total_discounts__c = 200.00;
        listOfOcs.add(oc);
        
        Order_Coupon__c oc1 = new Order_Coupon__c();
        oc1.coupon__c = coupon1.Id;
        oc1.order__c = order.Id;
        oc.total_discounts__c = 100.00;
        listOfOcs.add(oc1);
       /*
        Payment_Transaction__c pt = new Payment_Transaction__c();
            pt.amount_charged__c = 210.00;
            pt.amount_original__c = 200.00;
            pt.amount_surcharge__c = 10.00;
            pt.order__c = order.Id;
            pt.transaction_date__c = Date.today();
            pt.transaction_idenifier__c = 'ABC123';
            pt.method__c = 'BPoint';
            pt.transaction_type__c = 'Payment';
            pt.currency_code__c = 'AUD';

            insert pt;
        */
       SiteMinderUtilClass.sendEmailToDev('test','test');
        Test.startTest();
        SiteMinderUtilClass.customRollupOfAllocation(setOfAllocationIds);
        SiteMinderUtilClass.handleCoupons(listOfOrders);
        SiteMinderUtilClass.haveCouponsChanged(listOfOcs,mapOfIdWithCoupons);
        SiteMinderUtilClass.processCouponsFromMap(order,mapOfIdWithCoupons);
        Test.stopTest();
    }
    
      @isTest
    static void newReponseMethod() {
       
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        insert deal;        
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2022, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        order__c order = new order__c();
        //TestDataFactory.createOrders(acctPerson , deal , options , subOptions , dd , departureCity, RTOrderList[0].Id  );
        order.Sub_Options__c = subOptions.id;
        order.Account__c = acctPerson.id;
        order.RecordTypeId = RTOrderList[0].Id;
        order.deal__c = deal.id;
        order.Options__c = options.id;
        order.departures_dates__c = dd.id;
        order.SiteMinder_Start_Date__c = dd.date__c;
        order.SiteMinder_End_Date__c = date.newInstance(2022, 01, 02);
        order.qty__c = 1;
        order.departure_cities__c = departureCity.Id;
        order.SiteMinder_Start_Date__c=Date.newInstance(2022, 01, 01);
        order.qty__c=1;
        order.is_phone_sale__c=true;
        order.SiteMinder_End_Date__c=Date.newInstance(2022, 01, 02);
        order.is_web_order__c=true;
        order.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 1099.00,"amount_surcharge": 16.48,' +
            '"amount_charged": 1115.48,"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12345","paid_by_email": ' +
            '"pete.j.russell@gmail.com","paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "t3dsrfsderdo1u","comments": "test comment"}}';
        order.coupon__c = 'abcd|12345';
        insert order;
       
        test.startTest();
        SiteMinderUtilClass.mapCouponsFromString(order);
        test.stopTest();
            
    }
   
   
}