import { LightningElement,wire,track,api} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getCommType from'@salesforce/apex/EXP_SendCommunicationController.getHotelData';
import { NavigationMixin } from "lightning/navigation";
import createOrderComsRecord from '@salesforce/apex/EXP_SendCommunicationController.createOrderComsRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class ExpSendCommunication extends NavigationMixin (LightningElement) {
		@api recordId;
		@track commTypeList=[];
		@track commTypeConfirmList=[];
		isHotelCancelled = false;
		hotelCancelledStatus;
		hotelNotCancelledStatus;
		checkCommType;
		checkCommTypeNone = false;
		checkCommTypeOther = false;

		connectedCallback(){
				console.log("recordId:- "+this.recordId);
				this.getHotelData();
		}

		getHotelData(){
				getCommType({ 
						HotelId : this.recordId
				})
						.then(result => {
						this.commTypeList = result.commTypeListType;
						this.hotelStatus = result.HotelStatus;
						this.commTypeConfirmList = result.commTypeConfirmationListType;
						console.log('result ='+JSON.stringify(result));
						if(this.hotelStatus === 'Cancelled'){
								this.hotelCancelledStatus = true;
						}else{
								this.hotelNotCancelledStatus = true;	
						}

				})
						.catch(error => {
						console.log('ERROR FROM METHOD - getCommType ='+error.body.message);
				});
		}
		handleGetSelectedValue(event){ 
				let element = event.target.value;
				this.checkCommType=element;
				console.log('Line43 '+this.checkCommType);
				if(this.checkCommType === '----NONE----'){
						this.checkCommTypeNone = true;
					 this.checkCommTypeOther = false;
				}else{
					 this.checkCommTypeOther = true;
					 	this.checkCommTypeNone = false;
				}
		}

		closeQuickAction(event) {
				const closeQA = new CustomEvent('close');
				this.dispatchEvent(closeQA);
		}
		
		saveButtoncaseDetails(){

			  console.log('line65'+this.checkCommType);
				console.log('line66'+this.recordId);
				
	   		if(this.checkCommType != null && this.recordId != null) {
						createOrderComsRecord({
								hotelid:this.recordId,
								communicationcode:this.checkCommType,
							
						})
						const event = new ShowToastEvent({
							title: 'Success',
							duration:' 50000',
							variant: 'success',
							message: 'Records created successfully.',

					});
					this.dispatchEvent(event);

					   const closeQA = new CustomEvent('close');
             this.dispatchEvent(closeQA);
			}
		}
}