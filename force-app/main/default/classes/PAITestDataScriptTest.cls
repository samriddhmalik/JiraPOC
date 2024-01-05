@IsTest
public class PAITestDataScriptTest {

    @testSetup
    public static void testdeals() {
        Test.startTest();
        PAITestDataScript.dealMeUpScotty();
        Test.stopTest();
    }

    @IsTest
    public static void testOrdersv2() {
        Test.startTest();
        PAITestDataScript.ordersUpv2();
        Test.stopTest();
    }

    @IsTest
    public static void testOrdersv3() {
        Test.startTest();
        PAITestDataScript.ordersUpv3();
        Test.stopTest();
    }
    
}