/** JSONParsed Class for PNRConverter API Response ***
 * Created by : Samrat M <samrat.m@psagtechnologies.com>
 * Considerations: Change the following constants in the JSON String before parsing to APEX
 *  .              string --> string_x
 *                 name --> name_x
 *                 class --> class_x
 *                 png-logo-low-res --> png
 *                 svg-logo-high-res --> svg  */

//


public class PNRConverterJSONResponse{
	public cls_flightData flightData;
	public class cls_flightData {
		public cls_info[] info;
		public cls_names[] names;
		public cls_flights[] flights;
		public cls_meta meta;
	}
	public class cls_info {
		public String agencyName;	//TripADeal
		public Integer requestsLeft;	//83
	}
	public class cls_names {
	}
	public class cls_flights {
		public cls_dep dep;
		public cls_arr arr;
		public cls_flt flt;
	}
	public class cls_dep {
		public String airportname;	//Chhatrapati Shivaji Airport
		public String cityname;	//Mumbai
		public String countryname;	//India
		public String airportcode;	//BOM
		public String latitude;	//19.088699340
		public String longitude;	//72.867897030
		public String timezone;	//Asia/Calcutta
		public String timezoneshort;	//IST
	}
	public class cls_arr {
		public String airportname;	//London Heathrow Airport
		public String cityname;	//London
		public String countryname;	//United Kingdom
		public String airportcode;	//LHR
		public String latitude;	//51.470600000
		public String longitude;	//-0.461941000
		public String timezone;	//Europe/London
		public String timezoneshort;	//GMT
	}
	public class cls_flt {
		public String flightNo;	//8020
		public String iatacode;	//VS
		public String name_x;	//Virgin Atlantic
		public String operated_by;	//Indigo
		public boolean code_share;
		public String cabin;	//Economy
		public String class_x;	//M
		public String aircraft;	//Boeing 777-300ER 
		public cls_departure departure;
		public cls_arrival arrival;
		public cls_transit_time transit_time;
		public cls_duration duration;
		public cls_distance distance;
		public cls_co2 co2;
		public String svg;	//https://www.pnrconverter.com/images/airlines/vs.svg
		public String png;	//https://www.pnrconverter.com/images/airlines/png/150/vs.png
	}
	public class cls_departure {
		public String string_x;	//2021-01-15 02:35
		public String day;	//Fri
	}
	public class cls_arrival {
		public String string_x;	//2021-01-15 07:00
		public String day;	//Fri
	}
	public class cls_transit_time {
	}
	public class cls_duration {
		public String minutes;	//55
		public String hours;	//9
	}
	class cls_distance {
		public Integer miles;	//4484
		public Integer km;	//7217
	}
	public class cls_co2 {
		public String co2;	//5.60
		public String co2_with_environmental_impact;	//10.59
	}
	public class cls_meta {
		public cls_pnr pnr;
	}
	public class cls_pnr {
	}
	public static PNRConverterJSONResponse parse(String json){
		return (PNRConverterJSONResponse) System.JSON.deserialize(json, PNRConverterJSONResponse.class);
	}

	
}