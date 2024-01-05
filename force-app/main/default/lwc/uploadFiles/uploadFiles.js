import { LightningElement, track, api  } from 'lwc';
import createPaymentRecords from '@salesforce/apex/PaymentDataCreateByCSV.createPaymentRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UploadFiles extends LightningElement {

    @api recordId;
    @track showSpinner = false;
    @track isTrue = false;
    @track fileName = '';
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;
    blobVar;
    @track showCsvHeading=true;
    @track showCsvTab=false;
    @track showContentTab =false;
    @track typeOptions=[{label: "Upload CSV File", value: "Upload CSV File"},{label: "Upload Content Version", value: "Upload Content Version"} ];


    @api initialLookupValue = '';
    displayLabelField = 'Name';
    @api recordLimit = 5;
    @api labelHidden = false;
    searchKeyWord = '';
    @api selectedRecord = {}; // Use, for store SELECTED sObject Record
    @api where = '';
    selectedRecordLabel = '';
    searchRecordList = []; // Use,for store the list of search records which returns from apex class
    message = '';
    spinnerShow = false;
    error = '';
    noRecordFound = false;
    /*get acceptedFormats() {
        return ['.csv'];
    }*/

    connectedCallback(){
        console.log('loaded');
    }
    handleTypeChange(event){
        var Picklist_Value = event.target.value;
        console.log('Picklist_Value '+Picklist_Value);
        if(Picklist_Value=="Upload CSV File"){
            this.showCsvTab=true;
            console.log('clicked');
            this.showCsvHeading=false;
        }else if(Picklist_Value=="Upload Content Version"){
            this.showContentTab=true;
            console.log('clicked');
            this.showCsvHeading=false;
        }
    }
    
    backToHome(){
        this.showCsvHeading=true;
        this.showCsvTab=false;
        this.fileName='';
        this.filesUploaded=[];
    }

    backFromContent(event){
        this.showCsvHeading=event.detail.showCsvHeading;
        this.showContentTab=event.detail.showContentTab;
    }

    handleUploadFinished(event) {
        console.log('UploadFinished ');
        if (event.detail.files.length > 0) {
            console.log('Inif ');
           // this.filesUploaded = event.detail.files;
            this.filesUploaded = event.target.files;            
            console.log('filesUploaded '+JSON.stringify(this.filesUploaded));
           // this.fileName = event.detail.files[0].name;
            this.fileName = event.target.files[0].name;
            console.log('fileName '+this.fileName);
        }
    }

    handleSave() {
        if (this.filesUploaded.length > 0) {
            this.uploadHelper();
        } else {
            this.fileName = 'Please select a CSV file to upload!!';
            this.showToast('Error while uploading File', error.body.message, 'error', 'dismissable');
        }
    }

    uploadHelper() {
        this.file = this.filesUploaded[0];
        console.log('this.file '+JSON.stringify(this.file));
        if (this.file.size > this.MAX_FILE_SIZE) {
            console.log('File Size is too long!');
            return;
        }
        this.showSpinner = true;
        console.log("Before fileReader");
        
        this.fileReader = new FileReader();
        console.log('54');
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            console.log('fileContents '+this.fileContents);
            this.saveToFile();
        });
        this.fileReader.readAsText(this.file);
        this.showSpinner=false;

    }

    saveToFile() {
        
        createPaymentRecords({strFileName: this.fileName, base64Data: JSON.stringify(this.fileContents)})
            .then(result => {
                console.log(result);
                this.data = result;
                this.fileName = this.fileName + ' - Uploaded Successfully';
                this.isTrue = false;
                this.showSpinner = false;
                this.showToast('Success', this.file.name + ' - Uploaded Successfully!!!', 'success', 'dismissable');
            })
            .catch(error => {
                console.log(error);
                this.showToast('Error while uploading File', error.body.message, 'error', 'dismissable');
            });
    }


    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}