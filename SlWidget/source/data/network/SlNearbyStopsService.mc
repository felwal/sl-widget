using Toybox.Communications;
using Toybox.WatchUi;

class SlNearbyStopsService {

    // Närliggande Hållplatser 2
    // Bronze: 10_000/month, 30/min

    // edges of the SL zone, with an extra 2 km offset
    private static const _BOUNDS_SOUTH = 58.783223; // Ankarudden (Nynäshamn)
    private static const _BOUNDS_NORTH = 60.225171; // Ellans Vändplan (Norrtälje)
    private static const _BOUNDS_WEST = 17.239541; // Dammen (Nykvarn)
    private static const _BOUNDS_EAST = 19.116554; // Räfsnäs Brygga (Norrtälje)

    private static const _RESPONSE_OK = 200;

    private static const _MAX_STOPS = 15; // default 9, max 1000
    private static const _MAX_RADIUS = 2000; // default 1000, max 2000 (meters)

    private var _storage;

    // init

    function initialize(storage) {
        _storage = storage;
    }

    // request

    function requestNearbyStops(lat, lon) {
        // check if outside bounds, to not make unnecessary calls outside the SL zone
        if (lat < _BOUNDS_SOUTH || lat > _BOUNDS_NORTH || lon < _BOUNDS_WEST || lon > _BOUNDS_EAST) {
            Log.i("Location (" + lat +", " + lon + ") outside bounds; skipping request");

            if (lat == 0.0 && lon == 0.0) {
                _storage.setResponseError(new ResponseError(ResponseError.ERROR_CODE_NO_GPS));
            }
            else {
                _storage.setResponseError(new ResponseError(ResponseError.ERROR_CODE_OUTSIDE_BOUNDS));
            }

            WatchUi.requestUpdate();
        }
        else {
            Log.i("Requesting stops for coords (" + lat + ", " + lon + ") ...");
            _requestNearbyStops(lat, lon);
        }
    }

    private function _requestNearbyStops(lat, lon) {
        var url = "https://api.sl.se/api2/nearbystopsv2";

        var params = {
            "key" => KEY_NH,
            "originCoordLat" => lat,
            "originCoordLong" => lon,
            "r" => _MAX_RADIUS,
            "maxNo" => _MAX_STOPS
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => { "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON }
        };

        Communications.makeWebRequest(url, params, options, method(:onReceiveNearbyStops));
    }

    // receive

    function onReceiveNearbyStops(responseCode, data) {
        if (responseCode == _RESPONSE_OK && data != null) {
            _handleNearbyStopsResponseOk(data);
        }
        else {
            Log.i("Stops response error (code " + responseCode + "): " + data);

            if (DictCompat.hasKey(data, "Message")) {
                _storage.setResponseError(new ResponseError(data["Message"]));
            }
            else {
                _storage.setResponseError(new ResponseError(responseCode));
            }
        }

        WatchUi.requestUpdate();
    }

    //! @return If the selected stop has changed and departures should be requested
    private function _handleNearbyStopsResponseOk(data) {
        // SL error
        if (DictCompat.hasKey(data, "StatusCode") || DictCompat.hasKey(data, "Message")) {
            var statusCode = data["StatusCode"];
            var message = data["Message"];

            Log.i("Stops SL request error (code " + statusCode + "): " + message);

            var error = new ResponseError(statusCode);
            error.message = message;
            _storage.setResponseError(error);

            return;
        }

        Log.d("Stops response success: " + data);

        // no stops were found
        if (!DictCompat.hasKey(data, "stopLocationOrCoordLocation") || data["stopLocationOrCoordLocation"] == null) {
            if (DictCompat.hasKey(data, "Message")) {
                _storage.setResponseError(new ResponseError(data["Message"]));
            }
            else {
                _storage.setResponseError(new ResponseError(ResponseError.ERROR_CODE_NO_STOPS));
            }

            return;
        }

        // stops were found

        var stopIds = [];
        var stopNames = [];
        var stops = [];

        var stopsData = data["stopLocationOrCoordLocation"];
        for (var i = 0; i < stopsData.size() && i < _MAX_STOPS; i++) {
            var stopData = stopsData[i]["StopLocation"];

            var extId = stopData["mainMastExtId"];
            var id = extId.substring(5, extId.length()).toNumber();
            var name = stopData["name"];
            var distance = stopData["dist"].toNumber();

            stopIds.add(id);
            stopNames.add(name);
            stops.add(new Stop(id, name, distance));
        }

        _storage.setStops(stopIds, stopNames, stops);
    }

}
