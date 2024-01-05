import { LightningElement } from 'lwc';
import getCaseDetails from '@salesforce/apex/MP_CaseCommunityLayout.caseCommunityLayout';
export default class CaseCommunityLayoutLWC extends LightningElement {
    urlId;
    CaseData;
    connectedCallback(){
    
        console.log('Record Id-->'+  window.location.href);
        console.log('UserId-->'+  this.UserId);
        var urlParameters = window.location.href;
        var urlStateParameters = urlParameters.split('case/');
        var urlIDValue = urlStateParameters[1];
        urlIDValue = urlIDValue.split('/');
        this.urlId = urlIDValue[0];
        console.log('Record Id-18->'+  this.urlId);
        getCaseDetails({CaseId:this.urlId})
        .then(result => {
            this.CaseData = result;
            this.error = undefined;
            console.log('Line--20-->'+JSON.stringify(this.CaseData));
            
        })
        .catch(error => {
            this.error = error;
            this.data = undefined;
        }); 
       
    
    }
}