import { LightningElement, wire, track, api } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

import {refreshApex} from '@salesforce/apex';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Marketing_Inventory from '@salesforce/schema/ms_Marketing_Inventory__c';
import Country_Name from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Country__c';
import Channel_Source from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Channel__c';
import Supplier_field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Supplier__c';
import Title_field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Title__c';
import Placement from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Placement__c';
import cost_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Cost__c';
import Geo_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Geo__c';
import recurring_Field from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Recurring__c';
import ms_Date__c from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Date__c';
import getInventoryList from '@salesforce/apex/TAD_marketingActivitySearchLWC.getInventoryList';
import getInventoryListonLoad from '@salesforce/apex/TAD_marketingActivitySearchLWC.getInventoryListonLoad';
import getEligibleDealOnLoad from '@salesforce/apex/TAD_marketingActivitySearchLWC.getEligibleDealOnLoad';
import getEligibleDeal from '@salesforce/apex/TAD_marketingActivitySearchLWC.getEligibleDeal';

const columns = [{
label: 'Supplier',
fieldName: 'supplier',
type: 'text',
sortable: true
},
{
label: 'Title',
fieldName: 'title',
type: 'text',
sortable: true
},
{
label: 'Placement',
fieldName: 'placements',
type: 'text',
sortable: true
},
{
label: 'Cost',
fieldName: 'Cost',
type: 'text',
sortable: true
},
{
label: 'Budget',
fieldName: 'Budget',
type: 'text',
sortable: true
},
{
label: 'EndDate',
fieldName: 'EndDate',
type: 'Date',
sortable: true
},
{
label: 'StartDate',
fieldName: 'StartDate',
type: 'Date',
sortable: true
},
{
label: 'EndDate',
fieldName: 'EndDate',
type: 'Date',
sortable: true
},
{
label: 'sDate',
fieldName: 'sDate',
type: 'Date',
sortable: true
},
{
label: 'Geo',
fieldName: 'Geo',
type: 'text',
sortable: true
},
{
label: 'Recurring',
fieldName: 'recurring',
type: 'text',
sortable: true
},
{
label: 'Consumed Slot',
fieldName: 'consumedSlot',
type: 'text',
sortable: true
},
{
label: 'Available Slot',
fieldName: 'availableSlot',
type: 'text',
sortable: true
},
{
label: 'Last Booked Deal', fieldName: 'LastBookedDealId', type:'url',
    typeAttributes: {
        label: { 
            fieldName: 'LastBookedDeal' 
        },
        target : '_blank'
    }
}
];

