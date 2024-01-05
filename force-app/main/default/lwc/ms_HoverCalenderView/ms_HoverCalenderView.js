import { LightningElement,wire,track,api} from 'lwc';
import fetchActivityDetailsParent from '@salesforce/apex/ms_HoverCalendarView.fetchActivityDetailsParent';
import fetchActivityDetailsChild from '@salesforce/apex/ms_HoverCalendarView.fetchActivityDetailsChild';
import getPicklistvalues from '@salesforce/apex/ms_HoverCalendarView.getPicklistvalues';


export default class Ms_HoverCalenderView extends LightningElement {

    @api activityid;
    @api description; 
    @track newspaper=false;
    @track social=false;
    @track EDMIKPT=false;
    @track EDMTAD=false;
    @track Radio=false;
    @track Preroll=false;
    @track Search=false;
    @track Website=false;
    @track isChild=false;
    
    @api parentRecord;
    @api childRecord;
    @track ApprovalStatusPkl;
    @track SubstatusPkl;
    @track StatusPkl;
    @api activityDate;


    connectedCallback(){
        this.getdata();
        this.showtable=true;
        this.showchild=true;
        this.showmsg=false;
        //console.log('activityDate======>',activityDate);
        console.log('activityDate==1====>'+this.activityDate);
    
    }


