import { LightningElement, wire, track, api  } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { getPicklistValues  } from 'lightning/uiObjectInfoApi';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import Marketing_Inventory from '@salesforce/schema/ms_Marketing_Inventory__c';
import Marketing_Spend from '@salesforce/schema/Marketing_Spend__c';
import Country_Name from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Country__c';
import Channel_Source from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Channel__c';
import Supplier_field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Supplier__c';
import Title_field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Title__c';
import Placement from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Placement__c';
import cost_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Cost__c';
import Geo_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Geo__c';
import recurring_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Recurring__c';
import ms_Date__c from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Date__c';
import statusField from '@salesforce/schema/Marketing_Spend__c.ms_Status__c';
import Approval_Status from '@salesforce/schema/Marketing_Spend__c.Approval_Status__c';

export default class TAD_ShowFilterInventoryLWC extends NavigationMixin(LightningElement) {

@wire(CurrentPageReference) pageRef;
@track error;
@track data ;
@track spendInfo;
@track inventoryInfo;
@track OptionsForCountry = [];
@api channelOptions=[];
@api SupplierOptions=[];
@api TitleOptions=[];
@api PlacementOptions=[];
@api GeoOptions=[];
@api RecurringOptions=[];
@api statusOptions=[];
@api approvalStatusOptions=[];

@api iscalender = false;
@api countryValue ='Australia';
@api statusValue ='';
@api approvalValue ='';
@api channelValue='';
@api suppliervalue='';
@api titlevalue='';
@api placementvalue='';
@api Cost = 0.00;
@api geovalue='';
@api recurringvalue='';
@api dateValue = '';
@api startDate;
@api endDate;
@track dropdownList = 'slds-media slds-listbox__option slds-listbox__option_entity slds-listbox__option_has-meta';
@track dropdown = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownSuplier = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownTitle = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownPlacement = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownCost = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownGeo = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownRecurring = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownStatus = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownApproval = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';

@track selectedValue = 'Select Channel';
@track selectedValueSuplier = 'Select Supplier';  
@track selectedValueTitle = 'Select Title';  
@track selectedValuePlacement = 'Select Placement'; 
@track selectedValueGeo = 'Select Geo';   
@track selectedValueStatus = 'Select Status';
@track selectedValueApproval = 'Select Approval Status';
@track selectedValueRecurring = 'Select Recurring';
@track selectedDealtypes = 'Select Deal Type';


connectedCallback(){
    this.countryValue ='Australia';
    }

handleClick(event){
    var wrapobj = {countryValue: this.countryValue, statusValue : this.statusValue, approvalValue: this.approvalValue, channelValue:this.channelValue, suppliervalue: this.suppliervalue, titlevalue : this.titlevalue, placementvalue: this.placementvalue, Cost:this.Cost, geovalue:this.geovalue, statusValue: this.statusValue, approvalValue:this.approvalValue };
        const selectedEvent2 = new CustomEvent('filter', {
        detail: wrapobj 
    });
    //dispatching the custom event
    this.dispatchEvent(selectedEvent2);
}
   @wire(getObjectInfos, { objectApiNames: [ Marketing_Inventory, Marketing_Spend ] })
    propertyOrFunction({data, error}){
        if(data){
          
            this.spendInfo = data.results[1].result.defaultRecordTypeId;
            this.inventoryInfo = data.results[0].result.defaultRecordTypeId;
          
        }else{
            console.log('error here in sobject '+error);
        }
    };

    
@wire(getPicklistValues , { recordTypeId: '$spendInfo', fieldApiName: statusField})/******For Marketing Spend Object Picklist statusField******************* */
status({data, error}){
     if(data){
       var statusOptions = data.values;
        for (let i = 0; i < statusOptions.length; i++) {
        this.statusOptions = [...this.statusOptions, { value: statusOptions[i].value, label: statusOptions[i].label}];
        }
         this.error = undefined;
        }
        else if (error) {
           
            this.error = error;
            this.statusOptions = undefined;
            }

};

@wire(getPicklistValues , { recordTypeId: '$spendInfo', fieldApiName: Approval_Status})/******For Marketing Spend Object Picklist Approval_Status******************* */
approvalStatus({data, error}){
    if(data){
       var approvalStatusOptions = data.values;
        for (let i = 0; i < approvalStatusOptions.length; i++) {
        this.approvalStatusOptions = [...this.approvalStatusOptions, { value: approvalStatusOptions[i].value, label: approvalStatusOptions[i].label}];
        }
         this.error = undefined;
        }
        else if (error) {
           
            this.error = error;
            console.log('this.error '+JSON.stringify(this.error));
            this.approvalStatusOptions = undefined;
            }

};

@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Country_Name})
CountryValues({data, error}){
if(data){
    if(this.OptionsForCountry == ''){
        this.dataListForCountry = data.values;
        console.log('dataListForCountry==>' + JSON.stringify(this.dataListForCountry));
        for (let i = 0; i < this.dataListForCountry.length; i++) {
            
                this.OptionsForCountry = [...this.OptionsForCountry, { value: this.dataListForCountry[i].value, label: this.dataListForCountry[i].label, isChecked:false}];
            

        }
            console.log('OptionsForCountry==>' + JSON.stringify(this.OptionsForCountry));
            }
 this.error = undefined;
}
else if (error) {
this.error = error;
this.OptionsForCountry = undefined;
}
};

