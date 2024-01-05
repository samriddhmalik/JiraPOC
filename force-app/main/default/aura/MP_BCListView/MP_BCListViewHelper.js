({
    fetchOrders1: function (component, helper) {
          var action = component.get("c.fetchDealDataOnLoad");
          component.set("v.Spinner", true);

          action.setCallback(this, function (response) {
            console.log("Enter");
            var state = response.getState();
            console.log("state-78->" + state);
              if (state === "SUCCESS") {
                
                var records = response.getReturnValue();
                var dealId;
                 for(var i=0 ; i <= records.DealName.length; i++){
                    
                     dealId = records.DealName[1].Id; 
                      
                  }
                console.log('Line17  '+dealId); 
                component.set("v.IntialDealId",dealId);
                component.set("v.dealList",records.DealName);
                component.set("v.depDateList",records.DepDateName);
                component.set("v.startdateDataList",records.StartDate);  
                component.set("v.isDeptDateSelected",true);
                component.set("v.isDealSelected", true);
                
                this.fetchOrders(component, helper);
                //this.fetchBCRecords(component, helper);  
                this.fetchSelectedDealData(component, helper);
 
              }
               console.log("line511--->" + JSON.stringify(records));
                           
                           
                           });
                 $A.enqueueAction(action);  
        
                           
    },
                         
    fetchOrders: function (component, helper) {
        var action = component.get("c.fetchBC");

        var deptdate = component.find("departurePicklist").get("v.value");
        var dealId = [];
        var ddId = [];
        var dealIdIndexZero ;
        var departureDate = component.find("departurePicklist").get("v.value");
        var dealIdDetails = component.find("dealPicklist").get("v.value");
        var startDateDetails = component.find("startdatepicklist").get("v.value");
        var checkbc = component.get("v.OndealfetchBC");
        var fulldatasize;
        var allDealsModal = false;
        if (departureDate == "All Departure Date") {
            component.set("v.depName", "All Departure Dates");
        }
        if (departureDate == undefined) {
            departureDate = "All Departure Dates";
            console.log("Line--43");
        }
         console.log("Line--20"+dealIdDetails);
        if (dealIdDetails == "All Deals" || dealIdDetails == undefined) {
            component.set("v.Spinner", true);
            dealIdDetails = "All Deals";
            console.log("Line--47");
        }
        console.log('line--274-->'+checkbc);
        
         if(dealIdDetails != 'All Deals' && checkbc == false){
         dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
         dealIdIndexZero = dealIdDetails;
        }
        console.log('Line51'+JSON.stringify(dealIdIndexZero));
        action.setParams({
            deal: dealIdIndexZero,
            depDate: departureDate,
           //startDate: startDateDetails
        });
        
        /*var depDetatils = component.get("v.depDateList");
        console.log("line31--->" + JSON.stringify(depDetatils));
        for (var i = 0; i < depDetatils.length; i++) {
            if (
                depDetatils[i].Id == component.find("departurePicklist").get("v.value")
            ) {
                console.log("line50--->" + JSON.stringify(depDetatils[i].Id));
                component.set("v.depName", depDetatils[i].Name);
                break;
            }
        }*/
        action.setCallback(this, function (response) {
            console.log("Enter");
            var state = response.getState();
            console.log("state-78->" + state);
            if (state === "SUCCESS") {
                console.log("Success--80->");
                var records = response.getReturnValue();
                
                console.log("DATA SIZE-records->" + records.length);
                console.log("Line---87......" + JSON.stringify(records));
                                
                //component.set("v.filteredList", '');
                if (records.length == 0) {
                    helper.showToastWhenNoDeals(component, helper);
                    helper.buildData(component, helper);
                }
               
                if(records.HideFlightManifestData == 'Yes'){
                    console.log('Line--110-->'+records.HideFlightManifestData);
                    component.set("v.HideFlightManifest", true);
                }
                if(records.HideFlightManifestData == 'No'){
                      component.set("v.HideFlightManifest", false);
                }
                
                 console.log('Line--117-->'+component.get("v.HideFlightManifest"));
                component.set("v.allData", records.tadOrderWrapper);
                fulldatasize = component.get("v.allData");
                console.log('Line--111--->'+fulldatasize.length);
                if(dealIdDetails == "All Deals"){
                    console.log('Line--113-->'+dealIdDetails);
                    if(fulldatasize.length >1500){
                        allDealsModal = true;
                        component.set("v.isModalOpen",true);
                          component.set("v.Spinner", false);
                    }
                    }
               

                component.set("v.passengerData", records.passengerdata);
                component.set("v.landActivityKeySet",records.landActivitySet);
                console.log('LANDACTIVITY = '+component.get('v.landActivityKeySet'));
                var passenger = component.get("v.passengerData");
                console.log('Line--63-->'+JSON.stringify(passenger));
                
                //  component.set("v.allData", records);
                if(allDealsModal == false){
                component.set("v.ordList", records);
                helper.buildData(component, helper);
                var checkack = component.get("v.allData");
                for (var i = 0; i < checkack.length; i++) {
                    if (checkack[i].colorCode == false || checkack[i].colorCode == undefined || checkack[i].colorCode == null) {
                            component.set("v.enableButton", true);
                            break;
                        }
                        if(checkack[i].colorCode == true){
                         component.set("v.enableButton", false);

                        }
                    console.log("line no 95-->" + checkack[i].DealsId);
                    var ddeal = checkack[i].DealsId;
                    dealId.push(ddeal);
                    ddId.push(checkack[i].DepartureDate);
                    if (checkack[i].SendMerchantConfirmationemail == true) {
                        console.log("hide ack----@@");
                        component.set("v.SendMerchantEmailConfirmation", true);
                        var datachk = component.get("v.SendMerchantEmailConfirmation");
                        console.log("datachk----@@" + datachk);
                    }
                    if (checkack[i].SendMerchantConfirmationemailNot == true) {
                        console.log("hide ack----@@");
                        component.set("v.SendMerchantConfirmationemailNot", true);
                        var datachk = component.get("v.SendMerchantConfirmationemailNot");
                        console.log("datachk----@@" + datachk);
                    }
                }
                component.set("v.CurrentData", records);
               // component.set("v.ordList", records);
                var lengthdata = component.get("v.ordList");
                console.log("DATA SIZE-->" + JSON.stringify(lengthdata));
                component.set("v.Spinner", false);
                
                console.log("delIds" + checkack[0].dealIds);
                console.log("deptsIds" + checkack[0].deptsIds);
                if (checkack[0].dealIds != null) {
                    component.set("v.dealIds", checkack[0].dealIds);
                } else {
                    component.set("v.dealIds", dealId);
                }
                
                if (checkack[0].deptsIds != null) {
                    component.set("v.ddIds", checkack[0].deptsIds);
                } else {
                    component.set("v.ddIds", ddId);
                }
                
                //component.set("v.ddIds", ddId);
                
                console.log("dealIds=> " + component.get("v.dealIds"));
                helper.currentAllData(component, helper);
               // helper.buildData(component, helper);
               // helper.fetchdeal(component, helper);
                component.set("v.showBc", true);
            }
        }else {
                console.log("Line--119-->" + records);
                if (records == "" || records == undefined) {
                    helper.buildData(component, helper);
                    component.set("v.showBc", true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSelectedDealData: function (component, helper) {
        var dealIdIndexZero ;
        var checkbc = component.get("v.OndealfetchBC");
        var selectedDealID = component.find("dealPicklist").get("v.value");
        if(selectedDealID != 'All Deals' && checkbc == false){
         dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
         dealIdIndexZero = selectedDealID;
        }
        var action = component.get("c.getSelectedDealData");
       
        action.setParams({ dealId: dealIdIndexZero });
        action.setCallback(this, function (response) {
            console.log("Line 7:" + JSON.stringify(response.getReturnValue()));
            var records = response.getReturnValue();
            console.log('Line--188-->'+JSON.stringify(records));
             console.log('Line--189-->'+JSON.stringify(dealIdIndexZero));
            for (var i = 0; i < records.length; i++) {
                if (dealIdIndexZero == records[i].Id) {
                    component.set("v.dealIdTitle", records[i].Deal_ID_Title__c);
                    component.set("v.dealPDFUrl", records[i].pdf__c);
                    console.log("Deal PDF =" + component.get("v.dealPDFUrl"));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchdeal: function (component, helper) {
        var url = window.location.href;
        console.log("url==> " + url);
        var params = new URL(url).searchParams;
        console.log("params==> " + params);
        var dealName = params.get("dealId");
        var depDate = params.get("ddId");
        var dealId1 = component.get("v.dealIds");
        console.log("dealId=> " + dealId1);
        console.log("params=dealName=> " + dealName);
        console.log("params=depDate=> " + depDate);
        if (dealName != null && depDate != null) {
            component.set("v.dealPreviousName", dealName);
            component.set("v.depPreviousName", depDate);
            
            helper.selectedDepartureDates(component, helper);
        }
        
        var depId = window.location.href.split("/").pop().split("=")[2];
        if (depId) {
            var a = component.get("c.onDepartureDateChange");
            $A.enqueueAction(a);
        } else {
            var action = component.get("c.fetchDeals");
            action.setParams({
                dealId: dealId1
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log("Line151==" + state);
                if (state === "SUCCESS") {
                    console.log("here in dealList");
                    var rslt = response.getReturnValue();
                    console.log("line171" + response.getReturnValue());
                    console.log("Line172==" + JSON.stringify(response.getReturnValue()));
                    component.set("v.dealList", response.getReturnValue());
                    if (response.getReturnValue() == "") {
                        helper.showToastWhenNoDeals(
                            "No Booking Confirmation Available!",
                            "No Booking Confirmation Available",
                            "No Booking Confirmation Available"
                        );
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
        //component.set("v.showBc",true);
        // helper.fetchOrders(component,helper);
        component.set("v.depName", "All Departure Dates");
        component.set("v.startDateName", "All Start Dates");
        component.set("v.dealName", "All Deals");
        component.set("v.dealtitle", "");
    },
    
    currentAllData: function (component, helper) {
        var fulldata = component.get("v.allData");
       
        component.set("v.ordList", fulldata);
        var deal = component.find("dealPicklist").get("v.value");
        console.log('departureDate ='+deal);
        console.log("ordList ****105***" + component.get("v.ordList"));
        component.set("v.dataSize", fulldata.length);
        console.log("datasize-->" + component.get("v.dataSize"));
        console.log("pageSize-214->" + component.get("v.pageSize"));
        component.set(
            "v.totalPages",
            Math.ceil(fulldata.length / component.get("v.pageSize"))
        );
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
        
        console.log(
            "datasize-106->" +
            component.get(
                "v.totalPages",
                Math.ceil(fulldata.length / component.get("v.pageSize"))
            )
        );
    },
    
    fetchBCRecords: function (component, helper) {
        var departureDate = component.find("departurePicklist").get("v.value");
        var dealIdDetails = component.find("dealPicklist").get("v.value");
        var startDateDetails = component.find("startdatepicklist").get("v.value");
        var dealIdIndexZero;
        var checkbc = component.get("v.OndealfetchBC");
        console.log('line--274-->'+checkbc);
        
         if(dealIdDetails != 'All Deals' && checkbc == false){
         dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
         dealIdIndexZero = dealIdDetails;
        }
       
        console.log("dealIdDetails--205->" + dealIdDetails);
        console.log("departureDate--206->" + departureDate);
        console.log("startDateDetails--207->" + startDateDetails);
        component.set("v.Spinner", true);
        var action = component.get("c.fetchBC");
        if(startDateDetails=='' ||startDateDetails==null){
        
        action.setParams({
            deal: dealIdIndexZero,
            dateId: departureDate,
            //startDate: startDateDetails
        });
        }
        else{
             action.setParams({
            deal: dealIdIndexZero,
            dateId: departureDate,
            startDate: startDateDetails
        });
        }
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("Line217==" + state);
            if (state === "SUCCESS") {
                console.log("here in dealList");
                var rslt = response.getReturnValue();
                console.log("line221" + response.getReturnValue());
                console.log("Line222==" + JSON.stringify(response.getReturnValue()));
                //component.set("v.dealList", response.getReturnValue());
                if (response.getReturnValue() == "") {
                    helper.showToastWhenNoDeals(
                        "No Booking Confirmation Available!",
                        "No Booking Confirmation Available",
                        "No Booking Confirmation Available"
                    );
                    
                    if(rslt.HideFlightManifestData == 'Yes'){
                        console.log('Line--108-->'+records.HideFlightManifestData);
                        component.set("v.HideFlightManifest", true);
                    }
                    if(rslt.HideFlightManifestData == 'No'){
                        component.set("v.HideFlightManifest", false);
                    }
                } else {
                    console.log(
                        "Line--231==" + JSON.stringify(response.getReturnValue())
                    );
                    component.set("v.allRecordData", rslt.tadOrderWrapper);
                    component.set("v.ordList", rslt.tadOrderWrapper);
                    component.set("v.FetchCurrentData", rslt.tadOrderWrapper);
                    component.set("v.landActivityKeyFilteredSet",rslt.landActivitySet);
                    component.set("v.passengerDataFromBC", rslt.passengerdata);
                    component.set("v.Spinner", false);
                    
                    var checkack = component.get("v.allRecordData");
                    for (var i = 0; i < checkack.length; i++) {
                        console.log('Line--375-->'+checkack[i].colorCode);
                        if (checkack[i].colorCode == false || checkack[i].colorCode == undefined) {
                            component.set("v.enableButton", true);
                            break;
                        }
                        if(checkack[i].colorCode == true){
                         component.set("v.enableButton", false);

                        }
                    }
                    
                    if(rslt.HideFlightManifestData == 'Yes'){
                        component.set("v.HideFlightManifest", true);
                    }
                    if(rslt.HideFlightManifestData == 'No'){
                        component.set("v.HideFlightManifest", false);
                    }
                    helper.fetchAllData(component, helper);
                    
                }
            }
            console.log("Line--231-->" + component.get("v.allRecordData"));
              console.log("Line--272-->" + JSON.stringify(component.get("v.passengerDataFromBC")));
        });
        
        $A.enqueueAction(action);
    },
    
    
    fetchBCDepartureRecords: function (component,event,helper) {
        var dealIdIndexZero;
        var checkbc = component.get("v.OndealfetchBC");
        var departureDate = component.find("departurePicklist").get("v.value");
        var dealIdDetails = component.find("dealPicklist").get("v.value");
        var startDateDetails = component.find("startdatepicklist").get("v.value");
        component.set("v.Spinner", true);
        if(dealIdDetails != 'All Deals' && checkbc == false){
            dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
            dealIdIndexZero = dealIdDetails;
        }
        var action = component.get("c.fetchBC");
        action.setParams({deal: dealIdIndexZero,dateId: departureDate,startDate: startDateDetails});
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rslt = response.getReturnValue();
                console.log("ORDER DATA" + JSON.stringify(response.getReturnValue()));
                if (response.getReturnValue() == "") {
                    helper.showToastWhenNoDeals(
                        "No Booking Confirmation Available!",
                        "No Booking Confirmation Available",
                        "No Booking Confirmation Available"
                    );
                    
                    if(rslt.HideFlightManifestData == 'Yes'){
                        console.log('Line--444-->'+rslt.HideFlightManifestData);
                        component.set("v.HideFlightManifest", true);
                    }
                    if(rslt.HideFlightManifestData == 'No'){
                        component.set("v.HideFlightManifest", false);
                    }
                } else {                    
                    component.set("v.Spinner", false);
                    var depdate = component.find("departurePicklist").get("v.value");
                    console.log('depdate ='+ rslt.tadOrderWrapper);
                    component.set("v.passengerDataFromBC", rslt.passengerdata);                   
                    component.set("v.landActivityKeyFilteredSet",rslt.landActivitySet);
                    if(rslt.tadOrderWrapper.length > 0){
                        if (depdate == "All Departure Date" || depdate == undefined) { 
                            console.log('hii');
                            component.set("v.ordList",rslt.tadOrderWrapper);
                            component.set("v.allRecordData", rslt.tadOrderWrapper);
                            component.set("v.depName", "All Departure Dates");
                            component.set("v.startDateName", "All Start Dates");
                            component.find("startdatepicklist").set("v.value") == "choose one...";
                            var checkack = component.get("v.allRecordData");
                            for (var i = 0; i < checkack.length; i++) {
                                console.log('Line--375-->'+checkack[i].colorCode);
                                if (checkack[i].colorCode == false || checkack[i].colorCode == undefined) {
                                    component.set("v.enableButton", true);
                                    break;
                                }
                                if(checkack[i].colorCode == true){
                                    component.set("v.enableButton", false);
                                    
                                }
                            }
                            if(rslt.HideFlightManifestData == 'Yes'){
                                console.log('Line--464-->'+rslt.HideFlightManifestData);
                                component.set("v.HideFlightManifest", true);
                            }
                            if(rslt.HideFlightManifestData == 'No'){
                                component.set("v.HideFlightManifest", false);
                            }
                            helper.fetchStartDate(component, helper);
                        } else {
                            var currentDeptDateList = rslt.tadOrderWrapper;
                            var currentDeptDataList = [];
                            for (var i = 0; i < currentDeptDateList.length; i++) {
                                if (currentDeptDateList[i].DepartureDate == depdate) {
                                    currentDeptDataList.push(currentDeptDateList[i]);
                                }
                            }
                            component.set("v.depName", currentDeptDataList[0].DepartureDate);
                            component.set("v.departureIDtoLWC",currentDeptDataList[0].DepartureDate);
                            component.set("v.dealIDtoLWC", currentDeptDataList[0].DealsId);
                            component.set("v.isDepartureDateFetched", true); 
                            component.set("v.ordList",currentDeptDataList);
                            component.set("v.allRecordData", currentDeptDataList);
                            component.find("startdatepicklist").set("v.value") == "choose one...";
                            var checkack = component.get("v.allRecordData");
                            for (var i = 0; i < checkack.length; i++) {
                                console.log('Line--375-->'+checkack[i].colorCode);
                                if (checkack[i].colorCode == false || checkack[i].colorCode == undefined) {
                                    component.set("v.enableButton", true);
                                    break;
                                }
                                if(checkack[i].colorCode == true){
                                    component.set("v.enableButton", false);
                                    
                                }
                            }
                            if(rslt.HideFlightManifestData == 'Yes'){
                                component.set("v.HideFlightManifest", true);
                            }
                            if(rslt.HideFlightManifestData == 'No'){
                                component.set("v.HideFlightManifest", false);
                            }
                            helper.fetchStartDate(component, helper);
                            
                        }
                        
                    }
                    else{
                        component.set("v.ordList",rslt.tadOrderWrapper);
                        component.set("v.allRecordData", rslt.tadOrderWrapper);
                        var checkack = component.get("v.allRecordData");
                        for (var i = 0; i < checkack.length; i++) {
                            console.log('Line--375-->'+checkack[i].colorCode);
                            if (checkack[i].colorCode == false || checkack[i].colorCode == undefined) {
                                component.set("v.enableButton", true);
                                break;
                            }
                            if(checkack[i].colorCode == true){
                                component.set("v.enableButton", false);
                                
                            }
                        }
                        if(rslt.HideFlightManifestData == 'Yes'){
                            component.set("v.HideFlightManifest", true);
                        }
                        if(rslt.HideFlightManifestData == 'No'){
                            component.set("v.HideFlightManifest", false);
                        }
                        helper.showToastWhenNoOrders(component,event,helper);
                    }
                    helper.fetchAllData(component, helper);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    fetchStartDate: function (component) {
        console.log("here in fetchStartDate ");
        console.log("Deal-Id-->" + component.find("dealPicklist").get("v.value"));
        console.log(
            "Dept-Id-->" + component.find("departurePicklist").get("v.value")
        );
        var DealData = component.find("dealPicklist").get("v.value");
        var DeptData = component.find("departurePicklist").get("v.value");
        
        
        var dealIdIndexZero;
        var checkbc = component.get("v.OndealfetchBC");
        var departureDate = component.find("departurePicklist").get("v.value");
        component.set("v.Spinner", true);
        if(DealData != 'All Deals' && checkbc == false){
            dealIdIndexZero = component.get("v.dealList")[1].Id;
        } else{
            dealIdIndexZero = DealData;
        }
        
        
        var tourDeptName;
        var tourDeptdetails = component.get("v.depDateList");
        for (var i = 0; i < tourDeptdetails.length; i++) {
            if (
                tourDeptdetails[i].Id ==
                component.find("departurePicklist").get("v.value")
            ) {
                component.set("v.depName", tourDeptdetails[i].Name);
                tourDeptName = tourDeptdetails[i].Name;
                break;
            }
        }
        console.log("Line--432-->" + DeptData);
          console.log("Line--630-->" + dealIdIndexZero);
        var action = component.get("c.fetchStartDate");
        action.setParams({
            dealId: dealIdIndexZero,
            dateId: DeptData
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                 component.set("v.Spinner", false);
                console.log("response--640--->" + state);
                console.log("response--641--->" + response.getReturnValue());
                var listOfTags = response.getReturnValue();
                let check = {};
                let res = [];
                component.set("v.startdateDataList", listOfTags);
                //component.set("v.depDateList", response.getReturnValue());
             
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchAllData: function (component, helper) {
        var fulldata = component.get("v.allRecordData");
        
        component.set("v.ordList", fulldata);
        console.log("ordList ****105***" + component.get("v.ordList"));
        component.set("v.dataSize", fulldata.length);
        if(fulldata.length == 0){
            component.set("v.disabledAllButtons", true);
            
        }
        else{
            component.set("v.disabledAllButtons", false);
            
        }
        console.log("datasize-->" + component.get("v.dataSize"));
        console.log("pageSize-214->" + component.get("v.pageSize"));
        component.set(
            "v.totalPages",
            Math.ceil(fulldata.length / component.get("v.pageSize"))
        );
        component.set("v.currentPageNumber", 1);
        helper.buildallData(component, helper);
        console.log(
            "datasize-106->" +
            component.get(
                "v.totalPages",
                Math.ceil(fulldata.length / component.get("v.pageSize"))
            )
        );
    },
    
    buildallData: function (component, helper) {
        var checkbc = component.get("v.OndealfetchBC");
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        console.log("pageNumber:---:" + pageNumber);
        var pageSize = component.get("v.pageSize");
        console.log("pageSize:---:" + pageSize);
       
        var allData = component.get("v.allRecordData");

        console.log("allData:--:" + allData);
        /*var x = pageSize;
    console.log("line--285-->" + x);

    for (x=0; x < pageSize; x++) {
         console.log("line--277-->" + x);
      if (allData[x]) {
            console.log("line--279-->" + allData[x]);
        data.push(allData[x]);
      }
    }*/
        
        var x = (pageNumber - 1) * pageSize;
        console.log("line--239-->" + x);
        
        for (; x < pageNumber * pageSize; x++) {
            if (allData[x]) {
                data.push(allData[x]);
            }
        }
        console.log("data:---:" + JSON.stringify(data));
        console.log("data:-284--:" + data.length);
        component.set("v.currentDataSize", data.length);
        //console.log('dataa...'+data);
        component.set("v.ordList", data);
        helper.generatePageList(component, pageNumber);
        component.set("v.filter", []);
    },
    
    buildData: function (component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        console.log("pageNumber::" + pageNumber);
        var pageSize = component.get("v.pageSize");
        console.log("pageSize::" + pageSize);
        var allData = component.get("v.allData");
        console.log("allData::" + allData);
        var x = (pageNumber - 1) * pageSize;
        console.log("line--239-->" + x);
        
        for (; x < pageNumber * pageSize; x++) {
            if (allData[x]) {
                data.push(allData[x]);
            }
        }
        console.log("data::" + data);
        component.set("v.currentDataSize", data.length);
        //console.log('dataa...'+data);
        component.set("v.ordList", data);
        helper.generatePageList(component, pageNumber);
        component.set("v.filter", []);
    },
    
    showAcknowledgeToast: function (component, title, toastType, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: toastType,
            message: message
        });
        toastEvent.fire();
    },
    
    showToastWhenNoDeals: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //mode: 'sticky',
            message: "No Booking Confirmation Available!",
            messageTemplate: "No Booking Confirmation Available!"
        });
        toastEvent.fire();
    },
 
    
    showToastWhenNoOrders: function(component,event,helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: 'No Order found for this departure date!',
            messageTemplate: 'No Order found for this departure date!',
            
        });
        toastEvent.fire();
    },
    
    generatePageList: function (component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        console.log("totalPages::" + totalPages);
        if (totalPages > 1) {
            if (totalPages <= 10) {
                console.log("Inside this");
                var counter = 2;
                for (; counter < totalPages; counter++) {
                    pageList.push(counter);
                }
          
            } else {
                if (pageNumber < 5) {
                    pageList.push(2, 3, 4, 5, 6);
                } else {
                    if (pageNumber > totalPages - 5) {
                        pageList.push(
                            totalPages - 5,
                            totalPages - 4,
                            totalPages - 3,
                            totalPages - 2,
                            totalPages - 1
                        );
                    } else {
                        pageList.push(
                            pageNumber - 2,
                            pageNumber - 1,
                            pageNumber,
                            pageNumber + 1,
                            pageNumber + 2
                        );
                    }
                }
            }
        } else {
            component.set("v.totalPages", 1);
        }
        console.log("pageList::" + pageList);
        component.set("v.pageList", pageList);
    },
    
  
    getRequest: function (component, event) {
        var action = component.get("c.getPopupData");
        action.setParams({
            passId: component.get("v.passid")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result377 " + JSON.stringify(result));
                if (result == null) {
                    component.set("v.isReqEmpty", true);
                    var isEmpValue = component.set("v.isReqEmpty", true);
                    console.log("---isEmpValue--" + component.get("v.isReqEmpty"));
                }
                console.log("result378 " + result.length);
                
                component.set("v.reqList", result);
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords,landActivitySet) {
        var csvStringResult,
            counter,
            keys,
            columnDivider,
            lineDivider,
            keys1,
            keys2,
            keys3,
            keys4, setOfLandActivity;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
       // setOfLandActivity = landActivitySet.toString();
        columnDivider = ",";
        lineDivider = "\n";
        
        keys = [
            "DealNumber",
            "DealName",
            "OrderName",
            "OldOrderNumber",
            "DepartureDate",
            "StartDate",
            "componentType",
            "PAX",
            
            "PurchaserFullName",
            "Emailpurchaser",
            "AccountPhoneNumber",
            "AccountMobileNumber",
            "LinkingOrders",
            "RoomCabin",
            "CruisSubOption",
            
            "Solutation",
            "FirstName",
            "MiddleName",
            "LastName",
            "dob",
            "nationality",
            "passportNumber",
            "passportExpiry",
            "passportIssueDate",
            "countryOfIssue",
            "awaitingNewPassport",
            "Preferred_Bedding",
            "Solo_Travellers",
            "DietaryRequests",
            "MedicalRequests",
            "MobilityRequests",
            "OtherRequests",
            "ArriveEarlys",
            "StayBehinds",
            
            "landActivityCSV",
           // setOfLandActivity,
           "purchaseDate",
             "infofromlogistics",
            "OrdTripcase",
            "OrdTripcase1",
            "OrdTripcase2"
           
        ];
        
        console.log('KEYS ='+keys);
        var keysc1 = keys;
        for (var p = 0; p < keysc1.length; p++) {
            if (keysc1[p] == "DealNumber") keysc1[p] = "Deal";
            if (keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            if (keysc1[p] == "OrderName") keysc1[p] = "Order Number";
            if (keysc1[p] == "OldOrderNumber") keysc1[p] = "Old Order Number";
            if (keysc1[p] == "DepartureDate") keysc1[p] = "Departure Date";
            if (keysc1[p] == "StartDate") keysc1[p] = "Start Date";
            if (keysc1[p] == "componentType") keysc1[p] = "Component type";
            if (keysc1[p] == "PAX") keysc1[p] = "Passengers";
            if (keysc1[p] == "LinkingOrders") keysc1[p] = "Link to Order";
            if (keysc1[p] == "PurchaserFullName") keysc1[p] = "Account name";
            if (keysc1[p] == "Emailpurchaser") keysc1[p] = "E-mail";
            if (keysc1[p] == "AccountPhoneNumber") keysc1[p] = "Phone number";
            if (keysc1[p] == "AccountMobileNumber") keysc1[p] = "Mobile number";
            // if(keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            
            if (keysc1[p] == "RoomCabin") keysc1[p] = "Room/Cabin Required";
            if (keysc1[p] == "CruisSubOption") keysc1[p] = "Cruise/SubOption";
            
            
            if(keysc1[p] == "Solutation") keysc1[p] = "Title";
            if(keysc1[p] == "FirstName") keysc1[p] = "First Name";
            if(keysc1[p] == "MiddleName") keysc1[p] = "Second Name";
            if(keysc1[p] == "LastName") keysc1[p] = "Last Name";
            if (keysc1[p] == "dob") keysc1[p] = "D.O.B";
            if (keysc1[p] == "nationality") keysc1[p] = "Nationality";
            if (keysc1[p] == "passportNumber") keysc1[p] = "Passport Number";
            if (keysc1[p] == "passportExpiry") keysc1[p] = "Passport Expiry Date";
            if (keysc1[p] == "passportIssueDate") keysc1[p] = "Passport Issue Date";
            if (keysc1[p] == "countryOfIssue") keysc1[p] = "Country Of Issue";
            if (keysc1[p] == "awaitingNewPassport")
                keysc1[p] = "Awaiting new passport";
            
            //    if(keysc1[p] == "PostCode") keysc1[p] = "Post Code";
            if (keysc1[p] == "Preferred_Bedding") keysc1[p] = "Preferred Bedding";
            if (keysc1[p] == "Solo_Travellers") keysc1[p] = "Solo Travelers";
            if (keysc1[p] == "DietaryRequests") keysc1[p] = "Dietary Requests";
            if (keysc1[p] == "MedicalRequests") keysc1[p] = "Medical  Requests";
            if (keysc1[p] == "MobilityRequests") keysc1[p] = "Mobility Requests";
            if (keysc1[p] == "OtherRequests") keysc1[p] = "Other Requests";
            if (keysc1[p] == "ArriveEarlys") keysc1[p] = "Arrive Early";
            if (keysc1[p] == "StayBehinds") keysc1[p] = "Stay Behind";
            if (keysc1[p] == "landActivityCSV") keysc1[p] = "Land Activities";
            if (keysc1[p] == "purchaseDate") keysc1[p] = "Purchase Date";
            if (keysc1[p] == "OrdTripcase") keysc1[p] = "Trip case 1";
            if (keysc1[p] == "OrdTripcase1") keysc1[p] = "Trip case 2";
            if (keysc1[p] == "OrdTripcase2") keysc1[p] = "Trip case 3";
            if (keysc1[p] == "infofromlogistics")
                keysc1[p] = "Additional Information";
        }
        csvStringResult = "";
        csvStringResult += keysc1.join(columnDivider);
        console.log("csvStringResult 387= " + csvStringResult);
        csvStringResult += lineDivider;
        counter = 0;
        
        for (var p = 0; p < keysc1.length; p++) {
            if (keysc1[p] == "Deal") keysc1[p] = "DealNumber";
            if (keysc1[p] == "Deal Name") keysc1[p] = "DealName";
            if (keysc1[p] == "Order Number") keysc1[p] = "OrderName";
            if (keysc1[p] == "Old Order Number") keysc1[p] = "OldOrderNumber";
            if (keysc1[p] == "Departure Date") keysc1[p] = "DepartureDate";
            if (keysc1[p] == "Start Date") keysc1[p] = "StartDate";
            if (keysc1[p] == "Component type") keysc1[p] = "componentType";
            if (keysc1[p] == "Passengers") keysc1[p] = "PAX";
            if (keysc1[p] == "Link to Order") keysc1[p] = "LinkingOrders";
            if (keysc1[p] == "Account name") keysc1[p] = "PurchaserFullName";
            if (keysc1[p] == "E-mail") keysc1[p] = "Emailpurchaser";
            if (keysc1[p] == "Phone number") keysc1[p] = "AccountPhoneNumber";
            if (keysc1[p] == "Mobile number") keysc1[p] = "AccountMobileNumber";
            // if(keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            
            if (keysc1[p] == "Room/Cabin Required") keysc1[p] = "RoomCabin";
            if (keysc1[p] == "Cruise/SubOption") keysc1[p] = "CruisSubOption";
            
            if(keysc1[p] == "Title") keysc1[p] = "Solutation";
            if(keysc1[p] == "First Name") keysc1[p] = "FirstName";
            if(keysc1[p] == "Second Name") keysc1[p] = "MiddleName";
            if(keysc1[p] == "Last Name") keysc1[p] = "LastName";
            if (keysc1[p] == "D.O.B") keysc1[p] = "dob";
            if (keysc1[p] == "Nationality") keysc1[p] = "nationality";
            if (keysc1[p] == "Passport Number") keysc1[p] = "passportNumber";
            if (keysc1[p] == "Passport Expiry Date") keysc1[p] = "passportExpiry";
            if (keysc1[p] == "Passport Issue Date") keysc1[p] = "passportIssueDate";
            if (keysc1[p] == "Country Of Issue") keysc1[p] = "countryOfIssue";
            if (keysc1[p] == "Awaiting new passport")
                keysc1[p] = "awaitingNewPassport";
            
            //    if(keysc1[p] == "PostCode") keysc1[p] = "Post Code";
            if (keysc1[p] == "Preferred Bedding") keysc1[p] = "Preferred_Bedding";
            if (keysc1[p] == "Solo Travelers") keysc1[p] = "Solo_Travellers";
            if (keysc1[p] == "Dietary Requests") keysc1[p] = "DietaryRequests";
            if (keysc1[p] == "Medical  Requests") keysc1[p] = "MedicalRequests";
            if (keysc1[p] == "Mobility Requests") keysc1[p] = "MobilityRequests";
            if (keysc1[p] == "Other Requests") keysc1[p] = "OtherRequests";
            if (keysc1[p] == "Arrive Early") keysc1[p] = "ArriveEarlys";
            if (keysc1[p] == "Stay Behind") keysc1[p] = "StayBehinds";
            if (keysc1[p] == "Land Activities") keysc1[p] = "landActivityCSV";
            if (keysc1[p] == "Purchase Date") keysc1[p] = "purchaseDate";
            if (keysc1[p] == "Trip case 1") keysc1[p] = "OrdTripcase";
            if (keysc1[p] == "Trip case 2") keysc1[p] = "OrdTripcase1";
            if (keysc1[p] == "Trip case 3") keysc1[p] = "OrdTripcase2";
            if (keysc1[p] == "Additional Information")
                keysc1[p] = "infofromlogistics";
        }
        for (var i = 0; i < objectRecords.length; i++) {
            console.log("objectRecords 393= " + JSON.stringify(objectRecords[i]));
            for (var sTempkey in keysc1) {
                console.log("sTempkey 394= " + sTempkey);
                
                var skey = keysc1[sTempkey];
                console.log('KEYYY ='+skey);
                console.log("KEY VALUE " + objectRecords[i][skey]);
                if (
                   // (skey != 'landActivityCSV') &&
                    (objectRecords[i][skey] == null ||
                     objectRecords[i][skey] == "undefined" ||
                     objectRecords[i][skey] == "")
                ) {
                } else {
                    
                    
                    var replaceWithNospace = String(objectRecords[i][skey]).replace(
                        /[\r\n]/gm,
                        " "
                    );
                    console.log("replaceWithNospace", replaceWithNospace);
                    /*var str = String(objectRecords[i][skey]);
                    if(objectRecords[i][skey] == null && skey == 'landActivityCSV'){
                        console.log(' if');
                        csvStringResult += columnDivider;
                        for(var m=0;m< landActivitySet.length;m++){
                            csvStringResult += columnDivider;
                        }
                    }else if(objectRecords[i][skey] != null && skey == 'landActivityCSV'){
                        var passLandArr = objectRecords[i][skey];
                        var filteredPassArr = [];
                        for(var a =0;a<passLandArr.length;a++){
                            var splitLandAct = passLandArr[a].split(" /");
                            filteredPassArr.push(splitLandAct[0]);                                               
                        } 
                        console.log('filteredPassArr ='+filteredPassArr.length);
                        for(var b = 0;b<filteredPassArr.length; b++){
                            
                            csvStringResult += columnDivider;
                            
                            for(var k=0;k< landActivitySet.length;k++){
                                if(filteredPassArr[b] == landActivitySet[k]){
                                    csvStringResult += filteredPassArr[b];                                 
                                }
                                else{
                                    csvStringResult += columnDivider;
                                }
                            }
                            
                        }  
                    }
                    
                        else if(skey == "DealNumber" || skey ==  "DealName"|| skey == "OrderName"|| skey ==  "OldOrderNumber"|| skey == "DepartureDate"|| skey == "StartDate"|| skey == "componentType"||skey == "PAX"|| skey == "PurchaserFullName"|| skey == "Emailpurchaser"|| skey == "AccountPhoneNumber"|| skey == "AccountMobileNumber"|| skey == "LinkingOrders"|| skey == "RoomCabin"||skey == "CruisSubOption"|| skey == "Solutation"|| skey == "FirstName"|| skey == "MiddleName"|| skey == "LastName"|| skey == "dob"|| skey == "nationality"|| skey == "passportNumber"|| skey == "passportExpiry"|| skey == "passportIssueDate"|| skey == "countryOfIssue"|| skey == "awaitingNewPassport"|| skey == "Preferred_Bedding"|| skey == "Solo_Travellers"|| skey == "DietaryRequests"|| skey == "MedicalRequests"|| skey == "MobilityRequests"|| skey == "OtherRequests"|| skey == "ArriveEarlys"|| skey == "StayBehinds"|| skey == "OrdTripcase"|| skey == "OrdTripcase1"|| skey == "OrdTripcase2"|| skey == "infofromlogistics"	)	{
                            console.log('Else');
                            csvStringResult += replaceWithNospace;
                        }
                    */
                    
                    var newStr = replaceWithNospace;
                   /* try{
                        if(newStr.includes('%u')){
                            console.log('index of ='+newStr.indexOf('%u'));
                            var replaceFrom = newStr.substr(newStr.indexOf('%u'),6);
                            var charUnicode = newStr.substr(newStr.indexOf('%u')+2,4);
                            console.log('specialChar ='+charUnicode);
                            
                            var unicodeConvertedStr = String.fromCodePoint(parseInt(charUnicode, 16));
                            var valueStr = newStr.replace(replaceFrom,unicodeConvertedStr);
                            console.log('updated value = '+valueStr);
                        }
                    }catch(e){
                        console.error(e);
                    }*/
                    
                    csvStringResult += newStr;
                    
                }                
                csvStringResult += columnDivider;
                console.log("csvStringResult 407= " + csvStringResult);
                counter++;
            }
            csvStringResult += lineDivider;
        }
        console.log("csvStringResult=565 " + csvStringResult);
        return csvStringResult;
    },
    
    convertArrayOfObjectsToXLS: function (component, objectRecords) {
        var csvStringResult,
            counter,
            keys,
            columnDivider,
            lineDivider,
            keys1,
            keys2,
            keys3,
            keys4;
        console.log("objectRecords 371= " + JSON.stringify(objectRecords));
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        columnDivider = "\t";
        lineDivider = "\n";
        
        keys = [
            "DealNumber",
            "DealName",
            "OrderName",
            "OldOrderNumber",
            "DepartureDate",
            "StartDate",
            "componentType",
            "PAX",
            
            "PurchaserFullName",
            "Emailpurchaser",
            "AccountPhoneNumber",
            "AccountMobileNumber",
            "LinkingOrders",
            "RoomCabin",
            "CruisSubOption",
            
            "Solutation",
            "FirstName",
            "MiddleName",
            "LastName",
            "dob",
            "nationality",
            "passportNumber",
            "passportExpiry",
            "passportIssueDate",
            "countryOfIssue",
            "awaitingNewPassport",
            "Preferred_Bedding",
            "Solo_Travellers",
            "DietaryRequests",
            "MedicalRequests",
            "MobilityRequests",
            "OtherRequests",
            "ArriveEarlys",
            "StayBehinds",
            "landActivityCSV",
            "purchaseDate",
            "infofromlogistics",
            "OrdTripcase",
            "OrdTripcase1",
            "OrdTripcase2"
        ];
        
        var keysc1 = keys;
        var keysc1 = keys;
        for (var p = 0; p < keysc1.length; p++) {
            if (keysc1[p] == "DealNumber") keysc1[p] = "Deal";
            if (keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            if (keysc1[p] == "OrderName") keysc1[p] = "Order Number";
            if (keysc1[p] == "OldOrderNumber") keysc1[p] = "Old Order Number";
            if (keysc1[p] == "DepartureDate") keysc1[p] = "Departure Date";
            if (keysc1[p] == "StartDate") keysc1[p] = "Start Date";
            if (keysc1[p] == "componentType") keysc1[p] = "Component type";
            if (keysc1[p] == "PAX") keysc1[p] = "Passengers";
            if (keysc1[p] == "LinkingOrders") keysc1[p] = "Link to Order";
            if (keysc1[p] == "PurchaserFullName") keysc1[p] = "Account name";
            if (keysc1[p] == "Emailpurchaser") keysc1[p] = "E-mail";
            if (keysc1[p] == "AccountPhoneNumber") keysc1[p] = "Phone number";
            if (keysc1[p] == "AccountMobileNumber") keysc1[p] = "Mobile number";
            // if(keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            
            if (keysc1[p] == "RoomCabin") keysc1[p] = "Room/Cabin Required";
            if (keysc1[p] == "CruisSubOption") keysc1[p] = "Cruise/SubOption";
            
            
            if(keysc1[p] == "Solutation") keysc1[p] = "Title";
            if(keysc1[p] == "FirstName") keysc1[p] = "First Name";
            if(keysc1[p] == "MiddleName") keysc1[p] = "Second Name";
            if(keysc1[p] == "LastName") keysc1[p] = "Last Name";
            if (keysc1[p] == "dob") keysc1[p] = "D.O.B";
            if (keysc1[p] == "nationality") keysc1[p] = "Nationality";
            if (keysc1[p] == "passportNumber") keysc1[p] = "Passport Number";
            if (keysc1[p] == "passportExpiry") keysc1[p] = "Passport Expiry Date";
            if (keysc1[p] == "passportIssueDate") keysc1[p] = "Passport Issue Date";
            if (keysc1[p] == "countryOfIssue") keysc1[p] = "Country Of Issue";
            if (keysc1[p] == "awaitingNewPassport")
                keysc1[p] = "Awaiting new passport";
            
            //    if(keysc1[p] == "PostCode") keysc1[p] = "Post Code";
            if (keysc1[p] == "Preferred_Bedding") keysc1[p] = "Preferred Bedding";
            if (keysc1[p] == "Solo_Travellers") keysc1[p] = "Solo Travelers";
            if (keysc1[p] == "DietaryRequests") keysc1[p] = "Dietary Requests";
            if (keysc1[p] == "MedicalRequests") keysc1[p] = "Medical  Requests";
            if (keysc1[p] == "MobilityRequests") keysc1[p] = "Mobility Requests";
            if (keysc1[p] == "OtherRequests") keysc1[p] = "Other Requests";
            if (keysc1[p] == "ArriveEarlys") keysc1[p] = "Arrive Early";
            if (keysc1[p] == "StayBehinds") keysc1[p] = "Stay Behind";
            if (keysc1[p] == "landActivityCSV") keysc1[p] = "Land Activities";
             if (keysc1[p] == "purchaseDate") keysc1[p] = "Purchase Date";
            if (keysc1[p] == "OrdTripcase") keysc1[p] = "Trip case 1";
            if (keysc1[p] == "OrdTripcase1") keysc1[p] = "Trip case 2";
            if (keysc1[p] == "OrdTripcase2") keysc1[p] = "Trip case 3";
            if (keysc1[p] == "infofromlogistics")
                keysc1[p] = "Additional Information";
        }
        csvStringResult = "";
        csvStringResult += keysc1.join(columnDivider);
        console.log("csvStringResult 387= " + csvStringResult);
        csvStringResult += lineDivider;
        counter = 0;
        
        for (var p = 0; p < keysc1.length; p++) {
            if (keysc1[p] == "Deal") keysc1[p] = "DealNumber";
            if (keysc1[p] == "Deal Name") keysc1[p] = "DealName";
            if (keysc1[p] == "Order Number") keysc1[p] = "OrderName";
            if (keysc1[p] == "Old Order Number") keysc1[p] = "OldOrderNumber";
            if (keysc1[p] == "Departure Date") keysc1[p] = "DepartureDate";
            if (keysc1[p] == "Start Date") keysc1[p] = "StartDate";
            if (keysc1[p] == "Component type") keysc1[p] = "componentType";
            if (keysc1[p] == "Passengers") keysc1[p] = "PAX";
            if (keysc1[p] == "Link to Order") keysc1[p] = "LinkingOrders";
            if (keysc1[p] == "Account name") keysc1[p] = "PurchaserFullName";
            if (keysc1[p] == "E-mail") keysc1[p] = "Emailpurchaser";
            if (keysc1[p] == "Phone number") keysc1[p] = "AccountPhoneNumber";
            if (keysc1[p] == "Mobile number") keysc1[p] = "AccountMobileNumber";
            // if(keysc1[p] == "DealName") keysc1[p] = "Deal Name";
            
            if (keysc1[p] == "Room/Cabin Required") keysc1[p] = "RoomCabin";
            if (keysc1[p] == "Cruise/SubOption") keysc1[p] = "CruisSubOption";
            
            if(keysc1[p] == "Title") keysc1[p] = "Solutation";
            if(keysc1[p] == "First Name") keysc1[p] = "FirstName";
            if(keysc1[p] == "Second Name") keysc1[p] = "MiddleName";
            if(keysc1[p] == "Last Name") keysc1[p] = "LastName";
            if (keysc1[p] == "D.O.B") keysc1[p] = "dob";
            if (keysc1[p] == "Nationality") keysc1[p] = "nationality";
            if (keysc1[p] == "Passport Number") keysc1[p] = "passportNumber";
            if (keysc1[p] == "Passport Expiry Date") keysc1[p] = "passportExpiry";
            if (keysc1[p] == "Passport Issue Date") keysc1[p] = "passportIssueDate";
            if (keysc1[p] == "Country Of Issue") keysc1[p] = "countryOfIssue";
            if (keysc1[p] == "Awaiting new passport")
                keysc1[p] = "awaitingNewPassport";
            
            //    if(keysc1[p] == "PostCode") keysc1[p] = "Post Code";
            if (keysc1[p] == "Preferred Bedding") keysc1[p] = "Preferred_Bedding";
            if (keysc1[p] == "Solo Travelers") keysc1[p] = "Solo_Travellers";
            if (keysc1[p] == "Dietary Requests") keysc1[p] = "DietaryRequests";
            if (keysc1[p] == "Medical  Requests") keysc1[p] = "MedicalRequests";
            if (keysc1[p] == "Mobility Requests") keysc1[p] = "MobilityRequests";
            if (keysc1[p] == "Other Requests") keysc1[p] = "OtherRequests";
            if (keysc1[p] == "Arrive Early") keysc1[p] = "ArriveEarlys";
            if (keysc1[p] == "Stay Behind") keysc1[p] = "StayBehinds";
            if (keysc1[p] == "Land Activities") keysc1[p] = "landActivityCSV";
            if (keysc1[p] == "Purchase Date") keysc1[p] = "purchaseDate";
            if (keysc1[p] == "Trip case 1") keysc1[p] = "OrdTripcase";
            if (keysc1[p] == "Trip case 2") keysc1[p] = "OrdTripcase1";
            if (keysc1[p] == "Trip case 3") keysc1[p] = "OrdTripcase2";
            if (keysc1[p] == "Additional Information")
                keysc1[p] = "infofromlogistics";
        }
        for (var i = 0; i < objectRecords.length; i++) {
            console.log("objectRecords 393= " + JSON.stringify(objectRecords[i]));
            for (var sTempkey in keysc1) {
                console.log("sTempkey 394= " + sTempkey);
                
                var skey = keysc1[sTempkey];
                console.log("skey 396= " + skey);
                if (
                    objectRecords[i][skey] == null ||
                    objectRecords[i][skey] == "undefined" ||
                    objectRecords[i][skey] == ""
                ) {
                } else {
                    var replaceWithNospace = String(objectRecords[i][skey]).replace(
                        /[\r\n]/gm,
                        " "
                    );
                    console.log("replaceWithNospace", replaceWithNospace);
                    var newStr = replaceWithNospace;
                 
                    csvStringResult += newStr;
                }
                csvStringResult += columnDivider;
                console.log("csvStringResult 407= " + csvStringResult);
                counter++;
            }
            csvStringResult += lineDivider;
        }
        console.log("csvStringResult=565 " + csvStringResult);
        return csvStringResult;
    },
    
     convertCsvOrXlsToJSON : function(component,exportFileText,exportFileDelimiter){
        var fileText = exportFileText;
        var lines=fileText.split("\n");        
        var result = [];       
        var headers=lines[0].split(exportFileDelimiter);        
        for(var i=1;i<lines.length;i++){           
            var obj = {};
            var currentline=lines[i].split(exportFileDelimiter);            
            for(var j=0;j<headers.length;j++){
                obj[headers[j]] = currentline[j];
            }            
            result.push(obj);
            
        }    
       return result; 
    },
            
    updateFlightManifest: function (component, helper) {
        var dealdata = component.find("dealPicklist").get("v.value");
        
        console.log("line236--->" + JSON.stringify(dealdata));
        var checkbc = component.get("v.OndealfetchBC");

        if(dealdata != 'All Deals' && checkbc == false){
            var stockData = component.get("v.allData");
        } else {
            var stockData = component.get("v.allRecordData");
        }
        console.log("stockData = " + stockData.length);
        var orderLst = [];
        for (var i = 0; i < stockData.length; i++) {
            orderLst.push(stockData[i].OrderId);
        }
        console.log("OrderList1238 = " + orderLst);
        var action = component.get("c.refreshPNR");
        action.setParams({ orderIDList: orderLst });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            console.log("State =" + state);
            if (state === "SUCCESS") {
                console.log("Its a success.");
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title: "Success!",
                    message:
                    "The flight manifest will be updated shortly and you will receive an email with updated flight manifest report!"
                });
                resultsToast.fire();
                
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
     updateFlightManifestXls: function (component, helper) {
        var dealdata = component.find("dealPicklist").get("v.value");
        
        console.log("line236--->" + JSON.stringify(dealdata));
        var checkbc = component.get("v.OndealfetchBC");

        if(dealdata != 'All Deals' && checkbc == false){
            var stockData = component.get("v.allData");
        } else {
            var stockData = component.get("v.allRecordData");
        }
        console.log("stockData = " + stockData.length);
        var orderLst = [];
        for (var i = 0; i < stockData.length; i++) {
            orderLst.push(stockData[i].OrderId);
        }
        console.log("OrderList1238 = " + orderLst);
        var action = component.get("c.refreshPNRXls");
        action.setParams({ orderIDList: orderLst });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            console.log("State =" + state);
            if (state === "SUCCESS") {
                console.log("Its a success.");
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title: "Success!",
                    message:
                    "The flight manifest will be updated shortly and you will receive an email with updated flight manifest report!"
                });
                resultsToast.fire();
                
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    },
});