    getdata()
{

    fetchActivityDetailsParent({ActivityId : this.description}) 
    .then( (result) => {   
        console.log('parent result======>',result);
        this.parentRecord = result;
        if(this.parentRecord[0].Status=='Deferred')
    {
        this.showchild=false;

        if(this.parentRecord[0].Status=='Deferred')
        {
            this.showmsg= true;
            this.showtable=false;
        }
    }
    else{
        this.showchild=true; 
    }
     
            console.log('in this blog--->');
            if(this.parentRecord[0].ChannelName!=null && this.parentRecord[0].ChannelName!=undefined)
            {

            if(this.parentRecord[0].ChannelName.toLowerCase()=='newspaper')
            {
                this.newspaper=true;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=false;
                this.Search=false;
                this.Preroll=false;
                this.Website=false;

            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='search')
            {
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=false;
                this.Search=true;
                this.Preroll=false;
                this.Website=false;
            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='website')
            {
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=false;
                this.Search=false;
                this.Preroll=false;
                this.Website=true;
            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='social')
            {
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=true;
                this.Search=false;
                this.Preroll=false;
                this.Website=false;
            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='radio')
            {
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=true;
                this.social=false;
                this.Search=false;
                this.Preroll=false;
                this.Website=false;
            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='pre-roll')
            {
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=false;
                this.Search=false;
                this.Preroll=true;
                this.Website=false;
            }
        
            if(this.parentRecord[0].ChannelName.toLowerCase()=='email' && this.parentRecord[0].SupplierName.toLowerCase()=='iktp')
            {
                this.newspaper=false;
                this.EDMIKPT=true;
                this.EDMTAD=false;
                this.Radio=false;
                this.social=false;
                this.Search=false;
                this.Preroll=false;
                this.Website=false;
            }
            if(this.parentRecord[0].ChannelName.toLowerCase()=='email' && this.parentRecord[0].SupplierName.toLowerCase()=='tripadeal')
            {
                console.log('shubham');
                this.newspaper=false;
                this.EDMIKPT=false;
                this.EDMTAD=true;
                this.Radio=false;
                this.social=false;
                this.Search=false;
                this.Preroll=false;
                this.Website=false;
            }

            }
        
    
     }).catch(error => {
        // this.resultsum = undefined;
         console.log('error-- '+JSON.stringify(error));
     });
   
     fetchActivityDetailsChild({ActivityId : this.activityid}) 
     .then( (result) => {   
         console.log('child result=============>',JSON.stringify(this.result));
         
             console.log('in this blog--1-->');
             
            
             if(result !=null && result !=undefined && result !=''){
                this.isChild=true;
                
            }
            console.log('ischild'+this.isChild);
     this.childRecord = result;
    
    
     
      }).catch(error => {
         // this.resultsum = undefined;
          console.log('error-- '+JSON.stringify(error));
      });

      getPicklistvalues({objectName :'Marketing_Spend__c',field_apiname :'ms_Status__c'}) 
      .then( (result) => {   
          console.log('result=============>',result);
      
              console.log('in this blog--2-->');
              
          
      this.StatusPkl = result;
      console.log('status'+StatusPkl);
      
          
      
       }).catch(error => {
          // this.resultsum = undefined;
           console.log('error-- '+JSON.stringify(error));
       });
     
       getPicklistvalues({objectName :'Marketing_Spend__c',field_apiname :'Approval_Status__c'}) 
       .then( (result) => {   
           console.log('result=====1========>',result);
       
               console.log('in this blog--3-->');
               
           
       this.ApprovalStatusPkl = result;
       console.log('Approval status'+ApprovalStatusPkl);
           
       
        }).catch(error => {
           // this.resultsum = undefined;
            console.log('error-- '+JSON.stringify(error));
        });
        getPicklistvalues({objectName :'Marketing_Spend__c',field_apiname :'Sub_status__c'}) 
        .then( (result) => {   
            console.log('result=====2========>',result);
        
                console.log('in this blog--4-->');
                
            
        this.SubstatusPkl = result;
        console.log('SubStatus'+SubstatusPkl);
            
        
         }).catch(error => {
            // this.resultsum = undefined;
             console.log('error-- '+JSON.stringify(error));
         });
        


}
handleChangeParentstatus(event) {
    let i = event.target.name;
    let tempwrapper =  JSON.parse(JSON.stringify(this.parentRecord));
    console.log('value of i-->'+i);
    console.log('eventdetail'+event.detail.value);
    
 tempwrapper[i].Status = event.detail.value;
 this.parentRecord = tempwrapper;
 if(event.detail.value=="Deferred")
 {
 this.showchild = false;
 }
 else
 {
    this.showchild = true; 
 }
 //console.log('parent----'+JSON.stringify(this.parentRecord));

 var wrapperObj =tempwrapper;
 console.log('wrapperObj==>',wrapperObj)
 const selectedEvent = new CustomEvent('parentstatus', {
    detail: {wrapperObj} 
});
this.dispatchEvent(selectedEvent);
}

handleChangeParentapprovalstatus(event) {
    let i = event.target.name;
    let tempwrapper =  JSON.parse(JSON.stringify(this.parentRecord));
    console.log('value of i-->'+i);
    console.log('eventdetail'+event.detail.value);
    
 tempwrapper[i].ApprovalStatus = event.detail.value;
 this.parentRecord = tempwrapper;
 console.log('parent----'+JSON.stringify(this.parentRecord));
 
 var wrapperObj =tempwrapper;
 const selectedEvent = new CustomEvent('parentapprovalstatus', {
    detail: {wrapperObj} 
});
this.dispatchEvent(selectedEvent);
}

handleChangeParentsubstatus(event) {
    let i = event.target.name;
    let tempwrapper =  JSON.parse(JSON.stringify(this.parentRecord));
    console.log('value of i-->'+i);
    console.log('eventdetail'+event.detail.value);
    
 tempwrapper[i].SubStatus = event.detail.value;
 this.parentRecord = tempwrapper;
 console.log('parent----'+JSON.stringify(this.parentRecord));

 var wrapperObj =tempwrapper;
 const selectedEvent = new CustomEvent('parentsubstatus', {
    detail: {wrapperObj} 
});
this.dispatchEvent(selectedEvent);
}

handleChangeChildstatus(event) {
    let i = event.target.name;
    let tempwrapper =  JSON.parse(JSON.stringify(this.childRecord));
    console.log('value of i-->'+i);
    console.log('eventdetail'+event.detail.value);
    
 tempwrapper[i].Status = event.detail.value;
 this.childRecord = tempwrapper;
 console.log('parent----'+JSON.stringify(this.childRecord));
 this.childRecord[i].Status = event.detail.value;

 var wrapperObj =tempwrapper;
 const selectedEvent = new CustomEvent('childstatus', {
    detail: {wrapperObj} 
});
this.dispatchEvent(selectedEvent);
}





}