const option = [
    
    { label: 'All', value: 'All Day' },
    { label: 'This Day', value: 'This Day' },
    { label: 'This Week', value: 'This Week' },
    { label: 'This Month', value: 'This Month' }
];
export default class TAD_marketingActivitySearchViewLWC extends NavigationMixin(LightningElement) {
wiredDataResult;
@track showModal = false;
@wire(CurrentPageReference) pageRef;
@track error;
@track data ;
@track dealFilter = 'All Day';
//@track columns = columns;
@track resultsum = [];
@track dealsList = [];
@track OptionsForCountry = [];
@track channelOptions=[];
@track SupplierOptions=[];
@track TitleOptions=[];
@track PlacementOptions=[];
@track CostOptions=[];
@track GeoOptions=[];
@track RecurringOptions=[];
@track DateOptions=[];


@track countryValue='Australia';
@track channelValue='';
@track suppliervalue='';
@track titlevalue='';
@track placementvalue='';
@track Cost = 0.00;
@track geovalue='';
@track recurringvalue='';
@track dateValue;


@track dropdown = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownSuplier = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownTitle = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownPlacement = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownCost = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownGeo = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track dropdownRecurring = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';


@track dataList;
@track dropdownList = 'slds-media slds-listbox__option slds-listbox__option_entity slds-listbox__option_has-meta';
@track selectedValue = 'Select Channel';
// @track selectedListOfValues='';

@track dataListSuplier;
@track selectedValueSuplier = 'Select Supplier';


@track dataListTitle;
@track selectedValueTitle = 'Select Title';


@track dataListPlacement;
@track selectedValuePlacement = 'Select Placement';


@track dataListGeo;
@track selectedValueGeo = 'Select Geo';


@track dataListRecurring;
@track selectedValueRecurring = 'Select Recurring';

@track dealFiltersOption=[];

@track inventoryListafterClear=[];
@track dealListafterClear=[];

dealFiltersOption =  option ;

handleCostChange(event){
    this.Cost = event.target.value;
}

handleClick(event){
    console.log('here in this filter ');
    
    this.resultsum = [];
    if(this.countryValue == undefined){
        this.countryValue = '';
    }else{
        this.countryValue = this.countryValue;
    }
    if(this.channelValue == undefined){
        this.channelValue = '';
    }else{
        this.channelValue = this.channelValue;
    }
    if(this.suppliervalue == undefined){
        this.suppliervalue = '';
    }else{
        this.suppliervalue = this.suppliervalue;
    }
    if(this.titlevalue == undefined){
        this.titlevalue = '';
    }else{
        this.titlevalue = this.titlevalue;
    }
    if(this.placementvalue == undefined){
        this.placementvalue = '';
    }else{
        this.placementvalue = this.placementvalue ;
    }
    if(this.Cost == undefined || this.Cost == '' || this.Cost == null){
        this.Cost = 0.0;
    }else{
        this.Cost = this.template.querySelector("[data-field='costValue']").value;
        console.log('this cost '+this.Cost);
        //this.Cost = this.Cost ;
    }
    if(this.geovalue == undefined){
        this.geovalue = '';
    }else{
        this.geovalue =   this.geovalue ;
    }
    if(this.recurringvalue == undefined){
        this.recurringvalue = '';
    }else{
        this.recurringvalue = this.recurringvalue ;
    }
    if(this.dateValue == undefined){
        this.dateValue = null;
    }else{
        this.dateValue=this.dateValue;
    }
    

    this.callingInventoryList();
   
    //refreshApex(this.resultsum);
    return refreshApex(this.resultsum);
}

closeModal() {
    this.showModal = false;
  }