@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Channel_Source})
channelSourceValues({data, error}){
if(data){
    if(this.channelOptions == ''){
        var dataList = data.values;
        console.log('datalist1==>' + JSON.stringify(dataList));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < dataList.length; i++) {
        this.channelOptions = [...this.channelOptions, { value: dataList[i].value, label: dataList[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('channelOptions==>' + JSON.stringify(this.channelOptions));
    }
    // this.error = undefined;
}
else if (error) {
    this.error = error;
    this.channelOptions = undefined;
}
};

@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Supplier_field})
supplierValues({data, error}){
if(data){
    if(this.SupplierOptions == ''){
        var dataListSuplier = data.values;
        console.log('dataListSuplier==>' + JSON.stringify(dataListSuplier));
       
        for (let i = 0; i < dataListSuplier.length; i++) {
        this.SupplierOptions = [...this.SupplierOptions, { value:dataListSuplier[i].value, label: dataListSuplier[i].label,isChecked:false,class:this.dropdownList }];
        }       this.error = undefined;
    }
}
else if (error) {
this.error = error;
this.SupplierOptions = undefined;
}
};
@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Title_field})
titleValues({data, error}){
if(data){
    
   if(this.TitleOptions == ''){
       console.log('here in 2');
  
        var dataListTitle = data.values;
        console.log('dataListTitle==>' + JSON.stringify(dataListTitle));

        for (let i = 0; i < dataListTitle.length; i++) {
        this.TitleOptions = [...this.TitleOptions, { value: dataListTitle[i].value, label: dataListTitle[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('TitleOptions==>' + JSON.stringify(this.TitleOptions));
        this.error = undefined;
}
}
else if (error) {
this.error = error;
this.TitleOptions = undefined;
}
};
@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Placement})
placementValues({data, error}){
if(data){
    if(this.PlacementOptions  == ''){
    var dataListPlacement = data.values;
    console.log('dataListPlacement==>' + JSON.stringify(dataListPlacement));
    
    for (let i = 0; i < dataListPlacement.length; i++) {
    this.PlacementOptions = [...this.PlacementOptions, { value:dataListPlacement[i].value, label: dataListPlacement[i].label,isChecked:false,class:this.dropdownList }];
    }
  
    this.error = undefined;
        }
}
else if (error) {
this.error = error;
this.PlacementOptions = undefined;
}
};

@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: Geo_Field})
geoValues({data, error}){
if(data){
    if(this.GeoOptions == ''){
        var dataListGeo = data.values;
        console.log('dataListGeo==>' + JSON.stringify(dataListGeo));
       
        for (let i = 0; i < dataListGeo.length; i++) {
        this.GeoOptions = [...this.GeoOptions, { value: dataListGeo[i].value, label: dataListGeo[i].label,isChecked:false,class:this.dropdownList }];
        } 
        this.error = undefined;
        }
}
else if (error) {
this.error = error;
this.GeoOptions = undefined;
}
};
@wire(getPicklistValues, { recordTypeId: '$inventoryInfo', fieldApiName: recurring_Field})
recurringValues({data, error}){
if(data){
    if(this.RecurringOptions == ''){
        var dataListRecurring = data.values;
            for (let i = 0; i < dataListRecurring.length; i++) {
                this.RecurringOptions = [...this.RecurringOptions, { value: dataListRecurring[i].value, label: dataListRecurring[i].label,isChecked:false,class:this.dropdownList }];
                }

        this.error = undefined;
    }
}
else if (error) {
        this.error = error;
        this.RecurringOptions = undefined;
}
};

changeHandler(event) {
this.countryValue = event.target.value;

}

handleChangeDate(event) {
this.dateValue = event.target.value;
}
openDropdown(event){
   
    var classIdentifier =  event.currentTarget.className;
    if(classIdentifier.includes('channelId'))
        this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
        else if(classIdentifier.includes('supplierId')) 
            this.dropdownSuplier =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
            else if(classIdentifier.includes('titleId')) 
                this.dropdownTitle =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
                    else if(classIdentifier.includes('PlacementId'))
                        this.dropdownPlacement =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
                        else if(classIdentifier.includes('geoId'))
                            this.dropdownGeo =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
                            else if(classIdentifier.includes('recurringId'))
                                this.dropdownRecurring =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
                                else if(classIdentifier.includes('statusId')){
                                    this.dropdownStatus = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
                                    }else if(classIdentifier.includes('approvalStatus')){
                                        this.dropdownApproval = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';    
                                    }
  
}

