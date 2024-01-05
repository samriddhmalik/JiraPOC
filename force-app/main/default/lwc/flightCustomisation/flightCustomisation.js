import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDealData from '@salesforce/apex/flightCustomisation.getDealData';
import getCarriers from '@salesforce/apex/flightCustomisation.getCarriers';
import getCarrierAddons from '@salesforce/apex/flightCustomisation.getCarrierAddons';
import getAESB from '@salesforce/apex/flightCustomisation.getAESB';
import getSubStopOver from '@salesforce/apex/flightCustomisation.getSubStopOver';
import getAirLineUpgrade from '@salesforce/apex/flightCustomisation.getAirLineUpgrade';
import saveRecords from '@salesforce/apex/flightCustomisation.saveRecords';
import deleteRecords from '@salesforce/apex/flightCustomisation.deleteRecords';
import { RefreshEvent } from 'lightning/refresh';
export default class FlightCustomisation extends LightningElement {
    @api recordId;
    @track dealData=[];
    @track carriers=[];
    @track carrieraddon=[];
    @track copycarrieraddon=[];
    @track aesb=[];
    @track saveList=[];
    @track toRemove=[];
    @track delList=[];
    @track checkedList=[];
    @track stopOver=[];
    @track airlineUpgrade=[];
    @track saveSuccess=[];
    @track delSuccess=[];
    @track saved=false;
    @track showCustomisations=true;
    @track itinload = true;
    @track activeSections=[];
    @track showToast=false;
    
    connectedCallback(){
        console.log("recordId:- "+this.recordId);

        getDealData({
            recordId:this.recordId
        }).then(result => {
            
            console.log('carr '+ JSON.stringify(result));
            this.dealData = result;
            console.log('this.carriers '+JSON.stringify(this.dealData));
        });

        getCarriers({
            recordId:this.recordId
        }).then(result => {

            console.log('carr '+ JSON.stringify(result));
            this.carriers = result;
            console.log('this.carriers '+JSON.stringify(this.carriers));
        });

        getCarrierAddons({
            recordId:this.recordId
        }).then(result => {
            
            console.log('caradd36 '+ JSON.stringify(result));
            this.carrieraddon = result;
            this.copycarrieraddon=[...this.carrieraddon];
            console.log('this.carrieraddon '+JSON.stringify(this.carrieraddon));
           /* let checkboxes =this.template.querySelectorAll('[data-id3="checkbox"]');
            console.log('checboxes '+checkboxes.length);
            for(var i=0; i<checkboxes.length; i++){
                console.log('in loop ');
                let car = checkboxes[i].Attribute('data-id');
                console.log('car '+car);
            }*/
            this.itinload=false;
        });

        getAESB({
            recordId:this.recordId
        }).then(result => {
            
            console.log('aesb '+ JSON.stringify(result));
            this.aesb = result;
            console.log('this.aesb '+JSON.stringify(this.aesb));
        });
        getSubStopOver({
            recordId:this.recordId
        }).then(result=>{
            console.log('stopOver '+ JSON.stringify(result));
            this.stopOver = result;
            console.log('this.aesb '+JSON.stringify(this.stopOver));
        });
        getAirLineUpgrade({
            recordId:this.recordId
        }).then(result=>{
            console.log('getAirLineUpgrade '+ JSON.stringify(result));
            this.airlineUpgrade = result;
            console.log('this.airlineUpgrade '+JSON.stringify(this.airlineUpgrade));
        })
    }

    handleToggleSection(event){
        let checkboxes =this.template.querySelectorAll('[data-id3="checkbox"]');
            console.log('checboxes '+checkboxes.length);
            for(var i=0; i<checkboxes.length; i++){
                let car = checkboxes[i].getAttribute('data-id');
                let addon = checkboxes[i].getAttribute('data-id1');
                let type = checkboxes[i].getAttribute('data-id2');
                if(car=='Premium Carrier'){
                    car='Premium Carrier(Either Singapore Airlines, Cathay Pacific, Emirates or Qantas)';
                }
                console.log(this.carrieraddon);
                for(var j=0; j<this.copycarrieraddon.length; j++){
                    if(this.copycarrieraddon[j].AE_SB__c!=null){
                        if(this.copycarrieraddon[j].AE_SB__c==addon && this.copycarrieraddon[j].Carrier__r.Carrier_Group__c==car){
                            checkboxes[i].checked=true;
                            this.checkedList.push({
                                carrier:car,
                                addon:addon,
                                type:type
                            });
                        }
                    }
                    else if(this.copycarrieraddon[j].airline_upgrade__c!=null){
                        if(this.copycarrieraddon[j].airline_upgrade__c==addon && this.copycarrieraddon[j].Carrier__r.Carrier_Group__c==car){
                            checkboxes[i].checked=true;
                            this.checkedList.push({
                                carrier:car,
                                addon:addon,
                                type:type
                            });
                        }
                    }else if(this.copycarrieraddon[j].sub_stopover__c!=null){
                        if(this.copycarrieraddon[j].sub_stopover__c==addon && this.copycarrieraddon[j].Carrier__r.Carrier_Group__c==car){
                            checkboxes[i].checked=true;
                            this.checkedList.push({
                                carrier:car,
                                addon:addon,
                                type:type
                            });
                        }
                    }
                    
                }
                
            }
            console.log('this.checkedList '+JSON.stringify(this.checkedList));
    }