  showModalPopup(event) {
    this.showModal = true;
    var dealId = event.currentTarget.getAttribute('data-id');
    console.log('dealId'+dealId);
    this.template.querySelector("c-t-a-d_-detail-onhover").callTofetchWrapDetails(dealId);
  }



callingInventoryList(){
    
    console.log('channelValue after  '+this.channelValue+' suppliervalue '+this.suppliervalue+' titlevalue '+this.titlevalue+' placementvalue- '+this.placementvalue+' -Cost -'+this.Cost+' -geovalue- '+this.geovalue+'recurringvalue -- '+this.recurringvalue+' --dateValue -- '+this.dateValue+'- countryValue - '+this.countryValue);
    //console.log('channelValue after'+this.channelValue+' suppliervalue '+this.suppliervalue+' titlevalue '+this.titlevalue+' placementvalue- '+this.placementvalue+' -Cost -'+this.Cost+' -geovalue- '+this.geovalue+'recurringvalue -- '+this.recurringvalue+'dateValue '+this.dateValue);
    getInventoryList({selectedChannels : this.channelValue, selectedTitles : this.titlevalue, selectedsuppliers : this.suppliervalue, selectedPlacement : this.placementvalue, cost : this.Cost, selectedGeo : this.geovalue, selectedDate : this.dateValue, recurringValue : this.recurringvalue, countryValue : this.countryValue})
    .then( (result) => {
        this.wiredDataResult = result;
        if(result){
            var conts = result;
            console.log('conts -- '+JSON.stringify(conts));
            var setofInvIds = [];
            for(var key in conts){
                var dataInv = conts[key];
                dataInv.forEach(function(record){
                    console.log(' record LastBookedDealId 1'+record.LastBookedDealId);
                    //  record.Dealurl = baseUrl+record.LastBookedDealId; 
                    console.log('LastBookedDealId -- '+ record.LastBookedDealId);
                    setofInvIds.push(record.Id);
                    //  record.LastBookedDeal = '/'+record.LastBookedDealId;
                });
                console.log('dataInv '+JSON.stringify(conts[key]));
                this.resultsum.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
            }
        }
        console.log('resultsum ::'+JSON.stringify(this.resultsum));
        this.fetchEligibleDeals(setofInvIds);
        
        
    })
    .catch(error => {
            this.resultsum = undefined;
            console.log('error-- '+JSON.stringify(error));
    });
}

fetchEligibleDeals(setofInvIds){
getEligibleDeal({inventoryIds: setofInvIds, countryValue : this.countryValue, dealFilter: this.dealFilter})
.then( (result) => {
    console.log(' result '+JSON.stringify(result));
    var dataConst = result;
        this.dealsList = dataConst;
        console.log(' this.dealsList '+JSON.stringify(this.dealsList));

})
.catch(error => {
    this.resultsum = undefined;
    console.log('error-- '+JSON.stringify(error));
});

}



@wire(getObjectInfo, { objectApiName: Marketing_Inventory })
objectInfo;

@wire(getInventoryListonLoad)
wiredInventoryList({ error, data }) {
    if (data) {
        var dataConst = data;
        
            console.log('dataConst -- '+dataConst);
            var setofInvIds = [];
            for(var key in dataConst){
                var dataInv = dataConst[key];
                dataInv.forEach(function(record){
                    console.log(' record LastBookedDealId 1'+record.LastBookedDealId);
                    //  record.Dealurl = baseUrl+record.LastBookedDealId; 
                    console.log('LastBookedDealId -- '+ record.LastBookedDealId);
                    setofInvIds.push(record.Id);
                    //  record.LastBookedDeal = '/'+record.LastBookedDealId;
                });
                this.resultsum.push({value:dataConst[key], key:key}); //Here we are creating the array to show on UI.
            }
            console.log('resultsum -- '+this.resultsum);
            this.inventoryListafterClear = this.resultsum;
            this.dofetchdeals(setofInvIds);
    } else if (error) {
        this.error = error;
        this.resultsum = undefined;
    }
}

dofetchdeals(setofInvIds){
    getEligibleDealOnLoad({inventoryIds : setofInvIds})
    .then( (result) => {
        console.log(' result '+JSON.stringify(result));
        var dataConst = result;
            this.dealsList = dataConst;
            this.dealListafterClear = dataConst;
            console.log(' this.dealsList '+JSON.stringify(this.dealsList));

    })
    .catch(error => {
        this.resultsum = undefined;
        console.log('error-- '+JSON.stringify(error));
    });
}



@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Country_Name})
CountryValues({data, error}){
    if(data){
        this.dataListForCountry = data.values;
        console.log('dataListForCountry==>' + JSON.stringify(this.dataListForCountry));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListForCountry.length; i++) {
        this.OptionsForCountry = [...this.OptionsForCountry, { value: this.dataListForCountry[i].value, label: this.dataListForCountry[i].label,isChecked:false}];
        }
        console.log('OptionsForCountry==>' + JSON.stringify(this.OptionsForCountry));
        // this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.OptionsForCountry = undefined;
            }
};


    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Channel_Source})
