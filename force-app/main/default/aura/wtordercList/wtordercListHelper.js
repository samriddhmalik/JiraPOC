({
    defaultOrders : function(component,page) {
      
        page = page || 1;
      var action = component.get("c.defaultOrders");
      action.setParams({
             "pageNumber": page
      });
      action.setCallback(this, function(a) {
          var result = a.getReturnValue();
          component.set("v.orders", result.products);
          component.set("v.page", result.page);
          component.set("v.total", result.total);
          component.set("v.pages", Math.ceil(result.total/12));
      });
      $A.enqueueAction(action);
  },
    
    getOrders : function(component, page) {
        var searchKey = window.location.hash.substr(1);
        page = page || 1;
        var action = component.get("c.findAll");
		action.setParams({
      		"searchKey": searchKey,
            "pageNumber": page
    	});
    	action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            component.set("v.orders", result.products);
            component.set("v.page", result.page);
            component.set("v.total", result.total);
            component.set("v.pages", Math.ceil(result.total/12));
    	});
    	$A.enqueueAction(action);
	}
})