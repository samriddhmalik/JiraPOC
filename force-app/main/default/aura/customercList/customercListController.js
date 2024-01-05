({
    agentChange : function(component, event, helper) {
        helper.getCustomers(component);
    },
    pageChange: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getCustomers(component, page);
    }
})