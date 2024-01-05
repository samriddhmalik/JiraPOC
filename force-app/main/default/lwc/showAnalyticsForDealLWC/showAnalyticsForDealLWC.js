import { LightningElement, wire, track, api } from 'lwc';
import getDealList1 from '@salesforce/apex/showAnalyticsButtonController.getDealList';
import gettingSelectedDeals from '@salesforce/apex/showAnalyticsButtonController.getSelectedDealList';
import gettingAllChannels from '@salesforce/apex/showAnalyticsButtonController.getAllChannelList';
import gettingSelectedChannels from '@salesforce/apex/showAnalyticsButtonController.getSelectedChannelList';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Marketing_Inventory from '@salesforce/schema/ms_Marketing_Inventory__c';
import Channel_Source from '@salesforce/schema/ms_Marketing_Inventory__c.ms_Channel__c';

const COLS = [
    { label: 'Deal Id', fieldName: 'dealName', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Deal Title', fieldName: 'dealIdTitle', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Users', fieldName: 'googleApi_users', type: 'number' , cellAttributes: { alignment: 'left' }},
    { label: 'Time on Site', fieldName: 'googleApi_timeOnSite', type: 'text' , cellAttributes: { alignment: 'left' } },
    { label: 'Age', fieldName: 'googleApi_age', type: 'number' , cellAttributes: { alignment: 'left' }},
    { label: 'Geo', fieldName: 'googleApi_geo', type: 'text', cellAttributes: { alignment: 'left' } },
    { label: 'Traffic Source', fieldName: 'googleApi_traffic_Source', type: 'text', cellAttributes: { alignment: 'left' } },
    { label: 'Online Sales', fieldName: 'googleApi_onlineSales', type: 'number' , cellAttributes: { alignment: 'left' }}
];

