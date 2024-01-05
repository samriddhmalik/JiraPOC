({
  closeQA : function(component, event, helper) {
    console.log('parent comp')
    $A.get("e.force:closeQuickAction").fire();
  }
})