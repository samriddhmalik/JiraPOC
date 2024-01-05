import { LightningElement , wire, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDepartureDatesCall from '@salesforce/apex/linkProxyDTLwithNewDT.getDepartureDatesApex';
import getDTLRecordsCall from '@salesforce/apex/linkProxyDTLwithNewDT.getFilteredDTLList';
import getdoInitCall from '@salesforce/apex/linkProxyDTLwithNewDT.doInitDefaultData';
import createDtRecordCall from '@salesforce/apex/linkProxyDTLwithNewDT.createDtRecordsApex';
import createDtRecordDraftCall from '@salesforce/apex/linkProxyDTLwithNewDT.createDtRecordDraftCall';

export default class LinkProxyDTLwithNewDT extends LightningElement {
    
    @api recordId;
    @track defaultData={"companyId":"","dateFrom":"","dateTo":"","dealId":"","departuredateId":"","difference":0,"invoiceDate":"","invoiceNumber":"","merchantId":"","merchantName":"","selectedDTLAmount":0,"subTotal":0,"totalAmount":0,"totalGST":0,"orderNumber":""};
    showDtlList = false;
    showInvoice = '';
    depDateList = [];
    DTLList = [];
    DTLListOriginalClone = [];
    DTLListAllocated = [];
    companyList = [];
    showAllocated = false;
    isDraft = false;
    draftRecId ='';
    @track isLoading=false;

    connectedCallback() {
        console.log('recordId'+this.recordId)
        getdoInitCall({merchantId : this.recordId})
        .then((result) =>{
            if(result.merchantType =='Multi Line Expense'){
                this.showInvoice = true;
                let today = new Date().toISOString().slice(0, 10)
                console.log('result899'+JSON.stringify(result) );
                this.defaultData.dateFrom = today;
                this.defaultData.dateTo = today;
                this.defaultData.invoiceDate = today;
                this.defaultData.merchantId = result.merchantId;
                this.defaultData.merchantName = result.merchantName;
                this.companyList=result.companyValues;
                if(result.draftDtAndDtlsRecs.draftExist==true){
                    this.isDraft=true;
                    console.log('FinalId'+result.draftDtAndDtlsRecs.draftRecId);
                    this.draftRecId=result.draftDtAndDtlsRecs.draftRecId;
                    this.defaultData.dateFrom = result.draftDtAndDtlsRecs.filterPageDraft.dateFrom;
                    this.defaultData.dateTo = result.draftDtAndDtlsRecs.filterPageDraft.dateTo;
                    this.defaultData.totalGST = result.draftDtAndDtlsRecs.filterPageDraft.totalGST;
                    this.defaultData.totalAmount = result.draftDtAndDtlsRecs.filterPageDraft.totalAmount;
                    this.defaultData.selectedDTLAmount = result.draftDtAndDtlsRecs.filterPageDraft.selectedDTLAmount;
                    this.defaultData.invoiceNumber = result.draftDtAndDtlsRecs.filterPageDraft.invoiceNumber;
                    this.defaultData.companyId = result.draftDtAndDtlsRecs.filterPageDraft.companyId;
                    this.DTLList = result.draftDtAndDtlsRecs.dtlRecordsDraft;
                    this.DTLListAllocated = result.draftDtAndDtlsRecs.allocatedDtl; 
                    this.showDtlList=true;
                }
            }else{
                this.showInvoice = false; 
            }
        })
        .catch((error) => {  
            console.log('message'+JSON.stringify(error));
            this.error = error;   
           });  
      }

    setInvoiceNumber(event) {
        this.defaultData.invoiceNumber = event.detail.value;
    }

    setInvoiceDate(event) {
        this.defaultData.invoiceDate = event.detail.value;
    }

    setSubTotal(event) {
        this.defaultData.subTotal = event.detail.value;
    }

    setTotalGST(event) {
        this.defaultData.totalGST = event.detail.value;
    }

    setTotalAmount(event) {
        this.defaultData.totalAmount = event.detail.value;
        this.defaultData.difference=(event.detail.value) - (this.defaultData.selectedDTLAmount);
    }

    setTransactionDateFrom(event) {
        this.defaultData.dateFrom = event.detail.value;
    }

    setTransactionDateTo(event) {
        this.defaultData.dateTo = event.detail.value;
    }

    setCompanyRecord(event) {
        this.defaultData.companyId = event.detail.value;
    }

    setDealRecord(event) {
        this.defaultData.dealId = event.detail.value[0];
        if(this.defaultData.dealId!=''){
            this.getDDRecords();
        }
    }

    setDDRecord(event) {
        this.defaultData.departuredateId = event.detail.value;
    }

    setOrderNumber(event) {
        this.defaultData.orderNumber = event.detail.value;
    }

    clearFilters() {
        this.defaultData.dealId='';
        this.defaultData.departuredateId='';
        this.defaultData.orderNumber='';
        //this.DTLList=[];
        //this.showDtlList=false; 
    }

    getDDRecords(){
        console.log('dealrec'+this.defaultData.dealId);
        getDepartureDatesCall({dealId : this.defaultData.dealId})
        .then((result) =>{
            console.log('Result'+JSON.stringify(result));
            if (result.length===0) {  
                this.depDateList = [];  
                this.message = "No Records Found"; 
               } else {  
                this.depDateList = result; 
                this.message = "";  
               }  
               this.error = undefined;
        })
        .catch((error) => {  
            console.log('message'+JSON.stringify(error));
            this.error = error;   
           });    
    }

    getDTLRecords(){

        getDTLRecordsCall({dataRec : this.defaultData,allocatedDtl :this.DTLListAllocated})
        .then((result) =>{
            console.log('Result'+JSON.stringify(result));
            this.showAllocated = false;
            if (result.length===0) {  
                this.DTLList = [];  
                this.showDtlList=false; 
                this.showToast('Info','No Records Exist, Please try different filters.','info'); 
               } else {  
                this.DTLList = result; 
                this.showDtlList=true;  
                this.message = "";  
               }  
               this.error = undefined;
        })
        .catch((error) => {  
            this.error = error;   
           });    
    }

    showAllocatedDTL(event) {
        if(event.target.checked==true){
            this.showAllocated = true;
            this.DTLListOriginalClone=this.DTLList;
            this.DTLList=this.DTLListAllocated;
        }else{
            this.showAllocated = false;
            this.DTLList=this.DTLListOriginalClone; 
        }
    }

    setAllocation(event) {

        var indexPosition = event.currentTarget.name;
        var DTLList1 =  JSON.parse(JSON.stringify(this.DTLList)); // Visible List
        var DTLList2 =  JSON.parse(JSON.stringify(this.DTLListOriginalClone)); // Clone List
        var DTLListAllocated1 = JSON.parse(JSON.stringify(this.DTLListAllocated)); // Allocated Data
        //console.log('DtlListAllocated'+JSON.stringify(DTLListAllocated1));
        
        var showAllocated = this.showAllocated;
        if(showAllocated==true){
            if(event.target.checked==true){
                // Updates Screen values
                DTLList1[indexPosition].allocation=true;
                DTLList1[indexPosition].invoiceAmount=DTLList1[indexPosition].amount;
                
                // Updates Original Record 
                for(var i = 0; i < DTLList2.length; i++){
                    if(DTLList2[i].Id==DTLList1[indexPosition].Id){
                        DTLList2[i].allocation=true; 
                        DTLList2[i].invoiceAmount=DTLList2[i].amount;
                        break;
                    }
                }

                // Updates Allocated Data
                DTLListAllocated1.push(DTLList1[indexPosition]);
            }else{
                // Updates Screen values
                DTLList1[indexPosition].allocation=false; 
                DTLList1[indexPosition].invoiceAmount=0;
                // Updates Original Record 
                for(var i = 0; i < DTLList2.length; i++){
                    if(DTLList2[i].Id==DTLList1[indexPosition].Id){
                        DTLList2[i].allocation=false; 
                        DTLList2[i].invoiceAmount=0;
                        break;
                    }
                }
                // Updates Allocated Data
                DTLListAllocated1.splice(indexPosition, 1);
            }
        }else{
            if(event.target.checked==true){
                // Updates Screen values
                DTLList1[indexPosition].allocation=true;
                DTLList1[indexPosition].invoiceAmount=DTLList1[indexPosition].amount;

                // Updates Allocated Data
                DTLListAllocated1.push(DTLList1[indexPosition]);
            }else{
                // Updates Screen values
                DTLList1[indexPosition].allocation=false; 
                DTLList1[indexPosition].invoiceAmount=0;

                 // Updates Allocated Data
                for(var i = 0; i < DTLListAllocated1.length; i++){
                    if(DTLListAllocated1[i].Id==DTLList1[indexPosition].Id){
                        DTLListAllocated1.splice(i, 1);
                        break;
                    }
                }
            }
        }
       // console.log('DTLList2'+JSON.stringify(DTLList2));
        this.DTLList = DTLList1;
        this.DTLListOriginalClone=DTLList2;
       // console.log('DtlListAllocated1'+JSON.stringify(DTLListAllocated1));
        this.DTLListAllocated = DTLListAllocated1;
        this.populateDtlAmount();
    
    }

    setInvoiceAmount(event) {
        var indexPosition = event.currentTarget.name;
        var DTLList1 =  JSON.parse(JSON.stringify(this.DTLList));
        DTLList1[indexPosition].invoiceAmount=event.detail.value;
        this.DTLList = DTLList1;
        this.populateDtlAmount();

        var showAllocated = this.showAllocated;
       // if(showAllocated==true){
        var DTLListAllocated1 = JSON.parse(JSON.stringify(this.DTLListAllocated));
        for(var i = 0; i < DTLListAllocated1.length; i++){
           
            if(DTLListAllocated1[i].Id==DTLList1[indexPosition].Id){
                DTLListAllocated1[i].invoiceAmount=event.detail.value;
                break;
            }
        }
        
        this.DTLListAllocated = DTLListAllocated1;
       // } 
    }

    populateDtlAmount(event) {
        var creditAmount = 0 ;
        var DTLList1 = this.DTLList;
        for(var i = 0; i < DTLList1.length; i++){
         if(DTLList1[i].allocation==true){
            creditAmount= Number(creditAmount)+ Number(DTLList1[i].invoiceAmount);
         }
        }
        this.defaultData.selectedDTLAmount = creditAmount;
        this.defaultData.difference=Number(this.defaultData.totalAmount) - Number(creditAmount);
    }

    createDTRecordDraft(event) {
        this.isLoading = true;
        var draftId = '';
        if(this.isDraft==true){
            draftId=this.draftRecId;
        }
        console.log('draftRecId'+this.draftRecId);
        createDtRecordDraftCall({dtlrecs : this.DTLList,dataRec : this.defaultData,draftId : draftId})
        .then((result) =>{
            this.isLoading = false;
            this.showToast('Success','Deal Transaction Saved Succesfully.','success'); 
            this.closeQuickAction();
        })
        .catch((error) => { 
            this.isLoading = false; 
            console.log('message'+JSON.stringify(error));
            this.error = error;   
           });  
    }

    validateDataAndCreateDt(event) {
        if(this.defaultData.difference!=0){
            this.showToast('Error','TotalAmount and Selected Dtl Amount Should match','error');
        }else if(this.defaultData.difference==0){
            this.createDTRecord(); 
        }   

    }   
    createDTRecord(event) {
        this.isLoading = true;
        var draftId = '';
        if(this.isDraft==true){
            draftId=this.draftRecId;
        }
        createDtRecordCall({dtlrecs : this.DTLListAllocated,dataRec : this.defaultData,draftId : draftId})
        .then((result) =>{
            this.isLoading = false;
            this.showToast('Success','Deal Transaction Created Succesfully.','success'); 
            this.closeQuickAction();
        })
        .catch((error) => {  
            this.isLoading = false;
            console.log('message'+JSON.stringify(error));
            this.error = error;   
           });  
    }

    closeQuickAction() {
        const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
   }  
   
   showToast(title,message,variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
   }

}