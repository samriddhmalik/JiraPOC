import { LightningElement, api,track } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveActivityRecord from '@salesforce/apex/SearchInventoryController.saveActivityRecord';

import DeleteActivityRecord from '@salesforce/apex/SearchInventoryController.DeleteActivityRecord';
import ActivityRecordOnLoad1 from '@salesforce/apex/SearchInventoryController.ActivityRecordOnLoad1';

/*************Above is all the services which are import in this LWC from server side*******************/

/*******************************************************************************************************/



export default class TAD_reusableMarketingActivityViewLWC extends LightningElement {

    /*******************************************************************************************************/
 @track wrapperUsavedActivityChecked; /******Wrapper*********/
   @track wrappersavedActivityChecked;/***********Lists******************/
  @track wrapperUnsavedActivityAftrCancel;/*****To Fetch From************************/
 @track wrapperSavedActivityAftrCancel;/********Parent*********************/
  @track wrapperUnsavedActivity;/****************Lwc*************/
   @track WrapperSavedActivity;/**********searchInventory*******************/
@api forInventryEventChild;
    @api headingName;
    @api checkboxName;
    @api checkboxNameParent;
    @api checkboxNameChild;
  @api country;
    @api commentClassName;
    @api commentParentClassName;
    @api commentChildClassName
    @api deleteTitle;
    @api saveTitle;
    @api cancelTitle;
    @api pendingTitle;
    @api enableTitle;
    @api checkAllName;
    @api wrapperActivityData;
    @api inputLabel;
    @api inputClone;
    @api unsavedListToParent;
  @api wrapperActivityChecked;
  @track wrapperActivityCancel;
  @track isLoading=false;
  @track isChecked=false;
 

  

/******Above is all the variables used in this LWC where api decorator denotes communicating globally and track denotes communicating locally*******************/

    /*************Function to get Data from parent LWC is below*******************/
    @api
    childMethodActivityWrapper(WrapperWithoutCheck, WrapperWithCheck, WrapperbeforeCancel ) {
        this.wrapperUnsavedActivity = WrapperWithoutCheck;
        this.wrapperUsavedActivityChecked = WrapperWithCheck;
        if(WrapperbeforeCancel != null){
            this.wrapperUnsavedActivityAftrCancel = WrapperbeforeCancel;
        }
       
       
            if(this.wrapperUnsavedActivity && this.wrapperUsavedActivityChecked){
                refreshApex(this.wrapperUnsavedActivity);
            }
        }

    @api
    unsavedActivityWrapperShowAfterdrag(unsavedWrapperWithoutCheck, unsavedWrapperAfterCancel ) {
        console.log('unsavedWrapperWithoutCheck '+unsavedWrapperWithoutCheck+' & unsavedWrapperAfterCancel '+unsavedWrapperAfterCancel);
        this.wrapperUnsavedActivity = unsavedWrapperWithoutCheck;
        this.wrapperUnsavedActivityAftrCancel = unsavedWrapperAfterCancel;
        this.wrapperUsavedActivityChecked = unsavedWrapperWithoutCheck;
            
            if(this.wrapperUnsavedActivity && this.wrapperUnsavedActivityAftrCancel){
                refreshApex(this.wrapperUnsavedActivity);
                refreshApex(this.wrapperUnsavedActivityAftrCancel);
                refreshApex(this.wrapperUsavedActivityChecked);
            }
        }
        @api
        savedActivityWrapperShowOnload(unsavedWrapperWithoutCheck) {
            console.log('unsavedWrapperWithoutCheck==========> '+unsavedWrapperWithoutCheck);
            this.WrapperSavedActivity = unsavedWrapperWithoutCheck;
            this.wrapperSavedActivityAftrCancel = unsavedWrapperWithoutCheck;
            this.wrapperSavedActivityChecked = unsavedWrapperWithoutCheck;
                
                if(this.wrapperSavedActivityAftrCancel && this.WrapperSavedActivity){
                    refreshApex(this.WrapperSavedActivity);
                    refreshApex(this.wrapperSavedActivityAftrCancel);
                    refreshApex(this.wrapperSavedActivityChecked);
                }
            }
    
   

            


     /*************Functions to pass Data from this LWC to parent LWC is below*******************/
      
