@isTest
public class PNRConverterJSONResponseTest {
    
    static testMethod void testParse() {
		String json=		'{'+
		'    "flightData": {'+
		'        "info": ['+
		'            {'+
		'                "agencyName": "TripADeal",'+
		'                "requestsLeft": 83'+
		'            }'+
		'        ],'+
		'        "names": [],'+
		'        "flights": ['+
		'            {'+
		'                "dep": {'+
		'                    "airportname": "Chhatrapati Shivaji Airport",'+
		'                    "cityname": "Mumbai",'+
		'                    "countryname": "India",'+
		'                    "airportcode": "BOM",'+
		'                    "latitude": "19.088699340",'+
		'                    "longitude": "72.867897030",'+
		'                    "timezone": "Asia/Calcutta",'+
		'                    "timezoneshort": "IST"'+
		'                },'+
		'                "arr": {'+
		'                    "airportname": "London Heathrow Airport",'+
		'                    "cityname": "London",'+
		'                    "countryname": "United Kingdom",'+
		'                    "airportcode": "LHR",'+
		'                    "latitude": "51.470600000",'+
		'                    "longitude": "-0.461941000",'+
		'                    "timezone": "Europe/London",'+
		'                    "timezoneshort": "GMT"'+
		'                },'+
		'                "flt": {'+
		'                    "flightNo": "8020",'+
		'                    "iatacode": "VS",'+
		'                    "name": "Virgin Atlantic",'+
		'                    "operated_by": "Indigo",'+
		'                    "code_share": true,'+
		'                    "cabin": "Economy",'+
		'                    "class": "M",'+
		'                    "aircraft": "Boeing 777-300ER ",'+
		'                    "departure": {'+
		'                        "string": "2021-01-15 02:35",'+
		'                        "day": "Fri"'+
		'                    },'+
		'                    "arrival": {'+
		'                        "string": "2021-01-15 07:00",'+
		'                        "day": "Fri"'+
		'                    },'+
		'                    "transit_time": {},'+
		'                    "duration": {'+
		'                        "minutes": "55",'+
		'                        "hours": "9"'+
		'                    },'+
		'                    "distance": {'+
		'                        "miles": 4484,'+
		'                        "km": 7217'+
		'                    },'+
		'                    "co2": {'+
		'                        "co2": "5.60",'+
		'                        "co2_with_environmental_impact": "10.59"'+
		'                    },'+
		'                    "svg-logo-high-res": "https://www.pnrconverter.com/images/airlines/vs.svg",'+
		'                    "png-logo-low-res": "https://www.pnrconverter.com/images/airlines/png/150/vs.png"'+
		'                }'+
		'            }'+
		'        ],'+
		'        "meta": {'+
		'            "pnr": null'+
		'        }'+
		'    }'+
		'}';
		PNRConverterJSONResponse obj = PNRConverterJSONResponse.parse(json);
		System.assert(obj != null);
	}
}