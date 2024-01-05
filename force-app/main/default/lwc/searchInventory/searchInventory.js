import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import filterInventoriesListOnLoad from '@salesforce/apex/SearchInventoryController.filterInventoriesListOnLoad';
import fetchSearchvalues from '@salesforce/apex/SearchInventoryController.retriveInventoriesfromObject';
import fetchdeales from '@salesforce/apex/SearchInventoryController.fetchDealvalues';
import fetchSearchdeales from '@salesforce/apex/SearchInventoryController.retriveDealsfromObject';
import SearchInventoryHint from '@salesforce/label/c.SearchInventoryHint';
import updateActivityRecord from '@salesforce/apex/SearchInventoryController.updateActivityRecord';
import ActivityRecordOnLoad from '@salesforce/apex/SearchInventoryController.ActivityRecordOnLoad';
import ActivityRecordOnLoad1 from '@salesforce/apex/SearchInventoryController.ActivityRecordOnLoad1';

import getUserDateTime from '@salesforce/apex/TAD_marketingActivitySearchLWC.getUserDateTime';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import UnsavedActivityRecords from '@salesforce/apex/SearchInventoryController.UnsavedActivityRecords';
import getwrapperUnsavedActivity from '@salesforce/apex/SearchInventoryController.getwrapperUnsavedActivity';
import filterDeals from '@salesforce/apex/SearchInventoryController.filterDealsfromObject';




export default class SearchInventory extends NavigationMixin(LightningElement) {

    @api startDate;
    @api endDate;
    @api countryValue = '';
    @api channelValue = '';
    @api suppliervalue = '';
    @api titlevalue = '';
    @api placementvalue = '';
    @api Cost;
    @api geovalue = '';
    @api recurringvalue = '';
    @api dateValue;
    @api channelOptions = [];
    @api SupplierOptions = [];
    @api TitleOptions = [];
    @api PlacementOptions = [];
    @api GeoOptions = [];
    @api RecurringOptions = [];

    @api inputClone;

    @track isModalOpen = false;
    @track isStartAndEndDate = false;
    @track isOutsideRange = true;
    @track isCustomDate = false;
    @track dueDate = '';
    @track minDueDate;
    @track channelIdpart = undefined;
    @track DealIdpart = undefined;
    @track eligibleDeals = null;
    @track data = [];
    @track channels;
    @track channelsForBackup = null;
    @track errorMsg = '';
    @track deals;
    @track isDateVisible = false;
    @track forInventryEvent;
    @track currentdateplus1;

    @track inventoryIds;
    @track DealIds;
    @track searchDealValue;
    @track inventoryIdvsChannel = [];
    @track DealDataFetch = [];
    @track initDealData = [];
    searchValue = '';
    searchDealValue = '';
    label = {
        SearchInventoryHint
    };
    childIndex = '';
    parentIndex = '';
    parentIndexForSaved = '';
    childIndexForSaved = '';
    // wrappersavedActivityChecked = [];

    //  wrapperUsavedActivityChecked = [];
    // wrapperSavedActivityAftrCancel;
    dealList = [];

    @track dueTime = '';
    @track custom_date = null;
    @track startDateForCheck;
    @track endDateForCheck;
    @track invstartDate;
    @track invendDate;
    @track invDate;
    //@api wrapperUnsavedActivity;/****************Lwc*************/
    //@api WrapperSavedActivity;/**********searchInventory*******************/

    // @track wrapperUnsavedActivityAftrCancel=[];


    @track wrapperUnsavedActivity;
    @track WrapperSavedActivity;
    @track wrapperUsavedActivityChecked; /******Wrapper*********/
    @track wrappersavedActivityChecked;/***********Lists******************/
    @track wrapperUnsavedActivityAftrCancel;/*****To Fetch From************************/
    @track wrapperSavedActivityAftrCancel;/********Parent*********************/

    dealStatusvalue = '';
    durationValue = '';
    durationOptionsForDeal = [];

    get optionsForDealStatus() {
        return [
            { label: '-None-', value: '' },
            { label: 'Awaiting Deal Draft', value: 'Awaiting Deal Draft' },
            { label: 'Published Deal', value: 'Published' }

        ];
    }

    get disableDuration() {
        console.log('here in this');
        if (this.dealStatusvalue != "") {
            return false;
        } else {
            return true;
        }
        return false;
    }

    connectedCallback() {
        console.log('startDate in searchInventory--> ' + this.startDate + 'endDate  ' + this.endDate + ' countryValue ' + this.countryValue + ' channelValue ' + this.channelValue + ' suppliervalue ' + this.suppliervalue + ' titlevalue ' + this.titlevalue + ' placementvalue ' + this.placementvalue + ' Cost ' + this.Cost + ' geovalue ' + this.geovalue + ' recurringvalue ' + this.recurringvalue + ' dateValue ' + this.dateValue);
        //this.WrapperSavedActivity = undefined;
        var dateValueNew = new Date(this.dateValue);
        this.dateValue = dateValueNew;
        this.startDateForCheck = this.startDate;
        this.endDateForCheck = this.endDate;
        console.log(' countryValue in fetchDeals' + this.countryValue);
        this.dofetchvalues();
        this.dofetchdeals();
        //this.doFetchActivityOnLoad();


    }

    handleChangeDealStatus(event) {
        this.dealStatusvalue = event.detail.value;
        this.isCustomDate = false;
        this.custom_date = null;
        this.durationValue = undefined;
        console.log('this.dealStatusvalue  ' + this.dealStatusvalue);
        if (this.dealStatusvalue == 'Published') {
            this.durationValue = 'THIS_WEEK';
            const option = [

                { label: 'This Month', value: 'THIS_MONTH' },
                { label: 'This Week', value: 'THIS_WEEK' },
                { label: 'This Fortnight', value: 'This_Fortnight' },
                { label: 'Select a Date', value: 'Custom' }
            ];
            this.durationOptionsForDeal = option;

            this.doFilterDeals();

        } else if (this.dealStatusvalue == 'Awaiting Deal Draft') {
            const option = [

                { label: 'Next 7 Days', value: 'Next7Days' },
                { label: 'Next 15 Days', value: 'Next15Days' },
                { label: 'This Month', value: 'THIS_MONTH' }
            ];
            this.durationOptionsForDeal = option;
            this.durationValue = 'Next7Days';
            this.doFilterDeals();

        } else {
            this.durationOptionsForDeal = undefined;
            this.durationValue = undefined;
            var initDeals = JSON.parse(JSON.stringify(this.initDealData));

            this.deals = initDeals;
        }



    }

    repopulateTableData(event) {

        console.log('second part');
        var filters = []
        filters = event.detail.wrapperObj;
        console.log('filters=========>', filters);
        this.wrapperUnsavedActivity = filters;

        console.log('this.forInventryEvent=============>', this.forInventryEvent);


        //this.doFetchActivityOnLoad(this.forInventryEvent);
        ActivityRecordOnLoad1({ InventoryOnLoadList: this.forInventryEvent })
            .then((result) => {
                console.log('result=============>', result);

                console.log('in this blog');
                let result2 = this.calculateafterUnsaved(result);

                this.WrapperSavedActivity = result2;



            }).catch(error => {
                // this.resultsum = undefined;
                console.log('error-- ' + JSON.stringify(error));
            });


    }


    repopulateTableDataSaved(event) {

        console.log('second part');
        var filters = []
        filters = event.detail.wrapperObj;
        console.log('filters=========>', filters);
        //   this.wrapperUnsavedActivity = filters;

        //console.log('this.forInventryEvent=============>',this.forInventryEvent);


        //this.doFetchActivityOnLoad(this.forInventryEvent);
        ActivityRecordOnLoad1({ InventoryOnLoadList: this.forInventryEvent })
            .then((result) => {
                console.log('result=============>', result);

                console.log('in this blog');
                let result2 = this.calculateafterUnsaved(result);


                this.WrapperSavedActivity = result2;



            }).catch(error => {
                // this.resultsum = undefined;
                console.log('error-- ' + JSON.stringify(error));
            });


    }


