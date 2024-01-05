@isTest
public class showAnalyticsButtonControllerTest {
 @isTest
    static void myTest() {
        test.startTest();
        Deal__c d = new Deal__c();
        d = TestDataFactory.createMarketingDeal();
        ms_Analytics__c msa = new ms_Analytics__c();
        msa.Name = 'xyz';
        msa.ms_Deal__c = d.Id;
        Insert msa;
        showAnalyticsButtonController.getAllChannelList('Day');
         showAnalyticsButtonController.getAllChannelList('This Week');
        showAnalyticsButtonController.getAllChannelList('This Month');
        showAnalyticsButtonController.getAllChannelList('xyzz');
       
        showAnalyticsButtonController.getDealList('Day');
         showAnalyticsButtonController.getDealList('This Week');
        showAnalyticsButtonController.getDealList('This Month');
        showAnalyticsButtonController.getDealList('xyzz');
        List<String> selectedChannels = new List<String>();
        selectedChannels.add('Email');
       showAnalyticsButtonController.getSelectedChannelList(selectedChannels,'Day');
         showAnalyticsButtonController.getSelectedChannelList(selectedChannels,'This Week');
       showAnalyticsButtonController.getSelectedChannelList(selectedChannels,'This Month');
      
        showAnalyticsButtonController.getSelectedDealList('1241','Day');
         showAnalyticsButtonController.getSelectedDealList('1241','This Week');
        showAnalyticsButtonController.getSelectedDealList('1241','This Month');
        showAnalyticsButtonController.getSelectedDealList('','Day');
       showAnalyticsButtonController.getSelectedDealList('','This Week');
        showAnalyticsButtonController.getSelectedDealList('','This Month');
       showAnalyticsButtonController.initChannelWrapper cw = new showAnalyticsButtonController.initChannelWrapper();
        showAnalyticsButtonController.initWrapper iw = new showAnalyticsButtonController.initWrapper();
        
       // showAnalyticsButtonController.getSelectedChannelList(selectedChannels, timeDuration);
       // showAnalyticsButtonController.getSelectedDealList(dealNames, timeDuration);
        
        test.stopTest();
    }
   
}