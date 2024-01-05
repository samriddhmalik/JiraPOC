import { LightningElement, track, wire, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import {refreshApex} from '@salesforce/apex';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import DealObj from '@salesforce/schema/Deal__c';
import dealType_Field from '@salesforce/schema/Deal__c.deal_type__c';
import fetchEvents from '@salesforce/apex/ViewCalendarDueDate.fetchAllSpendRecords';
import filterRecords from '@salesforce/apex/ViewCalendarDueDate.filterSpendRecords';
import saveActivityStatus from '@salesforce/apex/ms_HoverCalendarView.saveActivityStatus';

//import createEvent from '@salesforce/apex/FullCalendarController.createEvent';
//import deleteEvent from '@salesforce/apex/FullCalendarController.deleteEvent';
//import { refreshApex } from '@salesforce/apex';
/**
 * @description: FullcalendarJs class with all the dependencies
 */
export default class DueDateCalendarViewActivity extends LightningElement {
    //To avoid the recursion from renderedcallback
    fullCalendarJsInitialised = false;
   
    //Fields to store the event data -- add all other fields you want to add
    title;
    startDate;
    endDate;
    DueStartDate;
    DueEndDate;
    colorname;
    @track searchDealValue = null;
    
    eventsRendered = false;//To render initial events only once
    openSpinner = false; //To open the spinner in waiting screens
    
    openModal = false; //To open form
    @track parentdata=null;
    @track childdata=null;
    @track
    eventId = '';
    @track
    description = '';
    @track
    events = []; //all calendar events are stored in this field
    // Variables to store and display the options for Deal types
    @track selectValueType = 'Select deal type';
    @track selectedDealType = [];
    @track dealtypeOptions = [];
    @track dropdown = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track dropdownList = 'slds-media slds-listbox__option slds-listbox__option_entity slds-listbox__option_has-meta';
    @track searchBookingId=null;
    searchValueForBooking='';
    searchValueForDeal='';
    //To store the orignal wire object to use in refreshApex method
    eventOriginalData = [];
    eventDataList = [];
    eventdataBackup = [];   
    @track error;
    @wire(getObjectInfo, { objectApiName: DealObj })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: dealType_Field})
    dealtypevalues({data, error}){
        if(data){
            var typeOptions = data.values;
             for (let i = 0; i < typeOptions.length; i++) {
             this.dealtypeOptions = [...this.dealtypeOptions, { value: typeOptions[i].value, label: typeOptions[i].label}];
             }
              this.error = undefined;
             }
             else if (error) {
                
                 this.error = error;
                 this.dealtypeOptions = undefined;
                 }
};

    //Get data from server - in this example, it fetches from the event object

    @wire(fetchEvents)
    eventObj(value){
        this.eventOriginalData = value; //To use in refresh cache

        const {data, error} = value;
        if(data){
            this.eventDataList = data;
            console.log('eventdatalist-->'+this.eventDataList);
            //format as fullcalendar event object
            console.log('data '+JSON.stringify(data));
            let events = data.map(item => {
                return { id : item.ActivityId, 
                        title : item.Title, 
                        start : item.DueStartDateTime,
                        end : item.DueEndDateTime,
                        description: item.Description,
                        backgroundColor:item.Colorname,
                        allDay : false,
                        textColor: 'black',
                        
                        
                      };
            });
            this.events = JSON.parse(JSON.stringify(events));
            this.eventdataBackup = JSON.parse(JSON.stringify(events));
            console.log(this.events);
            this.error = undefined;

            //load only on first wire call - 
            // if events are not rendered, try to remove this 'if' condition and add directly 
            if(! this.eventsRendered){
                //Add events to calendar
                const ele = this.template.querySelector("div.fullcalendarjs");
                $(ele).fullCalendar('renderEvents', this.events, true);
                this.eventsRendered = true;
            }
        }else if(error){
            this.events = [];
            this.error = 'No events are found';
        }
   }

   openDropdown(){
    this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';  
    }

    closeDropDown(){
        this.dropdown =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }

    
   /**
    * Load the fullcalendar.io in this lifecycle hook method
    */
   renderedCallback() {
      // Performs this operation only on first render
      if (this.fullCalendarJsInitialised) {
         return;
      }
      this.fullCalendarJsInitialised = true;

      // Executes all loadScript and loadStyle promises
      // and only resolves them once all promises are done
        Promise.all([
            loadScript(this, FullCalendarJS + "/FullCalendarJS/jquery.min.js"),
            loadScript(this, FullCalendarJS + "/FullCalendarJS/moment.min.js"),
            loadScript(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.js"),
           
            loadStyle(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.css"),
        ])
        .then(() => {
            //initialize the full calendar
        this.initialiseFullCalendarJs();
        })
        .catch((error) => {
        console.error({
            message: "Error occured on FullCalendarJS",
            error,
        });
        });
   }
   

    initialiseFullCalendarJs() {
        const ele = this.template.querySelector("div.fullcalendarjs");
        const modal = this.template.querySelector('div.modalclass');
       // console.log(FullCalendar);

        var self = this;

        //To open the form with predefined fields
        //TODO: to be moved outside this function
        function openActivityForm(DueStartDate, DueEndDate){
            self.DueStartDate = DueStartDate;
            self.DueEndDate = DueEndDate;
            //self.openModal = true;
        }
        //Actual fullcalendar renders here - https://fullcalendar.io/docs/v3/view-specific-options
        $(ele).fullCalendar({
            header: {
                left: "prev,next today",
                center: "title",
                right: "month,agendaWeek,agendaDay",
            },
            defaultDate: new Date(), // default day is today - to show the current date
            defaultView : 'agendaWeek', //To display the default view - as of now it is set to week view
            navLinks: true, // can click day/week names to navigate views
            // editable: true, // To move the events on calendar - TODO 
            selectable: true, //To select the period of time

            //To select the time period : https://fullcalendar.io/docs/v3/select-method
            select: function (DueStartDate, DueEndDate) {
                let stDate = DueStartDate.format();
                let edDate = DueEndDate.format();
                
                openActivityForm(stDate, edDate);
            },
            eventClick: function(event, jsEvent, view) {
               // var dt = date.format();
             //  alert('here in click '+event.id);
                self.eventId =  event.id;
                self.description = event.description;
                self.openModal = true;
                console.log('here in openModal '+self.openModal +'  self.eventId '+ self.eventId);
              },
              dateClick: function(info) {

                //alert('Date: ' + info.dateStr);
               
            },
            dayClick: function(date, jsEvent, view) {

               // alert('Clicked on: ' + date.format());
            
              //  alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
            
              //  alert('Current view: ' + view.name);
            
                // change the day's background color just for fun
               // $(this).css('background-color', 'red');
            
              },
              
            eventLimit: true, // allow "more" link when too many events
            events: this.events, // all the events that are to be rendered - can be a duplicate statement here
            
        });

        
    }

    
/**
     * @description method to filter spend records
     */
    filterCalendar(event){
        
        if(event.detail != null){
            console.log(' here in not null');
            this.openSpinner = true;
            var supplierArray = [];
            var approvalArray = [];
            var statusArray = [];
            var channelArray = [];
            var searchDealList = [];
            var searchBookingList = [];
            var placementArray = [];
            var titlesArray = [];
            var geolist = [];
            console.log(' event.detail.countryValue '+ event.detail.countryValue+ ' &  event.detail.channelValue >> '+event.detail.channelValue);
            if(event.detail.channelValue != null ){
                if(event.detail.channelValue.includes(',')){
                    channelArray =  event.detail.channelValue.split(',');
                    
                }else{
                    channelArray =  event.detail.channelValue; 
                }
                
             } if(  event.detail.statusValue != null){
                    if( event.detail.statusValue.includes(',')){
                        statusArray =  event.detail.statusValue.split(',');
                }else{
                        statusArray =  event.detail.statusValue;
                }
             }
             if(event.detail.approvalValue != null){
                if(event.detail.approvalValue.includes(',') ){
                    approvalArray = event.detail.approvalValue.split(',');
               }else{
                    approvalArray = event.detail.approvalValue;
               }
             }
             if(event.detail.suppliervalue != null){
                if(event.detail.suppliervalue.includes(',')){
                    supplierArray = event.detail.suppliervalue.split(',');
               }else{
                    supplierArray = event.detail.suppliervalue;
               }
             }
             if( this.searchDealValue!= null )
                {
                    console.log('searchdeal'+this.searchDealValue);
                    if(this.searchDealValue.includes(',')) {
                        searchDealList = this.searchDealValue.split(',');
                    } 
                    else{
                    searchDealList.push(this.searchDealValue);
                    }
                }
                if( this.searchBookingId!= null )
                {
                    if(this.searchBookingId.includes(',')) {
                        searchBookingList = this.searchBookingId.split(',');
                    } 
                    else{
                        searchBookingList.push(this.searchBookingId);
                    }
                }
                if( event.detail.placementvalue != null )
                {
                    if(event.detail.placementvalue.includes(',')) {
                        placementArray = event.detail.placementvalue.split(',');
                    } 
                    else{
                       placementArray =  event.detail.placementvalue;
                    }
                }
                if( event.detail.titlevalue!= null )
                {
                    if(event.detail.titlevalue.includes(',')) {
                        titlesArray = event.detail.titlevalue.split(',');
                    } 
                    else{
                        titlesArray = event.detail.titlevalue;
                    }
                }
                if( event.detail.geovalue!= null )
                {
                    if(event.detail.geovalue.includes(',')) {
                        geolist = event.detail.geovalue.split(',');
                    } 
                    else{
                        geolist = event.detail.geovalue;
                    }
                }                 
            filterRecords({ searchBookingId :searchBookingList,selectedDealtypes : this.selectedDealType, selectedDeals :  searchDealList, selectedChannels : channelArray, selectedTitles : titlesArray, selectedsuppliers: supplierArray, selectedPlacement : placementArray, cost: event.detail.Cost, selectedGeo: geolist, approvalStatusValue : approvalArray, statusValue : statusArray,  countryValue: event.detail.countryValue,  marketingSpendList : this.eventDataList})
                .then(result => {
                    console.log('result---'+result);
                    let events = result.map(item => {
                        return { id : item.ActivityId, 
                                title : item.Title, 
                                start : item.DueStartDateTime,
                                end : item.DueEndDateTime,
                                description: item.Description,
                                backgroundColor:item.Colorname,
                                allDay : false,
                                textColor: 'black'
                              };
                    });
                    this.events = [];
                    
                    console.log('events >> '+JSON.stringify(events));
                    this.error = undefined;
                    const ele = this.template.querySelector("div.fullcalendarjs");
                    
                    $(ele).fullCalendar( 'removeEvents');
                    this.events = JSON.parse(JSON.stringify(events));
                    $(ele).fullCalendar( 'renderEvents', this.events, true);
                    this.openSpinner = false;
                    this.searchDealList = [];
                    this.searchBookingList = [];
                    console.log('this.events >> '+JSON.stringify(this.events));
                    //return refreshApex(this.eventOriginalData);
                    //this.initialiseFullCalendarJs();
                })
                .catch(error => {
                    console.log('Error while fetching Picklist values' + JSON.stringify(error));
                    this.error = error;
                    this.contacts = undefined;
                });
        }
    }

    searchDealKeyword(event) {
        this.searchDealValue = event.detail.value;
            
        console.log('this.searchDealValue'+ this.searchDealValue );
       
         
    } 

    searchKeyword(event) {
        this.searchBookingId = event.detail.value;
            
        console.log('this.searchBookingId'+ this.searchBookingId );
       
         
    } 




    clearfilter(event){
    console.log('book12---->');

        this.searchDealValue = null;
        this.searchBookingId=null;
        
       

        this.events = [];
        //this.removeRecord(undefined);
                    
                    console.log('events >> '+JSON.stringify(this.events));
                    this.error = undefined;
                    const ele = this.template.querySelector("div.fullcalendarjs");
                    
                    $(ele).fullCalendar( 'removeEvents');
                    this.events = this.eventdataBackup;
                    $(ele).fullCalendar( 'renderEvents', this.events, true);

                    var removedealTypeOptions = this.dealtypeOptions;

                    for(let i=0; i < removedealTypeOptions.length; i++){
                        if(removedealTypeOptions[i].isChecked){
                            removedealTypeOptions[i].isChecked = false;
                            removedealTypeOptions[i].class = this.dropdownList;
                    
                     }
                    
                    }

                    this.selectedDealtypes = 'Select Deal Type';

                    this.selectedDealType= null;

                    this.dealtypeOptions=removedealTypeOptions;

                    console.log('clearfilter---->');

                    
    console.log('searchValueForBooking'+this.searchValueForBooking);
    console.log('searchValueForDeal'+this.searchValueForDeal);
    console.log('searchValueForBooking------>>'+JSON.stringify(this.searchValueForBooking));
    console.log('searchValueForDeal------->>'+JSON.stringify(this.searchValueForDeal));
                }
    selectOption(event){

        var isCheck = event.currentTarget.dataset.id;
        var label = event.currentTarget.dataset.name;
        console.log('label '+label +'& ischeck '+isCheck);
        var selectedListData=[];
        
        var selectedOption='';
        var allOptions = JSON.parse(JSON.stringify(this.dealtypeOptions));
        var count=0;
        console.log('allOptions length '+allOptions.length);
        for(let i=0;i<allOptions.length;i++){ 
            if(allOptions[i].label===label)
                { 
                    console.log('allOptions[i].label '+JSON.stringify(allOptions[i].label));
                    if(isCheck==='true')
                    { 
                    allOptions[i].isChecked = false;
                    allOptions[i].class = this.dropdownList;
                    }
                    else
                    { 
                    allOptions[i].isChecked = true; 
                    allOptions[i].class = 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-media_center slds-is-selected';
                    }
                    
                }
                if(allOptions[i].isChecked)
                { 
                    console.log('here in this checked ');
                selectedListData.push(allOptions[i].label); 
                count++; 
                } 
            
            
            }
                if(count === 1){
                selectedOption = count+' Type Selected';
                }
                else if(count>1){
                selectedOption = count+' Types Selected';
                }
                
                this.dealtypeOptions = allOptions;
                this.selectedValueType = selectedOption;
                if(selectedListData){
                this.selectedDealType = selectedListData;
                }
                console.log('selectedDealType after '+this.selectedDealType);
        }

        removeDealTypeRecord(event){
         console.log('here in ');
         var value = event.detail.name;
         var removedOptions = JSON.parse(JSON.stringify(this.dealtypeOptions));
         var count = 0;
         var selectedListData=[];
        
       
            for(let i=0; i < removedOptions.length; i++){
        
                if(removedOptions[i].label === value){
                removedOptions[i].isChecked = false;
                removedOptions[i].class = this.dropdownList;
                }
        
                if(removedOptions[i].isChecked){
                selectedListData.push(removedOptions[i].label); 
                count++;
                }   
            }
        
                var selectedOption;
                if(count === 1){
                selectedOption = count+' Type Selected';
                }
                    else if(count>1){
                    selectedOption = count+' Types Selected';
                    }
                        else if(count === 0){
                        selectedOption = 'Select deal type';
                        selectedListData = "";
                        }
                        
                            this.selectedDealType = selectedListData;
                        console.log('removed selectedDealType '+this.selectedDealType);
            
            this.selectValueType = selectedOption;
            this.dealtypeOptions = removedOptions;

       
     } 
     handleClose() {
        this.openModal = false;
        this.parentdata = null;
        this.childdata = null;
      }

      handleSaveActivity() {
        saveActivityStatus({parentdatalist:this.parentdata,childdatalist:this.childdata})
        .then((result)=>{
            this.parentdata = null;
            this.childdata = null;
            this.openModal = false;
            console.log('this point');
        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.log(error);
        });

      }
       //Save parent & child status fields..
    parentdataevent(event) {

        console.log('second part');
       var filters = []
        filters =  event.detail.wrapperObj;
        console.log('filters=========>',filters);

        this.parentdata = filters;
        console.log('parentdata'+this.parentdata);
    }

    childdataevent(event) {

        console.log('third part');
       var filters = []
        filters =  event.detail.wrapperObj;
        console.log('filters====1=====>',filters);

        this.childdata = filters;
        console.log('childdata'+this.childdata);
    }
}