channelSourceValues({data, error}){
    if(data){
        this.dataList = data.values;
        console.log('datalist1==>' + JSON.stringify(this.dataList));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataList.length; i++) {
        this.channelOptions = [...this.channelOptions, { value: this.dataList[i].value, label: this.dataList[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('channelOptions==>' + JSON.stringify(this.channelOptions));
        // this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.channelOptions = undefined;
            }
};

@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Supplier_field})
supplierValues({data, error}){
    if(data){
        this.dataListSuplier = data.values;
        console.log('dataListSuplier==>' + JSON.stringify(this.dataListSuplier));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListSuplier.length; i++) {
        this.SupplierOptions = [...this.SupplierOptions, { value: this.dataListSuplier[i].value, label: this.dataListSuplier[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('SupplierOptions==>' + JSON.stringify(this.SupplierOptions));
        this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.SupplierOptions = undefined;
            }
};
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Title_field})
titleValues({data, error}){
    if(data){
        this.dataListTitle = data.values;
        console.log('dataListTitle==>' + JSON.stringify(this.dataListTitle));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListTitle.length; i++) {
        this.TitleOptions = [...this.TitleOptions, { value: this.dataListTitle[i].value, label: this.dataListTitle[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('TitleOptions==>' + JSON.stringify(this.TitleOptions));
        this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.TitleOptions = undefined;
            }
};
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Placement})
placementValues({data, error}){
    if(data){
        this.dataListPlacement = data.values;
        console.log('dataListPlacement==>' + JSON.stringify(this.dataListPlacement));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListPlacement.length; i++) {
        this.PlacementOptions = [...this.PlacementOptions, { value: this.dataListPlacement[i].value, label: this.dataListPlacement[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('PlacementOptions==>' + JSON.stringify(this.PlacementOptions));
        this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.PlacementOptions = undefined;
            }
};

@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Geo_Field})
geoValues({data, error}){
    if(data){
        this.dataListGeo = data.values;
        console.log('dataListGeo==>' + JSON.stringify(this.dataListGeo));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListGeo.length; i++) {
        this.GeoOptions = [...this.GeoOptions, { value: this.dataListGeo[i].value, label: this.dataListGeo[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('GeoOptions==>' + JSON.stringify(this.GeoOptions));
        this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.GeoOptions = undefined;
            }
};
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: recurring_Field})
recurringValues({data, error}){
    if(data){
        this.dataListRecurring = data.values;
        console.log('dataListRecurring==>' + JSON.stringify(this.dataListRecurring));
        //console.log('datastring==>' + data.getContactName);
        for (let i = 0; i < this.dataListRecurring.length; i++) {
        this.RecurringOptions = [...this.RecurringOptions, { value: this.dataListRecurring[i].value, label: this.dataListRecurring[i].label,isChecked:false,class:this.dropdownList }];
        }
        console.log('RecurringOptions==>' + JSON.stringify(this.RecurringOptions));
        this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.RecurringOptions = undefined;
            }
};
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ms_Date__c})
DateValues;

changeHandler(event) {
    console.log('here in this log ');
    
    console.log('here in this countryValue '+ event.target.value);
    this.countryValue = event.target.value;
}




handleChangeDate(event) {
    console.log('here in this log ');
    
    console.log('here in this dateValue '+ event.target.value);
    this.dateValue = event.target.value;
}

changeDealChannelHandler(event){
    this.dealFilter = event.target.value;
    console.log(' this.dealFilter '+ this.dealFilter);
    getEligibleDeal({selectedChannels : this.channelValue, selectedTitles : this.titlevalue, selectedsuppliers : this.suppliervalue, selectedPlacement : this.placementvalue, cost : this.Cost, selectedGeo : this.geovalue, selectedDate : this.dateValue, recurringValue : this.recurringvalue, countryValue : this.countryValue, dealFilter: this.dealFilter})
    .then( (result) => {
        var dataConst = result;
            this.dealsList = dataConst;
            console.log(' this.dealsList '+JSON.stringify(this.dealsList));

    })
    .catch(error => {
        this.resultsum = undefined;
        console.log('error-- '+JSON.stringify(error));
    });

}


openDropdown(){
    this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';  
}

closeDropDown(){
    this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}

openDropdownForSuplier(){
    this.dropdownSuplier =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
}

closeDropDownForSupplier(){
    this.dropdownSuplier =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}

openDropdownForTitle(){
    this.dropdownTitle =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
}

closeDropDownForTitle(){
    this.dropdownTitle =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}

openDropdownForPlacement(){
    this.dropdownPlacement =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
}

closeDropDownForPlacement(){
    this.dropdownPlacement =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}


openDropdownForGeo(){
    this.dropdownGeo =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
}

closeDropDownForGeo(){
    this.dropdownGeo =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}
openDropdownForRecurring(){
    this.dropdownRecurring =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open'; 
}

closeDropDownForRecurring(){
    this.dropdownRecurring =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
}
viewDeal(event){
    console.log(' event.target.dataset.id'+ event.target.dataset.id);
        this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId:  event.target.dataset.id,
        objectApiName: 'Deal__c',
        actionName: 'view'
    }
});
}

handleNavigate() {
    
// Base64 encode the compDefinition JS object
//var encodedCompDef = btoa(JSON.stringify(compDefinition));
this[NavigationMixin.Navigate]({
    type: 'standard__navItemPage',
    attributes: {
        apiName: 'Analytics_For_Channel'
    }
});
}


