import { LightningElement, track, wire } from "lwc";
import retrievePassengerData from "@salesforce/apex/MP_OrderCancellationController.fetchOrderCancellationData";

export default class MP_OrderCancellationData extends LightningElement {
  passengerData;
  orderCancellationInfo;

  connectedCallback() {
    var urlParameters = window.location.href;
    var urlOrderParameters = urlParameters.split("tad-order/");
    var splitOrder = urlOrderParameters[1].split("/");
    var orderNumber = splitOrder[0];
    console.log("orderNumber =" + orderNumber);
    retrievePassengerData({ tadOrder: orderNumber })
      .then((result) => {
        console.log("RESPONSE =" + JSON.stringify(result));
        this.passengerData = result.passengerWrapperList;
        if (result.info.OrderInfo.includes("Has Cancellation")) {
          this.orderCancellationInfo = "Has Cancellation";
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.data = undefined;
      });
  }
}