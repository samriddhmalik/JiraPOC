import { LightningElement, wire,api,track} from 'lwc';
import getTadOrderRecord from '@salesforce/apex/MP_RaiseAQuestion.getTadOrderRecord';
import updateCase from '@salesforce/apex/MP_RaiseAQuestion.updateCase';
import NavigateToCase from '@salesforce/label/c.NavigateToCase';
import { NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import uploadFiles from '@salesforce/apex/MP_RaiseAQuestion.uploadFiles'
import newCaseRecord from '@salesforce/apex/MP_RaiseAQuestion.newCaseRecord'
const MAX_FILE_SIZE = 2097152;

export default class RaiseAQuestion extends NavigationMixin(LightningElement) {

@api
myRecordId;
  recId;
  tadOrderId;
  tadOrder;
  allData;
  openCases;
  closedCases;
  feedComments;
  caseComment;
  accordionCaseId;
  viewCase = NavigateToCase;
  recordData;
  res;
  error;
  isLoading = false;
  caseSub;
  caseDesc;
  isCalled= false;
  isCaseCreated= false;
  isUploadEnabled= false;
  @api recordId;
  @track filesData = [];
  showSpinner = false;
  NewCaseRecordDetails;
  caseRecordId;
  isModalOpen = false;


  connectedCallback() {
    const url = window.location.href;
    console.log('@@@this.url '+url);
    var newurl = new URL(url);
    this.tadOrderId = newurl.searchParams.get("tad_OrderId");
    console.log('@@@tadOrderId '+this.tadOrderId);
    }
      
    @wire(getTadOrderRecord)
    wiredResult({error, data}){
    if(data){
      console.log('@@@data '+data);
      this.allData = data;
      this.tadOrder = this.allData[0].tadOrder;
      this.openCases = this.allData[0].openCases;
      this.closedCases = this.allData[0].closedCases;
      this.recordData = this.allData[0].openCases;
      
        console.log('@@@this.tadOrder '+JSON.stringify(this.tadOrder));
        console.log('@@@this.openCases '+JSON.stringify(this.openCases));
      
        this.error = undefined;
    }else if(error){
      const event = new ShowToastEvent({
          title: 'Error',
          variant: 'error',
          message: error.body.message,
      });
      this.dispatchEvent(event);
    }
      
    }

  handleFileUploaded(event) {
      if (event.target.files.length > 0) {
          for(var i=0; i< event.target.files.length; i++){
              if (event.target.files[i].size > MAX_FILE_SIZE) {
                  this.showToast('Error!', 'error', 'File size exceeded the upload size limit.');
                  return;
              }
              let file = event.target.files[i];
              let reader = new FileReader();
              reader.onload = e => {
                  var fileContents = reader.result.split(',')[1]
                  this.filesData.push({'fileName':file.name, 'fileContent':fileContents});
              };
              reader.readAsDataURL(file);
          }
      }
  }

  uploadFiles() {
      if(this.filesData == [] || this.filesData.length == 0){
          this.showToast('Error', 'error', 'Please select files first'); return;
      }
      if((this.caseSub != undefined && this.caseSub != null && this.caseSub != '' ) && (this.caseDesc != undefined  && this.caseDesc != null && this.caseDesc != '' ) ) {
     
      this.showSpinner = true;
      uploadFiles({
          filedata : JSON.stringify(this.filesData),
          subject:this.caseSub,
          description:this.caseDesc,
          caseId:this.recId
      })
      .then(result => {
          console.log(result);
              this.filesData = [];
              this.recId = result;
              this.showToast('Success', 'success', 'Files Uploaded successfully.');
        
      }).catch(error => {
          if(error && error.body && error.body.message) {
              this.showToast('Error', 'error', error.body.message);
          }
      }).finally(() => this.showSpinner = false );
    }else{
      this.showToast('Error', 'error', 'Please fill Both Subject & description field before Uploading Files.'); return;
   
    }
  }

  removeReceiptImage(event) {
      var index = event.currentTarget.dataset.id;
      this.filesData.splice(index, 1);
  }

  showToast(title, variant, message) {
      this.dispatchEvent(
          new ShowToastEvent({
              title: title,
              variant: variant,
              message: message,
          })
      );
  }



caseSubject(event){
let element = event.target.value;
console.log('Subject element '+element);
this.caseSub=element;
console.log('Description element75 '+element);

console.log('isCaseCreated82'+this.isCaseCreated);


}

caseDescription(event){
let element = event.target.value;
this.caseDesc=element;



}



saveButtoncaseDetails(){

console.log('this.caseDesc '+this.caseDesc+' this.caseSub '+this.caseSub);

if((this.caseSub != undefined && this.caseSub != null && this.caseSub != '' ) && (this.caseDesc != undefined  && this.caseDesc != null && this.caseDesc != '' ) ){
  console.log('inside if---168');
  this.isLoading = true;
  console.log('Line--170-->'+this.isLoading);
updateCase({
  caseId:this.recId,
  subject:this.caseSub,
  description:this.caseDesc
}).then((data)=>{
  console.log('case record Id '+JSON.stringify(data));
  console.log('case record Id '+JSON.stringify(data.Id));
  this.caseRecordId = data.Id;
  newCaseRecord({caseId: this.caseRecordId})
      
  .then((result) =>{
  //console.log('Itinerary-comp-result->'+JSON.stringify(result));
  console.log('Line--236-->'+JSON.stringify(result));
  this.NewCaseRecordDetails = result;
  console.log('Line--NewCaseRecordDetails-->'+JSON.stringify(this.NewCaseRecordDetails));
  })
  
  .catch(error => {
      console.log('error', error);
  });
  const event = new ShowToastEvent({
    title: 'Success',
    duration:' 50000',
    variant: 'success',
    message: 'TripADeal will consider your application as soon as possible. Thank you for participating in the improvement of our product',
  });
  this.dispatchEvent(event);
  this.isModalOpen = true;
  this.isLoading = false;
});
}

else{
  console.log('inside else');
  const event = new ShowToastEvent({
    title: 'Error',
    duration:' 50000',
    variant: 'error',
    message: 'Please fill Both Subject & description field Before Raise A Question.',
    
  });
  this.dispatchEvent(event);
 
}


}

NavigateToCase() {
  this.isModalOpen = false;
  let title = this.caseRecordId;
  console.log('name'+title)
  var caseview = this.viewCase+'/'+title;

console.log('caseview'+caseview);
const config = {
  type: 'standard__webPage',
  attributes: {
      url: caseview
  }
};
this[NavigationMixin.GenerateUrl](config).then(url => { window.open(caseview, "_blank") });
window.location.reload();

}


BackToSR(){
  window.location.reload();
}

closeModal() {
  // to close modal set isModalOpen tarck value as false
  window.location.reload();
  //this.isModalOpen = false;
}
handleOpenAccordion(event){
let title = event.target.title;
  console.log('name'+title)
  var caseview = this.viewCase+'/'+title;

console.log('caseview'+caseview);
const config = {
  type: 'standard__webPage',
  attributes: {
      url: caseview
  }
};
this[NavigationMixin.GenerateUrl](config).then(url => { window.open(caseview, "_blank") });
  
}

get acceptedFormats() {
return ['.pdf', '.png','.jpg','.jpeg','.txt','.docx','.attachment','.js','.cls','.apxt','.html','.zip','.csv','.xls','.xlsx','.ppt','.pptx'];
}


}