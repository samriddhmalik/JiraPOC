import { LightningElement,api } from 'lwc';
import findRecords from '@salesforce/apex/Tad_CreateOrderPaymentLink.findRecords';

export default class Taduserlookup extends LightningElement {

    recordsList;  
    searchKey = "";  
   @api selectedValue;  
   @api selectedRecordId;  
   @api objectApiName;  
   @api iconName;  
   @api lookupLabel;  
    message;  
    recordId;


  onLeave(event) {  
   setTimeout(() => {  
    this.searchKey = "";  
    this.recordsList = null;  
   }, 300);  
  }  
    
  onRecordSelection(event) {  
   this.selectedRecordId = event.target.dataset.key;  
   this.selectedValue = event.target.dataset.name;  
   this.searchKey = "";  
   this.onSeletedRecordUpdate();  
  }  
   
  handleKeyChange(event) {  
   const searchKey = event.target.value;  
   this.searchKey = searchKey;  
   this.getLookupResult();  
  }  
   
  removeRecordOnLookup(event) {  
   this.searchKey = "";  
   this.selectedValue = null;  
   this.selectedRecordId = null;  
   this.recordsList = null;  
   this.onSeletedRecordUpdate();  
 }  
   


 


  getLookupResult() {  
    findRecords({ searchKey: this.searchKey, objectName : this.objectApiName})  
    .then((result) => {  
     if (result.length===0) {  
       this.recordsList = [];  
       this.message = "No Records Found";  
      } else {  
       this.recordsList = result;  
       this.message = "";  
      }  
      this.error = undefined;  
    })  
    .catch((error) => {  
     this.error = error;  
     this.recordsList = undefined;  
    });  
  }  
   
  onSeletedRecordUpdate(){  
   const passEventr = new CustomEvent('recordselection', {  
     detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }  
    });  
    this.dispatchEvent(passEventr);  
  }  



}