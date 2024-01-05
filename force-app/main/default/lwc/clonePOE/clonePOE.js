import { LightningElement, track, api } from 'lwc';
import getDep from '@salesforce/apex/getDepartureRecords.getDep';
import cloneDayPoe from '@salesforce/apex/getDepartureRecords.cloneDayPoe';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
const column = [
    {label: 'Id' , fieldName:  'Name' },
    {label:'Date', fieldName: 'Dt' },
		 {label: 'SubOption' , fieldName:  'Suboption' },
    {label:'Option', fieldName: 'Option' }
]

export default class ClonePOEButton extends NavigationMixin(LightningElement) {
    @track showButton = 'Show Button';
    @track isVisible = false;
    @track activeMessage = 'Loading...';
    @track dataTable = [];

    columns=column;

    @api recordId; //it shoews the current page record Id

    //get departure List witj same date from apex class by imperative method
    
    connectedCallback(){
        console.log('this.recordId'+this.recordId);

        //calling apex method
        getDep({lwcRecordId : this.recordId})
            .then(result=>{
								console.log('this.data'+JSON.stringify(result));
                this.dataTable = result.deptDates;
						
								console.log('this.data'+this.dataTable);
						    console.log('this.data'+result.errorMessage); 
						    if(result.errorMessage != null || result.errorMessage != ''){
										this.activeMessage = result.errorMessage;
										this.isVisible = result.isVisible;
								}
						
                if(this.dataTable.length > 0){
                    //this.isVisible = true;
                }else{
                    this.activeMessage = 'No Departure Date To Create Day POE Records';
                }
				})
            .catch(error=>{
                console.log('error occured'+error);      
            })
        }


 closeAction(){
		 var el = this.template.querySelector('lightning-datatable');
        console.log(el);
        var selected = el.getSelectedRows();
        console.log(JSON.stringify(selected));	
		    cloneDayPoe({depDates:selected,lwcRecordId : this.recordId}).then((data)=>{
          
            const evt = new ShowToastEvent({
               
                message: 'Record is Cloned successfully!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
    				window.location.reload();	
						
        }).catch((error)=>{
            console.log('FromApex Line 75',JSON.stringify(error));
				 		this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Cloning record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
				//window.location.reload();	
        });
      
        this.dispatchEvent(new CloseActionScreenEvent());
    }
		handlecheck(event){
				console.log('dnhsh');
				var el = this.template.querySelector('lightning-datatable');
        console.log(el);
        var selected = el.getSelectedRows();
        console.log(JSON.stringify(selected));	

		}
    //  Show/Hide button toggel functionality
    
 
    

}