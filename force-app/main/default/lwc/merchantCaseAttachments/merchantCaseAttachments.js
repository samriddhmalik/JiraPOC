import { LightningElement,api,track } from 'lwc';
import getFeedData from "@salesforce/apex/MP_MerchantCaseAttachments.getMerchantCaseAttachments";
import Id from "@salesforce/user/Id";
import uploadFile from "@salesforce/apex/MP_MerchantCaseAttachments.uploadFiles";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
 import {refreshApex} from '@salesforce/apex';

const MAX_FILE_SIZE = 2097152;
export default class MerchantCaseAttachments extends LightningElement {
@api recordId;
@track feedcommentdata;
caseId;
urlId;
urlId1;
UserId = Id;
@track isUploaded = false;
@track filesData = [];

connectedCallback() {
  var urlParameters = window.location.href;
  var urlStateParameters = urlParameters.split("case/");
  var urlIDValue = urlStateParameters[1];
  urlIDValue = urlIDValue.split("/");
  this.urlId = urlIDValue[0];
  console.log("Record Id-18->" + this.urlId);
  getFeedData({ parentID: this.urlId })
    .then((result) => {
      this.feedcommentdata = result;
      this.feedcommentdata.reverse();
      this.error = undefined;
      console.log("Line--27-->" + JSON.stringify(this.feedcommentdata));
    })
    .catch((error) => {
      this.error = error;
      this.data = undefined;
      console.log('ERROR'+JSON.stringify(this.error));
    });

  var urlParameters1 = window.location.href;
  var urlStateParameters = urlParameters1.split("case/");
  var urlIDValue1 = urlStateParameters[1];
  urlIDValue1 = urlIDValue1.split("/");
  this.urlId1 = urlIDValue1[0];
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

removeReceiptImage(event) {
  var index = event.currentTarget.dataset.id;
  this.filesData.splice(index, 1);
}

handleFileUploaded(event) {
  if (event.target.files.length > 0) {
    for (var i = 0; i < event.target.files.length; i++) {
      if (event.target.files[i].size > MAX_FILE_SIZE) {
        this.showToast(
          "Error!",
          "error",
          "File size exceeded the upload size limit."
        );
        return;
      }
      let file = event.target.files[i];
      let reader = new FileReader();
      reader.onload = (e) => {
        console.log('File Details ='+reader.result);
        var fileContents = reader.result.split(",")[1];
        console.log('fileContents ='+fileContents);
        console.log('File Name ='+file.name);
        //Below code for single file otherwise remove below line to add multiple files  
     //   this.filesData = []; 
        this.filesData.push({
          fileName: file.name,
          fileContent: fileContents
        });
        console.log('FileData ='+JSON.stringify(this.filesData));
      };
      reader.readAsDataURL(file);
      
    console.log('case ID :'+this.urlId);
    console.log('filedata :'+JSON.stringify(this.filesData)); 

   
    }
  }
}


handleClick() {
 this.isUploaded = true;
 if(this.filesData.length > 0){
  if(this.filesData.length > 10){
  this.showToast("Error!","error","Cannot upload more than 10 files." );
  }else{
   uploadFile({
    parentId: this.urlId,
    filedata: JSON.stringify(this.filesData)
  }).then((data) => {
  this.isUploaded = false;
  console.log('DATA ='+data);
  this.filesData = [];

  
  getFeedData({ parentID: this.urlId })
    .then((result) => {
      this.feedcommentdata = result;
      this.feedcommentdata.reverse();
      this.error = undefined;
      console.log("Line--27-->" + JSON.stringify(this.feedcommentdata));
      refreshApex(this.feedcommentdata);
    })
    .catch((error) => {
      this.error = error;
      this.data = undefined;
      console.log('ERROR'+JSON.stringify(this.error));
    });
  });
}
}else{
        this.isUploaded = false;
        this.showToast(
          "Error!",
          "error",
          "Please select file(s) to upload."
        );

}
  }
}