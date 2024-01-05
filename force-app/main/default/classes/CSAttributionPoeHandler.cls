public class CSAttributionPoeHandler {
    public static Boolean runOnce = false; 
    //This method is used for CS Attribution creation when OLI goes to Secured, and also covers conditions if the Dep Date HSS and Dep City Surcharges Apply.    
    public static void createCSAttributionPoeForOLI(List<Order_line_item__c> newOLIRecords, Map<Id, Order_line_item__c> oldOLIRecordsMap){
       
        //card Psag-199 handel create duplicate hss cs attribution
        Set<Id> setOfOli = new Set<Id>();
        for(Order_line_item__c ol : newOLIRecords){
          setOfOli.add(ol.id);
        }
        Map<Id,Decimal> mapofcsattForDepDate= new  Map<Id,Decimal>();
         Map<Id,Decimal> mapofcsattforDepCIty= new  Map<Id,Decimal>();
        
        List<CS_Attribution_POE__c> existingCSAttributions= [Select id,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c from CS_Attribution_POE__c where cs_OLI__c in: setOfOli  AND cs_Attribution_Type__c !='Addon' AND cs_status__c !='Cancelled'];
        system.debug('existingCSAttributions15---'+existingCSAttributions);
        for(CS_Attribution_POE__c csa :existingCSAttributions){
            if(csa.cs_Attribution_Type__c == 'Dep Date HSS'){
               mapofcsattForDepDate.put(Id.ValueOf(csa.cs_OLI__c),csa.cs_Sale_Amount__c); 
            }
            if(csa.cs_Attribution_Type__c== 'Dep City Surcharge'){
               mapofcsattforDepCIty.put(Id.ValueOf(csa.cs_OLI__c),csa.cs_Sale_Amount__c);   
            }
            
        }
        system.debug('mapofcsattdepDate20---'+mapofcsattForDepDate);
         system.debug('mapofcsattforDepCIty---'+mapofcsattforDepCIty);
        List<CS_Attribution_POE__c> listOfCsAttribute = new List<CS_Attribution_POE__c>();
        
        for(Order_line_item__c oli : newOLIRecords){ 
            CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
            CS_Attribution_POE__c cs1 = new CS_Attribution_POE__c();
            CS_Attribution_POE__c cs2 = new CS_Attribution_POE__c(); 
            
            // Card CSA-7 For hss Amount and ordexp_city_surcharge_amount__c is Equal to 0
            cs.cs_Attribution_Type__c = 'Sub Option';
            cs.cs_OLI__c = oli.Id;
            if(oli.Attribution__c != Null){
                cs.cs_Sale_Amount__c = oli.ordexp_suboption_amount__c==null?0:(((oli.ordexp_suboption_amount__c + oli.Total_surcharge__c)*oli.Attribution__c)/100);   
                    }
            cs.TAD_Order__c = oli.ordexp_TAD_Order__c;
            cs.cs_status__c ='Sold';
            cs.CurrencyIsoCode =oli.CurrencyIsoCode;
            cs.User__c = oldOLIRecordsMap.get(oli.id).CreatedById;
            listOfCsAttribute.add(cs);   
            
            // Card CSA-9 For ordexp_city_surcharge_amount__c greater than 0
            if(oli.ordexp_city_surcharge_amount__c >0){
                 system.debug('Getting the value mapofcsatt---'+mapofcsattforDepCIty.containsKey(oli.id));
                if(!mapofcsattforDepCIty.containsKey(oli.id)){                    
                   cs1.cs_Attribution_Type__c = 'Dep City Surcharge';
                cs1.cs_OLI__c = oli.Id;
                if(oli.Attribution__c != Null){
                    cs1.cs_Sale_Amount__c = oli.ordexp_city_surcharge_amount__c==null?0:((oli.ordexp_city_surcharge_amount__c*oli.Attribution__c)/(100));
                        }
                cs1.TAD_Order__c = oli.ordexp_TAD_Order__c;
                cs1.cs_status__c ='Sold';
                cs1.CurrencyIsoCode =oli.CurrencyIsoCode;
                cs1.User__c = oldOLIRecordsMap.get(oli.id).CreatedById;
                listOfCsAttribute.add(cs1); 
                }
                                  
            }
            
            // Card CSA-8 For hss Amount s greater than 0
            if(oli.HSS_Amount__c >0){
                system.debug('Getting the value mapofcsatt---'+mapofcsattForDepDate.containsKey(oli.id));
                if(!mapofcsattForDepDate.containsKey(oli.id)){
                    //system.debug('Getting the value mapofcsatt22'+mapofcsattForDepDate.get(oli.id));
                    cs2.cs_Attribution_Type__c = 'Dep Date HSS';
                    cs2.cs_OLI__c = oli.Id;
                    if(oli.Attribution__c != Null){
                        cs2.cs_Sale_Amount__c = oli.HSS_Amount__c==null?0:((oli.HSS_Amount__c*oli.Attribution__c)/(100));
                            }
                cs2.TAD_Order__c = oli.ordexp_TAD_Order__c;
                cs2.cs_status__c ='Sold';
                cs2.CurrencyIsoCode =oli.CurrencyIsoCode;
                cs2.User__c =oldOLIRecordsMap.get(oli.id).CreatedById;
                listOfCsAttribute.add(cs2);   
                    
                }
               
                
            }    
        }
        
        
        if(!listOfCsAttribute.isEmpty()){
            insert listOfCsAttribute;
            system.debug('line57'+listOfCsAttribute);
        }
        
    }
    
    
    public static void createCSAttributionPoeForAddOn(List<AddOn__c> newAddOnRecords,Map<Id, AddOn__c> oldAddonMap){
        
        List<CS_Attribution_POE__c> listOfCsAttributeToBeInserted = new List<CS_Attribution_POE__c>();
        
        
        for(AddOn__c addOn : newAddOnRecords){
            CS_Attribution_POE__c csAttForAddOn = new CS_Attribution_POE__c();
            csAttForAddOn.cs_Attribution_Type__c = 'Addon';
            csAttForAddOn.cs_AddOn__c = addOn.Id;
            csAttForAddOn.cs_OLI__c = addOn.Order_Line_Item__c;
            if(addOn.Attribution__c != Null){
                csAttForAddOn.cs_Sale_Amount__c = addOn.ordexp_amount__c==null || addOn.ordexp_amount__c == 0.00 ? 0:((addOn.ordexp_amount__c * addOn.Attribution__c)/(100));   
                    }
            csAttForAddOn.TAD_Order__c = addOn.TAD_Order_Id__c;
            csAttForAddOn.cs_status__c ='Sold';
            csAttForAddOn.CurrencyIsoCode =addOn.CurrencyIsoCode;
            csAttForAddOn.User__c = oldAddonMap.get(addOn.Id).CreatedById;
            listOfCsAttributeToBeInserted.add(csAttForAddOn); 
        } 
        
        
        if(!listOfCsAttributeToBeInserted.isEmpty()){
            system.debug('listOfCsAttributeToBeInserted===>'+listOfCsAttributeToBeInserted);
            insert listOfCsAttributeToBeInserted;
        }
        
    }    
    
    
    public static void cancelCSAttributionPoeForOli(List<Order_line_item__c> cancelledOLIs){
        Boolean isSplitedOliCSRec = false;
        Set<Id> orderId = new Set<Id>();
        Set<Id> setOfIdsAlreadyNegated = new Set<ID>();
        Set<Id> cancelledOliList = new Set<Id>();
        List<CS_Attribution_POE__c> newListOfCsAttributeForSplitted = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> newListOfCsAttribute = new List<CS_Attribution_POE__c>();
        for(Order_line_item__c oli : cancelledOLIs){
            isSplitedOliCSRec = oli.isSplit__c;
            orderId.add(oli.ordexp_TAD_Order__c);
        }
        
       
        
        List<Order_line_item__c> oliList = [Select id from Order_line_item__c where ordexp_TAD_Order__c in:orderId  AND OLI_Status__c ='Cancelled' AND (Refund_Status__c = 'Full Credit' OR Refund_Status__c ='Partial Credit' OR Refund_Status__c = 'Full Refund' OR Refund_Status__c ='Partial Refund' OR Refund_Status__c = 'Full Coupon' OR Refund_Status__c ='Partial Coupon' OR Refund_Status__c ='Partial Refund/Coupon/Credit')];
        for(Order_line_item__c ol : oliList){
          cancelledOliList.add(ol.id);
        }
        
        if(isSplitedOliCSRec == true){
            List<CS_Attribution_POE__c> existingCSAttributions= [Select id,createdAfterSpilit__c,cs_OLI__r.isSplit__c,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_OLI__r.CurrencyIsoCode, cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c from CS_Attribution_POE__c where cs_OLI__c in: cancelledOliList  AND cs_Attribution_Type__c !='Addon' AND cs_status__c !='Cancelled' AND createdAfterSpilit__c = true];
            List<CS_Attribution_POE__c> existingCSAttributionOneswithCancelled= [Select id,cs_attribution__c,cs_OLI__r.ordexp_oli_CanAmount__c,cs_OLI__r.CurrencyIsoCode,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_OLI__r.Cancellation_Amount__c from CS_Attribution_POE__c where cs_OLI__c in: cancelledOliList  AND cs_Attribution_Type__c !='Addon'];
        
            system.debug('Line--147-->'+existingCSAttributionOneswithCancelled);
            for(CS_Attribution_POE__c csAtt : existingCSAttributionOneswithCancelled){
                if(csAtt.cs_attribution__c != null){
                setOfIdsAlreadyNegated.add(csAtt.cs_attribution__c);
            }
        }
            
            if(!existingCSAttributions.isEmpty()){
                for(CS_Attribution_POE__c existingCSAtt : existingCSAttributions){
                    if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                    CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                    reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                    reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                    reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                    reverseCSAtt.cs_Sale_Amount__c = 0 - existingCSAtt.cs_Sale_Amount__c; 
                    reverseCSAtt.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                    reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                    reverseCSAtt.cs_status__c ='Cancelled';
                    reverseCSAtt.User__c = existingCSAtt.User__c;
                    newListOfCsAttributeForSplitted.add(reverseCSAtt);   
                    
                    }
                }
            }
        } else {
            List<CS_Attribution_POE__c> existingCSAttributions= [Select id,createdAfterSpilit__c,cs_OLI__r.isSplit__c,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_OLI__r.CurrencyIsoCode, cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c from CS_Attribution_POE__c where cs_OLI__c in: cancelledOliList  AND cs_Attribution_Type__c !='Addon' AND cs_status__c !='Cancelled'];
            if(!existingCSAttributions.isEmpty()){
                for(CS_Attribution_POE__c existingCSAtt : existingCSAttributions){
                    if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                    CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                    reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                    reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                    reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                    reverseCSAtt.cs_Sale_Amount__c = 0 - existingCSAtt.cs_Sale_Amount__c; 
                    reverseCSAtt.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                    reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                    reverseCSAtt.cs_status__c ='Cancelled';
                    reverseCSAtt.User__c = existingCSAtt.User__c;
                    newListOfCsAttribute.add(reverseCSAtt);   
                    }
                    
                }
            }   
        }
        if(!newListOfCsAttribute.isEmpty()){
            insert newListOfCsAttribute;
        }
        if(!newListOfCsAttributeForSplitted.isEmpty()){
            insert newListOfCsAttributeForSplitted;
        }
    }
    
      public static void cancelCSAttributionPoeForOliWithOffloaded(List<Order_line_item__c> cancelledOLIs){
        Boolean isSplitedOliCSRec = false;
          system.debug('CSATTribution=====171cancelCSAttributionPoeForOliWithOffloaded');
        List<CS_Attribution_POE__c> newListOfCsAttributeForSplitted = new List<CS_Attribution_POE__c>();
        List<Id> orderId = new List<Id>();
         Set<Id> setOfIdsAlreadyNegated = new Set<ID>();
        List<CS_Attribution_POE__c> newListOfCsAttribute = new List<CS_Attribution_POE__c>();
        for(Order_line_item__c oli : cancelledOLIs){
            isSplitedOliCSRec = oli.isSplit__c;
            orderId.add(oli.ordexp_TAD_Order__c);
        }
        if(isSplitedOliCSRec == true){
            List<CS_Attribution_POE__c> existingCSAttributions= [Select id,createdAfterSpilit__c,cs_OLI__r.isSplit__c,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_OLI__r.CurrencyIsoCode, cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c from CS_Attribution_POE__c where TAD_Order__c in: orderId  AND cs_Attribution_Type__c !='Addon' AND cs_status__c !='Cancelled' AND createdAfterSpilit__c = true];
            List<CS_Attribution_POE__c> existingCSAttributionOneswithCancelled= [Select id,cs_attribution__c,cs_OLI__r.ordexp_oli_CanAmount__c,cs_OLI__r.CurrencyIsoCode,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_OLI__r.Cancellation_Amount__c from CS_Attribution_POE__c where TAD_Order__c in: orderId  AND cs_Attribution_Type__c !='Addon' AND createdAfterSpilit__c = true];
        
            
            for(CS_Attribution_POE__c csAtt : existingCSAttributionOneswithCancelled){
                if(csAtt.cs_attribution__c != null){
                setOfIdsAlreadyNegated.add(csAtt.cs_attribution__c);
            }
            }
            if(!existingCSAttributions.isEmpty()){
                for(CS_Attribution_POE__c existingCSAtt : existingCSAttributions){
                     if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                    CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                    reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                    reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                    reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                    reverseCSAtt.cs_Sale_Amount__c = 0 - existingCSAtt.cs_Sale_Amount__c; 
                    reverseCSAtt.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                    reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                    reverseCSAtt.cs_status__c ='Cancelled';
                    reverseCSAtt.User__c = existingCSAtt.User__c;
                    newListOfCsAttributeForSplitted.add(reverseCSAtt);   
                    
                     }
                }
            }
        } else {
            List<CS_Attribution_POE__c> existingCSAttributions= [Select id,createdAfterSpilit__c,cs_OLI__r.isSplit__c,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_OLI__r.CurrencyIsoCode, cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c from CS_Attribution_POE__c where TAD_Order__c in: orderId  AND cs_Attribution_Type__c !='Addon' AND cs_status__c !='Cancelled'];
            List<CS_Attribution_POE__c> existingCSAttributionOneswithCancelled= [Select id,cs_attribution__c,cs_OLI__r.ordexp_oli_CanAmount__c,cs_OLI__r.CurrencyIsoCode,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_OLI__r.Cancellation_Amount__c from CS_Attribution_POE__c where TAD_Order__c in: orderId  AND cs_Attribution_Type__c !='Addon'];
        
            
            for(CS_Attribution_POE__c csAtt : existingCSAttributionOneswithCancelled){
                if(csAtt.cs_attribution__c != null){
                setOfIdsAlreadyNegated.add(csAtt.cs_attribution__c);
            }
            }
            
            
            
            if(!existingCSAttributions.isEmpty()){
                for(CS_Attribution_POE__c existingCSAtt : existingCSAttributions){
                     if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                    CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                    reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                    reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                    reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                    reverseCSAtt.cs_Sale_Amount__c = 0 - existingCSAtt.cs_Sale_Amount__c; 
                    reverseCSAtt.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                    reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                    reverseCSAtt.cs_status__c ='Cancelled';
                    reverseCSAtt.User__c = existingCSAtt.User__c;
                    newListOfCsAttribute.add(reverseCSAtt);   
                     } 
                    
                }
            }   
        }
        if(!newListOfCsAttribute.isEmpty()){
            insert newListOfCsAttribute;
        }
        if(!newListOfCsAttributeForSplitted.isEmpty()){
            insert newListOfCsAttributeForSplitted;
        }
    }
    
    
    public static void cancelCSAttributionPoeForOliPartialRefundCoupon(List<Order_line_item__c> cancelledOLIsOne){
        system.debug('CSATTribution=====248-cancelCSAttributionPoeForOliPartialRefundCoupon');
        List<CS_Attribution_POE__c> newListOfCsAttribute = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> existingCSAttributionOnes= [Select id,cs_attribution__c,cs_OLI__r.ordexp_oli_CanAmount__c,cs_OLI__r.CurrencyIsoCode,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_OLI__r.Cancellation_Amount__c from CS_Attribution_POE__c where cs_OLI__c in: cancelledOLIsOne  AND cs_status__c !='Cancelled' AND cs_Attribution_Type__c !='Addon'];
        List<CS_Attribution_POE__c> existingCSAttributionOneswithCancelled= [Select id,cs_attribution__c,cs_OLI__r.ordexp_oli_CanAmount__c,cs_OLI__r.CurrencyIsoCode,cs_OLI__r.OLI_Cancellation_Percentage__c,cs_Attribution_Type__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_OLI__r.Cancellation_Amount__c from CS_Attribution_POE__c where cs_OLI__c in: cancelledOLIsOne  AND cs_Attribution_Type__c !='Addon'];
        
        Set<Id> setOfIdsAlreadyNegated = new Set<ID>();
        for(CS_Attribution_POE__c csAtt : existingCSAttributionOneswithCancelled){
            if(csAtt.cs_attribution__c != null){
                setOfIdsAlreadyNegated.add(csAtt.cs_attribution__c);
            }
        }
        System.debug('Line 156'+setOfIdsAlreadyNegated);
        for(Order_line_item__c oli : cancelledOLIsOne){ 
            System.debug('oliHss'+oli.HSS_Amount__c);
            System.debug('oliCity'+oli.ordexp_city_surcharge_amount__c);
            System.debug('csSize'+existingCSAttributionOnes.size());
            if(oli.HSS_Amount__c == 0 && oli.ordexp_city_surcharge_amount__c == 0){
                if(!existingCSAttributionOnes.isEmpty()){
                    System.debug('Prinlt Line 1'+setOfIdsAlreadyNegated);
                    for(CS_Attribution_POE__c existingCSAtt : existingCSAttributionOnes){
                        if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                            CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                            reverseCSAtt.cs_Attribution_Type__c = 'Sub Option';
                            reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAtt.cs_Sale_Amount__c = -(existingCSAtt.cs_OLI__r.ordexp_oli_CanAmount__c); 
                            reverseCSAtt.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAtt.cs_status__c ='Cancelled';
                            reverseCSAtt.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAtt); 
                        }
                    }
                }
            }
            
            if(oli.HSS_Amount__c > 0 && oli.ordexp_city_surcharge_amount__c == 0){
                if(!existingCSAttributionOnes.isEmpty()){
                    System.debug('Prinlt Line 2'+setOfIdsAlreadyNegated);
                    for(CS_Attribution_POE__c existingCSAtt : existingCSAttributionOnes){
                        if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                        if(existingCSAtt.cs_Attribution_Type__c == 'Sub Option'){
                            
                            CS_Attribution_POE__c reverseCSAttSubOption = new CS_Attribution_POE__c();
                            reverseCSAttSubOption.cs_Attribution_Type__c = 'Sub Option';
                            reverseCSAttSubOption.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttSubOption.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttSubOption.cs_Sale_Amount__c = -((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttSubOption.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttSubOption.cs_status__c ='Cancelled';
                            reverseCSAttSubOption.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttSubOption.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttSubOption); 
                        }
                        
                        
                        if(existingCSAtt.cs_Attribution_Type__c == 'Dep Date HSS'){
                            CS_Attribution_POE__c reverseCSAttHSS = new CS_Attribution_POE__c();
                            reverseCSAttHSS.cs_Attribution_Type__c = 'Dep Date HSS';
                            reverseCSAttHSS.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttHSS.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttHSS.cs_Sale_Amount__c = -((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttHSS.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttHSS.cs_status__c ='Cancelled';
                            reverseCSAttHSS.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttHSS.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttHSS); 
                        }
                        }
                        
                    }
                }
            }
            
            if(oli.HSS_Amount__c == 0 && oli.ordexp_city_surcharge_amount__c > 0){
                if(!existingCSAttributionOnes.isEmpty()){
                   System.debug('Prinlt Line 3'+setOfIdsAlreadyNegated);
                    for(CS_Attribution_POE__c existingCSAtt : existingCSAttributionOnes){
                       if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                        if(existingCSAtt.cs_Attribution_Type__c == 'Sub Option'){
                            CS_Attribution_POE__c reverseCSAttSubOptionNew = new CS_Attribution_POE__c();
                            reverseCSAttSubOptionNew.cs_Attribution_Type__c = 'Sub Option';
                            reverseCSAttSubOptionNew.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttSubOptionNew.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttSubOptionNew.cs_Sale_Amount__c =-((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttSubOptionNew.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttSubOptionNew.cs_status__c ='Cancelled';
                            reverseCSAttSubOptionNew.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttSubOptionNew.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttSubOptionNew); 
                        }
                        
                        
                        if(existingCSAtt.cs_Attribution_Type__c == 'Dep City Surcharge'){
                            CS_Attribution_POE__c reverseCSAttCitySurchargeNew = new CS_Attribution_POE__c();
                            reverseCSAttCitySurchargeNew.cs_Attribution_Type__c = 'Dep City Surcharge';
                            reverseCSAttCitySurchargeNew.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttCitySurchargeNew.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttCitySurchargeNew.cs_Sale_Amount__c = -((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttCitySurchargeNew.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttCitySurchargeNew.cs_status__c ='Cancelled';
                            reverseCSAttCitySurchargeNew.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttCitySurchargeNew.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttCitySurchargeNew); 
                        }
                           }
                        
                    }
                }
            }
            
            
            if(oli.HSS_Amount__c > 0 && oli.ordexp_city_surcharge_amount__c > 0){
                if(!existingCSAttributionOnes.isEmpty()){
                    System.debug('Prinlt Line 4'+setOfIdsAlreadyNegated);
                    for(CS_Attribution_POE__c existingCSAtt : existingCSAttributionOnes){
                           if(!setOfIdsAlreadyNegated.contains(existingCSAtt.Id)){
                            if(existingCSAtt.cs_Attribution_Type__c == 'Sub Option'){
                            system.debug('Line248'+existingCSAtt.cs_Attribution_Type__c);
                            CS_Attribution_POE__c reverseCSAttSubOptionNewOne = new CS_Attribution_POE__c();
                            reverseCSAttSubOptionNewOne.cs_Attribution_Type__c = 'Sub Option';
                            reverseCSAttSubOptionNewOne.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttSubOptionNewOne.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttSubOptionNewOne.cs_Sale_Amount__c = -((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttSubOptionNewOne.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttSubOptionNewOne.cs_status__c ='Cancelled';
                            reverseCSAttSubOptionNewOne.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttSubOptionNewOne.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttSubOptionNewOne); 
                        }
                        
                        if(existingCSAtt.cs_Attribution_Type__c == 'Dep Date HSS'){
                            system.debug('Line261'+existingCSAtt.cs_Attribution_Type__c);
                            CS_Attribution_POE__c reverseCSAttHSSNewOne = new CS_Attribution_POE__c();
                            reverseCSAttHSSNewOne.cs_Attribution_Type__c = 'Dep Date HSS';
                            reverseCSAttHSSNewOne.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttHSSNewOne.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttHSSNewOne.cs_Sale_Amount__c = -((existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100);                
                            reverseCSAttHSSNewOne.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttHSSNewOne.cs_status__c ='Cancelled';
                            reverseCSAttHSSNewOne.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;    
                            reverseCSAttHSSNewOne.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttHSSNewOne); 
                        }
                        
                        if(existingCSAtt.cs_Attribution_Type__c == 'Dep City Surcharge'){
                            system.debug('Line274'+existingCSAtt.cs_Attribution_Type__c);
                            CS_Attribution_POE__c reverseCSAttCitySurchargeNewOne = new CS_Attribution_POE__c();
                            reverseCSAttCitySurchargeNewOne.cs_Attribution_Type__c = 'Dep City Surcharge';
                            reverseCSAttCitySurchargeNewOne.cs_attribution__c = existingCSAtt.Id;
                            reverseCSAttCitySurchargeNewOne.cs_OLI__c = existingCSAtt.cs_OLI__c;
                            reverseCSAttCitySurchargeNewOne.cs_Sale_Amount__c = -(existingCSAtt.cs_Sale_Amount__c * existingCSAtt.cs_OLI__r.OLI_Cancellation_Percentage__c)/100;                
                            reverseCSAttCitySurchargeNewOne.TAD_Order__c = existingCSAtt.TAD_Order__c;
                            reverseCSAttCitySurchargeNewOne.cs_status__c ='Cancelled';
                            reverseCSAttCitySurchargeNewOne.CurrencyIsoCode =existingCSAtt.cs_OLI__r.CurrencyIsoCode;
                            reverseCSAttCitySurchargeNewOne.User__c = existingCSAtt.User__c;
                            newListOfCsAttribute.add(reverseCSAttCitySurchargeNewOne); 
                        }
                        
                           } 
                    }
                }
            }
            
        }
        system.debug('Line292'+newListOfCsAttribute.size());
        if(!newListOfCsAttribute.isEmpty()){
            insert newListOfCsAttribute;
        }
        
    }
    
    
    public static void cancelCSAttributionPoeForAddOn(List<AddOn__c> cancelledAddons){
          system.debug('CSATTribution=====422-cancelCSAttributionPoeForAddOn');
        List<CS_Attribution_POE__c> listOfCsAttributeToBeInserted = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> existingCSAttributions= [Select id,CurrencyIsoCode,cs_OLI__r.CurrencyIsoCode, cs_Attribution_Type__c,cs_AddOn__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_AddOn__r.Cancellation_Amount__c from CS_Attribution_POE__c where cs_AddOn__c in: cancelledAddons AND cs_status__c !='Cancelled' AND cs_Attribution_Type__c ='Addon'];
        if(!existingCSAttributions.isEmpty()){
            for(CS_Attribution_POE__c existingCSAtt : existingCSAttributions){
                CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                reverseCSAtt.cs_AddOn__c = existingCSAtt.cs_AddOn__c;
                reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                if(existingCSAtt.cs_Sale_Amount__c != null ){
                    reverseCSAtt.cs_Sale_Amount__c = 0 - existingCSAtt.cs_Sale_Amount__c;   
                }                             
                reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                reverseCSAtt.cs_status__c ='Cancelled';
                reverseCSAtt.CurrencyIsoCode =existingCSAtt.CurrencyIsoCode;
                reverseCSAtt.User__c = existingCSAtt.User__c;
                listOfCsAttributeToBeInserted.add(reverseCSAtt); 
            }
        }
        
        if(!listOfCsAttributeToBeInserted.isEmpty()){
            system.debug('listOfCsAttributeToBeInserted===>'+listOfCsAttributeToBeInserted);
            insert listOfCsAttributeToBeInserted;
        }
        
    }
    
    public static void cancelCSAttributionPoeForAddOnPartialRefundAndCoupon(List<AddOn__c> cancelledAddonsRefundandCoupon){
           system.debug('CSATTribution=====451-cancelCSAttributionPoeForAddOnPartialRefundAndCoupon');
        List<CS_Attribution_POE__c> listOfCsAttributeToBeInserted = new List<CS_Attribution_POE__c>();
        List<CS_Attribution_POE__c> existingCSAttributionsOne= [Select id,CurrencyIsoCode,cs_OLI__r.CurrencyIsoCode,cs_AddOn__r.final_Cancellation_Amount__c, cs_Attribution_Type__c,cs_AddOn__c, cs_OLI__c, cs_Sale_Amount__c, TAD_Order__c, cs_status__c, User__c,cs_AddOn__r.Cancellation_Amount__c from CS_Attribution_POE__c where cs_AddOn__c in: cancelledAddonsRefundandCoupon AND cs_status__c !='Cancelled' AND cs_Attribution_Type__c ='Addon'];
        if(!existingCSAttributionsOne.isEmpty()){
            for(CS_Attribution_POE__c existingCSAtt : existingCSAttributionsOne){
                CS_Attribution_POE__c reverseCSAtt = new CS_Attribution_POE__c();
                reverseCSAtt.cs_Attribution_Type__c = existingCSAtt.cs_Attribution_Type__c;
                reverseCSAtt.cs_AddOn__c = existingCSAtt.cs_AddOn__c;
                reverseCSAtt.cs_attribution__c = existingCSAtt.Id;
                reverseCSAtt.cs_OLI__c = existingCSAtt.cs_OLI__c;
                reverseCSAtt.cs_Sale_Amount__c = -existingCSAtt.cs_AddOn__r.final_Cancellation_Amount__c;                
                reverseCSAtt.TAD_Order__c = existingCSAtt.TAD_Order__c;
                reverseCSAtt.cs_status__c ='Cancelled';
                reverseCSAtt.CurrencyIsoCode =existingCSAtt.CurrencyIsoCode;
                reverseCSAtt.User__c = existingCSAtt.User__c;
                listOfCsAttributeToBeInserted.add(reverseCSAtt); 
            }
        }
        
        if(!listOfCsAttributeToBeInserted.isEmpty()){
            system.debug('listOfCsAttributeToBeInserted===>'+listOfCsAttributeToBeInserted);
            insert listOfCsAttributeToBeInserted;
        }
        
    }
    
}