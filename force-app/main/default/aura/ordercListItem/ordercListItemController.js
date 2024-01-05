({
	doInit : function(component) {
        var links;
        var order = component.get("v.order");
        var type = component.get("v.type");
        if (order.RecordTypeId == "01228000000yb7cAAA") { // 01228000000ybHwAAI production | 01228000000yb7cAAA TC & TC Staging | 01228000000ybHwAAI NRMA & NRMA Staging
            component.set("v.type", "TC");
        } else {
            component.set("v.type", "else");
        }
	}
})