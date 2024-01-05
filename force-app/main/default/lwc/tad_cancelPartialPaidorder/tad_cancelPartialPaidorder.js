import { LightningElement, api, track } from 'lwc';
import getOrderInfo from '@salesforce/apex/tad_RequestCancellationController.getOrderInfo';
import createCancellationRecord from '@salesforce/apex/tad_RequestCancellationController.createCancellationRecord';
import submitRefundNoCancellation from '@salesforce/apex/Tad_RefundNoCancellationController.submitRefundNoCancellation';
import fetchRefundNoCancellationApproval from '@salesforce/apex/Tad_RefundNoCancellationController.fetchRefundNoCancellationApproval';
import reSubmitRefundNoCancellation from '@salesforce/apex/Tad_RefundNoCancellationController.reSubmitRefundNoCancellation';
import fetchApprovalHistory from '@salesforce/apex/Tad_RefundNoCancellationController.fetchApprovalHistory';
import verifyUser from '@salesforce/apex/Tad_RefundNoCancellationController.verifyUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import USER_ID from '@salesforce/user/Id';

export default class Tad_cancelPartialPaidorder extends NavigationMixin(LightningElement) {
@api recordId
@api cancellationType
userId = USER_ID
isValidUser
couponAmount
recievedAmount
refundAmount
refundCoupon
showSpinner = false;
reason
check = false
activeSections = [];
approvalHistory = [];
showApprovalHistory = false
@track apprHistory = [];
showSubmittedRequests = false;
reasonOptions = ['Merchant Changed Deal/Tour','Transfer Reimbursement', 'Baggage Reimbursement','System Error','Hotel Reimbursement','Overpayment On Order','Staff Error','Customer Complaint','Operator Reimbursement','BER Refund','Customer Error'].map(reason =>({value:reason,label:reason}));
actionOptions = ['Request new cancellation', 'Rejected Submissions','Approval History'].map(action=>({value:action,label:action}));

connectedCallback(){
    this.showSpinner = true;
    verifyUser({userId :this.userId}).then(response =>{
        if(response == true){
            this.isValidUser = true;
        }
    })
getOrderInfo({
    orderId: this.recordId}
    ).then(response =>{
        this.couponAmount  = response[0].Total_Order_Coupons_Discount__c;
        this.recievedAmount = response[0].ordexp_total_payment_received__c;
    })
    fetchRefundNoCancellationApproval({
        recId:this.recordId
    }).then(response =>{
        if(response.length>0){
            this.approvalHistory = response;
            this.showSubmittedRequests = true;
        }
    })
    fetchApprovalHistory({recId:this.recordId}).then(response=>{
    if(response.length>0){
        this.showApprovalHistory = true;
        this.apprHistory = response;
    }
    })
    this.showSpinner = false;
}
get showExpirePartial(){
  return this.cancellationType == 'expiredPartialPAidOrder'? true:false;
}
get showRefundNoCan(){
    if(this.isValidUser && (this.couponAmount+this.recievedAmount>0)){
        return true;
    }else{
        return false;
    }
}
inputChangeHandler(event){
  switch(event.target.name){
    case 'refund':
        this.refundAmount = parseFloat(event.target.value);
        break;
    case 'coupon':
        this.refundCoupon = parseFloat(event.target.value);
        break;
  }
}
handleSaveAndCancel(event){
    switch(event.target.name){
        case 'submit':
            this.handleVaidation();
        break;
        case 'back':
            const cancelEvt = new CustomEvent('back');
            this.dispatchEvent(cancelEvt);
        break;
        }
     }

