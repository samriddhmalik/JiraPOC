import { LightningElement, wire, track, api } from 'lwc';
import fetchWrapDetails from '@salesforce/apex/TAD_marketingActivitySearchLWC.fetchWrapDetails';

const COLS = [
    { label: 'Order Id', fieldName: 'TADOrder', type: 'text' },
    
    { label: 'Departure Cities Count', fieldName: 'DetailString', type: 'text' }
];

export default class TAD_DetailOnhover extends LightningElement {
    cols = COLS;
     @api dealId;
     @api showModal ;
     @api dealList = [];
    
     constructor() {
        super();
        this.showModal = false;
     }

     @api
    callTofetchWrapDetails(dealId){
        console.log('dealId '+dealId);
        fetchWrapDetails({dealId : dealId})
        .then(result => {
            let dealData = [];
            console.log('values '+ JSON.stringify(result));
            this.dealList = result;
           return 'finished calling';
        })
        .catch(error => {
            console.log('Error while fetching Picklist values' + JSON.stringify(error));
            this.error = error;
            return 'not called';
        });


    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
      }

      handlePositive(){
        this.dispatchEvent(new CustomEvent('positive'));
      }
}