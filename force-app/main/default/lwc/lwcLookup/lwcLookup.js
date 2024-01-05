import { LightningElement, api, track, wire } from 'lwc';
import fetchRecords from '@salesforce/apex/ReusableLookupController.fetchRecords';
import getIconName from '@salesforce/apex/ReusableLookupController.getIconName';
import IMAGE_PNG from '@salesforce/resourceUrl/DealInclusion';

/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 50;

export default class LwcLookup extends LightningElement {
@api helpText = "";
@api label = "";
@api required;
// @api selectedIconName = "standard:account";
@track selectedIconName;
@api objectLabel = "";
recordsList = [];
selectedRecordName;
selectedOtherField;
@api disableddata;

@api objectApiName = "Publishing_Inclusions__c";
@api fieldApiName = "Name";
@api otherFieldApiName;
@api loadImage;
@api searchString = "";
@api selectedRecordId = "";
@api fetchparentlistindex = "";	
@api getparticularinclusion = "";
@api getinclusiondetail = "";
@api parentRecordId;
@api parentFieldApiName;
@track blurTimeout;
//@track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
@track inputClass = '';
@api inclusionNotSelected = '';	
@api isInclusionSelected = false;	


selectedContent;

preventClosingOfSerachPanel = false;
delayTimeout;



get methodInput() {
return {
    objectApiName: this.objectApiName,
    fieldApiName: this.fieldApiName,
    otherFieldApiName: this.otherFieldApiName,
    searchString: this.searchString,
    selectedRecordId: this.selectedRecordId,
    parentRecordId: this.parentRecordId,
    parentFieldApiName: this.parentFieldApiName
};
}


@api
changeMessage(RecordName, RecordURL, RecordID) {	
		

}

@api 
removeCombo(){
		window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
    if (!this.preventClosingOfSerachPanel) {
        this.recordsList = [];
    }
    this.preventClosingOfSerachPanel = false;
}, DELAY);
}
	
@api	
displayError(){	
		this.isInclusionSelected = true;	
}

@api	
resetItem(RecordName,RecordURL,RecordID){	
		this.selectedRecordId = RecordID;	
		this.selectedRecordName = RecordName;	
		this.selectedOtherField = RecordURL;	
        this.isInclusionSelected = false;	
}

@api	
resetErrorMessage(RecordName){				
		//alert('NONE-SELECTED');	
		this.isValueSelected = '';	
		this.inclusionNotSelected = RecordName;	
		this.selectedRecordId = '';	
		this.selectedRecordName = RecordName;	
		this.selectedOtherField = '';	
		this.isInclusionSelected = true;				
}	
	

handleClick() {
        this.searchTerm = '';
        //this.inputClass = 'slds-has-focus';
        //this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
}

get showRecentRecords() {
if (!this.recordsList) {
    return false;
}
return this.recordsList.length > 0;
}

//getting the default selected record
connectedCallback() {
getIconName({
    sObjectName: this.objectApiName
}).then(result => {
   this.selectedIconName = result;
   console.log('result ='+JSON.stringify(result));
}).catch(error => {
    console.log(error);
})

this.preventClosingOfSerachPanel = false;	

if (this.selectedRecordId) {
    this.fetchSobjectRecords(true);
}


console.log('PUBLISH INCLUSION SELECTED ='+this.getparticularinclusion);

if(this.getparticularinclusion == undefined){
}
else{    
    this.selectedRecordId = this.getparticularinclusion;
    if(this.getinclusiondetail == undefined){

    }else{
    console.log('getparticularinclusion called'+this.getinclusiondetail);
    var splitStr = this.getinclusiondetail.split(' , ');
    console.log('splitStr ='+splitStr);
    
    this.selectedRecordName = splitStr[0];
    this.selectedOtherField = splitStr[1];
    }

}
}


renderedCallback() {
getIconName({
    sObjectName: this.objectApiName
}).then(result => {
   this.selectedIconName = result;
   console.log('Rendered Callback ='+JSON.stringify(result));
}).catch(error => {
    console.log(error);
})
}

        