const COLS1 = [
    { label: 'Channel', fieldName: 'channelName', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Supplier', fieldName: 'supplierName', type: 'text' , cellAttributes: { alignment: 'left' } },
    { label: 'Title', fieldName: 'titleName', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Time on Site', fieldName: 'timeOnSite', type: 'text', cellAttributes: { alignment: 'left' } },
    { label: 'Age', fieldName: 'ageInNumber', type: 'number' , cellAttributes: { alignment: 'left' }},
    { label: 'Geo', fieldName: 'geoName', type: 'text' , cellAttributes: { alignment: 'left' }},
    { label: 'Users', fieldName: 'noOfUsers', type: 'number', cellAttributes: { alignment: 'left' } }
];

export default class ShowAnalyticsForDealLWC extends LightningElement {

    cols = COLS;
    colsChannels = COLS1;

    @track isRendered;
    @track dealEnable = true;
    @track channelEnable = false;
    @track headerName = 'DEAL ANALYTICS';
    @api typeOfanalytics = '';
    @track dealName;
    @track dealId;
    @track dealSpinner = false;
    @track dealList = [];
    staticDealList = [];
    @track hidDealDetails = true;

    @track channelList = [];
    staticChannelList = [];
    @track hidChannelDetails = false;


    @track channelValue='';
    @api timeDuration= 'Day';

    @track dealNametracker = '';

    selectedDeal;

    connectedCallback() {
        this.dealSpinner = true;
        
    }

    renderedCallback() {
        console.log(this.isRendered);
        
    
        let style = document.createElement('style');
        style.innerText = '.slds-th__action{background-color: #01bfd7; color: white;}';
       
        
        
        
        this.template.querySelector('lightning-datatable').appendChild(style);
        let style1 = document.createElement('style');
        style1.innerText = '.slds-th__action:hover{background-color: #01bfd7; color: white;}';
        this.template.querySelector('lightning-datatable').appendChild(style1);
    }

    @wire(getDealList1, {timeDuration : 'Day'}) 
    fetchDealList(result) {
        if (result.data) {
            this.dealList = result.data;
            this.staticDealList = result.data;
            this.error = undefined;
            this.dealSpinner = false;
        } else if (result.error) {

            this.error = result.error;
            this.staticDealList = [];
            this.dealList = [];
            this.dealSpinner = false;
            console.log('this.error '+this.error);
        }
        console.log('result.data'+JSON.stringify(result.data));
        console.log('this.dealSpinner'+this.dealSpinner);
    }

    dealNameTrackerValue(event){
        this.dealNametracker = event.target.value;
    }

    durationChange(event){
        console.log('event:::'+event.target.value);
        this.timeDuration = event.target.value;
        
        console.log('this.dealNametracker --- >  '+this.dealNametracker);
        let dealNamesToFetch = this.dealNametracker;

        let ifDealOrChannel = this.template.querySelectorAll(".slds-select");
        if(ifDealOrChannel[0].value === 'Channel'){
            if(this.channelValue == ''){
                this.callAllTheChannels();
            }else{
                this.gettingSelectedChannelsOnly();
            }
        }else{
            this.callToFetchSelectedData();
        }

    }

    gettingSelectedChannelsOnly(){
        gettingSelectedChannels({timeDuration : this.timeDuration, selectedChannels : this.channelValue})
        .then((result) =>{
            if (result.length===0) {  
                this.channelList = [];  
                this.message = "No Records Found";  
               } else {  
                this.channelList = result;    
                this.message = "";  
               }  
               this.error = undefined;
        })
    }
    


    changeDealChannelHandler(event){
        console.log('event:::'+event.target.value);
        if(event.target.value === 'Deal'){
            this.dealEnable = true;
            this.channelEnable = false;
            this.hidChannelDetails = false;
            this.hidDealDetails = true;
            this.headerName = 'DEAL ANALYTICS';
            this.channelValue = '';
            this.callToFetchSelectedData();
        }else if(event.target.value === 'Channel'){
            console.log('entering here now;')
            this.channelEnable = true;
            this.dealEnable = false;
            this.hidDealDetails = false;
            this.hidChannelDetails = true;
            this.headerName = 'CHANNEL ANALYTICS';
            this.dealNametracker = '';
            let timeDurationToBeSet = this.template.querySelectorAll(".slds-select");
            this.timeDuration = timeDurationToBeSet[1].value;
            this.callAllTheChannels();
        }
    }

    callAllTheChannels(){
        console.log('this.timeDuration --- '+this.timeDuration);
        gettingAllChannels({timeDuration : this.timeDuration})
        .then((result) =>{
            this.dealSpinner = false;
            if (result.length===0) {  
                this.channelList = [];  
                this.message = "No Records Found";  
               } else {     
                this.channelList = result;  
                this.staticChannelList = result;  
                this.message = "";  
               }  
               this.error = undefined;
        })
    }

    callToFetchSelectedData(){
        gettingSelectedDeals({dealNames : this.dealNametracker, timeDuration : this.timeDuration})
        .then((result) =>{
            if (result.length===0) {  
                this.dealList = [];  
                this.message = "No Records Found";  
               } else {  
                this.dealList = result;  
                this.message = "";  
               }  
               this.error = undefined;
        })
        .catch((error) => {  
            this.error = error;  
            this.recordsList = undefined;  
           }); 
    }

@track dropdown = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
@track selectedValue = 'Select Channel';
@track channelOptions=[];

closeDropDown(){
       this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }

openDropdown(){
        this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';  
    }

@wire(getObjectInfo, { objectApiName: Marketing_Inventory })
    objectInfo;

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
                        selectedOption = '';
                        selectedListData = "";
                        }
            this.channelValue = selectedListData;
            this.selectedValue = selectedOption;
            this.channelOptions = removedOptions;

            console.log('this.channelValue'+this.channelValue);
            if(this.channelValue == ''){
                this.callAllTheChannels();
            }else{
                this.gettingSelectedChannelsOnly();
            }
        
            }

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
            this.error = undefined;
         }
         else if (error) {
               this.error = error;
               this.channelOptions = undefined;
             }
    };

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
            this.channelValue = selectedListData;

            console.log('this.selectedValue'+this.channelValue);
            
            if(this.channelValue == ''){
                this.callAllTheChannels();
            }else{
                console.log('Calling the channels for all selected ones...');
                this.gettingSelectedChannelsOnly();
            }
        }
}