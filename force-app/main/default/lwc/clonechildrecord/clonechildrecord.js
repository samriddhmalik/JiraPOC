import { LightningElement,track,api} from 'lwc';
import getAllOptionData from '@salesforce/apex/tad_cloneChildRecordApexHandler.getAllOptionData';
import getComponents from '@salesforce/apex/tad_cloneChildRecordApexHandler.getComponentData';
import getComponentPricings from '@salesforce/apex/tad_cloneChildRecordApexHandler.getComponentPricingData';
import getAllDepartureCityData from '@salesforce/apex/tad_cloneChildRecordApexHandler.getAllDepartureCityData';
import saveClick from '@salesforce/apex/tad_cloneChildRecordApexHandler.saveCloneData';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class Clonechildrecord extends NavigationMixin(LightningElement) {
@api recordId;		
@api cloneType;

@track name;
@track options = [];
@track suboptions = [];   
@track components = []; 
@track components1 = [];   
@track componentpricings = []; 
@track componentpricings1 = [];   
@track selectedsuboption = [];  
@track selectedcomponent = [];
@track selectedcomponent1 = [];    
@track selectedcomponentpricing = []; 
@track selectedcomponentpricing1 = []; 
@track showSubOpt;
@track showCmp;
@track showCmpRelatedToSupOption;
@track showCmpPricing;
@track showCmpPricingForSubOption;
@track cloneRecordsData = [];
showIdentifierInput = false;		
activeSectionMessage;
depCity = false
isLoading 

//get suboption data - start
connectedCallback() {
    // console.log("Record Id "+this.recordId)
    // console.log("cloneType "+this.cloneType)
    this.activeSectionMessage = 'Clone '+this.cloneType.charAt(0).toUpperCase() + this.cloneType.slice(1)+' and Related Record';
    if(this.cloneType == "Departure City"){
        this.depCity = true
        getAllDepartureCityData({
            rcdId : this.recordId,
            type : this.cloneType,
        }).then(result =>{
            this.name = result.name;
            this.components = result.componentList;
            this.showCmp = result.showCmp;
            // console.log('result '+JSON.stringify(result));
        })
        // console.log("Departure city block executed")
    }
    if(this.cloneType == "option"){
        console.log("Line--55-->"+this.cloneType);
        getAllOptionData({
            rcdId : this.recordId,
            type : this.cloneType,
            }).then(result => {
                // console.log('result '+JSON.stringify(result));
						this.name = result.name;
						// console.log('name '+JSON.stringify(this.name));
            this.suboptions = result.subOptionList;
            this.showSubOpt = result.showSubOpt;
			this.components = result.componentList;
            this.showCmp = result.showCmp;
            })
    }
    if(this.cloneType == "sub option"){
        console.log("Line--70-->"+this.cloneType);
        getAllOptionData({
            rcdId : this.recordId,
            type : this.cloneType,
            }).then(result => {
                // console.log('result '+JSON.stringify(result));
						this.name = result.name;
            this.components1 = result.componentList;
            this.showCmpRelatedToSupOption = result.showCmp;

            // console.log('result '+JSON.stringify(this.components));
            // console.log('result '+JSON.stringify(this.showCmp));
            })
    }
    if(this.cloneType == "component"){
        getAllOptionData({
            rcdId : this.recordId,
            type : this.cloneType,
            }).then(result => {
                // console.log('result '+JSON.stringify(result));
            this.componentpricings = result.componentPriceList;
						this.name = result.name;
            this.showCmpPricing = result.showCmpPricing;
			this.showIdentifierInput = true;
            })
    }
    this.cloneRecordsData.push({
        type: this.cloneType,
        rcdId: this.recordId,
    });
    }
//get suboption data stop

checkboxchangeHandler(event){
    // console.log('Enter to event '+JSON.stringify(event.target.checked));
    let type = event.target.getAttribute('data-id');
    let j=event.target.getAttribute('data-id2');
     console.log('value of i 35--->'+type);
     console.log('value of i 36--->'+event.target.value);
     console.log('value of i 37--->'+JSON.stringify(event.target.name));
	// 	console.log("cloneType "+this.cloneType)
    let recordData = [];
    
    if(type == 'suboption'){
     recordData = this.suboptions[j];
    }
    if(type == 'component'){
        console.log('Line--112-->'+type);
    recordData = this.components[j];
    }
    if(type == 'component1'){
        console.log('Line--116-->'+type);
        recordData = this.components1[j];
        }
    if(type == 'component Pricing'){
    recordData = this.componentpricings[j];
    } 
// console.log('recordData '+recordData);
    if(event.target.checked){
        if(type == 'suboption'){
            this.selectedsuboption.push({
                type: type,
                rcdId: this.suboptions[j].rcdId,
            });
            //console.log('value of i 123--->'+rcdId);
        }
        if(type == 'component'){
            console.log('Line--130-->'+type);
            this.selectedcomponent.push({
                type: type,
                rcdId: this.components[j].rcdId,
            });
            // console.log("line 127" ,JSON.stringify(this.selectedcomponent));
        }
        if(type == 'component Pricing'){
            this.selectedcomponentpricing.push({
                type: type,
                rcdId: this.componentpricings[j].rcdId,
            });
        }

    this.cloneRecordsData.push({
            type: type,
            rcdId: recordData.rcdId,
        });

    }else{ 
        if(this.selectedcomponentpricing.length=0)
        {
            this.showCmpPricing = false;
        }
        if(type == 'suboption'){
            for(var m=0; m<this.selectedsuboption.length; m++)
            {
                if( this.selectedsuboption[m].rcdId==recordData.rcdId)
                    this.selectedsuboption.splice(m,1);
            }
        }
        if(type == 'component'){
            for(var m=0; m<this.selectedcomponent.length; m++)
            {
                if( this.selectedcomponent[m].rcdId==recordData.rcdId)
                    this.selectedcomponent.splice(m,1);
            }
            
        }
        if(type == 'component Pricing'){
            for(var m=0; m<this.selectedcomponentpricing.length; m++)
            {
                if( this.selectedcomponentpricing[m].rcdId==recordData.rcdId)
                    this.selectedcomponentpricing.splice(m,1);
            }
        }
        for(var m=0; m<this.cloneRecordsData.length; m++)
        {
            if( this.cloneRecordsData[m].rcdId==recordData.rcdId)
                this.cloneRecordsData.splice(m,1);
        }
    }
    // console.log('this.selectedsuboption.length 151 '+this.selectedsuboption.length);
		if(this.selectedsuboption.length > 0){
				
		}else{
			//this.showCmp = result.showCmp;	
		}
		
    if(this.selectedsuboption.length > 0){
        getComponents({
            selectedDataList : this.selectedsuboption,
						rcdId:this.recordId,
            type: this.cloneType,
        }).then(result => {
            // console.log("Get Component Data "+JSON.stringify(result));
            this.components1 = result.componentList;
            console.log("Get Component Data-192--> "+JSON.stringify(this.components1));
            this.showCmpRelatedToSupOption = result.showCmp;
        }); 
    }

    if(this.selectedcomponent.length > 0){
        console.log('Line--206-bulb->'+this.selectedcomponent.length);
    getComponentPricings({
        selectedDataList : this.selectedcomponent,
    }).then(result => {
        // console.log("Get Component Data "+JSON.stringify(result))
        this.componentpricings = result.componentPricingList;
        this.showCmpPricing = result.showCmpPricing;
    }); 
}


}

checkboxchangeHandler1(event){
    let type = event.target.getAttribute('data-id');
    let j=event.target.getAttribute('data-id2');
    let recordData = [];

    if(type == 'component1'){
        console.log('Line--116-->'+type);
        recordData = this.components1[j];
        }
    if(type == 'component Pricing'){
    recordData = this.componentpricings1[j];
    }
    
    if(event.target.checked){
        if(type == 'component1'){
            console.log('Line--138-->'+type);
            this.selectedcomponent1.push({
                type: type,
                rcdId: this.components1[j].rcdId,
            });
            // console.log("line 127" ,JSON.stringify(this.selectedcomponent));
        }
    
    this.cloneRecordsData.push({
            type: type,
            rcdId: recordData.rcdId,
        });

    }else{ 
        if(this.selectedcomponentpricing.length=0)
        {
            this.showCmpPricing = false;
        }

        if(type == 'component1'){
            console.log('Line--180-->'+this.selectedcomponent);
            console.log('Line--181-->'+this.selectedcomponent.length);
            for(var m=0; m<this.selectedcomponent1.length; m++)
            {
                if( this.selectedcomponent1[m].rcdId==recordData.rcdId)
                    this.selectedcomponent1.splice(m,1);
            }
            
        }
console.log('line--267-->'+this.cloneRecordsData);
        for(var m=0; m<this.cloneRecordsData.length; m++)
        {
            if( this.cloneRecordsData[m].rcdId==recordData.rcdId)
                this.cloneRecordsData.splice(m,1);
        }
    }

    if(this.selectedcomponent1.length > 0){
        console.log('Line--317-->'+this.selectedcomponent1.length);
    getComponentPricings({
        selectedDataList : this.selectedcomponent1,
    }).then(result => {
        console.log("Get Component Data--302--> "+JSON.stringify(result))
        this.componentpricings1 = result.componentPricingList;
        console.log("Get componentpricings1--283--> "+this.componentpricings1)
        this.showCmpPricingForSubOption = result.showCmpPricing;
    }); 
}


}

checkboxchangeHandler2(event){
    let type = event.target.getAttribute('data-id');
    let j=event.target.getAttribute('data-id2');
    let recordData = [];
    console.log('Line--290-->'+type);
    console.log('Line--291-->'+j);
    if(type == 'component Pricing1'){
        console.log('Line--293-->'+type);
    recordData = this.componentpricings1[j];
    }
    
    if(event.target.checked){
 
        if(type == 'component Pricing1'){
            console.log('Line--301-->'+type);
            this.selectedcomponentpricing1.push({
                type: type,
                rcdId: this.componentpricings1[j].rcdId,
            });
        }

    this.cloneRecordsData.push({
            type: type,
            rcdId: recordData.rcdId,
        });

    }else{ 
        if(this.selectedcomponentpricing1.length=0)
        {
            this.showCmpPricing = false;
        }

        if(type == 'component Pricing1'){
            for(var m=0; m<this.selectedcomponentpricing1.length; m++)
            {
                if( this.selectedcomponentpricing1[m].rcdId==recordData.rcdId)
                    this.selectedcomponentpricing1.splice(m,1);
            }
        }
        for(var m=0; m<this.cloneRecordsData.length; m++)
        {
            if( this.cloneRecordsData[m].rcdId==recordData.rcdId)
                this.cloneRecordsData.splice(m,1);
        }
    }
}
		
identifierChangeHandler(event){
	//   console.log('Enter to event '+JSON.stringify(event.target.checked));
    let type = event.target.getAttribute('data-id');
    let j=event.target.getAttribute('data-id2');
    // console.log('value of i 174--->'+type);
    // console.log('value of i 175--->'+j);
		console.log("cloneType "+this.cloneType)
		
		let identifierElement = event.target.value;
		
		// console.log('Identifier Component '+JSON.stringify(this.components[j]));
		// console.log("Button click "+JSON.stringify(this.cloneRecordsData));
		
		if(this.cloneType == 'component'){
				for(var a=0;a<this.cloneRecordsData.length;a++){
				console.log("Button click "+JSON.stringify(this.cloneRecordsData[a]));
				if(this.recordId===this.cloneRecordsData[a].rcdId && type=='component'){
                let newcloneRecordsData = [...this.cloneRecordsData];
                newcloneRecordsData[a].identifier = identifierElement;
            }
		 }
		}
        else{
            console.log("Button click--359"+this.cloneRecordsData.length);
				for(var a=0;a<this.cloneRecordsData.length;a++){
				console.log("Button click--360-->"+JSON.stringify(this.cloneRecordsData[a]));
				if((this.components[j].rcdId===this.cloneRecordsData[a].rcdId && type=='component')){
                let newcloneRecordsData = [...this.cloneRecordsData];
                newcloneRecordsData[a].identifier = identifierElement;
            }
		 }	
		}
		// console.log("Line 190 After Identifier "+JSON.stringify(this.cloneRecordsData));
		
}

identifierChangeHandler1(event){
	//   console.log('Enter to event '+JSON.stringify(event.target.checked));
    let type = event.target.getAttribute('data-id');
    let j=event.target.getAttribute('data-id2');
    // console.log('value of i 174--->'+type);
    // console.log('value of i 175--->'+j);
		console.log("cloneType "+this.cloneType)
		
		let identifierElement = event.target.value;
		
		// console.log('Identifier Component '+JSON.stringify(this.components[j]));
		// console.log("Button click "+JSON.stringify(this.cloneRecordsData));
		
		if(this.cloneType == 'component'){
				for(var a=0;a<this.cloneRecordsData.length;a++){
				console.log("Button click "+JSON.stringify(this.cloneRecordsData[a]));
				if(this.recordId===this.cloneRecordsData[a].rcdId && type=='component'){
                let newcloneRecordsData = [...this.cloneRecordsData];
                newcloneRecordsData[a].identifier = identifierElement;
            }
		 }
		}
        else{
            console.log("Button click--395"+this.cloneRecordsData.length);
				for(var a=0;a<this.cloneRecordsData.length;a++){
				console.log("Button click--397-->"+JSON.stringify(this.cloneRecordsData[a]));
				if((this.components1[j].rcdId===this.cloneRecordsData[a].rcdId && type=='component1')){
                let newcloneRecordsData = [...this.cloneRecordsData];
                newcloneRecordsData[a].identifier = identifierElement;
            }
		 }	
		}
		// console.log("Line 190 After Identifier "+JSON.stringify(this.cloneRecordsData));
		
}	
cloneRecordHanlder(){
    this.isLoading = true;
    // console.log("Button click "+JSON.stringify(this.cloneRecordsData));
    let noIdentifierCheck;
		let searchIdentifier = this.template.querySelector(".Identifier");
		console.log('cloneType--372--> '+this.cloneType);
       
		// console.log('searchIdentifier '+searchIdentifier);
		// console.log('searchIdentifier '+this.cloneRecordsData.length);
		//Validation for identifier
		for(let i=0;i<this.cloneRecordsData.length;i++){
            console.log('cloneType--378--> '+this.cloneRecordsData[i].type);
				if(((this.cloneRecordsData[i].type == 'component') || (this.cloneRecordsData[i].type == 'component1')) && (this.cloneRecordsData[i].identifier == undefined || this.cloneRecordsData[i].identifier == 'undefined')){
						// console.log('searchIdentifier '+this.cloneRecordsData[i].type);
						// console.log('searchIdentifier '+this.cloneRecordsData[i].identifier);
						noIdentifierCheck = true;
						// console.log('noIdentifierCheck '+noIdentifierCheck);
						break;
				}
		}
		console.log('noIdentifierCheck '+noIdentifierCheck);
		if(noIdentifierCheck){
            this.isLoading = false;
				this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Cloning record',
                        message: 'Identifier Missing',
                        variant: 'error',
                    }),
       );
		}else{
    	saveClick({
        selectedDataList : this.cloneRecordsData,
				type : this.cloneType
    		}).then((data)=>{
                this.isLoading = false;
                const evt = new ShowToastEvent({
                message: 'Record is Cloned successfully!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        		const selectedEvent = new CustomEvent('close');
            // Dispatches the event for close popup window.
               this.dispatchEvent(selectedEvent);

				window.open(data,'_blank');
        }).catch((error)=>{
            this.isLoading = false;
            console.log(error.body.message);
            if(error.body.message.includes('duplicate value found') && error.body.message.includes('Error in Component')){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Cloning record',
                        message: 'Please provide unique Component Identifier',
                        variant: 'error',
                    }),
                );
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Cloning record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }
        });
      

	
	
}   
}
		
cancelHandler(event){
   
         const cancelEvt = new CustomEvent('cancel');
         this.dispatchEvent(cancelEvt);

    }
		
}