global class OTA_TravelClick_HotelResNotifRQ {
    
    global class GuestCounts{
        global List<GuestCount> GuestCount{get;set;}
    }
    
    global class GuestCount{
        global Integer AgeQualifyingCode{get;set;}
        global Integer Count{get;set;}
        global Integer Age{get;set;}
    }
    
    @Future(callout=true)
    global static void sendRestCalloutToTravelClick(String tadOrderId){
        
        TAD_Order__c roomBooking = [Select id, Name, CreatedDate, Siteminder_Reservation_ResId__c, ordexp_master_status__c, ordexp_gross_amount__c ,LastModifiedDate, ordexp_departure_date__c, ordexp_departure_date__r.date__c, ordexp_account__c,sm_End_Date__c , ordexp_account__r.FirstName, ordexp_account__r.LastName, ordexp_deal__c, ordexp_deal__r.Hotel_Name__c, ordexp_deal__r.Hotel_Code__c,ordexp_deal__r.RecordType.Name, ordexp_deal__r.Siteminder_Currency_Code__c  from TAD_Order__c where id =:tadOrderId];
        List<Order_Line_Item__c> listOfOLIs = [Select id, Sub_Options__c,Sub_Options__r.Rate_Plan_Code__c,Sub_Options__r.Room_Type_Code__c, orderxp_total_amount__c, OL_Cost__c  from Order_Line_Item__c where ordexp_TAD_Order__c =: roomBooking.Id];

        
        Date startDateOrder = roomBooking.ordexp_departure_date__r.date__c;
        string startDateOrderMonth;
        string startDateOrderDay;
        if(roomBooking.ordexp_departure_date__r.date__c.month() < 10){
            startDateOrderMonth = '0'+string.valueOf(roomBooking.ordexp_departure_date__r.date__c.month());
        }else{
            startDateOrderMonth = string.valueOf(roomBooking.ordexp_departure_date__r.date__c.month());
        }
        
        if(roomBooking.ordexp_departure_date__r.date__c.day() < 10){
            startDateOrderDay = '0'+string.valueOf(roomBooking.ordexp_departure_date__r.date__c.day());
        }else{
            startDateOrderDay = string.valueOf(roomBooking.ordexp_departure_date__r.date__c.day());
        }
        String finalStartDateForTimeSpan = string.valueOf(roomBooking.ordexp_departure_date__r.date__c.year())+'-'+startDateOrderMonth+'-'+startDateOrderDay;
        system.debug('finalStartDateForTimeSpan'+finalStartDateForTimeSpan);
        
        Date endDateOrder = roomBooking.sm_End_Date__c;
        string endDateOrderMonth;
        string endDateOrderDay;
        if(roomBooking.sm_End_Date__c.month() < 10){
            endDateOrderMonth = '0'+string.valueOf(roomBooking.sm_End_Date__c.month());
        }else{
            endDateOrderMonth = string.valueOf(roomBooking.sm_End_Date__c.month());
        }
        
        if(roomBooking.sm_End_Date__c.day() < 10){
            endDateOrderDay = '0'+string.valueOf(roomBooking.sm_End_Date__c.day());
        }else{
            endDateOrderDay = string.valueOf(roomBooking.sm_End_Date__c.day());
        }
        
        String finalEndDateForTimeSpan = string.valueOf(roomBooking.sm_End_Date__c.year())+'-'+endDateOrderMonth+'-'+endDateOrderDay;
        system.debug('finalEndDateForTimeSpan'+finalEndDateForTimeSpan);
        
        Set<Id> setOfOliIds = new Set<Id>();
        if(!listOfOLIs.isempty()){
            for(Order_Line_Item__c oli: listOfOLIs){
                setOfOliIds.add(oli.Id);
            }
        } 
        
        Map<Id,List<customer_POE__c>> mapOfOLIwithPAX = new Map<Id,List<customer_POE__c>>();
        List<customer_POE__c> listOfCustomers = [Select Id, dob__c, ordexp_tad_order__c,first_name__c ,last_name__c , Order_Line_Item__c from customer_POE__c where ordexp_tad_order__c =:tadOrderID and Order_Line_Item__c in : setOfOliIds];
        
        for(customer_POE__c cus : listOfCustomers ){
            
            if(mapOfOLIwithPAX.containsKey(cus.Order_Line_Item__c)){
                List<customer_POE__c> listOfCus = mapOfOLIwithPAX.get(cus.Order_Line_Item__c);
                listOfCus.add(cus);
            }else{
                List<customer_POE__c> listOfCus = new List<customer_POE__c>();
                listOfCus.add(cus);
                mapOfOLIwithPAX.put(cus.Order_Line_Item__c, listOfCus);
            }
        }
        
        Map<Id, List<GuestCount>> mapOfOliIdsWithGuestCounts = new Map<Id, List<GuestCount>>();
        for(String str: mapOfOLIwithPAX.keyset()){
            Integer numberOfAdults_new = 0;
            Integer numberOfChildren_new = 0;
            Integer numberOfInfants_new = 0;
            for(customer_POE__c cus : mapOfOLIwithPAX.get(str)){
                List<String> dobBreakUp = cus.dob__c.split('/');
                Date dobInstance = Date.newInstance(integer.valueOf(dobBreakUp[2]), integer.valueOf(dobBreakUp[1]), integer.valueOf(15));
                Date dateToday = system.today();
                
                Integer months = dobInstance.monthsBetween(dateToday);
                Integer years = integer.valueOf(months / 12);
                
                if(years >=10){
                    numberOfAdults_new = numberOfAdults_new + 1;
                }
                else if(years >= 8 && years<10){
                    numberOfChildren_new = numberOfChildren_new + 1;
                }else{
                    numberOfInfants_new = numberOfInfants_new + 1;
                }          
            }
            
            List<GuestCount> newListOfGuestCounts = new List<GuestCount>();
            
            if(numberOfAdults_new > 0){
                GuestCount guestCountForAdults = new GuestCount();
                guestCountForAdults.AgeQualifyingCode = 10;
                guestCountForAdults.Count = numberOfAdults_new;
                newListOfGuestCounts.add(guestCountForAdults);
            }
            
            if(numberOfChildren_new > 0){
                GuestCount guestCountForChildren = new GuestCount();
                guestCountForChildren.AgeQualifyingCode = 8;
                guestCountForChildren.Count = numberOfChildren_new;
                newListOfGuestCounts.add(guestCountForChildren);
            }
            
            if(numberOfInfants_new > 0){
                GuestCount guestCountForInfants = new GuestCount();
                guestCountForInfants.AgeQualifyingCode = 7;
                guestCountForInfants.Count = numberOfInfants_new;
                newListOfGuestCounts.add(guestCountForInfants);
            }            
            mapOfOliIdsWithGuestCounts.put(str,newListOfGuestCounts);
        }
        
        system.debug('mapOfOliIdsWithGuestCounts'+mapOfOliIdsWithGuestCounts);
        
        String resStatus;
        DateTime dt = roomBooking.CreatedDate;
        DateTime lastModified = roomBooking.LastModifiedDate;
        
        String monthValue;
        String dayValue; 
        String hourValue;
        String minuteValue;
        String secondValue;
        String CreateDateTime;
        String LastModifyDateTime;
        
        if(roomBooking.Siteminder_Reservation_ResId__c == null){
            resStatus = 'Commit';
            
            if(dt.month() < 10){
                monthValue = '0'+dt.month();
            }else{
                monthValue = string.valueOf(dt.month());
            }
            
            if(dt.day() < 10){
                dayValue = '0'+dt.day();
            }else{
                dayValue = string.valueOf(dt.day());
            }
            
            if(dt.hour() < 10){
                hourValue = '0'+dt.hour();
            }else{
                hourValue = string.valueOf(dt.hour());
            }
            
            if(dt.minute() < 10){
                minuteValue = '0'+dt.minute();
            }else{
                minuteValue = string.valueOf(dt.minute());
            }
            
            if(dt.second() < 10){
                secondValue = '0'+dt.second();
            }else{
                secondValue = string.valueOf(dt.second());
            }
            
            CreateDateTime = String.valueOf(dt.year())+'-'+monthValue+'-'+dayValue+'T'+hourValue+':'+minuteValue+':'+secondValue;
            
        }else{
            if(roomBooking.ordexp_master_status__c == 'Secured' || roomBooking.ordexp_master_status__c == 'In Progress'){
                resStatus = 'Modify';
            }
            
            if(roomBooking.ordexp_master_status__c == 'Cancelled'){
                resStatus = 'Cancel';
            }
            
            if(lastModified.month() < 10){
                monthValue = '0'+lastModified.month();
            }else{
                monthValue = string.valueOf(lastModified.month());
            }
            
            if(lastModified.day() < 10){
                dayValue = '0'+lastModified.day();
            }else{
                dayValue = string.valueOf(lastModified.day());
            }
            
            if(lastModified.hour() < 10){
                hourValue = '0'+lastModified.hour();
            }else{
                hourValue = string.valueOf(lastModified.hour());
            }
            
            if(lastModified.minute() < 10){
                minuteValue = '0'+lastModified.minute();
            }else{
                minuteValue = string.valueOf(lastModified.minute());
            }
            
            if(lastModified.second() < 10){
                secondValue = '0'+lastModified.second();
            }else{
                secondValue = string.valueOf(lastModified.second());
            }
            
            LastModifyDateTime = String.valueOf(dt.year())+'-'+monthValue+'-'+dayValue+'T'+hourValue+':'+minuteValue+':'+secondValue;
            
        }
        
        
        //XML Document Writing starts
        
        Dom.Document doc = new Dom.Document();
        
        //Header starts
        Dom.Xmlnode rootNode = doc.createRootElement('OTA_HotelResNotifRQ', null, null);
        rootNode.setAttribute('Version ', '1.0');
        
        //Logic to get TimeStamp
        String timeZone = System.Label.AUS_TimeZone;
        String url = System.Label.OTA_Connect_Reservation_Endpoint;
        DateTime currentTime = system.now();
        
        String tsmonthValue;
        String tsdayValue; 
        String tshourValue;
        String tsminuteValue;
        String tssecondValue;
        
        if(currentTime.month() < 10){
            tsmonthValue = '0'+currentTime.month();
        }else{
            tsmonthValue = string.valueOf(currentTime.month());
        }
        
        if(currentTime.day() < 10){
            tsdayValue = '0'+currentTime.day();
        }else{
            tsdayValue = string.valueOf(currentTime.day());
        }
        
        if(currentTime.hour() < 10){
            tshourValue = '0'+currentTime.hour();
        }else{
            tshourValue = string.valueOf(currentTime.hour());
        }
        
        if(currentTime.minute() < 10){
            tsminuteValue = '0'+currentTime.minute();
        }else{
            tsminuteValue = string.valueOf(currentTime.minute());
        }
        
        if(currentTime.second() < 10){
            tssecondValue = '0'+currentTime.second();
        }else{
            tssecondValue = string.valueOf(currentTime.second());
        }
        
        string TimeStamp = String.valueOf(currentTime.year())+'-'+tsmonthValue+'-'+tsdayValue+'T'+tshourValue+':'+tsminuteValue+':'+tssecondValue+timeZone;
        
        rootNode.setAttribute('TimeStamp', TimeStamp);
        
        //Setting the value for Echotoken
        String EchoToken = TimeStamp + '-' + roomBooking.Id;
        rootNode.setAttribute('EchoToken', EchoToken);
        
        //Setting the XML NAmespace value
        String xmlns = System.Label.OTAConnect_XMLNS ; 
        rootNode.setAttribute('xmlns', xmlns);
        
        //Header ends
        
        //POS Starts
        
        Dom.Xmlnode POSNode = rootNode.addChildElement('POS',null, null);
        Dom.XmlNode SourceNode = POSNode.addChildelement('Source',null,null);
        Dom.XmlNode BookinChannelNode = SourceNode.addChildelement('BookingChannel',null,null);
        BookinChannelNode.setAttribute('Type', '7');
        
        String partnerId = System.Label.OTA_Connect_Partner_ID; 
        Dom.XmlNode CompanyNameNode = BookinChannelNode.addChildElement('CompanyName',null,null);
        CompanyNameNode.setAttribute('Code', partnerId);
        CompanyNameNode.addTextNode(partnerId);
        
        //POS Ends
        
        //HotelReservations starts
        
        Dom.Xmlnode HotelReservationsNode = rootNode.addChildElement('HotelReservations', null, null);
        
        Dom.Xmlnode HotelReservationNode = HotelReservationsNode.addChildElement('HotelReservation', null, null);                          
        HotelReservationNode.setAttribute('ResStatus',resStatus);
        
        if(resStatus == 'Commit'){
            HotelReservationNode.setAttribute('CreateDateTime',CreateDateTime);
        }
        
        if(resStatus == 'Cancel' || resStatus == 'Modify'){
            HotelReservationNode.setAttribute('LastModifyDateTime',LastModifyDateTime);
        }
        
        String ResID_Value;
        if(roomBooking.Siteminder_Reservation_ResId__c == null || roomBooking.Siteminder_Reservation_ResId__c == ''){
            ResID_Value = roomBooking.Id +'-'+roomBooking.Name;
        }else{
            ResID_Value = roomBooking.Siteminder_Reservation_ResId__c;
        }
        
        Dom.Xmlnode ResGlobalInfoNode = HotelReservationNode.addChildElement('ResGlobalInfo', null, null);   
        Dom.Xmlnode HotelReservationIDsNode = ResGlobalInfoNode.addChildElement('HotelReservationIDs', null, null);
        Dom.Xmlnode HotelReservationIDNode = HotelReservationIDsNode.addChildElement('HotelReservationID', null, null);
        HotelReservationIDNode.setAttribute('ResID_Type','13');  
        HotelReservationIDNode.setAttribute('ResID_Value',ResID_Value);  
        
        
        Dom.Xmlnode ResGuestsNode = HotelReservationNode.addChildElement('ResGuests', null, null);
        
        for(customer_POE__c cus : listOfCustomers){
            Dom.Xmlnode ResGuestNode = ResGuestsNode.addChildElement('ResGuest', null, null);    
            //Non mandatory starts
            //ResGuestNode.setAttribute('ResGuestRPH','0');
            //Non mandatory ends
            
            Dom.Xmlnode ProfilesNode = ResGuestNode.addChildElement('Profiles', null, null);
            Dom.Xmlnode ProfileInfoNode = ProfilesNode.addChildElement('ProfileInfo', null, null);
            Dom.Xmlnode ProfileNode = ProfileInfoNode.addChildElement('Profile', null, null);
            Dom.Xmlnode CustomerNode = ProfileNode.addChildElement('Customer', null, null);
            Dom.Xmlnode PersonNameNode = CustomerNode.addChildElement('PersonName', null, null);  
            
            Dom.Xmlnode GivenNameNode = PersonNameNode.addChildElement('GivenName', null, null);
            GivenNameNode.addTextNode(cus.first_name__c);
            
            Dom.Xmlnode SurnameNode = PersonNameNode.addChildElement('Surname', null, null);
            SurnameNode.addTextNode(cus.last_name__c);
            
            //Non mandatory starts
            //Dom.Xmlnode TelephoneNode = CustomerNode.addChildElement('Telephone', null, null);
            //Dom.Xmlnode EmailNode = CustomerNode.addChildElement('Email', null, null);
            //Non mandatory ends 
            
            Dom.Xmlnode AddressNode = CustomerNode.addChildElement('Address', null, null);
            
            Dom.Xmlnode AddressLineNode = AddressNode.addChildElement('AddressLine', null, null);
            AddressLineNode.addTextNode('15 Wollongbar St');
            
            Dom.Xmlnode CityNode = CustomerNode.addChildElement('CityName', null, null);
            CityNode.addTextNode('Byron Bay');
            
            Dom.Xmlnode StateProvNode = CustomerNode.addChildElement('StateProv', null, null);
            StateProvNode.addTextNode('NSW');
            
            Dom.Xmlnode CountryNameNode = CustomerNode.addChildElement('CountryName', null, null);
            CountryNameNode.addTextNode('Australia');
            
            Dom.Xmlnode PostalCodeNode = CustomerNode.addChildElement('PostalCode', null, null);
            PostalCodeNode.addTextNode('2481');
            
        }
        //Special Request Part has now been skipped.
        //Comments part outside the RoomStays.
        
        
        //RoomStays part begins
        Dom.XmlNode RoomStaysNode = HotelReservationNode.addChildElement('RoomStays',null,null);
        integer i=1;
        for(Order_Line_Item__c oliInstance : listOfOLIs){
            
            //RoomStay Instance starts
            Dom.XmlNode RoomStayNode = RoomStaysNode.addChildElement('RoomStay',null,null);
            
            RoomStayNode.setAttribute('IndexNumber',string.valueOf(i));
            
            Dom.XmlNode BasicPropertyInfoNode = RoomStayNode.addChildElement('BasicPropertyInfo',null,null);
            BasicPropertyInfoNode.setAttribute('HotelCode',roomBooking.ordexp_deal__r.Hotel_Code__c);
            
            Dom.XmlNode TimsSpanNode = RoomStayNode.addChildElement('TimeSpan',null,null);
            TimsSpanNode.setAttribute('Start',finalStartDateForTimeSpan);
            TimsSpanNode.setAttribute('End',finalEndDateForTimeSpan);
            
            i=i++;
            /*
Dom.XmlNode TimeSpanNode = RoomStayNode.addChildElement('TimeSpan',null,null);
TimeSpanNode.setAttribute('Start',string.valueOf(roomBooking.ordexp_departure_date__r.date__c));
TimeSpanNode.setAttribute('End',string.valueOf(roomBooking.sm_End_Date__c));

Dom.XmlNode GuaranteeNode = TimeSpanNode.addChildElement('Guarantee',null,null);

Dom.XmlNode GuaranteesAcceptedNode = GuaranteeNode.addChildElement('GuaranteesAccepted',null,null);

Dom.XmlNode GuaranteeAcceptedNode = GuaranteesAcceptedNode.addChildElement('GuaranteeAccepted',null,null);

Dom.XmlNode PaymentCardNode = GuaranteeAcceptedNode.addChildElement('PaymentCard',null,null);
PaymentCardNode.setAttribute('ExpireDate','0418');

Dom.XmlNode CardTypeNode = PaymentCardNode.addChildElement('CardType',null,null); 
CardTypeNode.setAttribute('Code','VI');

Dom.XmlNode CardNumberNode = PaymentCardNode.addChildElement('CardNumber',null,null);
Dom.XmlNode PlainTextNode = CardNumberNode.addChildElement('PlainText',null,null);
PlainTextNode.addTextNode('1234123412341234');

Dom.XmlNode CardHolderNameNode = PaymentCardNode.addChildElement('CardHolderName',null,null);
CardHolderNameNode.addTextNode('Test Card');

Dom.XmlNode AddressNode = PaymentCardNode.addChildElement('CardType',null,null);
Dom.Xmlnode AddressLineNode = AddressNode.addChildElement('AddressLine', null, null);
AddressLineNode.addTextNode('15 Wollongbar St');

Dom.Xmlnode CityNode = AddressNode.addChildElement('CityName', null, null);
CityNode.addTextNode('Byron Bay');

Dom.Xmlnode StateProvNode = AddressNode.addChildElement('StateProv', null, null);
StateProvNode.addTextNode('NSW');

Dom.Xmlnode CountryNameNode = AddressNode.addChildElement('CountryName', null, null);
CountryNameNode.addTextNode('Australia');

Dom.Xmlnode PostalCodeNode = AddressNode.addChildElement('PostalCode', null, null);
PostalCodeNode.addTextNode('2481');
*/
            
            
            //Address section within the Payment Card Node is not a required thing. Has been commented below.
            /*
Dom.XmlNode AddressNodeCH = PaymentCardNode.addChildElement('Address',null,null);
Dom.XmlNode AddressLineNodeCH = AddressNodeCH.addChildElement('AddressLine',null,null);
Dom.XmlNode CityNameNodeCH = AddressNodeCH.addChildElement('CityName',null,null);
Dom.XmlNode StateProvNodeCH = AddressNodeCH.addChildElement('StateProv',null,null);
Dom.XmlNode CountryNameNodeCH = AddressNodeCH.addChildElement('CountryName',null,null);
Dom.XmlNode PostalCodeNodeCH = AddressNodeCH.addChildElement('PostalCode',null,null); */
            //Address section within the Payment Card Node ends.
            
            
            Dom.XmlNode GuestCountsNode = RoomStayNode.addChildElement('GuestCounts',null,null);
            
            for(GuestCount gc : mapOfOliIdsWithGuestCounts.get(oliInstance.Id)){
                Dom.XmlNode GuestCountNode = GuestCountsNode.addChildElement('GuestCount',null,null);
                GuestCountNode.setAttribute('Count',string.valueOf(gc.Count));
                GuestCountNode.setAttribute('AgeQualifyingCode',string.valueOf(gc.AgeQualifyingCode));
            }
            
            Dom.XmlNode TotalNode = RoomStayNode.addChildElement('Total',null,null);
            
            if(roomBooking.ordexp_deal__r.Siteminder_Currency_Code__c != null){
                TotalNode.setAttribute('CurrencyCode', string.valueOf(roomBooking.ordexp_deal__r.Siteminder_Currency_Code__c));
            }else{
                TotalNode.setAttribute('CurrencyCode','AUD'); 
            }  
            
            TotalNode.setAttribute('AmountAfterTax',string.valueOf(oliInstance.OL_Cost__c));
            
            
            String CommentInsideRoomStay = System.Label.Room_Stay_Comments_OTA_Connect;
            Dom.XmlNode CommentsNode = RoomStayNode.addChildElement('Comments',null,null);
            Dom.XmlNode CommentNode = CommentsNode.addChildElement('Comment',null,null);
            Dom.XmlNode CTextNode = CommentNode.addChildElement('Text',null,null);
            CTextNode.addTextNode(CommentInsideRoomStay);
            
            
            Dom.XmlNode RoomRatesNode = RoomStayNode.addChildElement('RoomRates',null,null);
            
            Dom.XmlNode RoomRateNode = RoomRatesNode.addChildElement('RoomRate',null,null);
            RoomRateNode.setAttribute('NumberOfUnits','1');
            RoomRateNode.setAttribute('RoomTypeCode',oliInstance.Sub_Options__r.Room_Type_Code__c);
            RoomRateNode.setAttribute('RatePlanCode',oliInstance.Sub_Options__r.Rate_Plan_Code__c);
            
            Dom.XmlNode RatesNode = RoomRateNode.addChildElement('Rates',null,null);
            
            Dom.XmlNode RateNode = RatesNode.addChildElement('Rate',null,null);
            RateNode.setAttribute('RoomPricingType','Per stay');
            RateNode.setAttribute('EffectiveDate',String.valueOf(roomBooking.ordexp_departure_date__r.date__c));
            RateNode.setAttribute('ExpireDate',String.valueOf(roomBooking.sm_End_Date__c));
            
                        
            Dom.XmlNode BaseNode = RateNode.addChildElement('Base',null,null);
            BaseNode.setAttribute('AmountAfterTax',string.valueOf(oliInstance.OL_Cost__c));
            
            Dom.XmlNode ResGuestRPHsNode = RoomStayNode.addChildElement('ResGuestRPHs',null,null);
            ResGuestRPHsNode.addTextNode('0');
            
        }          
        //HotelReservations ends
        
        String xmlString = doc.toXmlString();
        String endpoint= url;
        System.debug('xmlString =' + xmlString);
        HttpRequest req = new HttpRequest();
        req.setBody(xmlString);
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/xml');
        HttpResponse res =  new HttpResponse();
        Http ht = new Http();
        res = ht.send(req);
        System.debug('res=====>'+res.getBody());
        
        
        
        
        Dom.Document docres = new Dom.Document();  
        docres.load( res.getBody() );  
        Dom.XMLNode rootElement = docres.getRootElement();  
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            if(childElement.getName()=='Errors')
            {
                for ( Dom.XMLNode ChildElement2 : childElement.getChildElements() )
                {
                    roomBooking.Siteminder_Failure_Response__c = 'Type='+ChildElement2.getAttributeValue('Type', '')+';Code='+ChildElement2.getAttributeValue('Code', '')+';ShortText='+ChildElement2.getAttributeValue('ShortText', '')+';Error Message='+ChildElement2.getText();
                }
            }
            if(childElement.getName()=='HotelReservations')
            {
                for ( Dom.XMLNode ChildElement2 : childElement.getChildElements() )
                {
                    for ( Dom.XMLNode ChildElement3 : childElement2.getChildElements() )
                    {
                        for ( Dom.XMLNode ChildElement4 : childElement3.getChildElements() )
                        {
                            for ( Dom.XMLNode ChildElement5 : childElement4.getChildElements() )
                            {
                                
                                system.debug('value=====>'+ ChildElement5.getName() + '-' + ChildElement5.getAttributeValue('ResID_Value', '') );
                                
                                roomBooking.Siteminder_Reservation_ResId__c = ChildElement5.getAttributeValue('ResID_Value', '');
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
            } 
        }  
        
        update roomBooking;
    }
    
}