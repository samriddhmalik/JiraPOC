import { LightningElement, api, track } from 'lwc';
import getDealData from '@salesforce/apex/Tad_DealOptimizaitonContorller.getDealData';
import SaveIteneries from '@salesforce/apex/Tad_DealOptimizaitonContorller.SaveIteneries';
import saveAttachInclusions from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveAttachInclusions';
import saveDeal from '@salesforce/apex/Tad_DealOptimizaitonContorller.updateDeal';
import savetours from '@salesforce/apex/Tad_DealOptimizaitonContorller.savetours';
import getPicklistvalues from '@salesforce/apex/Tad_DealOptimizaitonContorller.getPicklistvalues';
import saveproperty from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveproperty';
import saveHighlights from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveHighlights';
import saveDealHistory from '@salesforce/apex/Tad_DealOptimizaitonContorller.saveDealHistory';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import LightningConfirm from 'lightning/confirm';
import LightningAlert from 'lightning/alert'; 

//import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class DealOptimization extends NavigationMixin (LightningElement) {
		RecordName;	
		RecordURL;	
		RecordID;
		@api recordId;
		dnarrow = true;
		@track dealtitle = '';
		@track dealhighlights = '';
		@track dealdata = [];
		@track iteneraries = [];
		@track tourInclusion = [];
		@track tourtodelete =[];
		@track properties = [];
		@track propertiestodelete =[];
		@track listOfAttachInclusions = [];
		@track listOfAttachInclusionsTraker = [];
		@track deleteTraker = [];
		@track saveTraker = [];
		@track insclusiontodelete = [];
		@track mealsOptions = [];
		toursites =[];
		@track countryOptions = [];
		@track selectedItenararies=[];
		@track showAttach;
		@track selectedItenarary;
		@track itineriesToDeleteByDeletAll = [];  
		@track cloneCheck;
		@track tempitinrow;
		@track itineriesToDelete=[];
		itindataPopUp;
		tourdataPopUp;
		propertydataPopUp;
		@track showModal;
		@track showtour;
		@track showproperty;
		highlights;
		@track iteneriesToClone;
		@track sortedDirection =  'asc';
		@track itinNumber;
		@track itinload = true;
		@track loading = false;
		@track country;
		@track datadisabled;
		@track restrictInput;
		@track showBDMCopy;
		@track showAnalystCopy;
		@track BDMData;
		@track AnalystData;
		@track Analystbutton = false;
		@track BDMbutton = false;
		@track disableloockup = false;
		@track showdealpopup;
		connectedCallback(){

				console.log("recordId:- "+this.recordId);
				this.getDealData();
		}

		getDealData(){
				getDealData({dealId : this.recordId})
						.then(res=>{
						console.log("dealData:- "+ JSON.stringify(res) );
						this.dealdata = res;
						this.dealtitle = res.title;
						this.dealhighlights = res.description;
						this.BDMData = res.BDMdata;
						this.AnalystData = res.AnalystData;
						this.restrictInput = res.dataEditableDisable;
						this.showAnalystCopy = res.showAnlystcopy;
						this.showBDMCopy = res.showBDMcopy;
						if(res.userRoleName == "Analyst" && this.showAnalystCopy == false && this.showBDMCopy == true){
								this.Analystbutton = true;						
						}else if(res.userRoleName == "BDM" && this.showBDMCopy == false){
								this.BDMbutton = true;
						}

						if(this.showAnalystCopy == true || this.showBDMCopy == true){
								this.disableloockup = true;
						}

						if(this.dealdata.isFlightbookbynull){
								this.ShowAlertPopup(event);
						}

						if(this.showBDMCopy == true){
								this.BDMData.iteneraries = JSON.parse( JSON.stringify(this.BDMData.iteneraries) ).sort( function(p1, p2){  return (p1.itinNumber - p2.itinNumber)} );
								this.BDMData.tours = JSON.parse(JSON.stringify(this.BDMData.tours)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
								this.BDMData.properties = JSON.parse(JSON.stringify(this.BDMData.properties)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
								for(var m=0; m<this.BDMData.iteneraries.length; m++){
										this.BDMData.iteneraries[m].itinorderlist = JSON.parse( JSON.stringify( this.BDMData.iteneraries[m].itinorderlist ) ).sort( function(p1, p2) {return ((p1.day != null ? p1.day : Infinity) - (p2.day != null ? p2.day : Infinity))});
								}
						}
						if(this.showAnalystCopy == true){
								this.AnalystData.iteneraries = JSON.parse( JSON.stringify( this.AnalystData.iteneraries) ).sort( function(p1, p2){  return (p1.itinNumber - p2.itinNumber)} );
								this.AnalystData.tours = JSON.parse(JSON.stringify(this.AnalystData.tours)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
								this.AnalystData.properties = JSON.parse(JSON.stringify(this.AnalystData.properties)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
								for(var m=0; m<this.AnalystData.iteneraries.length; m++){
										this.AnalystData.iteneraries[m].itinorderlist = JSON.parse( JSON.stringify( this.AnalystData.iteneraries[m].itinorderlist ) ).sort( function(p1, p2) {return ((p1.day != null ? p1.day : Infinity) - (p2.day != null ? p2.day : Infinity))});
								}
						}

						//this.iteneraries = res.iteneraries;
						this.tourInclusion = res.tours;
						this.listOfAttachInclusions = res.attachInclusionList;
						//console.log('ATTACHED INCLUSION FROM GET DEAL DATA :'+JSON.stringify(this.listOfAttachInclusions));
						let recordData = res.RecordTypeWrapper;
						let options = [];               
						for (var key in recordData) {
								console.log('label ='+recordData[key].RecordTypeName);
								console.log('value ='+recordData[key].RecordTypeName);
								options.push({ label: recordData[key].RecordTypeName, value: recordData[key].RecordTypeName  });
						}
						this.TypeOptions = options;
						console.log('TypeOptions ='+this.TypeOptions);
						this.properties = res.properties;
						this.iteneraries = JSON.parse( JSON.stringify( res.iteneraries) ).sort( function(p1, p2){  return (p1.itinNumber - p2.itinNumber)} );
						//this.iteneraries = JSON.parse( JSON.stringify( res.iteneraries) ).sort( (p1, p2) => (p1.itinNumber > p2.itinNumber) ? 1 : (p1.itinNumber < p2.itinNumber) ? -1 : 0);
						for(var m=0 ; m<this.iteneraries.length ; m++){
								if( (this.iteneraries.length != 1) && (m == (this.iteneraries.length - 1)) && (this.iteneraries.length < 10) ){
										for(var n=0; n<this.iteneraries[m].itinorderlist.length; n++){
												this.iteneraries[m].itinorderlist[n].disable = false;
										}
								} else if(this.iteneraries.length == 1){

										for(var n=0; n<this.iteneraries[m].itinorderlist.length; n++){
												this.iteneraries[m].itinorderlist[n].disable = false;
										}
								}

						}
						this.selectedItenararies = [];
						this.itineriesToDelete = [];
						this.itineriesToDeleteByDeletAll = [];
						this.itinload = false;
				})
						.catch(error=>{
						console.log("error occurd:- "+ JSON.stringify(error))
				});


				getPicklistvalues({objectName :'tour_inclusions__c',field_apiname :'site__c'}) 
						.then( (result) => {   

						this.toursites = result;
				}).catch(error => {
						console.log('error '+JSON.stringify(error));
				});
				getPicklistvalues({objectName :'Itinerary__c',field_apiname :'Meals_Included__c'}) 
						.then( (result) => {   

						this.mealsOptions = result;
				}).catch(error => {
						console.log('error '+JSON.stringify(error));
				});
				getPicklistvalues({objectName :'Itinerary__c',field_apiname :'country_context__c'}) 
						.then( (result) => {   
						console.log('itin country options',result);
						this.countryOptions = result;
				}).catch(error => {
						// this.resultsum = undefined;
						console.log('error '+JSON.stringify(error));
				});
		}

		handelcheckItenararies(event){
				console.log('Enter to handelcheckItenararies event  :-  '+ event.target.checked);
				// const element = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				console.log('child index:-'+ i);
				console.log('parent index:-'+j);
				this.selectedItenarary = this.iteneraries[j].itinorderlist;
				this.cloneCheck = false;
				this.checkall = true;
				if(event.target.checked === true){
						this.iteneraries[j].itinorderlist[i].check = true;
						if( j == (this.iteneraries.length - 1)  ){
								this.iteneraries[j].itinorderlist[i].selectedcount = this.selectedItenararies.length;
								this.selectedItenararies.push({id:this.selectedItenarary[i].id,
																							 day:this.selectedItenarary[i].day , 
																							 title:this.selectedItenarary[i].title , 
																							 description:this.selectedItenarary[i].description ,
																							 accommodation:this.selectedItenarary[i].accommodation , 
																							 body:this.selectedItenarary[i].body ,
																							 order:this.selectedItenarary[i].order ,
																							 selectedmeals:this.selectedItenarary[i].selectedmeals , 
																							 check:this.selectedItenarary[i].check,
																							 country:this.selectedItenarary[i].country,
																							 transfers:this.selectedItenarary[i].transfers,
																							 selectedcount: this.iteneraries[j].itinorderlist[i].selectedcount,
																							 isBlank: false
																							});

								console.log('this.selectedItenarary[i]'+ this.selectedItenarary[i]);
						}
						if(this.iteneraries.length <10){
								this.iteneraries[j].showclone = true;
						}
				}
				else if(event.target.checked === false){
						console.log('inside false event handler');
						this.iteneraries[j].itinorderlist[i].check = false;
						for(var m=0; m<this.selectedItenararies.length ; m++ ){
								console.log('this.selectedItenararies[m].selectedcount :- '+ JSON.stringify(this.selectedItenararies[m].selectedcount));
								console.log('this.selectedItenarary[i].selectedcount:- '+JSON.stringify(this.selectedItenarary[i].selectedcount));

								if(this.selectedItenararies[m].selectedcount == this.selectedItenarary[i].selectedcount ){
										this.selectedItenararies.splice(m,1);
										console.log('this.selectedItenararies :- '+ JSON.stringify(this.selectedItenararies));
								}
						}
				}
				for(var m=0 ; m<this.selectedItenarary.length; m++){
						if(this.selectedItenarary[m].check ===true ){
								if(j == (this.iteneraries.length - 1) ){
										//this.iteneraries[j].showclone = true;
										this.cloneCheck = true;
										console.log('this.cloneCheck inside :- '+ this.cloneCheck);
								}
						}
						if(this.selectedItenarary[m].check === false ){
								this.checkall = false;
						}
				}
				if(this.cloneCheck === false){
						this.iteneraries[j].showclone = false;
				}		
				if(this.checkall == false){
						this.iteneraries[j].check = false;
				}else{
						this.iteneraries[j].check = true;
				}


				console.log('this.cloneCheck :- '+ this.cloneCheck);

				console.log('this.iteneraries[j].showclone :- '+ JSON.stringify(this.iteneraries[j].showclone));
				console.log('this.selectedItenararies :- '+JSON.stringify(this.selectedItenararies));
		}

		handelclone(event){
				console.log('Enter to handelclone event '+JSON.stringify(event.detail));

				const j = event.target.getAttribute('data-id2');
				console.log("this.iteneraries[j].itinNumber>>>" + JSON.stringify(this.iteneraries[j].itinNumber));
				this.k = (this.iteneraries[j].itinNumber == undefined || this.iteneraries[j].itinNumber == "" ) ? 1 : (parseInt(this.iteneraries[j].itinNumber) + 1); 
				//parseInt(this.iteneraries[j].itinNumber) + 1;

				console.log('k:-' + this.k);
				console.log('parent index:-'+j);
				console.log('this.selectedItenararies :- '+JSON.stringify(this.selectedItenararies));
				console.log('this.iteneraries:- '+ this.iteneraries);
				console.log('itinCount:- '+ this.itinCount);
				for(var n=0; n<this.selectedItenararies.length; n++){
						if(this.selectedItenararies[n].country == undefined){
								this.selectedItenararies[n].country = 'AU';
						}
						this.selectedItenararies[n].check = false;
						this.selectedItenararies[n].isclone = true;
						this.selectedItenararies[n].isBlank = false;
						this.selectedItenararies[n].toUpdateorInsert = true;
				}
				if(this.iteneraries.length < 10){
						this.iteneraries.push({itinNumber:( (this.k> 10) ? 10 : this.k ) , itinorderlist:this.selectedItenararies, showclone:false });
				}

				console.log('this.itenerariestoclone :- '+ JSON.stringify(this.iteneraries));
				this.iteneraries[j].showclone = false;
				// for(var m=0; m<this.iteneraries[j].itinorderlist.length; m++){
				// 		console.log('Inside clone for loop');
				// 		this.iteneraries[j].itinorderlist[m].check = false;
				// 		this.iteneraries[j].itinorderlist[m].disable = true; 
				// 		console.log("this.iteneraries[j].itinorderlist[m].check :- "+this.iteneraries[j].itinorderlist[m].check); 
				// }

				// if(this.iteneraries.length >= 10){
				// 		for(var s=0 ; s<this.iteneraries[(this.iteneraries.length - 1)].itinorderlist.length; s++ ){
				// 				this.iteneraries[(this.iteneraries.length - 1)].itinorderlist[s].disable = true;
				// 		}
				// }

				this.selectedItenararies = [];
				console.log('this.iteneraries[j].showclone :- '+ JSON.stringify(this.iteneraries[j].showclone));
				console.log('this.selectedItenararies :- '+ JSON.stringify(this.selectedItenararies));    
				
				//DP-109 starts
				for(var d=0; d<this.iteneraries.length; d++){
						this.iteneraries[d].check = false;
						for(var f=0; f<this.iteneraries[d].itinorderlist.length; f++){
								this.iteneraries[d].itinorderlist[f].check = false;
						}
				}
			  //DP-109 End
		}

		//Disappearing the popup of lookup
		handleRemoveCombo(event){			
				for(var k=0;k<this.listOfAttachInclusions.length;k++){
						this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + k + '\"]').removeCombo();
				}
		}
		async deleteRowHandler(event)
		{
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				const recordtype = event.target.getAttribute('data-id3');
				console.log('child index:-'+ i);
				console.log('parent index:-'+j);
				console.log('recordtype:-'+recordtype);
				if(recordtype == "itin"){

						const result = await LightningConfirm.open({
								message: 'Click on "OK" to confirm ',
								theme: "warning", //success , warning, error, info
								variant: "default",
								label: 'Are you sure, you want to delete this Itinerary Day record?',
								// setting theme would have no effect
						});
						if(result){
								console.log('itinorderlist[i].isclone:-'+this.iteneraries[j].itinorderlist[i].isclone )
								if(this.iteneraries[j].itinorderlist[i].isclone == false){
										console.log('inside clone condition');
										this.itineriesToDelete.push( this.iteneraries[j].itinorderlist[i]);
								}

								if((j == this.iteneraries.length - 1) && (this.iteneraries[j].itinorderlist[i].check == true ) ){
										for(var s=0; s<this.selectedItenararies.length ; s++){
												if(this.selectedItenararies[s].selectedcount == this.iteneraries[j].itinorderlist[i].selectedcount){
														this.selectedItenararies.splice(s,1);
														console.log('this.selectedItenararies:- '+JSON.stringify(this.selectedItenararies));
												}
										}
								}

								console.log('itineriesToDelete:- '+JSON.stringify(this.itineriesToDelete));
								this.iteneraries[j].itinorderlist.splice(i,1);
								if(this.iteneraries[j].itinorderlist.length == 0){

										this.iteneraries.splice(j,1); 
								}

								if((this.iteneraries.length != 0) && (this.iteneraries.length < 10)){
										const k = this.iteneraries.length - 1;	
										for(var m=0; m<this.iteneraries[k].itinorderlist.length; m++){
												this.iteneraries[k].itinorderlist[m].disable = false;
										}
								}else if(this.iteneraries.length == 0){

										this.blankitin = [{
												isclone:true,
												day:1,
												description:'',
												isBlank:true,

										}];
										this.iteneraries.push({itinNumber:"1", itinorderlist:this.blankitin, showclone:false});

										this.event1 = 	setTimeout(() => {
												this.iteneraries[0].itinorderlist[0].isBlank =true;
										}, 50);

								}
						}

				}else if(recordtype == "Attach"){

						/*if(i+1 == this.listOfAttachInclusions.length){
							this.template.querySelector('c-lwc-Lookup').changeMessage(i);
						}*/
						if(this.listOfAttachInclusions[i].isclone == false){
								this.insclusiontodelete.push(this.listOfAttachInclusions[i]);
						}
						if(this.listOfAttachInclusions[i].isPublishInclusionSelected == 'None-Selected'){
								this.RecordName = '';
								this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + i + '\"]').resetErrorMessage(this.RecordName);
						}
						this.listOfAttachInclusions.splice(i,1);
						let newArray = [];
						newArray = this.listOfAttachInclusions;
						this.listOfAttachInclusions = [];
						this.listOfAttachInclusions = newArray;
						for(var k=0;k<this.listOfAttachInclusions.length;k++){
								//alert('detail ='+this.listOfAttachInclusions[k].selectedPublishedInclusionsDetail);
								//alert('id ='+this.listOfAttachInclusions[k].selectedPublishedInclusions);
								if(this.listOfAttachInclusions[k].selectedPublishedInclusionsDetail!=null &&  this.listOfAttachInclusions[k].selectedPublishedInclusions!=null){						
										let splitStr = this.listOfAttachInclusions[k].selectedPublishedInclusionsDetail.split(' , ');
										this.RecordName = splitStr[0];
										this.RecordURL = splitStr[1];
										this.RecordID = this.listOfAttachInclusions[k].selectedPublishedInclusions;	
										this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + k + '\"]').resetItem(this.RecordName,this.RecordURL,this.RecordID);
								}
								else if(this.listOfAttachInclusions[k].isPublishInclusionSelected == 'None-Selected'){
										this.RecordName = this.listOfAttachInclusions[k].selectedPublishedInclusionsDetail;
										//alert(this.RecordName);
										this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + k + '\"]').resetErrorMessage(this.RecordName);
								}
								else{
										this.RecordName = '';
										this.RecordURL = '';
										this.RecordID = ''	
										this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + k + '\"]').resetItem(this.RecordName,this.RecordURL,this.RecordID);	
								}

						}

						this.listOfAttachInclusionsTraker = JSON.stringify(this.listOfAttachInclusions);
						if(this.listOfAttachInclusions.length == 0){
								this.template.querySelector('c-lwc-Lookup[data-id1 = "0"]').resetItem('','','');	
								this.listOfAttachInclusions.push({ isclone:true, toUpdateorInsert:true , selectedRecordType : 'Deal - Highlights' ,  isRecordBlank : true});
						}
						console.log("this.listOfAttachInclusions:- "+ JSON.stringify(this.listOfAttachInclusions));
						console.log("this.insclusiontodelete:- "+ JSON.stringify(this.insclusiontodelete));

				}

				else if(recordtype == "tour"){
						if(this.tourInclusion[i].isclone == false){
								this.tourtodelete.push(this.tourInclusion[i]);
						}

						this.tourInclusion.splice(i,1);

						if(this.tourInclusion.length == 0){
								this.tourInclusion.push({ isclone:true, toUpdateorInsert:true, isBlank:true, order:null, description:''  });
								this.event1 = 	setTimeout(() => {
										this.tourInclusion[0].isBlank =true;
										console.log("this.tourInclusion 416:- "+ JSON.stringify(this.tourInclusion));
								}, 50);

						}
						console.log("this.tourInclusion:- "+ JSON.stringify(this.tourInclusion));
						console.log("this.tourtodelete:- "+ JSON.stringify(this.tourtodelete));

				}else if(recordtype == "property"){
						if(this.properties[i].isclone == false){
								this.propertiestodelete.push(this.properties[i]);
						}
						this.properties.splice(i,1);
						if(this.properties.length == 0){
								this.properties.push({ isclone:true, toUpdateorInsert:true, isBlank:true, order:null,description:'' })
								this.event1 = 	setTimeout(() => {
										this.properties[0].isBlank =true;
										console.log("this.properties:- "+ JSON.stringify(this.properties));
								}, 50);
						}
				}

		}

		handleAddItinRow(event){
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				console.log('child index:-'+ i);
				console.log('parent index:-'+j);
				let dayNumber  = this.iteneraries[j].itinorderlist.length + 1;//DP-67

				this.tempitinrow = Object.assign({}, this.iteneraries[j].itinorderlist[i] ) ;
				this.tempitinrow.day = parseInt(dayNumber); //DP-67
				console.log("this.tempitinrow.day:- "+JSON.stringify(this.tempitinrow.day));
				//this.tempitindata = Object.assign({}, this.iteneraries[j].itinorderlist[i]; ) ;
				if(this.iteneraries[j].itinorderlist[i].day === undefined){
						this.tempitinrow.day = null;
						this.iteneraries[j].itinorderlist[i].day = null;
				}
				this.tempitinrow.isclone = true;
				if(this.tempitinrow.country == undefined){
						this.tempitinrow.country = 'AU';
				}
				this.tempitinrow.toUpdateorInsert = true;
				console.log('tempitinrow:- '+ JSON.stringify(this.tempitinrow));
				this.iteneraries[j].itinorderlist.push(this.tempitinrow);

				if((j == this.iteneraries.length - 1) && (this.iteneraries[j].itinorderlist[i].check == true) ){
						console.log('last parent index:-'+j);
						this.iteneraries[j].itinorderlist[(this.iteneraries[j].itinorderlist.length - 1)].selectedcount = this.selectedItenararies.length;
						console.log("this.iteneraries[j].itinorderlist[i]:- "+ JSON.stringify(this.iteneraries[j].itinorderlist[i]));
				}

				if(this.tempitinrow.check == true){
						//this.tempitinrow.selectedcount = this.selectedItenararies.length; 
						this.selectedItenararies.push({id:this.tempitinrow.id,
																					 day:this.tempitinrow.day , 
																					 title:this.tempitinrow.title , 
																					 description:this.tempitinrow.description ,
																					 accommodation:this.tempitinrow.accommodation , 
																					 body:this.tempitinrow.body ,
																					 order:this.tempitinrow.order ,
																					 selectedmeals:this.tempitinrow.selectedmeals , 
																					 check:false,
																					 country:this.tempitinrow.country,
																					 transfers:this.tempitinrow.transfers,
																					 selectedcount: this.tempitinrow.selectedcount
																					});

				}
				console.log('this.selectedItenararies:- '+ JSON.stringify(this.selectedItenararies));
		}

		OnchangeFieldValue(event){
				this.value = event.target.value;
				//data-id3= "itin", "tour"
				const fieldname = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				const recordtype = event.target.getAttribute('data-id3');


				console.log('child index:-'+ i);
				console.log('parent index:-'+j);
				console.log('fieldname:-'+ fieldname);
				console.log('Onchange Value:-'+JSON.stringify(this.value));


				if(recordtype == "itin" ){

						this.iteneraries[j].itinorderlist[i].isBlank = false;
						this.iteneraries[j].itinorderlist[i].toUpdateorInsert = true;
						// day , title, description, Selected Meals,  accommodation , 

						if(fieldname == "day"){
								console.log("Inside day OnchangeFieldValue");
								this.iteneraries[j].itinorderlist[i].day = this.value;
								console.log("day" + JSON.stringify(this.iteneraries[j].itinorderlist[i].day));
						}else if(fieldname == "title"){
								console.log("Inside title OnchangeFieldValue");
								this.iteneraries[j].itinorderlist[i].title = this.value;
								console.log("title" + JSON.stringify(this.iteneraries[j].itinorderlist[i].title));

						}
						else if(fieldname == "description"){
								console.log("Inside description OnchangeFieldValue");
								this.iteneraries[j].itinorderlist[i].description = this.value;
								console.log("description" + JSON.stringify(this.iteneraries[j].itinorderlist[i].description));
						}
						else if(fieldname == "Selected Meals"){
								console.log("Inside Selected Meals OnchangeFieldValue");
								this.iteneraries[j].itinorderlist[i].selectedmeals = this.value;
								console.log("selectedmeals" + JSON.stringify(this.iteneraries[j].itinorderlist[i].selectedmeals));
						}
						else if(fieldname == "accommodation"){
								console.log("Inside accommodation OnchangeFieldValue");
								this.iteneraries[j].itinorderlist[i].accommodation = this.value;
								console.log("accommodation" + JSON.stringify(this.iteneraries[j].itinorderlist[i].accommodation));
						}

						if((j== this.iteneraries.length -1) && (this.iteneraries[j].itinorderlist[i].check == true)){
								for(var m=0; m<this.selectedItenararies.length ; m++){
										if(this.selectedItenararies[m].selectedcount == this.iteneraries[j].itinorderlist[i].selectedcount ){
												if(fieldname == "day"){
														this.selectedItenararies[m].day = this.value;
														console.log("day" + JSON.stringify(this.selectedItenararies[m].day));
												}else if(fieldname == "title"){
														this.selectedItenararies[m].title = this.value;
														console.log("title" + JSON.stringify(this.selectedItenararies[m].title));

												}
												else if(fieldname == "description"){
														this.selectedItenararies[m].description = this.value;
														console.log("description" + JSON.stringify(this.selectedItenararies[m].description));
												}
												else if(fieldname == "Selected Meals"){
														this.selectedItenararies[m].selectedmeals = this.value;
														console.log("selectedmeals" + JSON.stringify(this.selectedItenararies[m].selectedmeals));
												}
												else if(fieldname == "accommodation"){
														this.selectedItenararies[m].accommodation = this.value;
														console.log("accommodation" + JSON.stringify(this.selectedItenararies[m].accommodation));
												}
										}
								}
						}

						console.log("toUpdateorInsert :- "+ JSON.stringify(this.iteneraries[j].itinorderlist[i].toUpdateorInsert));

				}
				else if(recordtype == "highlights"){
						if(fieldname == "dealtitle"){
								this.dealtitle = this.value;
						}else if(fieldname == "dealhighlights"){
								this.dealhighlights = this.value;
						}						

				}
				else if(recordtype == "Attach"){
						if(fieldname == "RecordType"){
								this.listOfAttachInclusions[i].selectedRecordType = this.value;
						}else if(fieldname == "Publish"){
								console.log('497 Line ==='+event.detail.eventFiredFrom);
								if(event.detail.eventFiredFrom == 'handleCommit'){
										this.listOfAttachInclusions[i].selectedPublishedInclusions = null;
										this.listOfAttachInclusions[i].selectedPublishedInclusionsDetail = null;
										this.listOfAttachInclusions[i].isPublishInclusionSelected = 'BLANK';
										this.listOfAttachInclusions[i].toUpdateorInsert = true;
								}else if(event.detail.eventFiredFrom == 'handleSelect'){
										this.listOfAttachInclusions[i].selectedPublishedInclusions = event.detail.recordSelectedId;
										this.listOfAttachInclusions[i].selectedPublishedInclusionsDetail = event.detail.Name + ' , '+event.detail.IconImage;
										this.listOfAttachInclusions[i].isPublishInclusionSelected =  event.detail.Name + ' , '+event.detail.IconImage;
										this.listOfAttachInclusions[i].toUpdateorInsert = true;
								}else if(event.detail.eventFiredFrom == 'handleChange'){
										console.log('SEARCH KEY IN DEAL COMPONENT ='+event.detail.searchKey);
										if(event.detail.searchKey == ''){
												this.listOfAttachInclusions[i].selectedPublishedInclusions = null;
												this.listOfAttachInclusions[i].selectedPublishedInclusionsDetail = null;
												this.listOfAttachInclusions[i].toUpdateorInsert = true;
												this.listOfAttachInclusions[i].isPublishInclusionSelected = 'BLANK';
										}else{
												this.listOfAttachInclusions[i].selectedPublishedInclusions = null;
												this.listOfAttachInclusions[i].selectedPublishedInclusionsDetail = event.detail.searchKey ;
												this.listOfAttachInclusions[i].isPublishInclusionSelected = 'None-Selected';
												this.listOfAttachInclusions[i].toUpdateorInsert = true;

										}

								}

						}else if(fieldname == "Text"){
								this.listOfAttachInclusions[i].selectedText = this.value;
						}

						this.listOfAttachInclusions[i].isRecordBlank = false;
						this.listOfAttachInclusions[i].toUpdateorInsert = true;
				}
				else if( recordtype =="tour"){

						if(fieldname == "tourtitle"){

								this.tourInclusion[i].title = this.value;
								console.log("tourtitle" + JSON.stringify(this.tourInclusion[i].title));
						}else if(fieldname == "tour description"){

								this.tourInclusion[i].description = this.value;
								console.log("tour  description" + JSON.stringify(this.tourInclusion[i].description));
								//order, 
						}else if(fieldname == "tour site"){

								this.tourInclusion[i].selectedsite = this.value;
								console.log("tour site" + JSON.stringify(this.tourInclusion[i].selectedsite));
						}else if(fieldname == "tour order"){
								if(this.value == ""){
										this.tourInclusion[i].order = null;
								}else{
										this.tourInclusion[i].order = this.value;		
								}

								console.log("tour order" + JSON.stringify(this.tourInclusion[i].order));
						}
						this.tourInclusion[i].toUpdateorInsert = true;
						this.tourInclusion[i].isBlank = false;
				}else if(recordtype =="property"){

						if(fieldname == "propertytitle"){

								this.properties[i].title = this.value;
								console.log("propertytitle" + JSON.stringify(this.properties[i].title));
						}else if(fieldname == "property description"){

								this.properties[i].description = this.value;
								console.log("property  description" + JSON.stringify(this.properties[i].description));
								//order, 
						}else if(fieldname == "property site"){

								this.properties[i].selectedsite = this.value;
								console.log("property site" + JSON.stringify(this.properties[i].selectedsite));
						}else if(fieldname == "property order"){
								if(this.value == ""){
										this.properties[i].order = null;
								}else{
										this.properties[i].order = this.value;		
								}

								console.log("property order" + JSON.stringify(this.properties[i].order));
						}
						this.properties[i].toUpdateorInsert = true;
						this.properties[i].isBlank = false;
				}

		}

		changeOrder(event){
				this.value = event.target.value;
				const i = event.target.getAttribute('data-id1');
				console.log("Enter in ChangeOrder Event:- "+ i);
				this.itinerarrList = this.iteneraries[i].itinorderlist;
				if(this.value < 11){
						this.iteneraries[i].itinNumber = this.value;
						for(var m=0; m<this.iteneraries[i].itinorderlist.length;m++){
								this.iteneraries[i].itinorderlist[m].toUpdateorInsert = true;
								this.iteneraries[i].itinorderlist[m].order = this.value;
						}
				}
				console.log("this.iteneraries[i].itinorderlist:- "+ JSON.stringify(this.iteneraries[i].itinorderlist));
		}

		saveHandler(event){
				this.eventname = event.target.getAttribute('data-id');
				this.itinload = true;
				console.log("this.eventname:- "+ this.eventname);
				if(this.eventname == 'itineraries'){
						console.log('Enter to handelclone event '+JSON.stringify(event.detail));
						console.log(" this.iteneraries:- "+ JSON.stringify( this.iteneraries));
						console.log(" this.recordId:- "+ JSON.stringify( this.recordId));
						console.log('this.itineriesToDelete:- '+JSON.stringify(this.itineriesToDelete));
						SaveIteneries({itenerariesOrderWrap : this.iteneraries , dealId : this.recordId , iteneraryDataToDelete : this.itineriesToDelete})
								.then(res=>{

								console.log(" succeed "+ JSON.stringify(res) );

								this.event1 = 	setTimeout(() => {
										//this.itineriesToDelete = [];
										this.showNotification();
										this.getDealData();
										this.itinload = false;
								}, 7000);


						})
								.catch(error=>{
								console.log("error occurred:- "+ JSON.stringify(error));
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: "error occurred ",
										message: '' ,
										variant: 'error',
								});
								this.dispatchEvent(evt);
						});

						//window.location.reload();


						//this.selectedItenararies = [];

						//this.getDealData();
						for(var m=0; m<this.iteneraries.length; m++){
								console.log('this.iteneraries inside:- '+JSON.stringify(this.iteneraries));
								console.log('m inside:- '+ m );
								for(var n=0; n<this.iteneraries[m].itinorderlist.length; n++){
										console.log('n inside:- '+ n);
										this.iteneraries[m].itinorderlist[n].isclone = false;
										this.iteneraries[m].itinorderlist[n].toUpdateorInsert = false;
								}
						}
				}else if((this.eventname == 'Important Information' ) || (this.eventname == 'Overview')){

						const error = "error occurred While saving "+ this.eventname;
						saveDeal({data:this.dealdata , fieldname: this.eventname })
								.then(res=>{
								console.log(" succeed "+ JSON.stringify(res) );
								const evt = new ShowToastEvent({
										title: 'Success',
										message: this.eventname +' saved successfully ',
										variant: 'success',
										duration:' 50000',});
								this.event1 = 	setTimeout(() => {
										this.dispatchEvent(evt);			
										this.getDealData();
										this.itinload = false;
								}, 4000);


						}).catch(err=>{

								console.log("error occurred:- "+ JSON.stringify(err));
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message: this.error,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						});
				}else if(this.eventname == 'highlights'){

						saveHighlights({title: this.dealtitle , description: this.dealhighlights, dealId: this.recordId  })
								.then(res=>{
								//console.log(" succeed "+ JSON.stringify(res) );

								const evt = new ShowToastEvent({
										title: 'Success',
										message:  ' Deal Highlights saved successfully ',
										variant: 'success',
										duration:' 50000',});

								this.event1 = 	setTimeout(() => {
										this.dispatchEvent(evt);			
										this.getDealData();
										this.itinload = false;
								}, 4000);


						}).catch(err=>{

								//	console.log("error occurred:- "+ JSON.stringify(err));
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message: 'Error while saving '+ this.eventname ,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						});

				}

				else if(this.eventname == 'tour' ){
						savetours({tourlist: this.tourInclusion , toursToDelete: this.tourtodelete, dealId: this.recordId  })
								.then(res=>{
								console.log(" succeed "+ JSON.stringify(res) );
								this.tourInclusion = [];
								const evt = new ShowToastEvent({
										title: 'Success',
										message:  ' Tour Inclusions saved successfully ',
										variant: 'success',
										duration:' 50000',});

								this.event1 = 	setTimeout(() => {
										this.dispatchEvent(evt);			
										this.getDealData();
										this.itinload = false;
								}, 4000);


						}).catch(err=>{

								console.log("error occurred:- "+ JSON.stringify(err));
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message: 'Error while saving '+ this.eventname ,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						});
						this.tourtodelete =[];
				}else if(this.eventname == 'Attach' ){
						console.log('ON SAVE = '+JSON.stringify(this.listOfAttachInclusions));
						var count = 0;
						for(var m=0; m<this.listOfAttachInclusions.length; m++){
								console.log('m ='+this.listOfAttachInclusions[m].selectedPublishedInclusionsDetail)
								if(this.listOfAttachInclusions[m].isPublishInclusionSelected == 'None-Selected'){
										this.template.querySelector('c-lwc-Lookup[data-id1 = \"' + m + '\"]').displayError();
										count = count+1;
								}
						}

						if(count == 0){
								this.deleteTraker = JSON.stringify(this.insclusiontodelete);
								this.saveTraker = JSON.stringify(this.listOfAttachInclusions);
								saveAttachInclusions({inclusionList: this.listOfAttachInclusions , inclusionListToDelete: this.insclusiontodelete, dealId: this.recordId  })
										.then(res=>{
										console.log(" succeed "+ JSON.stringify(res) );

										const evt = new ShowToastEvent({
												title: 'Success',
												message:  ' Attach Inclusions saved successfully ',
												variant: 'success',
												duration:' 50000',});

										this.event1 = 	setTimeout(() => {
												this.dispatchEvent(evt);
												this.listOfAttachInclusions = [];	
												this.getDealData();
												this.itinload = false;
										}, 4000);


								}).catch(err=>{
										console.log("error occurred:- "+ JSON.stringify(err));
										this.itinload = false;
										const evt = new ShowToastEvent({
												title: 'Error occurred',
												message: 'Error while saving '+ this.eventname ,
												variant: 'error',
												duration:' 50000',
										});
										this.dispatchEvent(evt);
								});
								this.inclusionListToDelete =[];
						}else{
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message:  'Publish Inclusions are not selected. Please select an option or remove the search term.' ,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						}

				}

				else if(this.eventname == 'property'){
						saveproperty({propertylist: this.properties , propertiesToDelete: this.propertiestodelete , dealId: this.recordId  })
								.then(res=>{
								console.log(" succeed "+ JSON.stringify(res) );

								const evt = new ShowToastEvent({
										title: 'Success',
										message:  ' Properties saved successfully ',
										variant: 'success',
										duration:' 50000',});

								this.properties = [];
								this.event1 = 	setTimeout(() => {
										this.dispatchEvent(evt);			
										this.getDealData();
										this.itinload = false;
								}, 4000);

						}).catch(err=>{
								console.log("error occurred:- "+ JSON.stringify(err));
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message: 'Error while saving '+ this.eventname ,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						});

				}

		}

		showNotification() {
				const evt = new ShowToastEvent({
						title: "Itineraries Saved Successfully ",
						message: '' ,
						variant: 'success',
				});
				this.dispatchEvent(evt);
		}

		handleShowModal(event) {
				const popupname = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				const copyname = event.target.getAttribute('data-id3');
				console.log('popupname:- '+ popupname);
				console.log('child index:-'+ i);
				console.log('parent index:-'+j);
				console.log('copyname:- '+ copyname);
				if(copyname == "Final"){
						this.datadisabled = this.restrictInput;
				}else{
						this.datadisabled = true;
				}
				if(popupname == "itin" ){
						this.itindataPopUp =[];
						if(copyname == "Final"){
								if(this.iteneraries[j].itinorderlist[i].country == undefined){
										this.country = 'AU';
								}else{
										this.country = this.iteneraries[j].itinorderlist[i].country;
								}
								this.itinNumber = this.iteneraries[j].itinNumber;
								this.itindataPopUp = {

										childIndex : i,
										parentIndex : j ,
										id: this.iteneraries[j].itinorderlist[i].id,
										day: this.iteneraries[j].itinorderlist[i].day,
										title: this.iteneraries[j].itinorderlist[i].title,
										description: this.iteneraries[j].itinorderlist[i].description,
										accommodation: this.iteneraries[j].itinorderlist[i].accommodation,
										name: this.iteneraries[j].itinorderlist[i].name,
										//country: this.iteneraries[j].itinorderlist[i].country,
										country : this.country,
										transfers: this.iteneraries[j].itinorderlist[i].transfers,
										selectedmeals: this.iteneraries[j].itinorderlist[i].selectedmeals,
										isclone: this.iteneraries[j].itinorderlist[i].isclone , 
										toUpdateorInsert: this.iteneraries[j].itinorderlist[i].toUpdateorInsert,
										check: this.iteneraries[j].itinorderlist[i].check,
										isBlank: this.iteneraries[j].itinorderlist[i].isBlank
										//activity: this.iteneraries[j].itinorderlist[i].activity															
								};


						}else if(copyname == "Analyst"){
								this.itinNumber = this.AnalystData.iteneraries[j].itinNumber;
								this.itindataPopUp = {

										childIndex : i,
										parentIndex : j ,
										id: this.AnalystData.iteneraries[j].itinorderlist[i].id,
										day: this.AnalystData.iteneraries[j].itinorderlist[i].day,
										title: this.AnalystData.iteneraries[j].itinorderlist[i].title,
										description: this.AnalystData.iteneraries[j].itinorderlist[i].description,
										accommodation: this.AnalystData.iteneraries[j].itinorderlist[i].accommodation,
										name: this.AnalystData.iteneraries[j].itinorderlist[i].name,
										country: this.AnalystData.iteneraries[j].itinorderlist[i].country,
										transfers: this.AnalystData.iteneraries[j].itinorderlist[i].transfers,
										selectedmeals: this.AnalystData.iteneraries[j].itinorderlist[i].selectedmeals,
										isclone: this.AnalystData.iteneraries[j].itinorderlist[i].isclone , 
										toUpdateorInsert: this.AnalystData.iteneraries[j].itinorderlist[i].toUpdateorInsert,
										check: this.AnalystData.iteneraries[j].itinorderlist[i].check
										//activity: this.AnalystData.iteneraries[j].itinorderlist[i].activity															
								};
						}else if(copyname == "BDM"){
								this.itinNumber = this.BDMData.iteneraries[j].itinNumber;
								this.itindataPopUp = {

										childIndex : i,
										parentIndex : j ,
										id: this.BDMData.iteneraries[j].itinorderlist[i].id,
										day: this.BDMData.iteneraries[j].itinorderlist[i].day,
										title: this.BDMData.iteneraries[j].itinorderlist[i].title,
										description: this.BDMData.iteneraries[j].itinorderlist[i].description,
										accommodation: this.BDMData.iteneraries[j].itinorderlist[i].accommodation,
										name: this.BDMData.iteneraries[j].itinorderlist[i].name,
										country: this.BDMData.iteneraries[j].itinorderlist[i].country,
										transfers: this.BDMData.iteneraries[j].itinorderlist[i].transfers,
										selectedmeals: this.BDMData.iteneraries[j].itinorderlist[i].selectedmeals,
										isclone: this.BDMData.iteneraries[j].itinorderlist[i].isclone , 
										toUpdateorInsert: this.BDMData.iteneraries[j].itinorderlist[i].toUpdateorInsert,
										check: this.BDMData.iteneraries[j].itinorderlist[i].check
										//activity: this.BDMData.iteneraries[j].itinorderlist[i].activity															
								};
						}
						console.log("Inside Parent componentr value:- "+ JSON.stringify(this.itindataPopUp));
						this.showModal = true;

				}else if(popupname == "tour" ){

						this.tourdataPopUp =[];
						if(copyname == "Final"){
								this.tourdataPopUp = { 

										childIndex: i, 
										name: this.tourInclusion[i].name,
										title: this.tourInclusion[i].title,
										description: this.tourInclusion[i].description,
										selectedsite: this.tourInclusion[i].selectedsite,
										order: this.tourInclusion[i].order,
										isclone: this.tourInclusion[i].isclone, 
										toUpdateorInsert: this.tourInclusion[i].toUpdateorInsert,  
										id:this.tourInclusion[i].id,
										isBlank:this.tourInclusion[i].isBlank

								};
								this.tourname = 'Tour Inclusion - '+ this.tourInclusion[i].name;
						}else if(copyname == "Analyst"){
								this.tourname ='Tour Inclusion - '+this.AnalystData.tours[i].name;
								this.tourdataPopUp = {

										childIndex: i, 
										name: this.AnalystData.tours[i].name ,
										title: this.AnalystData.tours[i].title,
										description: this.AnalystData.tours[i].description,
										selectedsite: this.AnalystData.tours[i].selectedsite,
										order: this.AnalystData.tours[i].order,   			

								};

						}else if(copyname == "BDM"){

								this.tourname ='Tour Inclusion - '+this.BDMData.tours[i].name;

								this.tourdataPopUp = {  
										childIndex: i, 
										name: this.BDMData.tours[i].name,
										title: this.BDMData.tours[i].title,
										description: this.BDMData.tours[i].description,
										selectedsite: this.BDMData.tours[i].selectedsite,
										order: this.BDMData.tours[i].order,																	
								};
						} 
						console.log("Inside Parent component tourdatapopup value:- "+ JSON.stringify(this.tourdataPopUp));
						this.showtour = true;
				}else if(popupname == "attachInclusions"){
						const modeltoshow = true;
						const attachInclusionsEvent = new CustomEvent ("handleShowModal", { detail:{modeltoshow}
																																							});
						this.dispatchEvent(attachInclusionsEvent);

				}else if(popupname == "property"){
						if( copyname == "Final"){
								this.propertydataPopUp = {
										childIndex: i, 
										name: this.properties[i].name,
										title: this.properties[i].title,
										description: this.properties[i].description,
										selectedsite: this.properties[i].selectedsite,
										order: this.properties[i].order,
										isclone: this.properties[i].isclone, 
										toUpdateorInsert: this.properties[i].toUpdateorInsert,  
										id:this.properties[i].id,
										isBlank:this.properties[i].isBlank
								};

						}else if(copyname == "Analyst"){
								this.propertydataPopUp = {
										childIndex: i, 
										name: this.AnalystData.properties[i].name,
										title: this.AnalystData.properties[i].title,
										description: this.AnalystData.properties[i].description,
										selectedsite: this.AnalystData.properties[i].selectedsite,
										order: this.AnalystData.properties[i].order,
								};

						}else if(copyname == "BDM"){
								this.propertydataPopUp = {
										childIndex: i, 
										name: this.BDMData.properties[i].name,
										title: this.BDMData.properties[i].title,
										description: this.BDMData.properties[i].description,
										selectedsite: this.BDMData.properties[i].selectedsite,
										order: this.BDMData.properties[i].order,
								};
						}

						console.log("Inside Parent component propertydataPopUp value:- "+ JSON.stringify(this.propertydataPopUp));
						this.showproperty = true;	
				}else if(popupname == "clone itin records"){
						this.showdealpopup = true;
				}

		}

		closePopup(event){
				this.showchild  = event.detail.showModal;
				this.popupName = event.detail.popupName;
				console.log("popupName:- " + JSON.stringify(this.popupName));
				console.log("this.showchild:- " + JSON.stringify(this.showchild));
				if(this.popupName == "itin"){
						this.showModal = this.showchild;
				}
				if(this.popupName == "tour"){
						this.showtour = this.showchild;
				}if(this.popupName == "property"){
						this.showproperty = this.showchild;
				}if(this.popupName == "Attach"){
						this.showAttach = this.showchild;
				}if(this.popupName == "deallookup"){
						this.showdealpopup = this.showchild;
				}
		}

		childFieldChange(event){
				this.itindataTemp = event.detail;

				// day , title, description, accommodation , inclusions , transfers , country

				console.log("this.description:- "+JSON.stringify(this.description));

				console.log("this.itindataTemp:- " + JSON.stringify(this.itindataTemp));
				const childIndex = this.itindataTemp.childIndex;
				const parentIndex = this.itindataTemp.parentIndex;
				this.iteneraries[parentIndex].itinorderlist[childIndex].id = this.itindataTemp.id;
				this.iteneraries[parentIndex].itinorderlist[childIndex].day = this.itindataTemp.day;
				this.iteneraries[parentIndex].itinorderlist[childIndex].title = this.itindataTemp.title;
				this.iteneraries[parentIndex].itinorderlist[childIndex].description = this.itindataTemp.description;
				this.iteneraries[parentIndex].itinorderlist[childIndex].accommodation = this.itindataTemp.accommodation;
				this.iteneraries[parentIndex].itinorderlist[childIndex].selectedmeals = this.itindataTemp.selectedmeals;
				this.iteneraries[parentIndex].itinorderlist[childIndex].transfers = this.itindataTemp.inclusions;
				this.iteneraries[parentIndex].itinorderlist[childIndex].country = this.itindataTemp.country;
				this.iteneraries[parentIndex].itinorderlist[childIndex].transfers = this.itindataTemp.transfers;
				this.iteneraries[parentIndex].itinorderlist[childIndex].toUpdateorInsert = this.itindataTemp.toUpdateorInsert;
				this.iteneraries[parentIndex].itinorderlist[childIndex].isclone = this.itindataTemp.isclone;
				this.iteneraries[parentIndex].itinorderlist[childIndex].isBlank = this.itindataTemp.isBlank;

				if((parentIndex == this.iteneraries.length -1) && (this.iteneraries[parentIndex].itinorderlist[childIndex].check == true) ){
						for(var m=0 ; m<this.selectedItenararies.length ; m++){
								if(this.selectedItenararies[m].selectedcount == this.iteneraries[parentIndex].itinorderlist[childIndex].selectedcount ){
										this.selectedItenararies[m].id	= this.iteneraries[parentIndex].itinorderlist[childIndex].id ;
										this.selectedItenararies[m].day	= this.iteneraries[parentIndex].itinorderlist[childIndex].day ;
										this.selectedItenararies[m].title	= this.iteneraries[parentIndex].itinorderlist[childIndex].title ;
										this.selectedItenararies[m].description	= this.iteneraries[parentIndex].itinorderlist[childIndex].description ;
										this.selectedItenararies[m].accommodation	= this.iteneraries[parentIndex].itinorderlist[childIndex].accommodation ;
										this.selectedItenararies[m].selectedmeals	= this.iteneraries[parentIndex].itinorderlist[childIndex].selectedmeals ;
										this.selectedItenararies[m].transfers	= this.iteneraries[parentIndex].itinorderlist[childIndex].transfers ;
										this.selectedItenararies[m].country	= this.iteneraries[parentIndex].itinorderlist[childIndex].country ;
										this.selectedItenararies[m].isBlank	= this.iteneraries[parentIndex].itinorderlist[childIndex].isBlank ;
										//this.selectedItenararies[m].toUpdateorInsert	= this.iteneraries[parentIndex].itinorderlist[childIndex].toUpdateorInsert ;
										//this.selectedItenararies[m].isclone	= this.iteneraries[parentIndex].itinorderlist[childIndex].isclone ;
								}
						}
				}

		}

		tourfieldsChange(event){
				this.tourdataTemp = event.detail;
				console.log("this.tourdataTemp >>:- "+JSON.stringify(this.tourdataTemp));
				const tourIndex = this.tourdataTemp.childIndex;
				console.log("tourIndex:->>>"+ tourIndex);
				//title, order, Selected Site, description
				this.tourInclusion[tourIndex].id = this.tourdataTemp.id;
				this.tourInclusion[tourIndex].name = this.tourdataTemp.name;
				this.tourInclusion[tourIndex].title = this.tourdataTemp.title;
				this.tourInclusion[tourIndex].order = this.tourdataTemp.order;
				this.tourInclusion[tourIndex].selectedsite = this.tourdataTemp.selectedsite;
				this.tourInclusion[tourIndex].description = this.tourdataTemp.description;
				this.tourInclusion[tourIndex].isclone = this.tourdataTemp.isclone;
				this.tourInclusion[tourIndex].toUpdateorInsert = this.tourdataTemp.toUpdateorInsert;
				this.tourInclusion[tourIndex].isBlank = this.tourdataTemp.isBlank;
		}

		propertyfieldsChange(event){
				this.propertydataTemp = event.detail;
				console.log("this.propertydataTemp >>:- "+JSON.stringify(this.propertydataTemp));
				const propertyIndex = this.propertydataTemp.childIndex;

				this.properties[propertyIndex].id = this.propertydataTemp.id;
				this.properties[propertyIndex].name = this.propertydataTemp.name;
				this.properties[propertyIndex].title = this.propertydataTemp.title;
				this.properties[propertyIndex].order = this.propertydataTemp.order;
				this.properties[propertyIndex].selectedsite = this.propertydataTemp.selectedsite;
				this.properties[propertyIndex].description = this.propertydataTemp.description;
				this.properties[propertyIndex].isclone = this.propertydataTemp.isclone;
				this.properties[propertyIndex].toUpdateorInsert = this.propertydataTemp.toUpdateorInsert;
				this.properties[propertyIndex].isBlank = this.propertydataTemp.isBlank;
		}

		sortRecs( event ) {
				//data-id="itinaries" data-id1={index}
				const i = event.target.getAttribute("data-id1");
				this.datatype = event.target.getAttribute("data-id");
				this.colName = event.target.name;
				console.log( 'this parent index ' + i );
				console.log( 'Column Name is ' + this.colName );
				console.log( 'this.datatype ' + this.datatype );
				console.log( 'this.sortedColumn ' + this.sortedColumn );

				if(this.datatype == "itinaries"){
						if(this.iteneraries[i].sortup === false){
								this.iteneraries[i].sortup = true;
								//this.dnarrow = false;
						}else{
								this.iteneraries[i].sortup  = false;
								//this.dnarrow = true;
						}

						this.isReverse = this.sortedDirection === 'asc' ? 1 : -1;

						console.log('isReverse:- ' + this.isReverse);
						console.log('this.sortedDirection ' + this.sortedDirection);

						this.sortedColumn = this.colName;

						// sort the data
						if(this.datatype == "itinaries" && this.iteneraries[i].sortup === true ){

								this.iteneraries[i].itinorderlist = JSON.parse( JSON.stringify( this.iteneraries[i].itinorderlist ) ).sort( function(p1, p2) {return ((p1.day != null ? p1.day : Infinity) - (p2.day != null ? p2.day : Infinity))});
								// this.iteneraries[i].itinorderlist = JSON.parse( JSON.stringify( this.iteneraries[i].itinorderlist ) ).sort( (p1, p2) =>
								// 																																																					 (p1.day > p2.day) ? 1 : (p1.day < p2.day) ? -1 : 0);
						}else if(this.datatype == "itinaries" && this.iteneraries[i].sortup === false){
								this.iteneraries[i].itinorderlist = JSON.parse( JSON.stringify( this.iteneraries[i].itinorderlist ) ).sort( function(p1, p2) {return ((p1.day != null ? p1.day : Infinity) - (p2.day != null ? p2.day : Infinity))}).reverse();
						}
				}else if(this.datatype == "tour"){
						if(this.dealdata.toursort === true){
								this.dealdata.toursort = false
								this.toursortup = false
						}else if(this.dealdata.toursort === false){
								this.dealdata.toursort = true;
								this.toursortup = true;
						}
						if(this.dealdata.toursort == true){
								this.tourInclusion = JSON.parse(JSON.stringify(this.tourInclusion)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
						}else if(this.dealdata.toursort == false){
								this.tourInclusion = JSON.parse(JSON.stringify(this.tourInclusion)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))}).reverse();
						}
				}else if(this.datatype == "property"){
						if(this.dealdata.propertysort == true){
								this.dealdata.propertysort = false;
						}else if(this.dealdata.propertysort == false){
								this.dealdata.propertysort = true;
						}
						if(this.dealdata.propertysort == true){
								this.properties = JSON.parse(JSON.stringify(this.properties)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))});
						}else if(this.dealdata.propertysort == false){
								this.properties = JSON.parse(JSON.stringify(this.properties)).sort(function(p1, p2){return ((p1.order != null ? p1.order : Infinity) - (p2.order != null ? p2.order : Infinity))}).reverse();
						}

				}


		}
		dealpreiview(event){

				console.log("substr:- "+ this.dealdata.dealname.substr(7,10));
				var url = 'https://www.tripadeal.com.au/deals/'+ this.dealdata.dealname.substr(7,10); // get from processing apex response
				console.log("URL:->> "+ url);
				window.open(url, "_blank");


		}

		feildvaluechange(event){
				this.value = event.target.value;
				const fieldname = event.target.getAttribute("data-id");
				console.log('fieldname:- '+ fieldname);

				//importantinfoAU, importantinfoNZ, summaryAU, summaryNZ
				//dealdata

				if(fieldname =='impinfoAU'){
						this.dealdata.importantinfoAU = 	this.value;

				}else if(fieldname == 'impinfoNZ'){
						this.dealdata.importantinfoNZ = 	this.value;

				}else if (fieldname == 'summaryAU'){
						this.dealdata.summaryAU = 	this.value;

				}else if(fieldname == 'summaryNZ'){
						this.dealdata.summaryNZ = 	this.value;
				}

				console.log('DealData:- '+ JSON.stringify(this.dealdata));
		}

		handleAddRow(event){
				const evtname = event.target.getAttribute("data-id");
				const i = event.target.getAttribute("data-id1");
				console.log("evtname>>"+  evtname);
				if(evtname =="tour" ){	
						this.temptour = Object.assign({}, this.tourInclusion[i] ) ;
						if(this.temptour.order ===undefined){
								this.temptour.order = null;
								this.tourInclusion[i].order = null;
						}
						console.log("this.temptour.order after>>>:- "+ JSON.stringify(this.temptour.order) + "  <<<< this.tourInclusion[i].order >>>>> :-  "+ JSON.stringify(this.tourInclusion[i].order));
						this.temptour.isclone = true;
						this.temptour.toUpdateorInsert = true;
						console.log("this.temptour:- "+ JSON.stringify(this.temptour));
						this.tourInclusion.push(this.temptour);
				}else if(evtname =="property"){
						this.tempprperty = Object.assign({}, this.properties[i] ) ;
						if(this.tempprperty.order ===undefined){
								this.tempprperty.order = null;
								this.properties[i].order = null;
						}
						this.tempprperty.isclone = true;
						this.tempprperty.toUpdateorInsert = true;
						console.log("this.tempprperty:- "+ JSON.stringify(this.tempprperty));
						this.properties.push(this.tempprperty);
				}else if(evtname =="Attach"){
						if(this.listOfAttachInclusions[i].isPublishInclusionSelected == 'None-Selected'){
								this.itinload = false;
								const evt = new ShowToastEvent({
										title: 'Error occurred',
										message: 'Publish Inclusion is not selected. Please select an option or remove the search term.' ,
										variant: 'error',
										duration:' 50000',
								});
								this.dispatchEvent(evt);
						}else{
								this.tempAttach = Object.assign({}, this.listOfAttachInclusions[i] ) ;
								this.tempAttach.isclone = true;
								this.tempAttach.isRecordBlank = false;
								this.tempAttach.toUpdateorInsert = true;
								console.log("this.tempprperty:- "+ JSON.stringify(this.tempAttach));
								this.listOfAttachInclusions.push(this.tempAttach);
						}
				}
		}

		finalizedDeal(event){
				const roleName = event.target.getAttribute("data-id");
				this.itinload = true;	
				console.log("rolename:"+ roleName);
				saveDealHistory({dealId: this.recordId , AnalystOrBDM: roleName } )
						.then(res=>{
						const evt = new ShowToastEvent({
								title: 'Success',
								message:  roleName + ' deal copy saved successfully' ,
								variant: 'success',
								duration:' 50000',});
						this.dispatchEvent(evt);
						window.location.reload();
				}).catch(err=>{
						const evt = new ShowToastEvent({
								title: 'Error Occured',
								message:  JSON.stringify(err) ,
								variant: 'error',
								duration:' 50000',});
						this.dispatchEvent(evt);
				})

		}

		showDealLoockup(event){
				this.showDealLoockupPopup = true;
		}

		async ShowAlertPopup(event){
				await LightningAlert.open({
						message: 'Please populate the field "Flight Book By" on this deal to proceed further ',
						theme: 'warning', // a red theme intended for error states
						label: 'You Can not Proceed', // this is the header text
				});
		}

		handelcheckItinToDelete(event){
				// itineriesToDeleteByDeletAll = [];  selectedcounttoDelete
				console.log('Enter to handelcheckItinToDelete event  :-  '+ event.target.checked);
				// const element = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				console.log('type:-'+ i);
				console.log('parent index:-'+j);
				if(event.target.checked === true){
						this.iteneraries[j].check = true;
						for(var k=0; k< this.iteneraries[j].itinorderlist.length; k++ ){
								this.iteneraries[j].itinorderlist[k].check = true;
								console.warn("this.iteneraries[j].itinorderlist[k].check: - "+ JSON.stringify(this.iteneraries[j].itinorderlist[k].check));
						}
				}else if(event.target.checked === false){
						this.iteneraries[j].check = false;
						for(var k=0; k< this.iteneraries[j].itinorderlist.length; k++ ){
								this.iteneraries[j].itinorderlist[k].check = false;
								console.warn("this.iteneraries[j].itinorderlist[k].check: - "+ JSON.stringify(this.iteneraries[j].itinorderlist[k].check));
						}
				}

				if(j == (this.iteneraries.length - 1)){
						if(event.target.checked === true){
								this.selectedItenararies = [];
								for(var k=0; k<this.iteneraries[j].itinorderlist.length;k++){
										this.iteneraries[j].itinorderlist[k].selectedcount = this.selectedItenararies.length;
										this.selectedItenararies.push({id:this.iteneraries[j].itinorderlist[k].id,
																									 day:this.iteneraries[j].itinorderlist[k].day , 
																									 title:this.iteneraries[j].itinorderlist[k].title , 
																									 description:this.iteneraries[j].itinorderlist[k].description ,
																									 accommodation:this.iteneraries[j].itinorderlist[k].accommodation , 
																									 body:this.iteneraries[j].itinorderlist[k].body ,
																									 order:this.iteneraries[j].itinorderlist[k].order ,
																									 selectedmeals:this.iteneraries[j].itinorderlist[k].selectedmeals , 
																									 check:this.iteneraries[j].itinorderlist[k].check,
																									 country:this.iteneraries[j].itinorderlist[k].country,
																									 transfers:this.iteneraries[j].itinorderlist[k].transfers,
																									 selectedcount:this.iteneraries[j].itinorderlist[k].selectedcount,
																									 isBlank: false
																									});
										console.warn('this.selectedItenararies'+ JSON.stringify(this.selectedItenararies));
								}
								if(this.iteneraries.length < 10){
										this.iteneraries[j].showclone = true;		
								}

						} else if(event.target.checked === false){
								this.selectedItenararies = [];
								this.iteneraries[j].showclone = false;
								console.warn('this.selectedItenararies'+ JSON.stringify(this.selectedItenararies));
						}

				}	

		}

		async handelDeleteItinerary(event){
				this.itinload = true;				
				console.log('Enter to handelDeleteItinerary event  :-  '+ event.target.checked);
				// const element = event.target.getAttribute('data-id');
				const i = event.target.getAttribute('data-id1');
				const j = event.target.getAttribute('data-id2');
				let checkSelectedOrNot = false;
				for (var k=0; k<this.iteneraries.length; k++){
						for(var m=0;m<this.iteneraries[k].itinorderlist.length; m++){
								if((this.iteneraries[k].itinorderlist[m].check == true)  ){
										checkSelectedOrNot = true;
								}
						}
				}

				if(checkSelectedOrNot){
						const result = await LightningConfirm.open({
								message: 'Click on "OK" to confirm ',
								theme: "warning", //success , warning, error, info
								variant: "default",
								label: 'Selecting all the days will automatically delete this Itinerary. Do you confirm?',
								// setting theme would have no effect
						});	

						if(result){

								for (var k=0; k<this.iteneraries.length; k++){
										for(var m=0;m<this.iteneraries[k].itinorderlist.length; m++){
												if((this.iteneraries[k].itinorderlist[m].check == true) && (this.iteneraries[k].itinorderlist[m].isclone == false) ){
														console.info("this.iteneraries[k].itinorderlist[m].isclone:-- "+ JSON.stringify(this.iteneraries[k].itinorderlist[m].isclone));
														this.itineriesToDeleteByDeletAll.push({id: this.iteneraries[k].itinorderlist[m].id});
														console.info("this.itineriesToDeleteByDeletAll:-- "+ JSON.stringify(this.itineriesToDeleteByDeletAll));
												}
										}
								}

								this.itineriesToDelete = this.itineriesToDelete.concat(this.itineriesToDeleteByDeletAll); 
								console.log("this.itineriesToDelete 1452 :- " + JSON.stringify(this.itineriesToDelete));

								SaveIteneries({itenerariesOrderWrap : null , dealId : this.recordId , iteneraryDataToDelete : this.itineriesToDelete}).
								then(res=>{ 
										console.log("delete All Itineraries response:- " + JSON.stringify(res) );
										this.iteneraries = [];
										this.event1 = 	setTimeout(() => {
												this.getDealData();
										}, 50);
								}).catch(err=>{
										console.error("Error Occured while delete All Itineraries:- " + JSON.stringify(err));
								});
								
						}else if(!result){
								this.itinload = false;	
						}

				}else if(!checkSelectedOrNot){

						const evt = new ShowToastEvent({
								title: "Please select the itinerary days you would like to delete",
								message: '' ,
								variant: 'warning',
						});
						this.dispatchEvent(evt);
						this.itinload = false;		
				}
		}

		addBlankItinerary(event){				
				const i = event.target.getAttribute('data-id');
				const j = event.target.getAttribute('data-id2');
				const daynumber = parseInt(this.iteneraries[j].itinorderlist.length + 1);

				const blankitin = {
						isclone:true,
						day:daynumber,
						isBlank:false,
						toUpdateorInsert:true
				}		
				this.iteneraries[j].itinorderlist.push(blankitin);
				console.log("this.iteneraries[j].itinorderlist :- " +JSON.stringify(this.iteneraries[j].itinorderlist));
		}

}