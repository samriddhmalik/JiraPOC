import { LightningElement, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/ReusableLookupController.fetchRecords';
import CloneDealItineraries from '@salesforce/apex/Tad_DealOptimizaitonContorller.CloneDealItineraries';
import getIconName from '@salesforce/apex/ReusableLookupController.getIconName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import LightningConfirm from 'lightning/confirm';

const DELAY = 50;

export default class DealLookupPopUp extends LightningElement {
		@api dealid;
		@track recordsList = [];
		selectedRecordName;

		@track selectedIconName;
		@api objectLabel = "";
		selectedRecordName;
		selectedOtherField;

		@api objectApiName = "deal__c";
		@api fieldApiName = "Name";
		@api otherFieldApiName;
		@api loadImage;
		@track searchString;
		@track selectedRecordId ;
		@api fetchparentlistindex = "";
		@track itinload = false;

		@track parentRecordId;
		@track parentFieldApiName;
		@track blurTimeout;
		//@track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
		@track inputClass = '';
		selectedContent;
		preventClosingOfSerachPanel = false;
		popup = { showModal : false , popupName : "deallookup"  };

		connectedCallback(){
				console.log("child dealid:- "+this.dealid);
		}

		handleDialogClose(event) {
				this.popup.showModal = false;
				//create cutome event to pass showmodel=false in parent.
				console.log("inside handleDialogClose ");
				const hidepopupEvt = new CustomEvent("hidepopup" , {detail: this.popup });
				this.dispatchEvent(hidepopupEvt);
		}

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

		get showRecentRecords() {
				if (!this.recordsList) {
						return false;
				}
				return this.recordsList.length > 0;
		}

		handleChange(event){
				this.searchString = event.target.value;
				//this.otherFieldApiName = 'Icon_Label_Image__c';
				console.log('Handle Change Event Called ='+this.searchString);
				this.fetchSobjectRecords(false);
		}

		fetchSobjectRecords(loadEvent) {
				console.log('MEtHOD INPUT ='+JSON.stringify(this.methodInput));
				fetchRecords({
						inputWrapper: this.methodInput
				}).then(result => {

						console.log('Get recrds:- '+ JSON.stringify(result));
						this.recordsList = JSON.parse(JSON.stringify(result));

				}).catch(error => {
						console.log(" fetchSobjectRecords error :- "+ JSON.stringify(error));
				})
		}


		handleInputBlur(event) {
				// Debouncing this method: Do not actually invoke the Apex call as long as this function is
				// being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
				//window.clearTimeout(this.delayTimeout);
				// eslint-disable-next-line @lwc/lwc/no-async-operation

				this.delayTimeout = setTimeout(() => {
						if (!this.preventClosingOfSerachPanel) {
								this.recordsList = [];
						}
						this.preventClosingOfSerachPanel = false;
				}, DELAY);

				this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);

		}

		handleDivClick() {
				this.preventClosingOfSerachPanel = true;
		}

		get isValueSelected() {
				return this.selectedRecordId;
		}

		set isValueSelected(value){	
				this.selectedRecordId = value;	
		}

		//handler for selection of records from lookup result list
		handleSelect(event) {
				console.log("inside select handler");
				let selectedRecord = {
						mainField: event.currentTarget.dataset.mainfield,
						id: event.currentTarget.dataset.id
				};
				this.selectedRecordId = selectedRecord.id;
				this.selectedRecordName = selectedRecord.mainField;


				this.recordsList = [];
				console.log("selectedRecord:- "+ JSON.stringify(selectedRecord));

				var selectedContent = { 
						recordSelectedId : this.selectedRecordId,
						Name : this.selectedRecordName, 
						IconImage : this.selectedOtherField
				};


				if(this.blurTimeout) {
						clearTimeout(this.blurTimeout);
				}
				// this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
		}

		handleCommit(event) {
				this.selectedRecordId = "";
				this.selectedRecordName = "";
				this.fetchSobjectRecords(false);

				var selectedContent = { 	
						recordSelectedId : '',	
						Name : '', 	
				};	

				console.log("selectedContent :-"+ JSON.stringify(selectedContent));

		}

		async changeDealHandler(event){
				console.log("DailIdtoClonedFrom :- "+  this.selectedRecordId + "   AND  DailIdtoClonedTO  >>>  " + this.dealid);
				if(this.selectedRecordId == undefined || this.selectedRecordId == null || this.selectedRecordId == "" ){
						const errorNotification = new ShowToastEvent({
								title: "Please select deal",
								message: "" ,
								variant: 'warning',
								duration: '5000'
						})

						this.dispatchEvent(errorNotification);
				}else{
						const result = await LightningConfirm.open({
								message: 'Clicking on Ok will copy the itineraries from the selected deal and delete the existing ones.',
								theme: "warning", //success , warning, error, info
								variant: "default",
								label: 'Are you sure, you want to delete current Itineraries?',
								// setting theme would have no effect
						});

						if(result){
								this.itinload = true;
								CloneDealItineraries({
										DailIdtoClonedFrom: this.selectedRecordId , 
										DailIdtoClonedTO:this.dealid 
								}).then(result => {

										this.itinload = false;
										const shownotification = new ShowToastEvent({
												title: "Itineraries Are Cloned Successfully",
												message: '',
												variant: 'success',
												duration: '5000'
										})

										this.dispatchEvent(shownotification);

										window.location.reload();

								}).catch(error =>{
										const errorNotification = new ShowToastEvent({
												title: "Error occured",
												message: JSON.stringify(error),
												variant: 'error',
												duration: '5000'
										})

										this.dispatchEvent(errorNotification);
								})

						}


				}


		}



}