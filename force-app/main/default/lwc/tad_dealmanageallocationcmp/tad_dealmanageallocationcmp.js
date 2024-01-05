import { LightningElement, api, track } from 'lwc';
import getAllocationLevelTypePickList from '@salesforce/apex/tad_DealManageAllocationController.getAllocationLevelTypePickList';
import getAllocationData from '@salesforce/apex/tad_DealManageAllocationController.getAllocationData';
import saveOptionMinmum from '@salesforce/apex/tad_DealManageAllocationController.saveOptionMinmum';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class Tad_dealmanageallocationcmp extends NavigationMixin(LightningElement) {
    
	@api recordId;	
	@track AllocationSelectionLevelValues = [];
	@track SelectedAllocationLevel;  
	@track showAllocationDataTable  = false;
	@track AllocationDataTable;	
	@track saveAllocationDataTable = [];
	@track buttonDisabled = true;	
    
	connectedCallback(){
        console.log('Deal Id '+this.recordId);
			getAllocationLevelTypePickList({

			}).then( (result) => {
				console.log('Result '+JSON.stringify(result));
				this.AllocationSelectionLevelValues = result;
			}).catch((error) => {
				console.log('Error '+JSON.stringify(error));
			});
    }
 handleChangeAllocationLevelSelection(event){
		 let element = event.detail.value;
		 console.log(element);
		 console.log('Selected Allocation Level');
		 this.SelectedAllocationLevel = element;

         getAllocationData({
            dealrcdId: this.recordId,
            AllocationLevelType: this.SelectedAllocationLevel
         }).then((result) =>{
					console.log('Result '+JSON.stringify(result));
						 this.showAllocationDataTable = true;
						 this.AllocationDataTable = result.optionData;
    		}).catch((error) => { 
        	console.log('message'+JSON.stringify(error)); 
       	}); 
 }   
		
 AllocationDataChangeHandler(event){
	let element = event.target.value;
	let i=event.target.getAttribute('data-id1');
	console.log(`Index ${i} minmum value = ${element} option ${JSON.stringify(this.AllocationDataTable[i].optionRcdId)}`);

		 console.log(`this.saveAllocationDataTable.length ${this.saveAllocationDataTable.length }`);
		 
	if(this.saveAllocationDataTable.length > 0){
			this.buttonDisabled = false;
			console.log(`Inside length if block`);
			for(var m=0; m<this.saveAllocationDataTable.length;m++){
					console.log(`inside forloop ${this.saveAllocationDataTable[m]} changes in ${this.AllocationDataTable[i]}`);
					console.log(`inside forloop ${this.saveAllocationDataTable[m].optionRcdId} changes in ${this.AllocationDataTable[i].optionRcdId}`);
					if(this.saveAllocationDataTable[m].optionRcdId === this.AllocationDataTable[i].optionRcdId){
							console.log(`Record Match Found ${this.saveAllocationDataTable[m]}`);
								this.saveAllocationDataTable[m].minumum = element;
					}else{
							console.log(`Record Match Not Found ${this.AllocationDataTable[i]}`);
							if(m == this.saveAllocationDataTable.length - 1){
									console.log(`m = ${m} length ${this.saveAllocationDataTable.length }`)
									this.updateDataTable(this.AllocationDataTable[i].optionRcdId,this.AllocationDataTable[i].optionName,element);
							}
					}
			}
	}else{
			console.log(`Inside length else block`);
			this.updateDataTable(this.AllocationDataTable[i].optionRcdId,this.AllocationDataTable[i].optionName,element);
	}
	console.log(`Update Data Table = ${JSON.stringify(this.saveAllocationDataTable)}`);
 }	

 updateDataTable(rcdId,rcdName,min){

	this.saveAllocationDataTable.push({
		optionRcdId:rcdId,
		optionName:rcdName,
		minumum:min
	});
 }

 saveClick(event){
		console.log('Button Handler Call')
		console.log(`Save Button Click Data = ${JSON.stringify(this.saveAllocationDataTable)}`);
		this.buttonDisabled = true;
		saveOptionMinmum({
			options: this.saveAllocationDataTable
		}).then((result) => {
			console.log('Call Success '+JSON.stringify(result));
				const evt = new ShowToastEvent({
				title: 'Success',
                message: 'Record update successfully!',
                variant: 'success',
            });	
			this.dispatchEvent(evt);
			
			location.reload();

		}).catch((error) => {
			console.log('Error on Save Click '+JSON.stringify(error));
				console.log('error length '+JSON.stringify(error.body.message));
				const evt = new ShowToastEvent({
					title: 'Error',
					message: error.body.message,
					variant: 'error',
				});
				this.dispatchEvent(evt);
			
		});		
	}

	cancelHandler(event){
		location.reload();
   }
}