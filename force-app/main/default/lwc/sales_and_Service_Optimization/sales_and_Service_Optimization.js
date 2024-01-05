import { LightningElement, track, wire, api } from 'lwc';
import getinitialdata from '@salesforce/apex/TAD_SSOController.getInitialData';
import getDeals from '@salesforce/apex/TAD_SSOController.getDeals';
import saveEnquiry from '@salesforce/apex/TAD_SSOController.saveEnquiry';
import saveordercoms from '@salesforce/apex/TAD_SSOController.saveordercoms';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import LightningConfirm from 'lightning/confirm';
import LightningAlert from 'lightning/alert'; 
import { CloseActionScreenEvent } from 'lightning/actions';

export default class Sales_and_Service_Optimization extends LightningElement {
		@api recordId;
		@track loading = true;
		@track getInitialData = {'CommsType':[]}
		@track dealdata
		@track showdata=false
		@track selectedDeals = []
		@track dealselected = false
		@track cities=[];
		connectedCallback() {
				this.Delay = 	setTimeout(() => {
						console.log("recordId:- "+this.recordId);
						this.getdata(this.recordId);
						//this.Picklistvalues();
				}, 1000);   
		}

		getdata(){
				getinitialdata({recId : this.recordId})
						.then(res=>{
						console.log(' res.CommsType:- '+JSON.stringify(res));
						this.getInitialData = res;
						this.cities = this.getInitialData.Activecities;
						if((this.getInitialData.dealList != undefined ) && !(JSON.stringify(this.getInitialData.dealList) == '[]') ){
								this.selectedDeals = [...this.getInitialData.dealList];
								this.dealdata = [...this.getInitialData.dealList];
								this.showdata=true;
								this.dealselected = true;

								this.Delay = 	setTimeout(() => {
										let checkboxes = this.template.querySelectorAll("[data-id1='deal check']");
										for(var k=0 ; k<checkboxes.length; k++){
												checkboxes[k].checked = true;
										}
								}, 1000);

						}
						this.loading = false;
				}).catch(err=>{
						console.log(' err:- '+JSON.stringify(err));
				})
		}

		resetData(){
				this.selectedDeals = [];
				//this.dealdata.ToDate = '';
				//this.dealdata.fromDate = '';
				this.dealdata = [];
				this.showdata = false;
				this.dealselected = false;
				this.getInitialData.dealList = [];
				//this.template.querySelector('[data-id1="To Date"]').value = null;
				//this.template.querySelector('[data-id1="From Date"]').value = null;


		}
		
		Picklistvalues(){
				getPicklistvalues({objectName:'departure_cities__c', field_apiname:'city__c'})
						.then(res=>{
						this.cities = Activecities;
				}).catch(err=>{
						console.log('error74'+ JSON.stringify(err));
				});
				
		}

