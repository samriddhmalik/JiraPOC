import { LightningElement, wire, api, track } from "lwc";
import downloadFiles from "@salesforce/apex/MP_DownloadDepartureDateFiles.downloadFile";

export default class DownloadDepartureDateFiles extends LightningElement {
  FileData;
  @track bIsFileDataEmpty = false;
  @api departureID;
  @api dealID;

  connectedCallback() {
    console.log("LWC called");
    console.log("departureID= " + this.departureID);
    downloadFiles({ departureDateID: this.departureID, dealID: this.dealID })
      .then((result) => {
        console.log("filedata=" + JSON.stringify(result));
        this.FileData = result;
        console.log("File Length =" + this.FileData.length);
        if (this.FileData.length == 0) {
          this.bIsFileDataEmpty = true;
        } else {
          this.bIsFileDataEmpty = false;
        }
      })
      .catch((error) => {
        this.error = error;
        this.data = undefined;
        console.log("download error=" + JSON.stringify(error));
      });
  }
}