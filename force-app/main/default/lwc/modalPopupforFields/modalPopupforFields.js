import { LightningElement, api, track } from 'lwc';
//import getActivities from '@salesforce/apex/Tad_DealOptimizaitonContorller.getitinactivity';
import saveSingleItinerary from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveSingleItinerary';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
export default class modalPopupforFields extends LightningElement {
		showModal = false;
		recordsList;
		@api itindata;
		@api itinnumber;
		@api countryoptions;
		@api mealsOptions;
		@api dealid;
		@api disableddata;
		@track tempitindata = {};
		popup = { showModal : false , popupName : "itin"  };
		//selectedValue=true;

		handleDialogClose(event) {
				this.popup.showModal = false;
				//create cutome event to pass showmodel=false in parent.
				console.log("inside handleDialogClose ");
				const hidepopupEvt = new CustomEvent("hidepopup" , {detail: this.popup });
				this.dispatchEvent(hidepopupEvt);
		}
		handleChange(event){
				this.fieldname = event.target.getAttribute('data-id1');
				this.value = event.target.value;
				console.log('check Empty:- '+ (JSON.stringify(this.tempitindata) === '{}'));
				if(JSON.stringify(this.tempitindata) === '{}'){
						this.tempitindata = Object.assign({}, this.itindata ) ;
				}


				console.log("this.fieldname:- "+ JSON.stringify(this.fieldname));
				console.log("this.value:- "+ JSON.stringify(this.value));
				console.log("this.tempitindata:- "+ JSON.stringify(this.tempitindata));
				// day , title, description, accommodation , inclusions , transfers , country

				if(this.fieldname =='day'){
						this.tempitindata.day = this.value;
				}else if(this.fieldname =='title'){
						this.tempitindata.title = this.value;
				}else if(this.fieldname =='description'){
						this.tempitindata.description = this.value;
				}else if(this.fieldname =='accommodation'){
						console.log('insidevaccomodation');
						this.tempitindata['accommodation'] = this.value;
				}else if(this.fieldname =='inclusions'){
						this.tempitindata.selectedmeals = this.value;
				}else if(this.fieldname =='transfers'){
						this.tempitindata.transfers = this.value;
				}else if(this.fieldname =='country'){
						this.tempitindata.country = this.value;
				}else if(this.fieldname =='activity'){
				}
				this.tempitindata.isBlank = false;
				this.tempitindata.toUpdateorInsert = true;

				console.log("this.tempitindata:- "+ JSON.stringify(this.tempitindata));
				// const fieldvaluechageEvt = new CustomEvent("handlefieldvalue" , {detail: this.tempitindata });
				// this.dispatchEvent(fieldvaluechageEvt);

		}

		handleSsaveChanges(event){

				if((JSON.stringify(this.tempitindata)==='{}')){
						this.tempitindata = Object.assign({}, this.itindata ) ;
						this.tempitindata.toUpdateorInsert = true;
				}
				saveSingleItinerary({itinrec: this.tempitindata , dealId: this.dealid , itinNumber: this.itinnumber})
						.then((res)=>{
						console.log('this.tempitindata response:- '+ JSON.stringify(res));
						this.tempitindata = res;
						if(!(JSON.stringify(res)==='{}')){
								console.log("this.tempitindata:- "+ JSON.stringify(this.tempitindata));
								const fieldvaluechageEvt = new CustomEvent("handlefieldvalue" , {detail: this.tempitindata });
								this.dispatchEvent(fieldvaluechageEvt);
								this.tempitindata = {};
						}
				}).catch((err)=>{
						console.log('Error in SaveSingleItinerary:- '+ JSON.stringify(err));
				});

				// console.log("this.tempitindata:- "+ JSON.stringify(this.tempitindata));
				// const fieldvaluechageEvt = new CustomEvent("handlefieldvalue" , {detail: this.tempitindata });
				// this.dispatchEvent(fieldvaluechageEvt);
				// this.tempitindata = {};
				this.handleDialogClose(event);
		}

		handleKeyChange(event){
				this.value = event.target.value;

// 				getActivities({searchKeyWord: this.value , dealId: this.dealid})
// 						.then((result) => {  
// 
// 						if (result.length===0) {  
// 								this.recordsList = [];  
// 								this.message = "No Records Found";  
// 						} else {  
// 								this.recordsList = result;  
// 								this.message = "";  
// 								console.log('this.recordsList:- '+ JSON.stringify(this.recordsList));
// 						}  
// 						this.error = undefined;  
// 				}).catch((error) => {  
// 						this.error = error;  
// 						this.recordsList = undefined;  
// 				});

		}

}