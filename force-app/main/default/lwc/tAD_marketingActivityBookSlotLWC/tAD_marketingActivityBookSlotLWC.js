import { LightningElement,api,track, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserDateTime from '@salesforce/apex/TAD_marketingActivitySearchLWC.getUserDateTime';

export default class TAD_marketingActivityBookSlotLWC extends NavigationMixin(LightningElement) {

    @api startDate;
    @api endDate;
    //@track todayDate = new Date();
    @track minStartDate ='';
    @track minEndDate ='';
    @track stDate;
    @track edDate;
    @track result;
    @track result2;
    @track isBookSlotModalOpen = true;
    @track currentdateplus1;

    @api countryValue='';
    @api channelValue='';
    @api suppliervalue='';
    @api titlevalue='';
    @api placementvalue='';
    @api Cost ;
    @api geovalue='';
    @api recurringvalue='';
    @api dateValue;
    @api channelOptions=[];
    @api SupplierOptions=[];
    @api TitleOptions=[];
    @api PlacementOptions=[];
    @api GeoOptions=[];
    @api RecurringOptions=[];

    connectedCallback() {
        console.log('startDate '+this.startDate+'endDate  '+this.endDate + ' countryValue '+this.countryValue+' channelValue '+this.channelValue+' suppliervalue '+this.suppliervalue+' titlevalue '+this.titlevalue+' placementvalue '+this.placementvalue+' Cost '+this.Cost+' geovalue '+this.geovalue+' recurringvalue '+this.recurringvalue+' dateValue '+this.dateValue);
      // var todayDate = new Date();
      if(this.startDate != null && this.endDate != null){
          this.minStartDate = this.startDate;
          console.log('this.minStartDate '+this.minStartDate);
          this.minEndDate = this.endDate;
      }else{
        getUserDateTime()
        .then(result=>{
            console.log('result'+result);
            this.minDueDate = result.CurrentDate;
            console.log('minduedate50'+this.minDueDate);
            this.currentdateplus1 = result.CurrentDatePlus1;
            console.log('startdateplus'+this.currentdateplus1);
  
          /*var parts = result.split(/[- : /]/);
          console.log('parts here '+parts);
          var d = new Date(parts[2], parts[1] - 1, parts[0],0,0,0,0);
         
          //d =  result;
          console.log('d here  '+d);
          var newd = new Date(d);
          var month = '' + (d.getMonth() + 1);
         var day = '' + d.getDate();
         var year = d.getFullYear();
  
      if (month.length < 2) 
          month = '0' + month;
      if (day.length < 2) 
          day = '0' + day;
          var stringDate = [year, month, day].join('-');
          console.log(' ISO string '+stringDate);
          var newDate = new Date(stringDate);
          console.log(' newDate '+newDate);
          console.log(' newDate  toISOString '+newDate.toISOString());
          this.minStartDate = newDate.toISOString();
  
          //console.log('this.minStartDate '+this.minStartDate);*/
  
        })
        .catch(error=>{
          this.error = error;
          console.log('error '+this.error);
         // this.contacts = undefined;
        });

      }
     
       
   
        
    }

   /* @wire(getDate,{dt:this.todayDate})
        date({data})
        { if(data){
            console.log("Data here todayDate "+JSON.stringify(data));
            this.minStartDate = JSON.stringify(data);
        }
        } */

    handleStartDateEvent(event){
        var starDate = event.target.value;
        this.stDate = new Date(event.target.value);
        console.log(' this.stDate'+ this.stDate);
        console.log(' starDate'+ starDate);
        if(starDate){
            this.startDate = starDate;
            console.log('this.startDate1'+this.startDate);
            this.minStartDate = this.startDate;
            console.log('this.minStartDate'+this.minStartDate);
        }
       
        //this.startDate = event.target.value;
    }
    handleEndDateEvent(event){
    
        var edate = event.target.value;
        this.edDate = new Date(event.target.value);
        if(edate){
        this.endDate = edate;
        console.log('this.endDate'+this.endDate);
        }
    }

    
    /* @api openBookSlotModal() {
         this.isBookSlotModalOpen = true;
     }*/
     closeBookSlotModal() {
         this.isBookSlotModalOpen = false;
     }
     submitBookSlotDetails() {
         
         this.result = this.edDate - this.stDate;
         this.result = (this.result/ (1000*60*60*24));
         
         //alert(this.result);
         this.result2 =  new Date() - this.stDate;
         this.result2 = (this.result2/ (1000*60*60*24));
         //alert(this.result2);
         
        if(this.startDate == undefined || this.startDate == null){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please select start date to procced!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }else if(this.result2 >= 1){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Select a valid date!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }else if(this.endDate != null && this.result < 0){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please select End Date later than Start Date or on Start Date!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
         }else if(this.endDate == undefined || this.endDate == null){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please select End Date later than Start Date or on Start Date!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
         }else{
            //this.isBookSlotModalOpen = false;
            const evt = new ShowToastEvent({
                title: 'You have successfully selected the slot!',
                //message: 'You have successfully selected the slot!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            this.navigateToFilterInventory();
         }
     }
     navigateToFilterInventory(){
        var compDefinition = {
            componentDef: "c:tAD_ShowFilterInventoryLWC",
            attributes: {
                startDate: this.startDate,
                endDate: this.endDate,
                countryValue: this.countryValue,
                channelOptions:this.channelOptions,
                SupplierOptions:this.SupplierOptions,
                TitleOptions: this.TitleOptions,
                PlacementOptions: this.PlacementOptions,
                Cost: this.Cost,
                GeoOptions: this.GeoOptions,
                RecurringOptions : this.RecurringOptions,
                dateValue : this.dateValue,
                channelValue: this.channelValue,
                suppliervalue: this.suppliervalue,
                titlevalue : this.titlevalue,
                placementvalue: this.placementvalue,
                geovalue: this.geovalue,
                recurringvalue: this.recurringvalue
            }
        };
        // Base64 encode the compDefinition JS object
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        });
     }
}