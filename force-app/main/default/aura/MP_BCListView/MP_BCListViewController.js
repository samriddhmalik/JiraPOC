({
    doInit: function (component, event, helper) {  
       // helper.fetchOrders(component, helper);
        helper.fetchOrders1(component, helper);
    },
    
    handleMenuSelect : function (component, event, helper) {

        var selectedMenu = event.detail.menuItem.get("v.value");
        console.log( 'Selected button is ' + selectedMenu );
        if(selectedMenu == 'Export as CSV'){
            console.log( 'Selected button is--97->' + selectedMenu );
            helper.updateFlightManifest(component, helper);
        }
        else{
             console.log( 'Selected button is--100->' + selectedMenu );
              helper.updateFlightManifestXls(component, helper);
        }
},
    
    onDealChange: function (component, event, helper) {
        console.log("Entered In Deal");
        component.set("v.depPreviousName", null);
    
        component.set("v.startDateName", "All Start Dates");
        
        var dealdata = component.find("dealPicklist").get("v.value");
        var depdata = component.find("departurePicklist").get("v.value");
        console.log('Line-52->'+depdata);
        component.set("v.isDepartureDateFetched", false);
        console.log('Line57'+dealdata);
        if (dealdata == "All Deals" || dealdata == undefined) {
            console.log('line--59-->'+component.find("dealPicklist").get("v.value"))
            component.set("v.dealName", "All Deals");
            component.set("v.depName", "All Departure Dates");
            component.set("v.startDateName", "All Start Dates");
            component.find("startdatepicklist").set("v.value") == "choose one...";
            component.set("v.startdateDataList", []);
            component.set("v.depDateList", []);
             component.set("v.depDateListonDealChange", []);
              component.set("v.AckFalse",true);
            helper.fetchOrders(component, helper);
            component.set("v.isDealSelected", false);
        } else {
            console.log('line--71-->'+component.find("dealPicklist").get("v.value"))
            component.set("v.isDeptDateSelected",false);
             component.set("v.OndealfetchBC",true);
             component.set("v.AckFalse",true);
             component.set("v.IntialDealId",null);
           var check = component.find("SelectAll");
            console.log('Line--74-->'+check);
            var checkbox = check.set("v.value",false);
             console.log('Line--76-->'+checkbox);
            component.find("departurePicklist").set("v.value") ==
                "All Departure Dates";
            var deptId = component.get("v.ddIds");
            var action = component.get("c.fetchDeparture");
            action.setParams({
                dealId: component.find("dealPicklist").get("v.value"),
                ddId: deptId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('Line--72-->'+state);
                
                if (state === "SUCCESS") {
                    var responseVal = response.getReturnValue();
                    let res = [];
                    let check = {};
                    console.log('Line--77-->'+JSON.stringify(responseVal));
                    for (let i = 0; i < responseVal.length; i++) {
                        if (!check[responseVal[i]["Name"]]) {
                            console.log("-listOfTags--->" + responseVal[i]["Name"]);
                            check[responseVal[i]["Name"]] = true;
                            res.push(responseVal[i]);
                        }
                    }
                    console.log('Line--87-->'+res)
                    
                    component.set("v.depDateListonDealChange", res);
                    console.log('Line--90-->'+ component.get("v.depDateListonDealChange"));
                    
                    component.set("v.showDeparture", true);
                    component.set("v.depName", "All Departure Dates");
                    component.set("v.startDateName", "All Start Dates");
                    component.set("v.isDealSelected", true);
                }
                component.find("startdatepicklist").set("v.value") == "choose one...";
                helper.fetchSelectedDealData(component, helper);
                
                //helper.fetchOrders(component, helper);
                helper.fetchBCRecords(component, helper);
                helper.fetchStartDate(component, helper);
            });
        }
        
        $A.enqueueAction(action);
    },
    
    onDepartureDateChange: function (component, event, helper) {
        component.set("v.departureIDtoLWC", "");
        component.set("v.isDepartureDateFetched", false);
        component.set("v.startDateName", "All Start Dates");
        component.find("startdatepicklist").set("v.value") == "choose one...";
        component.set("v.showBc", true);  
        component.set("v.onDeptSelectionSorting", true);
        helper.fetchBCDepartureRecords(component,event,helper);
    },
    
    onStartDateChange: function (component, event, helper) {
        var Startdate = component.find("startdatepicklist").get("v.value");
        var depdate = component.find("departurePicklist").get("v.value");
        var dealdata = component.find("dealPicklist").get("v.value");
        console.log('Line--138-->'+Startdate);
         console.log('Line--139-->'+depdate);
        var currentDataList = component.get("v.allData");
        console.log('Line--140-->'+JSON.stringify(currentDataList));
        var currentstartDataList = [];
        
        if (
          
            Startdate == "All Start Dates" ||
            Startdate == undefined ||
            Startdate == ""
        )
        {
            
            console.log("Inside--184 If");
            for (var i = 0; i < currentDataList.length; i++) {
                if (
                    currentDataList[i].DepartureDate ==
                    component.find("departurePicklist").get("v.value") &&
                    currentDataList[i].DealsId ==
                    component.find("dealPicklist").get("v.value")
                ) {
                    console.log(
                        "line--138-->" + JSON.stringify(currentDataList[i].StartDate)
                    );
                     console.log(
                        "line--142-->" + JSON.stringify(component.find("departurePicklist").get("v.value"))
                    );
                    console.log(
                        "line--145-->" + JSON.stringify(currentDataList[i].DepartureDate)
                    );
                    currentstartDataList.push(currentDataList[i]);
                    component.set("v.startDateName", "All Start Dates");
                }
                if (
                    currentDataList[i].DealsId ==
                    component.find("dealPicklist").get("v.value") && (depdate == undefined || depdate == "All Departure Dates")
                ) {
                    console.log(
                        "line--151-->" + JSON.stringify(currentDataList[i].StartDate)
                    );
                     console.log(
                        "line--154-->" + JSON.stringify(currentDataList[i].DepartureDate)
                    );
                    
                      console.log(
                        "line--164-->" + JSON.stringify(component.find("departurePicklist").get("v.value"))
                    );
                    currentstartDataList.push(currentDataList[i]);
                    component.set("v.startDateName", "All Start Dates");
                }
            }
            console.log("currentstartDataList" + JSON.stringify(currentstartDataList));
            console.log("currentstart-171->" + JSON.stringify(currentstartDataList.length));
            console.log("line--173-->" + JSON.stringify(component.find("departurePicklist").get("v.value")));
            console.log("line--174-->" + JSON.stringify(component.find("dealPicklist").get("v.value")));

            //component.set("v.allRecordData", currentstartDataList);
                    helper.fetchBCRecords(component, helper);

        } else {
            for (var i = 0; i < currentDataList.length; i++) {
                 console.log("line184--->" + JSON.stringify(currentDataList[i].StartDate));
                 console.log("line185--->" + JSON.stringify(currentDataList[i].DealsId));
                 console.log("line186--->" + JSON.stringify(component.find("startdatepicklist").get("v.value")));
                 console.log("line187--->" + JSON.stringify(component.find("dealPicklist").get("v.value")));

                if (
                    currentDataList[i].StartDate == component.find("startdatepicklist").get("v.value") && currentDataList[i].DealsId ==
                    (component.find("dealPicklist").get("v.value") || component.get("v.IntialDealId"))
                ) 
                {
                    console.log(
                        "line197--->" + JSON.stringify(currentDataList[i].StartDate)
                    );
                    currentstartDataList.push(currentDataList[i]);
                    component.set("v.startDateName", currentDataList[i].StartDate);
                }
            }
            console.log(
                "currentstartDataList57" + JSON.stringify(currentstartDataList)
            );
            component.set("v.allRecordData", currentstartDataList);
            console.log(
                "all--205-->" + JSON.stringify(component.get("v.allRecordData"))
            );
                    helper.fetchBCRecords(component, helper);
                    component.set("v.onStartDateSelectionSorting", true);

        }
    },
    
    filter: function (component, event, helper) {
        var data = component.get("v.ordList"),
            term = component.get("v.filter"),
            results = data,
            regex;
        try {
            regex = new RegExp(term, "i");
            results = data.filter(
                (row) =>
                regex.test(row.orderId) ||
                regex.test(row.departureDate.toString()) ||
                regex.test(row.firstName.toString()) ||
                regex.test(row.lastName.toString())
            );
        } catch (e) {}
        if (results.length === 0) {
            component.set("v.currentDataSize", "0");
        }
        if ($A.util.isEmpty(component.get("v.filter"))) {
            //   $A.get('e.force:refreshView').fire();
        }
        console.log("results--->" + results);
        component.set("v.ordList", results);
        component.set("v.currentDataSize", results.length);
    },
    
    downloadCsv: function (component, event, helper) {
        var initialdealdata = component.get("v.IntialDealId");
        var dealdata = component.find("dealPicklist").get("v.value");
        var landActivitySet = [];
        console.log("line236--->" + JSON.stringify(dealdata));
        console.log("line239--->" + JSON.stringify(initialdealdata));
        if (dealdata == "All Deals" || dealdata == undefined) {
            var stockData = component.get("v.passengerData");
            var filteredPassengerDataLst = stockData;
            landActivitySet = component.get("v.landActivityKeySet");
            console.log('landActivitySet ='+landActivitySet);
        }
        else if(component.get("v.IntialDealId") !=null){
            var stockData = component.get("v.passengerData");
            landActivitySet = component.get("v.landActivityKeyFilteredSet");
            var filteredPassengerDataLst = [];
            
             console.log("line243--->" + JSON.stringify( component.find("dealPicklist").get("v.value")));
            console.log("line244--->" + JSON.stringify(component.find("departurePicklist").get("v.value")));
            console.log("line245--->" + JSON.stringify(component.find("startdatepicklist").get("v.value")));
            for(var i=0;i<stockData.length;i++){
                   console.log("line276--->" + JSON.stringify(component.get("v.IntialDealId")));
                  console.log("line249--->" + JSON.stringify(stockData[i].dealId));
                  console.log("line250--->" + JSON.stringify(stockData[i].DepartureDate));
                  console.log("line251--->" + JSON.stringify(stockData[i].StartDate));
                if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") == (undefined || "" || '')){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date")){
                  
                    filteredPassengerDataLst.push(stockData[i]);
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == (undefined)){
                     console.log("line264--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate ){
                     console.log("line291--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") ==  stockData[i].StartDate ){
                     console.log("line266--->" + JSON.stringify(stockData[i].StartDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }
                    else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == stockData[i].StartDate){
                         console.log("line270--->" + JSON.stringify(stockData[i].DepartureDate));
                        filteredPassengerDataLst.push(stockData[i]);            
                    }  
                
                
            }  
        }
        
        else {
            var stockData = component.get("v.passengerDataFromBC");
            landActivitySet = component.get("v.landActivityKeyFilteredSet");
            var filteredPassengerDataLst = [];
            
             console.log("line280--->" + JSON.stringify( component.find("dealPicklist").get("v.value")));
            console.log("line281--->" + JSON.stringify(component.find("departurePicklist").get("v.value")));
            console.log("line282--->" + JSON.stringify(component.find("startdatepicklist").get("v.value")));
            for(var i=0;i<stockData.length;i++){
                  console.log("line299--->" + JSON.stringify(stockData[i].dealId));
                  console.log("line300--->" + JSON.stringify(stockData[i].DepartureDate));
                  console.log("line301--->" + JSON.stringify(stockData[i].StartDate));
               if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                } else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                } else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") ==''){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") ==''){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == ""){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date")){
                
                    filteredPassengerDataLst.push(stockData[i]);
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == (undefined)){
                     console.log("line264--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate ){
                     console.log("line291--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") ==  stockData[i].StartDate ){
                     console.log("line266--->" + JSON.stringify(stockData[i].StartDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }
                    else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == stockData[i].StartDate){
                         console.log("line270--->" + JSON.stringify(stockData[i].DepartureDate));
                        filteredPassengerDataLst.push(stockData[i]);            
                    }  
                
                
                
            }  
        }
        
        console.log("ordList295" + JSON.stringify(stockData));
        try{
            var csv = helper.convertArrayOfObjectsToCSV(component, filteredPassengerDataLst,landActivitySet);
            console.log("Download csv" + csv);  
            if (csv == null) {
                return;
            }
            
            var hiddenElement = document.createElement("a");
            hiddenElement.href = "data:text/csv;charset=utf-8,%EF%BB%BF" + encodeURI(csv);
            
            hiddenElement.target = "_self"; //
            hiddenElement.download = "BookingConfirmations.csv"; // CSV file Name* you can change it.[only name not .csv]
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file*/
        }catch(e){
            console.error(e);
        }
        
        
    },
    
    downloadXls: function (component, event, helper) {
       var initialdealdata = component.get("v.IntialDealId");
        var dealdata = component.find("dealPicklist").get("v.value");
        console.log("line339--->" + JSON.stringify(dealdata));
         console.log("line340--->" + JSON.stringify(initialdealdata));
        if (dealdata == "All Deals" || dealdata == undefined) {
            var stockData = component.get("v.passengerData");
            var filteredPassengerDataLst = stockData;
            
        }
        
        else if(component.get("v.IntialDealId") !=null){
            var stockData = component.get("v.passengerData");
            //landActivitySet = component.get("v.landActivityKeyFilteredSet");
            var filteredPassengerDataLst = [];
            
             console.log("line352--->" + JSON.stringify( component.find("dealPicklist").get("v.value")));
            console.log("line353--->" + JSON.stringify(component.find("departurePicklist").get("v.value")));
            console.log("line354--->" + JSON.stringify(component.find("startdatepicklist").get("v.value")));
            for(var i=0;i<stockData.length;i++){
                  console.log("line356--->" + JSON.stringify(stockData[i].dealId));
                  console.log("line357--->" + JSON.stringify(stockData[i].DepartureDate));
                  console.log("line358--->" + JSON.stringify(stockData[i].StartDate));
                if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") == (undefined || "" || '')){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date")){
                   
                    filteredPassengerDataLst.push(stockData[i]);
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == undefined ){
                     console.log("line264--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate ){
                     console.log("line291--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") ==  stockData[i].StartDate ){
                     console.log("line266--->" + JSON.stringify(stockData[i].StartDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }
                    else if(stockData[i].dealId == component.get("v.IntialDealId") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == stockData[i].StartDate){
                         console.log("line270--->" + JSON.stringify(stockData[i].DepartureDate));
                        filteredPassengerDataLst.push(stockData[i]);            
                    }  
                
                
            }  
        }
        
else {
            var stockData = component.get("v.passengerDataFromBC");
            console.log('Line--294-->'+JSON.stringify(stockData));
            var filteredPassengerDataLst = [];
            
            for(var i=0;i<stockData.length;i++){
              
                 console.log("line390--->" + component.find("dealPicklist").get("v.value"));
            console.log("line391--->" + JSON.stringify(component.find("departurePicklist").get("v.value")));
            console.log("line392--->" + JSON.stringify(component.find("startdatepicklist").get("v.value")));
                 console.log("line393--->" + stockData[i].dealId );
                if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                } else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                } else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == "All Departure Date" && component.find("startdatepicklist").get("v.value") ==''){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == undefined){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") ==''){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == undefined && component.find("startdatepicklist").get("v.value") == ""){
                    console.log('25 ='+ component.find("departurePicklist").get("v.value"));
                    
                    filteredPassengerDataLst.push(stockData[i]);                               
                }
                else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date")){
                   
                    filteredPassengerDataLst.push(stockData[i]);
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == (undefined)){
                     console.log("line264--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate ){
                     console.log("line291--->" + JSON.stringify(stockData[i].DepartureDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == (undefined || "All Departure Date") && component.find("startdatepicklist").get("v.value") ==  stockData[i].StartDate ){
                     console.log("line266--->" + JSON.stringify(stockData[i].StartDate));
                    filteredPassengerDataLst.push(stockData[i]);            
                }
                    else if(stockData[i].dealId == component.find("dealPicklist").get("v.value") &&  component.find("departurePicklist").get("v.value") == stockData[i].DepartureDate && component.find("startdatepicklist").get("v.value") == stockData[i].StartDate){
                         console.log("line270--->" + JSON.stringify(stockData[i].DepartureDate));
                        filteredPassengerDataLst.push(stockData[i]);            
                    }  
                
                
                
                
            }
        }
        
        var xls = helper.convertArrayOfObjectsToXLS(component, filteredPassengerDataLst);
        console.log("line---168--->" + xls);
        if (xls == null) {
            return;
        }
        
            
        try{
            var xlsJSON = helper.convertCsvOrXlsToJSON(component,xls,"\t");
            console.log('xlsJSON ='+xlsJSON);
            var data = JSON.parse(JSON.stringify(xlsJSON));
            console.table(data);
            
            var filename = "BookingConfirmations.xls";
            var ws_name = "sheet1";
            
            if (typeof console !== 'undefined') console.log(new Date());
           var wb = XLSX.utils.book_new(),
                ws = XLSX.utils.json_to_sheet(data);
            
            XLSX.utils.book_append_sheet(wb, ws, ws_name);
            if (typeof console !== 'undefined') console.log(new Date());
            XLSX.writeFile(wb, filename);
            if (typeof console !== 'undefined') console.log(new Date());   
         
        }catch(e){
            console.error(e);
        } 
        
       /* var hiddenElement = document.createElement("a");
        console.log("line---173--->" + hiddenElement);
        //hiddenElement.href = 'data:application/vnd.ms-excel'  + escape(xls);
        hiddenElement.href = 'data:application/vnd.ms-excel;charset=utf-8' + ',' + encodeURIComponent(xls);
        hiddenElement.target = "_self"; //
        hiddenElement.download = "BookingConfirmations.xls"; // CSV file Name* you can change it.[only name not .csv]
        hiddenElement.style = "border: 1.5pt";
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download xls file*/
    },
    
    handleAcknowledge: function (component, event, helper) {
        console.log("inside ack");
        var dealdata;
        var checkbc = component.get("v.OndealfetchBC");
        var ackDataCheck = component.get("v.AckFalse");
        var check = component.find("SelectAll");
      
        console.log("Line443 "+ackDataCheck);
         if (ackDataCheck == true) {
         
               dealdata = component.find("dealPicklist").get("v.value");
         } else {
             dealdata = component.get("v.IntialDealId");
         }
      
        
        console.log("line455--->" + JSON.stringify(dealdata));
          console.log("line456--->" + JSON.stringify(dealdata));
        if (dealdata == "All Deals" || dealdata == undefined) {
          
            var fullData = component.get("v.allData");
        } else if(dealdata != "All Deals" && checkbc == false){
            var fullData = component.get("v.allData");
        }
        else{
                var fullData = component.get("v.allRecordData");
                
            }
        
        console.log("fullData" + JSON.stringify(fullData));
        var tadorderId = [];
        var dealId = [];
        for (var i = 0; i < fullData.length; i++) {
            console.log("inside loop");
            if (fullData[i].isChecked == true) {
                console.log("inside if");
                console.log("line197--->" + JSON.stringify(fullData[i].isChecked));
                tadorderId.push(fullData[i].OrderId);
                dealId.push(fullData[i].DealsId);
                console.log("Line 271" + tadorderId);
                console.log("Line 272" + dealId);
            }
        }
        console.log("Line 355--->" + tadorderId.length);
        if (tadorderId.length > 0 && tadorderId.length == 1) {
            var action = component.get("c.handleAcknowledged");
            action.setParams({
                TADOrderId: tadorderId
            });
            action.setCallback(this, function (response) {
                console.log("test===>286");
                helper.showAcknowledgeToast(
                    component,
                    "Success!",
                    "success",
                    "Order successfully acknowledged!"
                );
                  var checkCmp = check.set("v.value",false);
                if (dealdata == "All Deals" || dealdata == undefined) {
                    helper.fetchOrders(component, helper);
                } else if(dealdata != "All Deals" && checkbc == false){
                    helper.fetchOrders(component, helper);
                } else {
                    helper.fetchBCRecords(component, helper);
                }
            });
            $A.enqueueAction(action);
            //window.location.reload();
        }
        else if (tadorderId.length > 0 && tadorderId.length > 1) {
            var action = component.get("c.handleAcknowledged");
            action.setParams({
                TADOrderId: tadorderId
            });
            action.setCallback(this, function (response) {
                console.log("test===>286");
                helper.showAcknowledgeToast(
                    component,
                    "Success!",
                    "success",
                    "Orders successfully acknowledged!"
                );
                var checkCmp = check.get("v.value");
                if (dealdata == "All Deals" || dealdata == undefined) {
                    helper.fetchOrders(component, helper);
                } else if(dealdata != "All Deals" && checkbc == false){
                    helper.fetchOrders(component, helper);
                } else {
                    helper.fetchBCRecords(component, helper);
                }
            });
            $A.enqueueAction(action);
            //window.location.reload();
        }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: "Please Select Orders Before Acknowledge",
                    duration: " 5000",
                    key: "info_alt",
                    type: "error",
                    mode: "pester"
                });
                toastEvent.fire();
            }
    },
    onCheckRow: function (component, event, helper) {
        var i = event.getSource().get("v.name");
        var getCheckedDatavalue = event.getSource().get("v.value");
    
     
        var dealdata = component.find("dealPicklist").get("v.value");
   
        if (dealdata == "All Deals" || dealdata == undefined) {
          
               var allData = component.get("v.allData");
               
        } else if(dealdata == ''){
              var allData = component.get("v.allData");
             
        } else{
           
             var allData = component.get("v.allRecordData");
           
        }
        
        allData[i].isChecked = true;
        for (j = 0; j < allData.length(); j++) {
            if (i == allData.id) {
                allData[j].isChecked = true;
            }
        }
        console.log('Line655 '+allData[i].isChecked);
        /*
        if (dealdata == "All Deals" || dealdata == undefined) {
            component.set("v.allData", allData);
        } else {
            component.set("v.allallRecordDataData", allData);
        }
        
        console.log("line no 394>>" + JSON.stringify(component.get("v.allData")));
        console.log(
            "line no 395>>" + JSON.stringify(component.get("v.allallRecordDataData"))
        );*/
    },
   
    onNext: function (component, event, helper) {
        component.set("v.defaultRows", []);
        var checkbc = component.get("v.OndealfetchBC");
         var checkdeal = component.get("v.isDealSelected");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        var pageNumber = component.get("v.currentPageNumber");
        console.log("Line--386-->" + pageNumber);
        component.set("v.currentPageNumber", pageNumber + 1);
        console.log(
            "Line--388-->" + component.get("v.currentPageNumber", pageNumber + 1)
        );
        
        var dealdata = component.find("dealPicklist").get("v.value");
        console.log("Line--391-->" + dealdata);
        
        if (dealdata == "All Deals" || dealdata == undefined) {
            console.log("Line--394-->" + dealdata);
            helper.buildData(component, helper);
        }else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false && checkbcSorting == false){

            helper.buildData(component, helper);
        }
        else {
                console.log("Line--399-->" + dealdata);
                helper.buildallData(component, helper);
            }
        component.set("v.filter", []);
    },
    
    onPrev: function (component, event, helper) {
        component.set("v.defaultRows", []);
        var checkbc = component.get("v.OndealfetchBC");
         var checkdeal = component.get("v.isDealSelected");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        var dealdata = component.find("dealPicklist").get("v.value");
        if (dealdata == "All Deals" || dealdata == undefined) {
            console.log("Line--394-->" + dealdata);
            helper.buildData(component, helper);
        }else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false && checkbcSorting == false){

            helper.buildData(component, helper);
        }
        else {
                console.log("Line--399-->" + dealdata);
                helper.buildallData(component, helper);
            }
        component.set("v.filter", []);
    },
    
    processMe: function (component, event, helper) {
        component.set("v.defaultRows", []);
        component.set("v.currentPageNumber", parseInt(event.target.name));
        var dealdata = component.find("dealPicklist").get("v.value");
        if (dealdata == "All Deals" || dealdata == undefined) {
            helper.buildData(component, helper);
        } else {
            helper.buildallData(component, helper);
        }
    },
    
    onFirst: function (component, event, helper) {
        component.set("v.defaultRows", []);
        var checkbc = component.get("v.OndealfetchBC");
         var checkdeal = component.get("v.isDealSelected");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        component.set("v.currentPageNumber", 1);
        var dealdata = component.find("dealPicklist").get("v.value");
        if (dealdata == "All Deals" || dealdata == undefined) {
            console.log("Line--394-->" + dealdata);
            helper.buildData(component, helper);
        }else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false && checkbcSorting == false){

            helper.buildData(component, helper);
        }
        else {
                console.log("Line--399-->" + dealdata);
                helper.buildallData(component, helper);
            }
        //helper.fetchOrders(component,helper);
        component.set("v.filter", []);
    },
    
    onLast: function (component, event, helper) {
        component.set("v.defaultRows", []);
        var checkbc = component.get("v.OndealfetchBC");
        var checkdeal = component.get("v.isDealSelected");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        var dealdata = component.find("dealPicklist").get("v.value");
        if (dealdata == "All Deals" || dealdata == undefined) {
            console.log("Line--394-->" + dealdata);
            helper.buildData(component, helper);
        }else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false && checkbcSorting == false){

            helper.buildData(component, helper);
        }
        else {
                console.log("Line--399-->" + dealdata);
                helper.buildallData(component, helper);
            }
        component.set("v.filter", []);
    },
    
    onSelectChange: function (component, event, helper) {
        var checkbc = component.get("v.OndealfetchBC");
        var checkdeal = component.get("v.isDealSelected");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        var url = window.location.href;
        console.log("url==> " + url);
        var params = new URL(url).searchParams;
        console.log("params==> " + params);
         console.log("checkdeal==> " + checkdeal);
        var dealName = params.get("dealId");
        var depDate = params.get("ddId");
        if (dealName != null && depDate != null) {
            console.log("Line--482-->" + dealName);
            var Selected = component.find("noOfRec").get("v.value");
            console.log("Selected--->" + Selected);
            if (Selected != "ALL") {
                component.set("v.pageSize", Selected);
            } else {
                component.set("v.pageSize", 10000);
            }
            helper.fetchBCRecords(component, helper);
        } else {
            console.log("line492==> " + params);
            var Selected = component.find("noOfRec").get("v.value");
            if (Selected != "ALL") {
                component.set("v.pageSize", Selected);
            } else {
                component.set("v.pageSize", 10000);
            }
             var dealdata;
              var ackDataCheck = component.get("v.AckFalse");
            console.log("Line443 "+ackDataCheck);
         if (ackDataCheck == true) {
         
               dealdata = component.find("dealPicklist").get("v.value");
         } else {
             dealdata = component.get("v.IntialDealId");
         }
          

        if (dealdata == "All Deals" || dealdata == undefined) {
            helper.currentAllData(component, helper);
        }
         /*else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false){
           
            helper.currentAllData(component, helper);
        }*/
            else if(dealdata != 'All Deals' && checkdeal == true && checkbc == false && checkbcSorting == false){
           
            helper.currentAllData(component, helper);
        }
        else {
                helper.fetchAllData(component, helper);
            }
        }
    },
    
    sortDepartDate: function (component, event, helper) {
        var data = [];
        var checkbc = component.get("v.OndealfetchBC");
        var dealIdIndexZero;
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        var checkbcStartSorting = component.get("v.onStartDateSelectionSorting");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var dealIdDetails = component.find("dealPicklist").get("v.value");
       
        if(dealIdDetails != 'All Deals' && checkbc == false){
            dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
            dealIdIndexZero = dealIdDetails;
        }
        if (dealIdIndexZero == "All Deals" || dealIdIndexZero == undefined || dealIdIndexZero == '') {
            var allData = component.get("v.allData");
        }else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcSorting == false && checkbcStartSorting == false){
            var allData = component.get("v.allData");
        }
        else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcSorting == false && checkbcStartSorting == true){
            var allData = component.get("v.allRecordData");
        }
        else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcSorting == true  && checkbcStartSorting == false){
            var allData = component.get("v.allRecordData");
        }

        else {
               var allData = component.get("v.allRecordData");
            }
        //console.log('allData::'+JSON.stringify(allData));
        //  For Sort the data
        var result = allData;
        console.log("allData::" + JSON.stringify(result));
        var sort = component.get("v.showDepartDate");
        console.log("line no 437" + sort);
        if (sort == 0) {
            console.log("sortggg == 0--->", sort);
            result.sort((a, b) => (a.DepartureDate > b.DepartureDate ? 1 : -1));
            console.log("allDataresult if::" + JSON.stringify(result));
            component.set("v.showDepartDate", 1);
        } else {
            console.log("sortgv == --->", sort);
            result.sort((a, b) => (a.DepartureDate < a.DepartureDate ? 1 : -1));
            console.log("allDataresult else::" + JSON.stringify(result));
            component.set("v.showDepartDate", 0);
        }
        
        
        console.log("allDatasort::" + JSON.stringify(result));
        var x = (pageNumber - 1) * pageSize;
        
        //creating data-table data
        for (; x < pageNumber * pageSize; x++) {
            if (result[x]) {
                data.push(result[x]);
            }
        }
        // console.log('data::'+data);
        component.set("v.currentDataSize", data.length);
        
        component.set("v.ordList", data);
    },
    
    
    sortstartDate: function (component, event, helper) {
        var data = [];
        var checkbc = component.get("v.OndealfetchBC");
        var dealIdIndexZero;
        var checkbcStartSorting = component.get("v.onStartDateSelectionSorting");
        var checkbcSorting = component.get("v.onDeptSelectionSorting");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var dealIdDetails = component.find("dealPicklist").get("v.value");
        
        if(dealIdDetails != 'All Deals' && checkbc == false){
            dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
            dealIdIndexZero = dealIdDetails;
        }
        if (dealIdIndexZero == "All Deals" || dealIdIndexZero == undefined || dealIdIndexZero == '') {
        }
        else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcStartSorting == false && checkbcSorting == false){
            var allData = component.get("v.allData");
        }
        else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcStartSorting == true && checkbcSorting == false){
            var allData = component.get("v.allRecordData");
        }
         else if(dealIdIndexZero != 'All Deals' && checkbc == false && checkbcStartSorting == false && checkbcSorting == true){
             var allData = component.get("v.allRecordData");
        }
        else {
            var allData = component.get("v.allRecordData");
         }
        
        //console.log('allData::'+JSON.stringify(allData));
        //  For Sort the data
        var result = allData;
        console.log("allData::" + JSON.stringify(result));
        var sort = component.get("v.showStartDate");
        console.log("line no 437" + sort);
        if (sort == 0) {
            console.log("sortggg == 0--->", sort);
            result.sort((a, b) => (a.StartDate > b.StartDate ? 1 : -1));
            console.log("allDataresult if::" + JSON.stringify(result));
            component.set("v.showStartDate", 1);
        } else {
            console.log("sortgv == --->", sort);
            result.sort((a, b) => (a.StartDate < a.StartDate ? 1 : -1));
            console.log("allDataresult else::" + JSON.stringify(result));
            component.set("v.showStartDate", 0);
        }
       
        console.log("allDatasort::" + JSON.stringify(result));
        var x = (pageNumber - 1) * pageSize;
        
        //creating data-table data
        for (; x < pageNumber * pageSize; x++) {
            if (result[x]) {
                data.push(result[x]);
            }
        }
        // console.log('data::'+data);
        component.set("v.currentDataSize", data.length);
        
        component.set("v.ordList", data);
    },
    
    onCheck1: function (component, event, helper) {
    var allData;
    var checkbc = component.get("v.OndealfetchBC");
    var check = component.find("SelectAll");
    var checkCmp = check.get("v.value");
    console.log("Line--793-->"+checkCmp);
        console.log("Line--907-->"+checkbc);
    var dealdata = component.find("dealPicklist").get("v.value");
    console.log("Line--795-->"+dealdata);
    console.log("Line--910-->"+JSON.stringify(component.get("v.allRecordData")));
    if (checkCmp == true) {
        var filtered = component.get("v.ordList");
        console.log("xyzzvghvv");
        
        console.log("filtered===802==>" + JSON.stringify(filtered));
            console.log("filtered===803==>" + JSON.stringify(filtered.length));
        for (var i = 0; i < filtered.length; i++) {
            if (filtered[i].colorCode === false) {
                filtered[i].isChecked = true;
            }
        }
        component.set("v.ordList", filtered);
        
        
        if (dealdata == "All Deals" || dealdata == undefined) {
            allData = component.get("v.allData");
        } 
        else if(dealdata != "All Deals" && checkbc == false){
            allData = component.get("v.allData");
        }
        else if(dealdata != "All Deals" && checkbc == true){
            allData = component.get("v.allRecordData");
        }
        else{
            allData = component.get("v.allData");  
            }
        
        for (var i = 0; i < allData.length; i++) {
            console.log('Line--939-->'+allData[i].colorCode);
            if (allData[i].colorCode != true) {
                console.log('Line--Inside-->');
                allData[i].isChecked = true;
            }
        }
        
        if (dealdata == "All Deals" || dealdata == undefined) {
            component.set("v.allData", allData);
        } else {
            component.set("v.allRecordData", allData);
        }
    }
    if (checkCmp == false) {
        var filtered = component.get("v.ordList");
        console.log("xyzzvghvv");
        
        console.log("filtered===833==>" + JSON.stringify(filtered));
        
        for (var i = 0; i < filtered.length; i++) {
            filtered[i].isChecked = false;
        }
        
        component.set("v.ordList", filtered);
        
        if (dealdata == "All Deals" || dealdata == undefined) {
            allData = component.get("v.allData");
        } 
        else if(dealdata != "All Deals" && checkbc == false){
            allData = component.get("v.allRecordData");
        }
            else{
                allData = component.get("v.allData");  
            }
        
        for (var i = 0; i < allData.length; i++) {
            allData[i].isChecked = false;
        }
        if (dealdata == "All Deals" || dealdata == undefined) {
            component.set("v.allData", allData);
        } else {
            component.set("v.allRecordData", allData);
        }
    }
   },
    
    NavigateToCase: function (component, event, helper) {
        component.set("v.callLWC", true);
    },
    
    closeLWCModal: function (component, event, helper) {
        component.set("v.callLWC", false);
    },
    
    PerformAction: function (component, event, helper) {
        var rowIndex = event.getSource().get("v.name");
        component.set("v.passid", rowIndex);
        console.log("rowIndex25 " + rowIndex);
        
        helper.getRequest(component, event);
        component.set("v.openmodel", true);
    },
    closeModal: function (component, event, helper) {
        var cmpTarget = component.find("editDialog");
        var cmpBack = component.find("overlay");
        $A.util.removeClass(cmpBack, "slds-backdrop--open");
        $A.util.removeClass(cmpTarget, "slds-fade-in-open");
        component.set("v.openmodel", false);
    },
    
    NavigateToInfoFromLogistic: function (component, event, helper) {
        var tadOrderId = event.getSource().get("v.name");
        console.log("rowIndex25 " + tadOrderId);
        var action = component.get("c.getInfoLogisticData");
        action.setParams({
            TadOrderId: tadOrderId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result588 " + JSON.stringify(result));
                component.set("v.InfoList", result);
            }
        });
        $A.enqueueAction(action);
        
        component.set("v.InfoFromLogistic", true);
    },
    CloseInfoFromLogistic: function (component, event, helper) {
        component.set("v.InfoFromLogistic", false);
    },
    openFlightManifest: function (component, event, helper) {
        console.log("Line--573");
        var tadorderId = event.getSource().get("v.name");
        console.log("Line--575-----" + tadorderId);
        var dealId = event.getSource().get("v.value");
        console.log("Line--577--->>>-" + dealId);
        var action = component.get("c.getFlightData");
        action.setParams({
            //"TadOrderId": tadorderId,
            DealId: dealId,
            PassID: tadorderId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result588 " + JSON.stringify(result));
                component.set("v.FlightList", result);
                console.log("Result701" + JSON.stringify(result.Arrival_Airport_code));
                console.log("Result702" + JSON.stringify(result.DealArrivalAirport));
            }
        });
        $A.enqueueAction(action);
        
        component.set("v.openFlightManifest", true);
    },
    closeFlightManifest: function (component, event, helper) {
        component.set("v.openFlightManifest", false);
    },
    
    openTripCase: function (component, event, helper) {
        var tadOrderId = event.getSource().get("v.name");
        console.log("Trip--->" + tadOrderId);
        var action = component.get("c.getTripCaseData");
        action.setParams({
            TadOrderId: tadOrderId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result--TripList-->" + JSON.stringify(result));
                component.set("v.TripList", result);
            }
        });
        $A.enqueueAction(action);
        component.set("v.OpenTripCase", true);
    },
    
    closeTripCase: function (component, event, helper) {
        component.set("v.OpenTripCase", false);
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