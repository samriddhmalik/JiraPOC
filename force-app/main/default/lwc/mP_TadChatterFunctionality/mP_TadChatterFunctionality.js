import { LightningElement, api, wire, track } from "lwc";
import getFeedData from "@salesforce/apex/MP_FeedCommentTriggerHandler.feedcommentfromcase";
import insertFeedComment from "@salesforce/apex/MP_FeedCommentTriggerHandler.insertFeedComment";
import getCaseDetails from '@salesforce/apex/MP_CaseCommunityLayout.caseCommunityLayout';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";
import Id from "@salesforce/user/Id";
const MAX_FILE_SIZE = 2097152;
export default class MP_TadChatterFunctionality extends LightningElement {
  @api recordId;
  feedcommentdata;
  insertCommentData = false;
  commentBody;
  caseId;
  urlId;
  urlId1;
  UserId = Id;
  CaseStatus = false;
  @track filesData = [];

  connectedCallback() {
    //console.log('Record Id-->'+  window.location.href);
    //console.log('UserId-->'+  this.UserId);
    var urlParameters = window.location.href;
    var urlStateParameters = urlParameters.split("case/");
    var urlIDValue = urlStateParameters[1];
    urlIDValue = urlIDValue.split("/");
    this.urlId = urlIDValue[0];
    console.log("Record Id-18->" + this.urlId);
    getFeedData({ ParentId: this.urlId })
      .then((result) => {
        this.feedcommentdata = result;
        this.feedcommentdata.reverse();
        this.error = undefined;
        console.log("Line--27-->" + JSON.stringify(this.feedcommentdata));
      })
      .catch((error) => {
        this.error = error;
        this.data = undefined;
      });


      var urlParameters1 = window.location.href;
      var urlStateParameters = urlParameters1.split('case/');
      var urlIDValue1 = urlStateParameters[1];
      urlIDValue1 = urlIDValue1.split('/');
      this.urlId1 = urlIDValue1[0];
      console.log('Record Id-18->'+  this.urlId);
      getCaseDetails({CaseId:this.urlId})
      .then(result => {
          this.CaseData = result[0].Status;
          if(this.CaseData == 'New'){
this.CaseStatus = true;
          }
          this.error = undefined;
          console.log('Line--50-->'+JSON.stringify(this.CaseData));
          console.log('Line--55-->'+JSON.stringify(this.CaseStatus));
          
      })
      .catch(error => {
          this.error = error;
          this.data = undefined;
      }); 
  }

  @wire(getRecord, { recordId: "$recordId" })
  getRequisition({ data }) {
    // console.log("RecordId--34-->" + data);
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

  handleChange(event) {
    let element = event.target.value;
    //console.log('Line--23-->'+element);
    this.commentBody = element;
  }

  handleClick() {
    console.log("parentId--34->" + this.urlId);
    //console.log("commentBody--35->" + this.commentBody);
  console.log('Comment ='+this.commentBody);
  console.log('filedata ='+this.filedata);
  if((this.commentBody == undefined || this.commentBody == '') && (this.filesData == undefined || this.filesData == '')){
     this.showToast('Error', 'error', 'Please enter comment');
  }
  else if(((this.commentBody != undefined)  && (this.filesData == '' || this.filesData == undefined))
  || ((this.commentBody == undefined || this.commentBody == '') && (this.filesData != '' || this.filesData !=undefined))
  || ((this.commentBody != undefined || this.commentBody != '') && (this.filesData != '') || this.filesData !=undefined)){
    
  console.log('Comment has been entered');
  /*if((this.filesData != '' || this.fileData!= && this.filesData.length >10){
    this.showToast('Error', 'error', 'Only 10 files can be attached!');
  }
  else{*/

    insertFeedComment({
      parentId: this.urlId,
      commentBody: this.commentBody,
      filedata: JSON.stringify(this.filesData)
    }).then((data) => {
      this.insertCommentData = true;
      console.log("commentBody-->" + JSON.stringify(data));
      /*const event = new ShowToastEvent({
        title: "Success",
        duration: " 50000",
        variant: "success",
        message: data
        // message: 'Thank you..!',
      });
      this.dispatchEvent(event);*/
      window.location.reload();
    });
  }
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
        //Below code for single file otherwise remove below line to add multiple files  
        this.filesData = []; 
        this.filesData.push({
          fileName: file.name,
          fileContent: fileContents
        });
      };
      reader.readAsDataURL(file);
    }
  }
}

removeReceiptImage(event) {
  var index = event.currentTarget.dataset.id;
  this.filesData.splice(index, 1);
}

downloadFile(event) {
  /*const iframe = this.template.querySelector("iframe");
  iframe.style.background = "red";
  iframe.contentWindow.addEventListener("click", Handler);

  function Handler() {
    console.log("works");
  }*/
  console.log("onLoad =" + JSON.stringify(event.currentTarget.dataset.Id));
}
}