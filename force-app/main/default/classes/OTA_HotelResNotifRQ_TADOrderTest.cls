@isTest
public class OTA_HotelResNotifRQ_TADOrderTest {

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
        deal.Allocation_by__c = 'Sub option';
        deal.deal_type__c = 'Siteminder Hotel';
        deal.per_night_allocation__c = true;
        deal.deal_archetype__c = 'SANUZ';
        //deal.merchant_sharing_deadline__c = 30;
        deal.Flight_Book_By__c = 2;
        insert deal;     
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Price1__c  = 1499;
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2023, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2023, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2023, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2023, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCities =  TestDataFactory.createDepartureCities(deal.Id);
        departureCities.Surcharge__c = 250;
        insert departureCities;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,dd,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
       
       
        Integer i = 1;
       
        customer_POE__c c = new customer_POE__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = String.valueOf(i);
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.dob__c = '15/10/1990';
        insert c;
       
        // creating a record for child
        customer_POE__c c1 = new customer_POE__c();
        c1.ordexp_tad_order__c = order1.Id;
        c1.Order_Line_Item__c=oli.id;
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
        RestContext.request.params.put('tadOrderID',order1.id);
        RestContext.response= res;
        
        
       
        Test.startTest();
        OTA_HotelResNotifRQ_TADOrder.getTheRoomReservationRecord();
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
        deal.Siteminder_Currency_Code__c = 'AUD';
        deal.Allocation_by__c = 'Sub option';
        deal.deal_type__c = 'Siteminder Hotel';
        deal.per_night_allocation__c = true;
        deal.deal_archetype__c = 'SANUZ';
        //deal.merchant_sharing_deadline__c = 30;
        deal.Flight_Book_By__c = 2;
        insert deal;    
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
       
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Price1__c  = 1499;
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2023, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2023, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2023, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2023, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCities =  TestDataFactory.createDepartureCities(deal.Id);
        departureCities.Surcharge__c = 250;
        insert departureCities;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,dd,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
    /*    order.is_web_order__c=true;
        order.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 1099.00,"amount_surcharge": 16.48,' +
            '"amount_charged": 1115.48,"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12345","paid_by_email": ' +
            '"pete.j.russell@gmail.com","paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "t3dsrfsderdo1u","comments": "test comment"}}';
        update order;*/
       
       
        Integer i = 1;
       
        customer_poe__c c = new customer_poe__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = String.valueOf(i);
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.dob__c = '15/10/1990';
        insert c;
       
        // creating a record for child
        customer_poe__c c1 = new customer_poe__c();
        c1.ordexp_tad_order__c = order1.Id;
        c1.Order_Line_Item__c=oli.id;
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
        RestContext.request.params.put('tadOrderID',order1.id);
        RestContext.response= res;
        
        
       
