({
	 callTadOrderCreateFlow : function(component,event,helper, getAccountid){
        
        console.log('Entering callFlowNow for Account Id');
        var flow = component.find("flowId");
        console.log("flow "+flow);
       
        var inputVariables = [
            {
                name : "accountIdtoGet",
                type : "String",
                value : getAccountid	
            },
        ];
            
            // In that component, start your flow. Reference the flow's Unique Name.        
            flow.startFlow("Create_Customisation_Enquiry_Case",inputVariables);	
	}
})