closeDropDown(event){
    var closedropdownIdentifier = event.currentTarget.getAttribute('data-id');
       if(closedropdownIdentifier == 'channelBox')
        this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        else if(closedropdownIdentifier == 'supplierBox')
            this.dropdownSuplier =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
           else if(closedropdownIdentifier == 'titleBox')
                this.dropdownTitle =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                else  if(closedropdownIdentifier == 'placmentBox')
                 this.dropdownPlacement =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                 else if(closedropdownIdentifier == 'geoBox')
                    this.dropdownGeo =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                    else  if(closedropdownIdentifier == 'recurringBox')
                        this.dropdownRecurring =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click'; 
                        else if(closedropdownIdentifier == 'statusBox'){
                            this.dropdownStatus = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                        }else{
                            this.dropdownApproval = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                        }
}

/*selectOption(event){

var selectidentifier = event.currentTarget.getAttribute('data-id');
var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
var selectedListData=[];
var count=0;
var selectedOption='';
var selectStringIdentifier = '';
if(selectidentifier == 'channelVar'){
    selectStringIdentifier = 'Channel';
    var allOptions = JSON.parse(JSON.stringify(this.channelOptions));
            for(let i=0;i<allOptions.length;i++){ 
                if(allOptions[i].label===label)
                { 
                    if(isCheck==='true')
                    { 
                    allOptions[i].isChecked = false;
                    allOptions[i].class = this.dropdownList;
                    }
                        else
                        { 
                        allOptions[i].isChecked = true; 
                        allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
                        }
                } 
                if(allOptions[i].isChecked)
                { 
                    selectedListData.push(allOptions[i].label); 
                    count++; 
                }
            }
    }else if(selectidentifier == 'statusVar'){
        selectStringIdentifier = 'Status';
        var allOptions = JSON.parse(JSON.stringify(this.statusOptions));
                for(let i=0;i<allOptions.length;i++){ 
                    if(allOptions[i].label===label)
                    { 
                        if(isCheck==='true')
                        { 
                        allOptions[i].isChecked = false;
                        allOptions[i].class = this.dropdownList;
                        }
                            else
                            { 
                            allOptions[i].isChecked = true; 
                            allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
                            }
                    } 
                    if(allOptions[i].isChecked)
                    { 
                        selectedListData.push(allOptions[i].label); 
                        count++; 
                    }
                }
        }else if(selectidentifier == 'approvalStatusVar'){
            selectStringIdentifier = 'Approval Status';
            var allOptions = JSON.parse(JSON.stringify(this.approvalStatusOptions));
            for(let i=0;i<allOptions.length;i++){ 
                if(allOptions[i].label===label)
                { 
                    if(isCheck==='true')
                    { 
                    allOptions[i].isChecked = false;
                    allOptions[i].class = this.dropdownList;
                    }
                        else
                        { 
                        allOptions[i].isChecked = true; 
                        allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
                        }
                } 
                    if(allOptions[i].isChecked)
                    { 
                        selectedListData.push(allOptions[i].label); 
                        count++; 
                    }

            }
        }
    if(count === 1){
        selectedOption = count+' '+selectStringIdentifier+' Selected';
        }
        else if(count > 1 && selectStringIdentifier == 'Channel'){
            selectedOption = count+' '+selectStringIdentifier+'s'+' Selected';
            }else if(count > 1 && (selectStringIdentifier == 'Status' || selectStringIdentifier == 'Approval Status'))
                selectedOption = count+' '+selectStringIdentifier+'es'+' Selected';
            else if(count === 0){
                selectedOption = 'Select '+selectStringIdentifier;
                selectedListData = "";
            }

    if(selectidentifier == 'channelVar'){
        this.channelValue = selectedListData;
        this.selectedValue = selectedOption;
        this.channelOptions = allOptions;
        }else if(selectidentifier == 'statusVar'){
            this.statusValue = selectedListData;
            this.selectedValueStatus = selectedOption;
            this.statusOptions = allOptions;
        }else if(selectStringIdentifier == 'Approval Status')  {
            this.approvalValue = selectedListData;
            this.selectedValueApproval = selectedOption;
            this.approvalStatusOptions = allOptions;
        }  
    }

removeRecord(event){
console.log(' class '+event.currentTarget.className);
var count = 0;
var selectedListData=[];
var selectedOption;
var selectStringIdentifier = '';
if(event.currentTarget.className.includes('channel')){
    selectStringIdentifier = 'channel';
    var removedOptions = JSON.parse(JSON.stringify(this.channelOptions));
    for(let i=0; i < removedOptions.length; i++){

            if(removedOptions[i].label === event.detail.name){
            removedOptions[i].isChecked = false;
            removedOptions[i].class = this.dropdownList;
            }
            
            if(removedOptions[i].isChecked){
            selectedListData.push(removedOptions[i].label); 
            count++;
            }   
        }
}else if(event.currentTarget.className.includes('status')){
    selectStringIdentifier = 'status'
    var removedOptions = JSON.parse(JSON.stringify(this.statusOptions));
    for(let i=0; i < removedOptions.length; i++){

            if(removedOptions[i].label === event.detail.name){
            removedOptions[i].isChecked = false;
            removedOptions[i].class = this.dropdownList;
            }
            
            if(removedOptions[i].isChecked){
            selectedListData.push(removedOptions[i].label); 
            count++;
            }   
        }
}

if(count === 1){
selectedOption = count+' '+selectStringIdentifier+' Selected';
}
else if(count > 1 && selectStringIdentifier == 'channel'){
selectedOption = count+' '+selectStringIdentifier+'s'+' Selected';
}else if(count > 1 && selectStringIdentifier == 'status')
selectedOption = count+' '+selectStringIdentifier+'es'+' Selected';
else if(count === 0){
selectedOption = 'Select '+selectStringIdentifier;
selectedListData = "";
}
if(event.currentTarget.className.includes('channel')){
    this.channelValue = selectedListData;
    this.selectedValue = selectedOption;
    this.channelOptions = removedOptions;
}else if(event.currentTarget.className.includes('status')){
    this.statusValue = selectedListData;
    this.selectedValueStatus = selectedOption;
    this.statusOptions = removedOptions;
}


}*/

