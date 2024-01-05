public class Exp_CancellationRefundforHotelHandler {
    public static void createCanRefRecordHotel(Map<Id,Id> HotelcancellationId){
        
        
        Map<Id,Id> tadOrderBookingHotel = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c>canList =new List<Cancellation_Refund_POE__c>();
        
        id TadOrder;
        Id bookingHotelId;
        Id canRefId;
        Id tadownerId;
        Decimal outstandingAmount = 0.00;
        for(Id s : HotelcancellationId.values()){
            TadOrder = s;
        }
        system.debug('Line14 '+TadOrder);
        
       List<Booking_Hotel__c> BookingHotelList = [select Id,ordexp_Total_Payment_Received__c,ordexp_Coupon_Payment_Received__c,Subtotal__c,Total_Amount_Outstanding__c,Cancellation_Amount__c,CanRef_status__c from Booking_Hotel__c where ID IN: HotelcancellationId.keySet()];
                system.debug('Line18 '+BookingHotelList);

        for(Booking_Hotel__c b : BookingHotelList){
              outstandingAmount = -(b.Total_Amount_Outstanding__c);
            if(outstandingAmount < (b.ordexp_Total_Payment_Received__c + b.ordexp_Coupon_Payment_Received__c)){
                system.debug('Line15 ');
                b.CanRef_status__c ='Partial Refund Processed';
            }
            if(outstandingAmount == (b.ordexp_Total_Payment_Received__c + b.ordexp_Coupon_Payment_Received__c)){
                 b.CanRef_status__c ='Full Refund Processed';
            }
        }
        update BookingHotelList;
        
        List<Room__c> roomList = [select Id,Booking_Hotel__c,Total_Room_Cost__c,Booking_Hotel__r.TAD_Order__c,Booking_Hotel__r.Cancellation_Amount_Order__c,Booking_Hotel__r.Subtotal__c,Booking_Hotel__r.Local_tax_in_AUD__c,Cancellation_Refund__c,Cancellation_Refund__r.Approval_Status__c from Room__c where Booking_Hotel__c IN: HotelcancellationId.keySet() AND Status__c = 'Cancelled'];
        system.debug('Line--20-->'+roomList);
        system.debug('Line--20-->'+roomList.size());
        
        /*for(Room__c ro : roomList){
            if(ro.Cancellation_Refund__c !=null && ro.Cancellation_Refund__r.Approval_Status__c != 'Processed'){
                ro.Status__c = 'Cancelled';
                ro.Cancellation_Amount_Room__c =  ((((ro.Booking_Hotel__r.Cancellation_Amount_Order__c)*(ro.Total_Room_Cost__c))/ro.Booking_Hotel__r.Subtotal__c));  
                
                
            }
            if(ro.Cancellation_Refund__c ==null){
                ro.Status__c = 'Cancelled';
                ro.Cancellation_Amount_Room__c =  ((((ro.Booking_Hotel__r.Cancellation_Amount_Order__c)*(ro.Total_Room_Cost__c))/ro.Booking_Hotel__r.Subtotal__c));  
                
            }
            
            
        }
        if(!roomList.isEmpty()){
            update roomList; 
        }*/
        List<order_line_POE__c> OlList = [select Id,Status__c from order_line_POE__c where Room__c IN: roomList];
        system.debug('Line--42-->'+OlList);
        system.debug('Line--43-->'+OlList.size());
        
        for(order_line_POE__c ro : OlList){
            ro.Status__c = 'Cancelled';
        }
        if(!OlList.isEmpty()){
            update OlList;
        }
        
        
        
        
    }
    
    public static void createCanRefRecordRoomHotel(Map<Id,Id> RoomcancellationId){
        
        system.debug('Line--55-->'+RoomcancellationId.values());
        List<Cancellation_Refund_POE__c> deleteOldCanRef = new List<Cancellation_Refund_POE__c>();
        List<Cancellation_Refund_POE__c>oldcanList =[Select Id from Cancellation_Refund_POE__c where Tad_Booking_Hotel__c IN:RoomcancellationId.keyset()];
        system.debug('line--60-->'+oldcanList);
        for(Cancellation_Refund_POE__c can : oldcanList){
            deleteOldCanRef.add(can);
        }
        delete deleteOldCanRef;
        List<Booking_Hotel__c> bookinghotelslist = [select Id,Gross_Cost__c,Total_Amount_Outstanding__c,TAD_Order__c,Expedia_Booking_Amount__c,QFF_Payment__c,Total_Payment_Received_Without_QFF__c,TAD_Order__r.OwnerId,Cancellation_Amount__c,ordexp_Total_QFF_Received__c,ordexp_Coupon_Payment_Received__c,ordexp_Total_Payment_Received__c from Booking_Hotel__c where ID IN: RoomcancellationId.keyset()];
        
        Map<Id,Id> tadOrderBookingHotel = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c>canList =new List<Cancellation_Refund_POE__c>();
        
        //   Id hotelRecordTypeId = Schema.SObjectType.Cancellation_Refund_POE__c.getRecordTypeInfosByName().get('Hotel Cancellation').getRecordTypeId();
        Id roomId;
        Id canRefId;
        Id tadownerId;
        Boolean negativeValue = false;
        Decimal outstandingAmount = 0.00;
        Set<Id> bookingHotelIdSet = new Set<Id>();
        Decimal CanAmt = 0.00;
        for(Booking_Hotel__c bho : bookinghotelslist){
            if(bho.ordexp_Total_QFF_Received__c < 0.00){
                negativeValue = true;
            }
            outstandingAmount = -(bho.Total_Amount_Outstanding__c);
            CanAmt = outstandingAmount;
            tadownerId = bho.TAD_Order__r.OwnerId;
            Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
            can.ordexp_tad_order__c = bho.TAD_Order__c;
            can.Tad_Booking_Hotel__c = bho.Id;
            can.Approval_Status__c = 'Pending Finance Approval';
            can.Cancellation_Type__c = 'Cancellation';
            can.Type__c = 'Refund Required';
            can.Room_Cancellation_Amount__c = -(bho.Total_Amount_Outstanding__c);
            system.debug('Line--103-->'+ bho.Gross_Cost__c);
            
            system.debug('Line--110-->'+bho.ordexp_Coupon_Payment_Received__c);
                 system.debug('Line--111-->'+bho.ordexp_Total_QFF_Received__c);
             system.debug('Line--112-->'+ outstandingAmount);
            if(outstandingAmount > bho.ordexp_Total_QFF_Received__c){
                 system.debug('Line--113-->'+ 'True');
            }
            
            if((bho.ordexp_Coupon_Payment_Received__c == null || bho.ordexp_Coupon_Payment_Received__c == 0.00) && (bho.ordexp_Total_QFF_Received__c == null || bho.ordexp_Total_QFF_Received__c == 0.00)){
                can.Refund_Amount__c = outstandingAmount;                
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && (bho.ordexp_Total_QFF_Received__c ==null || bho.ordexp_Total_QFF_Received__c ==0.00) && (outstandingAmount > bho.ordexp_Coupon_Payment_Received__c)){
                can.Coupon_Amount__c = bho.ordexp_Coupon_Payment_Received__c;
                can.Refund_Amount__c = outstandingAmount-bho.ordexp_Coupon_Payment_Received__c;
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && (bho.ordexp_Total_QFF_Received__c ==null || bho.ordexp_Total_QFF_Received__c ==0.00) && (outstandingAmount == bho.ordexp_Coupon_Payment_Received__c)){
                can.Coupon_Amount__c = outstandingAmount;
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && (bho.ordexp_Total_QFF_Received__c ==null || bho.ordexp_Total_QFF_Received__c ==0.00) && (bho.ordexp_Total_Payment_Received__c  ==null || bho.ordexp_Total_Payment_Received__c  ==0.00) && (outstandingAmount < bho.ordexp_Coupon_Payment_Received__c)){
                can.Coupon_Amount__c = outstandingAmount;
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && (bho.ordexp_Total_QFF_Received__c ==null || bho.ordexp_Total_QFF_Received__c ==0.00) && (bho.ordexp_Total_Payment_Received__c  !=null || bho.ordexp_Total_Payment_Received__c  !=0.00) && (outstandingAmount < bho.ordexp_Coupon_Payment_Received__c)){
                can.Coupon_Amount__c = outstandingAmount;
            }
            
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00 && negativeValue ==false && (outstandingAmount > bho.ordexp_Total_QFF_Received__c)){                       
                can.QFF_Refund__c = bho.ordexp_Total_QFF_Received__c;
                
                if(can.QFF_Refund__c !=Null && ((outstandingAmount - bho.ordexp_Total_QFF_Received__c) > bho.ordexp_Coupon_Payment_Received__c)){
                    can.Coupon_Amount__c = bho.ordexp_Coupon_Payment_Received__c;
                    can.Refund_Amount__c = outstandingAmount - bho.ordexp_Coupon_Payment_Received__c - bho.ordexp_Total_QFF_Received__c;
                    
                }
                else if(can.QFF_Refund__c !=Null && ((outstandingAmount - bho.ordexp_Total_QFF_Received__c) < bho.ordexp_Coupon_Payment_Received__c)){
                    can.Coupon_Amount__c = outstandingAmount - bho.ordexp_Total_QFF_Received__c;
                    if(outstandingAmount > (bho.ordexp_Coupon_Payment_Received__c + bho.ordexp_Total_QFF_Received__c)){
                        can.Refund_Amount__c = outstandingAmount - (bho.ordexp_Coupon_Payment_Received__c + bho.ordexp_Total_QFF_Received__c);
                        
                    }
                    else{
                        can.Refund_Amount__c =0;
                        
                    }
                    
                }
                else if(can.QFF_Refund__c !=Null && ((outstandingAmount - bho.ordexp_Total_QFF_Received__c) == (bho.ordexp_Coupon_Payment_Received__c))){
                    can.Coupon_Amount__c = outstandingAmount - bho.ordexp_Total_QFF_Received__c;
                    
                }
                else{
                    can.Refund_Amount__c = outstandingAmount - bho.ordexp_Total_QFF_Received__c;
                    
                }
                
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00 && negativeValue ==false && (outstandingAmount < bho.ordexp_Total_QFF_Received__c)){                       
                system.debug('Line--158-->'+bho.ordexp_Coupon_Payment_Received__c);
                 system.debug('Line--159-->'+bho.ordexp_Total_QFF_Received__c);
                can.QFF_Refund__c =0.00;
                can.Coupon_Amount__c = outstandingAmount;
                can.Refund_Amount__c = 0.00;
                
            }
            if(bho.ordexp_Coupon_Payment_Received__c != null && bho.ordexp_Coupon_Payment_Received__c != 0.00 && bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00 && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount == bho.ordexp_Total_QFF_Received__c)){                       
                can.QFF_Refund__c = outstandingAmount;
                can.Coupon_Amount__c = 0.00;
                can.Refund_Amount__c = 0.00;
                
            }
            if((bho.ordexp_Coupon_Payment_Received__c == 0.00 || bho.ordexp_Coupon_Payment_Received__c == null) && (bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00)  && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount == bho.ordexp_Total_QFF_Received__c)){
                can.QFF_Refund__c = outstandingAmount;
            }
            if((bho.ordexp_Coupon_Payment_Received__c == 0.00 || bho.ordexp_Coupon_Payment_Received__c == null) && (bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00) && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount < bho.ordexp_Total_QFF_Received__c)){
                can.Coupon_Amount__c = outstandingAmount;
            }
            if((bho.ordexp_Coupon_Payment_Received__c == 0.00 || bho.ordexp_Coupon_Payment_Received__c == null) && (bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00) && (bho.ordexp_Total_Payment_Received__c !=null && bho.ordexp_Total_Payment_Received__c != 0.00) && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount > bho.ordexp_Total_QFF_Received__c)){
                can.QFF_Refund__c = bho.ordexp_Total_QFF_Received__c;
                can.Refund_Amount__c = outstandingAmount - bho.ordexp_Total_QFF_Received__c;
            }
            if((bho.ordexp_Coupon_Payment_Received__c == 0.00 || bho.ordexp_Coupon_Payment_Received__c == null) && (bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00) && (bho.ordexp_Total_Payment_Received__c !=null && bho.ordexp_Total_Payment_Received__c != 0.00) && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount < bho.ordexp_Total_QFF_Received__c)){
                can.Coupon_Amount__c = outstandingAmount;
            }
            if((bho.ordexp_Coupon_Payment_Received__c == 0.00 || bho.ordexp_Coupon_Payment_Received__c == null) && (bho.ordexp_Total_QFF_Received__c !=null && bho.ordexp_Total_QFF_Received__c != 0.00) && (bho.ordexp_Total_Payment_Received__c !=null && bho.ordexp_Total_Payment_Received__c != 0.00) && bho.QFF_Payment__c == True && negativeValue ==false && (outstandingAmount == bho.ordexp_Total_QFF_Received__c)){
                can.QFF_Refund__c = bho.ordexp_Total_QFF_Received__c;
                //can.Refund_Amount__c = bho.ordexp_Total_Payment_Received__c - bho.ordexp_Total_QFF_Received__c;
            }
            
            
            canList.add(can);
        }
        if(!canList.isEmpty()){
            insert canList; 
        }
        
        system.debug('Line27 '+canList);
        for(Cancellation_Refund_POE__c can1 : canList){
            
            tadOrderBookingHotel.put(can1.ordexp_tad_order__c,can1.Id);
            
        }
        
        List<Room__c> roomListtoUpdate = new List<Room__c>();
        
        List<Room__c> roomList = [select Id,Booking_Hotel__c,Cancellation_Amount_Room__c,Booking_Hotel__r.TAD_Order__c,Cancellation_Refund__c from Room__c where Booking_Hotel__c IN: RoomcancellationId.keySet() AND Status__c = 'Cancelled'];
       
        for(Room__c r1 : roomList){
            canRefId = tadOrderBookingHotel.get(r1.Booking_Hotel__r.TAD_Order__c);
            r1.Cancellation_Refund__c = tadOrderBookingHotel.get(r1.Booking_Hotel__r.TAD_Order__c);
            roomListtoUpdate.add(r1);
            
        }
        if(!roomListtoUpdate.isEmpty()){
            update roomListtoUpdate; 
        }
        system.debug('Line--180-->'+roomListtoUpdate);
        system.debug('Line--209->'+CanAmt);
        system.debug('Line--210->'+canRefId);
        system.debug('Line--211->'+tadownerId);
        
        
        
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(canRefId);
        req1.setSubmitterId(tadownerId); 
        req1.setProcessDefinitionNameOrId('Cancellation_Refund_Approval_Process_BH');
        req1.setSkipEntryCriteria(true);
        if(CanAmt != null){
        Approval.ProcessResult result = Approval.process(req1);
        }
        // Code to cancel the booking record
        List<Booking_Hotel__c> orderData =[Select id,Status__c,(Select Id,Status__c from Rooms__r where Status__c!='Cancelled' ) from Booking_Hotel__c where Id IN: RoomcancellationId.keyset() AND Modification_in_Progress__c = false AND Expedia_Booking_Amount__c = 0.00];
        
        List<Booking_Hotel__c> bhUpdate = new List<Booking_Hotel__c>();
        for(Booking_Hotel__c td : orderData)
        {    
            if(td.Rooms__r.size() == 0){
                td.Status__c = 'Cancelled';
                bhUpdate.add(td);
            }
        }
        
        if(!bhUpdate.isEmpty()){
            update bhUpdate;   
        }
    }
    
          public static void updateBookingStatusToProcessed(Set<Id> tadCanRefId){
            List<Booking_Hotel__c> bookinghotelslist = [select Id,CanRef_status__c,Refund_Type__c,Cancellation_Refund__c,Cancellation_Refund__r.Approval_Status__c,TAD_Order__c,TAD_Order__r.ordexp_gross_amount__c,Cancellation_Amount__c from Booking_Hotel__c where TAD_Order__c IN: tadCanRefId];
            For(Booking_Hotel__c bo : bookinghotelslist){
                bo.CanRef_status__c = 'Processed';
            }
            System.debug('Line--262-->'+bookinghotelslist);
            update bookinghotelslist;
        }
}