		handleChange(event){
				const dataid1 = event.target.getAttribute('data-id1');
				const value = event.target.value;
				console.log('dataid1:-  ' + dataid1);
				console.log('value:-  ' + value);
				if (dataid1== 'type') {
						this.getInitialData.comsSelected = value;
				}
				else if (dataid1 == 'search Key') {
						this.resetData();
						this.getInitialData.Destination = value;
						console.log('68')
				}
				else if (dataid1 == 'Departure Date Range') {

						console.log('check :- ' + event.target.checked);
						this.getInitialData.DepDateRange = event.target.checked;
						if(event.target.checked == false){
								this.getInitialData.ToDate = null;
								this.getInitialData.fromDate = null;
						}
						this.Delay = 	setTimeout(() => {
								this.resetData();
						}, 50); 

				}
				else if (dataid1 == 'From Date') {
						this.getInitialData.fromDate = value;
						if(value == null){
								this.getInitialData.ToDate = null;
								this.template.querySelector("[data-id1='To Date']").disabled = true;
						}else{ 
								this.template.querySelector("[data-id1='To Date']").disabled = false;
						}
				}
				else if (dataid1 == 'To Date') {
						this.getInitialData.ToDate = value;
				}
				else if (dataid1 == 'passengers') {
						this.getInitialData.passengerCount = value;
				}
				else if (dataid1 == 'Include AddOn info') {
						const check = event.target.checked;
						console.log('chech:- ' + event.target.checked);
						this.getInitialData.addonInclude = event.target.checked;
				}
				else if(dataid1 == 'deal check'){
						const check = event.target.checked;
						const index = event.target.getAttribute("data-id");
						const deealId = this.dealdata[index].id;
						console.log("Index:- "+ index);
						console.log("deealId:- "+ deealId);


						if(check == true){

								if(this.selectedDeals.length <4){
										this.selectedDeals.push(this.dealdata[index]);

								}else if(this.selectedDeals.length == 4){

										const evt = new ShowToastEvent({
												title: 'You cannot select more than 4 deals!',
												message: '' ,
												variant: 'error',
												duration:' 30000',
										});
										this.dispatchEvent(evt);
										this.delay = setTimeout(() => {

												let checkboxes = this.template.querySelectorAll("[data-id1='deal check']");

												for(var k=0 ; k<checkboxes.length; k++){
														if(checkboxes[k].getAttribute("data-id")== index){
																checkboxes[k].checked = false;			
														}

												}
										}, 50);

								}

						}else if(check == false){
								for(var m=0; m<this.selectedDeals.length; m++){
										if(this.selectedDeals[m].id == deealId){
												this.selectedDeals.splice(m,1);
										}
								}
						}
						if(this.selectedDeals.length > 0){
								this.dealselected = true; 
						}else{
								this.dealselected = false;
						}
						console.log("selectedDeals:- "+ JSON.stringify(this.selectedDeals));
				}else if(dataid1 == 'deal notes'){
						const index = event.target.getAttribute('data-id');
						console.log('Index:- '+ index);
						this.selectedDeals[index].dealNotes = value;
						console.log("selectedDeals:- "+ JSON.stringify(this.selectedDeals));
				}else if(dataid1=='Quote Details'){
						this.getInitialData.quoteDeals = value;
				}else if(dataid1=='city'){
						this.resetData();
						this.getInitialData.citySelected = value;
				}
				console.log("this.getInitialData:- "+JSON.stringify(this.getInitialData));
		}


		SearchDeals(event){
				if(this.getInitialData.Destination == undefined || this.getInitialData.Destination == null || this.getInitialData.Destination ==' ' || this.getInitialData.Destination ==''){

						const evt = new ShowToastEvent({
								title: 'Select Destination to proceed',
								message: '' ,
								variant: 'error',
								duration:' 30000',
						});
						this.dispatchEvent(evt);

				}else	if( this.getInitialData.DepDateRange == true)
				{

						if (this.getInitialData.fromDate > this.getInitialData.ToDate ){

								const evt = new ShowToastEvent({
										title: '"To date" must be after "From date"',
										message: '' ,
										variant: 'error',
										duration:' 30000',
								});
								this.dispatchEvent(evt);
						}else if(this.getInitialData.fromDate == null || this.getInitialData.fromDate == undefined || this.getInitialData.ToDate == undefined || this.getInitialData.ToDate == null){
								const evt = new ShowToastEvent({
										title: 'Select  "From date" and "To date"',
										message: '' ,
										variant: 'error',
										duration:' 30000',
								});
								this.dispatchEvent(evt);
						}else{
								console.log('180');
								let checkboxes = this.template.querySelectorAll("[data-id1='deal check']");

								for(var k=0 ; k<checkboxes.length; k++){

										checkboxes[k].checked = false;
								}

								this.selectedDeals = [];
								this.dealdata = [];
								this.showdata = false;
								this.dealselected = false;

								/*if(this.getInitialData.Destination == ''){
												this.getInitialData.Destination = null;
										}*/
								this.loading = true;
								getDeals({data : this.getInitialData, dealIds:'' , checkIds : false})
										.then(result=>{
										console.log('result :- '+JSON.stringify(result));
										this.dealdata = result;
										if(this.dealdata.length >0){
												this.showdata = true;
										}else{
												this.showdata = false;
										}
										this.loading = false;
								}).catch(error=>{
										console.log('error :- '+JSON.stringify(error));
								});
						}

				}else{
						console.log('180');
						let checkboxes = this.template.querySelectorAll("[data-id1='deal check']");

						for(var k=0 ; k<checkboxes.length; k++){

								checkboxes[k].checked = false;
						}

						this.selectedDeals = [];
						this.dealdata = [];
						this.showdata = false;
						this.dealselected = false;

						/*if(this.getInitialData.Destination == ''){
												this.getInitialData.Destination = null;
										}*/
						this.loading = true;
						getDeals({data : this.getInitialData, dealIds:'' , checkIds : false})
								.then(result=>{
								console.log('result :- '+JSON.stringify(result));
								this.dealdata = result;
								if(this.dealdata.length >0){
										this.showdata = true;
								}else{
										this.showdata = false;
								}
								this.loading = false;
						}).catch(error=>{
								console.log('error :- '+JSON.stringify(error));
						});
				}

		}