    handleChange(event){
        let i=event.currentTarget.getAttribute('data-id');
        console.log('data-id ' +i);
        if(i=='Premium Carrier'){
            i='Premium Carrier(Either Singapore Airlines, Cathay Pacific, Emirates or Qantas)';
        }
        let j = event.currentTarget.getAttribute('data-id1');
        console.log('data-id1 ' +j);
        let k = event.currentTarget.getAttribute('data-id2');
        console.log('data-id2 ' +k);
        if(event.target.checked){
            let add=true;
            if(this.delList.length>0){
                for(var m=0; m<this.delList.length; m++){
                    if(this.delList[m].carrier==i && this.delList[m].addon==j && this.delList[m].type==k){
                        this.delList.splice(m,1);
                        add=false;
                    }
                }
            }
            if(add==true){
                this.saveList.push({
                    carrier:i,
                    addon:j,
                    type:k
                });
            }
            
            console.log('this.saveList 135 '+JSON.stringify(this.saveList));
            
        }else{
           /* this.toRemove.push({
                carrier:i,
                addon:j,
                type:k
            });*/
            if(this.copycarrieraddon.length>0){
                console.log('line170');
                for(var m=0; m<this.copycarrieraddon.length; m++){
                    if(k=='aesb'){
                        console.log('k=aesb');
                        if(this.copycarrieraddon[m].Carrier__r.Carrier_Group__c== i && this.copycarrieraddon[m].AE_SB__c== j){
                            console.log('found');
                            this.copycarrieraddon.splice(m,1);
                            console.log('this.carrieraddon after splice '+JSON.stringify(this.copycarrieraddon));
                        }
                    }else if(k=='stopOver'){
                        if(this.copycarrieraddon[m].Carrier__r.Carrier_Group__c== i && this.copycarrieraddon[m].sub_stopover__c== j){
                            this.copycarrieraddon.splice(m,1);
                            console.log('this.carrieraddon after splice '+JSON.stringify(this.copycarrieraddon));
                        }
                    }else if(k=='airlineUpgrade'){
                        if(this.copycarrieraddon[m].Carrier__r.Carrier_Group__c== i && this.copycarrieraddon[m].airline_upgrade__c== j){
                            this.copycarrieraddon.splice(m,1);
                            console.log('this.carrieraddon after splice '+JSON.stringify(this.copycarrieraddon));
                        }
                    }
                    
                }
            }
            if(this.saveList.length>0){
                for(var m=0; m<this.saveList.length; m++){
                        if(this.saveList[m].carrier== i && this.saveList[m].addon== j && this.saveList[m].type== k){
                            this.saveList.splice(m,1);
                        }
                }
            }
            //if(this.checkedList.length>0){
              //  for(var m=0; m<this.checkedList.length; m++){
                  //  if(this.checkedList[m].carrier== i && this.checkedList[m].addon== j && this.checkedList[m].type== k){
                        console.log('in remove');
                       // this.delList.push(this.checkedList[m]);
                        this.delList.push({
                            carrier:i,
                            addon:j,
                            type:k
                        });
                    //}
                //}
            //}
            console.log('after splice '+JSON.stringify(this.saveList));
        }
        console.log('this.saveList '+JSON.stringify(this.saveList));
        console.log('this.delList '+JSON.stringify(this.delList));
    }

    saveOnClick(){
        if(this.saveList.length>0){
            saveRecords({
                saveList:this.saveList,
                recordId:this.recordId
            }).then((data)=>{
              
                const evt = new ShowToastEvent({
                    title: 'Success!',
                    message: 'The Flight Customisations are saved successfully!',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                this.showToast = true;
                console.log('FromApex Line 71 ',data);
                this.saveSuccess=data;
                for(var j=0; j<this.saveList.length; j++){
                    this.checkedList.push({
                        carrier:this.saveList[j].carrier,
                        addon:this.saveList[j].carrier,
                        type:this.saveList[j].type,
                    });
                }
                console.log('this.checkedLst 245 '+JSON.stringify(this.checkedList));
               // this.saved=true;
               // this.showCustomisations=false;
               this.saveList=[];
               this.activeSections=[];
               this.showToast = false;
            }).catch((error)=>{
                console.log('FromApex Line 75',JSON.stringify(error));
            });
        }
        if(this.delList.length>0){
            deleteRecords({
                delList:this.delList,
                recordId:this.recordId
            }).then((data)=>{
             // if(this.showToast==false){
                const evt = new ShowToastEvent({
                    title: 'Success!',
                    message: 'The Flight Customisations are saved successfully!',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
              //  this.showToast=true;
               // this.showToast=false;
              //}
                
                console.log('FromApex Line 71 ',data);
                this.delSuccess=data;
                this.delList=[];
                this.activeSections=[];
              //  this.saved=true;
               // this.showCustomisations=false;
        
            }).catch((error)=>{
                console.log('FromApex Line 75',JSON.stringify(error));
            });
        }
        
      //  if(this.delSuccess==true || this.saveSuccess==true){
            
       // }
    }
    cancelOnClick(){
        
      /*  this.itinload=true;
        this.copycarrieraddon=[...this.carrieraddon];
        console.log('')
        console.log('this.carrieraddon272 '+JSON.stringify(this.carrieraddon));
        this.activeSections=[];
        this.itinload=false;*/
        window.location.reload();
       
    }
}