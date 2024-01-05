import { LightningElement, wire, api, track } from "lwc";
import totalPaxTravellingDetails from "@salesforce/apex/MP_TotalPaxTravellingVsDepartureDate.totalPaxTravellingDetails";
//import totalPaxTravellingDetails from  '@salesforce/apex/MP_SalesReportController.fetchOrderData';
export default class MP_TotalPaxTravellingBasedonDepartureDate extends LightningElement {
  chartConfiguartion;

  @api CardTitle;
  totalpax = 0;

  currentPage = 1;
  totalRecords;
  totalPage = 0;

  responseTotalData = [];
  responseDepartureData = [];
  @track limit = 10;
  @track offset = 0;
  @wire(totalPaxTravellingDetails, { dealId: "$CardTitle" })
  totalPaxTravellingDetails({ error, data }) {
    if (error) {
      alert("hello");
      console.log("error-9->" + JSON.stringify(error));
      this.error = error;
      this.chartConfiguartion = undefined;
    } else if (data) {
      this.totalRecords = data;
      console.log("Line--17--deal-->" + this.CardTitle);
      console.log("Data-->" + JSON.stringify(data));
      this.limit = Number(this.limit);
      this.totalPage = Math.ceil(data.length / this.limit);
      let totalPaxTravelling = [];
      let departureDate = [];

      this.responseTotalData = [];
      this.responseDepartureData = [];

      data.forEach((pax) => {
        console.log("Line--21->" + pax);
        totalPaxTravelling.push(pax.Qty);
        departureDate.push(pax.deptdate);
        this.responseTotalData.push(pax.Qty);
        this.responseDepartureData.push(pax.deptdate);
      });
      console.log("Line--28-totalPaxTravelling->" + totalPaxTravelling);

      totalPaxTravelling.push(0);
      console.log("Line--23-Updated to 32->" + totalPaxTravelling);
      console.log("offset :", this.offset);
      console.log("limit :", this.limit);
      this.generateMap();
      this.error = undefined;
    }
  }

  get disablePrevious() {
    return this.currentPage <= 1;
  }
  get disableNext() {
    return this.currentPage >= this.totalPage;
  }

  previousHandler() {
    if (this.currentPage > 1) {
      this.currentPage = this.currentPage - 1;
      this.offset = this.offset - this.limit;
      this.generateMap();
    }
  }

  nextHandler() {
    if (this.currentPage < this.totalPage) {
      this.currentPage = this.currentPage + 1;
      this.offset = this.offset + this.limit;
      this.generateMap();
    }
  }

  generateMap() {
    let paginatedTotalPaxTravelling = [];
    let paginatedDepartureDate = [];

    for (let i = this.offset; i < this.currentPage * this.limit; i++) {
      if (this.responseDepartureData[i] != null) {
        paginatedTotalPaxTravelling.push(this.responseTotalData[i]);
        paginatedDepartureDate.push(this.responseDepartureData[i]);
      }
    }

    this.chartConfiguartion = {
      type: "horizontalBar",
      //plugins: [this.ChartDataLabels],
      data: {
        datasets: [
          {
            label: "Sum of PAX Travelling",
            backgroundColor: "blue",
            data: paginatedTotalPaxTravelling
          }
        ],
        labels: paginatedDepartureDate
      },

      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          datalabels: {
            clamp: true,
            color: "black",
            labels: {
              title: {
                font: {
                  weight: "bold"
                }
              }
            }
          }
        },

        scales: {
          x: {
            beginAtZero: true
          },

          xAxes: [
            {
              ticks: {
                beginAtZero: true,
                autoskip: false,
                fontSize: 10
              }
            }
          ],

          /* y: {
           beginAtZero: true
          },*/

          yAxes: [
            {
              scaleLabel: {
                fontSize: 10,
                display: true,
                labelString: "Departure Date"
              },
              ticks: {
                // beginAtZero: false,
                fontSize: 10
              }
            }
          ]
        },
        events: ["mouseout", "touchstart", "touchmove", "touchend"]
      }
    };
  }
}