import { LightningElement, api, track } from 'lwc';
import saveSingleTour from '@salesforce/apex/Tad_DealOptimizaitonContorller.savesingletour';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
export default class MagnifierForTour extends LightningElement {
		@api dealid;
		@api siteOptions;
		@api tourdata;
		@api disableddata;
		@track temptourdata ={};
		popup = { showModal : false , popupName : "tour"  };
    @api name;
		
		handleDialogClose(event) {
				this.popup.showModal = false;
				//create cutome event to pass showmodel=false in parent.
				console.log("inside handleDialogClose ");
				const hidepopupEvt = new CustomEvent("hidepopup" , {detail: this.popup });
				this.dispatchEvent(hidepopupEvt);
		}

		handleSaveChanges(event){
				if(JSON.stringify(this.temptourdata)==="{}"){
						this.temptourdata = Object.assign({}, this.tourdata );
				}
				console.log("this.temptourdata Before calling >>:- "+ JSON.stringify(this.temptourdata) + "  <<<<< dealID before calling >>>>:- "+ this.dealid );
				saveSingleTour({tourdata: this.temptourdata , dealId: this.dealid})
						.then((res)=>{
						console.log("tour data responponse >>:- "+ JSON.stringify(res) );
						this.temptourdata = res;
					if(!(JSON.stringify(this.temptourdata)==="{}") && JSON.stringify(res) != "null"){
	
						const changeFieldvalues = new CustomEvent("handletoursave", {detail: this.temptourdata});
						this.dispatchEvent(changeFieldvalues); 
						this.temptourdata = {};
						this.handleDialogClose(event);
					}
				}).catch((err)=>{ 
						console.log("Error while tour saving:- "+ JSON.stringify(err) );
						const evt = new ShowToastEvent({
								title: 'Error occured while saving Tour Inclusion Record',
								message: JSON.stringify(err) ,
								variant: 'error',
								duration: '50000',
						}); 
						this.dispatchEvent(evt);
				});


		}

		handleChange(event){
				const fieldname = event.target.getAttribute("data-id1");
				this.value = event.target.value;
				if(JSON.stringify(this.temptourdata)==="{}"){
						this.temptourdata = Object.assign({}, this.tourdata );
				}
				//title, order, Selected Site, description
				if(fieldname == "title"){
						this.temptourdata.title = this.value;
				}else if(fieldname== "order"){
						if(this.value == ""){
							this.temptourdata.order = null;		
						}else{
								this.temptourdata.order = this.value;
						}
						
				}else if(fieldname== "Selected Site"){
						this.temptourdata.selectedsite = this.value;
				}else if(fieldname== "description"){
						this.temptourdata.description = this.value;
				}
				this.temptourdata.toUpdateorInsert = true;
				this.temptourdata.isBlank = false;
				console.log("this.temptourdata:->> "+JSON.stringify(this.temptourdata));
		}

}