selectOptionChannel(event){

    var isCheck = event.currentTarget.dataset.id;
    var label = event.currentTarget.dataset.name;
    var selectedListData=[];
    
    var selectedOption='';
    var allOptions = JSON.parse(JSON.stringify(this.channelOptions));
    console.log('allOptions '+JSON.stringify(allOptions));
    var count=0;
    
    for(let i=0;i<allOptions.length;i++){ 
    if(allOptions[i].label===label)
    { 
    if(isCheck==='true')
    { 
    allOptions[i].isChecked = false;
    allOptions[i].class = this.dropdownList;
    }
    else
    { 
    allOptions[i].isChecked = true; 
    allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
    }
    } 
    if(allOptions[i].isChecked)
    { 
    selectedListData.push(allOptions[i].label); 
    count++; 
    } 
    
    }
    if(count === 1){
    selectedOption = count+' Channel Selected';
    }
    else if(count>1){
    selectedOption = count+' Channel Selected';
    }
    
    this.channelOptions = allOptions;
    this.selectedValue = selectedOption;
    if(selectedListData)
    this.channelValue = selectedListData;
    
    }
    
    removeRecordChannel(event){
    
    var value = event.detail.name;
    var removedOptions = JSON.parse(JSON.stringify(this.channelOptions));
    var count = 0;
    var selectedListData=[];
    for(let i=0; i < removedOptions.length; i++){
    
    if(removedOptions[i].label === value){
    removedOptions[i].isChecked = false;
    removedOptions[i].class = this.dropdownList;
    }
    
    if(removedOptions[i].isChecked){
    selectedListData.push(removedOptions[i].label); 
    count++;
    }   
    }
    
    var selectedOption;
    if(count === 1){
    selectedOption = count+' Channel Selected';
    }
    else if(count>1){
    selectedOption = count+' Channel Selected';
    }
    else if(count === 0){
    selectedOption = 'Select Channel';
    selectedListData = "";
    }
    
    this.channelValue = selectedListData;
    console.log('removed channelValue' +this.channelValue);
    
    this.selectedValue = selectedOption;
    this.channelOptions = removedOptions;
    
    }