handleNavigateToShowAnalyticsForDeal(){
this[NavigationMixin.Navigate]({
    type: 'standard__navItemPage',
    attributes: {
        //Name of any CustomTab. Visualforce tabs, web tabs, Lightning Pages, and Lightning Component tabs
        apiName: 'Analytics_For_Deal'
    },
});

}

ClearFilters(){

    var removechannelOptions = this.channelOptions;
    var removedSupplierOptions = this.SupplierOptions;
    var removeTitleOptions = this.TitleOptions;
    var removedPlacementOptions = this.PlacementOptions;
   
    var removedGeoOptions = this.GeoOptions;
    var removedRecurringOptions = this.RecurringOptions;
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

    for(let i=0; i < removedRecurringOptions.length; i++){
        if(removedRecurringOptions[i].isChecked){
            removedRecurringOptions[i].isChecked = false;
            removedRecurringOptions[i].class = this.dropdownList;
          
    }

    }
    this.selectedValue = 'Select Channels';
    this.selectedValueSuplier = 'Select Suppliers';
    this.selectedValueTitle = 'Select Titles';
    this.selectedValuePlacement = 'Select Placements';
    this.selectedValueGeo = 'Select Geo';
    this.selectedValueRecurring = 'Select Recurring';

    this.countryValue = 'Australia';
    this.channelValue = '';
    this.suppliervalue = '';
    this.titlevalue = '';
    this.placementvalue = '';
    this.recurringvalue = '';
    this.geovalue = '';
    this.Cost = null;
   
    this.dateValue = null;
    this.channelOptions = removechannelOptions;
    this.SupplierOptions = removedSupplierOptions;
    this.TitleOptions = removeTitleOptions;
    this.PlacementOptions = removedPlacementOptions;
    this.GeoOptions = removedGeoOptions;
    this.RecurringOptions = removedRecurringOptions;
    this.dealFilter = 'All Day';

   
    this.resultsum = this.inventoryListafterClear;
    this.dealsList = this.dealListafterClear;
   

}


selectOption(event){

    var isCheck = event.currentTarget.dataset.id;
    var label = event.currentTarget.dataset.name;
    var selectedListData=[];

    var selectedOption='';
    var allOptions = this.channelOptions;
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
            selectedOption = count+' Channels Selected';
        }
        
        this.channelOptions = allOptions;
        this.selectedValue = selectedOption;
        if(selectedListData)
        this.channelValue = selectedListData;
        
    }

    removeRecord(event){

        var value = event.detail.name;
        var removedOptions = this.channelOptions;
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
                selectedOption = count+' Channels Selected';
                }
                    else if(count === 0){
                    selectedOption = 'Select Channels';
                    selectedListData = "";
                    }
                    
                        this.channelValue = selectedListData;
                    console.log('removed channelValue '+this.channelValue);
        
        this.selectedValue = selectedOption;
        this.channelOptions = removedOptions;
    
        }

        

        selectOptionSuplier(event){

            var isCheck = event.currentTarget.dataset.id;
            var label = event.currentTarget.dataset.name;
            var selectedListData=[];
    
            var selectedOption='';
            var allOptions = this.SupplierOptions;
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
                var removedOptions = this.SupplierOptions;
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
                    var selectedListData=[];
            
                    var selectedOption='';
                    var allOptions = this.TitleOptions;
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
                            selectedOption = count+' Title Selected';
                        }
                        else if(count>1){
                            selectedOption = count+' Titles Selected';
                        }
                        
                        this.TitleOptions = allOptions;
                        this.selectedValueTitle = selectedOption;
                        if(selectedListData){
                            this.titlevalue = selectedListData;
                        }
                        
                        
                    }
            
                    removeRecordtitle(event){
            
                        var value = event.detail.name;
                        var removedOptions = this.TitleOptions;
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
                            var allOptions = this.PlacementOptions;
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
                                var removedOptions = this.PlacementOptions;
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
                                            var allOptions = this.GeoOptions;
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
                                                var removedOptions = this.GeoOptions;
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
                                                    var allOptions = this.RecurringOptions;
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
                                                        var removedOptions = this.RecurringOptions;
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

            


}