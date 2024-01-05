import { LightningElement,wire } from 'lwc';
import getUser  from '@salesforce/apex/MP_ProfileDetailsOnCommunity.getUser';
import savefieldData  from '@salesforce/apex/MP_ProfileDetailsOnCommunity.sendEmailEnable';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import savePIFDetails  from '@salesforce/apex/MP_ProfileDetailsOnCommunity.enablePIFSummary';
import fireChangePasswordEmail  from '@salesforce/apex/MP_ProfileDetailsOnCommunity.changePasswordEmail';
import Id from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';


export default class ProfileDetailsOnCommunity extends LightningElement {
    
  userId=Id;
   userlist;
    error;
    result;
    postalcode;
    State;
    Address;
    pifSummary;

    Street;
    phnDetails = "";
    errDetails = "";
    isAddressEmpty = false;
    chklist;
    isClicked = false;
   isClicked1 = false;
    isLoading = false;
    isEMAilLoading = false;
    isPIFCheckboxClicked = false;
    isEnableEmailCheckboxClicked = false;
   

@wire(getUser) 
newlocalMethod({ error,data}){
       
    if(data){
        console.log('data value '+JSON.stringify(data));
 this.userlist=data;
this.State= this.userlist[0].State;
this.City= this.userlist[0].City;
 this.Street = this.userlist[0].Street;
 this.postalcode = this.userlist[0].PostalCode;
 this.Address = this.userlist[0].Address;
 this.chklist = this.userlist[0].isEmailEnable;
 this.pifSummary = this.userlist[0].isPIFSettingsEnabled;
 this.phnDetails = this.userlist[0].Phone;



 
 if (this.Address != null){
   this.isAddressEmpty = true;
 }

console.log('Line--18-->'+this.isAddressEmpty);
console.log('Line--23-->'+this.Address);
}

if(error){
    console.log('error value '+JSON.stringify(error));
this.error=error;}

}




checkboxchange(event){
    console.log('Enter to event '+JSON.stringify(event.target.checked));
    this.isEnableEmailCheckboxClicked = true;
    this.chklist = event.target.checked;
    this.isClicked = true;
    console.log('Line--71'+ this.chklist);
}

onChangePIFSettings(event){
    console.log('Enter to event '+JSON.stringify(event.target.checked));
    this.isPIFCheckboxClicked = true;
    this.pifSummary = event.target.checked;
    this.isClicked = true;
    console.log('Line--79'+ this.pifSummary);
}

phoneChange(event){
    this.isClicked1 = true;
    let element = event.target.value;
    console.log('element123 '+element);
   
    this.phnDetails = element;
    this.isClicked1 = true;
    console.log('chkDetails'+isClicked1);
    console.log('phnDetails'+phnDetails);
    
    //console.log('isCaseCreated82'+this.isCaseCreated);
    
    
    }

saveclick(){

    if(this.isEnableEmailCheckboxClicked == true && this.isPIFCheckboxClicked == true){
         if(this.chklist == true){
                    this.isEMAilLoading = true;

            console.log('Enter to 98 '+this.chklist);
            console.log('Enter to 99 '+this.phnDetails);
            console.log('Enter to 100 '+this.userId);
    savefieldData({
            chklistValue : this.chklist,
        phnData : this.phnDetails,
        userID : this.userId
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Enable Email Notification Saved Successfully',
          });
          this.dispatchEvent(event);
          this.isEMAilLoading = false;
          this.isEnableEmailCheckboxClicked = false;
          this.chklist = true;
          refreshApex(this.chklist);
          this.isClicked = false;

          
})
            }
        else{
                    this.isEMAilLoading = true;
    savefieldData({
        chklistValue : this.chklist,
        phnData : this.phnDetails,
        userID : this.userId
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Enable Email Notification Disabled Successfully',
          });
          this.dispatchEvent(event);
          this.isEMAilLoading = false;
          this.isEnableEmailCheckboxClicked = false;
          this.chklist = false;
          refreshApex(this.chklist);
          this.isClicked = false;
})

            }

    if(this.pifSummary == true ){
                this.isLoading = true;
    console.log('pifSummary ',this.pifSummary);
    console.log('userId',this.userId);
    savePIFDetails({        
        userID : this.userId,
        isPifSummaryEnabled : true
    
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'PIF Summary has been enabled Successfully',
          });
          this.dispatchEvent(event);
          this.isLoading = false;
          this.isPIFCheckboxClicked = false;
          this.pifSummary = true;
          refreshApex(this.pifSummary);
          this.isClicked = false;
          
          
         

})
    }
    else{
        this.isLoading = true;
    savePIFDetails({
        userID : this.userId,
        isPifSummaryEnabled : false
        
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'PIF Summary has been disabled Successfully',
          });
          this.dispatchEvent(event);
          this.isLoading = false;
          this.isPIFCheckboxClicked = false;
          this.pifSummary = false;
         refreshApex(this.pifSummary);
         this.isClicked = false;
})
    }

 

    }
    else{
        if(this.isEnableEmailCheckboxClicked == true){
    if(this.chklist == true){
    this.isEMAilLoading = true;
    console.log('Enter to 98 '+this.chklist);
    console.log('Enter to 99 '+this.phnDetails);
    console.log('Enter to 100 '+this.userId);
    savefieldData({
        chklistValue : this.chklist,
        phnData : this.phnDetails,
        userID : this.userId
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Enable Email Notification Saved Successfully',
          });
          this.dispatchEvent(event);
          this.isEMAilLoading = false;
          this.isEnableEmailCheckboxClicked = false;
          //window.location.reload();
          this.chklist = true;
           refreshApex(this.chklist);
           this.isClicked = false;
          
})
}
else{
    this.isEMAilLoading = true;
    savefieldData({
        chklistValue : this.chklist,
        phnData : this.phnDetails,
        userID : this.userId
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Enable Email Notification Disabled Successfully',
          });
          this.dispatchEvent(event);
          this.isEMAilLoading = false;
          this.isEnableEmailCheckboxClicked = false;
          this.chklist = false;
            refreshApex(this.chklist);
            this.isClicked = false;

})
}

    }

    if(this.isPIFCheckboxClicked == true){
        this.isLoading = true;
if(this.pifSummary == true ){
    console.log('pifSummary ',this.pifSummary);
    console.log('userId',this.userId);
    savePIFDetails({        
        userID : this.userId,
        isPifSummaryEnabled : true
    
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'PIF Summary has been enabled Successfully',
          });
          this.dispatchEvent(event);
          this.isLoading = false;
          this.isPIFCheckboxClicked = false;
          this.pifSummary = true;
           refreshApex(this.pifSummary);
           this.isClicked = false;
          
         

})
}
else{
    this.isLoading = true;
    savePIFDetails({
        userID : this.userId,
        isPifSummaryEnabled : false
        
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'PIF Summary has been disabled Successfully',
          });
          this.dispatchEvent(event);
          this.isLoading = false;
          this.isPIFCheckboxClicked = false;
          this.pifSummary = false;
        refreshApex(this.pifSummary);
        this.isClicked = false;
})
}
    }
    }
    
}

