import { LightningElement, api } from "lwc";
import chartjs from "@salesforce/resourceUrl/chartJsResource";
import ChartDataLabels from "@salesforce/resourceUrl/ChartPlugins";
import { loadScript } from "lightning/platformResourceLoader";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class Gen_barchart extends LightningElement {
  @api loaderVariant = "base";
  isChartJsInitialized;
  chartConfig_;

  @api
  get chartConfig() {
    return this.chartConfig_;
  }
  set chartConfig(value) {
    this.chartConfig_ = value;
    this.loadingChart();
  }

  loadingChart() {
    // load static resources.
    console.log("Loading Chart JS");
    Promise.all([loadScript(this, chartjs), loadScript(this, ChartDataLabels)])
      .then(() => {
        this.isChartJsInitialized = true;
        const ctx = this.template
          .querySelector("canvas.barChart")
          .getContext("2d");
        Chart.plugins.register(ChartDataLabels);
        this.chart = new window.Chart(
          ctx,
          JSON.parse(JSON.stringify(this.chartConfig_))
        );
        this.chart.canvas.parentNode.style.height = "300px";
        this.chart.canvas.parentNode.style.width = "100%";
      })
      .catch((error) => {
        console.log("Line--26-->" + error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading ChartJS",
            message: error.message,
            variant: "error"
          })
        );
      });
  }
}