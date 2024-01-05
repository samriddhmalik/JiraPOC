import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getOrderDataValue from '@salesforce/apex/Tad_CreateOrderPaymentLink.getOrderData';
import { NavigationMixin } from "lightning/navigation";
import createPaymentRecord from '@salesforce/apex/Tad_CreateOrderPaymentLink.createPaymentRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class createOrderPaymentLink extends NavigationMixin (LightningElement) {
		@api recordId;
		@track orderdata = [];
		originalAmount;
		originalEmail;
		tadOrderId;
		OrderAmount;
		Validity;
		Email;
		validEmail = false;
		subStatus;
		subStatusTrue = false;
		subStatusfalse = false;
		subStatusfalseQuote=false;
		showSpinner = false;
		todaysdate;
		splitwithTValidity;
		checkHavedate = false;
		nulldate = false;
        userName;
		notifyMe = false;
		
		
		
		
		connectedCallback(){
				console.log("recordId:- "+this.recordId);
				this.getOrderData();
		}

		getOrderData(){
				getOrderDataValue({orderId : this.recordId})
						.then(res=>{
						console.log("orderData:- "+ JSON.stringify(res));
						this.orderdata = res;
						console.log("orderAmount:- "+ JSON.stringify(res.OrderAmountOutStanding));
						console.log("orderStatus:- "+ JSON.stringify(res.OrderStatus));
						console.log("orderSubStatus:- "+ JSON.stringify(res.OrderSubStatus));
						this.todaysdate = res.dateSee;
						this.originalAmount = res.OrderAmountOutStanding;
						this.originalEmail = res.Email;
						this.subStatus = res.OrderSubStatus;
						var secureAllocation=res.secureAllocation;
						console.log('secureAllocation '+secureAllocation);
						if(this.subStatus === 'Quote Sent' && secureAllocation==false){//sso-74
							this.subStatusfalseQuote = true;
						}else{
							if((this.subStatus === 'Initial Payment Pending' || this.subStatus === 'Paid - PIF/s Due' || this.subStatus === 'Paid - PIF/s Overdue') && this.originalAmount > 0){
								this.subStatusTrue = true;
							}else{
								this.subStatusfalse = true;
							}
						}
						/*if((this.subStatus === 'Initial Payment Pending' || this.subStatus === 'Paid - PIF/s Due' || this.subStatus === 'Paid - PIF/s Overdue') && this.originalAmount > 0){
								this.subStatusTrue = true;
						}else{
								this.subStatusfalse = true;
						}*/

				});

		}		
		onEmailChanges(event){
					let element = event.target.value;
		   		this.Email=element;
		}

		OrderAmountOutStandingChanges(event){
				let element = event.target.value;
				this.OrderAmount=element;
		}
		 closeQuickAction() {
    const closeQA = new CustomEvent('close');
    this.dispatchEvent(closeQA);
  }

		OnchangeFieldValue(event){
				let element = event.target.value;
				this.Validity=element;
				this.splitwithTValidity = element;
				var aaj = event.target.value;
				if(aaj != null || aaj != undefined){
				var resultDate = aaj.split("T")[0];
				this.splitwithTValidity = resultDate;
			   	this.checkHavedate = true;
					
				}
				else{
							this.checkHavedate = false;
				}
			}
		

  
	onUserSelection(event){  
    this.userName = event.detail.selectedRecordId;
    
    //console.log('accountName-->'+accountName);
    console.log('userName-->'+this.userName); 
    
 
    }
		
	checkboxchange(event){
    console.log('Enter to event '+JSON.stringify(event.target.checked));
   // this.isEnableEmailCheckboxClicked = true;
    this.notifyMe = event.target.checked;
  //  this.isClicked = true;
    console.log('Line--71'+ this.notifyMe);
}
		
		saveButtoncaseDetails(){

			
					if(this.OrderAmount === undefined){
				     this.OrderAmount = this.originalAmount;
	       	}
					if(this.Email === undefined){
				     this.Email = this.originalEmail;
	       	}
					 var validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
				   let checkemailvalue = this.Email;
				
				 if (checkemailvalue.match(validRegex)) {
				
				   	if(this.checkHavedate == false){
			 	console.log('inside if');
				if((this.OrderAmount != undefined && this.OrderAmount != null && this.OrderAmount != '' && this.OrderAmount <= this.originalAmount && this.OrderAmount >0 ) && (this.Email != undefined && this.Email != null && this.Email != '') && (this.validity === undefined)){
				 	 	console.log('inside if1');
						createPaymentRecord({
								tadorderId:this.recordId,
								OrderAmountOutStanding:this.OrderAmount,
								tillValid:this.Validity,
								user : this.userName,
								notify :  this.notifyMe,
								emailRecipient : this.Email
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
				
				
				else{
						console.log('inside else1');
						const event = new ShowToastEvent({
								title: 'Error',
								duration:' 50000',
								variant: 'error',
								message: 'You can not choose more than original Amount/Negative Amount or neither choose past date.',

						});
						this.dispatchEvent(event);

				}
		}
								else{
					if((this.OrderAmount != undefined && this.OrderAmount != null && this.OrderAmount != '' && this.OrderAmount <= this.originalAmount && this.OrderAmount >0) && (this.Email != undefined && this.Email != null && this.Email != '') && ( this.splitwithTValidity != undefined && this.splitwithTValidity >= this.todaysdate)){
				 	console.log('inside if2');
						createPaymentRecord({
								tadorderId:this.recordId,
								OrderAmountOutStanding:this.OrderAmount,
								tillValid:this.Validity,
								user : this.userName,
								notify :  this.notifyMe,
								emailRecipient : this.Email
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
				
				
				else{
						console.log('inside else2');
						const event = new ShowToastEvent({
								title: 'Error',
								duration:' 50000',
								variant: 'error',
								message: 'You can not choose more than original Amount/Negative Amount or neither choose past date.',

						});
						
					
						this.dispatchEvent(event);
				}

				}
				 }else{
						 		console.log('inside else2');
						const event = new ShowToastEvent({
								title: 'Error',
								duration:' 50000',
								variant: 'error',
								message: 'Please choose a valid email address.',

						});
						
					
						this.dispatchEvent(event);
				 }
		}


}