({
    searchKeyChange: function(component, event) {
        window.location.hash = event.target.value;
    },
    locationChange: function(component, event) {
        var token = event.getParam("token") || "";
        component.set("v.searchKey", token);
    },
    clearText: function(component) {
        window.location.hash = "";
    },
    display : function(component, event, helper) {
        helper.toggleHelper(component, event);
    },
    displayOut : function(component, event, helper) {
        helper.toggleHelper(component, event);
    }
})