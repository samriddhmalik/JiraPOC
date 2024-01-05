({
  doInit: function (component, event, helper) {
    component.set("v.bccolumns", [
      {
        label: "Order Number",
        fieldName: "orderId",
        type: "url",
        initialWidth: 200,
        sortable: true,
        typeAttributes: { label: { fieldName: "orderName" }, target: "_blank" }
      },
      {
        label: "Order Line Item",
        fieldName: "orderLineItem",
        type: "text",
        sortable: true
      },
      {
        label: "Purchaser Account",
        fieldName: "purchaserAccount",
        type: "text",
        sortable: true
      },
      {
        label: "Sub Options Purchased",
        fieldName: "subOptionPurchased",
        type: "text",
        sortable: true
      },
      {
        label: "Option Purchased",
        fieldName: "optionPurchased",
        type: "text",
        sortable: true
      },
      { label: "Pax Qty", fieldName: "paxQty", type: "text", sortable: true },
      {
        label: "Room Required",
        fieldName: "roomRequire",
        type: "number",
        sortable: true,
        cellAttributes: { alignment: "left" }
      },
      {
        label: "Room Configuration",
        fieldName: "roomConfig",
        type: "text",
        sortable: true
      }
    ]);

    console.log("In Table");



    //helper.fetchOrders(component, helper);
    //added below lines by @Ritu Nagi
    //component.set("v.IscomponentPicklist", false);
    //component.set("v.IsShowcomponentlist", true);
    //helper.fetchTourDepartureDates(component);    
    //helper.fetchDepartureDates(component);
    //helper.fetchOrderData(component, helper);  
    //helper.fetchSelectedDealData(component, helper);
    //helper.fetchDealandDepartureDates(component, helper);
  },

  getData: function (component, event, helper) {  	   
    component.set("v.dealName", "All Deals");
    component.set("v.depName", "All Start Date");
    component.set("v.tourDeptName", "All Tour Departure Dates");
    var url = window.location.href;
    console.log("url==> " + url);
    var params = new URL(url).searchParams;
    console.log("params==> " + params);
    var dealName = params.get("dealId");
    var depDate = params.get("departureDateId");
    console.log("dealName---->" + dealName);
    console.log("depDate---->" + depDate);
    if (dealName != null && depDate != null) {
      component.set("v.dealPreviousName", dealName);
      component.set("v.depPreviousName", depDate);
      helper.fetchDealPrevious(component, helper);
      helper.selectedDepartureDates(component, helper);
      helper.previousFetchOrders(component, helper);
    }
	helper.fetchDeals(component, helper);

    //helper.fetchDepartureDates(component);
    //helper.fetchSubOptions(component);
    var a = component.get("c.doInit");
    $A.enqueueAction(a);
  },

  filter: function (component, event, helper) {
    var data = component.get("v.ordList"),
      term = component.get("v.filter"),
      results = data,
      regex;
    try {
      regex = new RegExp(term, "i");
      // filter checks each row, constructs new array where function returns true
      results = data.filter(
        (row) =>
          regex.test(row.dealName) ||
          regex.test(row.departureDateName) ||
          regex.test(row.orderName) ||
          regex.test(row.optionPurchased) ||
          regex.test(row.purchaserAccount) ||
          regex.test(row.subOptionPurchased) ||
          regex.test(row.ComponentName)
      );
    } catch (e) {}

    console.log("result is 71" + regex);
    console.log("result is 72" + JSON.stringify(results));
    component.set("v.filteredList", results);
    component.set("v.dealIdTitle", dealName);
    /*component.set(
      "v.selectedDeal",
      component.find("dealPicklist").get("v.value")
    );*/
    component.set("v.selectedDeal",component.get("v.selectedDealByDefault"));
    var filteredList = component.get("v.filteredList");
    component.set("v.currentDataSize", filteredList.length);
    console.log("Line--72" + filteredList);
  },

  sortDepDate: function (component, event, helper) {
    var data = [];
    var pageNumber = component.get("v.currentPageNumber");
    console.log("pageNumber::" + pageNumber);
    var pageSize = component.get("v.pageSize");
    console.log("pageSize::" + pageSize);
    var allData = component.get("v.allData");
    //console.log('allData::'+JSON.stringify(allData));
    //  For Sort the data
    var result = allData;
    var sort = component.get("v.showDeptDate");
    if (sort == 0) {
      console.log("sortggg == 0--->", sort);
      result.sort((a, b) =>
        a.component[0].StartDate > b.component[0].StartDate ? 1 : -1
      );
      console.log("allDataresult if::" + JSON.stringify(result));
      component.set("v.showDeptDate", 1);
    } else {
      console.log("sortgv == --->", sort);
      result.sort((a, b) =>
        a.component[0].StartDate < a.component[0].StartDate ? 1 : -1
      );
      console.log("allDataresult else::" + JSON.stringify(result));
      component.set("v.showDeptDate", 0);
    }
    component.set("v.allData", result);
    console.log("allDatasort::" + JSON.stringify(result));
    var x = (pageNumber - 1) * pageSize;

    //creating data-table data
    for (; x < pageNumber * pageSize; x++) {
      if (result[x]) {
        data.push(result[x]);
      }
    }

    component.set("v.currentDataSize", data.length);

    component.set("v.ordList", data);
  },

  getDeparture: function (component, event, helper) {
    component.set("v.depPreviousName", null);
    component.set("v.depName", "All Start Dates");
    component.set("v.tourDeptName", "All Tour Departure Dates");
    console.log("getDeptDateAndFetchOrder");
    component.find("departurePicklist").set("v.value") == "choose one...";

    component.find("ComponentNamePicklist").set("v.value") == "";
    component.find("tourDepartureDatePicklist").set("v.value") == "";
    if(component.find("dealPicklist").get("v.value") == 'All Deals'){
      component.set("v.selectedDealByDefault",null);
      component.set("v.IscomponentPicklist", true);
      component.set("v.dealName", "All Deals");
      component.set("v.depName", "All Start Dates");
      component.set("v.tourDeptName", "All Tour Departure Dates");
      component.set("v.dealName", "All Deals");
      component.set("v.IsShowcomponentlist", false);
      component.set("v.dealtitle", "");
      
      
      component.set("v.LandActivityNameList", []);
      component.set("v.LandNameList", []);
      component.set("v.LandTourNameList", []);
      component.set("v.FlightNameList", []);
      component.set("v.CruiseNameList", []);
      component.set("v.RailNameList", []);
      component.set("v.TotalPackageNameList", []);
      component.set("v.AccomNameList", []);
      component.set("v.TransferNameList", []);
      component.set("v.AENameList", []);
      component.set("v.SBNameList", []);
      component.set("v.StopOverNameList", []);
      component.set("v.FlightUpgradeNameList", []);
      component.set("v.DepartureCitySurchargeNameList", []);
      component.set("v.AEAccommodationNameList", []);
      component.set("v.SBAccommodationNameList", []);
      component.set("v.DayTourNameList", []);
      component.set("v.tourDeptDateList", []);
      component.set("v.depDateList",[]);
      component.set("v.LandActivityInfoList", []);
      component.set("v.LandNameInfoList", []);
      component.set("v.LandTourInfoList", []);
      component.set("v.FlightInfoList", []);
      component.set("v.CruiseInfoList", []);
      component.set("v.RailInfoList", []);
      component.set("v.TotalPackageInfoList", []);
      component.set("v.AccomInfoList", []);
      component.set("v.TransferInfoList", []);
      component.set("v.AEInfoList", []);
      component.set("v.SBInfoList", []);
      component.set("v.StopOverInfoList", []);
      component.set("v.FlightUpgradeInfoList", []);
      component.set("v.DepartureCitySurchargeInfoList", []);
      component.set("v.AEAccommodationInfoList", []);
      component.set("v.SBAccommodationInfoList", []);
      component.set("v.DayTourInfoList", []);    
    helper.fetchOrderData(component, helper);
    //helper.fetchDealandDepartureDates(component, helper);
  }else{  
      component.set("v.selectedDealByDefault",component.find("dealPicklist").get("v.value"));
      /*setTimeout(function () {
          var a = component.get("c.doInit");
          $A.enqueueAction(a);
          
      }, 500);*/
      
      component.set("v.IscomponentPicklist", false);
      component.set("v.IsShowcomponentlist", true);
      helper.fetchTourDepartureDates(component);    
      helper.fetchDepartureDates(component);
      
      helper.fetchOrderData(component, helper);   
      helper.fetchSelectedDealData(component, helper);
      helper.fetchDealandDepartureDates(component, helper);
  }
  },

  updateColumnSorting: function (component, event, helper) {
    var fieldName = event.getParam("fieldName");
    var sortDirection = event.getParam("sortDirection");
    component.set("v.sortedBy", fieldName);
    component.set("v.sortedDirection", sortDirection);
    helper.sortData(component, fieldName, sortDirection);
  },
  getOrderList: function (component, event, helper) {
    component.find("ComponentNamePicklist").set("v.value") == "";

    helper.fetchOrderData(component);

    $A.enqueueAction(a);
  },

  getTourDeptDate: function (component, event, helper) {
    component.find("departurePicklist").set("v.value") == "choose one...";

    component.find("ComponentNamePicklist").set("v.value") == "";
    
    helper.fetchOrderData(component, helper);
    helper.fetchTourDepartureDates(component);
    helper.fetchDepartureDates(component);

    $A.enqueueAction(a);
  },

  getComponentNameList: function (component, event, helper) {
    component.set("v.IscomponentPicklist", true);

    helper.fetchOrderData(component, helper);
  },

  downloadCsv: function (component, event, helper) {
    var stockData = component.get("v.allData");
    var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
    if (csv == null) {
      return;
    }

    var hiddenElement = document.createElement("a");
    hiddenElement.href = "data:text/csv;charset=utf-8,%EF%BB%BF" + encodeURI(csv);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "SalesReportData.csv"; // CSV file Name* you can change it.[only name not .csv]
    document.body.appendChild(hiddenElement); // Required for FireFox browser
    hiddenElement.click(); // using click() js function to download csv file
  },

  downloadXls: function (component, event, helper) {
    var stockData = component.get("v.allData");
    console.log("line---161--->" + stockData);

    var xls = helper.convertArrayOfObjectsToXLS(component, stockData);
    console.log("line---168--->" + xls);
    if (xls == null) {
      return;
    }

    var hiddenElement = document.createElement("a");
    console.log("line---173--->" + hiddenElement);

    hiddenElement.href = "data:application/vnd.ms-excel," + escape(xls);
    hiddenElement.target = "_self"; //
    hiddenElement.download = "SalesReportData.xls"; // CSV file Name* you can change it.[only name not .csv]
    hiddenElement.style = "border: 1.5pt";
    document.body.appendChild(hiddenElement); // Required for FireFox browser
    hiddenElement.click(); // using click() js function to download xls file
  },

  onNext: function (component, event, helper) {
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber + 1);
    helper.buildData(component, helper);
  },

  onPrev: function (component, event, helper) {
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber - 1);
    helper.buildData(component, helper);
  },

  processMe: function (component, event, helper) {
    component.set("v.currentPageNumber", parseInt(event.target.name));
    helper.buildData(component, helper);
  },

  onFirst: function (component, event, helper) {
    component.set("v.currentPageNumber", 1);
    helper.buildData(component, helper);
  },

  onLast: function (component, event, helper) {
    component.set("v.currentPageNumber", component.get("v.totalPages"));
    helper.buildData(component, helper);
  },

  onSelectChange: function (component, event, helper) {
    var url = window.location.href;
    console.log("url==> " + url);
    var params = new URL(url).searchParams;
    console.log("params==> " + params);
    var dealName = params.get("dealId");
    var depDate = params.get("departureDateId");
    console.log('line350  '+(component.find("dealPicklist").get("v.value"))); 
    if (dealName != null && depDate != null) {
      
      var Selected = component.find("noOfRec").get("v.value");
      if (Selected != "ALL") {
        component.set("v.pageSize", Selected);
      } else {
        component.set("v.pageSize", 10000);
      }
      //helper.fetchOrderData(component, helper);
      helper.currentAllData(component, helper);

    } else {
      var Selected = component.find("noOfRec").get("v.value");
      if (Selected != "ALL") {
        component.set("v.pageSize", Selected);
      } else {
        component.set("v.pageSize", 10000);
      }

      helper.currentAllData(component,helper);
      //helper.fetchOrderData(component, helper);
    }
  },

  NavigateToCase: function (component, event, helper) {
    component.set("v.callLWC", true);
  },

  closeLWCModal: function (component, event, helper) {
    component.set("v.callLWC", false);
  },
  openModel: function(component, event, helper) {
    // Set isModalOpen attribute to true
    component.set("v.isModalOpen", true);
 },

 closeModel: function(component, event, helper) {
    // Set isModalOpen attribute to false  
    component.set("v.isModalOpen", false);
location.reload()
 }
});