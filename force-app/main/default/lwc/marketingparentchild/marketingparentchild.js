import { LightningElement , wire ,track, api } from 'lwc';
import ParentActivityRecordOnLoad from '@salesforce/apex/ms_parentchild.ParentActivityRecordOnLoad';
import ChildActivityRecordOnLoad from '@salesforce/apex/ms_parentchild.ChildActivityRecordOnLoad';
import UpdateActivityStatus from '@salesforce/apex/ms_parentchild.UpdateActivityStatus';
import getPicklistvalues from '@salesforce/apex/ms_parentchild.getPicklistvalues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Marketingparentchild extends LightningElement {

@api recordId;   
@api parentActivity;
@api childActivity;
@api StatusPicklist;
@api showchild;
@api showtable;
@api showmsg;
connectedCallback(){
    this.showtable=true;
    this.showchild=true;
    this.showmsg=false;
    this.getdata();

}


getdata()
{
    ParentActivityRecordOnLoad({ActivityId : this.recordId}) 
    .then( (result) => {   
        console.log('result parent=============>',result);
    
            console.log('in this blog');
            
        
    this.parentActivity = result;
    if(this.parentActivity[0].ActivityStatus=='Pending'||this.parentActivity[0].ActivityStatus=='Deferred')
    {
        this.showchild=false;

        /*if(this.parentActivity[0].ActivityStatus=='Deferred')
        {
            this.showmsg= true;
            this.showtable=false;
        }*/
    }
    else{
        this.showchild=true; 
    }
    console.log('parentActivity==============>>>',this.parentActivity);
        
    
     }).catch(error => {
        // this.resultsum = undefined;
         console.log('error-- '+JSON.stringify(error));
     });
   
     ChildActivityRecordOnLoad({ActivityId : this.recordId}) 
     .then( (result) => {   
         console.log('result child=============>',result);
     
             console.log('in this blog');
             
         
     this.childActivity = result;
     
         
     
      }).catch(error => {
         // this.resultsum = undefined;
          console.log('error-- '+JSON.stringify(error));
      });

      getPicklistvalues({objectName :'Marketing_Spend__c',field_apiname :'ms_Status__c'}) 
      .then( (result) => {   
          console.log('result=============>',result);
      
              console.log('in this blog');
              
          
      this.StatusPicklist = result;
      
          
      
       }).catch(error => {
          // this.resultsum = undefined;
           console.log('error-- '+JSON.stringify(error));
       });
     
 


}


handleChangeParent(event) {
    let i = event.target.name;
 this.parentActivity[i].ActivityStatus = event.detail.value;
 if(event.detail.value=="Pending" || event.detail.value=="Deferred")
 {
 this.showchild = false;
 }
 else
 {
    this.showchild = true; 
 }
 }


 handleChangeChild(event) {
    let i = event.target.name;
 this.childActivity[i].ActivityStatus = event.detail.value;
 }


 updateActivityRecordNow(event)
 {
    UpdateActivityStatus({parentActivity : this.parentActivity,childActivity:this.childActivity}) 
    .then( (result) => {   
        console.log('result child=============>',result);
        const evt = new ShowToastEvent({
            title: 'success',
            message: 'The Status are updated successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        this.getdata();
        const value = false;
        const valueChangeEvent = new CustomEvent("valuechange", {
            detail: { value }
          });
          this.dispatchEvent(valueChangeEvent);
            
    
     }).catch(error => {
        // this.resultsum = undefined;
         console.log('error-- '+JSON.stringify(error));
     });



 }


}