     /*************Functions to saveActivity Data from this LWC is below*******************/
     /*
     saveActivityRecordNow(event){
        if(event.target.title == 'Save'){
            console.log('in save record '+JSON.stringify(this.wrapperActivityChecked));
            var wrapperObj = { tempWrapperList: JSON.parse(JSON.stringify(this.wrapperActivityChecked))};
            const selectedEvent = new CustomEvent('saveactivity', {
                detail: wrapperObj 
            });
             //dispatching the custom event
            this.dispatchEvent(selectedEvent);
        }else{

        }
     }
*/
     /*************Function to Cancel the changes in Data from button click is below*******************/
    /* CancelActivityRecordNow(event){
        var wrapperObj = {title : event.target.title, tempWrapperList1:this.wrapperActivityChecked, tempWrapperList: this.wrapperUnsavedActivityAftrCancel};
                const selectedEvent = new CustomEvent('cancelactivity', {
                    detail: wrapperObj 
                });
                 //dispatching the custom event
                this.dispatchEvent(selectedEvent);


        
    }*/



     /*************Function to pending Data from onclick on pending button is below*******************/
    /* pendingActivity(event){
            
        if(event.target.title == 'Pending Saved'){
           
            var wrapperObj = {title : event.target.title, tempWrapperList:this.wrappersavedActivityChecked};
                const selectedEvent = new CustomEvent('pendingactivity', {
                    detail: wrapperObj 
                });
                 //dispatching the custom event
                this.dispatchEvent(selectedEvent);
        }
        if(event.target.title == 'Pending'){
            
            var wrapperObj = {title : event.target.title, tempWrapperList: this.wrapperActivityChecked};
                const selectedEvent = new CustomEvent('pendingactivity', {
                    detail: wrapperObj 
                });
                 //dispatching the custom event
                this.dispatchEvent(selectedEvent);

        }
       
    }*/

     /*************Function to Enable Data from onclick on pending button is below*******************/
   /*  EnableActivity(event){
        console.log(' event.target.getAttribute '+event.target.title);
        
        if(event.target.title == 'Enable Saved'){  
            var wrapperObj = {title : event.target.title, tempWrapperList:this.wrappersavedActivityChecked};
                const selectedEvent = new CustomEvent('enableactivity', {
                    detail: wrapperObj 
                });
                 //dispatching the custom event
                this.dispatchEvent(selectedEvent);

        }

        if(event.target.title == 'Enable'){
            var wrapperObj = {title : event.target.title, tempWrapperList:this.wrapperActivityChecked};
            const selectedEvent = new CustomEvent('enableactivity', {
                detail: wrapperObj 
            });
             //dispatching the custom event
            this.dispatchEvent(selectedEvent);

        }
    }*/
     /*************Function to Save comment in wrapper List from onchange is below*******************/
     saveComment(event){
        
        var unsavedOrSaved = event.target.getAttribute('class');
        console.log('unsavedOrSaved '+unsavedOrSaved);

        if(unsavedOrSaved.includes('02savedparent')){
            console.log('here in this saved parent comment ');
           
            var parentIndex = event.target.name;
            console.log('parentIndex savedparentcomment',parentIndex);
            
            var i = event.target.getAttribute('data-id');
            console.log('i savedparentcomment',i);
           // console.log('WrapperSavedActivity savedparentcomment=====>',this.WrapperSavedActivity);
            
            let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
            console.log('tempWrapperList savedparentcomment',tempWrapperList);
            tempWrapperList[parentIndex].wrapperparentWithChild[i].objParentvariable.ms_Comment = event.target.value;
           // this.wrapperActivityCancel =this.inputLabel ;
           
            this.inputLabel = tempWrapperList;
            this.wrapperActivityChecked = tempWrapperList;

        }
        if(unsavedOrSaved.includes('02savedchild')){
            console.log('here in this Saved child comment ');
           
            var parentIndex = event.target.name;
           // console.log('parentIndex savedchildcomment',inputLabel);
           
            var i = event.target.getAttribute('data-id');
            var j = event.target.getAttribute('data-id2');
          
            let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
            tempWrapperList[parentIndex].wrapperparentWithChild[i].objChildListVariable[j].Comments = event.target.value;
            //this.wrapperActivityCancel =this.inputLabel ;
            this.inputLabel = tempWrapperList;
            this.wrapperActivityChecked = tempWrapperList;

        }
       /* if(unsavedOrSaved.includes('01unsavedparent')){
            console.log('here in this usnsaved parent comment');
           
            var parentIndex = event.target.name;
            console.log('parentIndex usnsavedparentcomment',parentIndex);
            
            var i = event.target.getAttribute('data-id');
            console.log('i ** usnsavedparentcomment',i);
            
            let tempWrapperList = this.wrapperUnsavedActivity;
            console.log('tempWrapperList ** usnsavedparentcomment',i);
           
            tempWrapperList[parentIndex].wrapperparentWithChild[i].objParentvariable.ms_Comment = event.target.value;
            this.wrapperUnsavedActivity = tempWrapperList;
            this.wrapperUsavedActivityChecked = tempWrapperList;
          
        }
       

        if(unsavedOrSaved.includes('01unsavedchild')){
            console.log('here in this unsaved child comment')
            var parentIndex = event.target.name;
            var i = event.target.getAttribute('data-id');
            var j = event.target.getAttribute('data-id2');
          
            let tempWrapperList = this.wrapperUnsavedActivity;
            tempWrapperList[parentIndex].wrapperparentWithChild[i].objChildListVariable[j].Comments = event.target.value;
            this.wrapperUnsavedActivity = tempWrapperList;
            this.wrapperUsavedActivityChecked = tempWrapperList;
          
        }
        */
        

    }