selectOptionStatus(event){

    var isCheck = event.currentTarget.dataset.id;
    var label = event.currentTarget.dataset.name;
    var selectedListData=[];
    
    var selectedOption='';
    var allOptions = JSON.parse(JSON.stringify(this.statusOptions));
    console.log('allOptions '+JSON.stringify(allOptions));
    var count=0;
    
    for(let i=0;i<allOptions.length;i++){ 
    if(allOptions[i].label===label)
    { 
    if(isCheck==='true')
    { 
    allOptions[i].isChecked = false;
    allOptions[i].class = this.dropdownList;
    }
    else
    { 
    allOptions[i].isChecked = true; 
    allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
    }
    } 
    if(allOptions[i].isChecked)
    { 
    selectedListData.push(allOptions[i].label); 
    count++; 
    } 
    
    }
    if(count === 1){
    selectedOption = count+' Status Selected';
    }
    else if(count>1){
    selectedOption = count+' Status Selected';
    }
    
    this.statusOptions = allOptions;
    this.selectedValueStatus = selectedOption;
    if(selectedListData)
    this.statusValue = selectedListData;
    
    }
    
    removeRecordStatus(event){
    
    var value = event.detail.name;
    var removedOptions = JSON.parse(JSON.stringify(this.statusOptions));
    var count = 0;
    var selectedListData=[];
    for(let i=0; i < removedOptions.length; i++){
    
    if(removedOptions[i].label === value){
    removedOptions[i].isChecked = false;
    removedOptions[i].class = this.dropdownList;
    }
    
    if(removedOptions[i].isChecked){
    selectedListData.push(removedOptions[i].label); 
    count++;
    }   
    }
    
    var selectedOption;
    if(count === 1){
    selectedOption = count+' Status Selected';
    }
    else if(count>1){
    selectedOption = count+' Status Selected';
    }
    else if(count === 0){
    selectedOption = 'Select Status';
    selectedListData = "";
    }
    
    this.statusValue = selectedListData;
    console.log('removed StatusValue' +this.statusValue);
    
    this.selectedValueStatus = selectedOption;
    this.statusOptions = removedOptions;
    
    }
    


selectOptionApproval(event){

    var isCheck = event.currentTarget.dataset.id;
    var label = event.currentTarget.dataset.name;
    var selectedListData=[];
    
    var selectedOption='';
    var allOptions = JSON.parse(JSON.stringify(this.approvalStatusOptions));
    console.log('allOptions '+JSON.stringify(allOptions));
    var count=0;
    
    for(let i=0;i<allOptions.length;i++){ 
    if(allOptions[i].label===label)
    { 
    if(isCheck==='true')
    { 
    allOptions[i].isChecked = false;
    allOptions[i].class = this.dropdownList;
    }
    else
    { 
    allOptions[i].isChecked = true; 
    allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
    }
    } 
    if(allOptions[i].isChecked)
    { 
    selectedListData.push(allOptions[i].label); 
    count++; 
    } 
    
    }
    if(count === 1){
    selectedOption = count+' Approval Selected';
    }
    else if(count>1){
    selectedOption = count+' Approval Selected';
    }
    
    this.approvalStatusOptions = allOptions;
    this.selectedValueApproval = selectedOption;
    if(selectedListData)
    this.approvalValue = selectedListData;
    
    }
    
    removeRecordApproval(event){
    
    var value = event.detail.name;
    var removedOptions = JSON.parse(JSON.stringify(this.approvalStatusOptions));
    var count = 0;
    var selectedListData=[];
    for(let i=0; i < removedOptions.length; i++){
    
    if(removedOptions[i].label === value){
    removedOptions[i].isChecked = false;
    removedOptions[i].class = this.dropdownList;
    }
    
    if(removedOptions[i].isChecked){
    selectedListData.push(removedOptions[i].label); 
    count++;
    }   
    }
    
    var selectedOption;
    if(count === 1){
    selectedOption = count+' Approval Selected';
    }
    else if(count>1){
    selectedOption = count+' Approval Selected';
    }
    else if(count === 0){
    selectedOption = 'Select Approval Status';
    selectedListData = "";
    }
    
    this.approvalValue = selectedListData;
    console.log('removed approvalValue' +this.approvalValue);
    
    this.selectedValueApproval = selectedOption;
    this.approvalStatusOptions = removedOptions;
    
    }
    



selectOptionSuplier(event){

var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
var selectedListData=[];

var selectedOption='';
var allOptions = JSON.parse(JSON.stringify(this.SupplierOptions));
console.log('allOptions '+JSON.stringify(allOptions));
var count=0;

for(let i=0;i<allOptions.length;i++){ 
if(allOptions[i].label===label)
{ 
if(isCheck==='true')
{ 
allOptions[i].isChecked = false;
allOptions[i].class = this.dropdownList;
}
else
{ 
allOptions[i].isChecked = true; 
allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
}
} 
if(allOptions[i].isChecked)
{ 
selectedListData.push(allOptions[i].label); 
count++; 
} 

}
if(count === 1){
selectedOption = count+' Supplier Selected';
}
else if(count>1){
selectedOption = count+' Suppliers Selected';
}

this.SupplierOptions = allOptions;
this.selectedValueSuplier = selectedOption;
if(selectedListData)
this.suppliervalue = selectedListData;

}