		saveHandler(event){
				this.loading = true;
				const dataid = event.target.getAttribute('data-id');
				this.getInitialData.dealList = this.selectedDeals;
				console.log(' getInitialData 115:- '+JSON.stringify(this.getInitialData));
				console.log("Selected coms :- "+JSON.stringify(this.getInitialData.comsSelected));
				console.log("Destination :- " +JSON.stringify(this.getInitialData.Destination));
				if( this.getInitialData.comsSelected == undefined || this.getInitialData.comsSelected == null ||  this.getInitialData.Destination == undefined || this.getInitialData.Destination == null || this.getInitialData.Destination ==' ' || this.getInitialData.Destination ==''){
						const evt = new ShowToastEvent({
								title: 'Select Destination to '+  (dataid=='Send OC'? 'Send': 'Save')  + ' Communication',
								message: '' ,
								variant: 'error',
								duration:' 30000',
						});
						this.loading = false;
						this.dispatchEvent(evt);
				}
				else{

						if ((this.getInitialData.fromDate > this.getInitialData.ToDate) && this.getInitialData.DepDateRange == true ){

								const evt = new ShowToastEvent({
										title: '"To date" must be after "From date"',
										message: '' ,
										variant: 'error',
										duration:' 30000',
								});
								this.dispatchEvent(evt);
								this.loading = false;
						}else if((this.getInitialData.fromDate == null || this.getInitialData.fromDate == undefined || this.getInitialData.ToDate == undefined || this.getInitialData.ToDate == null) && (this.getInitialData.DepDateRange == true)){
								const evt = new ShowToastEvent({
										title: 'Select  "From date" and "To date"',
										message: '' ,
										variant: 'error',
										duration:' 30000',
								});
								this.dispatchEvent(evt);
								this.loading = false;
						}

						else{
								if(dataid=='Send OC'){
										if(this.selectedDeals == undefined || this.selectedDeals == null || JSON.stringify(this.selectedDeals) == '[]' ){
												console.log("this.selectedDeals is null :- " + this.selectedDeals);
												const evt = new ShowToastEvent({
														title: 'Select Deal to send Communication',
														message: '' ,
														variant: 'error',
														duration:' 30000',
												});
												this.dispatchEvent(evt);
												this.loading = false;
										}else{
												saveordercoms({data : this.getInitialData})
														.then(res=>{
														console.log(' res:- '+JSON.stringify(res));
														const evt = new ShowToastEvent({
																title: 'Enquiry email sent to customer successfully.',
																message: '' ,
																variant: 'success',
																duration:' 50000',
														});
														this.loading = false;
														this.dispatchEvent(evt);
														this.dispatchEvent(new CloseActionScreenEvent());
												}).catch(err=>{
														console.log(' err:- '+JSON.stringify(err));
												})
										}

								}else if(dataid=='Save Enquiry'){





										saveEnquiry({data : this.getInitialData})
												.then(res=>{
												console.log(' res:- '+JSON.stringify(res));
												const evt = new ShowToastEvent({
														title: 'Enquiry details are saved successfully.',
														message: '' ,
														variant: 'success',
														duration:' 50000',
												});
												this.loading = false;
												this.dispatchEvent(evt);
												this.dispatchEvent(new CloseActionScreenEvent());
										}).catch(err=>{
												console.log(' err:- '+JSON.stringify(err));
										})
								}



						}

				}

		}


}