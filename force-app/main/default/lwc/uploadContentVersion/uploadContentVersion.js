import { LightningElement, api, wire, track } from 'lwc';
import getLookupValues from '@salesforce/apex/CreateContentVersion.getLookupValues';
import getinitRecord from '@salesforce/apex/CreateContentVersion.getinitRecord';
import gerRecentlyCreatedRecords from '@salesforce/apex/CreateContentVersion.gerRecentlyCreatedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import uploadFile from '@salesforce/apex/CreateContentVersion.uploadFile';

export default class UploadContentVersion extends LightningElement {
    //public properties
    @api uniqueName = "Tad_Order__c";
    @api initialLookupValue = '';
    @api objectAPIName = "Tad_Order__c";
    @api displayLabelField = "Name";
    @api placeHolder = "Search Tad Order";
    @api recordLimit = 5;
    @api labelHidden = false;
    @api searchKeyWord = '';
    @api searchKeyWord1 = '';
    @api selectedRecord = {}; // Use, for store SELECTED sObject Record
    @api where = '';
    @api selectedRecordList=[];
    @api recordId;
    fileData;
    @track filename = '';
    // private properties
    isTrue=false;
    selectedRecordLabel = '';
    searchRecordList = []; // Use,for store the list of search records which returns from apex class
    message = '';
    spinnerShow = false;
    error = '';
    noRecordFound = false;
    showSpinner=false;
    showSettings=false;
    deliveryname='';
    disableDateField=true;
    notifyMe=false;
    expiry=false;
    expiryDateTime=null;
    password=false;
    isSave=true;
    @track dataid='';
    @track rows=[1];
    @track inputBoxes=[];
    connectedCallback() {

        if (this.initialLookupValue != '') {
            getinitRecord({ recordId: this.initialLookupValue, "objectAPIName": this.objectAPIName, "fieldNames": this.displayLabelField })
                .then((data) => {
                    if (data != null) {
                        console.log("getinitRecord —> ", JSON.stringify(data));
                        this.selectedRecord = data;
                        this.selectedRecordLabel = data.Name; //data[this.displayLabelField];
                        this.selectionRecordHelper();
                    }
                })
                .catch((error) => {
                    console.log("getinitRecord Error —> " + JSON.stringify(error));
                    this.error = error;
                    this.selectedRecord = {};
                });
        }
    }

    @wire(getLookupValues, { searchKeyWord: '$searchKeyWord1', objectAPIName: '$.objectAPIName', whereCondition: '$where', fieldNames: '$displayLabelField', customLimit: '$recordLimit' })
    wiredsearchRecordList({ error, data }) {
        this.spinnerShow = true;
        if (data) {
            this.spinnerShow = false;
            this.searchRecordList = JSON.parse(JSON.stringify(data));
            this.error = undefined;
            this.hasRecord();
        } else if (error) {
            console.log("getLookupValues Error 2 —> " + JSON.stringify(error));
            this.hasRecord();
            this.error = error;
            this.searchRecordList = undefined;
        }
    }

    AddRow(){
        console.log('rows '+this.rows);
        var last=this.rows.slice(-1);
        console.log('last '+last);
        var toadd=Number(last)+1;
        this.rows.push(toadd);
        console.log('afteradding '+this.rows);
        //this.searchKeyWord='';
    }

    removeRow(event){
        let rowno=event.target.getAttribute('data-id1');
        for(var i=0; i<this.rows.length; i++){
            if(this.rows[i]==rowno){
                this.rows.splice(i, 1);
            }
        }
        console.log('this.rows after splice '+this.rows);
    }

