({
    doInit : function(component, event, helper) {
        helper.checkForOpportunityStage(component, event, helper);
        helper.getDealType(component, event, helper);
        helper.getDateFlights(component, event, helper);
        helper.isDealExist(component, event, helper);
    },
    
    navigateToRecordCreation : function(component, event, helper) {
        console.log("here in console");
        
        //helper.navigateToRecordCreation(component, event, helper);
         component.set("v.openmodel",true);
    },
    
    showModal : function(component, event, helper){
      console.log("isDealExist--->");
        //helper.isDealExist(component, event, helper);
         //helper.isOppFieldPopulated(component, event, helper);
         //component.set("v.isButtonView", 'false');

        
    },
    closeModal :  function(component, event, helper){
         component.set("v.isOpen", 'false');
         component.set("v.isButtonView", 'true');
    },
    
    hideModel :  function(component, event, helper){
         component.set("v.isDealExist", false);
    },

    closeOppModal :  function(component, event, helper){
         component.set("v.OppFieldBlank", false);
    },
    
     hideDealCreateModal: function(component, event, helper) {
      component.set("v.openmodel", false);
   },
  
   saveDeal: function(component, event, helper) {
        console.log("Deal Creation Step--->");
        helper.dealCreationFromOpportunity(component, event, helper);
      //component.set("v.openmodel", false);
   },
    handleDealTypeChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedDealType", selectedValues);
        console.log('selectedDealType-->'+selectedValues);
    },
    handleDateFlightChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedFlight = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedDateFlight", selectedFlight);
        console.log('selectedDateFlight-->'+selectedFlight);
    },
})