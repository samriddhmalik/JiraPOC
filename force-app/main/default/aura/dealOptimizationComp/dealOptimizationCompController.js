({
	myAction : function(component, event, helper) {
       
	},
    
    showinclusions : function(component, event, helper){
        console.log("line 007:- "+event.getParam('modeltoshow'));
        if(event.getParam('modeltoshow') == true){
            component.set("v.showAttachedInclusion",true);
        }
           	
        },
    closeModel: function(component, event, helper){
        component.set("v.showAttachedInclusion",false);
    }
})