    handleClickOnInputBox(event) {
        let dataid=event.target.getAttribute('data-id');
        console.log('data-id '+dataid);
        this.dataid=dataid;
        let container = this.template.querySelector('.custom-lookup-container[data-id="' +dataid+ '"]');
        container.classList.add("slds-is-open");
        this.spinnerShow = true;
        console.log(this.where);
        console.log('this.searchKeyWord 93 '+this.searchKeyWord);
        if (typeof this.searchKeyWord1 === 'string' && this.searchKeyWord1.trim().length === 0) {
            gerRecentlyCreatedRecords({ "objectAPIName": this.objectAPIName, "fieldNames": this.displayLabelField, "whereCondition": this.where, "customLimit": this.recordLimit })
                .then((data) => {
                    if (data != null) {
                        try {
                            console.log("gerRecentlyCreatedRecords —> ", JSON.stringify(data));
                            this.spinnerShow = false;
                            this.searchRecordList = JSON.parse(JSON.stringify(data));
                            console.log('this.searchRecordList101  '+this.searchRecordList );
                            this.hasRecord();
                        } catch (error) {
                            console.log(error);
                            this.hasRecord();
                        }
                    }
                })
                .catch((error) => {
                    console.log("gerRecentlyCreatedRecords Error —> " + JSON.stringify(error));
                    this.error = error;
                });
        }else if (typeof this.searchKeyWord1 === 'string' && this.searchKeyWord1.trim().length > 0) {
            let temp = this.searchKeyWord1
            this.searchKeyWord1 = temp;
            getLookupValues({ "searchKeyWord": this.searchKeyWord1, "objectAPIName": this.objectAPIName, "whereCondition": this.where, "fieldNames": this.displayLabelField, "customLimit": this.recordLimit })
                .then((data) => {
                    if (data != null) {
                        console.log("getLookupValues —> ", JSON.stringify(data));
                        this.spinnerShow = false;
                        this.searchRecordList = JSON.parse(JSON.stringify(data));
                        console.log('this.searchRecordList122  '+this.searchRecordList );
                        this.error = undefined;
                        this.hasRecord();
                    }
                })
                .catch((error) => {
                    console.log("getLookupValues Error —> " + JSON.stringify(error));
                    this.error = error;
                    this.selectedRecord = {};
                });
        }
    }

    fireLookupUpdateEvent(value) {
        const oEvent = new CustomEvent('customLookupUpdateEvent',
            {
                'detail': {
                    'name': this.uniqueName,
                    'selectedRecord': value
                }
            }
        );
        this.dispatchEvent(oEvent);
    }

    handleKeyChange(event) {
        var dataid=event.target.getAttribute('data-id');
        console.log('dataid145 '+dataid);
        var dataid1=event.target.getAttribute('data-id1');
        console.log('dataid1 '+dataid1);
        var selectedInput = this.template.querySelector('lightning-input[data-id="' +dataid+ '"]');

        selectedInput.value=event.detail.value;
        
        console.log('149');
        this.searchKeyWord1 = event.detail.value;
        console.log(this.searchKeyWord1);
        if (typeof this.searchKeyWord1 === 'string' && this.searchKeyWord1.trim().length > 0) {
            this.searchRecordList = [];
        }
    }

    handleOnblur(event) {
        let container = this.template.querySelectorAll('.custom-lookup-container');
        for(var i=0;i<container.length; i++){
            container[i].classList.remove('slds-is-open');
        }
        //container.classList.remove('slds-is-open');
        this.spinnerShow = false;
        this.searchRecordList = [];
    }

    handleSelectionRecord(event) {
        
        var recid = event.target.getAttribute('data-recid');
        console.log("recid : ", recid);
        let container = this.template.querySelectorAll('.custom-lookup-container');
        console.log('169'+ container);
        for(var i=0; i<container.length; i++){
            container[i].classList.remove('slds-is-open');
        }
        //container.classList.remove('slds-is-open');
        this.selectedRecord = this.searchRecordList.find(data => data.Id === recid);
        this.selectedRecordList.push(this.selectedRecord);
        console.log('this.selectedRecordList '+this.selectedRecordList);
        this.selectedRecordLabel = this.selectedRecord.Name;//this.selectedRecord[this.displayLabelField];
        
        console.log(this.selectedRecord);
        console.log(this.selectedRecordLabel);
        this.fireLookupUpdateEvent(this.selectedRecord);
        this.selectionRecordHelper(this.dataid);
    }

    selectionRecordHelper(dataid) {
        var dataid=dataid;
        console.log('dataid186 '+dataid);
        console.log('this.selectedRecord '+this.selectedRecordLabel);
       // this.template.querySelector('lightning-input[data-id="' +dataid+ '"]').value = this.selectedRecord;;
        let inputBox= this.template.querySelector('lightning-input[data-id="' +dataid+ '"]');
        console.log('inputBox '+inputBox);
        inputBox.value=this.selectedRecordLabel;
        let searchicon=this.template.querySelector('.search-icon[data-id="' +dataid+ '"]');
        console.log('searchicon '+searchicon);
        searchicon.classList.add('slds-hide');
        
        let buttonRemove=this.template.querySelector('.close-button[data-id="' +dataid+ '"]');
        console.log('buttonRemove '+buttonRemove);
        buttonRemove.classList.remove('slds-hide');
        buttonRemove.classList.add('slds-show');
       
    }