     handleVaidation(){
       
        let paymentRecieved = this.recievedAmount + this.couponAmount;
        let refund = this.refundAmount + this.refundCoupon;
        let inputVal1 = this.template.querySelector('.input1');
        let inputVal2 = this.template.querySelector('.input2');
        if(inputVal1.checkValidity() == false || inputVal2.checkValidity() == false){
            inputVal1.reportValidity();
            inputVal2.reportValidity();
            return;
        }
        if(this.refundAmount < 0 || this.refundCoupon < 0 ){
            this.dispatchEvent( 
                new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                message:
                    'Negative amount not allowed!!',
            }));
            return;
        }
       
        if(this.cancellationType == 'expiredPartialPAidOrder'){
        if(refund > paymentRecieved){
            this.dispatchEvent( 
                new ShowToastEvent({
                title: 'Error',
                variant: 'Error',
                message:
                    'Cancellation amount cannot be more than Payment received',
            }));
            return;
            }

            if(this.refundAmount > this.recievedAmount){
                this.dispatchEvent( 
                    new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    message:
                        'Refund Amount cannot be more than Received Amount',
                }));
                return;
                }
                

                this.showSpinner = true
              console.log('refund',this.refundAmount,'coupon',this.refundCoupon);

                createCancellationRecord({
                    orderId: this.recordId, refundAmount: this.refundAmount, refundCoupon: this.refundCoupon}
                    ).then(response => {
                       // const url = '/'+ response;
                        this.showSpinner = false;
                        this.dispatchEvent( 
                            new ShowToastEvent({
                            title: 'Success',
                            variant: 'Success',
                            message:
                                'Cancellation record created successfully.',
                        }));
                    //    window.open(url, '_blank');
                       const evt = new CustomEvent('close');
                       this.dispatchEvent(evt);
                    }).catch(error => {
                        this.showSpinner = false;
                        this.dispatchEvent( 
                            new ShowToastEvent({
                            title: 'Error',
                            variant: 'Error',
                            message:
                                'Error in creating cancellation record',
                        }))});
                    
                }else{
                    
                    if(this.reason == undefined){
                        this.dispatchEvent( 
                            new ShowToastEvent({
                            title: 'Error',
                            variant: 'Error',
                            message:
                                'Please select Reason from the picklist',
                        }));
                        return;
                    }
                    if(this.refundAmount>0 || this.refundCoupon>0){
                        this.showSpinner = true;
                        if(this.refundAmount == undefined){
                            this.refundAmount = 0.00;
                        }
                        if(this.refundCoupon == undefined){
                            this.refundCoupon = 0.00
                        }
                        submitRefundNoCancellation({recId:this.recordId,couponAmount:this.refundCoupon,refundAmount:this.refundAmount, reason:this.reason}).then(response =>{
                        console.log('response from no cancelllation',response);
                        this.showSpinner = false;
                            this.dispatchEvent( 
                                new ShowToastEvent({
                                title: 'Success',
                                variant: 'Success',
                                message:
                                    'Refund No Cancellation submitted successfully.',
                            }));
                            const evt = new CustomEvent('close');
                           this.dispatchEvent(evt);
                        }).catch(error => {
                            this.showSpinner = false;
                            this.dispatchEvent( 
                                new ShowToastEvent({
                                title: 'Error',
                                variant: 'Error',
                                message:
                                    'Error in submitting cancellation request',
                            }))});
                    }else{
                        this.dispatchEvent( 
                            new ShowToastEvent({
                            title: 'Error',
                            variant: 'Error',
                            message:
                                'Refund Amount or Coupon Amount should be greater than 0.',
                        }));
                        return;
                    }
                   
                }
            }
        handleReasonChange(event){
                this.reason = event.target.value;            
            }
        handleSectionToggle(event){

        }
        handleresubmitReasonChange(event){
                const index = event.target.dataset.index;
                this.approvalHistory[index].refundReason = event.target.value;
            }
        checkboxchangeHandler(event){
            const index = event.target.dataset.index;
            if(event.target.checked){
                this.approvalHistory[index].check = true;
            }else{
                this.approvalHistory[index].check = false;
            }
        }
        resubmitInputChangeHandler(event){
            const index = event.target.dataset.index;
            if(event.target.name == 'refund'){
                this.approvalHistory[index].refund = event.target.value;
            }else{
                this.approvalHistory[index].coupon = event.target.value;
            }
            

        }
        resubmitHandler(){
            let recData = []
            recData.push(...this.approvalHistory.filter(obj=>obj.check==true));
            let check = this.approvalHistory.some(obj=>{return obj.check == true});
            
            if(check == false){
                this.dispatchEvent( 
                    new ShowToastEvent({
                    title: 'Error',
                    variant: 'Error',
                    message:
                        'Please select at least one record.',
                }));
                return;
            }else{
                if(!recData.every(obj=>{ return (obj.refund>0 || obj.coupon >0)})){
                    this.dispatchEvent( 
                        new ShowToastEvent({
                        title: 'Error',
                        variant: 'Error',
                        message:
                            'Refund Amount or Coupon Amount should be greater that 0.',
                    }));
                    return;
                }
                recData.forEach(obj =>{
                    if(obj.refund == undefined || obj.refund == ''){
                        obj.refund = 0.00;
                    }
                    if(obj.coupon == undefined || obj.coupon == ''){
                        obj.coupon = 0.00;
                    }
                })
                this.showSpinner = true;
                console.log('recData',recData)
                reSubmitRefundNoCancellation({wrap: recData}).then(response=>{
                    this.showSpinner = false;
                    this.dispatchEvent( 
                        new ShowToastEvent({
                        title: 'Success',
                        variant: 'Success',
                        message:
                            'Refund No Cancellation Resubmitted successfully.',
                    }));
                    const evt = new CustomEvent('close');
                   this.dispatchEvent(evt);
                }).catch(error => {
                    console.log('error',error)
                    this.showSpinner = false;
                    this.dispatchEvent( 
                        new ShowToastEvent({
                        title: 'Error',
                        variant: 'Error',
                        message:
                            'Error in Resubmitting cancellation request',
                    }))});
            }
        }

    }