removeRecordSupplier(event){

var value = event.detail.name;
var removedOptions = JSON.parse(JSON.stringify(this.SupplierOptions));
var count = 0;
var selectedListData=[];
for(let i=0; i < removedOptions.length; i++){

if(removedOptions[i].label === value){
removedOptions[i].isChecked = false;
removedOptions[i].class = this.dropdownList;
}

if(removedOptions[i].isChecked){
selectedListData.push(removedOptions[i].label); 
count++;
}   
}

var selectedOption;
if(count === 1){
selectedOption = count+' Supplier Selected';
}
else if(count>1){
selectedOption = count+' Suppliers Selected';
}
else if(count === 0){
selectedOption = 'Select Supplier';
selectedListData = "";
}

this.suppliervalue = selectedListData;
console.log('removed suppliervalue' +this.suppliervalue);

this.selectedValueSuplier = selectedOption;
this.SupplierOptions = removedOptions;

}

selectOptionTitle(event){

var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
console.log('label '+label +'& ischeck '+isCheck);
var selectedListData=[];

var selectedOption='';
var allOptions = JSON.parse(JSON.stringify(this.TitleOptions));
var count=0;
console.log('allOptions length '+allOptions.length);
for(let i=0;i<allOptions.length;i++){ 
if(allOptions[i].label===label)
{ 
    console.log('allOptions[i].label '+JSON.stringify(allOptions[i].label));
    if(isCheck==='true')
    { 
    allOptions[i].isChecked = false;
    allOptions[i].class = this.dropdownList;
    }
    else
    { 
    allOptions[i].isChecked = true; 
    allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
    }
    
}
if(allOptions[i].isChecked)
{ 
    console.log('here in this checked ');
selectedListData.push(allOptions[i].label); 
count++; 
} 


}
if(count === 1){
selectedOption = count+' Title Selected';
}
else if(count>1){
selectedOption = count+' Titles Selected';
}
console.log('allOptions after '+allOptions);
this.TitleOptions = allOptions;
this.selectedValueTitle = selectedOption;
if(selectedListData){
this.titlevalue = selectedListData;
}


}

removeRecordtitle(event){

var value = event.detail.name;
var removedOptions = JSON.parse(JSON.stringify(this.TitleOptions));
var count = 0;
var selectedListData=[];
for(let i=0; i < removedOptions.length; i++){

if(removedOptions[i].label === value){
removedOptions[i].isChecked = false;
removedOptions[i].class = this.dropdownList;
}

if(removedOptions[i].isChecked){
selectedListData.push(removedOptions[i].label); 
count++;
}   
}

var selectedOption;
if(count === 1){
selectedOption = count+' Title Selected';
}
else if(count>1){
selectedOption = count+' Title Selected';
}
else if(count === 0){
selectedOption = 'Select Titles';
selectedListData = "";
}

this.titlevalue = selectedListData;
console.log(' titlevalue '+this.titlevalue);

this.selectedValueTitle = selectedOption;
this.TitleOptions = removedOptions;

}
selectOptionPlacement(event){

var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
var selectedListData=[];

var selectedOption='';
var allOptions = JSON.parse(JSON.stringify(this.PlacementOptions));
var count=0;

for(let i=0;i<allOptions.length;i++){ 
if(allOptions[i].label===label)
{ 
if(isCheck==='true')
{ 
allOptions[i].isChecked = false;
allOptions[i].class = this.dropdownList;
}
else
{ 
allOptions[i].isChecked = true; 
allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
}
} 
if(allOptions[i].isChecked)
{ 
selectedListData.push(allOptions[i].label); 
count++; 
} 

}
if(count === 1){
selectedOption = count+' Placement Selected';
}
else if(count>1){
selectedOption = count+' Placements Selected';
}

this.PlacementOptions = allOptions;
this.selectedValuePlacement = selectedOption;
if(selectedListData){
this.placementvalue = selectedListData;
}


}

removeRecordPlacement(event){

var value = event.detail.name;
var removedOptions = JSON.parse(JSON.stringify(this.PlacementOptions));
var count = 0;
var selectedListData=[];
for(let i=0; i < removedOptions.length; i++){

if(removedOptions[i].label === value){
removedOptions[i].isChecked = false;
removedOptions[i].class = this.dropdownList;
}

if(removedOptions[i].isChecked){
selectedListData.push(removedOptions[i].label); 
count++;
}   
}

var selectedOption;
if(count === 1){
selectedOption = count+' Placement Selected';
}
else if(count>1){
selectedOption = count+' Placements Selected';
}
else if(count === 0){
selectedOption = 'Select Placments';
selectedListData = "";
}

this.placementvalue = selectedListData;
console.log(' placementvalue '+this.placementvalue);

this.selectedValuePlacement = selectedOption;
this.PlacementOptions = removedOptions;

}


