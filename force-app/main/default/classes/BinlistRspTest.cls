@IsTest
public class BinlistRspTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '  \"number\": {'+
                '    \"length\": 16,'+
                '    \"luhn\": true'+
                '  },'+
                '  \"scheme\": \"visa\",'+
                '  \"type\": \"debit\",'+
                '  \"brand\": \"Visa/Dankort\",'+
                '  \"prepaid\": false,'+
                '  \"country\": {'+
                '    \"numeric\": \"208\",'+
                '    \"alpha2\": \"DK\",'+
                '    \"name\": \"Denmark\",'+
                '    \"emoji\": \"🇩🇰\",'+
                '    \"currency\": \"DKK\",'+
                '    \"latitude\": 56,'+
                '    \"longitude\": 10'+
                '  },'+
                '  \"bank\": {'+
                '    \"name\": \"Jyske Bank\",'+
                '    \"url\": \"www.jyskebank.dk\",'+
                '    \"phone\": \"+4589893300\",'+
                '    \"city\": \"Hjorring\"'+
                '  }'+
                '}';
        BinlistRsp.BinlistResponse r = BinlistRsp.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BinlistRsp.BinlistResponse objBinlistResponse = new BinlistRsp.BinlistResponse(System.JSON.createParser(json));
        System.assert(objBinlistResponse != null);
        System.assert(objBinlistResponse.numberClass == null);
        System.assert(objBinlistResponse.scheme == null);
        System.assert(objBinlistResponse.typeString == null);
        System.assert(objBinlistResponse.brand == null);
        System.assert(objBinlistResponse.prepaid == null);
        System.assert(objBinlistResponse.country == null);
        System.assert(objBinlistResponse.bank == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BinlistRsp.Bank objBank = new BinlistRsp.Bank(System.JSON.createParser(json));
        System.assert(objBank != null);
        System.assert(objBank.name == null);
        System.assert(objBank.url == null);
        System.assert(objBank.phone == null);
        System.assert(objBank.city == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BinlistRsp.Country objCountry = new BinlistRsp.Country(System.JSON.createParser(json));
        System.assert(objCountry != null);
        System.assert(objCountry.numeric == null);
        System.assert(objCountry.alpha2 == null);
        System.assert(objCountry.name == null);
        System.assert(objCountry.emoji == null);
        System.assert(objCountry.currencyString == null);
        System.assert(objCountry.latitude == null);
        System.assert(objCountry.longitude == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BinlistRsp.NumberClass objNumber = new BinlistRsp.NumberClass(System.JSON.createParser(json));
        System.assert(objNumber != null);
        System.assert(objNumber.length == null);
        System.assert(objNumber.luhn == null);
    }

}