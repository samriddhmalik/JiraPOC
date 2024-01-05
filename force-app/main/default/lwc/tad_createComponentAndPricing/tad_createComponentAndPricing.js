import { LightningElement,api,track,wire } from 'lwc';
import saveComponent from '@salesforce/apex/Tad_createDepCityController.saveComponent';
import saveComponentPricing from '@salesforce/apex/Tad_createDepCityController.saveComponentPricing';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class Tad_createComponentAndPricing extends NavigationMixin(LightningElement) {
    @api addId
    @api type
    showSpinner = false;
    compId
    compPriceId
    isNextButton = false
    isStopover = false
    isAirline = false
    isAesb = false
    isDepCity = false
    isLandActivity = false
    @track componentObj = {'compName': null,
                          'depCityId': null,
                          'mercName': null,
                          'dealId':null,
                          'mptJoin': null,
                          'canPolicy': null,
                          'landActivity': null,
                          'aesb': null,
                          'mpAesb': null,
                          'stopover': null,
                          'departed': null,
                          'cName':null,
                          'airlineUpgrade':null,
                          'identifier':null,
                          'partDeadline':null,
                          'tieredCostedRate':null,
                          'compType':null,
                          'productPricing':null,
                          'compPartnerSharing':null}
    @track comPricingobj={'pricingName': null,
                          'pricingCategory': null,
                          'componentId':null,
                          'pricingCurrency': null,
                          'pricingCosted':null,
                          'pricingDeal': null,
                          'pricingGrossCost': null,
                          'pricingSoloCost': null,
                          'pricingDateFrom': null,
                          'pricingDateto': null,
                          'pricingBdateFrom': null,
                          'pricingBdateTo': null,
                          'pricingMinPax':null,
                          'pricingMaxPax':null,
                          'pricingJoin':null}
    isComponent=true
    isComponentPricing=false
    connectedCallback(){
       console.log(this.type)
       if(this.type == 'sub_stopover__c'){
        this.componentObj.stopover = this.addId;
        this.isStopover = true
       }
       if(this.type == 'AE_SB__c'){
        this.componentObj.aesb = this.addId;
        this.isAesb = true
       }
       if(this.type == 'airline_upgrade__c'){
        this.componentObj.airlineUpgrade = this.addId;
        this.isAirline = true
       }
       if(this.type == 'departure_cities__c'){
        this.componentObj.depCityId = this.addId;
        this.isDepCity = true
       }
       if(this.type == 'land_activity__c'){
        this.componentObj.landActivity = this.addId;
        this.isLandActivity = true
       }
    }
    compInputHandler(event){
        let value = event.target.value;
        let name = event.target.name;
        this.componentObj[name] = value === '' ? null : value;
        console.log(JSON.stringify(this.componentObj))
    }
    compPricingInputHandler(event){
        let value = event.target.value;
        let name = event.target.name;
        this.comPricingobj[name] = value === '' ? null :value;
        console.log(JSON.stringify(this.comPricingobj))
    }
    handleCompNext(){
        this.isNextButton = true;
        this.handleCompSave();
    }
    handleCompPriceNew(){
        this.isNew = true;
        this.handleCompPriceSave();
    }
    handleCompSave(){
        if (!this.validateCompFields()) {
            const toast = new ShowToastEvent({
                message: 'Required fields are missing.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(toast);
        }else{
        this.showSpinner = true
        saveComponent({compData:this.componentObj}).then((response)=>{
          this.compId = response;
          this.showSpinner =false
          if(this.isNextButton){
          this.isComponent = !this.isComponent
          this.isComponentPricing = !this.isComponentPricing
          }else{
            this.resetFields('.compfield');
          }
          this.comPricingobj.componentId = response;
          const evt = new ShowToastEvent({
            message: 'Component has been created successfully.',
            variant: 'success',
            title: 'Success!',
            mode: 'dismissible'
        });
        this.dispatchEvent(evt);
        }).catch((error)=>{
            this.showSpinner =false
         if(JSON.stringify(error).includes('duplicate value found')){
            const evt = new ShowToastEvent({
                message: 'Please provide unique identifier.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
        }else if(JSON.stringify(error).includes('Required fields are missing')){
            const evt = new ShowToastEvent({
                message: 'Required fields are missing.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
        }else if(JSON.stringify(error).includes('populate one of the following')){
            const evt = new ShowToastEvent({
                message: 'You can only populate one of the following: Deal, Option, Sub Option, Land Activity, AE/SB, AE/SB Accommodation, Stopover, Airline Upgrade, City.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
        }else{
            const evt = new ShowToastEvent({
                message: 'Error in creating component.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
        }
        })
    }
    }
    handleCompPriceSave(){
        if (!this.validatePricingFields()) {
            const toast = new ShowToastEvent({
                message: 'Required fields are missing.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(toast);
        }else{
        this.showSpinner = true
        saveComponentPricing({compPricingData:this.comPricingobj}).then((response)=>{
            this.compPriceId = response;
            this.showSpinner =false
            const evt = new ShowToastEvent({
                message: 'Component Pricing has been created successfully.',
                variant: 'success',
                title: 'Success!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
            if(this.isNew){
                this.resetFields('.pricingfield');
                this.isNew = !this.isNew
                }else{
                    this.dispatchEvent(evt);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            objectApiName: this.type,
                            recordId: this.addId,
                            actionName: 'view',
                        },
                    });
                    this.dispatchEvent(new CustomEvent('closetab'));
                }
            
        }).catch((error)=>{
            
            const evt = new ShowToastEvent({
                message: 'Required fields are missing.',
                variant: 'error',
                title: 'Error!',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
        })
    }
    }
    handleCancel(){
        this.dispatchEvent(new CustomEvent('cancel'));
    }
    resetFields(type){
        const inputFields = this.template.querySelectorAll(
            type
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        if(type = '.compfield'){
            for(let key in this.componentObj){
                this.componentObj[key]=null
            }
            console.log(JSON.stringify(this.componentObj))
            if(this.type == 'sub_stopover__c'){
                this.componentObj.stopover = this.addId;
            }
            if(this.type == 'AE_SB__c'){
                this.componentObj.aesb = this.addId;
            }
            if(this.type == 'airline_upgrade__c'){
                this.componentObj.airlineUpgrade = this.addId;
            }
            if(this.type == 'departure_cities__c'){
                this.componentObj.depCityId = this.addId;
            }
            if(this.type == 'land_activity__c'){
                this.componentObj.landActivity = this.addId;
            }
        }else{
            for(let key in this.comPricingobj){
                this.comPricingobj[key]=null
            }
            this.comPricingobj.componentId = this.compId;
        }
    }
    validateCompFields() {
        return [...this.template.querySelectorAll(".compfield")].reduce((validSoFar, field) => {
            return (validSoFar && field.reportValidity());
        }, true);
    }
    validatePricingFields() {
        return [...this.template.querySelectorAll(".pricingfield")].reduce((validSoFar, field) => {
            return (validSoFar && field.reportValidity());
        }, true);
    }
}