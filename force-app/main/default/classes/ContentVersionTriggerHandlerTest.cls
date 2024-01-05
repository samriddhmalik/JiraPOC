@isTest
public class ContentVersionTriggerHandlerTest {

    @isTest
    public static void testMethod1(){
        string base64='iVBORw0KGgoAAAANSUhEUgAAB2MAAAN+CAYAAAAooKDOAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiU';
        string fileName='testFile';
        
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        datetime timenow=datetime.now();
        cv.Title = filename+string.valueof(timenow);
        cv.PathOnClient = filename;
        
        test.startTest();
        insert cv;
        test.stopTest();
    }
}