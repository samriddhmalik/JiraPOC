public class BookingHotelTriggerHandler {
    
    public static Boolean isFirstTime = True;
    public static boolean firstRun = true; 
    public static void createTADOrder(Map<id,Booking_Hotel__c> BookingHotelMap){
        system.debug('Line5 '+BookingHotelMap);
        
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        //      Id hotelRecordTypeId = Schema.SObjectType.Order_line_item__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        system.debug('Line12 '+DefaultDeal); 
        Departure_cities__c dc = new Departure_cities__c();
        if(Test.isRunningTest()){
            dc = [Select id from Departure_cities__c Limit 1];
        }else{
            dc = [Select id from Departure_cities__c where deal__c =: DefaultDeal Limit 1];
        }        
        List<Booking_Hotel__c>bookingHotelList =new List<Booking_Hotel__c>();
        List<TAD_Order__c>orderList =new List<TAD_Order__c>();
        List<order_line_item__c>orderLineItemList =new List<order_line_item__c>();
        for(Booking_Hotel__c bn : BookingHotelMap.values()){
            
            TAD_Order__c ord = new TAD_Order__c();
            ord.ordexp_deal__c = DefaultDeal;
            ord.ordexp_option__c = DefaultOption;
            ord.ordexp_account__c = bn.Account__c;
            ord.Booking_Hotel__c = bn.id;
            ord.RecordTypeId = RecordTypeId;
            ord.ordexp_gross_amount__c = bn.Subtotal__c;
            ord.Qantas_Frequent_Flyer_Number__c = bn.Qantas_Frequent_Flyer_Number__c;
            orderList.add(ord);
            
            
        }
        if(!orderList.isEmpty()){
            insert orderList; 
        }
        
        for(TAD_Order__c ord : orderList){
            
            tadOrderBookingHotel.put(ord.Booking_Hotel__c,ord.Id);
            
            order_line_item__c oli = new order_line_item__c();
            oli.ordexp_TAD_Order__c = ord.id;
            oli.Deal__c = DefaultDeal;
            oli.Departure_cities__c = dc.Id;
            oli.Is_Expedia_OLI__c = true;
            orderLineItemList.add(oli);
        }
        if(!orderLineItemList.IsEmpty()){ 
            insert orderLineItemList;
        }
        
        List<Booking_Hotel__c> bookinghotelListtoUpdate = new List<Booking_Hotel__c>();
        
        for(String s : tadOrderBookingHotel.keySet()){
            Booking_Hotel__c bh = new Booking_Hotel__c();
            bh.Id = s;
            bh.TAD_Order__c = tadOrderBookingHotel.get(s);
            bookinghotelListtoUpdate.add(bh);
        }
        update bookinghotelListtoUpdate;
        
        
        
    }
    
    public static void updateTADOrderqff(Map<Id,String> BookingHotelMapUpdate){
        
        List<TAD_Order__c>orderList = [Select id,Qantas_Frequent_Flyer_Number__c from TAD_Order__c where Id IN: BookingHotelMapUpdate.keySet()];
        
        
        for(TAD_Order__c ord : orderList){
            ord.Qantas_Frequent_Flyer_Number__c = BookingHotelMapUpdate.get(ord.Id);
        }
        
        
        if(!orderList.isEmpty()){
            update orderList; 
        }
        
        
    }
    
    public static void updateRoomRecord(List<Room__c> roomList, Set<Id> bookingIdSet,String str){
        
        Set<Id> TadOrderId = new Set<Id>(); 
        Set<Id> roomId = new Set<Id>(); 
        List<Booking_Hotel__c> BookingHotelToUpdate = new List<Booking_Hotel__c>();
        String RoomTitle= '';
        for(Room__c ro : roomList){
           roomId.add(ro.id);
        }
        
        List<Booking_Hotel__c> BookingHotelList = [Select id,TAD_Order__c,Room_Title__c from Booking_Hotel__c where Id IN: bookingIdSet];
        system.debug('line67 '+BookingHotelList);
        
        List<Room__c> bookingHotelRoomData = [select Id,Room_Title__c from Room__c where Booking_Hotel__c IN:bookingIdSet];

         system.debug('Line99 '+bookingHotelRoomData);
        
        for(Room__c ro : bookingHotelRoomData){
              RoomTitle += ro.Room_Title__c + ',';
        }
        	  RoomTitle = RoomTitle.removeEnd(',');
        system.debug('Line105 '+RoomTitle); 
        
        for(Booking_Hotel__c b : BookingHotelList){
            TadOrderId.add(b.TAD_Order__c);
            b.Room_Title__c = RoomTitle;
        }
        system.debug('Line110 '+BookingHotelList);
        update BookingHotelList;
        
        system.debug('Line77 '+TadOrderId);
        
        if(str == 'insert'){
        
        order_line_item__c oli = [Select id from order_line_item__c where ordexp_TAD_Order__c IN: TadOrderId];
            
       List<Room__c> RoomDataList =[Select id,Order_Line_Item__c from Room__c where Id IN:roomId];
                
         for(Room__c ro : roomDataList){
           ro.Order_Line_Item__c = oli.id;
         }
         update roomDataList;
       }
    }

    
    public static void updateTADOrder(Map<id,Booking_Hotel__c> BookingHotelMap){
        
        
        
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<id,decimal> BookingHotelSubTotal = new Map<id,decimal>();
        
        List<Booking_Hotel__c>bookingHotelList =new List<Booking_Hotel__c>();
        List<TAD_Order__c>orderList =new List<TAD_Order__c>();
        for(Booking_Hotel__c bn : BookingHotelMap.values()){
            BookingHotelSubTotal.put(bn.TAD_Order__c, bn.Subtotal__c);
        }
        
        List<TAD_Order__c> tadListData = [select id,ordexp_gross_amount__c from TAD_Order__c where id IN:BookingHotelSubTotal.keyset()];
        
        for(TAD_Order__c ord : tadListData){
            ord.ordexp_gross_amount__c = BookingHotelSubTotal.get(ord.id);
            orderList.add(ord);
        }
        
        if(!orderList.isEmpty()){
            update orderList; 
        }
        
    }
    
    public static void convertCurrencyCodeWithApex(Map<id,Room__c> BookingHotelCurrencyMap){
        
        String oCurrency = 'AUD'; 
        String nCurrency = '';
        Double amount;
        Double localTaxinAUD ;
        Set<String> isoCodes = new Set<String>();
        Set<String> bookingIDset = new Set<String>();
        List<Room__c> bookingHotelRoomDataToUpdate = new List<Room__c>();
        List<Booking_Hotel__c> bookingHotelDataToUpdate = new List<Booking_Hotel__c>();
        Map<String,Double> conversion_rates = new Map<String,Double>();
        
        for(Room__c bn : BookingHotelCurrencyMap.values()){
            nCurrency = bn.Local_Currency_Code__c;
            amount = bn.Local_Tax__c;
            bookingIDset.add(bn.Booking_Hotel__c);
        }
        
        isoCodes.add(oCurrency);
        
        isoCodes.add(nCurrency);
        
        
        for(CurrencyType curr: [SELECT IsoCode,ConversionRate FROM CurrencyType WHERE IsoCode in: isoCodes]){          
            
            conversion_rates.put(curr.IsoCode,curr.ConversionRate);        
            
        }
        Double conversionRate = conversion_rates.get(nCurrency);
        amount = amount / conversionRate;
        
        if(!conversion_rates.isEmpty()){
            
            conversionRate = conversion_rates.get(oCurrency);
            
            amount = amount * conversionRate;
            localTaxinAUD = amount * conversionRate ;
        }
        
        
        List<Booking_Hotel__c> bookingHotelData = [select Id,Local_Currency_Code__c,Currency_Iso_Code_Update__c from Booking_Hotel__c where Id IN:bookingIDset AND Currency_Iso_Code_Update__c = false];
        List<Room__c> bookingHotelRoomData = [select Id,Local_tax_in_AUD__c from Room__c where id IN:BookingHotelCurrencyMap.keyset()];
        for(Room__c ro : bookingHotelRoomData){
            ro.Local_tax_in_AUD__c = localTaxinAUD;
            bookingHotelRoomDataToUpdate.add(ro);
        }
        
        for(Booking_Hotel__c bh : bookingHotelData){
            bh.Local_Currency_Code__c = nCurrency;
            bh.Currency_Iso_Code_Update__c = True;
            bookingHotelDataToUpdate.add(bh);
        }
        
        if(!bookingHotelRoomDataToUpdate.isEmpty()){
            update bookingHotelRoomDataToUpdate; 
        }
        
        if(!bookingHotelDataToUpdate.isEmpty()){
            update bookingHotelDataToUpdate; 
        }
        
        
    }
    
    public static void updateBookingHotelStatus(Set<Id> tadIdSet){
        system.debug('Line--177-->'+tadIdSet);
        Set<Id> bhIdset = new Set<Id>();
        //List<String> bookinghotelId = new List<String>();
        
        List<TAD_Order__c> getOrderData = [SELECT ID,Booking_Hotel__c FROM TAD_Order__c WHERE ID =: tadIdSet];
        system.debug('Line--182--> '+getOrderData);
        for(TAD_Order__c d : getOrderData ){
            bhIdset.add(d.Booking_Hotel__c);
            
        }  
        system.debug('Line--187-->'+bhIdset);
        
        List<Booking_Hotel__c> bookingList = [Select Id,Qantas_Frequent_Flyer_Number__c,Status__c,ordexp_Total_QFF_Received__c,QFF_Payment__c,TAD_Order__c,TAD_Order__r.QFF_Cash__c From Booking_Hotel__c where Id =: bhIdset];
        system.debug('Line--180-->'+bookingList);
        String QFFN;
        For(Booking_Hotel__c bh :bookingList){
            if(bh.Status__c == 'On Hold'){
                bh.Status__c = 'Confirmed';
                bh.Purchase_date__c = system.Today();
                
                //bhIdset.add(bh.Id);
            }
            
        }
        Update bookingList;
        
        List<Room__c> roomList = [select Id,Status__c,Booking_Hotel__c from Room__c where Booking_Hotel__c IN: bhIdset];
        
        for(Room__c ro : roomList){
            ro.Status__c = 'Active';
        }
        
        Update roomList;
        
        List<TAD_Order__c> tadList = [Select Id,ordexp_purchase_date__c From TAD_Order__c where Booking_Hotel__c IN : bhIdset];
        For(TAD_Order__c tad :tadList){
            tad.ordexp_purchase_date__c = system.Today();
            
        }
        
        Update tadList;
        
    }
    
    public static void updateRoomStatus(Set<Id> BookingIdSet){
        
        List<Room__c> roomList = [select Id,Status__c,Booking_Hotel__c from Room__c where Booking_Hotel__c IN: BookingIdSet AND Status__c = 'On Hold'];
        
        for(Room__c ro : roomList){
            ro.Status__c = 'Active';
        }
        
        Update roomList;
        
    }

    public static void updateBookingHotelQff(Set<Id> tadIdSet){
        List<Booking_Hotel__c> bookingList = [Select Id,Status__c,ordexp_Total_QFF_Received__c,QFF_Payment__c,TAD_Order__c,TAD_Order__r.QFF_Cash__c From Booking_Hotel__c where TAD_Order__c IN : tadIdSet AND ordexp_Total_QFF_Received__c !=0.00];
        For(Booking_Hotel__c bh :bookingList){
            system.debug('line--174-->'+bh.ordexp_Total_QFF_Received__c);
            bh.QFF_Payment__c = True;
        }
        
        Update bookingList;
    }
    
    public static void createOrderComsRecord(Set<Id> orderid){
        system.debug('line49 '+orderid);
        
        List<String> bookinghotelId = new List<String>();
        
        List<TAD_Order__c> getOrderData = [SELECT ID,Booking_Hotel__c FROM TAD_Order__c WHERE ID =: orderid LIMIT 1];
        system.debug('Line22 '+getOrderData);
        for(TAD_Order__c d : getOrderData ){
            bookinghotelId.add(d.Booking_Hotel__c);
            
        }    
        
        
        //  Id RecordTypeId = Schema.SObjectType.Order_Communication_POE__c.getRecordTypeInfosByName().get('Partner Order Comm').getRecordTypeId();
        system.debug('Line240 '+bookinghotelId);
        Booking_Hotel__c tadOrd = [Select Id,Property_Address__c,Property_Full_Address__c,Ammendment_Done__c,Property_Phone_Number__c,Property_Name__c,TAD_Order__r.Purchaser_First_Name__c,Check_in_instructions__c,Check_out_instructions__c,Special_Check_In_Instructions__c,Expedia_Booking_reference_number__c,Know_before_you_go__c,Fees_Information__c,Local_tax_in_AUD__c,Local_Tax__c,Local_Currency_Code__c,Total_Tax__c,TAD_Order__c,Account__r.PersonEmail,Rooms_and_Nights__c,Cancellation_amount__c,Booking_Surcharges__c,Check_In_Date__c,Check_Out_Date__c,Account_First_Name__c,Account__r.Name,Subtotal__c,Hotel_Image__c,No_of_Rooms__c,Number_of_Beds__c,Number_of_Adults__c,Number_of_Bathroom__c,Name,Number_of_Nights_Stay__c FROM Booking_Hotel__c where Id =:bookinghotelId AND Status__c !='Cancelled'];
        
        
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = tadOrd.TAD_Order__c;
        oc.purchaser_first_name__c = tadOrd.TAD_Order__r.Purchaser_First_Name__c;
        oc.email_purchaser__c = tadOrd.Account__r.PersonEmail;
        oc.Check_In_date__c = tadOrd.Check_In_Date__c;
        oc.Check_Out_date__c = tadOrd.Check_Out_Date__c;
        oc.Night__c = tadOrd.Rooms_and_Nights__c;
        oc.Property_Full_Address__c = tadOrd.Property_Full_Address__c;
        oc.Property_Phone_Number__c = tadOrd.Property_Phone_Number__c;
        oc.Booking_Surcharge__c = tadOrd.Booking_Surcharges__c;
        oc.Cancellation_amount__c =  tadOrd.Cancellation_amount__c;
        oc.Hotel_Name__c = tadOrd.Name;
        oc.Number_Of_Nights__c = tadOrd.Number_of_Nights_Stay__c;
        oc.Number_of_Adults__c = tadOrd.Number_of_Adults__c;
        oc.Number_of_Bathroom__c = tadOrd.Number_of_Bathroom__c;
        oc.Number_of_Beds__c = tadOrd.Number_of_Beds__c;
        oc.Number_of_Rooms__c = tadOrd.No_of_Rooms__c;
        oc.Partner_Deal_Main_Image__c =  tadOrd.Hotel_Image__c;
        oc.Subtotal__c = tadOrd.Subtotal__c;  
        oc.purchaser_full_name__c = tadOrd.Account__r.Name;
        oc.purchaser_first_name__c = tadOrd.Account_First_Name__c;
        oc.Check_in_Instruction__c = tadOrd.Check_in_instructions__c;
        oc.Check_Out_Instruction__c = tadOrd.Check_out_instructions__c;
        oc.Special_Check_In_Instructions__c = tadOrd.Special_Check_In_Instructions__c;
        oc.Itinerary_ID__c = tadOrd.Expedia_Booking_reference_number__c;
        oc.Know_before_you_go__c =tadOrd.Know_before_you_go__c;
        
        oc.Local_tax_in_AUD__c = tadOrd.Local_tax_in_AUD__c;
        oc.Local_tax_in_local_currency__c = tadOrd.Local_Tax__c;
        oc.Local_Tax_ISO_Code__c = tadOrd.Local_Currency_Code__c;
        oc.Tax_Fees__c = tadOrd.Total_Tax__c;
        oc.Property_Name__c = tadOrd.Property_Name__c;
        oc.Hotel_Order__c = tadOrd.id;
        oc.communication_code__c ='Partner Booking Updated'; 
        
        insert oc;
        
        tadOrd.Ammendment_Done__c = True;
        update tadOrd;
        system.debug('oc---'+oc);       
        
    } 
    
    public static void createOrderLinesForRooms (Set<Id>roomIdsForOL,Set<Id>dealIds){
        system.debug('Line--216-->'+roomIdsForOL);
        system.debug('Line--217-->'+dealIds);
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        List<Component__c> components = new List<Component__c>();
        
        if(test.isRunningTest()){
            components = [SELECT Id,deal__c,CurrencyIsoCode,Deal__r.Accounting_Treatment_AU__c, Name ,name__c,Merchant_Name__r.Name,Merchant_Name__c,(Select Id,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__r.Name = '1234'];
        }else{
            components = [SELECT Id,deal__c,CurrencyIsoCode,Deal__r.Accounting_Treatment_AU__c, Name ,name__c,Merchant_Name__r.Name,Merchant_Name__c,(Select Id,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c =: DefaultDeal LIMIT 1];
        }
        system.debug('Line--222-->'+components);     
        Map<Id,Room__c> rooms = new Map<Id,Room__c>([Select id,Merchant_Gross_Cost__c,Total_Room_Cost__c,Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,Name,Order_Line_Item__r.Deal__c,Order_Line_Item__c,Order_Line_Item__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.PAX_Quantity__c from Room__c where Id IN: roomIdsForOL]);
        system.debug('Line--74-->'+rooms);
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        
        Id compPricingid;
        
        for (Component__c c : components) {
            for(Component_Pricing__c price : c.Component_Pricing__r){
                compPricingid = price.id; 
            }
        }
        
        for (Id roomId : rooms.KeySet()) {
            for (Component__c c : components) {
                
                order_line_POE__c ol = new order_line_POE__c();
                ol.TAD_Order__c = rooms.get(roomId).Order_Line_Item__r.ordexp_TAD_Order__c;
                ol.component__c  = c.Id;
                ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                ol.mp_merchant__c=c.Merchant_Name__c;
                ol.Component_Name__c = c.name__c;
                ol.Deal__c = c.deal__c;//FF-894
                ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                ol.Status__c='Active';
                ol.departures_dates__c = rooms.get(roomId).Order_Line_Item__r.ordexp_departure_date__c;
                String uniqueKey = roomId + '#' + c.Id+'#'+ol.departures_dates__c;
                ol.External_Id__c = uniqueKey;
                ol.OL_Type__c = 'Expedia';
                ol.Order_Line_Item__c = rooms.get(roomId).Order_Line_Item__c;
                ol.Room__c = roomId;
                ol.PAX_Travelling__c=1;
                ol.CurrencyIsoCode = c.CurrencyIsoCode;//ff-606
                
                ol.Gross_cost__c = rooms.get(roomId).Merchant_Gross_Cost__c;
                ol.Component_Pricing__c = compPricingid;
                
                
                orderLines.add(ol);
            }    
        }
        
        
        // Ol inserted per unique key
        if (orderLines.size() > 0) {
            
            upsert orderLines External_Id__c;
            
        }
    }
    
    public static void createOrderLinesForUpdatedRooms(list<Room__c> newPass,map<id,Room__c> oldPAss){
        
        system.debug('Line--327-->'+newPass);
        system.debug('Line--328-->'+oldPAss);
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        List<Component__c> components = new List<Component__c>();
        
        if(test.isRunningTest()){
            components = [SELECT Id,deal__c,CurrencyIsoCode,Deal__r.Accounting_Treatment_AU__c, Name ,name__c,Merchant_Name__r.Name,Merchant_Name__c,(Select Id,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__r.Name = '1234'];
        }else{
            components = [SELECT Id,deal__c,CurrencyIsoCode,Deal__r.Accounting_Treatment_AU__c, Name ,name__c,Merchant_Name__r.Name,Merchant_Name__c,(Select Id,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c =: DefaultDeal LIMIT 1];
        }
        
        system.debug('Line--334-->'+components);     
        Map<Id,Room__c> rooms = new Map<Id,Room__c>([Select id,Merchant_Gross_Cost__c,Total_Room_Cost__c,Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,Name,Order_Line_Item__r.Deal__c,Order_Line_Item__c,Order_Line_Item__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.PAX_Quantity__c from Room__c where Id IN: newPass]);
        system.debug('Line--74-->'+rooms);
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        
        Id compPricingid;
        
        for (Component__c c : components) {
            for(Component_Pricing__c price : c.Component_Pricing__r){
                compPricingid = price.id; 
            }
        }
        system.debug('Line325 '+ rooms.KeySet());    
        for (Id roomId : rooms.KeySet()) {
            for (Component__c c : components) {
                
                
                system.debug('Line329 '+rooms.get(roomId).Order_Line_Item__r.ordexp_TAD_Order__c);
                system.debug('Line330 '+rooms.get(roomId).Order_Line_Item__c);
                
                order_line_POE__c ol = new order_line_POE__c();
                ol.TAD_Order__c = rooms.get(roomId).Order_Line_Item__r.ordexp_TAD_Order__c;
                ol.component__c  = c.Id;
                ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                ol.mp_merchant__c=c.Merchant_Name__c;
                ol.Component_Name__c = c.name__c;
                ol.Deal__c = c.deal__c;//FF-894
                ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                ol.Status__c='Active';
                ol.departures_dates__c = rooms.get(roomId).Order_Line_Item__r.ordexp_departure_date__c;
                String uniqueKey = roomId + '#' + c.Id+'#'+ol.departures_dates__c;
                ol.External_Id__c = uniqueKey;
                ol.OL_Type__c = 'Expedia';
                ol.Order_Line_Item__c = rooms.get(roomId).Order_Line_Item__c;
                ol.Room__c = roomId;
                ol.PAX_Travelling__c=1;
                ol.CurrencyIsoCode = c.CurrencyIsoCode;//ff-606
                
                ol.Gross_cost__c = rooms.get(roomId).Merchant_Gross_Cost__c - oldPAss.get(roomId).Merchant_Gross_Cost__c;
                ol.Component_Pricing__c = compPricingid;
                
                
                orderLines.add(ol);
            }    
        }
        
        
        // Ol inserted per unique key
        if (orderLines.size() > 0) {
            
            //   upsert orderLines External_Id__c;
            insert orderLines;
            system.debug('Line385 '+orderLines);
        }
        
        
    }
    
    public static void updateRoominformation(List<Order_Communication_POE__c> ocList, Set<Id> bookingIdSet){
        
        String emailBodyRoomInfo;
        String emailBodyFeesInfo;
        String emailBodyLocalTaxInfo;
        String BookingStatus;
        String CanRefStatus;
        Decimal rooms=0;
        Decimal Nights=0;
        String RoomsAndNights = '';
        String communicationcode= '';
        Boolean commcodeCancellation= false;
        List<Booking_Hotel__c> BookingHotelList = [Select id,CanRef_status__c,Status__c,Fees_Information__c,Local_Tax__c,Local_Currency_Code__c,Local_tax_in_AUD__c from Booking_Hotel__c where Id IN: bookingIdSet]; 
        
        emailBodyFeesInfo = '<table id="main-table" style="width: 100%;background:#F2F1F1">';  
        system.debug('Line--477-->'+ocList);
        for(Order_Communication_POE__c oc :ocList){
            if(oc.communication_code__c == 'No Refund Cancellation' || oc.communication_code__c == 'Full Refund Cancellation' || oc.communication_code__c == 'Partial Refund Cancellation' || oc.communication_code__c == 'Refund Processed'){
                commcodeCancellation = True;
            }
        }
         system.debug('Line--482-->'+communicationcode);
          system.debug('Line--504-->'+commcodeCancellation);
        for(Booking_Hotel__c b: BookingHotelList){
            BookingStatus = b.Status__c;
            CanRefStatus = b.CanRef_status__c;
            system.debug('Line469 '+b.Fees_Information__c);
            system.debug('Line470 '+b.Local_tax_in_AUD__c);
              system.debug('Line484 '+BookingStatus);
              system.debug('Line485 '+CanRefStatus);
            if(b.Fees_Information__c != null && b.Local_tax_in_AUD__c != null && b.Local_tax_in_AUD__c != 0.00 && commcodeCancellation == false){
                Decimal toround = b.Local_tax_in_AUD__c;
                Decimal rounded = toround.setScale(2);
                emailBodyFeesInfo = '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<br/><hr style="width:95%;padding-top:-30px;" align="center">'+'</th> </thead></table>';
                emailBodyFeesInfo += '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+'<b>'+'Fees'+'</b>'+'</th> </thead>';
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+b.Fees_Information__c+'</th> </thead></table>';
                
                emailBodyFeesInfo += '<table id="main-table" style="width: 100%;background:#F2F1F1;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<tbody><td  style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;padding-right:10px" align="left">'+'<b>Fees Paid at property</b>'+'</td>';
                emailBodyFeesInfo +=  '<td align="right"  style="color: #000000; text-align: right;font-family: Lato,Arial,Helvetica,sans-serif;font-size: 16px; line-height:24px; padding-right:10px">'+b.Local_Tax__c+' '+b.Local_Currency_Code__c+'</td></tbody></table>';       
                emailBodyFeesInfo +=  '<table id="main-table" style="width: 100%;background:#F2F1F1;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo +=  '<tbody><td align="left"  style="color: #F2F1F1; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px">'+'</td>';
                emailBodyFeesInfo +=  '<td align="right"  style="color: #000000; text-align: right;font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px">'+'approx value'+' '+rounded +' '+'AUD'+'</td></tbody></table>';
                emailBodyFeesInfo += '<table id="main-table" style="width: 100%;background:#FFFFFF; border-bottom: 1px solid #5A5A5A;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<tbody><td style="color: #000000; text-align: left;font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px;padding-left:10px;padding-right:10px" align="left">'+'**Payable at property on check in.This conversion is approximate price based on current exchange rate and may be change before your stay.'+'</td> </tbody></table>';
                system.debug('Line482 '+emailBodyFeesInfo);
            }else if((b.Fees_Information__c != null && b.Local_tax_in_AUD__c == 0.00 && b.Local_tax_in_AUD__c == 0.00) || (b.Fees_Information__c != null && b.Local_tax_in_AUD__c != null && b.Local_tax_in_AUD__c != 0.00 && commcodeCancellation == true)){
                system.debug('Line83 '+b.Fees_Information__c);
                emailBodyFeesInfo = '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<br/><hr style="width:95%;padding-top:-30px;" align="center">'+'</th> </thead></table>';
                emailBodyFeesInfo += '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-bottom: 1px solid #5A5A5A;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+'<b>'+'Fees'+'</b>'+'</th> </thead>';
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+b.Fees_Information__c+'</th> </thead></table>';
                
            }
         else{
                emailBodyFeesInfo = '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-bottom: 1px solid #5A5A5A;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #FFFFFF; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+''+'</th> </thead></table>';
                
            }
        /*    if(b.Fees_Information__c != null){
                system.debug('Line83 '+b.Fees_Information__c);
                emailBodyFeesInfo = '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<br/><hr style="width:95%;padding-top:-30px;" align="center">'+'</th> </thead></table>';
                emailBodyFeesInfo += '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-bottom: 1px solid #5A5A5A;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+'<b>'+'Fees'+'</b>'+'</th> </thead>';
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+b.Fees_Information__c+'</th> </thead></table>';
                
            }else{
                emailBodyFeesInfo = '<table id="main-table" style="padding-top:-30px;width: 100%;background:#FFFFFFF; border-bottom: 1px solid #5A5A5A;border-right: 1px solid #5A5A5A;border-left: 1px solid #5A5A5A;">';       
                emailBodyFeesInfo += '<thead><th>'+'<td style="color: #FFFFFF; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-top:10px;padding-left:10px">'+''+'</th> </thead></table>';
                
            }
*/            
        }
        
        
        List<Room__c> RoomList = [Select id,Private_bathroom__c,Age_of_children__c,Room_Title__c,Number_of_Adults__c,Number_of_Children__c,Room_Max_Occupancy__c,Kitchen_Available__c,Number_Of_Bedroom__c,
                                  Wifi_Available__c,Bed_Type__c,Number_of_Bathroom__c,Bed_Choice__c,Cancellation_Type__c,Room_QTY__c,Number_Of_Nights__c,Cancellation_Policy__c from Room__c where Booking_Hotel__c IN: bookingIdSet AND Status__c != 'Cancelled'];
        
        List<Room__c> RoomListCancelled = [Select id,Private_bathroom__c,Age_of_children__c,Room_Title__c,Number_of_Adults__c,Number_of_Children__c,Room_Max_Occupancy__c,Kitchen_Available__c,Number_Of_Bedroom__c,
                                           Wifi_Available__c,Bed_Type__c,Number_of_Bathroom__c,Bed_Choice__c,Cancellation_Type__c,Room_QTY__c,Number_Of_Nights__c,Cancellation_Policy__c from Room__c where Booking_Hotel__c IN: bookingIdSet AND Status__c = 'Cancelled'];
        
        integer i =1;
        emailBodyRoomInfo = '<table id="main-table" style="width: 100%;background:#F2F1F1">';
        if(commcodeCancellation == false){
            for(Room__c ro: RoomList){
                 rooms = rooms+ro.Room_QTY__c;
                Nights = Nights +ro.Number_Of_Nights__c;
                emailBodyRoomInfo += '<table id="main-table" style="width: 100%;background:#F2F1F1">';
                emailBodyRoomInfo += '<tbody>'+'<td><b style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;padding-top:10px;" valign="top">'+'Room' + ' '+i +' - '+ro.Room_Title__c +'</b></td>';
                if(ro.Number_of_Children__c != 1 && ro.Number_of_Children__c != null && ro.Number_of_Children__c != 0){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults,'+ro.Number_of_Children__c +' '+'Children'+'</td></tbody>';
                }else if(ro.Number_of_Children__c == 1){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults,'+ro.Number_of_Children__c +' '+'Child'+'</td></tbody>';
                    
                }else{
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults'+'</td></tbody>';
                    
                }
                if(ro.Cancellation_Type__c != null){
                    emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px; padding-left:10px;" valign="top">'+ro.Cancellation_Type__c +'</td>';
                }else{
                    emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px; padding-left:10px;" valign="top">'+'Non-Refundable' +'</td>';
                }
                if(ro.Number_of_Children__c != null && ro.Age_of_children__c != null){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-right:10px;" valign="top">'+ro.Age_of_children__c+' '+'years old'+'</td></tbody>';
                }else if (ro.Age_of_children__c == null && ro.Number_of_Children__c != null && ro.Number_of_Children__c != 0){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-right:10px;" valign="top">'+'Age not provided'+'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<td></td>'+'</tbody>';     
                }
               emailBodyRoomInfo += '</br></br>';
                
                emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;">'+'Sleeps'+' '+ro.Room_Max_Occupancy__c+'</td></tbody>';
                if(ro.Kitchen_Available__c != false){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left;margin -left:200px, font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;">'+'Full Kitchen' +'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<tbody><td></td>'+'</tbody>';   
                }
                
                if(ro.Wifi_Available__c != false){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: left;font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+'Wifi Available' +'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<td></td>'+'</tbody>';   
                }
             
                 if(ro.Bed_Type__c != null && ro.Bed_Choice__c != null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Choice__c+'</td></tbody>';
                }else if(ro.Bed_Type__c == null && ro.Bed_Choice__c !=null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Choice__c+'</td></tbody>';
                }else if(ro.Bed_Type__c != null && ro.Bed_Choice__c == null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Type__c+'</td></tbody>';
                }else{
                     emailBodyRoomInfo += '<tbody><td></td>'+'</tbody>';    
                }
                 emailBodyRoomInfo += '</br></br>';
                emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px;padding-left:10px;" valign="top">'+'*Bed preferences are not'+' '+'guaranteed.'+'</td>';
                emailBodyRoomInfo += '</br></br>';
                if(ro.Cancellation_Type__c == 'Refundable'){
                     emailBodyRoomInfo += '<tbody>'+'<p style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px;padding-left:10px;padding-right:10px;" valign="top">'+'<b>Cancellation Policy</b>'+' - '+'<p style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 8px; line-height:16px;padding-left:10px;padding-right:10px;" valign="top">'+ro.Cancellation_Policy__c+'</p>'+'</p>';                 }
                if(i != RoomList.size()){
                    emailBodyRoomInfo += '<hr>';
                }
                emailBodyRoomInfo += '</table>'; 
                
                i++;
            }
           if(Nights > 1 && rooms> 1){
                  RoomsAndNights = rooms+' '+ 'Rooms' +' '+'X'+' '+Nights+' '+'Nights';
            }else if(Nights == 1 && rooms > 1){
                  RoomsAndNights = rooms+' '+ 'Rooms' +' '+'X'+' '+Nights+' '+'Night';
            }else if(Nights > 1 && rooms ==1){
                 RoomsAndNights = rooms+' '+ 'Room' +' '+'X'+' '+Nights+' '+'Nights';
            }else{
                RoomsAndNights = rooms+' '+ 'Room' +' '+'X'+' '+Nights+' '+'Night';
            }
                      

        }
        else{
            system.debug('Line--598-->'+RoomListCancelled);
              
            for(Room__c ro: RoomListCancelled){
                 system.debug('Line--599-->'+rooms);
               system.debug('Line--600-->'+Nights);
                rooms = rooms+ro.Room_QTY__c;
                Nights = Nights +ro.Number_Of_Nights__c;
                emailBodyRoomInfo += '<table id="main-table" style="width: 100%;background:#F2F1F1">';
                emailBodyRoomInfo += '<tbody>'+'<td><b style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;padding-top:10px;" valign="top">'+'Room' + ' '+i +' - '+ro.Room_Title__c +'</b></td>';
                if(ro.Number_of_Children__c != 1 && ro.Number_of_Children__c != null && ro.Number_of_Children__c != 0){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults,'+ro.Number_of_Children__c +' '+'Children'+'</td></tbody>';
                }else if(ro.Number_of_Children__c == 1){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults,'+ro.Number_of_Children__c +' '+'Child'+'</td></tbody>';
                    
                }else{
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-right:10px;padding-top:10px;" valign="top">'+ro.Number_of_Adults__c+' '+'Adults'+'</td></tbody>';
                    
                }
                if(ro.Cancellation_Type__c != null){
                    emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px; padding-left:10px;" valign="top">'+ro.Cancellation_Type__c +'</td>';
                }else{
                    emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px; padding-left:10px;" valign="top">'+'Non-Refundable' +'</td>';
                }
                if(ro.Number_of_Children__c != null && ro.Age_of_children__c != null){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-right:10px;" valign="top">'+ro.Age_of_children__c+' '+'years old'+'</td></tbody>';
                }else if (ro.Age_of_children__c == null && ro.Number_of_Children__c != null && ro.Number_of_Children__c != 0){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: right; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-right:10px;" valign="top">'+'Age not provided'+'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<td></td>'+'</tbody>';     
                }
                emailBodyRoomInfo += '</br></br>';
                emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;">'+'Sleeps'+' '+ro.Room_Max_Occupancy__c+'</td></tbody>';
                if(ro.Kitchen_Available__c != false){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px;padding-left:10px;">'+'Full Kitchen' +'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<td></td>'+'</tbody>';   
                }
                
                if(ro.Wifi_Available__c != false){
                    emailBodyRoomInfo += '<td style="color: #000000; text-align: left;font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+'Wifi Available' +'</td></tbody>';
                }else{
                    emailBodyRoomInfo += '<td></td>'+'</tbody>';   
                }
             
             
                 if(ro.Bed_Type__c != null && ro.Bed_Choice__c != null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Choice__c+'</td></tbody>';
                }else if(ro.Bed_Type__c == null && ro.Bed_Choice__c !=null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Choice__c+'</td></tbody>';
                }else if(ro.Bed_Type__c != null && ro.Bed_Choice__c == null){
                    emailBodyRoomInfo += '<tbody><td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 16px; line-height:24px; padding-left:10px;">'+ro.Bed_Type__c+'</td></tbody>';
                }else{
                     emailBodyRoomInfo += '<tbody><td></td>'+'</tbody>';    
                }
                 emailBodyRoomInfo += '</br></br>';
                emailBodyRoomInfo += '<tbody>'+'<td style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px;padding-left:10px;" valign="top">'+'*Bed preferences are not'+' '+'guaranteed.'+'</td>';
                emailBodyRoomInfo += '</br></br>';
                 if(ro.Cancellation_Type__c == 'Refundable'){
                    emailBodyRoomInfo += '<tbody>'+'<p style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 12px; line-height:20px;padding-left:10px;padding-right:10px;" valign="top">'+'<b>Cancellation Policy</b>'+' - '+'<p style="color: #000000; text-align: left; font-family: Lato,Arial,Helvetica,sans-serif; font-size: 8px; line-height:16px;padding-left:10px;padding-right:10px;" valign="top">'+ro.Cancellation_Policy__c+'</p>'+'</p>';                }
                if(i != RoomList.size()){
                    emailBodyRoomInfo += '<hr>';
                }
                emailBodyRoomInfo += '</table>'; 
                
                i++;
            }
             if(Nights > 1 && rooms> 1){
                  RoomsAndNights = rooms+' '+ 'Rooms' +' '+'X'+' '+Nights+' '+'Nights';
            }else if(Nights == 1 && rooms > 1){
                  RoomsAndNights = rooms+' '+ 'Rooms' +' '+'X'+' '+Nights+' '+'Night';
            }else if(Nights > 1 && rooms ==1){
                 RoomsAndNights = rooms+' '+ 'Room' +' '+'X'+' '+Nights+' '+'Nights';
            }else{
                RoomsAndNights = rooms+' '+ 'Room' +' '+'X'+' '+Nights+' '+'Night';
            }
                     
           
        }
        emailBodyRoomInfo += '</table>'; 
        
        system.debug('Line584 '+emailBodyRoomInfo);
        system.debug('Line585 '+emailBodyLocalTaxInfo);
        system.debug('Line586 '+emailBodyFeesInfo);
        for(Order_Communication_POE__c o : ocList){
            if(BookingStatus =='Cancelled' || CanRefStatus =='Processed' || CanRefStatus =='Partial Refund Processed' || CanRefStatus =='Finance Rejected'){
                o.Night__c = RoomsAndNights;
            }else{
                o.Night__c=RoomsAndNights;
            }
            o.Room_Information__c = emailBodyRoomInfo;
            o.Local_Tax_Info__c = emailBodyLocalTaxInfo;
            o.Fees_Information__c = emailBodyFeesInfo;
        }
        
    }
    
    
    /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
    public static void updateRoomFinancial(Set<Id> bookingIdSet){
        system.debug('Line--593-->'+bookingIdSet);
        List<Room__c> roomListToUpdate = [Select Id, Room_Price__c,Cancellation_Amount_Room__c,Original_Total_Room_Cost__c,Original_Room_Price__c,Original_Extra_guest_price__c,Extra_guest_price__c,Taxes__c,Merchant_Cost__c,Refunded_Merchant_Gross_Cost__c,Reverse_Cancellation__c from Room__c where ID IN : bookingIdSet];
        system.debug('Line--596-->'+roomListToUpdate);
        for(Room__c r : roomListToUpdate){
            if(r.Original_Total_Room_Cost__c == r.Cancellation_Amount_Room__c){
                r.Room_Price__c = 0.00;
                r.Extra_guest_price__c = 0.00;
                r.Merchant_Cost__c = 0.00;
                r.Taxes__c = 0.00;
                r.Room_Price__c = (r.Room_Price__c * r.Reverse_Cancellation__c)/100;
                r.Extra_guest_price__c = (r.Extra_guest_price__c * r.Reverse_Cancellation__c)/100;
                r.Taxes__c = (r.Taxes__c * r.Reverse_Cancellation__c)/100;
                r.Merchant_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)/100;
                r.Refunded_Merchant_Gross_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)*100;
            }
            else{
                r.Room_Price__c = (r.Original_Room_Price__c * r.Reverse_Cancellation__c)/100;
                if(r.Taxes__c == 0.00 || r.Taxes__c == null){
                    r.Taxes__c = 0.00;
                    r.Taxes__c = (r.Taxes__c * r.Reverse_Cancellation__c)/100;
                }
                else{
                    r.Extra_guest_price__c = (r.Original_Extra_guest_price__c * r.Reverse_Cancellation__c)/100;
                    
                }
                if(r.Extra_guest_price__c == 0.00 || r.Extra_guest_price__c == null){
                    r.Extra_guest_price__c = 0.00;
                    r.Extra_guest_price__c = (r.Extra_guest_price__c * r.Reverse_Cancellation__c)/100;
                }
                else{
                    r.Taxes__c = ((r.Original_Total_Room_Cost__c-r.Cancellation_Amount_Room__c)-(r.Room_Price__c+r.Extra_guest_price__c));
                    
                }
                if(r.Merchant_Cost__c == 0.00 || r.Merchant_Cost__c == null){
                    r.Merchant_Cost__c = 0.00;
                    r.Merchant_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)/100;
                    r.Refunded_Merchant_Gross_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)*100;
                }
                else{
                    r.Merchant_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)/100;
                    r.Refunded_Merchant_Gross_Cost__c = (r.Merchant_Cost__c * r.Reverse_Cancellation__c)*100;
                }
            }
        }
        update roomListToUpdate;
    }
    /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
    
}