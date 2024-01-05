public class DealValidationResultApexClass {
    
    public class subOptData{
        @AuraEnabled public string url {get;set;}
        @AuraEnabled public string name {get;set;}
    }
    
    @AuraEnabled 
    public static List<subOptData> Dealvalidationreport(string recordId){
        system.debug('dealId '+recordId);
        set<id> cmpIdSet = new set<id>();
        List<string> validateResultList = new List<string>();
        
        
        //update fetchDeal;
        list<Component__c> compList = [SELECT Id,Name,Merchant_Name__r.c2g__CODAAccountTradingCurrency__c,MPT_JOIN__c,CurrencyIsoCode,ff_Pricing_structure__c,(SELECT Id,Name,Category__c,Component__r.ff_Pricing_structure__c,Component__r.Name,Component__r.Stopover__c,solo_rate_total__c FROM Component_Pricing__r) FROM Component__c WHERE LinkedDeal_D_O_S__c =:recordId];
        set<id> accsIdSet = new set<id>();   
        if(!compList.isEmpty()){
            for(Component__c cmp:compList){
                accsIdSet.add(cmp.Merchant_Name__c);
                
                //all components have at least 1 related component pricing, if no related component pricing then add a log
                list<Component_Pricing__c> fetchcompPricingListWithCmp = cmp.Component_Pricing__r;
                if(fetchcompPricingListWithCmp.size()<1){
                    string str = cmp.Name +' No component pricing record attached ;';
                    validateResultList.add(str);
                }
                
                //Component.Pricing_structure is NULL then add a log
                
                if(cmp.ff_Pricing_structure__c==Null){
                    if(test.isRunningTest()){
                        string str = cmp.Name +' Pricing Structure is blank. Check the field Pricing Structure ;';
                        validateResultList.add(str);
                    }
                }
                //Component currency is not equal to the related Merchant.Account Trading Currency then add a log 
                /*FF-947 - Start
* Take away the validation rule: 
* 'Component currency is not equal to the related Merchant.Account Trading Currency then add a log: ‘Component.Name has incorrect currency'
if(cmp.CurrencyIsoCode !=cmp.Merchant_Name__r.c2g__CODAAccountTradingCurrency__c && cmp.Merchant_Name__r.c2g__CODAAccountTradingCurrency__c!=Null){
string str = cmp.Name +' has incorrect currency ;';
validateResultList.add(str);
}FF-947 - End */
                
                //FF-947 - End
                
                //Component record has attached ‘Payment Terms’ (not blank). 
                if(cmp.MPT_JOIN__c==Null){
                    string str = cmp.Name +' doesn’t have attached Payment Terms ;';
                    validateResultList.add(str);
                }
                system.debug('fetchcompPricingListWithCmp '+fetchcompPricingListWithCmp.size());
                if(fetchcompPricingListWithCmp.size()>0){
                    string cmpPricingCategory = fetchcompPricingListWithCmp[0].Category__c;
                    for(Component_Pricing__c cmpPricing:fetchcompPricingListWithCmp){
                        system.debug('cmpPricingCategory '+cmpPricingCategory);
                        if(cmpPricing.Category__c!=cmpPricingCategory){
                            system.debug('cmpPricing.Category__c '+cmpPricing.Category__c);
                            string str = cmpPricing.Component__r.Name +' component Pricing records has different Category ;';
                            system.debug('str '+str);
                            validateResultList.add(str);
                        }
                        system.debug('validateResultList '+validateResultList);
                        //Component with Pricing structure = ‘Not applicable' has component pricing records with Category = ‘Tiered’ or ‘Deated/Tiered’
                        if(cmpPricing.Component__r.ff_Pricing_structure__c=='Not applicable' && (cmpPricing.Category__c=='Tiered' || cmpPricing.Category__c=='Dated/Tiered')){
                            string str = cmpPricing.Component__r.Name +' has incorrect Pricing structure, Not applicable - Tiered Cost: Rule can be Single or Dated ;';
                            validateResultList.add(str);
                        }
                        
                        //Component with Pricing structure = ‘Cost updates' or ‘No Cost Updates' has component pricing records with Category = ‘Dated’ or ‘Single’ 
                        if((cmpPricing.Component__r.ff_Pricing_structure__c=='Cost Updates' || cmpPricing.Component__r.ff_Pricing_structure__c=='No Cost Updates') && (cmpPricing.Category__c=='Dated' || cmpPricing.Category__c=='Single')){
                            string str = cmpPricing.Component__r.Name +' has incorrect Pricing structure  Not applicable - Tiered Updates: Rule can be Tired or Dated/Tired;';
                            validateResultList.add(str);
                        }
                        
                        
                        //Component pricing for Stop overs: solo costs are blank
                        if(cmpPricing.Component__r.Stopover__c!=Null && cmpPricing.solo_rate_total__c==Null){
                            string str = cmpPricing.Name +' solo costs is blank. Check the field solo costse ;';
                            validateResultList.add(str);
                        }
                    }
                }    
            }
        }
        
        list<account> merchantList = [SELECT Id,Name,RecordType.Name,Merchant_Type__c,c2g__CODAAccountTradingCurrency__c,c2g__CODABankAccountName__c,c2g__CODABankAccountNumber__c,c2g__CODABankSortCode__c,
                                      FINANCE_EMAIL__c,c2g__CODAPaymentMethod__c,c2g__CODATaxCalculationMethod__c,c2g__CODAAccountsPayableControl__c FROM account WHERE Id IN:accsIdSet];
        
        if(!merchantList.isEmpty()){
            for(account acc:merchantList){
                if(acc.RecordType.Name!='Product Partner'){
                    string str = acc.Name +' is not a Product Partner. Check merchant account ;';
                    validateResultList.add(str);
                }
                if(acc.Merchant_Type__c==Null){
                    string str = acc.Name +' Merchant Type is blank. Check the field Merchant Type ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODABankAccountName__c==Null){
                    string str = acc.Name +' Bank Account Name is blank. Check the field Bank Account Name ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODABankAccountNumber__c==Null){
                    string str = acc.Name +' Bank Account Number is blank. Check the field Bank Account Number ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODABankSortCode__c==Null){
                    string str = acc.Name +' Bank Sort Code is blank. Check the field Bank Sort Code ;';
                    validateResultList.add(str);
                }
                if(acc.FINANCE_EMAIL__c==Null){
                    string str = acc.Name +' No email for remittance. Check the field FINANCE EMAIL ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODAPaymentMethod__c==Null){
                    string str = acc.Name +' Payment method is blank. Check the field Payment method ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODATaxCalculationMethod__c==Null){
                    string str = acc.Name +' Tax Calculation Method is blank. Check the field Tax Calculation Method ;';
                    validateResultList.add(str);
                }
                if(acc.c2g__CODAAccountsPayableControl__c==Null){
                    string str = acc.Name +' Accounts Payable Control is blank. Check the field Accounts Payable Control ;';
                    validateResultList.add(str);
                }
            }
        }
        
        //Merchant payment terms don’t sum up to 100% (MPT_JOIN.Total Amount% <> 100)
        list<MPT_JOIN__c> listMPT = [SELECT Id,Name,Total_Amount__c FROM MPT_JOIN__c WHERE Component__r.LinkedDeal_D_O_S__c =:recordId];
        for(MPT_JOIN__c mpt:listMPT){
            if(mpt.Total_Amount__c<100){
                string str = mpt.Name +' is incorrect ;';
                validateResultList.add(str);
            }
        }
        
        //deal validation
        deal__c fetchDeal = [SELECT Id,Accounting_Treatment_AU__c,Allocation_by__c,Validation_Result__c,GST_AU__c,GST_NZ__c,Estimated_Weighted_Margin__c,Estimated_Weighted_Margin_NZ__c,Country_NZ__c,merchant_sharing_deadline__c,merchant_sharing_deadline_date__c FROM Deal__c WHERE Id =:recordId LIMIT 1];
        
        //Departure Dates validation
        list<departures_dates__c> fetchDepDateWithDeal = [SELECT Id,name,HSS_amount__c,HSS_Cost__c FROM departures_dates__c where Deal_for_Reporting__c=:recordId and online_status__c='Online'];
        
        for(departures_dates__c depDate:fetchDepDateWithDeal){
            if(depDate.HSS_amount__c>0 && depDate.HSS_Cost__c==0){
                string str = depDate.Name+' has no HSS cost ;';  
                if(!validateResultList.contains(str)){
                    validateResultList.add(str);  
                }				
            }            
        }
        
        //Addons validation
        //Stop overs and Departure cities: If substopover exist then it should be linked to the Departure cities. 
        //If no relationship exists then add a log ‘Substopover.Name doesn’t have any linked departure city. Please add departure cities to the substopover'
        /*
Add validation: All addons should have a component AND the lookup for AE/SB/SOver/Airline 
upgrade/Land Activity should NOT be NULL for component types = ‘AE’, ‘SB, ‘S/Over’, ‘Flight Upgrade’, 'Land Activity’. 
*/
        list<sub_stopover__c> subStopoverList = [SELECT Id,Name,(SELECT Id,Name FROM StopOver_Departure_Cities__r),(select id,name from components__r) FROM sub_stopover__c WHERE deal__c=:recordId];
        if(!subStopoverList.isEmpty()){
            for(sub_stopover__c subStop:subStopoverList){
                list<StopOver_Departure_Cities__c> liststopDepCities = subStop.StopOver_Departure_Cities__r;
                if(liststopDepCities.size()<1){
                    string str = subStop.Name+' doesnot have any linked departure city. Please add departure cities to the substopover ;';
                    if(!validateResultList.contains(str)){
                        validateResultList.add(str);  
                    }
                }
                if(subStop.components__r.size()<1){
                    string str = subStop.Name+' Has no component Record attached ;';
                    if(!validateResultList.contains(str)){
                        validateResultList.add(str);  
                    }
                }
            }
            
        }
        
        //Land activity doesn't have solo or twin price then add a log: ‘Addon.name Solo or Twin price is missing’ (Refer component type -Land Activity)
        list<land_activity__c> landactivity = [Select Id,Name,price__c,solo_price__c,itinerary_activity__c,site__c,price_nz__c,solo_price_nz__c,(select id,name from components__r) FROM land_activity__c WHERE Deal__c =:recordId];
        
        if(!landactivity.isEmpty()){
            for(land_activity__c la:landactivity){
                if((la.price__c==Null && la.solo_price__c==Null) && la.site__c.contains('AU')){//FF-943 & FF-955
                    string str = la.Name+' Solo or Twin price is missing ;';
                    validateResultList.add(str);
                }
                if(la.components__r.size()<1){
                    string str = la.Name+' Has no component Record attached ;';
                    if(!validateResultList.contains(str)){
                        validateResultList.add(str);  
                    }
                    
                }
                if(la.itinerary_activity__c==null){
                    string str = la.Name+' Does not have attched Itinerary Activity ;';
                    validateResultList.add(str);
                }
                
                //FF-943 - Start
                //If the deal is is also for ‘NZ’ site: then validation for NZ should run on the fields ‘Twin Price - NZD’ and ‘Twin Price - NZD’ for Land Activity object.
                if(la.site__c.contains('NZ') && (la.price_nz__c == Null && la.solo_price_nz__c == Null)){//FF-955
                    string str = la.Name+' Solo or Twin price is missing ;';
                    validateResultList.add(str);
                }
                //FF-943 - End
            }
        }
        
        list<Airline_Upgrade__c> Airline_Upgrade = [Select Id,Name,(select id,name from components__r) FROM Airline_Upgrade__c WHERE Deal__c =:recordId];
        if(!Airline_Upgrade.isEmpty()){
            for(Airline_Upgrade__c au:Airline_Upgrade){
                if(au.components__r.size()<1){
                    string str = au.Name+' Has no component Record attached ;'; 
                    validateResultList.add(str);
                }
            }
        }
        
        list<AE_SB__c> AeSb = [Select Id,Name,Blockout__c,(select id,name from components__r) FROM AE_SB__c WHERE linked_deal__c =:recordId];
        if(!AeSb.isEmpty()){
            for(AE_SB__c ae:AeSb){
                if(ae.components__r.size()<1){
                    string str = ae.Name+' Has no component Record attached ;'; 
                    validateResultList.add(str);
                }
                
                //FF-945 - Start
                /*
Check the field 'Blockout':
if the format of the field ‘Blockout' is not like this: "01/10/2018-01/12/2018" then display the text message: Enter the Blockout dates per below format '01/10/2018-01/12/2018’.
*/
                if(ae.Blockout__c != Null){
                    String []  dates = ae.Blockout__c.split('\n'); 
                    for(String line : dates){
                        
                        Matcher m = Pattern.compile('[0-9]{2}+/[0-9]{2}+/[0-9]{4}+-{1}+[0-9]{2}+/[0-9]{2}+/[0-9]{2}+').matcher(line);
                        if(!m.find()){
                            string str = ae.name+' Enter the Blockout dates per below format 01/10/2018-01/12/2018 ;'; 
                            if(!validateResultList.contains(str)){
                                validateResultList.add(str); 
                            }
                        }
                    }
                }
                //FF-945 - End   
            }
        }
        if(fetchDeal.Accounting_Treatment_AU__c==Null){
            string str = ' Accounting treatment is blank ;';
            validateResultList.add(str);
        }
        if(fetchDeal.GST_AU__c==Null){
            string str = ' GST AU: TAD Orders is blank ;';
            validateResultList.add(str);
        }
        if(fetchDeal.GST_NZ__c==Null){
            string str = ' GST NZ: TNZ Orders is blank ;';
            validateResultList.add(str);
        }
        if(fetchDeal.Estimated_Weighted_Margin__c==Null){
            string str = ' Estimated Weighted Margin is blank ;';
            validateResultList.add(str);
        }
        if(fetchDeal.Estimated_Weighted_Margin_NZ__c==Null && fetchDeal.Country_NZ__c!=Null){
            string str = ' Estimated Weighted Margin - NZ is blank ;';
            validateResultList.add(str);
        }
        
        /* PBP-181 Start */
        List<subOptData> subOptWrapList = new List <subOptData>(); //PSAG-242 End
        list<sub_options__c> subOptionWithDeal = [SELECT Id,name,Deal__r.Allocation_by__c,(Select id from General_Pricings__r limit 1) FROM sub_options__c WHERE Deal__c =:recordId];
        if(!subOptionWithDeal.isEmpty()){
            for(sub_options__c sb:subOptionWithDeal){
                String str;
                if(sb.General_Pricings__r.size()==0){
                    
                    //PSAG-242 start
                    subOptData subOptWrap = new subOptData();
                    subOptWrap.url = System.Url.getOrgDomainUrl().toExternalForm()+'/'+sb.id;
                    subOptWrap.name = sb.name;
                    subOptWrapList.add(subOptWrap);
                    //PSAG-242 End
                    
                    str=sb.name + ' - NO General Pricing Record'; 
                    if(!validateResultList.contains(str)){
                        validateResultList.add(str);  
                    }
                }
            }
        }
        
        /*
//FF - 935 Start
//‘Allocated by’ is not blank.  If blank, then display an error message: Enter the value in the field ‘Allocated by’.
if(fetchDeal.Allocation_by__c == Null){
string str = ' Enter the value in the field ‘Allocated by ;';
validateResultList.add(str);
}


list<options__c> optionWithDeal = [SELECT Id,name,Deal__r.Allocation_by__c,(Select id from sub_options__r),(Select id from Components__r) FROM options__c WHERE Deal__c =:recordId];
if(!optionWithDeal.isEmpty()){
for(options__c opt:optionWithDeal){
//if 1 option has 2+ suboption records then allocated by = ‘Suboption’. If not then display an error message: Wrong value in the field ‘Allocated by’.   
if(opt.Deal__r.Allocation_by__c != Null){
if(opt.Deal__r.Allocation_by__c == 'Sub option' && opt.sub_options__r.size()<2){
string str = ' Wrong value in the field ‘Allocated by’ ';

if(!validateResultList.contains(str)){
validateResultList.add(str);  
}
}
//1 option has 0 suboptions (before was 0/1) -> then allocated by has values = 'deal' or 'option'. If not then display an error message: Wrong value in the field ‘Allocated by’.     
if((opt.Deal__r.Allocation_by__c == 'deal' || opt.Deal__r.Allocation_by__c == 'option') && opt.sub_options__r.size()<1){
string str = ' Wrong value in the field ‘Allocated by’ ';
if(!validateResultList.contains(str)){
validateResultList.add(str);  
}
}
//Any combination where there are more option records than suboption records. For example, 2 options and 1 suboption. 
//If true then display a message: incorrect number of records: more options than suboptions.       

}

//If 'Allocated by' =  'Option' then each option has a component, otherwise, display an error message: Allocated by Option and [Option name] is not covered by any component.
if(opt.Components__r.size()<1 && opt.Deal__r.Allocation_by__c == 'option'){
string str = ' Allocated by Option and '+opt.Name+' is not covered by any component ';
validateResultList.add(str);
}


}
}
//If 'Allocated by' =  'Suboption' then each Suboption has a component, otherwise, display an error message: Allocated by SubOption and [SubOption name] is not covered by any component.
list<sub_options__c> subOptionWithDeal = [SELECT Id,name,Deal__r.Allocation_by__c,(Select id from Components__r) FROM sub_options__c WHERE Deal__c =:recordId AND Deal__r.Allocation_by__c = 'Sub option'];
if(!subOptionWithDeal.isEmpty()){
for(sub_options__c subOpt:subOptionWithDeal){
if(subOpt.Components__r.size()<0 && subOpt.Deal__r.Allocation_by__c == 'Sub option'){
string str = ' Allocated by SubOption '+subOpt.Name+' is not covered by any component ';
validateResultList.add(str);
}
}
}

//FF - 935 End*/
        //FF - 942 Start
        //if ‘Merchant Sharing Deadline Day’ or ‘Merchant Sharing Deadline Date’ is blank then display text -> "Populate Merchant Sharing Deadline Day".
        if(fetchDeal.merchant_sharing_deadline__c == Null && fetchDeal.merchant_sharing_deadline_date__c ==  Null){
            
            string str = ' Populate Merchant Sharing Deadline Day ;';
            validateResultList.add(str);
        }
        /*
If both fields are populated ‘Merchant Sharing Deadline Day’ AND ‘Merchant Sharing Deadline Date’ then display text  
-> "Only one field is required to be populated: ‘Merchant Sharing Deadline Day’ OR ‘Merchant Sharing Deadline Date’". 
*/
        
        //FF - 958
        /*
if ‘Merchant Sharing Deadline - Days’ or ‘Merchant Sharing Deadline - Date’ is blank and then display text -> 
"Populate Merchant Sharing Deadline". (Do not include this Validation for the Deals with the following condition: 
if it’s the “Escape/Stay Deal” that having “Send Merchant Confirmation email” ticked). 
*/
        if(fetchDeal.merchant_sharing_deadline__c != Null && fetchDeal.merchant_sharing_deadline_date__c !=  Null && (fetchDeal.deal_type__c != 'Stay' || fetchDeal.deal_type_nz__c != 'Stay') && fetchDeal.Send_Merchant_Confirmation_email__c != true){
            
            string str = ' Only one field is required to be populated: ‘Merchant Sharing Deadline Day’ OR ‘Merchant Sharing Deadline Date ;';
            validateResultList.add(str);
        }
        
        /*
If there is more than one Departure Date on the deal and ‘Merchant Sharing Deadline Date’ populated or  
‘Merchant Sharing Deadline Day’ or ‘Merchant Sharing Deadline Date’ is blank then display the text “There are more than one Departure Date. 
The field ‘Merchant Sharing Deadline Day' is required to be populated and is the field ‘Merchant Sharing Deadline Date’ needs to be blank"
*/
        if(fetchDepDateWithDeal.size()>1 && ((fetchDeal.merchant_sharing_deadline__c == Null && fetchDeal.merchant_sharing_deadline_date__c ==  Null) || fetchDeal.merchant_sharing_deadline_date__c !=  Null)){
            string str = ' There are more than one Departure Date. The field Merchant Sharing Deadline Day is required to be populated and is the field ‘Merchant Sharing Deadline Date needs to be blank ;';
            validateResultList.add(str);
        }
        
        //FF - 942 End
        string str = String.join(validateResultList, '\n');
        system.debug('str '+str);	
        
        if(!validateResultList.isEmpty()){
            if(fetchDeal.Validation_Result__c!=Null){
                fetchDeal.Validation_Result__c = /*fetchDeal.Validation_Result__c+'\n'+*/String.join(validateResultList, '\n');
                fetchDeal.Deal_Validation_Initiated__c = true;
                
            }else{
                fetchDeal.Validation_Result__c = 'All Validation Done Successfully'; 
                fetchDeal.Deal_Validation_Initiated__c = true;
            }
        }else{
            fetchDeal.Validation_Result__c = 'All Validation Done Successfully'; 
            fetchDeal.Deal_Validation_Initiated__c = true;
        }
        
        system.debug('fetchDeal '+fetchDeal);
        update fetchDeal;
        
        return subOptWrapList; //PSAG-242 
    }
   
    /*
public static void DealvalidationForComponentInsert(List<Component__c> listOfCmt){
system.debug('listOfCmt '+listOfCmt);
set<Id> dealIdsSet = new set<Id>();
set<Id> optIdsSet = new set<Id>();
set<Id> subOptIdsSet = new set<Id>();

Map<string,List<string>> validateResultMap = new Map<string,List<string>>();
List<string> validateResultList = new List<string>();

for(Component__c cmp:listOfCmt){
if(cmp.LinkedDeal_D_O_S__c!=null){
dealIdsSet.add(cmp.LinkedDeal_D_O_S__c);
}
if(cmp.Options__c!=null){
optIdsSet.add(cmp.Options__c);
}
if(cmp.Sub_Options__c!=null){
subOptIdsSet.add(cmp.Sub_Options__c);
}
}
system.debug('subOptIdsSet '+subOptIdsSet);
system.debug('optIdsSet '+optIdsSet);
//deal validation
if(!dealIdsSet.isEmpty() && (!optIdsSet.isEmpty() || !subOptIdsSet.isEmpty())){
List<Component__c> fetchCmpListWithDeal = [SELECT Id,Name,LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.name,Options__c,Options__r.name,Sub_Options__c,Sub_Options__r.name FROM Component__c WHERE Id NOT IN:listOfCmt AND LinkedDeal_D_O_S__c IN:dealIdsSet AND( Options__c IN:optIdsSet OR Sub_Options__c IN:subOptIdsSet)];
system.debug('fetchCmpListWithDeal '+fetchCmpListWithDeal);
if(!fetchCmpListWithDeal.isEmpty()){

for(Component__c cmp:fetchCmpListWithDeal){
system.debug('cmp '+cmp);
if(!dealIdsSet.isEmpty() && !optIdsSet.isEmpty()){
if(cmp.LinkedDeal_D_O_S__c!=Null && cmp.Options__c!=Null){
system.debug('cmp.LinkedDeal_D_O_S__c '+cmp.LinkedDeal_D_O_S__c);
if(validateResultMap.containsKey(cmp.LinkedDeal_D_O_S__c)){
system.debug('cmp.LinkedDeal_D_O_S__c '+validateResultMap.containsKey(cmp.LinkedDeal_D_O_S__c));
validateResultList = validateResultMap.get(cmp.LinkedDeal_D_O_S__c);
validateResultList.add('Component: '+cmp.name);
}else{
validateResultList.add('Component: '+cmp.name);
}
system.debug('validateResultList '+validateResultList);
}
}
if(!dealIdsSet.isEmpty() && !subOptIdsSet.isEmpty()){
if(cmp.LinkedDeal_D_O_S__c!=Null && cmp.Sub_Options__c!=Null){
if(validateResultMap.containsKey(cmp.LinkedDeal_D_O_S__c)){
validateResultList = validateResultMap.get(cmp.LinkedDeal_D_O_S__c);
validateResultList.add('Component: '+cmp.name);
}else{
validateResultList.add('Component: '+cmp.name);
}
}
}
system.debug('validateResultList '+validateResultList);
validateResultMap.put(cmp.LinkedDeal_D_O_S__c,validateResultList);
}

system.debug('validateResultMap '+validateResultMap);
}
}


if(!validateResultMap.isEmpty()){
List<options__c> optList = new List<options__c>();
List<Sub_Options__c> subOptList = new List<Sub_Options__c>();
Map<Id,List<options__c>> optMap = new Map<Id,List<options__c>>();

List<deal__c> fetchDealToUpdate = [SELECT Id,Validation_Result__c FROM deal__C WHERE Id IN:dealIdsSet];

if(!fetchDealToUpdate.isEmpty()){
for(deal__c deal:fetchDealToUpdate){
system.debug('validateResultMap.get(deal.Id) '+validateResultMap.get(deal.Id));
if(deal.Validation_Result__c!=Null){
integer index=0;
for(string str:validateResultMap.get(deal.Id)){
if(deal.Validation_Result__c.contains(str)){
system.debug('value exist '+str);
validateResultMap.get(deal.Id).remove(index);
}
index++;
}
system.debug('validateResultMap.get(deal.Id) '+validateResultMap.get(deal.Id));
deal.Validation_Result__c = deal.Validation_Result__c+'\n'+String.join(validateResultMap.get(deal.Id), '\n');
}else{
deal.Validation_Result__c = String.join(validateResultMap.get(deal.Id), '\n');
}
system.debug('deal.Validation_Result__c '+deal.Validation_Result__c);
}
}
update fetchDealToUpdate;
}
} */
}