    clearSelection(event) {
        let dataid=event.currentTarget.getAttribute('data-id');
        console.log('dataid '+dataid);
        let inputBox= this.template.querySelector('lightning-input[data-id="' +dataid+ '"]');
        console.log('inputBox '+inputBox);
        inputBox.value='';
        let searchicon=this.template.querySelector('.search-icon[data-id="' +dataid+ '"]');
        console.log('searchicon '+searchicon);
        searchicon.classList.remove('slds-hide');
        searchicon.classList.add('slds-show');
        let buttonRemove=this.template.querySelector('.close-button[data-id="' +dataid+ '"]');
        console.log('buttonRemove '+buttonRemove);
        buttonRemove.classList.remove('slds-show');
        buttonRemove.classList.add('slds-hide');
        /*let custom_lookup_pill_container = this.template.querySelector('.custom-lookup-pill');
        custom_lookup_pill_container.classList.remove('slds-show');
        custom_lookup_pill_container.classList.add('slds-hide');
        let search_input_container_container = this.template.querySelector('.search-input-container');
        search_input_container_container.classList.remove('slds-hide');
        search_input_container_container.classList.add('slds-show');*/
        this.fireLookupUpdateEvent(undefined);
        this.clearSelectionHelper();
    }

    clearSelectionHelper() {
        this.selectedRecord = {};
        this.selectedRecordLabel = '';
        this.searchKeyWord = '';
        this.searchRecordList = [];
    }

    hasRecord() {
        if (this.searchRecordList && this.searchRecordList.length > 0) {
            this.noRecordFound = false;
        } else {
            this.noRecordFound = true;
        }
    }

    backToHomePage(){
        console.log('backbutton');
        this.dispatchEvent(new CustomEvent('backtohomepage', {
            detail: {
                showCsvHeading: true,
                showContentTab: false
            }
        }));
    }

    openfileUpload(event) {
        const file = event.target.files[0];
        console.log('file '+file);
        this.showSettings=true;
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
            }
            console.log(this.fileData);
            this.filename=file.name;
            this.base64=base64;
        }
        reader.readAsDataURL(file)
    }

    deliveryName(event){
        console.log('event.target.value '+event.target.value);
        this.deliveryname=event.target.value;
        if(this.deliveryname!='' && this.deliveryname!=null){
            this.isSave=false;
        }else{
            this.isSave=true;
        }
        
    }

    handleCheckChange(event){
        if(event.target.checked){
            this.notifyMe=true;
        }else{
            this.notifyMe=false;
        }
    }

    handleCheck2Change(event){
        if(event.target.checked){
            this.expiry=true;
            this.disableDateField=false;
        }else{
            this.expiry=false;
            this.disableDateField=true;
        }
    }

    handleCheck3Change(event){
        if(event.target.checked){
            this.password=true;
        }else{
            this.password=false;
        }
    }

    handleDateChange(event){
        if( this.expiry==true){
            this.expiryDateTime=event.target.value;
            console.log('this.expiryDateTime '+this.expiryDateTime);
        }
        
    }

    handleClick(){
        this.inputBoxes=this.template.querySelectorAll("lightning-input");
        console.log('this.inputBoxes.length '+this.inputBoxes.length);
        let orderNos=[];
        for(var i=0; i<this.inputBoxes.length; i++){
            if(this.inputBoxes[i].value!=null){
                orderNos.push(this.inputBoxes[i].value);
            }
        }
        console.log('orderNos '+orderNos);
        const {base64, filename} = this.fileData
        this.showSpinner=true;
        uploadFile({ base64:this.base64, filename:this.filename, orderNos, deliveryname:this.deliveryname, notifyMe:this.notifyMe, expiry:this.expiry, expiryDateTime:this.expiryDateTime, password:this.password }).then(result=>{
            this.showSpinner=false;
            console.log('in success');
            this.fileData = null;
           // let title = `${filename} uploaded successfully!!`
            this.showToast('Success', this.filename + ' - Uploaded Successfully!!!', 'success', 'dismissable');
            this.filename='';
            this.showSettings=false;
            this.rows=[1];
            this.disableDateField=true;
            this.deliveryname='';
            this.notifyMe=false;
            this.expiry=false;
            this.password=false;
            this.expiryDateTime=null;
            this.isSave=true;
            //this.toast(title)
        }).catch(error => {
            console.log(error);
            console.log('in error');
            this.showSpinner=false;
            this.showToast('Error while uploading File', error.body.message, 'error', 'dismissable');
            this.filename='';
            this.showSettings=false;
            this.rows=[1];
            this.disableDateField=true;
            this.deliveryname='';
            this.notifyMe=false;
            this.expiry=false;
            this.password=false;
            this.expiryDateTime=null;
            this.isSave=true;
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

    toast(title){
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent)
    }
}