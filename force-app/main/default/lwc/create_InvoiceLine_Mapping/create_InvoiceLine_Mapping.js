import { LightningElement,api,track } from 'lwc';
import getExpenseLineRecords from '@salesforce/apex/orderLineMappingController.getExpeneLineRecords';
//import getCreditLineRecords from '@salesforce/apex/orderLineMappingController.getCreditLineRecords';
//import getOL from '@salesforce/apex/orderLineMappingController.getrelatedOrderLines';
import expMapping from '@salesforce/apex/orderLineMappingController.CreateEXPInvoiceMapping';
//import creditMapping from '@salesforce/apex/orderLineMappingController.CreateCrInvoiceMapping';
import deleteMapping from '@salesforce/apex/orderLineMappingController.DeleteMappingRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Create_InvoiceLine_Mapping extends LightningElement {
    @track expList;
    @track subtotal;
    @track expidtemp = [];
    @track expolmap=[];
    @track crolmap=[];
    @track CrList;
    @api recordId;
    @track showExpenseLineItems = false;
    @track showcreditLineitem = false;
    @track checkvalue;
    @track olitoDelete = [];
    @track selectedrecord;
    @track showOl = false ;
    @track showrRelatedExOl;
    @track loading = true;
		



    connectedCallback(){
        this.getinitialRecords();
    }
    getinitialRecords(){
        console.log('RecId:- '+ this.recordId);
        getExpenseLineRecords({ PINId : this.recordId})
        .then(res=>{
            if(res){
                this.showExpenseLineItems = true;
                this.expList = res;
                this.loading = false;

                console.log("ExpList Response:-  "+ JSON.stringify(res));
            }
        })
        .catch(err=>{
            console.log("ExpRecords error:-" + err);
        })

//         getCreditLineRecords({ PINId : this.recordId})
//         .then(res=>{
// 
//             if(res){
//                 //this.showcreditLineitem = true;
//                 this.CrList = JSON.parse(res);
//                 console.log("CreditList Response:- "+ JSON.stringify(res));
//             }
//             //this.expenseData = this.resArray;
//         })
//         .catch(err=>{
//             console.log("CreditRecords error:- " + err);
//         })
    }

    removeItemAll(arr, value) {
                    
        var i = 0;
        while (i < arr.length) {
          if (arr[i] === value) {
            arr.splice(i, 1);
          } else {
            ++i;
          }
        }
        console.log('inside child childrow');
        return arr;
      }

     Expticked(event) {
        
                const expCheck = event.target.getAttribute('data-id2');
				const element = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
                console.log('element checked:-'+expCheck);
                console.log('element Selected :-'+element);
				console.log('Index Value:-' +i);
				if(event.target.checked===true){

                     this.expList[i].check = true;
			}
                else if(event.target.checked===false){
                   this.expList[i].check = false;
                   
                    }
    }



    selecgtAllOL(event){
        console.log('Enter to select All OL event '+JSON.stringify(event.detail));
        console.log('this.expList.length:- ' +this.expList.length);
        const expoltempList = [];
        const expidtemp = [];
        console.log('expoltempList:- '+JSON.stringify(this.expoltempList));
		console.log('this.expidtemp before:-  '+JSON.stringify(this.expidtemp));	
        console.log('this.expolmap.lenght:-  '+JSON.stringify(this.expolmap.length));
        
if(this.expolmap.length > 0){
		for(var x=0; x<this.expolmap.length; x++ ){
            console.log('JSON.stringify(this.expolmap[x].expId):- '+JSON.stringify(this.expolmap[x].OlId))
            this.expidtemp.push(this.expolmap[x].OlId);
            
           console.log('expidtemp:- '+this.expidtemp);
          // this.expidtemp.push(JSON.parse(JSON.stringify(expolmap[x].OlId))); 
        }
	 
                 
        
				console.log('this.expidtemp:-  '+JSON.stringify(this.expidtemp));	
}				
       
        for(var n=0; n<this.expList.length; n++)
                                {
                                    this.expList[n].check = true;

                                    this.subtotal = 0;
                                    console.log('subtotal 1 :- '+ this.subtotal);
                                    this.expoltempList = this.expList[n].expOLList; 
                                //console.log('this.expoltempList.length:- '+JSON.stringify(this.expoltempList));
                                    for(var m=0; m<this.expoltempList.length; m++){
                                        console.log('this.expidtemp Inside loop:- '+JSON.stringify(this.expidtemp));
                                        console.log('this.expoltempList.length:- '+JSON.stringify(this.expoltempList[m].olId));
                                        
                                        console.log('check truefalse:-  '+ this.expidtemp.includes(this.expoltempList[m].olId));

                                        this.subtotal = Math.round((this.subtotal +  this.expList[n].expOLList[m].grossCost)*100)/100 ;

                                        console.log('subtotal 2 :- '+ this.subtotal);
                                        this.expList[n].expOLList[m].check = true;
                                      // setTimeout(function(){
                                        if(!(this.expidtemp.includes(this.expoltempList[m].olId))){
                                            this.expolmap.push({
                                                expid:this.expoltempList[m].expId,
                                                PINID:this.expoltempList[m].PINID,
                                                OlId:this.expoltempList[m].olId
                                               });
                                            

                                            }
                                            
                                      // }, 100);
                                        
                                            
                                        
                                    }

                                    console.log('subtotal 3 :- '+ this.subtotal);

                                    this.expList[n].olsubtotal = this.subtotal;
                        }
                         console.log('this.expolmap :- ' +JSON.stringify(this.expolmap) );

                        //  const PINList = this.template.querySelectorAll('[data-id="Payable Invoice Expense"]');
                        //  for (const toggleElement of PINList) {
                        //     toggleElement.checked =  true;
                        //  }

                        //  const OLList = this.template.querySelectorAll('[data-id="Order LIne"]');
                        //  for (const toggleElement of OLList) {
                        //     toggleElement.checked =  true;
                        //  }


    }

    clearAllOL(event){
        console.log('Enter to clear All OL event '+JSON.stringify(event.detail));
       
       
        for(var n=0; n<this.expList.length; n++){

           // this.expList[n].check = false;

            const expoltempList = [];
            this.expoltempList = this.expList[n].expOLList; 
            this.expList[n].olsubtotal = 0;
                console.log('this.expoltempList.length:- '+JSON.stringify(this.expoltempList.length));
            for(var m=0; m<this.expoltempList.length; m++){

                this.expList[n].expOLList[m].check = false;

                for(var x=0; x<this.expolmap.length; x++){

                    if(this.expolmap.length > 0){
                               this.expolmap = [];                     
                }
            }
            this.olitoDelete.push({
                olids:this.expoltempList[m].olId,
                PINIDs:this.expoltempList[m].PINID,
                expId:this.expoltempList[m].expId
            });
        }
        
       
    }
    console.log('this.olitoDelete :- ' +JSON.stringify(this.olitoDelete) );
    console.log('this.expolmap :- ' +JSON.stringify(this.expolmap) );

    // const PINList = this.template.querySelectorAll('[data-id="Payable Invoice Expense"]');
    //                      for (const toggleElement of PINList) {
    //                         toggleElement.checked =  false;
    //                      }
    
                        //  const OLList = this.template.querySelectorAll('[data-id="Order LIne"]');
                        //  for (const toggleElement of OLList) {
                        //     toggleElement.checked =  false;
                        //  }
}

