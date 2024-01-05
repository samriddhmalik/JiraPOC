({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        flow.startFlow("Create_New_Case");
    },
})