    handledeleteunsavedactivity(event) {
        console.log('second part');
        var filters = []
        filters = event.detail.wrapperObj;
        console.log('filters=========>', filters);
        this.wrapperUnsavedActivity = filters;

    }

    handledeletesavedactivity(event) {
        console.log('second part');
        var filters = []
        filters = event.detail.wrapperObj;
        console.log('filters=========>', filters);
        this.WrapperSavedActivity = filters;

    }

    handleChangeDealDuration(event) {
        this.durationValue = event.detail.value;
        console.log('this.durationValue ' + this.durationValue);
        if (this.durationValue != '' && this.durationValue != 'Custom') {
            this.custom_date = null;
            this.isCustomDate = false;
            this.doFilterDeals();
        } else if (this.durationValue == 'Custom') {
            this.isCustomDate = true;
        }
    }

    doFilterDeals() {
        filterDeals({ filterType: this.durationValue, DealStatus: this.dealStatusvalue, listOfEligibleDeals: this.eligibleDeals, customdate: this.custom_date })
            .then((result) => {
                console.log('this.dealsList--1-->' + JSON.stringify(result));
                this.deals = result;


            })
            .catch(error => {
                this.resultsum = undefined;
                console.log('error-- ' + JSON.stringify(error));
            });
    }




    // update searchValue var when input field value change
    searchKeyword(event) {
        this.searchValue = event.target.value;
        console.log(' this.searchValue   ' + this.searchValue);
        event.preventDefault();
        if (this.searchValue != null) {
            fetchSearchvalues({ inventoryVal: this.searchValue })
                .then(result => {

                    this.channels = result;

                })
                .catch(error => {
                    console.log('Error ' + error);
                })
        } else {
            this.channels = this.channelsForBackup;
        }

    }

    searchDealKeyword(event) {
        this.searchDealValue = event.target.value;
        console.log('this.searchDealValue ' + this.searchDealValue);


        if (this.searchDealValue != '') {

            fetchSearchdeales({ dealVal: this.searchDealValue })
                .then(result => {

                    this.deals = result;

                })
                .catch(error => {
                    console.log('Error ' + error);
                })
        } else {
            console.log('this.initDealData  ' + JSON.stringify(this.initDealData));
            var initDeals = JSON.parse(JSON.stringify(this.initDealData));
            //  this.deals = undefined;
            this.deals = initDeals;
        }

    }




    //getUserDateTime()
    /*
     checkAll(event){
         var test = event.target.checked;
         console.log(' test '+test);
         var savedOrUnsaved = event.target.getAttribute('name');
 
         console.log('name');
         let i;
         if(savedOrUnsaved.includes('checkAllforUnsaved')){
             console.log('here in unsaved')
             let checkboxes = this.template.querySelectorAll('[name="checkForUnsaved"]');
 
             let tempWrapperList = JSON.parse(JSON.stringify(this.wrapperUnsavedActivity));
 
             if (test == true) {
                 
             
                 console.log('checkboxes '+checkboxes.length);
                 for (i = 0; i < checkboxes.length; i++) {
                     checkboxes[i].checked = event.target.checked;
                 }
 
                 for(var j=0; j < tempWrapperList.length; j++){
                     for(var k=0; k < tempWrapperList[j].unSavedRecordsList.length; k++){
                         tempWrapperList[j].unSavedRecordsList[k].CheckOrUncheck = true;
                          this.wrapperUnsavedActivity = tempWrapperList;
                          this.wrapperUsavedActivityChecked = tempWrapperList;
                     }
                 }
 
             } else {
                 for ( i = 0; i < checkboxes.length; i++) {
                     console.log(i)
                     if (checkboxes[i].type == 'checkbox') {
                         checkboxes[i].checked = event.target.checked;
                     }
                 }
 
                 for(var j=0; j < tempWrapperList.length; j++){
                     for(var k=0; k < tempWrapperList[j].unSavedRecordsList.length; k++){
                         tempWrapperList[j].unSavedRecordsList[k].CheckOrUncheck = false;
                          this.wrapperUnsavedActivity = tempWrapperList;
                          this.wrapperUsavedActivityChecked = tempWrapperList;
                     }
                 }
 
             }
         }
 
          if(savedOrUnsaved.includes('checkAllforSaved')){
             console.log('here in saved')
             let checkboxes = this.template.querySelectorAll('[name="checkForSaved"]');
             let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));
                 if (test == true) {
                
                     console.log('checkboxes '+checkboxes.length);
                     for ( i=0; i < checkboxes.length; i++) {
                         checkboxes[i].checked = event.target.checked;
                     }
                     
 
                     for(var j=0; j < tempWrapperList.length; j++){
                         for(var k=0; k < tempWrapperList[j].unSavedRecordsList.length; k++){
 
                             tempWrapperList[j].unSavedRecordsList[k].CheckOrUncheck = true;
                              this.wrappersavedActivityChecked = tempWrapperList;
                         }
                     }
                     
                 } else {
 
                     for ( i = 0; i < checkboxes.length; i++) {
                         console.log(i)
                         if (checkboxes[i].type == 'checkbox') {
                             checkboxes[i].checked = event.target.checked;
                         }
                     }
 
                     for(var j=0; j < tempWrapperList.length; j++){
                         for(var k=0; k < tempWrapperList[j].unSavedRecordsList.length; k++){
                             tempWrapperList[j].unSavedRecordsList[k].CheckOrUncheck = false;
 
                              this.wrappersavedActivityChecked = tempWrapperList;
                         }
                     }
                 }
         }
         
     }*/
    /*
     check(event){
         
             if(event.target.name == 'checkForSaved'){
                 var childIndexForSaved = event.target.getAttribute('data-id2');
                 
                 var parentIndexForSaved = event.target.getAttribute('data-id');
                 console.log('childIndexForSaved  '+childIndexForSaved+' & parentIndexForSaved '+parentIndexForSaved);
                 let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));
 
                 tempWrapperList[parentIndexForSaved].unSavedRecordsList[childIndexForSaved].CheckOrUncheck = event.target.checked; 
                 this.wrappersavedActivityChecked = tempWrapperList;
                 this.WrapperSavedActivity = tempWrapperList;
                 console.log('tempWrapperList '+JSON.stringify(tempWrapperList));
             }
 
         
         
        
     }
 
     
 
     saveComment(event){
         
         console.log(event.target.value);
      
         
         var unsavedOrSaved = event.target.getAttribute('class');
         console.log('unsavedOrSaved '+unsavedOrSaved);
 
             var parentIndex = event.target.name;
             var i = event.target.getAttribute('data-id');
             console.log('child '+i+' & parent'+parentIndex);
             let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));
             tempWrapperList[parentIndex].unSavedRecordsList[i].ms_Comment = event.target.value;
             this.WrapperSavedActivity = tempWrapperList;
             this.wrappersavedActivityChecked = tempWrapperList;
     
 
     }
     
 
     */


    RemoveRecord(event) {



        if (event.target.title == 'Delete Saved') {
            var i = event.target.getAttribute('data-id');
            var parentIndex = event.target.value;
            console.log('parentIndex ' + parentIndex + ' i ' + i);
            let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));
            let tempWrapList = JSON.parse(JSON.stringify(this.wrapperSavedActivityAftrCancel));
            this.dodeleteActivity(tempWrapperList[parentIndex].wrapperparentWithChild[i]);
            tempWrapperList[parentIndex].wrapperparentWithChild.splice(i, 1);
            tempWrapList[parentIndex].wrapperparentWithChild.splice(i, 1);
            console.log('tempWrapperList ' + JSON.stringify(tempWrapperList));
            if (tempWrapperList[parentIndex].wrapperparentWithChild.length < 1) {
                tempWrapperList.splice(parentIndex, 1);
            }
            if (tempWrapList[parentIndex].wrapperparentWithChild.length < 1) {
                tempWrapList.splice(parentIndex, 1);

            }