saveclick1(){
 
 //   alert('after apply regex '+this.phn+' => '+Result[1]);
    this.isLoading = true;
    console.log('Enter to 98 '+this.chklist);
    console.log('Enter to 99 '+this.phnDetails);
    console.log('Enter to 100 '+this.userId);
   
    savefieldData({
        chklistValue : this.chklist,
        phnData : this.phnDetails,
        userID : this.userId
    }).then((data)=>{
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Phone Number Updated Successfully',
          });
          this.dispatchEvent(event);
          this.isLoading = false;
          window.location.reload();
          

})


}
handleClick(){
    window.location.reload();
}

changePassword(){
    console.log('Line--130-->'+this.userId);
    fireChangePasswordEmail({
        userID : this.userId
       
    }).then(result => {
        this.result = result;
        console.log('Line--135'+JSON.stringify(this.result));
        const event = new ShowToastEvent({
            title: 'Success',
            duration:' 50000',
            variant: 'success',
            message: 'Change Password Email Sent Successfully'
        });
        this.dispatchEvent(event);
}).catch(error => {
    this.error = error;
    console.log('Line--144'+JSON.stringify(this.error));
    const evt = new ShowToastEvent({
        message: 'Merchant recently requested to reset the password . We cannot reset your password because it was changed within the last 24 hours.',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
});
   
}

}