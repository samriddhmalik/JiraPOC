@isTest
public with sharing class ordercTriggerHandlerTest {

    @testSetup
    static void setupTestData() {

        List<Profile> pf = TADUtils.getUserProfile('System Administrator');
        
        User u = TestDataFactory.createUser(pf[0].id);        
        insert u;

        // Query your permission set name from Organization that your want to test.
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Lock_Orders_On_Export'];

        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;

        system.runAs(u) {

            List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
            
            Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            insert account;

            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
            insert deal;

            Deal_Draft__c dealDraft = new Deal_Draft__c();
            dealDraft.Deal__c = deal.Id;
            dealDraft.Name = deal.Name;
            insert dealDraft;

            Product_FX_Pricing__c pfxp = TestDataFactory.createPFXP();
            insert pfxp;

            Component__c dealc = TestDataFactory.cutomComponent(account,'Flight',pfxp);
            dealc.Deal__c = deal.Id;
            insert dealc;

            options__c options =  TestDataFactory.CreateOptions(deal.Id); 
            options.NIghts__c = 2;
            insert options;

            Component__c optc =TestDataFactory.cutomComponent(account,'Land Tour',pfxp);
            optc.Options__c = options.Id;
            insert optc;

            sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
            insert subOptions;

            Component__c subc = TestDataFactory.cutomComponent(account,'Cruise',pfxp);
            subc.Sub_Options__c = subOptions.Id;
            insert subc;

            List<departures_dates__c> dds = new List<departures_dates__c>();
            departures_dates__c departuresDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
            departuresDates.date__c = Date.newInstance(2018, 04, 24);
            departuresDates.HSS__c = true;
            departuresDates.HSS_amount__c = 50;
            dds.add(departuresDates);
            departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
            dd.Name = '2018-04-25';
            dd.date__c = Date.newInstance(2018, 04, 25);
            dd.HSS__c = true;
            dd.HSS_amount__c = 10;
            dds.add(dd);
            insert dds;

            departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
            departureCity.Surcharge__c = 250;
            insert departureCity;

            land_activity__c la = TestDataFactory.createLandActivityBasic(deal);
            insert la;

            Component__c lac =TestDataFactory.cutomComponent(account,'Land Activity',pfxp);
            lac.Land_Activity__c = la.Id;
            insert lac;

            AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
            insert ae;

            Component__c aec = TestDataFactory.cutomComponent(account,'AE',pfxp);
            aec.Name = '1234-AUDAUD-AE-Brisbane-1234';
            aec.AE_SB__c = ae.Id;
            insert aec;

            AE_SB__c sb =  TestDataFactory.createAE_SBBasic(deal);
            sb.Type__c = 'Stay Behind';
            sb.Name = 'SB-Brisbane-1234';
            sb.name__c = 'SB-Brisbane-1234';
            insert sb;

            Component__c sbc = TestDataFactory.cutomComponent(account,'SB',pfxp);
            sbc.Name = '1234-AUDAUD-SB-Brisbane-1234';
            sbc.AE_SB__c = sb.Id;
            insert sbc;

            stopover__c stopover = new stopover__c();
            stopover.Deal__c = deal.Id;
            insert stopover;

            sub_stopover__c pre =  TestDataFactory.createSubStopover(deal);
            pre.stopover__c = stopover.Id;
            insert pre;

            Component__c prec = TestDataFactory.cutomComponent(account,'S/Over',pfxp);
            prec.Stopover__c = pre.Id;
            insert prec;

            sub_stopover__c post = TestDataFactory.createSubStopover(deal);
            post.stopover__c = stopover.Id;
            post.type__c = 'Post Tour';
            post.Destination__c = 'Bengalli';
            insert post;

            Component__c postc = TestDataFactory.cutomComponent(account,'S/Over',pfxp);
            postc.Stopover__c = post.Id;
            insert postc;

            airline_upgrade__c au = TestDataFactory.airlineUpgrade(deal);
            insert au;

            Component__c auc = TestDataFactory.cutomComponent(account,'Flight Upgrade',pfxp);
            auc.Airline_Upgrade__c = au.Id;
            insert auc;

            
            Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
            acctPerson.FirstName = 'TAD';
            acctPerson.LastName='Test';
            insert acctPerson;

            system.assertEquals(departuresDates.allocated__c, null);

            coupon__c coupon = TestDataFactory.createCoupon();
            insert coupon;

            Test.startTest();

            List<order__c> orders = new List<order__c>();
            order__c o1 = TestDataFactory.createOrders(acctPerson , deal , options , subOptions , departuresDates , departureCity, RTOrderList[0].Id  );
            o1.status__c = 'onHoldWeb';
            o1.is_web_order__c = true;
            o1.update_order__c = 'All Good!';
            o1.ae__c = ae.Id;
            o1.AE_Nights__c = 3;
            o1.sb__c = sb.Id;
            o1.SB_Nights__c = 3;
            o1.pre_tour_stopover__c = pre.Id;
            o1.post_tour_stopover__c = post.Id;
            o1.land_activity__c = la.Id;
            o1.airline_upgrade__c = au.Id;
            o1.qty__c = 2;
            o1.couponused__c = coupon.Id;
            orders.add(o1);

            order__c o2 = o1.clone(false, true, false, false);
            o2.status__c = 'onHoldPhone';
            o2.is_phone_sale__c = true;
            o2.is_web_order__c = false;
            orders.add(o2);

            order__c o3 = new order__c();
            o3.Deal__c=deal.Id;
            o3.allocation_status__c = 'Secured';
            o3.status__c = 'onHoldWeb2';
            o3.is_web_order__c = true;
            o3.order_status__c = 'On Hold';
            o3.update_order__c = 'All Good!';
            o3.options__c=options.Id;
            o3.sub_options__c=subOptions.Id;
            o3.departure_cities__c=departureCity.Id;
            o3.departures_dates__c=departuresDates.Id;
            o3.Account__c=acctPerson.Id;
            o3.qty__c = 2;
            o3.option_line_price__c = 999.00;
            o3.sub_option_line_price__c = 500;
            orders.add(o3);

            insert orders;
            Test.stopTest();

        }
    }

    // Test phone sale insert functions - Referrer, allocation remaining => then expire order.
    static testMethod void myUnitTestA() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
            ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
            web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            departures_dates__c dd = [SELECT Remaining_Allocation__c FROM departures_dates__c WHERE Id = :o.departures_dates__c];

            List<order_line__c> ols = [SELECT Id FROM order_line__c];
            System.assertEquals(0, ols.size());

            order__c o1 = o.clone(false,true,false,false);
            o1.allocation_status__c = 'Secured';
            o1.status__c = 'On Hold';
            o1.update_order__c = 'All Good!';
            o1.qty__c = 2;

            insert o1;

            Test.startTest();

            order__c o1r = [SELECT qty__c, pif_count__c, update_order__c, order_status__c, total_discounts__c, grand_total__c, Referrer__c FROM order__c WHERE Id = :o1.Id];
            departures_dates__c ddr = [SELECT Remaining_Allocation__c FROM departures_dates__c WHERE Id = :o1.departures_dates__c];

            System.assertEquals('On Hold', o1r.order_status__c);
            System.assertEquals('TripADeal', o1r.Referrer__c);
            System.assertEquals(dd.Remaining_Allocation__c - 2, ddr.Remaining_Allocation__c);

            o1r.update_order__c = 'Expire Order';

            ordercTriggerHandler.firstBeforeUpdate = true;
            update o1r;

            order__c o1ur = [SELECT qty__c, order_status__c FROM order__c WHERE Id = :o1.Id];
            System.assertEquals('Expired', o1ur.order_status__c);


            Test.stopTest();
        }
    }

    // Test in phone order - on hold financials...and check everytime functions.
    static testMethod void myUnitTestB() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    coupon__c, web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            departures_dates__c dd = [SELECT Remaining_Allocation__c FROM departures_dates__c WHERE Id = :o.departures_dates__c];

            List<order_line__c> ols = [SELECT Id FROM order_line__c];
            System.assertEquals(0, ols.size());

            order__c o1 = o.clone(false,true,false,false);
            o1.allocation_status__c = 'Secured';
            o1.status__c = 'On Hold';
            o1.is_web_order__c = false;
            o1.update_order__c = 'All Good!';
            o1.qty__c = 2;

            insert o1;

            Test.startTest();

            order__c o1r = [SELECT order_status__c FROM order__c WHERE Id = :o1.Id];
            System.assertEquals('On Hold', o1r.order_status__c);

            order__c o1ur = [SELECT Id, amount_outstanding__c, option_line_price__c, option_qty_price__c, sub_option_line_price__c, sub_option_qty_price__c,
                    hss_line_price__c, hss_qty_price__c, departure_city_line_price__c, departure_city_qty_price__c, land_activity_line_price__c, land_activity_qty_price__c,
                    land_activity_a_line_price__c, land_activity_a_qty_price__c, land_activity_b_line_price__c, land_activity_b_qty_price__c, land_activity_c_line_price__c,
                    land_activity_c_qty_price__c, ae_line_price__c, ae_qty_price__c, sb_line_price__c, sb_qty_price__c, pre_tour_stopover_line_price__c, pre_tour_stopover_qty_price__c,
                    post_tour_stopover_line_price__c, post_tour_stopover_qty_price__c, airline_upgrade_line_price__c, airline_upgrade_qty_price__c, total_price__c, total_discounts__c,
                    description__c, departure_date__c, departure_city__c, exclude_sending_tp__c, email_purchaser__c, first_name_purchaser__c, full_name_purchaser__c, user_email__c,
                    number_of_adults__c, number_of_children__c, qty__c, PAX_QTY__c
                    FROM order__c WHERE Id = :o1.Id];
            Decimal myTotal = o1ur.total_price__c - o1ur.total_discounts__c;

            System.assertEquals(999, o1ur.option_line_price__c);
            System.assertEquals(50, o1ur.hss_line_price__c);
            System.assertEquals(250, o1ur.departure_city_line_price__c);
            System.assertEquals(150, o1ur.land_activity_line_price__c);
            System.assertEquals(0, o1ur.land_activity_a_line_price__c);
            System.assertEquals(0, o1ur.land_activity_b_line_price__c);
            System.assertEquals(0, o1ur.land_activity_c_line_price__c);
            System.assertEquals(200, o1ur.ae_line_price__c);
            System.assertEquals(200, o1ur.sb_line_price__c);
            System.assertEquals(100, o1ur.pre_tour_stopover_line_price__c);
            System.assertEquals(100, o1ur.post_tour_stopover_line_price__c);
            System.assertEquals(6500, o1ur.airline_upgrade_line_price__c);

            System.assertEquals(myTotal, o1ur.amount_outstanding__c);

            System.assertEquals('option|suboption|24th April|2018|Sydney|2', o1ur.description__c);
            System.assertEquals('Sydney', o1ur.departure_city__c);
            System.assertEquals(Date.newInstance(2018,04,24), o1ur.departure_date__c);
            System.assertEquals(true, o1ur.exclude_sending_tp__c);
            System.assertEquals('tripadeal@example.com', o1ur.email_purchaser__c);
            System.assertEquals('TAD', o1ur.first_name_purchaser__c);
            System.assertEquals('TAD Test', o1ur.full_name_purchaser__c);
            System.assertEquals('tripadeal@example.com', o1ur.user_email__c);

            System.assertEquals(0, o1ur.number_of_children__c);
            System.assertEquals(o1ur.qty__c, o1ur.number_of_adults__c);
            System.assert(o1ur.PAX_QTY__c > 0);

            Test.stopTest();
        }
    }

    // Test web order update functions -  Confirmed, Payment transaction is applied to web order, order line items added.
    static testMethod void myUnitTestC() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldWeb' LIMIT 1];

            departures_dates__c dd = [SELECT Remaining_Allocation__c FROM departures_dates__c WHERE Id = :o.departures_dates__c];

            List<order_line__c> ols = [SELECT Id FROM order_line__c];
            System.assertEquals(0, ols.size());

            order__c o1 = o.clone(false,true,false,false);
            o1.allocation_status__c = 'Secured';
            o1.status__c = 'On Hold';
            o1.update_order__c = 'All Good!';
            o1.qty__c = 2;

            insert o1;

            Test.startTest();

            order__c o1r = [SELECT qty__c, pif_count__c, order_status__c, total_discounts__c, grand_total__c, Referrer__c FROM order__c WHERE Id = :o1.Id];

            System.assertEquals('On Hold', o1r.order_status__c);

            o1r.order_status__c = 'Confirmed';
            o1r.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 1099.00,"amount_surcharge": 16.48,' +
                    '"amount_charged": 1115.48,"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12345","paid_by_email": ' +
                    '"pete.j.russell@gmail.com","paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "t3o1u","comments": "test comment"}}';

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            update o1r;
            Test.stopTest();

            Payment_Transaction__c pt = [SELECT Id, order__c, amount_charged__c, transaction_type__c, method__c FROM Payment_Transaction__c WHERE order__c = :o1.Id LIMIT 1];
            System.assertEquals(1115.48,pt.amount_charged__c);
            system.assertEquals('Payment', pt.transaction_type__c);
            system.assertEquals('BPoint', pt.method__c);

            List<order_line__c> olsAU = [SELECT Id FROM order_line__c];
            System.assert(olsAU.size() > 0);

            order__c o1ur = [SELECT qty__c, pif_count__c, order_status__c, confirmed__c, total_discounts__c, web_json__c, grand_total__c, web_payment_processed__c FROM order__c WHERE Id = :o1.Id];
            System.debug('o1 after upsert: ' + o1);
            system.assertEquals(true, o1ur.web_payment_processed__c);
            system.assertEquals(true, o1ur.confirmed__c);
            system.assert(o1ur.web_json__c != null);

        }
    }

    // Test phone sale update functions -  Confirmed, Payment transaction is applied to web order, order line items added.
    static testMethod void myUnitTestD() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            departures_dates__c dd = [SELECT Remaining_Allocation__c FROM departures_dates__c WHERE Id = :o.departures_dates__c];

            List<order_line__c> ols = [SELECT Id FROM order_line__c];
            System.assertEquals(0, ols.size());

            order__c o1 = o.clone(false,true,false,false);
            o1.allocation_status__c = 'Secured';
            o1.status__c = 'On Hold';
            o1.update_order__c = 'All Good!';
            o1.qty__c = 2;

            insert o1;
            ordercTriggerHandler.firstAfterUpdate = true;
            ordercTriggerHandler.firstBeforeUpdate = true;

            Test.startTest();

            order__c o1r = [SELECT qty__c, pif_count__c, order_status__c, total_discounts__c, grand_total__c, Referrer__c, amount_outstanding__c FROM order__c WHERE Id = :o1.Id];
            System.assertEquals('On Hold', o1r.order_status__c);
            System.debug('o status: ' + o1r.order_status__c);

            Payment_Transaction__c pt = new Payment_Transaction__c();
            pt.amount_charged__c = o1r.amount_outstanding__c + 10.00;
            pt.amount_original__c = o1r.amount_outstanding__c;
            pt.amount_surcharge__c = 10.00;
            pt.order__c = o1.Id;
            pt.transaction_date__c = Date.today();
            pt.transaction_idenifier__c = 'ABC123';
            pt.method__c = 'BPoint';
            pt.transaction_type__c = 'Payment';
            pt.currency_code__c = 'AUD';

            insert pt;

            order__c o1ur = [SELECT qty__c, pif_count__c, order_status__c, confirmed__c, total_discounts__c, web_json__c, grand_total__c, amount_outstanding__c FROM order__c WHERE Id = :o1.Id];
            System.assertEquals(true, o1ur.confirmed__c);
            System.assertEquals(0.00, o1ur.amount_outstanding__c);

            Payment_Transaction__c ptai = [SELECT Id, order__c, method__c, transaction_type__c, amount_charged__c FROM Payment_Transaction__c WHERE order__c = :o1.Id LIMIT 1];
            System.assertEquals(pt.amount_charged__c,ptai.amount_charged__c);
            System.assertEquals('Payment', ptai.transaction_type__c);
            System.assertEquals('BPoint', ptai.method__c);

            List<order_line__c> olsAU = [SELECT Id FROM order_line__c];
            System.assert(olsAU.size() > 0);

            Test.stopTest();
        }
    }

    // Test in web order - payment, coupons, expire, un expire.
    static testMethod void myUnitTestE() {
        System.debug('F SELECT USER');
        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){
            System.debug('F GET ORDER');
            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldWeb' LIMIT 1];

            Test.startTest();
            order__c o1 = o.clone(false,true,false,false);
            o1.allocation_status__c = 'Secured';
            o1.status__c = 'On Hold';
            o1.update_order__c = 'All Good!';
            o1.allocation_status__c = 'Secured';
            o1.marketing_source__c = 'Google Search';
            o1.qty__c = 2;
            o1.web_payment_processed__c = false;
            o1.web_json__c = '{"AccountWeb": {"email": "pete.j.russell@gmail.com"},"PaymentTransactionWeb": {"amount_original": 999,"amount_surcharge": 14.98,"amount_charged": 1013.98,' +
                    '"crn1": "pete.j.russell@gmail.com","crn2": "1247+1","crn3": "11111","method": "BPoint","order_id": "W12346","paid_by_email": "pete.j.russell@gmail.com",' +
                    '"paid_by_name": "Peter Russell","transaction_date": "2017-06-27","transaction_idenifier": "t5o4","comments": ""}}';
            o1.transaction_number__c = 'testTransaction2';
            o1.payment_type__c = 'zipMoney';
            o1.amount__c = 1000.00;
            o1.surcharge__c = 14.98;
            //o1.couponused__c = coupon.Id;
            System.debug('F INSERT o1');
            insert o1;

            Test.stopTest();

            coupon__c coupon2 = new coupon__c();
            coupon2.Status__c = 'Enabled';
            coupon2.Name__c = 'testcoupon2';
            coupon2.Discount__c = 2.00;
            coupon2.usable_count__c = 10;
            coupon2.currency_code__c = 'AUD';
            System.debug('F INSERT coupon2');
            insert coupon2;

            o1.update_order__c = 'Expire Order';
            o1.couponused__c = coupon2.Id;
            System.debug('F update o1');
            ordercTriggerHandler.firstBeforeUpdate = true;
            update o1;

//            o1.update_order__c = 'Unexpire Order';
//            update o1;
//
//            o1.order_status__c = 'Confirmed';
//            update o1;

        }
    }

    // Web only lines
    static testMethod void myUnitTestF() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c FROM order__c WHERE status__c = 'onHoldWeb' LIMIT 1];

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'Confirmed';
            o.Account__c = null;
            o.user_email__c = 'tripadeal@example.com';
            o.referrer_attribution__c = 'nrma';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c, Referrer__c, is_web_order__c, Account__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Confirmed', uo.order_status__c);
            System.assertEquals('NRMA Blue', uo.Referrer__c);
            System.assertEquals(true, uo.is_web_order__c);
            System.assert(uo.Account__c != null);

        }
    }
    // Add more here

    // Test in phone order - payment, pax and cancellation utilise test data order
    static testMethod void myUnitTestX1() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            List<order_line__c> ols = [SELECT Id FROM order_line__c];
            System.assertEquals(0, ols.size());

            o.allocation_status__c = 'Secured';
            o.status__c = 'On Hold';
            o.update_order__c = 'All Good!';
            o.AE_Nights__c = 3;
            o.qty__c = 2;

            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            Test.startTest();

            order__c o1r = [SELECT qty__c, pif_count__c, order_status__c, total_discounts__c, grand_total__c, Referrer__c, amount_outstanding__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('On Hold', o1r.order_status__c);

            Payment_Transaction__c pt = new Payment_Transaction__c();
            pt.amount_charged__c = o1r.amount_outstanding__c + 10;
            pt.amount_original__c = o1r.amount_outstanding__c;
            pt.amount_surcharge__c = 10.00;
            pt.order__c = o.Id;
            pt.transaction_date__c = Date.today();
            pt.transaction_idenifier__c = 'ABC123';
            pt.method__c = 'BPoint';
            pt.transaction_type__c = 'Payment';
            pt.currency_code__c = 'AUD';

            insert pt;

            Test.stopTest();

            order__c o1ur = [SELECT qty__c, order_status__c, is_web_order__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('Confirmed', o1ur.order_status__c);

        }
    }
    // Ready for export after pifs returned
    static testMethod void myUnitTestX2() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            coupon__c coupon2 = new coupon__c();
            coupon2.Status__c = 'Enabled';
            coupon2.Name__c = 'testcoupon2';
            coupon2.Discount__c = 2.00;
            coupon2.usable_count__c = 10;
            coupon2.currency_code__c = 'AUD';
            insert coupon2;

            Test.startTest();

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.couponused__c = coupon2.Id;
            o.order_status__c = 'Confirmed';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;


            order__c uo = [SELECT Id, order_status__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Confirmed', uo.order_status__c);
            System.assertEquals(false, uo.ready_for_export__c);

            List<customer__c> pax = new List<customer__c>();
            Integer i = 1;
            while (i < 3) {
                customer__c c = new customer__c();
                c.order__c = o.Id;
                c.first_name__c = String.valueOf(i);
                c.last_name__c = 'tester';
                c.pif_final__c = true;
                pax.add(c);
                i++;
            }

            insert pax;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, pif_outstanding__c, PIF_Returned_Rollup__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];
            System.debug('ord: ' + ord);

            System.assertEquals(true, ord.ready_for_export__c);
            System.assertEquals(2, ord.PIF_Returned_Rollup__c);
            System.assertEquals(0, ord.pif_outstanding__c);
            System.assertEquals('Ready For Export', ord.order_status__c);

        }
    }
    // Cancel confirmed order
    static testMethod void myUnitTestX3() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'Confirmed';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Confirmed', uo.order_status__c);
            System.assertEquals(false, uo.ready_for_export__c);

            Test.startTest();

            uo.update_order__c = 'Cancel Order';
            update uo;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, pif_outstanding__c, PIF_Returned_Rollup__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('Pending Cancellation', ord.order_status__c);

        }
    }
    // Pending Cancellation to Cancelled
    static testMethod void myUnitTestX4() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c  FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];


            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'Pending Cancellation';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Pending Cancellation', uo.order_status__c);
            System.assertEquals(false, uo.ready_for_export__c);

            Test.startTest();

            uo.booking_status__c = 'Cancelled';
            update uo;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, pif_outstanding__c, PIF_Returned_Rollup__c, ready_for_export__c, booking_status__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('Cancelled', ord.order_status__c);
            System.assertEquals('Cancelled', ord.booking_status__c);

        }
    }
    // Unexpire order and insurance quote required
    static testMethod void myUnitTestX5() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];


            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'Expired';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Expired', uo.order_status__c);
            System.assertEquals(false, uo.ready_for_export__c);

            Test.startTest();

            uo.update_order__c = 'Unexpire Order';
            uo.Insurance_Referral__c = 'Insurance Quote Required';
            update uo;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, Call_Back_Status__c, Call_Back_Type__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('On Hold', ord.order_status__c);
            System.assertEquals('Quote Required',ord.Call_Back_Status__c);
            System.assertEquals('Insurance', ord.Call_Back_Type__c);

        }
    }
    // Updateing Order
    static testMethod void myUnitTestX6() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c FROM order__c WHERE status__c = 'onHoldWeb' LIMIT 1];

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.is_web_order__c = true;
            o.is_phone_sale__c = false;
            o.order_status__c = 'Confirmed';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Confirmed', uo.order_status__c);

            Test.startTest();

            uo.update_order__c = 'Updating Order';
            update uo;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, update_order__c, is_phone_sale__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('On Hold', ord.order_status__c);
            System.assertEquals('Updating Order', ord.update_order__c);
            System.assertEquals(true, ord.is_phone_sale__c);

        }
    }

    // Order Nights
    static testMethod void myUnitTestXON() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        system.runAs(u){

            order__c myOrder = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c, isstay__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];
            System.debug('isstay: ' + myOrder.isstay__c);
            Deal__c deal = [SELECT Id, deal_type__c, per_night_allocation__c FROM Deal__c WHERE Id = :myOrder.deal__c];
            deal.deal_type__c = 'stay';
            deal.per_night_allocation__c = true;
            update deal;

            List<Order_Night__c> onsB4 = [SELECT Id, order__c FROM Order_Night__c WHERE order__c = :myOrder.Id];

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c, isstay__c FROM order__c WHERE Id = :myOrder.Id];
            System.debug('isstay: ' + o.isstay__c);

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.qty__c = 1;
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            order__c uo = [SELECT Id, order_status__c FROM order__c WHERE Id = :o.Id];

            Test.startTest();

            uo.update_order__c = 'Updating Order';
            update uo;

            Test.stopTest();

            order__c ord = [SELECT order_status__c, update_order__c, is_phone_sale__c, ready_for_export__c, hss_escapes__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals('On Hold', ord.order_status__c);
            System.assertEquals('Updating Order', ord.update_order__c);
            System.assertEquals(true, ord.is_phone_sale__c);

            List<Order_Night__c> ons = [SELECT Id, order__c, HSS__c FROM Order_Night__c WHERE order__c = :o.Id];
            System.assert(onsB4.size() == 0);
            System.assert(ons.size() > 0);
            System.assertEquals(50, ons[0].HSS__c);
            System.assertEquals(10, ons[1].HSS__c);
            System.assertEquals(60, ord.hss_escapes__c);
        }
    }

    // Enhanced coupons
    static testMethod void myUnitTestXEC1() {

        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];

        order__c ord = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c, amount_outstanding__c, grand_total__c, total_payment_received__c, total_discounts__c 
                    FROM order__c WHERE status__c = 'onHoldWeb2' LIMIT 1];

        List<coupon__c> myCoupons = new List<coupon__c>();

        System.assertEquals(null, ord.couponused__c);
        System.debug('gt: ' + ord.grand_total__c);
        System.debug('tpr: ' + ord.total_payment_received__c);
        System.debug('td: ' + ord.total_discounts__c);
        System.debug('ord.am o: ' + ord.amount_outstanding__c);
        coupon__c coupon1 = new coupon__c();
        coupon1.Status__c = 'Enabled';
        coupon1.Name__c = 'testcoupon1';
        coupon1.Discount__c = ord.amount_outstanding__c - 25.00;
        coupon1.usable_count__c = 1;
        coupon1.currency_code__c = 'AUD';
        myCoupons.add(coupon1);
        
        for (Integer i = 2; i < 5; i++) {
            coupon__c coupon2 = new coupon__c();
            coupon2.Status__c = 'Enabled';
            coupon2.Name__c = 'testcoupon' + String.valueOf(i);
            coupon2.Discount__c = 10.00;
            coupon2.usable_count__c = 1;
            coupon2.currency_code__c = 'AUD';
            coupon2.Usage__c = 'Balance';
            myCoupons.add(coupon2);
        }

        insert myCoupons;

        Map<String, Id> couponsByName = new Map<String, Id>();
        for (coupon__c c : myCoupons) {
            couponsByName.put(c.Name__c, c.Id);
        }

        system.runAs(u){

            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                    ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                    web_json__c, web_payment_processed__c, is_phone_sale__c FROM order__c WHERE Id = :ord.Id];

            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.is_web_order__c = true;
            o.is_phone_sale__c = false;
            o.coupon__c = couponsByName.get('testcoupon1') + '|' + couponsByName.get('testcoupon2') + '|' + couponsByName.get('testcoupon3') + '|' + couponsByName.get('testcoupon4');
            o.order_status__c = 'Confirmed';
            update o;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            List<Order_Coupon__c> newOcs = [SELECT Id, name, order__c, coupon__c FROM Order_Coupon__c WHERE order__c = :o.Id];
            order__c uo = [SELECT Id, order_status__c, amount_outstanding__c, coupon__c FROM order__c WHERE Id = :o.Id];

            System.assertEquals('Confirmed', uo.order_status__c);
            System.assertEquals(4, newOcs.size());
            System.assertEquals(0.00, uo.amount_outstanding__c);
            
            for (Order_Coupon__c oc : newOcs) {
                System.debug('oc: ' + oc);
            }

            coupon__c testcoupon1 = [SELECT Id, name__c, Status__c, balance_remaining__c, Discount__c FROM coupon__c WHERE Id = :couponsByName.get('testcoupon1')];
            coupon__c testcoupon2 = [SELECT Id, name__c, Status__c, balance_remaining__c, Discount__c FROM coupon__c WHERE Id = :couponsByName.get('testcoupon2')];
            coupon__c testcoupon3 = [SELECT Id, name__c, Status__c, balance_remaining__c, Discount__c FROM coupon__c WHERE Id = :couponsByName.get('testcoupon3')];
            coupon__c testcoupon4 = [SELECT Id, name__c, Status__c, balance_remaining__c, Discount__c FROM coupon__c WHERE Id = :couponsByName.get('testcoupon4')];
            
            System.debug(testcoupon1);
            System.debug(testcoupon2);
            System.debug(testcoupon3);
            System.debug(testcoupon4);
            System.assertEquals('Disabled', testcoupon1.Status__c);
            System.assertEquals('Disabled', testcoupon2.Status__c);
            System.assertEquals('Disabled', testcoupon3.Status__c);
            System.assertEquals('Enabled', testcoupon4.Status__c);
            System.assertEquals(5.00, testcoupon4.balance_remaining__c);

            /// Simulate shuffle and change of coupons with customisation addition.
            uo.coupon__c = couponsByName.get('testcoupon1') + '|' + couponsByName.get('testcoupon2') + '|' + couponsByName.get('testcoupon4');
            uo.land_activity_a_line_price__c = 5.00;

            Test.startTest();

            update uo;
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;

            List<Order_Coupon__c> updatedOcs = [SELECT Id, name, order__c, coupon__c FROM Order_Coupon__c WHERE order__c = :o.Id];
            System.assertEquals(3, updatedOcs.size());

            order__c uo2 = [SELECT Id, order_status__c, amount_outstanding__c, coupon__c FROM order__c WHERE Id = :o.Id];
            System.assertEquals(15.00, uo2.amount_outstanding__c);

            testcoupon3 = [SELECT Id, name__c, Status__c, balance_remaining__c, Discount__c FROM coupon__c WHERE Id = :couponsByName.get('testcoupon3')];
            // Will be disabled from first use... will need it reactivated for next use manually, but shouldn't happen user will see its not attached to any order_coupon.
            System.assertEquals('Disabled', testcoupon3.Status__c);

            Test.stopTest();
        }
    }
    
    static testMethod void OrderNightStatusChangeHold() {
        
        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                  EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];
        
        system.runAs(u){
            
            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                          ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                          web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];
            
            
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'On Hold';
            update o;
            
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            
            order__c uo = [SELECT Id, order_status__c,departures_dates__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];
            departures_dates__c dd = [SELECT id FROM departures_dates__c WHERE Id = :uo.departures_dates__c];
            
            Order_Night__c orNights = new Order_Night__c();
            orNights.departures_dates__c=dd.id;
            orNights.order__c=uo.id;
            insert orNights;
            
            uo.order_status__c = 'Expired';
            update uo;
            
            Order_Night__c orn = [SELECT id , status__c FROM Order_Night__c WHERE order__c = :uo.Id];
            System.assertEquals('Hold', orn.status__c);
   
        }
    }
     static testMethod void OrderNightStatusChangeActive() {
        
        User u = [SELECT FirstName,LastName,Email,CompanyName,Title,Username,Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey,
                  EmailEncodingKey,ProfileId,LanguageLocaleKey FROM User WHERE Email = 'test@tripadeal.com.au' LIMIT 1];
        
        system.runAs(u){
            
            order__c o = [SELECT Id, Name, deal__c, allocation_status__c, status__c, is_web_order__c, update_order__c, options__c, Sub_Options__c, departures_dates__c, departure_cities__c,
                          ae__c, AE_Nights__c, sb__c, SB_Nights__c, pre_tour_stopover__c, post_tour_stopover__c, land_activity__c, airline_upgrade__c, Account__c, qty__c, couponused__c, order_status__c,
                          web_json__c, web_payment_processed__c FROM order__c WHERE status__c = 'onHoldPhone' LIMIT 1];
            
            
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            o.order_status__c = 'Expired';
            update o;
            
            ordercTriggerHandler.firstBeforeUpdate = true;
            ordercTriggerHandler.firstAfterUpdate = true;
            
            order__c uo = [SELECT Id, order_status__c,departures_dates__c, ready_for_export__c FROM order__c WHERE Id = :o.Id];
            departures_dates__c dd = [SELECT id FROM departures_dates__c WHERE Id = :uo.departures_dates__c];
            
            Order_Night__c orNights = new Order_Night__c();
            orNights.departures_dates__c=dd.id;
            orNights.order__c=uo.id;
            insert orNights;
            
            uo.order_status__c = 'On Hold';
            update uo;
            
            Order_Night__c orn = [SELECT id , status__c FROM Order_Night__c WHERE order__c = :uo.Id];
            System.assertEquals('Active', orn.status__c);
   
        }
    }
    
}