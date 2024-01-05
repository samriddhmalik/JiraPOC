import { LightningElement, wire} from 'lwc';
import getFAQ from '@salesforce/apex/mp_FAQ.getFAQ';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
const DELAY = 100;
export default class FrequentlyAskedQuestion extends LightningElement {
   
    allData;
    error;
    textSearch = '';
    
       filesData = [];
      showSpinner = false;
    

      /*connectedCallback() {
        getFAQ({
       
        }).then(result => {
           
            console.log('Here in line no 20 callback---->'+JSON.stringify(result));
            
        })
    }*/

      @wire(getFAQ,{faqStrName:'$textSearch'})
      wiredResult({error, data}){
      if(data){
        console.log('@@@data '+JSON.stringify(data));
        this.allData = data.getFaq;
       
        
          console.log('@@@this.allDatagete---> '+JSON.stringify(this.allData));
        
        
          this.error = undefined;
      }else if(error){ 
        console.log('@@@this.error---> '+JSON.stringify(error));
      
        const event = new ShowToastEvent({
            title: 'Error',
            variant: 'error',
            message: error.body.message,
        });
        this.dispatchEvent(event);
      }
        
      }

      searchFaqAction(event){
        console.log('Line--50-->'+ event.target.value);
        //this.accountName = event.target.value;
        const searchString = event.target.value;
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.textSearch = searchString; 
        }, DELAY);
    }
}