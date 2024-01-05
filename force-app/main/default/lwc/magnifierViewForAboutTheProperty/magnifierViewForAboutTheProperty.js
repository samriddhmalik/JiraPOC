import { LightningElement, api, track } from 'lwc';
import saveSingleProperty from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveSingleProperty';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class MagnifierViewForAboutTheProperty extends LightningElement {

    @api dealid;
    @api propertydata;
    @api siteOptions;
    @api disableddata;
    @track temppropertydata ={};
    popup = { showModal : false , popupName : "property" };

    handleDialogClose(event) {
        this.popup.showModal = false;
        //create cutome event to pass showmodel=false in parent.
        console.log("inside handleDialogClose ");
        const hidepopupEvt = new CustomEvent("hidepopup" , {detail: this.popup });
        this.dispatchEvent(hidepopupEvt);
    }

    handleChange(event){
        const fieldname = event.target.getAttribute("data-id1");
        this.value = event.target.value;
        if(JSON.stringify(this.temppropertydata)==="{}"){
                this.temppropertydata = Object.assign({}, this.propertydata );
        }
        //title, order, Selected Site, description
        if(fieldname == "title"){
                this.temppropertydata.title = this.value;
        }else if(fieldname== "order"){
						if(this.value == ""){
							this.temppropertydata.order = null;	
						}else{
								this.temppropertydata.order = this.value;
						}
        }else if(fieldname== "Selected Site"){
                this.temppropertydata.selectedsite = this.value;
        }else if(fieldname== "description"){
                this.temppropertydata.description = this.value;
        }
        this.temppropertydata.toUpdateorInsert = true;
				this.temppropertydata.isBlank = false;
        console.log("this.temppropertydata:->> "+JSON.stringify(this.temppropertydata));
    }

    handleSaveChanges(event){
        if(JSON.stringify(this.temppropertydata)==="{}"){
                this.temppropertydata = Object.assign({}, this.propertydata );
        }
        console.log("this.temppropertydata Before calling >>:- "+ JSON.stringify(this.temppropertydata) + "  <<<<< dealID before calling >>>>:- "+ this.dealid );
        saveSingleProperty({propertydata: this.temppropertydata , dealId: this.dealid})
                .then((res)=>{
                console.log("property data responponse >>:- "+ JSON.stringify(res) );
                this.temppropertydata = res;
            if(!(JSON.stringify(this.temppropertydata)==="{}") && JSON.stringify(res) != "null"){

                const changeFieldvalues = new CustomEvent("handlepropertysave", {detail: this.temppropertydata});
                this.dispatchEvent(changeFieldvalues); 
                this.temppropertydata = {};
                this.handleDialogClose(event);
            }
        }).catch((err)=>{ 
                console.log("Error while About the Property saving:- "+ JSON.stringify(err) );
                const evt = new ShowToastEvent({
                        title: 'Error occured while saving About the Property Record',
                        message: JSON.stringify(err) ,
                        variant: 'error',
                        duration: '50000',
                }); 
                this.dispatchEvent(evt);
        });


    }

}