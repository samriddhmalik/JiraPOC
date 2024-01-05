({
    SearchFunctionality: function(component, event, helper) {
        
        console.log('2');
        
        var key= document.getElementById('articleinput').value;
        
        if(key.length > 1){
            var action = component.get("c.fetchArticles");
            action.setParams({
                "key":key
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var stringItems = response.getReturnValue(); 
                    console.log('Articles: '+JSON.stringify(stringItems));
                    component.set('v.Knowledge',stringItems);                
                    
                } 
            });
            $A.enqueueAction(action); 
        }
        else{
            component.set('v.Knowledge','');    
        }
        
        
    },
    
    ViewKnowledge: function(component, event, helper) {
        
        var recId = event.target.id;
        console.log('recId: '+recId);
        
        var action = component.get("c.articleViewed");
        action.setParams({
            "recId":recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Response Received' );     
                var stringItems = response.getReturnValue();   
                component.set("v.Title",stringItems[0].Title);
                component.set("v.URL",stringItems[0].UrlName);
                component.set("v.Question",stringItems[0].Question__c);
                component.set("v.Answer",stringItems[0].Answer__c);
                document.getElementById('addNewTalentFade').className='slds-backdrop slds-backdrop--open';
                document.getElementById('addNewTalentModal').className='slds-modal slds-fade-in-open';
                
            } 
        });
        $A.enqueueAction(action);
        
    },
    
    modalCloseFun:function(component, event, helper){       
        document.getElementById('addNewTalentFade').className='slds-backdrop';
        document.getElementById('addNewTalentModal').className='slds-modal';
        component.set("v.Title",'');
        component.set("v.URL",'');
        component.set("v.Question",'');
        component.set("v.Answer",'');
    },
})