selectOptionGeo(event){

var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
var selectedListData=[];

var selectedOption='';
var allOptions = JSON.parse(JSON.stringify(this.GeoOptions));
var count=0;

for(let i=0;i<allOptions.length;i++){ 
if(allOptions[i].label===label)
{ 
if(isCheck==='true')
{ 
allOptions[i].isChecked = false;
allOptions[i].class = this.dropdownList;
}
else
{ 
allOptions[i].isChecked = true; 
allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
}
} 
if(allOptions[i].isChecked)
{ 
selectedListData.push(allOptions[i].label); 
count++; 
} 

}
if(count === 1){
selectedOption = count+' Geo Selected';
}
else if(count>1){
selectedOption = count+' Geo Selected';
}

this.GeoOptions = allOptions;
this.selectedValueGeo = selectedOption;
if(selectedListData){
this.geovalue = selectedListData;
}


}

removeRecordGeo(event){

var value = event.detail.name;
var removedOptions = JSON.parse(JSON.stringify(this.GeoOptions));
var count = 0;
var selectedListData=[];
for(let i=0; i < removedOptions.length; i++){

if(removedOptions[i].label === value){
removedOptions[i].isChecked = false;
removedOptions[i].class = this.dropdownList;
}

if(removedOptions[i].isChecked){
selectedListData.push(removedOptions[i].label); 
count++;
}   
}

var selectedOption;
if(count === 1){
selectedOption = count+' Geo Selected';
}
else if(count>1){
selectedOption = count+' Geo Selected';
}
    else if(count === 0){
    selectedOption = 'Select Geo';
    selectedListData = "";
    }
    
        this.geovalue = selectedListData;
        console.log(' geovalue removed '+this.geovalue);

this.selectedValueGeo = selectedOption;
this.GeoOptions = removedOptions;

}
selectOptionRecurring(event){

var isCheck = event.currentTarget.dataset.id;
var label = event.currentTarget.dataset.name;
var selectedListData=[];

var selectedOption='';
var allOptions = JSON.parse(JSON.stringify(this.RecurringOptions));
var count=0;

for(let i=0;i<allOptions.length;i++){ 
if(allOptions[i].label===label)
{ 
    if(isCheck==='true')
    { 
        allOptions[i].isChecked = false;
        allOptions[i].class = this.dropdownList;
        }
    else
    { 
        allOptions[i].isChecked = true; 
        allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
    }
} 
if(allOptions[i].isChecked)
{ 
    selectedListData.push(allOptions[i].label); 
    count++; 
} 

}
if(count === 1){
    selectedOption = count+' Recurring Selected';
}
else if(count>1){
    selectedOption = count+' Recurring Selected';
}

this.RecurringOptions = allOptions;
this.selectedValueRecurring = selectedOption;
if(selectedListData){
    this.recurringvalue = selectedListData;
}


}

removeRecordRecurring(event){

var value = event.detail.name;
var removedOptions = JSON.parse(JSON.stringify(this.RecurringOptions));
var count = 0;
var selectedListData=[];
for(let i=0; i < removedOptions.length; i++){

    if(removedOptions[i].label === value){
    removedOptions[i].isChecked = false;
    removedOptions[i].class = this.dropdownList;
    }

    if(removedOptions[i].isChecked){
    selectedListData.push(removedOptions[i].label); 
    count++;
    }   
}

    var selectedOption;
    if(count === 1){
    selectedOption = count+' Recurring Selected';
    }
        else if(count>1){
        selectedOption = count+'Recurring Selected';
        }
            else if(count === 0){
            selectedOption = 'Select Recurring';
            selectedListData = "";
            }
            
                this.recurringvalue = selectedListData;
            console.log(' recurringvalue  removed '+this.recurringvalue);

this.selectedValueRecurring = selectedOption;
this.RecurringOptions = removedOptions;

}

navigateBackToBookSlot(){
    var compDefinition = {
        componentDef: "c:tAD_marketingActivityBookSlotLWC",
        attributes: {
            startDate: this.startDate,
            endDate: this.endDate,
            countryValue: this.countryValue,
            channelOptions:this.channelOptions,
            SupplierOptions:this.SupplierOptions,
            TitleOptions: this.TitleOptions,
            PlacementOptions: this.PlacementOptions,
            Cost: this.Cost,
            GeoOptions: this.GeoOptions,
            RecurringOptions : this.RecurringOptions,
            dateValue : this.dateValue,
            channelValue: this.channelValue,
            suppliervalue: this.suppliervalue,
            titlevalue : this.titlevalue,
            placementvalue: this.placementvalue,
            geovalue: this.geovalue,
            recurringvalue: this.recurringvalue
        }
    };
    // Base64 encode the compDefinition JS object
    var encodedCompDef = btoa(JSON.stringify(compDefinition));
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: '/one/one.app#' + encodedCompDef
        }
    });
}

handleCostChange(event){
    this.Cost = event.target.value;
}