//     CrTicked(event){
//         console.log('Enter to CrTicked event '+JSON.stringify(event.target.checked));
//         let CrId = event.target.getAttribute('data-id');
//         console.log("CrId:- "+CrId);
//         
//         if(event.target.checked===true){
//             getOL({ ExpOrCrID : this.CrId })
//             .then(res=>{
//                 if(res){
//                     this.showrRelatedExOl = true;
//                     this.CrOLList = JSON.parse(res);
//                     console.log("CrOLList Response:-  "+ JSON.stringify(res));
//                 }
//             })
//             .catch(err=>{
//                 console.log("CrOLList error:-" + err);
//             })
//         }else if(event.target.checked===false){
//             this.showrRelatedExOl = false;
//         }     
//     } 

               expOlticked(event){

                const element = event.target.getAttribute('data-id');
                console.log('element Selected '+element);
                const i = event.target.getAttribute('data-id1');
                const m = event.target.getAttribute('data-id2');
                const olid = event.target.getAttribute('data-id3');
                console.log('this.expList[i].expOLList[m]:-'+this.expList[i].expOLList[m]);
               // const idtoremove = this.olitoDelete.olids;
                console.log('parent index:-'+i);
                console.log('child index:-'+m);
                console.log('olid:-'+olid );
                this.subtotal = this.expList[i].olsubtotal
            
                if(event.target.checked ===true)
                {
                    this.expList[i].expOLList[m].check = true;
                    this.expList[i].olsubtotal = Math.round((this.subtotal + this.expList[i].expOLList[m].grossCost)*100)/100;

                   this.expolmap.push({
                    expid:this.expList[i].expOLList[m].expId,
                    PINID:this.expList[i].expOLList[m].PINID,
                    OlId:this.expList[i].expOLList[m].olId
                   });
                    console.log('expolmap:-'+ JSON.stringify(this.expolmap));

                   
                    for(var x=0; x<this.olitoDelete.length; x++){
                        if(
                            this.olitoDelete[x].olids===olid){
                                this.olitoDelete.splice(x,1);
                            }
                    }

                   
                    console.log('orderLine checked :-'+ JSON.stringify(this.olitoDelete));

                }

                    else if(event.target.checked===false){

                        this.expList[i].expOLList[m].check = false;

                        this.expList[i].olsubtotal = Math.round( (this.subtotal - this.expList[i].expOLList[m].grossCost)*100)/100;

                        if(this.expolmap.length > 0){
                                for(var n=0; n<this.expolmap.length; n++)
                                {
                                if( this.expolmap[n].OlId === this.expList[i].expOLList[m].olId){
                                    this.expolmap.splice(n,1);                                
                                console.log('expolmap:-'+JSON.stringify(this.expolmap));
                            }
                        } 
                    }
                    
                    this.olitoDelete.push({
                        olids:this.expList[i].expOLList[m].olId,
                        PINIDs:this.expList[i].expOLList[m].PINID,
                        expId:this.expList[i].expOLList[m].expId
                    }); 

                    console.log('orderLine unchecked :-'+ JSON.stringify(this.olitoDelete));
                    
                }
            }
        
                        
    CrOlticked(event){
        const element = event.target.getAttribute('data-id');
        console.log('element Selected '+element);
        const i = event.target.getAttribute('data-id1');
        const m = event.target.getAttribute('data-id2');
        console.log('parent index:-'+i);
        console.log('child index:-'+m);
                        console.log('this.crList'+JSON.stringify(this.crOlList[i]));
        console.log(' this.crList.crOLList'+ JSON.stringify(this.crList[i].crOLList[m]));
        if(event.target.checked ===true)
        {
           this.crolmap.push({
            crid:this.crList[i].crOLList[m].crId,
            PINID:this.crList[i].crOLList[m].PINID,
            OlId:this.crList[i].crOLList[m].olId
           });
            console.log('crolmap:-'+ JSON.stringify(this.crolmap));
        }else if(event.target.checked===false){
        
                if(this.crolmap.length > 0){
                        for(var n=0; n<this.crolmap.length; n++)
                        {
                        if( this.crolmap[n].OlId === this.crList[i].crOLList[m].olId){
                            this.crolmap.splice(n,1);                                
                        console.log('crolmap:-'+JSON.stringify(this.crolmap));
                    }
                } 
            }    
        }
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: "Records Mapped/Unmapped Sucessfully ",
            message: '' ,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    mapOl(event)
    {
        console.log('Enter to mapOl event '+JSON.stringify(event.detail));

        expMapping({
            idsToMap : this.expolmap

        }).then(res=>{
                console.log('expmapping sucess'+ JSON.stringify(res));
        }).catch(error=>{
            console.log('expmapping error'+ JSON.stringify(error));
        })

        // creditMapping({
        //     idsToMap : this.crolmap
        // }).then(res=>{
        //     console.log('crmapping sucess'+ JSON.stringify(res));
        // }).catch(error=>{
        //     console.log('crmapping error'+ JSON.stringify(error));
        // })

        deleteMapping({
            olIdsToDelete : this.olitoDelete
        }).then(res=>{
            console.log('mappingDeleted success:-'+JSON.stringify(res));
        }).catch(err=>{
            console.log('mappingDeleted Failed:- '+JSON.stringify(err));
        })

       this.showNotification();
        window.location.reload();
    }
   

}