        Test.startTest();
        OTA_HotelResNotifRQ_TADOrder.getTheRoomReservationRecord();
        Test.stopTest();
       
    }
   
    @isTest
    static void coverWrapperMethods() {
       
        OTA_HotelResNotifRQ_TADOrder.timeStamp tp = new   OTA_HotelResNotifRQ_TADOrder.timeStamp();
        tp.day=1;
        tp.hour=1;
        tp.minute=1;
        tp.month=1;
        tp.second=1;
        tp.timezone=1;
        tp.year=1;
       
        OTA_HotelResNotifRQ_TADOrder.Results Results = new   OTA_HotelResNotifRQ_TADOrder.Results();
        Results.CAVV='test';
        Results.DSTransactionID='test';
        Results.ECI='test';
        Results.Enrolled='test';
        Results.PAResStatus='test';
        Results.SignatureVerification='test';
        Results.ThreeDSVersion='test';
        Results.XID='test';
       
        OTA_HotelResNotifRQ_TADOrder.VirtualCreditCard  VirtualCreditCard = new OTA_HotelResNotifRQ_TADOrder.VirtualCreditCard();
        VirtualCreditCard.isVCC=true;
        VirtualCreditCard.VCCActivationDate=Date.newInstance(2022, 01, 02);
        VirtualCreditCard.VCCCurrencyCode='test';
        VirtualCreditCard.VCCDeactivationDate=Date.newInstance(2022, 01, 02);
        VirtualCreditCard.VCCCurrentBalance=1234;  
       
        OTA_HotelResNotifRQ_TADOrder.CardHolderName CardHolderName = new OTA_HotelResNotifRQ_TADOrder.CardHolderName();
        CardHolderName.CardHolderName='test';
       
        OTA_HotelResNotifRQ_TADOrder.ThreeDomainSecurity ThreeDomainSecurity = new OTA_HotelResNotifRQ_TADOrder.ThreeDomainSecurity();
        ThreeDomainSecurity.Results=Results;
       
        OTA_HotelResNotifRQ_TADOrder.TPA_Extensions TPA_Extensions= new OTA_HotelResNotifRQ_TADOrder.TPA_Extensions();
        TPA_Extensions.VirtualCreditCard=VirtualCreditCard;
       
        OTA_HotelResNotifRQ_TADOrder.PaymentCard PaymentCard = new   OTA_HotelResNotifRQ_TADOrder.PaymentCard();
        PaymentCard.CardCode='123';
        PaymentCard.CardNumber='123';
        PaymentCard.CardType=123;
        PaymentCard.ExpireDate='123';
        PaymentCard.SeriesCode='123';
        PaymentCard.CardHolderName=CardHolderName;
        PaymentCard.ThreeDomainSecurity=ThreeDomainSecurity;
        PaymentCard.TPA_Extensions=TPA_Extensions;
       
       
        OTA_HotelResNotifRQ_TADOrder.Text Text= new OTA_HotelResNotifRQ_TADOrder.Text();
        Text.Text='123';
       
        OTA_HotelResNotifRQ_TADOrder.TaxDescription TaxDescription= new OTA_HotelResNotifRQ_TADOrder.TaxDescription();
        TaxDescription.Text=Text;
       
        List<OTA_HotelResNotifRQ_TADOrder.Tax> taxList = new List<OTA_HotelResNotifRQ_TADOrder.Tax>();
        OTA_HotelResNotifRQ_TADOrder.Tax  Tax = new OTA_HotelResNotifRQ_TADOrder.Tax();
        Tax.Amount=1;
        Tax.Code='123';
        Tax.CurrencyCode='123';
        Tax.Percentage=10;
        Tax.x_Type='123';
        Tax.TaxDescription=TaxDescription;
        taxList.add(Tax);
       
        OTA_HotelResNotifRQ_TADOrder.Taxes Taxes = new OTA_HotelResNotifRQ_TADOrder.Taxes();
        Taxes.Tax =taxList;
       
        OTA_HotelResNotifRQ_TADOrder.Base Base = new OTA_HotelResNotifRQ_TADOrder.Base();
        Base.AmountAfterTax =1;
        Base.AmountBeforeTax=1;
        Base.CurrencyCode='asd';
        Base.Taxes = Taxes;
       
        OTA_HotelResNotifRQ_TADOrder.RateDescription  RateDescription = new OTA_HotelResNotifRQ_TADOrder.RateDescription();
        RateDescription.Text='text';
       
        OTA_HotelResNotifRQ_TADOrder.Total Total = new OTA_HotelResNotifRQ_TADOrder.Total();
        Total.AmountAfterTax=123;
        Total.AmountBeforeTax=123;
        Total.CurrencyCode='123';
        Total.Taxes=Taxes;
       
        OTA_HotelResNotifRQ_TADOrder.Price Price= new OTA_HotelResNotifRQ_TADOrder.Price();
        Price.Base = Base;
        Price.RateDescription=RateDescription;
        Price.Total=Total;
       
        OTA_HotelResNotifRQ_TADOrder.TimeSpan  TimeSpan = new OTA_HotelResNotifRQ_TADOrder.TimeSpan();
        TimeSpan.endDate=Date.newInstance(2022, 01, 02);
        TimeSpan.Start=Date.newInstance(2022, 01, 02);
       
        OTA_HotelResNotifRQ_TADOrder.ServiceDetails ServiceDetails= new OTA_HotelResNotifRQ_TADOrder.ServiceDetails();
        ServiceDetails.TimeSpan=TimeSpan;
       
        OTA_HotelResNotifRQ_TADOrder.Service Service = new OTA_HotelResNotifRQ_TADOrder.Service();
        Service.Inclusive=true;
        Service.Quantity=1;
        Service.ServiceInventoryCode='123';
        Service.ServiceRPH='123';
        Service.x_Id='123';
        Service.Price = Price;
        Service.ServiceDetails=ServiceDetails;
       
        OTA_HotelResNotifRQ_TADOrder.Rate Rate = new  OTA_HotelResNotifRQ_TADOrder.Rate();
        Rate.Base=Base;
        Rate.EffectiveDate=Date.newInstance(2022, 01, 02);
        Rate.ExpireDate=   Date.newInstance(2022, 01, 02);
        Rate.RateTimeUnit='123';
        Rate.Total=Total;
        Rate.UnitMultiplier=1;
       
        OTA_HotelResNotifRQ_TADOrder.CityName CityName = new OTA_HotelResNotifRQ_TADOrder.CityName();
        CityName.Text=Text;
       
        OTA_HotelResNotifRQ_TADOrder.CountryName CountryName = new OTA_HotelResNotifRQ_TADOrder.CountryName();
        CountryName.Text=Text;
       
        OTA_HotelResNotifRQ_TADOrder.PostalCode PostalCode = new OTA_HotelResNotifRQ_TADOrder.PostalCode();
        PostalCode.Text=Text;
       
        OTA_HotelResNotifRQ_TADOrder.StateProv StateProv = new OTA_HotelResNotifRQ_TADOrder.StateProv();
        StateProv.Text = Text;
       
        List<OTA_HotelResNotifRQ_TADOrder.AddressLine> AddressLineList = new List<OTA_HotelResNotifRQ_TADOrder.AddressLine> ();
        OTA_HotelResNotifRQ_TADOrder.AddressLine AddressLine = new OTA_HotelResNotifRQ_TADOrder.AddressLine();
        AddressLine.AddressLine='134';
        AddressLineList.add(AddressLine);
       
        OTA_HotelResNotifRQ_TADOrder.Address Address= new OTA_HotelResNotifRQ_TADOrder.Address();
        Address.CityName='123';
        Address.CountryName='123';
        Address.PostalCode='123';
        Address.StateProv='123';
        Address.AddressLine =AddressLineList;
        
        OTA_HotelResNotifRQ_TADOrder.TransportInfo transportInfo = new OTA_HotelResNotifRQ_TADOrder.TransportInfo();
        transportInfo.x_Id = 'nkjdfnsgk';
        transportInfo.x_Time = system.now();
        transportInfo.x_Type = 'test';
       
       	OTA_HotelResNotifRQ_TADOrder.Text textForEmail = new OTA_HotelResNotifRQ_TADOrder.Text();
        textForEmail.Text = 'test123@test.com';
        
        OTA_HotelResNotifRQ_TADOrder.Email newEmail = new OTA_HotelResNotifRQ_TADOrder.Email();
        newEmail.Text = textForEmail;
        
        OTA_HotelResNotifRQ_TADOrder.Text textForCityName = new OTA_HotelResNotifRQ_TADOrder.Text();
        textForCityName.Text = 'Adelaide';
        
        OTA_HotelResNotifRQ_TADOrder.CityName newCity = new OTA_HotelResNotifRQ_TADOrder.CityName();
        newEmail.Text = textForCityName;
        
        OTA_HotelResNotifRQ_TADOrder.Text textForPostalCode = new OTA_HotelResNotifRQ_TADOrder.Text();
        textForPostalCode.Text = '593453';
        
        OTA_HotelResNotifRQ_TADOrder.PostalCode newCityPostalCode = new OTA_HotelResNotifRQ_TADOrder.PostalCode();
        newCityPostalCode.Text = textForPostalCode;
        
        OTA_HotelResNotifRQ_TADOrder.Text textForStateProvince = new OTA_HotelResNotifRQ_TADOrder.Text();
        textForStateProvince.Text = 'VICTORIA';
        
        OTA_HotelResNotifRQ_TADOrder.StateProv newCityStateProv = new OTA_HotelResNotifRQ_TADOrder.StateProv();
        newCityStateProv.Text = textForStateProvince;
        
		OTA_HotelResNotifRQ_TADOrder.Text newCountryName = new OTA_HotelResNotifRQ_TADOrder.Text();
        newCountryName.Text = 'Australia';
        
        OTA_HotelResNotifRQ_TADOrder.CountryName newCityCountryName = new OTA_HotelResNotifRQ_TADOrder.CountryName();
        newCityCountryName.Text = newCountryName;        
        
        List<OTA_HotelResNotifRQ_TADOrder.AddressLine> listOfAddressLine = new  List<OTA_HotelResNotifRQ_TADOrder.AddressLine>();
        
        OTA_HotelResNotifRQ_TADOrder.AddressLine add1 = new OTA_HotelResNotifRQ_TADOrder.AddressLine();
        add1.AddressLine = '211';
        listOfAddressLine.add(add1);
        
        OTA_HotelResNotifRQ_TADOrder.AddressLine add2 = new OTA_HotelResNotifRQ_TADOrder.AddressLine();
        add2.AddressLine = 'King Street';
        listOfAddressLine.add(add2);
        
        OTA_HotelResNotifRQ_TADOrder.AddressInfo addNew = new OTA_HotelResNotifRQ_TADOrder.AddressInfo();
        addNew.AddressLine = listOfAddressLine;
        addNew.CityName = newCity;
        addNew.PostalCode = newCityPostalCode;
        addNew.StateProv = newCityStateProv;
        addNew.CountryName = newCityCountryName;
        
        OTA_HotelResNotifRQ_TADOrder.CompanyInfo companyInfo = new OTA_HotelResNotifRQ_TADOrder.CompanyInfo();
        OTA_HotelResNotifRQ_TADOrder.TelephoneInfo teleInfo = new OTA_HotelResNotifRQ_TADOrder.TelephoneInfo();
        teleInfo.PhoneNumber = '264732';
        companyInfo.TelephoneInfo = teleInfo;
        companyInfo.Email = newEmail;
		companyInfo.AddressInfo = addNew;
		   
        
        OTA_HotelResNotifRQ_TADOrder.ArrivalTransport arrivalInfo = new OTA_HotelResNotifRQ_TADOrder.ArrivalTransport();
        arrivalInfo.TransportInfo = transportInfo;
        
        OTA_HotelResNotifRQ_TADOrder.DepartureTransport departureInfo = new OTA_HotelResNotifRQ_TADOrder.DepartureTransport();
        departureInfo.TransportInfo = transportInfo;
        
        OTA_HotelResNotifRQ_TADOrder.ResGuest resGuestDummy = new OTA_HotelResNotifRQ_TADOrder.ResGuest();
        resGuestDummy.ResGuestRPH = 4;
        resGuestDummy.PrimaryIndicator = true;
        resGuestDummy.ArrivalTime = time.newInstance(12, 00, 00, 00);
        resGuestDummy.ArrivalTransport = arrivalInfo;
        resGuestDummy.DepartureTransport = departureInfo;
    }
   
   
   
    
}