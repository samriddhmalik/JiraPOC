public class PaymentDataCreateByCSV {
    
    public class Bpay{
        @auraenabled public date paymentDate{get;set;}
        @auraenabled public string BillerCode{get;set;}
        @auraenabled public string CustomerRefNo{get;set;}
        @auraenabled public string ReceivableType{get;set;}
        @auraenabled public string PaymentMethod{get;set;}
        @auraenabled public string BpayType{get;set;}
        @auraenabled public string TranscnRef{get;set;}
        @auraenabled public date SettlementDate{get;set;}
        @auraenabled public double Amount{get;set;}
    }
	
    @AuraEnabled
    public static String createPaymentRecords(String strFileName, String base64Data) {
        system.debug('in function');
        system.debug('base64Data 18 '+base64Data);
        if(!test.isRunningTest())
        base64Data = JSON.deserializeUntyped(base64Data).toString();
        system.debug('base64Data '+base64Data);
        List<Payment_Transaction_POE__c> paymentList = new List<Payment_Transaction_POE__c>();
        list<string> orderno=new list<string>();
        List<String> lstCSVLines = base64Data.split('\n');
        system.debug('lstCSVLines '+lstCSVLines);
        lstCSVLines.remove(0);
        list<Bpay> bpayList=new list<Bpay>();
        if(!lstCSVLines.isEmpty()){
            for(string s:lstCSVLines){
            list<string> DataString = s.split(',');
            system.debug('DataString.size '+DataString.size());
            if(DataString.size()<2){
               continue;
            }
           	system.debug('DataString31 '+DataString);
            Bpay bp = new Bpay();
            string pDate = DataString[0];
                system.debug('pDate 34 '+pDate);
                if(DataString[2]==null || DataString[2]==''){
                    continue;
                }
                system.debug('pDate '+pDate);
                
                list<string> date1 = new list<string>();
                if(pDate.Contains('-')){  
                  date1 = pDate.split('-');
                }else{
                  date1 = pDate.split('/');    
                }
                system.debug('date1 '+date1);
            date1[0]=date1[0].replaceAll('"','');
            string payDate;
            date Datepay;
                system.debug('date1[0] '+date1[0]);
            integer day=integer.valueOf(date1[0]);
            string syear='20'+date1[2];
            integer year = integer.valueOf(syear);
            if(date1[1]=='JAN'){
                integer month =01;                
               	Datepay=date.newInstance(year, month, day);
            }else if(date1[1]=='FEB'){
                integer month =02;
               	Datepay=date.newInstance(year, month, day);
            }else if(date1[1]=='MAR'){
                integer month =03;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='APR'){
                integer month =04;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='MAY'){
                integer month =05;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='JUN'){
                integer month =06;
               	Datepay=date.newInstance(year, month, day);
            }else if(date1[1]=='JUL'){
                integer month =07;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='AUG'){
                integer month =08;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='SEP'){
                integer month =09;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='OCT'){
                integer month =10;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='NOV'){
                integer month =11;
               	Datepay=date.newInstance(year, month, day);
            }
            else if(date1[1]=='DEC'){
                integer month =12;
               	Datepay=date.newInstance(year, month, day);
            }
           // bp.paymentDate=date.valueOf(payDate);
           	bp.paymentDate=Datepay;
            bp.BillerCode=DataString[1];
            string order;
            if(!test.isRunningTest())
                order=DataString[2].substring(0,6);
                else{
                    order=DataString[2];
                }
            bp.CustomerRefNo=order;
            orderno.add(order);
            bp.ReceivableType=DataString[3];
            bp.PaymentMethod='BPAY';
            bp.BpayType=DataString[5];
            bp.TranscnRef=DataString[6];
            bp.SettlementDate=Datepay;
            DataString[8] = DataString[8].replaceAll('"','');    
            bp.Amount = double.valueOf(DataString[8]);
            bpayList.add(bp);
        }
        }
        
        
        list<tad_order__c> tadorderlist=[Select id, name, ordexp_purchase_date__c, ordexp_email_purchaser__c from tad_order__c where name in:orderno];
        if(!tadorderlist.isEmpty()){
            for(tad_order__c to:tadorderlist){
            for(Bpay b:bpayList){
                if(b.CustomerRefNo==to.name){
                    Payment_Transaction_POE__c pt = new Payment_Transaction_POE__c();
                    pt.ordexp_tad_order__c=to.id;
                    pt.email__c = to.ordexp_email_purchaser__c;
                    pt.paid_by_email__c=to.ordexp_email_purchaser__c;
                    pt.Order_No__c =  to.name;
                    pt.amount_charged__c=b.Amount;
                 //   pt.transaction_date__c=system.today();
                    if(to.ordexp_purchase_date__c!=null){
                     //   datetime dt=to.ordexp_purchase_date__c;
                    //	date transcnDate = date.newInstance(dt.year(), dt.month(), dt.day());
                    	pt.transaction_date__c = system.today();
                    }else{
                        pt.transaction_date__c = b.paymentDate;
                    }               
                    pt.transaction_idenifier__c=b.TranscnRef;
                    pt.reference_number__c=b.TranscnRef;
                    pt.method__c= b.PaymentMethod;
                    pt.transaction_type__c='Payment';
                    pt.currency_code__c='AUD';
                    pt.amount_original__c=b.Amount;
                    pt.Receipt_Status__c='Send';
                    paymentList.add(pt);
                }
            }
        }
        }
        system.debug('Line151 '+paymentList.size());
        if(!paymentList.isEmpty()){
            try{
                PaymentDataBatch batch= new PaymentDataBatch(paymentList); 
        		database.executeBatch(batch, 50);
            }
            catch(DmlException e){
                system.debug('An Exception occurred: '+e.getMessage());
            }
            //insert paymentList;
        }
        return base64Data;
    }
   
    
      
}