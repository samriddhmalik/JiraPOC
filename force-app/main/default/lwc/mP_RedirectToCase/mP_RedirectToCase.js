import { LightningElement , api} from 'lwc';
import getFeedData  from '@salesforce/apex/MP_RedirectToCaseFromFeed.parentIdFromFeed';
import NavigateToCase from '@salesforce/label/c.NavigateToCase';
import NavigateToHomePage from '@salesforce/label/c.MP_Home_Page';
import { NavigationMixin} from 'lightning/navigation';
export default class MP_RedirectToCase extends NavigationMixin(LightningElement)  {
@api recordId;
feedcommentdata;
commentBody;
caseId;
urlId;
viewCase = NavigateToCase;
backToHome = NavigateToHomePage;
isModalOpen = false;
connectedCallback(){

console.log('Record Id-->'+  window.location.href);
var urlParameters = window.location.href;
var urlStateParameters = urlParameters.split('feed/');
var urlIDValue = urlStateParameters[1];
urlIDValue = urlIDValue.split('/');
this.urlId = urlIDValue[0];
console.log('Record Id-18->'+  this.urlId);
getFeedData({feedId:this.urlId})
.then(result => {
    this.feedcommentdata = result;
    this.caseId = result[0].ParentId;
    this.error = undefined;
    console.log('Line--27-->'+JSON.stringify(this.feedcommentdata));
    console.log('Line-33-caseId-->'+JSON.stringify(this.caseId));
    
})
.catch(error => {
    this.error = error;
    this.data = undefined;
}); 

this.isModalOpen = true;
}


NavigateToCase() {
let title = this.caseId;
console.log('name-46->'+title)
var caseview = this.backToHome+'case'+'/'+title;

console.log('caseview--49-->'+caseview);
const config = {
type: 'standard__webPage',
attributes: {
    url: caseview
}
};
this[NavigationMixin.GenerateUrl](config).then(url => { window.open(caseview, "_blank") });
this.BackToSR();
}


BackToSR(){
this[NavigationMixin.Navigate]({
"type": "standard__webPage",
"attributes": {
    "url" : this.backToHome
    //"url": "https://tripadeal--merchantqa.sandbox.my.site.com/TADMerchantPortal/s/"
}
});

}

closeModal() {
this[NavigationMixin.Navigate]({
    "type": "standard__webPage",
    "attributes": {
        "url" : this.backToHome
        //"url": "https://tripadeal--merchantqa.sandbox.my.site.com/TADMerchantPortal/s/"
    }
});
}
}