     /*************Function to check Data from checkbox on pending button is below*******************/
     check(event){
        var savedUnsaved = event.target.name;

            console.log('event.target.checked here '+event.target.checked );
            if(savedUnsaved == 'checkForParent'){
            console.log('Check Shubham01');
                var childIndex1 = event.target.class;
               
                var childIndex = event.target.getAttribute('data-id2');
                
                var parentIndex = event.target.getAttribute('data-id');
                console.log('childIndexParent',childIndex);
               console.log('parentIndexParent',parentIndex);
               console.log('childIndex1Parent',childIndex1);
              
                let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
                tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objParentvariable.CheckOrUncheck = event.target.checked;

                if( tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objChildListVariable!=null &&  tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objChildListVariable!=undefined)
                {
               for(var l=0; l < tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objChildListVariable.length; l++){
                   tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objChildListVariable[l].CheckOrUncheck = event.target.checked; 
               
                }
            }
                this.inputLabel = tempWrapperList;
                this.wrapperActivityChecked = tempWrapperList;
               // console.log('wrapperUsavedActivityChecked in check '+JSON.stringify(this.wrapperUsavedActivityChecked));
            
            }     
            
            if(savedUnsaved == 'checkForChild'){

                var childIndex1 = event.target.class;
               
                var childIndex = event.target.getAttribute('data-id2');
                
                var parentIndex = event.target.getAttribute('data-id');
               
                var Index = event.target.getAttribute('data-id3');
               console.log('childIndex',childIndex);
               console.log('parentIndex',parentIndex);
               console.log('Index',Index);
               console.log('childIndex1',childIndex1);
                let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
                tempWrapperList[parentIndex].wrapperparentWithChild[childIndex].objChildListVariable[Index].CheckOrUncheck = event.target.checked;
                this.inputLabel = tempWrapperList;
                this.wrapperActivityChecked = tempWrapperList;
               // console.log('wrapperUsavedActivityChecked in check '+JSON.stringify(this.wrapperUsavedActivityChecked));
            
            }
            /*
            else if(savedUnsaved == 'checkForSavedParent'){ 
                var childIndexForSaved = event.target.getAttribute('data-id2');
                console.log('Check Shubham02');
            
                var parentIndexForSaved = event.target.getAttribute('data-id');
                console.log('childIndexForSaved  '+childIndexForSaved+' & parentIndexForSaved '+parentIndexForSaved);
                let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));

                tempWrapperList[parentIndexForSaved].wrapperparentWithChild[childIndexForSaved].objParentvariable.CheckOrUncheck = event.target.checked; 
               // for(var l=0; l < tempWrapperList[parentIndexForSaved].wrapperparentWithChild[childIndexForSaved].objChildListVariable.length; l++){
               //     tempWrapperList[parentIndexForSaved].wrapperparentWithChild[childIndexForSaved].objChildListVariable[l].CheckOrUncheck = event.target.checked; 
               
                //}
                this.wrappersavedActivityChecked = tempWrapperList;
                this.WrapperSavedActivity = tempWrapperList;
              
            }
            else if(savedUnsaved == 'checkForSavedChild'){ 
                var childIndexForSaved = event.target.getAttribute('data-id2');
                
                var parentIndexForSaved = event.target.getAttribute('data-id');
                var Index = event.target.getAttribute('data-id3');
               
                console.log('childIndexForSavedchild  '+childIndexForSaved+' & parentIndexForSavedchild '+parentIndexForSaved);
                let tempWrapperList = JSON.parse(JSON.stringify(this.WrapperSavedActivity));

                tempWrapperList[parentIndexForSaved].wrapperparentWithChild[childIndexForSaved].objChildListVariable[Index].CheckOrUncheck = event.target.checked; 
                this.wrappersavedActivityChecked = tempWrapperList;
                this.WrapperSavedActivity = tempWrapperList;
              
            }
*/



    }


