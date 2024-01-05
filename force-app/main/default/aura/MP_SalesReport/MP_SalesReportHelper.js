({
    fetchSelectedDealData: function (component, helper) {
        var action = component.get("c.getSelectedDealData");
        //var selectedDealID = component.find("dealPicklist").get("v.value");
        var selectedDealID = component.get("v.selectedDealByDefault");
        action.setParams({ dealId: selectedDealID });
        action.setCallback(this, function (response) {
            console.log("Line 7:" + JSON.stringify(response.getReturnValue()));
            var records = response.getReturnValue();
            for (var i = 0; i < records.length; i++) {
                if (selectedDealID == records[i].Id) {
                    component.set("v.dealIdTitle", records[i].Deal_ID_Title__c);
                    component.set("v.dealPDFUrl", records[i].pdf__c);
                    console.log("Deal PDF =" + component.get("v.dealPDFUrl"));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDealandDepartureDates: function (component, helper) {
        console.log("Line--1382");
        component.set("v.dataSpinner", true);
        var action = component.get("c.getDealsFromData");
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                component.set("v.dataSpinner", false);
                console.log("response--359--->" + state);
                console.log(
                    "response--1388--->" + JSON.stringify(response.getReturnValue())
                );
                var records = response.getReturnValue();
                console.log("Line---1396-->" + JSON.stringify(records));
                console.log("Line---1397-->" + JSON.stringify(records.length));
                var ddId = [];
                var deptdata = records.deptId;
                for (var i = 0; i < deptdata.length; i++) {
                    ddId.push(deptdata[i].deptId);
                }
                //component.set("v.dealList", records.dealId);
                component.set("v.ddIds", ddId);
                //component.set("v.startDateIds", records.MP_StartDate);
            }
        });
        console.log("Line---Before-->");
        $A.enqueueAction(action);
        console.log("Line---after-->");
        component.set("v.showDeparture", true);
    },
    
    fetchDeals: function (component, helper) {
        console.log('In FetchDeals');
        component.set("v.dealsSpinner", true);
        var action = component.get("c.fetchDeals");
        
        action.setCallback(this, function (response) {
            console.log("response");
            component.set("v.dealsSpinner", false);
            
            
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                console.log(
                    "Line--44-Deal->" + JSON.stringify(response.getReturnValue())
                );
                var dealDataLst = response.getReturnValue();
                
                console.log('dealDataLst ='+dealDataLst.length);
                for(var i=1; i<dealDataLst.length;i++){
                    console.log('DEAL ID ='+dealDataLst[1].Id);
                    component.set("v.selectedDealByDefault",dealDataLst[1].Id);
                    break;
                    
                }
                component.set("v.dealList", response.getReturnValue());
                console.log("dealDataLst[1] fetched ="+JSON.stringify(component.get("v.selectedDealByDefault")));
                component.set("v.dealSelected",true);
                component.set("v.showDeparture", true);
                if(component.get("v.dealSelected") == true){
                    //added below lines by @Ritu Nagi
                    //component.set("v.IscomponentPicklist", false);
                    //component.set("v.IsShowcomponentlist", true);
                    //helper.fetchTourDepartureDates(component);    
                    //helper.fetchDepartureDates(component);
                    
                    helper.fetchTourDepartureDates(component);    
                    helper.fetchDepartureDates(component);
                    
                    helper.fetchOrderData(component, helper);   
                    helper.fetchSelectedDealData(component, helper);
                    // helper.fetchDealandDepartureDates(component, helper);
                    component.set("v.IscomponentPicklist", false);
                    component.set("v.IsShowcomponentlist", true);
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchTourDepartureDates: function (component) {
        console.log("Deal-Id-->" + component.find("dealPicklist").get("v.value"));
        console.log(
            "Dept-Id-->" + component.find("tourDepartureDatePicklist").get("v.value")
        );
        var startdate = component.find("departurePicklist").get("v.value");
        console.log("startdate--->" + startdate);
        if (startdate == "All Start Dates" || startdate == "") {
            component.set("v.depName", "All Start Dates");
        }
        var action = component.get("c.tourDepartureDate");
        action.setParams({
            //dealId: component.find("dealPicklist").get("v.value")
            dealId: component.get("v.selectedDealByDefault")
            //"deptId":deptId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                console.log("response--359--->" + state);
                console.log(
                    "response--360--->" + JSON.stringify(response.getReturnValue())
                );
                var listOfTags = response.getReturnValue();
                let check = {};
                let res = [];
                for (let i = 0; i < listOfTags.length; i++) {
                    if (!check[listOfTags[i]]) {
                        console.log("-listOfTags--->" + listOfTags[i]);
                        check[listOfTags[i]] = true;
                        res.push(listOfTags[i]);
                    }
                }
                console.log("tourDeptdetails-102->" +JSON.stringify(res));
                component.set("v.tourDeptDateList", res);
                console.log("Line--372-->" + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepartureDates: function (component) {
        var tourDept = component.find("tourDepartureDatePicklist").get("v.value");
        var tourDeptName;
        var tourDeptdetails = component.get("v.tourDeptDateList");
        console.log("tourDeptdetails-797->" +JSON.stringify(tourDeptdetails));
        for (var i = 0; i < tourDeptdetails.length; i++) {
            if (
                tourDeptdetails[i].Id ==
                component.find("tourDepartureDatePicklist").get("v.value")
            ) {
                component.set("v.tourDeptName", tourDeptdetails[i].Name);
                tourDeptName = tourDeptdetails[i].Name;
                break;
            }
        }
        console.log("tourDeptName-113->" + tourDeptName);
        console.log("tourDept---310-->" + tourDept);
        if (
            tourDept == undefined ||
            tourDept == "All Departure Dates" ||
            tourDept == "undefined" ||
            tourDept == ""
        ) {
            console.log("tourDept---89-->" + tourDept);
            var action = component.get("c.fetchDeparture");
            action.setParams({
                //dealId: component.find("dealPicklist").get("v.value")
                dealId: component.get("v.selectedDealByDefault")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() != null) {
                    console.log("response--321--->" + state);
                    console.log("response--322--->" + response.getReturnValue());
                    var listOfTags = response.getReturnValue();
                    
                    console.log("Line--315-->" + listOfTags);
                    component.set("v.depDateList", listOfTags);
                }
            });
            $A.enqueueAction(action);
        } else {
            var action = component.get("c.fetchDeparture");
            action.setParams({
                //dealId: component.find("dealPicklist").get("v.value"),
                dealId: component.get("v.selectedDealByDefault"),
                
                dateId: tourDept
                //"StartDateId":startDateName
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() != null) {
                    console.log("response--321--->" + state);
                    console.log("response--322--->" + response.getReturnValue());
                    var listOfTags = response.getReturnValue();
                    
                    console.log("Line--315-->" + listOfTags);
                    component.set("v.depDateList", listOfTags);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    fetchOrderData: function (component, helper) {
        /*var mySpinner = component.find("mySpinner");
        
        $A.util.removeClass(mySpinner, 'slds-show');
        
        $A.util.addClass(mySpinner, 'slds-show');*/
        var fulldatasize;
        var allDealsModal = false;
        var action = component.get("c.fetchOrderData");
        var dept = component.find("departurePicklist").get("v.value");
        
        var tourDept = component.find("tourDepartureDatePicklist").get("v.value");
        console.log("tourDept-946-->" + tourDept);
        var dealIdDetails = component.find("dealPicklist").get("v.value");
        component.set("v.spinner", true);
        var dealdata = component.get("v.selectedDealByDefault");
        if (dealdata != null) {

            
            component.set("v.IsShowcomponentlist", true);
            component.set("v.dealIdForTotalPAX", dealdata);
        }
        
        var compdata = component.find("ComponentNamePicklist").get("v.value");
        console.log("dept-710-->" + dept);
        console.log("dealdata--711-->" + dealdata);
        console.log("compdata--713->" + JSON.stringify(compdata));
        var deptName;
        var depdetails = component.get("v.depDateList");
        console.log("depdetails[i]- " + depdetails);
        console.log(
            'component.find("departurePicklist").get("v.value")[i]- ' +
            component.find("departurePicklist").get("v.value")
        );
        for (var i = 0; i < depdetails.length; i++) {
            if (depdetails[i] == component.find("departurePicklist").get("v.value")) {
                component.set("v.depName", depdetails[i]);
                deptName = depdetails[i];
                break;
            }
        }
        var tourDeptName;
        var tourDeptdetails = component.get("v.tourDeptDateList");
        console.log("tourDeptdetails-797->" + tourDeptdetails);
        for (var i = 0; i < tourDeptdetails.length; i++) {
            if (
                tourDeptdetails[i].Id ==
                component.find("tourDepartureDatePicklist").get("v.value")
            ) {
                component.set("v.tourDeptName", tourDeptdetails[i].Name);
                tourDeptName = tourDeptdetails[i].Name;
                break;
            }
        }
        console.log("tourDeptName-646->" + tourDeptName);
        var dealTitleDetails = component.get("v.dealList");
        for (var i = 0; i < dealTitleDetails.length; i++) {
            /*if (
        dealTitleDetails[i].Id == component.find("dealPicklist").get("v.value")
      ) {*/
          if (dealTitleDetails[i].Id == component.get("v.selectedDealByDefault")) {
              component.set("v.dealName", dealTitleDetails[i].Name);
              /*var selectedDeal =
          dealTitleDetails[i].Name + " - " + dealTitleDetails[i].title__c;*/
            var selectedDeal =
                dealTitleDetails[i].Name;
            component.set("v.dealIdTitle", selectedDeal);
            component.set("v.dealtitle", dealTitleDetails[i].title__c);
            
            break;
        }
      }
        var compttName;
        var complist = component.get("v.componentNameList");
        for (var i = 0; i < complist.length; i++) {
            if (
                complist[i] == component.find("ComponentNamePicklist").get("v.value")
            ) {
                component.set("v.comptName", complist[i]);
                compttName = complist[i];
                break;
            }
        }
        
        if (dept == "All Start Date" || dept == "") {
            component.set("v.depName", "All Start Date");
        }
        if (tourDept == "All Tour Departure Dates" || tourDept == "") {
            component.set("v.tourDeptName", "All Tour Departure Dates");
        }
        
        console.log(
            "Line--612--> " + component.find("departurePicklist").get("v.value")
        );
        console.log(
            "Line--613--> " + component.find("ComponentNamePicklist").get("v.value")
        );
        
        console.log('deal ='+component.get("v.selectedDealByDefault"));
        console.log('dateId ='+tourDept);
        console.log('compId ='+component.find("ComponentNamePicklist").get("v.value"));
        console.log('depName ='+component.find("departurePicklist").get("v.value"))
        action.setParams({
            deal: component.get("v.selectedDealByDefault"), 
            dateId: tourDept,
            compId: component.find("ComponentNamePicklist").get("v.value"),
            //"depName" : deptName
            depName: component.find("departurePicklist").get("v.value")

        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("state -Order-494");
            console.log(state);
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                console.log("Success-497-->");
                //$A.util.removeClass(mySpinner, 'slds-show');
                //$A.util.addClass(mySpinner, 'slds-hide');
                component.set("v.spinner", false);
                
                var records = response.getReturnValue().TadOrderList;
                console.log('records ='+records.length);
                
                var compkeyvalList = response.getReturnValue().LandActPick;
                var compkeyvalList1 = response.getReturnValue().LandPick;
                var compkeyvalList2 = response.getReturnValue().LandTourPick;
                var compkeyvalList3 = response.getReturnValue().FlightPick;
                var compkeyvalList4 = response.getReturnValue().CruisePick;
                var compkeyvalList5 = response.getReturnValue().RailPick;
                var compkeyvalList6 = response.getReturnValue().TotalPackagePick;
                var compkeyvalList7 = response.getReturnValue().AccomPick;
                var compkeyvalList8 = response.getReturnValue().TransferPick;
                var compkeyvalList9 = response.getReturnValue().AEPick;
                var compkeyvalList10 = response.getReturnValue().SBPick;
                var compkeyvalList11 = response.getReturnValue().StopOverPick;
                var compkeyvalList12 = response.getReturnValue().FlightUpgradePick;
                var compkeyvalList13 = response.getReturnValue().DepartureCitySurchargePick;
                var compkeyvalList14 = response.getReturnValue().AEAccommodationPick;
                var compkeyvalList15 = response.getReturnValue().SBAccommodationPick;
                var compkeyvalList16 = response.getReturnValue().DayTourPick;
                console.log("Line--857--->" + compkeyvalList7);
                
                var compPicklist = component.get("v.IscomponentPicklist");
                if (compPicklist == true) {
                    //component.set("v.IscomponentPicklist", false);
                    console.log("Line--851-->" + compPicklist);
                } else {
                    console.log("Line--854-->" + compPicklist);
                    component.set("v.LandActivityNameList", compkeyvalList);
                    component.set("v.LandNameList", compkeyvalList1);
                    component.set("v.LandTourNameList", compkeyvalList2);
                    component.set("v.FlightNameList", compkeyvalList3);
                    component.set("v.CruiseNameList", compkeyvalList4);
                    component.set("v.RailNameList", compkeyvalList5);
                    component.set("v.TotalPackageNameList", compkeyvalList6);
                    component.set("v.AccomNameList", compkeyvalList7);
                    component.set("v.TransferNameList", compkeyvalList8);
                    component.set("v.AENameList", compkeyvalList9);
                    component.set("v.SBNameList", compkeyvalList10);
                    component.set("v.StopOverNameList", compkeyvalList11);
                    component.set("v.FlightUpgradeNameList", compkeyvalList12);
                    component.set("v.DepartureCitySurchargeNameList", compkeyvalList13);
                    component.set("v.AEAccommodationNameList", compkeyvalList14);
                    component.set("v.SBAccommodationNameList", compkeyvalList15);
                    component.set("v.DayTourNameList", compkeyvalList16);
                }
                
                if (dealdata != null || dealdata != "") {
                    console.log("enter in dealdata-->" + dealdata);
                    component.set(
                        "v.LandActivityInfoList",
                        response.getReturnValue().LandActInfo
                    );
                    component.set(
                        "v.LandNameInfoList",
                        response.getReturnValue().LandInfo
                    );
                    component.set(
                        "v.LandTourInfoList",
                        response.getReturnValue().LandTourInfo
                    );
                    component.set(
                        "v.FlightInfoList",
                        response.getReturnValue().FlightInfo
                    );
                    component.set(
                        "v.CruiseInfoList",
                        response.getReturnValue().CruiseInfo
                    );
                    component.set("v.RailInfoList", response.getReturnValue().RailInfo);
                    component.set(
                        "v.TotalPackageInfoList",
                        response.getReturnValue().TotalPackageInfo
                    );
                    component.set("v.AccomInfoList", response.getReturnValue().AccomInfo);
                    component.set(
                        "v.TransferInfoList",
                        response.getReturnValue().TransferInfo
                    );
                    component.set("v.AEInfoList", response.getReturnValue().AEInfo);
                    component.set("v.SBInfoList", response.getReturnValue().SBInfo);
                    component.set(
                        "v.StopOverInfoList",
                        response.getReturnValue().StopOverInfo
                    );
                    component.set(
                        "v.FlightUpgradeInfoList",
                        response.getReturnValue().FlightUpgradeInfo
                    );
                    component.set(
                        "v.DepartureCitySurchargeInfoList",
                        response.getReturnValue().DepartureCitySurchargeInfo
                    );
                    component.set(
                        "v.AEAccommodationInfoList",
                        response.getReturnValue().AEAccommodationInfo
                    );
                    component.set(
                        "v.SBAccommodationInfoList",
                        response.getReturnValue().SBAccommodationInfo
                    );
                    component.set(
                        "v.DayTourInfoList",
                        response.getReturnValue().DayTourInfo
                    );
                    
                    component.set(
                        "v.LandActivityPassInfoList",
                        response.getReturnValue().LandActPassInfo
                    );
                    component.set(
                        "v.LandNamePassInfoList",
                        response.getReturnValue().LandPassInfo
                    );
                    component.set(
                        "v.LandTourPassInfoList",
                        response.getReturnValue().LandTourPassInfo
                    );
                    component.set(
                        "v.FlightPassInfoList",
                        response.getReturnValue().FlightPassInfo
                    );
                    component.set(
                        "v.CruisePassInfoList",
                        response.getReturnValue().CruisePassInfo
                    );
                    component.set(
                        "v.RailPassInfoList",
                        response.getReturnValue().RailPassInfoList
                    );
                    component.set(
                        "v.TotalPackagePassInfoList",
                        response.getReturnValue().TotalPackagePassInfo
                    );
                    component.set(
                        "v.AccomPassInfoList",
                        response.getReturnValue().AccomPassInfo
                    );
                    component.set(
                        "v.TransferPassInfoList",
                        response.getReturnValue().TransferPassInfo
                    );
                    component.set(
                        "v.AEPassInfoList",
                        response.getReturnValue().AEPassInfo
                    );
                    component.set(
                        "v.SBPassInfoList",
                        response.getReturnValue().SBPassInfo
                    );
                    component.set(
                        "v.StopOverPassInfoList",
                        response.getReturnValue().StopOverPassInfo
                    );
                    component.set(
                        "v.FlightUpgradePassInfoList",
                        response.getReturnValue().FlightUpgradePassInfo
                    );
                    component.set(
                        "v.DepartureCitySurchargePassInfoList",
                        response.getReturnValue().DepartureCitySurchargePassInfo
                    );
                    component.set(
                        "v.AEAccommodationPassInfoList",
                        response.getReturnValue().AEAccommodationPassInfo
                    );
                    component.set(
                        "v.SBAccommodationPassInfoList",
                        response.getReturnValue().SBAccommodationPassInfo
                    );
                    component.set(
                        "v.DayTourPassInfoList",
                        response.getReturnValue().DayTourPassInfo
                    );
                }
                console.log("Line--457-->" + JSON.stringify(records));
                var dealIds;
                for (var i = 0; i < records.length; i++) {
                    dealIds = records[0].DealId;
                    
                    component.set("v.prefilledDealId", dealIds);
                }
                console.log('Line--462-->'+dealIds);
                
                if (records != null) {
                    component.set("v.allData", records);
                    console.log("alldata--769->" + records);
                    fulldatasize = component.get("v.allData");
                    console.log('Line--111--->'+fulldatasize.length);
                    if(dealIdDetails == "All Deals"){
                        if(fulldatasize.length >1500){
                            allDealsModal = true;
                            component.set("v.isModalOpen",true);
                            component.set("v.Spinner", false);
                        }
                    }
                    console.log("Line--745-->" + JSON.stringify(records));
                    
                }
                if (records.length == 0) {
                    console.log("Line--749-->" + records);
                    helper.showToastWhenNoOrders(component, helper);
                }
                if(allDealsModal == false){
                    component.set("v.ordList", records);
                    
                    var portalName = $A.get("{!$Label.c.Merchant_Portal_Name}");
                    
                    records.forEach(function (record) {
                        record["orderId"] =
                            "/" + portalName + "/s/tad-order/" + record["orderId"];
                    });
                    
                    console.log("Line--763-->" + records);
                    component.set(
                        "v.dataSize",
                        response.getReturnValue().TadOrderList.length
                    );
                    console.log("Line--765-->" + records);
                    component.set(
                        "v.totalPages",
                        Math.ceil(
                            response.getReturnValue().TadOrderList.length /
                            component.get("v.pageSize")
                        )
                    );
                    console.log("Line--767-->" + records);
                    
                    component.set("v.currentPageNumber", 1);
                    console.log(
                        "currentPageNumber::" + component.get("v.currentPageNumber")
                    );
                    
                    this.buildData(component, helper);
                    
                    component.set("v.showOrder", true);
                }
            } else {
                component.set("v.filteredList", "");
            }
           
                
            
            if (dealdata == "All Deals" || dealdata == "") {
                console.log("Line--1049--->" + dealdata);
                component.set("v.dealName", "All Deals");
                component.set("v.IsShowcomponentlist", false);
                component.set("v.dealtitle", "");
                
                component.set("v.tourDeptName", "All Tour Departure Dates");
                
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
            }
            if (records == "") {
                console.log("Line--463-->" + JSON.stringify(records));
                helper.showToastWhenNoOrders(component, helper);
            }
        });
        $A.enqueueAction(action);
        
        var PaxTravellingDetails = component.get("v.ordList");
        for (var i = 0; i < PaxTravellingDetails.length; i++) {
            component.set("v.paxTravel", PaxTravellingDetails[i].PaxTravelling);
            
            break;
        }
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
    
    showToastWhenNoOrders: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Info",
            message: "No Orders Yet.",
            duration: " 5000",
            key: "info_alt",
            type: "info",
            mode: "dismissible"
        });
        toastEvent.fire();
    },
    
    /*
   * this function will build table data
   * based on current page selection
   * */
    buildData: function (component, helper) {
        console.log("Entered In BuildData");
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        console.log("pageNumber::" + pageNumber);
        var pageSize = component.get("v.pageSize");
        console.log("pageSize::" + pageSize);
        var allData = component.get("v.allData");
        
        var x = (pageNumber - 1) * pageSize;
        
        //creating data-table data
        for (; x < pageNumber * pageSize; x++) {
            if (allData[x]) {
                data.push(allData[x]);
            }
        }
        console.log("data::" + data);
        component.set("v.currentDataSize", data.length);
        
        component.set("v.ordList", data);
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
   * this function generate page list
   * */
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
    
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        var csvStringResult,
            counter,
            keys,
            columnDivider,
            lineDivider,
            keys1,
            keys2;
        console.log("objectRecords 371= " + JSON.stringify(objectRecords));
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        columnDivider = ",";
        lineDivider = "\n";
        
        keys = [
            "Deal",
            "OrderNumber",
            "OldOrderNumber",
            "MinNumberMet",
            "Status",
            "AccountName",
            "TourDepartureDate",
            "StartDate",
            "OptionData",
            "ComponentName",
            "PaxTravelling",
            "RoomsRequired"
        ];
        keys1 = [
            "Deal",
            "OrderNumber",
            "OldOrderNumber",
            "MinNumberMet",
            "Status",
            "AccountName",
            "TourDepartureDate"
        ];
        keys2 = [
            "StartDate",
            "OptionData",
            "ComponentName",
            "PaxTravelling",
            "RoomsRequired"
        ];
        var keyc = keys;
        var keysc1 = keys1;
        var keysc2 = keys2;
        for (var p = 0; p < keyc.length; p++) {
            if (keyc[p] == "OrderNumber") keyc[p] = "Order Number";
            if (keyc[p] == "OldOrderNumber") keyc[p] = "Old Order Number";
            if (keyc[p] == "AccountName") keyc[p] = "Account Name";
            if (keyc[p] == "TourDepartureDate") keyc[p] = "Tour Departure Date";
            if (keyc[p] == "StartDate") keyc[p] = "Start Date";
            if (keyc[p] == "ComponentName") keyc[p] = "Component Name";
            if (keyc[p] == "PaxTravelling") keyc[p] = "Passengers";
            if (keyc[p] == "RoomsRequired") keyc[p] = "Room/Cabin Required";
            if (keyc[p] == "MinNumberMet") keyc[p] = "Min Number Met";
            if (keyc[p] == "OptionData") keyc[p] = "Option";
        }
        
        csvStringResult = "";
        csvStringResult += keyc.join(columnDivider);
        console.log("csvStringResult 387= " + csvStringResult);
        csvStringResult += lineDivider;
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            console.log("objectRecords 393= " + objectRecords[i]);
            for (var sTempkey in keysc1) {
                console.log("sTempkey 394= " + sTempkey);
                var skey = keysc1[sTempkey];
                console.log("skey 396= " + skey);
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                
                console.log(
                    "objectRecords.comp 407= " + objectRecords[i].component.length
                );
                if (
                    objectRecords[i][skey] == null ||
                    objectRecords[i][skey] == "undefined" ||
                    objectRecords[i][skey] == ""
                ) {
                } else {
                    csvStringResult += '"' + objectRecords[i][skey] + '"';
                }
                console.log("csvStringResult 407= " + csvStringResult);
                counter++;
            }
            
            for (var j = 0; j < objectRecords[i].component.length; j++) {
                counter = 0;
                console.log(
                    "component.length 415= " + objectRecords[i].component.length
                );
                if (j > 0) {
                    for (var sTempkey in keysc1) {
                        console.log("sTempkey 394= " + sTempkey);
                        var skey = keysc1[sTempkey];
                        console.log("skey 396= " + skey);
                        if (counter > 0) {
                            csvStringResult += columnDivider;
                        }
                        
                        console.log(
                            "objectRecords.comp 407= " + objectRecords[i].component.length
                        );
                        if (
                            objectRecords[i][skey] == null ||
                            objectRecords[i][skey] == "undefined" ||
                            objectRecords[i][skey] == ""
                        ) {
                        } else {
                            csvStringResult += '"' + objectRecords[i][skey] + '"';
                        }
                        console.log("csvStringResult 407= " + csvStringResult);
                        counter++;
                    }
                } else {
                    csvStringResult += columnDivider;
                }
                for (var sTempkey in keysc2) {
                    var skey = keysc2[sTempkey];
                    console.log("Line--614-->" + j);
                    console.log("line--618-->" + skey);
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    
                    if (
                        (objectRecords[i].component[j][skey] == null ||
                         objectRecords[i].component[j][skey] == "undefined" ||
                         objectRecords[i].component[j][skey] == "") &&
                        skey != "PaxTravelling"
                    ) {
                        if (skey == "StartDate") {
                            csvStringResult +=
                                '"' + objectRecords[i].component[j - 1][skey] + '"';
                        }
                        if (skey == "RoomsRequired" || skey == "RoomConfiguration") {
                            csvStringResult += "";
                        }
                        if (skey == "ComponentName") {
                            csvStringResult +=
                                '"' + objectRecords[i].component[j - 1][skey] + '"';
                        }
                    } else {
                        csvStringResult += '"' + objectRecords[i].component[j][skey] + '"';
                    }
                    
                    counter++;
                }
                csvStringResult += lineDivider;
            }
        }
        console.log("csvStringResult= " + csvStringResult);
        return csvStringResult;
    },
    
    convertArrayOfObjectsToXLS: function (component, objectRecords) {
        var csvStringResult,
            counter,
            keys,
            columnDivider,
            lineDivider,
            keys1,
            keys2;
        console.log("objectRecords 371= " + JSON.stringify(objectRecords));
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        columnDivider = "\t";
        lineDivider = "\n";
        
        keys = [
            "Deal",
            "OrderNumber",
            "OldOrderNumber",
            "MinNumberMet",
            "Status",
            "AccountName",
            "TourDepartureDate",
            "StartDate",
            "OptionData",
            "ComponentName",
            "PaxTravelling",
            "RoomsRequired"
        ];
        keys1 = [
            "Deal",
            "OrderNumber",
            "OldOrderNumber",
            "MinNumberMet",
            "Status",
            "AccountName",
            "TourDepartureDate"
        ];
        keys2 = [
            "StartDate",
            "OptionData",
            "ComponentName",
            "PaxTravelling",
            "RoomsRequired"
        ];
        var keyc = keys;
        var keysc1 = keys1;
        var keysc2 = keys2;
        for (var p = 0; p < keyc.length; p++) {
            if (keyc[p] == "OrderNumber") keyc[p] = "Order Number";
            if (keyc[p] == "OldOrderNumber") keyc[p] = "Old Order Number";
            if (keyc[p] == "AccountName") keyc[p] = "Account Name";
            if (keyc[p] == "TourDepartureDate") keyc[p] = "Tour Departure Date";
            if (keyc[p] == "StartDate") keyc[p] = "Start Date";
            if (keyc[p] == "ComponentName") keyc[p] = "Component Name";
            if (keyc[p] == "PaxTravelling") keyc[p] = "Passengers";
            if (keyc[p] == "RoomsRequired") keyc[p] = "Room/Cabin Required";
            if (keyc[p] == "MinNumberMet") keyc[p] = "Min Number Met";
            if (keyc[p] == "OptionData") keyc[p] = "Option";
        }
        
        csvStringResult = "";
        csvStringResult += keyc.join(columnDivider);
        console.log("csvStringResult 387= " + csvStringResult);
        csvStringResult += lineDivider;
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            console.log("objectRecords 393= " + objectRecords[i]);
            for (var sTempkey in keysc1) {
                console.log("sTempkey 394= " + sTempkey);
                var skey = keysc1[sTempkey];
                console.log("skey 396= " + skey);
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                
                console.log(
                    "objectRecords.comp 407= " + objectRecords[i].component.length
                );
                if (
                    objectRecords[i][skey] == null ||
                    objectRecords[i][skey] == "undefined" ||
                    objectRecords[i][skey] == ""
                ) {
                } else {
                    csvStringResult += '"' + objectRecords[i][skey] + '"';
                }
                console.log("csvStringResult 407= " + csvStringResult);
                counter++;
            }
            
            for (var j = 0; j < objectRecords[i].component.length; j++) {
                counter = 0;
                console.log(
                    "component.length 415= " + objectRecords[i].component.length
                );
                if (j > 0) {
                    for (var sTempkey in keysc1) {
                        console.log("sTempkey 394= " + sTempkey);
                        var skey = keysc1[sTempkey];
                        console.log("skey 396= " + skey);
                        if (counter > 0) {
                            csvStringResult += columnDivider;
                        }
                        
                        console.log(
                            "objectRecords.comp 407= " + objectRecords[i].component.length
                        );
                        if (
                            objectRecords[i][skey] == null ||
                            objectRecords[i][skey] == "undefined" ||
                            objectRecords[i][skey] == ""
                        ) {
                        } else {
                            csvStringResult += '"' + objectRecords[i][skey] + '"';
                        }
                        console.log("csvStringResult 407= " + csvStringResult);
                        counter++;
                    }
                } else {
                    csvStringResult += columnDivider;
                }
                for (var sTempkey in keysc2) {
                    var skey = keysc2[sTempkey];
                    
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    if (
                        (objectRecords[i].component[j][skey] == null ||
                         objectRecords[i].component[j][skey] == "undefined" ||
                         objectRecords[i].component[j][skey] == "") &&
                        skey != "PaxTravelling"
                    ) {
                        if (skey == "StartDate") {
                            csvStringResult +=
                                '"' + objectRecords[i].component[j - 1][skey] + '"';
                        }
                        if (skey == "RoomsRequired" || skey == "RoomConfiguration") {
                            csvStringResult += "";
                        }
                        if (skey == "ComponentName") {
                            csvStringResult +=
                                '"' + objectRecords[i].component[j - 1][skey] + '"';
                        }
                    } else {
                        csvStringResult += '"' + objectRecords[i].component[j][skey] + '"';
                    }
                    counter++;
                }
                csvStringResult += lineDivider;
            }
        }
        console.log("csvStringResult= " + csvStringResult);
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
    }
});