//call the apex method
fetchSobjectRecords(loadEvent) {
console.log('MEtHOD INPUT ='+JSON.stringify(this.methodInput));
fetchRecords({
    inputWrapper: this.methodInput
}).then(result => {
    if (loadEvent && result) {
        //this.selectedRecordName = result[0].mainField;
        //this.otherFieldApiName = result[0].subField;
        //this.selectedIconName = result[0].objectIcon;
        console.log('Line 81 called');
        console.log('IMAGE ='+ IMAGE_PNG+'/svgtopng/store.png');
        this.recordsList = [];
        this.recordsList = JSON.parse(JSON.stringify(result));
        
    } else if (result) {
        //this.selectedRecordName = result[0].mainField;
        //this.otherFieldApiName = result[0].subField;
       // this.selectedIconName = result[0].objectIcon;
        this.recordsList = [];
        this.recordsList = JSON.parse(JSON.stringify(result));
          /*this.data = [...result].map(record => {
            record.otherFieldApiName = IMAGE_PNG+'/svgtopng/store.png';
            return record;
        });*/
    } else {
        //this.recordsList = [];
    }
}).catch(error => {
    console.log(error);
})
}



get isValueSelected() {
return this.selectedRecordId;
}

	set isValueSelected(value){	
	this.selectedRecordId = value;	
}

//handler for calling apex when user change the value in lookup
handleChange(event) {
this.searchString = event.target.value;
//this.otherFieldApiName = 'Icon_Label_Image__c';
console.log('isvalueSelcted :'+this.isValueSelected);
console.log('isInclusionSelected :'+this.isInclusionSelected);
//this.isValueSelected = true;
if(this.searchString == ''){
		this.isInclusionSelected = false;

}else{
		this.isInclusionSelected = true;

}

var selectedContent = { 
		searchKey : this.searchString,
    eventFiredFrom : 'handleChange'
};
const selectedEvent = new CustomEvent('optionselected', {
    detail: selectedContent
});
this.dispatchEvent(selectedEvent);
this.fetchSobjectRecords(false);

}

//handler for clicking outside the selection panel
handleBlur() {
this.recordsList = [];
this.preventClosingOfSerachPanel = false;
//this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);

}

//handle the click inside the search panel to prevent it getting closed
handleDivClick() {
this.preventClosingOfSerachPanel = true;
}

//handler for deselection of the selected item
handleCommit() {
	var selectedContent = { 	
    eventFiredFrom : 'handleCommit'	
};	
const selectedEvent = new CustomEvent('optionselected', {	
    detail: selectedContent	
});	
this.dispatchEvent(selectedEvent);	
this.inclusionNotSelected = '';	
this.selectedRecordId = "";
this.selectedRecordName = "";
this.selectedIconName = "";
this.selectedOtherField = "";
this.fetchSobjectRecords(false);
this.isInclusionSelected = false;	

}


//handler for selection of records from lookup result list
handleSelect(event) {
let selectedRecord = {
    mainField: event.currentTarget.dataset.mainfield,
    subField: event.currentTarget.dataset.subfield,
   // objectIcon : event.currentTarget.dataset.objectIcon,
    id: event.currentTarget.dataset.id
};
this.selectedRecordId = selectedRecord.id;
this.selectedRecordName = selectedRecord.mainField;
this.selectedOtherField = selectedRecord.subField;
//this.selectedIconName = selectedRecord.objectIcon;
this.recordsList = [];
this.isInclusionSelected = true;	
this.inclusionNotSelected = '';
// Creates the event
console.log('Name ='+ this.selectedRecordName + ' , '+ 'IconImage ='+this.selectedOtherField);
var selectedContent = { 
    recordSelectedId : this.selectedRecordId,
    Name : this.selectedRecordName, 
    IconImage : this.selectedOtherField,
    eventFiredFrom : 'handleSelect'
};
const selectedEvent = new CustomEvent('optionselected', {
    detail: selectedContent
});
//dispatching the custom event
this.dispatchEvent(selectedEvent);

  if(this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    // this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
}


//to close the search panel when clicked outside of search input
handleInputBlur(event) {
// Debouncing this method: Do not actually invoke the Apex call as long as this function is
// being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
//window.clearTimeout(this.delayTimeout);
// eslint-disable-next-line @lwc/lwc/no-async-operation
window.clearTimeout(this.delayTimeout);
this.delayTimeout = setTimeout(() => {
    if (!this.preventClosingOfSerachPanel) {
        this.recordsList = [];
    }
    this.preventClosingOfSerachPanel = false;
}, DELAY);

        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 100);

}

}