     /*************Function to check All Data from checkbox on pending button is below*******************/
     
     checkAll(event){
        //var test =event.target.checked;
        this.isChecked=event.target.checked;
        console.log('Checkalltesting'+this.isChecked);
        var savedOrUnsaved = event.target.getAttribute('name');

        var atLeastOneChecked = false;
        console.log('atLeastOneChecked'+atLeastOneChecked);
        if(this.inputLabel!=null && this.inputLabel!=undefined)
        {
            atLeastOneChecked = true;
            console.log('atLeastOneChecked--->'+atLeastOneChecked);
        let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));

            
        
            if (this.isChecked == true) {
                
                for(var j=0; j < tempWrapperList.length; j++){
                    for(var k=0; k < tempWrapperList[j].wrapperparentWithChild.length; k++){
                        tempWrapperList[j].wrapperparentWithChild[k].objParentvariable.CheckOrUncheck = true;
                        if(tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable!=null && tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable!=undefined)
                        {
                        for(var l=0; l < tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable.length; l++){
                        tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable[l].CheckOrUncheck = true;
                         }
                    }
                }
                
                }
                this.wrapperActivityChecked = tempWrapperList;
                       
                this.inputLabel = tempWrapperList;
            
            }
                          
            else {
                

                for(var j=0; j < tempWrapperList.length; j++){
                    for(var k=0; k < tempWrapperList[j].wrapperparentWithChild.length; k++){
                        tempWrapperList[j].wrapperparentWithChild[k].objParentvariable.CheckOrUncheck = false;
                        if(tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable!=null && tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable!=undefined)
                        {
                        for(var l=0; l < tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable.length; l++){
                        tempWrapperList[j].wrapperparentWithChild[k].objChildListVariable[l].CheckOrUncheck = false;
                        
                        }
                    }
                    }
                }
                this.inputLabel = tempWrapperList;
                this.wrapperActivityChecked = tempWrapperList;

            }

        }
            if(atLeastOneChecked == false){
                const evt = new ShowToastEvent({
                    title: 'Warning',
                    message: 'No records available!',
                    variant: 'warning',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }


        }
        
     

   /*************Function to Remove row data from the table as well as do delete from backend onclick of Delete button is below*******************/
   /*
   RemoveRecord(event){
       
        var i = event.target.getAttribute('data-id');
        var parentIndex = event.target.value;
        console.log('parentIndex '+parentIndex+' i '+i);
        console.log(' event.target.title '+event.target.title);
         if(event.target.title == 'Delete'){
            let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
            //creating an object in javaScript with parameter i, parentIndex and tempWrapperList 
            var wrapperObj = {i: i, parentIndex : parentIndex, tempWrapperList: tempWrapperList, title:event.target.title};
            const selectedEvent2 = new CustomEvent('removeactivity', {
                detail: wrapperObj 
            });
             //dispatching the custom event
            this.dispatchEvent(selectedEvent2);
            

         }
         
    }
*/
/*************Function to navigate Back onclick of Back button is below*******************/
    callParentNavigation(){
        const selectedEvent2 = new CustomEvent('navigateback');
         //dispatching the custom event
        this.dispatchEvent(selectedEvent2);
    }





    EnableActivity(event){
        console.log('event.detail.title '+event.detail.title);
        var atLeastOneChecked = false;
        let tempWrapperList;
       
       
        if(this.wrapperActivityChecked!=null && this.wrapperActivityChecked!=undefined)
          {
        tempWrapperList = JSON.parse(JSON.stringify( this.wrapperActivityChecked));
          console.log('tempWrapperList in enable'+tempWrapperList)
            
            if(tempWrapperList.length > 0){
                for(var i=0; i<tempWrapperList.length; i++){
                    if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                   
                        for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                           
                             if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                 if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                     console.log('here in check001');
                                    
                                     tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Active';
                                     atLeastOneChecked = true;
                                 }
                                 if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=undefined)
                                 {
                                    if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                   
                                
                                 for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                         if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true){
                                             console.log('here in check002');
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
                //this.wrapperActivityCancel =this.inputLabel ;
                console.log('test01');
                this.inputLabel = tempWrapperList;
             this.wrapperActivityChecked = tempWrapperList;
             //this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList, tempWrapperList, null);
            
            }

        
    }

    

    pendingActivity(event){
     
        console.log(' event.detail.title '+event.target.title);
       
            var atLeastOneChecked = false;
            let tempWrapperList;
            console.log('535'+JSON.stringify( this.wrapperActivityChecked));
          if(this.wrapperActivityChecked!=null && this.wrapperActivityChecked!=undefined)
          {
            tempWrapperList = JSON.parse(JSON.stringify( this.wrapperActivityChecked));
            console.log('tempWrapperList pendingActivity'+JSON.stringify(tempWrapperList));
            for(var i=0; i< tempWrapperList.length; i++){
               
                if(tempWrapperList[i] != null && tempWrapperList[i] != undefined){
                   
                        for(var j=0; j< tempWrapperList[i].wrapperparentWithChild.length;  j++){
                           if(tempWrapperList[i].wrapperparentWithChild[j] != null && tempWrapperList[i].wrapperparentWithChild[j] != undefined ){
                                if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                    console.log('here in check001');
                                    tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.Activity = 'Pending';
                                    atLeastOneChecked = true;
                                }
                                if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=undefined)
                                {
                                    
                                for(var k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                    if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k] != undefined ){
                                        if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ||  tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true){
                                            console.log('here in check002');
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
               // this.wrapperActivityCancel =this.inputLabel ;
               console.log('test01');
               console.log('586'+JSON.stringify(this.inputLabel));
                this.inputLabel = tempWrapperList;
                console.log('588'+JSON.stringify(tempWrapperList));
                this.wrapperActivityChecked = tempWrapperList;
            }
        }
        
       
       
    

        CancelActivityRecordNow(event){
       
            this.isChecked=false;
            var atLeastOneChecked = false;

            
            if(this.wrapperActivityChecked!=null && this.wrapperActivityChecked!=undefined && this.inputLabel !=null && this.inputLabel != undefined  && this.inputLabel != '')
            {
                atLeastOneChecked = true;
               let tempWrapperList1 = JSON.parse(JSON.stringify(this.wrapperActivityChecked));
                console.log(' tempWrapperList1 '+JSON.stringify(tempWrapperList1));
    
                let tempWrapperList = JSON.parse(JSON.stringify(this.inputClone));
                console.log(' tempWrapperList '+JSON.stringify(tempWrapperList));
                for(var i=0; i< tempWrapperList1.length; i++){

                    for(var j=0; j< tempWrapperList1[i].wrapperparentWithChild.length;  j++){
                             if(tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true ){
                                 console.log('here in check--614');
                                 tempWrapperList1[i] = tempWrapperList[i];
                                // tempWrapperList1[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck = false;
                                
                             }
                             console.log('here in check--619');
                             
                             if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=undefined)
                                {
                                    console.log('here in check--624');
                             for(var k=0; k< tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable.length;  k++){
                                     if(tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true ){
                                         console.log('here in check--627');
                                         tempWrapperList1[i] = tempWrapperList[i];
                                        // tempWrapperList1[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck = false;
                                        
                                     }
                                 }        
                                
                            }
                        
                     
    
                }
            }
               if(tempWrapperList1.length > 0){
                this.inputLabel= tempWrapperList1 ;
                this.inputClone = tempWrapperList;
                this.wrapperActivityChecked = tempWrapperList1;
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
            }
        
        
        }
    



        
saveActivityRecordNow(event){
    
    this.isChecked=false;
   
        console.log('671');
     if(this.inputLabel != null && this.inputLabel != undefined) { 
    var checkOrUncheck =  this.validateWrapperIfCheck(this.inputLabel);
    console.log('672---->'+checkOrUncheck);
    console.log('tempWrapperList===============00>',JSON.stringify(this.inputLabel));
    let saveUnsave = this.headingName;
    console.log('saveUnsave==========> '+saveUnsave);
    let recordstoprocess =[];
       
    let tempWrapperList = this.inputLabel;
    console.log('tempWrapperList===============01>',JSON.stringify(this.inputLabel));
    let tempList = JSON.parse(JSON.stringify(this.inputLabel));
    
    console.log('678>',JSON.stringify(this.inputLabel));
    let templist2=[];
    var wrapListToProcess =  this.inputLabel;
    console.log('checkOrUncheck==========> '+checkOrUncheck);
    if(checkOrUncheck == true){
      
        this.isLoading = true;
       if(saveUnsave=='Unsaved')
       {
        
        recordstoprocess = this.inputLabel;
        for(let i = 0; i < tempWrapperList.length; i++){
           
            //console.log(' tempWrapperList[i].wrapperparentWithChild===========> '+JSON.stringify(tempWrapperList[i].wrapperparentWithChild));
            console.log('length===>',tempWrapperList[i].wrapperparentWithChild.length);

           let k= (tempWrapperList[i].wrapperparentWithChild.length) - 1;
            for(let j=k; j>=0; j--){
               console.log('in this loop');
                    if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true)
                    {
                        console.log('in this condition');
                        
                        tempList[i].wrapperparentWithChild.splice(j,1);
        

                    }

                   
                  }
                
                  
                  if(tempList[i].wrapperparentWithChild.length>=1){ 

                    console.log('xyz=======>')
                    templist2.push(tempList[i]);
                }
                 
            
    }
       

    
    console.log('tempList2=======>'+templist2);
                  

console.log('recordstoprocess=======>',recordstoprocess);

}
else if(saveUnsave=='Saved')
{
    recordstoprocess = this.inputLabel;
    console.log('recordstoprocess=======**>',recordstoprocess);

}
       


       
        
console.log('saveUnsave==========>before '+saveUnsave);
   
        saveActivityRecord({unsavedWrapperList :recordstoprocess ,Operation:saveUnsave,countryname:this.country})
    .then((result) =>{
        this.isLoading = false;
        console.log(' result '+JSON.stringify(result));
       
            const evt = new ShowToastEvent({
                title: 'success',
                message: 'The record is saved successfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);

 
        
        if(saveUnsave='Unsaved')
        {
            var wrapperObj =templist2;
            console.log('wrapperObj=761=>',wrapperObj);
                    const selectedEvent = new CustomEvent('saveactivity', {
                        detail: {wrapperObj} 
            });
            this.dispatchEvent(selectedEvent);
          
        }
        if(saveUnsave='Saved')
        {
            var wrapperObj =templist2;
            console.log('wrapperObj=771=>',wrapperObj);
                    const selectedEvent = new CustomEvent('saved', {
                        detail: {wrapperObj} 
            });
            this.dispatchEvent(selectedEvent);
          
        }

        })
        .catch(error => {
            // eslint-disable-next-line no-console
            console.log(error);
        });
       // this.isLoading = false;
       this.wrapperActivityChecked = null;

}
else{
    
    const evt = new ShowToastEvent({
        title: 'Warning',
        message: 'Please select checkbox to save Marketing Actitvity Record!',
        variant: 'warning',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
    
}
 
}
}




 
 validateWrapperIfCheck(wrapperChecked){
    
    let saveUnsave = this.headingName;
    console.log('saveUnsave====>check====c>',saveUnsave);
    var checkList =[];
  console.log('808'+JSON.stringify(wrapperChecked));
  if(wrapperChecked !=null && wrapperChecked != undefined && wrapperChecked !=''){
    if(saveUnsave == 'Unsaved')
    {
        console.log('801'+JSON.stringify(wrapperChecked));
    let tempWrapperList = JSON.parse(JSON.stringify(wrapperChecked));
    console.log('803'+tempWrapperList);
    console.log('806'+JSON.stringify(wrapperChecked));
    var check = true;
    for(let i = 0; i < tempWrapperList.length; i++){
        //console.log(' tempWrapperList[i].wrapperparentWithChild '+JSON.stringify(tempWrapperList[i].wrapperparentWithChild));
        console.log('810');
        for(let j=0; j< tempWrapperList[i].wrapperparentWithChild.length; j++){
           var count=0;
            if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=undefined )
            {
                console.log('815');
            for(let k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length; k++){

                if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == false && tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == false)
                {
                    check = false;
                    console.log('821');
                }
                
                if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true && tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true)
                {
                    count++;
                    check = true;
                    console.log('828');

                }
              


        }
        if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length == count)
        {
            console.log('truelog');
            check = true;
        }

    }

    }
}
    return check;

}
else
{
    console.log('850');
let tempWrapperList = JSON.parse(JSON.stringify(wrapperChecked));
var check = false;
for(let i = 0; i < tempWrapperList.length; i++){
    //console.log(' tempWrapperList[i].wrapperparentWithChild '+JSON.stringify(tempWrapperList[i].wrapperparentWithChild));
    for(let j=0; j< tempWrapperList[i].wrapperparentWithChild.length; j++){
        if(tempWrapperList[i].wrapperparentWithChild[j].objParentvariable.CheckOrUncheck == true){
            console.log('test case01');
            check = true;
        }
        if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=null && tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable!=undefined )
            {

            for(let k=0; k< tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable.length; k++){
                if(tempWrapperList[i].wrapperparentWithChild[j].objChildListVariable[k].CheckOrUncheck == true)
                {
                    console.log('test case02');
                    check = true;  
                }
                
            }
        }


        
    }
}
return check;

}
}   

}
 
 




RemoveRecord(event){
        
    let saveUnsave = this.headingName;
    var i = event.target.getAttribute('data-id');
    var parentIndex = event.target.value;  
    if( saveUnsave == 'Saved'){
        
        
        console.log('parentIndex '+parentIndex+' i '+i);
        let tempWrapperList = JSON.parse(JSON.stringify(this.inputLabel));
        this.dodeleteActivity(tempWrapperList[parentIndex].wrapperparentWithChild[i]);
        tempWrapperList[parentIndex].wrapperparentWithChild.splice(i,1);
        console.log('tempWrapperList '+JSON.stringify(tempWrapperList));
        if(tempWrapperList[parentIndex].wrapperparentWithChild.length < 1){
            tempWrapperList.splice(parentIndex,1);
        }
        
        //this.wrapperSavedActivityAftrCancel = tempWrapperList;
        this.inputLabel = tempWrapperList;
        this.inputClone = tempWrapperList;
        this.wrapperActivityChecked = tempWrapperList;
        var wrapperObj =tempWrapperList;
        console.log('wrapperObj==>',wrapperObj);
                const selectedEvent = new CustomEvent('deletesavedactivity', {
            detail: {wrapperObj} 
        });
        this.dispatchEvent(selectedEvent);
  

    }
    if( saveUnsave == 'Unsaved'){

        console.log('parentIndex unsaved'+parentIndex+' i '+i);
        let tempWrapperList =JSON.parse(JSON.stringify(this.inputLabel));
        console.log('tempWrapperList before'+JSON.stringify(tempWrapperList));
            tempWrapperList[parentIndex].wrapperparentWithChild.splice(i,1);
          // temWrapperList[0].wrapperparentWithChild[0] = null;
          
          
      
       console.log('part1',tempWrapperList);
        if(tempWrapperList[parentIndex].wrapperparentWithChild.length < 1){   
           tempWrapperList.splice(parentIndex,1);
            console.log('part2');
       }
        this.inputLabel = tempWrapperList;
        this.inputClone = tempWrapperList;
        this.wrapperActivityChecked = tempWrapperList;
        var wrapperObj =tempWrapperList;
            console.log('wrapperObj==>',wrapperObj);
                    const selectedEvent = new CustomEvent('deleteunsavedactivity', {
                detail: {wrapperObj} 
            });
            this.dispatchEvent(selectedEvent);
        //this.template.querySelector('c-t-a-d-_reusable-marketing-activity-view-l-w-c').childMethodActivityWrapper(tempWrapperList, tempWrapperList, tempWrapperList);

     }
     
}


dodeleteActivity(wrappertoDelete){
    console.log('wrappertoDelete '+JSON.stringify(wrappertoDelete));
    DeleteActivityRecord({deleteSavedWrapper : wrappertoDelete })
    .then((result) =>{
        if(result == true){
            console.log('deleted');
        }
    })
    .catch(error => {
        // eslint-disable-next-line no-console
        console.log(error);
    });
}

}