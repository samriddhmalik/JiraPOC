import { LightningElement, track, wire } from 'lwc';
import retriveCase from '@salesforce/apex/TAD_CaseForFinance.getCaseRecord';
import { NavigationMixin } from "lightning/navigation";


export default class CaseListView extends NavigationMixin (LightningElement) {
		@track showrecord = false;
		@track caseNumber;
		@track searchName;
		@track records;
		@track dataNotFound;
		@track showtable = false;
		@track recordIdToShow;

		handleChangeCaseNumber(event) {
				this.caseNumber = event.target.value;
				console.log('Insisde handleChangeCaseNumber');
				console.log('this.caseNumber:-  ' + this.caseNumber);



		}

		handleCaseSearch() {
				console.log('Insisde handleCaseSearch');
				retriveCase({ caseNumber: this.caseNumber }).then(res => {

						this.records = res;

						if (this.records != null) {
								this.showtable = true;
						} else {
								this.showtable = false;
						}
						console.log('records:- ' + JSON.stringify(this.records));
						console.log('res:- ' + JSON.stringify(res));
						console.log('this.showtable:-  ' + this.showtable);

				}).catch(err => {
						this.showtable = false;
						this.dataNotFound = '';
						this.dataNotFound = 'There is no Case Record found related to Case Number';
						console.log('error:- '+ JSON.stringify(err));
				})
		}

		openCaseRecord(event) {
				
				let i = event.target.getAttribute('data-id');
				console.log('i:- '+ i);
				console.log('this.records[i]:- '+ this.records[i]);
				this.recordIdToShow = this.records[i].id;
				console.log('recordIdToShow:- ' + this.recordIdToShow);
				this.showrecord = true;

				//this.dispatchEvent(this.navigateToRecordPage(event));
		}

		navigateToRecordPage(event) {
				this[NavigationMixin.Navigate]({
						type: 'standard__recordPage',
						attributes: {
								recordId: this.recordIdToShow,
								objectApiName: 'Case',
								actionName: 'view'
						}
				});
		}

}