            //this.wrapperSavedActivityAftrCancel = tempWrapperList;
            this.WrapperSavedActivity = tempWrapperList;
            this.wrapperSavedActivityAftrCancel = tempWrapList;
            this.wrappersavedActivityChecked = tempWrapperList;
            if (tempWrapperList.length < 1) {
                this.template.querySelectorAll('[data-id="myDiv"]').classList.remove('heightClass');
            }

        }
        if (event.detail.title == 'Delete') {
            console.log('event.detail.tempWrapperList ' + event.detail.tempWrapperList + ' event.detail.i ' + event.detail.i + ' event.detail.parentIndex ' + event.detail.parentIndex);
            let tempWrapperList = event.detail.tempWrapperList;
            console.log('tempWrapperList before' + JSON.stringify(tempWrapperList));
            tempWrapperList[event.detail.parentIndex].wrapperparentWithChild.splice(event.detail.i, 1);

            if (tempWrapperList[event.detail.parentIndex].wrapperparentWithChild.length < 1) {
                tempWrapperList.splice(event.detail.parentIndex, 1);
            }
            this.wrapperUnsavedActivity = tempWrapperList;
            this.wrapperUnsavedActivityAftrCancel = tempWrapperList;
            this.wrapperUsavedActivityChecked = tempWrapperList;
            this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList, tempWrapperList, tempWrapperList);

        }

    }
    /*
        EnableActivity(event){
            console.log('event.detail.title '+event.detail.title);
            
            if(event.target.title == 'Enable Saved'){
               
                var atLeastOneChecked = false;
              
                let tempWrapperList = JSON.parse(JSON.stringify( this.wrappersavedActivityChecked));
                for(var i=0; i<tempWrapperList.length; i++){
                    if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                   
                        for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                            if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                 if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                     console.log('here in check');
                                     tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Active';
                                     atLeastOneChecked = true;
                                 }
                                 for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                     if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != undefined ){
                                         if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                             console.log('here in check');
                                             tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].ActivityStatus = 'Active';
                                             atLeastOneChecked = true;
                                         }
                                     }        
    
                                 }
                                 
                             }
                             
                         }
                 }
    
                }
                
               
                if(atLeastOneChecked == false){
                    const evt = new ShowToastEvent({
                        title: 'Warning',
                        message: 'Please select checkbox to proceed!',
                        variant: 'warning',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }else{
                    this.WrapperSavedActivity = tempWrapperList;
                    this.wrappersavedActivityChecked = tempWrapperList;
                }
                
            }
    
            if(event.detail.title == 'Enable'){
                let tempWrapperList = event.detail.tempWrapperList;
              console.log('tempWrapperList in enable'+tempWrapperList)
                var atLeastOneChecked = false;
                if(tempWrapperList.length > 0){
                    for(var i=0; i<tempWrapperList.length; i++){
                        if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                       
                            for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                                if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                     if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                         console.log('here in check');
                                         tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Active';
                                         atLeastOneChecked = true;
                                     }
                                     for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                         if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != undefined ){
                                             if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                                 console.log('here in check');
                                                 tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].ActivityStatus = 'Active';
                                                 atLeastOneChecked = true;
                                             }
                                         }        
     
                                     }
                                     
                                 }
                                 
                             }
                     }
            
                   }
    
                }
                
                if(atLeastOneChecked == false){
                    const evt = new ShowToastEvent({
                        title: 'Warning',
                        message: 'Please select checkbox to proceed!',
                        variant: 'warning',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }else{
                    this.wrapperUnsavedActivity = tempWrapperList;
                 this.wrapperUsavedActivityChecked = tempWrapperList;
                 this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList, tempWrapperList, null);
                
                }
    
            }
        }
    
        pendingActivity(event){
         
            console.log(' event.detail.title '+event.target.title);
            if(event.target.title== 'Pending Saved'){
                var atLeastOneChecked = false;
              
                let tempWrapperList = JSON.parse(JSON.stringify( this.wrappersavedActivityChecked));
                console.log('tempWrapperList pendingActivity'+JSON.stringify(tempWrapperList));
                for(var i=0; i< tempWrapperList.length; i++){
                   
                    if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                       
                            for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                               if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                    if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                        console.log('here in check');
                                        tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Pending';
                                        atLeastOneChecked = true;
                                    }
                                    for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                        if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != undefined ){
                                            if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                                console.log('here in check');
                                                tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].ActivityStatus = 'Pending';
                                                atLeastOneChecked = true;
                                            }
                                        }        
    
                                    }
                                    
                                }
                                
                            }
                      
                    }
                }
             
    
               
                
                
                if(atLeastOneChecked == false){
                    const evt = new ShowToastEvent({
                        title: 'Warning',
                        message: 'Please select checkbox to proceed!',
                        variant: 'warning',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }else{
                    this.WrapperSavedActivity = tempWrapperList;
                    this.wrappersavedActivityChecked = tempWrapperList;
                }
            }else if(event.detail.title == 'Pending'){
    
                let tempWrapperList = event.detail.tempWrapperList;
               
                var atLeastOneChecked = false;
                if(tempWrapperList.length > 0 ){
                    for(var i=0; i< tempWrapperList.length; i++){
                        if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                       
                            for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                                if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                     if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                         console.log('here in check');
                                         tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Pending';
                                         atLeastOneChecked = true;
                                     }
                                     for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                         if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != undefined ){
                                             if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                                 console.log('here in check');
                                                 tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].ActivityStatus = 'Pending';
                                                 atLeastOneChecked = true;
                                             }
                                         }        
     
                                     }
                                     
                                 }
                                 
                             }
                     }
        
                    }
    
                }
            
                 if(atLeastOneChecked == false){
                    const evt = new ShowToastEvent({
                        title: 'Warning',
                        message: 'Please select checkbox to proceed!',
                        variant: 'warning',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }else{
                    this.wrapperUnsavedActivity = tempWrapperList;
                    this.wrapperUsavedActivityChecked = tempWrapperList;
                    this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList, tempWrapperList, null);
                 
                }
    
            }
           
        }
    
        CancelActivityRecordNow(event){
           
            
    
            if(event.target.title == 'Cancel update'){
          
               let tempWrapperList1 = JSON.parse(JSON.stringify(this.wrappersavedActivityChecked));
                console.log(' tempWrapperList1 '+JSON.stringify(tempWrapperList1));
    
                let tempWrapperList = JSON.parse(JSON.stringify(this.wrapperSavedActivityAftrCancel));
                console.log(' tempWrapperList '+JSON.stringify(tempWrapperList));
                for(var i=0; i< tempWrapperList1.length; i++){
    
                    for(var j=0; j< tempWrapperList1[i].wrapperparentWithChild.length;  j++){
                             if(tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                 console.log('here in check');
                                 tempWrapperList1[i] = tempWrapperList[i];
                                // tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck = false;
                                
                             }
                             for(var k=0; k< tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                     if(tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                         console.log('here in check');
                                         tempWrapperList1[i] = tempWrapperList[i];
                                        // tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck = false;
                                        
                                     }
                                 }        
    
                             
                         
                         
                         
                     }
    
                }
               if(tempWrapperList1.length > 0){
                this.WrapperSavedActivity= tempWrapperList1 ;
                this.wrappersavedActivityChecked = tempWrapperList;
               }
                
            }else if(event.detail.title != 'Cancel update'){
                console.log('here in unsaved cancel ');
                let tempWrapperList1 = JSON.parse(JSON.stringify(event.detail.tempWrapperList1));
                console.log(' tempWrapperList1 '+JSON.stringify(tempWrapperList1));
    
                let tempWrapperList = JSON.parse(JSON.stringify(event.detail.tempWrapperList));
                console.log(' tempWrapperList '+JSON.stringify(tempWrapperList));
                for(var i=0; i< tempWrapperList1.length; i++){
                    for(var j=0; j< tempWrapperList1[i].wrapperparentWithChild.length;  j++){
                        if(tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                            console.log('here in check');
                            tempWrapperList1[i] = tempWrapperList[i];
                           // tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck = false;
                           
                        }
                        for(var k=0; k< tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                if(tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                    console.log('here in check');
                                    tempWrapperList1[i] = tempWrapperList[i];
                                   // tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck = false;
                                   
                                }
                            }        
        
                }
                }
                console.log('tempWrapperList1 after cancel '+JSON.stringify(tempWrapperList1));
                
                if(tempWrapperList1.length > 0){
                    this.wrapperUnsavedActivity= tempWrapperList1 ;
                    this.wrapperUsavedActivityChecked = tempWrapperList1;
                    this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList1, tempWrapperList1, this.wrapperSavedActivityAftrCancel);
    
                }
                
            }
        }
    */
    NavigateToFilterRecordsComponent(event) {
        console.log('in navigation this.startDate' + this.startDate + ' endDate ' + this.endDate + ' countryValue ' + this.countryValue + 'this.channelOptions ' + this.channelOptions)
        var compDefinition = {
            componentDef: "c:tAD_ShowFilterInventoryLWC",
            attributes: {
                startDate: this.startDate,
                endDate: this.endDate,
                countryValue: this.countryValue,
                channelOptions: this.channelOptions,
                SupplierOptions: this.SupplierOptions,
                TitleOptions: this.TitleOptions,
                PlacementOptions: this.PlacementOptions,
                Cost: this.Cost,
                GeoOptions: this.GeoOptions,
                RecurringOptions: this.RecurringOptions,
                dateValue: this.dateValue,
                channelValue: this.channelValue,
                suppliervalue: this.suppliervalue,
                titlevalue: this.titlevalue,
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



    dofetchvalues() {
        if (this.dateValue == null) {
            this.dateValue = null;
        }
        filterInventoriesListOnLoad({ startDate: this.startDate, EndDate: this.endDate, selectedChannels: this.channelValue, selectedTitles: this.titlevalue, selectedsuppliers: this.suppliervalue, selectedPlacement: this.placementvalue, cost: this.Cost, selectedGeo: this.geovalue, selectedDate: this.dateValue, recurringValue: this.recurringvalue, countryValue: this.countryValue })
            .then(result => {
                let channelData = [];
                console.log('values inventory--->' + JSON.stringify(result));
                for (let i = 0; i < result.length; i++) {

                    channelData.push(result[i]);
                    this.inventoryIdvsChannel.push({ value: result[i].ms_Channel__c, key: result[i].Id });

                }
                this.forInventryEvent = result;
                this.channels = channelData;
                this.channelsForBackup = channelData;
                this.doFetchActivityOnLoad(result);
            })
            .catch(error => {
                console.log('Error while fetching Picklist values' + JSON.stringify(error));
                this.error = error;
                this.contacts = undefined;
            });

    }


    dofetchdeals() {

        fetchdeales({selectedChannels : this.channelValue, selectedTitles : this.titlevalue, selectedsuppliers : this.suppliervalue, selectedPlacement : this.placementvalue, cost : this.Cost, selectedGeo : this.geovalue, selectedDate : this.dateValue, recurringValue : this.recurringvalue, countryValue : this.countryValue})
            .then(result => {

                let dealData = [];
                console.log('values----> ' + JSON.stringify(result));
                for (let i = 0; i < result.length; i++) {

                    dealData.push(result[i]);
                    this.DealDataFetch.push({ value: result[i].Deal__c, key: result[i].Id });
                    console.log('values-1----->'+ JSON.stringify(this.DealDataFetch));

                }
                this.initDealData = result;
                console.log('values-2----->'+ JSON.stringify(this.initDealData));
                this.deals = result;
                console.log('values-3----->'+ JSON.stringify(this.deals));
                this.eligibleDeals = result;
                console.log('values-4----->'+ JSON.stringify(this.eligibleDeals));
            })
            .catch(error => {
                console.log('Error while fetching Picklist values' + JSON.stringify(error));
                this.error = error;
                this.contacts = undefined;
            });

    }



    drop(event) {
        event.preventDefault();
        /*var element2 = this.template.querySelectorAll('[class="box completed"]');
        console.log('element2'+element2.length);

        if(element2.length>1){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Cannot Drop More Than one Inventory!',
                variant: 'success'
            });
            this.dispatchEvent(evt);
        }
        else{
*/
        var draggedObj = event.dataTransfer.getData("divId");
        console.log('channel draggedObj ' + JSON.parse(draggedObj));
        var obj = JSON.parse(draggedObj);
        if (obj.title == 'channelsDiv') {
            console.log('here entered')
            this.inventoryIds = obj;
            var divId = obj.id;
            var draggedElement = this.template.querySelector('#' + divId);
            console.log(' draggedElement ' + draggedElement);

            draggedElement.classList.add('completed');
            event.target.appendChild(draggedElement);
            event.dataTransfer.clearData();
            console.log('ninv id of dealv ' + this.DealIds);
            this.checkForBothDealAndInventory(this.inventoryIds, this.DealIds);
        }
    
}
    allowDrop(event) {
        var test = event.target;
        console.log('test here ' + JSON.stringify(test));
        event.preventDefault();
    }

    allowDropForDeal(event) {
        event.preventDefault();
    }

    drag(event) {
        console.log('event.target.getAttribute(data-id6) ', event.target.getAttribute('data-id6'));
        var wrapperObj = { id: event.target.id, title: event.target.getAttribute('data-id2'), startDate: event.target.getAttribute('data-id'), endDate: event.target.getAttribute('data-id3'), Date: event.target.getAttribute('data-id4'), InventoryChannel: event.target.getAttribute('data-id5'), StartTime: event.target.getAttribute('data-id6') };
        event.dataTransfer.setData("divId", JSON.stringify(wrapperObj));
    }
    dealsdragbackToDeal(event) {
        console.log('channel drag event details ' + event.target.id);

        var wrapperObj = { id: event.target.id, title: event.target.getAttribute('data-id') };
        event.dataTransfer.setData("divId", JSON.stringify(wrapperObj));


    }

    dealsdragbackToInventory(event) {
        console.log('channel drag event details ' + event.target.id);

        console.log('channel drag event back' + event.target.getAttribute('data-id2'));
        var wrapperObj = { id: event.target.id, title: event.target.getAttribute('data-id2') };
        event.dataTransfer.setData("divId", JSON.stringify(wrapperObj));

    }

    dealsdropbackToDeal(event) {
        event.preventDefault();
        var draggedObj = event.dataTransfer.getData("divId");

        var obj = JSON.parse(draggedObj);
        if (obj.title == 'dealIdDiv') {

            this.DealIds = undefined;
            var divId = obj.id;
            var draggedElement = this.template.querySelector('#' + divId);
            console.log(' draggedElement ' + draggedElement);


            event.target.appendChild(draggedElement);
            event.dataTransfer.clearData();
            console.log('ninv id of dealv ' + this.DealIds);

        }

    }
    handleChangeDate(event) {
        console.log('here in this log ');

        console.log('here in this dateValue ' + event.target.value);
        this.dateValue = event.target.value;
    }

    dropbackToInventory(event) {
        event.preventDefault();
        var draggedObj = event.dataTransfer.getData("divId");
        console.log('draggedObj in dropbackToInventory ' + JSON.stringify(draggedObj));
        var obj = JSON.parse(draggedObj);
        if (obj.title == 'channelsDiv') {

            this.inventoryIds = undefined;
            var divId = obj.id;
            var draggedElement = this.template.querySelector('#' + divId);
            console.log(' draggedElement ' + draggedElement);


            event.target.appendChild(draggedElement);
            event.dataTransfer.clearData();
            console.log('ninv id of dealv ' + this.DealIds);

        }

    }

    dealsdrop(event) {
        event.preventDefault();
        /*var element3 = this.template.querySelectorAll('[class="deal completed"]');
        console.log('element3'+element3.length);

        if(element3.length>1){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Cannot Drop More Than one Deal!',
                variant: 'success'
            });
            this.dispatchEvent(evt);
        }
        else{*/

        var draggedObj = event.dataTransfer.getData("divId");
        var obj = JSON.parse(draggedObj);
        console.log(' deals obj ' + obj);

        if (obj.title == 'dealIdDiv') {
            var draggedElement = this.template.querySelector('#' + obj.id);
            this.DealIds = obj;
            draggedElement.classList.add('completed');
            event.target.appendChild(draggedElement);
            //event.target.value = "";
            event.dataTransfer.clearData();
            this.checkForBothDealAndInventory(this.inventoryIds, this.DealIds);
        }
        
}

    dealsdrag(event) {
        var wrapperObj = { id: event.target.id, title: event.target.getAttribute('data-id'), DealTitle: event.target.getAttribute('data-id2') };
        event.dataTransfer.setData("divId", JSON.stringify(wrapperObj));

    }

    checkForBothDealAndInventory(channelId, dealId) {
        console.log('channelId  ' + JSON.stringify(channelId) + ' dealId ' + dealId);
        if (channelId != null && channelId != undefined && channelId != '' && dealId != null && dealId != undefined && dealId != '') {
            var channelIdpart = channelId.id.split('-')[0];

            var dealIdpart = dealId.id.split('-')[0];

            console.log(' channelIdpart ' + channelIdpart + ' dealIdpart ' + dealIdpart);
            this.channelIdpart = channelIdpart.toString();
            this.DealIdpart = dealIdpart.toString();
            console.log('this.inventoryIds.Date=======>' + this.inventoryIds.Date);
            if (this.inventoryIds.Date != null && this.inventoryIds.Date != undefined) {

                this.isDateVisible = true;
                console.log('this.inventoryIds.Date' + this.inventoryIds.Date);
                console.log('===============Great=======>');

            }
            else {
                this.isDateVisible = false;
            }
            this.openModal();

        }
    }

    dodeleteActivity(wrappertoDelete) {
        console.log('wrappertoDelete ' + JSON.stringify(wrappertoDelete));
        DeleteActivityRecord({ deleteSavedWrapper: wrappertoDelete })
            .then((result) => {
                if (result == true) {
                    console.log('deleted');
                }
            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.log(error);
            });
    }


    updateActivityRecordNow() {

        var checkOrUncheck = this.validateWrapperIfCheck(this.wrappersavedActivityChecked);
        console.log('checkOrUncheck ' + checkOrUncheck);
        if (checkOrUncheck == true) {
            updateActivityRecord({ updateSavedWrapperList: this.wrappersavedActivityChecked })

                .then((result) => {
                    if (result) {

                        const evt = new ShowToastEvent({
                            title: 'Success',
                            message: 'Records saved successfully!',
                            variant: 'success'
                            //mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }
                    let tempPickList = JSON.parse(JSON.stringify(result));
                    for (let i = 0; i < tempPickList.length; i++) {
                        console.log(' result[i].wrapperparentWithChild.length ' + tempPickList[i].wrapperparentWithChild.length);
                        for (let j = 0; j < result[i].wrapperparentWithChild.length; j++) {
                            tempPickList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck = false;
                            if (tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime != undefined && tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime != '') {
                                if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('PM'))) {
                                    var hours = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(0, 2), 10),
                                        minutes = tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(3, 5),
                                        ampm = 'AM';
                                        if (hours > 12 || hours == 12) {
                                            //hours -= 12;
                                            ampm = 'PM';
                                            console.log('Hours-2-->'+hours);
                                            console.log('ampm-2-->'+ampm);
                                        }

                                    /*if (hours == 12) {
                                        ampm = 'PM';
                                        console.log('Hours--->'+hours);
                                        console.log('ampm--->'+ampm);
                                    } else if (hours == 0) {
                                        hours = 12;
                                        console.log('Hours-1->'+hours);
                                        console.log('ampm--1->'+ampm);
                                    } else if (hours > 12 || hours == 12) {
                                        hours -= 12;
                                        ampm = 'PM';
                                        console.log('Hours-2-->'+hours);
                                        console.log('ampm-2-->'+ampm);
                                    }*/
                                    tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime = hours + ':' + minutes + ' ' + ampm;

                                }


                            }
                            if (tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime != undefined) {
                                if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.includes('PM'))) {
                                    var hoursStartTime = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.substring(0, 2), 10),
                                        minutesStartTime = tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.substring(3, 5),
                                        ampm = 'AM';

                                        if (hoursStartTime > 12) {
                                            //hoursStartTime -= 12;
                                            ampm = 'PM';
                                        }

                                    /*if (hoursStartTime == 12) {
                                        ampm = 'PM';
                                    } else if (hoursStartTime == 0) {
                                        hoursStartTime = 12;
                                    } else if (hoursStartTime > 12) {
                                        hoursStartTime -= 12;
                                        ampm = 'PM';
                                    }*/


                                    tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime = hoursStartTime + ':' + minutesStartTime + ' ' + ampm;

                                }
                            }

                            for (let k = 0; k < result[i].wrapperparentWithChild[j].length; k++) {
                                tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck = false;
                                if (tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime != undefined && tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime != '') {
                                    if (!(tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime.includes('PM'))) {
                                        var hours = parseInt(tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime.substring(0, 2), 10),
                                            minutes = tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime.substring(3, 5),
                                            ampm = 'AM';
                                            if (hours > 12 || hours == 12) {
                                                //hours -= 12;
                                                ampm = 'PM';
                                                console.log('Hours-3-->'+hours);
                                                console.log('ampm-4-->'+ampm);
                                            }

                                        /*if (hours == 12) {
                                            ampm = 'PM';
                                            console.log('Hours--01->'+hours);
                                        console.log('ampm--->'+ampm);
                                        } else if (hours == 0) {
                                            hours = 12;
                                            console.log('Hours--11->'+hours);
                                        console.log('ampm--->'+ampm);
                                        } else if (hours > 12 || hours == 12) {
                                            hours -= 12;
                                            ampm = 'PM';
                                            console.log('Hours--12->'+hours);
                                        console.log('ampm--12->'+ampm);
                                        }*/
                                        tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].Duetime = hours + ':' + minutes + ' ' + ampm;

                                    }


                                }
                                if (tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime != undefined) {
                                    if (!(tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime.includes('PM'))) {
                                        var hoursStartTime = parseInt(tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime.substring(0, 2), 10),
                                            minutesStartTime = tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime.substring(3, 5),
                                            ampm = 'AM';

                                            if (hoursStartTime > 12) {
                                                //hoursStartTime -= 12;
                                                ampm = 'PM';
                                            }

                                        /*if (hoursStartTime == 12) {
                                            ampm = 'PM';
                                        } else if (hoursStartTime == 0) {
                                            hoursStartTime = 12;
                                        } else if (hoursStartTime > 12) {
                                            hoursStartTime -= 12;
                                            ampm = 'PM';
                                        }*/


                                        tempPickList[i].wrapperparentWithChild[j].objChildListVariable[k].StartTime = hoursStartTime + ':' + minutesStartTime + ' ' + ampm;

                                    }
                                }
                            }

                            console.log('tempPickList ' + JSON.stringify(tempPickList));
                            result = tempPickList;

                        }


                    }
                    this.WrapperSavedActivity = result;

                    this.inventoryIds = '';
                    this.DealIds = '';
                    // this.dueTime = '';
                    console.log(' in save inv ' + this.inventoryIds + ' & deal ' + this.DealIds);
                    this.channelIdpart = undefined;
                    this.DealIdpart = undefined;


                })
                .catch(error => {
                    // eslint-disable-next-line no-console
                    console.log(error);
                });
        } else {
            const evt = new ShowToastEvent({
                title: 'Warning',
                message: 'Please select checkbox to update Marketing Actitvity Record!',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
    }

    validateWrapperIfCheck(wrapperChecked) {
        let tempWrapperList = JSON.parse(JSON.stringify(wrapperChecked));
        var check = false;
        for (let i = 0; i < tempWrapperList.length; i++) {
            console.log(' tempWrapperList[i].wrapperparentWithChild ' + JSON.stringify(tempWrapperList[i].wrapperparentWithChild));
            for (let j = 0; j < tempWrapperList[i].wrapperparentWithChild.length; j++) {
                if (tempWrapperList[i].wrapperparentWithChild[j].CheckOrUncheck == true) {
                    check = true;
                }
            }
        }
        return check;

    }
    /*
    saveActivityRecordNow(event){
        
        var checkOrUncheck =  this.validateWrapperIfCheck(event.detail.tempWrapperList);
       //console.log(' this.wrapperUsavedActivityChecked '+this.wrapperUsavedActivityChecked+' this.startDate '+this.startDate+' this.endDate '+this.endDate);
        console.log('checkOrUncheck '+checkOrUncheck);
        if(checkOrUncheck == true){
            this.wrapperUsavedActivityChecked = event.detail.tempWrapperList;
            this.isLoading = true;
            saveActivityRecord({unsavedWrapperList : event.detail.tempWrapperList , StartDate : this.startDate, EndDate : this.endDate, savedWrapperList : this.WrapperSavedActivity})
        .then((result) =>{
            console.log(' result '+JSON.stringify(result));
            if(result){
                    result = this.calculateafterUnsaved(result);
                    
                    this.inventoryIds = '';
                    this.DealIds = '';
                    console.log(' in save inv '+this.inventoryIds+' & deal '+ this.DealIds);
                    this.channelIdpart = undefined;
                    this.DealIdpart = undefined;
    
                    let tempList = JSON.parse(JSON.stringify(this.wrapperUsavedActivityChecked));
                    for(var m=0; m< tempList.length;  m++){
                        
                        for(var n=0 ; n< tempList[m].wrapperparentWithChild.length;  n++){
                     
                            if(tempList[m].wrapperparentWithChild[n].objParentvariable.CheckOrUncheck == true){
                                console.log('tempList in 1 '+JSON.stringify(tempList));
                               tempList[m].wrapperparentWithChild.splice(n,1);
                               n--;
                            }
                            
                        }
             
                }
                console.log('tempList before '+JSON.stringify(tempList));
                for(var j = 0;j < tempList.length ; j++){
                  
                    if(tempList[j].wrapperparentWithChild.length == 0){
                        console.log(' length '+tempList[j].wrapperparentWithChild.length);
                        tempList.splice(j,1);
                        j--;
                    }
                }
                console.log('tempList after '+JSON.stringify(tempList));
                
               
                this.WrapperSavedActivity =  result;    
                this.wrapperUnsavedActivity = tempList;
                this.wrapperUnsavedActivityAftrCancel = tempList;
                this.wrapperUsavedActivityChecked = tempList;
                this.WrapperSavedActivity = result;
                this.wrapperSavedActivityAftrCancel = result;
                this.isLoading = false;
                this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempList,tempList,tempList);
            
            
            }else{
                this.WrapperSavedActivity = undefined;
            }
    
            })
            .catch(error => {
                // eslint-disable-next-line no-console
                console.log(error);
            });
    }else{
        const evt = new ShowToastEvent({
            title: 'Warning',
            message: 'Please select checkbox to save Marketing Actitvity Record!',
            variant: 'warning',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    }
    */

    doFetchActivityOnLoad(InventoryOnLoad) {
        // this.isLoading = false;
        ActivityRecordOnLoad({ InventoryOnLoadList: InventoryOnLoad })
            .then((result) => {

                console.log('step1===============>', result);
                let result2 = this.calculateafterUnsaved(result);
                console.log('step2');
                console.log('result2====>', result2);
                this.WrapperSavedActivity = result2;
                //this.wrapperSavedActivityAftrCancel = result2;
                // this.wrapperSavedActivityChecked = result2; 

                //this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').savedActivityWrapperShowOnload(result2);

                /*
                    console.log(' result fetchActivityOnLoad '+JSON.stringify(result));
                    
                            let tempPickList  = JSON.parse(JSON.stringify(result));
                            for(let i = 0; i < tempPickList.length; i++){
                                console.log(' result[i].unSavedRecordsList.length '+tempPickList[i].unSavedRecordsList.length);
                                for(let j=0; j< result[i].unSavedRecordsList.length; j++){
                                    if(tempPickList[i].unSavedRecordsList[j].dueTime != undefined && tempPickList[i].unSavedRecordsList[j].dueTime != ''){
                                    if(!(tempPickList[i].unSavedRecordsList[j].dueTime.includes('AM') || tempPickList[i].unSavedRecordsList[j].dueTime.includes('PM'))){
                                        var hours   = parseInt(tempPickList[i].unSavedRecordsList[j].dueTime.substring(0, 2), 10),
                                            minutes = tempPickList[i].unSavedRecordsList[j].dueTime.substring(3, 5),
                                            ampm    = 'AM';
                
                                        if (hours == 12) {
                                            ampm = 'PM';
                                        } else if (hours == 0) {
                                            hours = 12;
                                        } else if (hours > 12) {
                                            hours -= 12;
                                            ampm = 'PM';
                                        }
                                        tempPickList[i].unSavedRecordsList[j].dueTime = hours + ':' + minutes + ' ' + ampm;
                
                                    }
                                }
                                    if(tempPickList[i].unSavedRecordsList[j].ms_StartTime != undefined){
                                        if(! ( tempPickList[i].unSavedRecordsList[j].ms_StartTime.includes('AM') || tempPickList[i].unSavedRecordsList[j].ms_StartTime.includes('PM'))){
                                            var hoursStartTime   = parseInt(tempPickList[i].unSavedRecordsList[j].ms_StartTime.substring(0, 2), 10),
                                                minutesStartTime = tempPickList[i].unSavedRecordsList[j].ms_StartTime.substring(3, 5),
                                                ampm    = 'AM';
                    
                                            if (hoursStartTime == 12) {
                                                ampm = 'PM';
                                            } else if (hoursStartTime == 0) {
                                                hoursStartTime = 12;
                                            } else if (hoursStartTime > 12) {
                                                hoursStartTime -= 12;
                                                ampm = 'PM';
                                            }
                                            
                                            
                                            tempPickList[i].unSavedRecordsList[j].ms_StartTime = hoursStartTime + ':' + minutesStartTime + ' ' + ampm;
                    
                                        }
                                    }
                                    
                                    
                
                                        
                                       
                                        console.log('tempPickList '+ JSON.stringify(tempPickList));
                                        result = tempPickList;
                                                       
                                }
                                
                                this.WrapperSavedActivity = tempPickList;
                                this.wrapperSavedActivityAftrCancel = tempPickList;
                                this.inventoryIds = '';
                            this.DealIds = '';
                           // this.dueTime = '';
                            console.log(' in save inv '+this.inventoryIds+' & deal '+ this.DealIds);
                            this.channelIdpart = undefined;
                            this.DealIdpart = undefined;
                            console.log(' here in style '+ this.template.querySelectorAll('[data-id="myDiv"]').classList);
                            if(tempPickList.length == 0){
                                this.template.querySelectorAll('[data-id="myDiv"]').classList.remove('heightClass');
                            }
                         
                                
                            }
                        */
                //this.dealsdrag();
            }).catch(error => {
                // this.resultsum = undefined;
                console.log('error-- ' + JSON.stringify(error));
            });
    }
    handleDueTime(event) {
        console.log('event.target.value ' + event.target.value);
        this.dueTime = event.target.value;
    }
    handleStartandEndAndCustomdate(event) {
        if (event.target.name == 'startDate') {
            var start = new Date(event.target.value);
            this.startDateForCheck = start.toISOString();
            console.log('this.startDateForCheck  ' + this.startDateForCheck);
        } else if (event.target.name == 'endDate') {
            var end = new Date(event.target.value);
            this.endDateForCheck = end.toISOString();
        } else {
            var custom = new Date(event.target.value);
            this.custom_date = custom.toISOString();
            this.doFilterDeals();
        }
    }

    handleDueDateEvent(event) {
        //var dueDate = new Date(event.target.value);
        var dueDate = event.target.value;
        console.log('dueDate100 ' + dueDate);
        if (dueDate) {
            //this.dueDate = dueDate.toISOString();
            this.dueDate = dueDate;
            console.log('duedate101---> ' + this.dueDate);
            // this.minEndDate = this.startDate;
        }
    }
    navigateToFilterInventory() {
        var compDefinition = {
            componentDef: "c:tAD_ShowFilterInventoryLWC",
            attributes: {
                startDate: this.startDate,
                endDate: this.endDate,
                countryValue: this.countryValue,
                channelOptions: this.channelOptions,
                SupplierOptions: this.SupplierOptions,
                TitleOptions: this.TitleOptions,
                PlacementOptions: this.PlacementOptions,
                Cost: this.Cost,
                GeoOptions: this.GeoOptions,
                RecurringOptions: this.RecurringOptions,
                dateValue: this.dateValue,
                channelValue: this.channelValue,
                suppliervalue: this.suppliervalue,
                titlevalue: this.titlevalue,
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

    openModal() {
        // to open modal set isModalOpen tarck value as true
        console.log(' in this modal ' + this.inventoryIds);
        this.startDateForCheck = this.startDate;
        this.endDateForCheck = this.endDate;

        var startDate = new Date(this.startDate);
        var endDate = new Date(this.endDate);
        if (this.inventoryIds.Date != null) {
            this.isStartAndEndDate = false;
            this.invDate = this.inventoryIds.Date;

            this.invstartDate = undefined;
            this.invendDate = undefined;
            var Datess = new Date(this.invDate);
            if (Date.parse(Datess) >= Date.parse(startDate) && Date.parse(Datess) >= Date.parse(endDate)) {
                this.isOutsideRange = false;
            } else {
                this.isOutsideRange = true;
            }
        } else {
            this.isStartAndEndDate = true;
            this.invDate = undefined;
            this.invstartDate = this.inventoryIds.startDate;
            this.invendDate = this.inventoryIds.endDate;
            var invStart = new Date(this.invstartDate);
            var invEnd = new Date(this.invendDate);
            if (Date.parse(invStart) <= Date.parse(startDate) && Date.parse(startDate) <= Date.parse(invEnd) && Date.parse(invStart) <= Date.parse(endDate) && Date.parse(endDate) <= Date.parse(invEnd)) {
                this.isOutsideRange = false;
            } else {
                this.isOutsideRange = true;
            }

        }
        this.isModalOpen = true;
        getUserDateTime()
            .then(result => {
                console.log('result' + result);
                this.minDueDate = result.CurrentDate;
                console.log('minduedate1493' + this.minDueDate);
                this.currentdateplus1 = result.CurrentDatePlus1;
                console.log('currendate1495' + this.currentdateplus1);
            /* 
  
          var parts = result.split(/[- : /]/);
          console.log('parts here '+parts);
          var d = new Date(parts[2], parts[1] - 1, parts[0],0,0,0,0);
          //var d =d1+1;
          
        //var d =  date.setDate(date.getDate() + 1);
         
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
          this.minDueDate = newDate.toISOString();
  
          //console.log('this.minStartDate '+this.minStartDate);
  
        */})
            .catch(error => {
                this.error = error;
                console.log('error ' + this.error);
                // this.contacts = undefined;
            });
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.removeselectedElements();
        this.inventoryIds = '';
        this.DealIds = '';
        this.channelIdpart = undefined;
        this.DealIdpart = undefined;
        this.isModalOpen = false;

    }
    submitDetails() {
        var invStart = new Date(this.invstartDate);
        var invEnd = new Date(this.invendDate);
        var Datess = new Date(this.invDate);
        var startDate = new Date(this.startDateForCheck);
        var endDate = new Date(this.endDateForCheck);
        var dueDate = new Date(this.dueDate);
        var mindueDate = new Date(this.minDueDate);
        console.log('submit start' + startDate + ' endDate >> ' + endDate + '& dueDate >> ' + dueDate);
        if (this.invstartDate != null && this.invendDate != null) {
            if (Date.parse(invStart) <= Date.parse(startDate) && Date.parse(startDate) <= Date.parse(invEnd) && Date.parse(invStart) <= Date.parse(endDate) && Date.parse(endDate) <= Date.parse(invEnd)) {
                this.isOutsideRange = false;
                if (Date.parse(dueDate) != null && Date.parse(dueDate) != undefined && Date.parse(dueDate) != NaN && Date.parse(dueDate) != 0) {
                    console.log('mindueDate ' + Date.parse(mindueDate));
                    if (Date.parse(dueDate) >= Date.parse(mindueDate)) {

                        if(Date.parse(dueDate) < Date.parse(startDate)) {
                            console.log('here in right');
                            this.checkEnddate();
                            //this.showUnsavedRecords();
                        } else {
                            const evt = new ShowToastEvent({
                                title: 'Important !',
                                message: 'Select Due Date which is earlier than the Start Date of marketing activity',
                                variant: 'warning',
                                mode: 'pester'
                            });
                            this.dispatchEvent(evt);
                        }

                    } else {
                        console.log('Empty Due Date');
                        const evt = new ShowToastEvent({
                            title: 'Important !',
                            message: 'Please Select Due Date To Proceed',
                            variant: 'warning',
                            mode: 'pester'
                        });
                        this.dispatchEvent(evt);
                    }


                } else {

                }
            } else {
                this.isOutsideRange = true;
            }
        }
        else if (this.invDate != null) {

            if (Date.parse(dueDate) != null && Date.parse(dueDate) != undefined && Date.parse(dueDate) != NaN && Date.parse(dueDate) != 0) {
                console.log('mindueDate ' + Date.parse(mindueDate));
                if (Date.parse(dueDate) >= Date.parse(mindueDate)) {

                    if (Date.parse(dueDate) < Date.parse(Datess)) {
                        console.log('here in right');
                        this.startDateForCheck = Datess;
                        this.endDateForCheck = Datess;
                        this.isModalOpen = false;
                        this.showUnsavedRecords();
                    } else {
                        const evt = new ShowToastEvent({
                            title: 'Important !',
                            message: 'Select Due Date which is earlier than the Start Date of marketing activity',
                            variant: 'warning',
                            mode: 'pester'
                        });
                        this.dispatchEvent(evt);
                    }

                } else {
                    console.log('wrong');
                }


            } else {

            }

        }





    }

    checkEnddate(){
        var startDate = new Date(this.startDateForCheck);
        var endDate = new Date(this.endDateForCheck);
        if(Date.parse(endDate) >= Date.parse(startDate)) {
            this.isModalOpen = false;
            this.showUnsavedRecords();
        } else {
            const evt = new ShowToastEvent({
                title: 'Important !',
                message: 'End date should not be earlier than start date',
                variant: 'warning',
                mode: 'pester'
            });
            this.dispatchEvent(evt);
        }
    }

    showUnsavedRecords() {
        console.log('this.UnsavedActivityRecords=======>' + this.wrapperUnsavedActivity);

        UnsavedActivityRecords({ unsavedWrapMainList: this.wrapperUnsavedActivity, dueTime: this.dueTime, dueDate: this.dueDate, inventoryId: this.channelIdpart, dealId: this.DealIdpart, StartDate: this.startDateForCheck, EndDate: this.endDateForCheck, DealTitle: this.DealIds.DealTitle, InventoryChannel: this.inventoryIds.InventoryChannel, StartTime: this.inventoryIds.StartTime })
            .then((result) => {
                console.log(' result in unsaved ' + JSON.stringify(result));
                var resultbforecancelled = '';
                var result1 = '';
                this.removeselectedElements();
                result = this.calculateafterUnsaved(result);
                console.log(' here in result after calculation' + JSON.stringify(result));
                result1 = result;
                if (this.wrapperUnsavedActivity == undefined || this.wrapperUnsavedActivity == '') {
                    this.wrapperUnsavedActivityAftrCancel = result;
                    resultbforecancelled = result;
                    this.inventoryIds = '';
                    this.DealIds = '';
                    this.channelIdpart = undefined;
                    this.DealIdpart = undefined;
                    this.wrapperUnsavedActivity = result;
                    console.log('result in if ' + result);
                    console.log('result1 ' + result1 + ' resultbforecancelled in if ' + resultbforecancelled);
                    // this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').unsavedActivityWrapperShowAfterdrag(result1, resultbforecancelled);

                } else {
                    UnsavedActivityRecords({ unsavedWrapMainList: this.wrapperUnsavedActivityAftrCancel, dueTime: this.dueTime, dueDate: this.dueDate, inventoryId: this.channelIdpart, dealId: this.DealIdpart, StartDate: this.startDateForCheck, EndDate: this.endDateForCheck, DealTitle: this.DealIds.DealTitle, InventoryChannel: this.inventoryIds.InventoryChannel, StartTime: this.inventoryIds.StartTime })
                        .then((result2) => {
                            console.log('result2=======================>', result2);
                            result2 = this.calculateafterUnsaved(result2);
                            resultbforecancelled = result2;
                            console.log(' result2 after calculation' + JSON.stringify(result2));
                            console.log('result ' + result);

                            this.wrapperUnsavedActivityAftrCancel = result2;
                            this.inventoryIds = '';
                            this.DealIds = '';
                            this.channelIdpart = undefined;
                            this.DealIdpart = undefined;
                            this.wrapperUnsavedActivity = result;
                            console.log('this.wrapperUnsavedActivity ' + this.wrapperUnsavedActivity);
                            console.log('result1 ' + result1 + ' resultbforecancelled in else' + resultbforecancelled);
                            //this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').unsavedActivityWrapperShowAfterdrag(result1, resultbforecancelled);
                        }).catch(error => {

                            console.log('here  in this' + JSON.stringify(error));
                        });

                }




            })
            .catch(error => {
                this.inventoryIds = '';
                this.DealIds = '';
                this.channelIdpart = undefined;
                this.DealIdpart = undefined;
                console.log('here ' + JSON.stringify(error));
            });


    }

    // Method to remove selected Elements from Both Section After Close the Modal
    removeselectedElements() {
        var parentElement1 = this.template.querySelector('[class="flex-container dealClass"]');
        var parentElement2 = this.template.querySelector('[class="flex-container selectedInventory"]');
        var element1 = this.template.querySelectorAll('[class="deal completed"]');
        var element2 = this.template.querySelectorAll('[class="box completed"]');
        console.log('element1 ' + element1.length);
        console.log('parentElement1 ' + parentElement1);
        var oldDealChild;
        var oldInventoryChild;

        for (var i = 0; i < element1.length; i++) {
            console.log('this.element[i].id ' + element1[i].id);
            if (!element1[i].id.includes('5678')) {
                oldDealChild = parentElement1.removeChild(element1[i]);
            }
        }

        for (var i = 0; i < element2.length; i++) {
            console.log('this.element2[i].id ' + element2[i].id);
            if (!element2[i].id.includes('1234')) {
                if (element2[i].parentNode) {
                    oldInventoryChild = element2[i].parentNode.removeChild(element2[i]);
                }

            }
        }

        console.log(oldInventoryChild.className);
        oldInventoryChild.className = 'box';
        var parentDealToDrop = this.template.querySelector('[class="flex-container dropping"]');
        var parentInventoryToDrop = this.template.querySelector('[class="flex-container inventorydrop"]');
        console.log('oldDealChild ' + oldDealChild + ' & parentDealToDrop ' + parentDealToDrop);
        parentDealToDrop.appendChild(oldDealChild);

        parentInventoryToDrop.appendChild(oldInventoryChild);
        parentElement2 = '';

    }

    calculateafterUnsaved(result) {
        let tempPickList = JSON.parse(JSON.stringify(result));
        for (let i = 0; i < tempPickList.length; i++) {
            console.log(' result[i].unSavedRecordsList.length ' + tempPickList[i].wrapperparentWithChild.length);
            for (let j = 0; j < result[i].wrapperparentWithChild.length; j++) {
                console.log('here in parent loop');
                //var hours;

                /*if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('AM') )) {
                    console.log('here in parent loop1 FOR AM');
                     var hours = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(0, 2), 10),
                        minutes = tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(3, 5),
                        ampm = 'AM';
                        tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime = hours + ':' + minutes + ' ' + ampm;
                    }

                    if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('PM') )) {
                        console.log('here in parent loop2 FOR PM');
                         var hours = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(0, 2), 10),
                            minutes = tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(3, 5),
                            ampm = 'PM';
                            tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime = hours + ':' + minutes + ' ' + ampm;
                        }*/
                        
                if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.includes('PM'))) {
                    console.log('here in parent loop2');
                    var hours = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(0, 2), 10),
                        minutes = tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime.substring(3, 5),
                        ampm = 'AM';

                        if (hours > 12 || hours == 12) {
                            //hours -= 12;
                            ampm = 'PM';
                        }

                    /*if (hours == 12) {
                        ampm = 'PM';
                    } else if (hours == 0) {
                        hours = 12;
                    } else if (hours > 12 || hours == 12) {
                        hours -= 12;
                        ampm = 'PM';
                    }*/
                    tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime = hours + ':' + minutes + ' ' + ampm;
                    console.log('here in parent loop2*****');

                }
                console.log('tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime', tempPickList[i].wrapperparentWithChild[j].objParentvariable.Duetime);

                // console.log('tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime',tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime);
                if (tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime != undefined) {
                    console.log('here in parent loop3');
                    if (!(tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.includes('AM') || tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.includes('PM'))) {
                        console.log('here in parent loop3***');
                        var hoursStartTime = parseInt(tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.substring(0, 2), 10),
                            minutesStartTime = tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime.substring(3, 5),
                            ampm = 'AM';

                            if (hours > 12 || hours == 12) {
                                hours -= 12;
                                ampm = 'PM';
                            }

                        /*if (hoursStartTime == 12) {
                            ampm = 'PM';
                        } else if (hoursStartTime == 0) {
                            hoursStartTime = 12;
                        } else if (hoursStartTime > 12) {
                            hoursStartTime -= 12;
                            ampm = 'PM';
                        }*/


                        tempPickList[i].wrapperparentWithChild[j].objParentvariable.StartTime = hoursStartTime + ':' + minutesStartTime + ' ' + ampm;

                    }
                }






            }
        }
        // console.log('tempPickList '+ JSON.stringify(tempPickList));
        result = tempPickList;
        return result;

    }





}