ClearFilters(event){
    var removechannelOptions = this.channelOptions;
    var removedSupplierOptions = this.SupplierOptions;
    var removeTitleOptions = this.TitleOptions;
    var removedPlacementOptions = this.PlacementOptions;
   
    var removedGeoOptions = this.GeoOptions;
    var removedRecurringOptions = this.RecurringOptions;
    var removedstatusOptions = this.statusOptions;
    var removedapprovalStatusOptions = this.approvalStatusOptions;
    for(let i=0; i < removechannelOptions.length; i++){
           if(removechannelOptions[i].isChecked){
            removechannelOptions[i].isChecked = false;
            removechannelOptions[i].class = this.dropdownList;
       
        }
       
    }
    
    for(let i=0; i < removedSupplierOptions.length; i++){
            if(removedSupplierOptions[i].isChecked){
                removedSupplierOptions[i].isChecked = false;
                removedSupplierOptions[i].class = this.dropdownList;
              
        }
        
    }
    for(let i=0; i < removeTitleOptions.length; i++){
        if(removeTitleOptions[i].isChecked){
            removeTitleOptions[i].isChecked = false;
            removeTitleOptions[i].class = this.dropdownList;
           
    }

    }
    for(let i=0; i < removedPlacementOptions.length; i++){
        if(removedPlacementOptions[i].isChecked){
            removedPlacementOptions[i].isChecked = false;
            removedPlacementOptions[i].class = this.dropdownList;
          
    }

    }
    
    for(let i=0; i < removedGeoOptions.length; i++){
        if(removedGeoOptions[i].isChecked){
            removedGeoOptions[i].isChecked = false;
            removedGeoOptions[i].class = this.dropdownList;
           
    }

    }
    for(let i=0; i < removedstatusOptions.length; i++){
        if(removedstatusOptions[i].isChecked){
            removedstatusOptions[i].isChecked = false;
            removedstatusOptions[i].class = this.dropdownList;
    
     }
    
 }
 for(let i=0; i < removedapprovalStatusOptions.length; i++){
    if(removedapprovalStatusOptions[i].isChecked){
        removedapprovalStatusOptions[i].isChecked = false;
        removedapprovalStatusOptions[i].class = this.dropdownList;

 }

}


    this.selectedValue = 'Select Channels';
    this.selectedValueSuplier = 'Select Suppliers';
    this.selectedValueTitle = 'Select Titles';
    this.selectedValuePlacement = 'Select Placements';
    this.selectedValueGeo = 'Select Geo';
    this.selectedValueStatus = 'Select Status';
    this.selectedValueApproval = 'Select ApprovalStatus';
   

    this.countryValue = 'Australia';
    this.channelValue = '';
    this.suppliervalue = '';
    this.titlevalue = '';
    this.placementvalue = '';
    this.statusValue = '';
    this.approvalValue = '';

    
    this.geovalue = '';
    this.Cost = 0.00;
   
   
    this.channelOptions = removechannelOptions;
    this.SupplierOptions = removedSupplierOptions;
    this.TitleOptions = removeTitleOptions;
    this.PlacementOptions = removedPlacementOptions;
    this.GeoOptions = removedGeoOptions;
    this.statusOptions=removedstatusOptions;
    this.approvalStatusOptions=removedapprovalStatusOptions;

    
   
        const selectedEvent = new CustomEvent('removefilters', {
            detail: 'all cleared' 
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
   
}
navigateToBookMarketingActivity(){
console.log('this.startDate '+this.startDate+'this.endDate '+this.endDate+ ' this.countryValue'+this.countryValue+'-- this.Cost--  '+this.Cost+'--this.dateValue-- '+this.dateValue+'-- this.channelValue--'+this.channelValue+'--this.suppliervalue-- '+this.suppliervalue+' --this.titlevalue--'+this.titlevalue+' -this.placementvalue- '+this.placementvalue+' this.geovalue- '+this.geovalue+' this.recurringvalue- '+this.recurringvalue );
    var compDefinition1 = {
        componentDef: "c:searchInventory",
        attributes: {
            startDate: this.startDate,
            endDate: this.endDate,
            countryValue: this.countryValue,
            channelOptions:this.channelOptions,
            SupplierOptions:this.SupplierOptions,
            TitleOptions: this.TitleOptions,
            PlacementOptions: this.PlacementOptions,
            Cost: this.Cost,
            GeoOptions: this.GeoOptions,
            RecurringOptions : this.RecurringOptions,
            dateValue : this.dateValue,
            channelValue: this.channelValue,
            suppliervalue: this.suppliervalue,
            titlevalue : this.titlevalue,
            placementvalue: this.placementvalue,
            geovalue: this.geovalue,
            recurringvalue: this.recurringvalue
        }
    };
    // Base64 encode the compDefinition JS object
    var encodedCompDef1 = btoa(JSON.stringify(compDefinition1));
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: '/one/one.app#' + encodedCompDef1
        }
    });

}

}