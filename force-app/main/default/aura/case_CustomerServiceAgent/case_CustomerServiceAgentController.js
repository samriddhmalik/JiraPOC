({
		doInit : function(component, event, helper) {
        console.log('Entering Init ==>');
        helper.getInitDetails(component,event,helper);
	},
    doSomething : function(component,event, helper) {
       console.log('Hey There .. the anchor was clicked');
       console.log(event);
       var href = event.srcElement.href;
       console.log(href);

    },
     openTab : function(component, event, helper) {
        helper.closeFocusedTabAndOpenNewTab(component,event,helper); 
    },
})