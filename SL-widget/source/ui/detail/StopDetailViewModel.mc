using Toybox.WatchUi;
using Toybox.Timer;

(:glance)
class StopDetailViewModel {

    private static const _REQUEST_TIME_DELAY = 500;

    var stopCursor = 0;
    var modeCursor = 0;

    private var _repo;

    // init

    function initialize(repo, stopCursor, modeCursor) {
        _repo = repo;
        self.stopCursor = stopCursor;
        self.modeCursor = modeCursor;
    }

    // request

    function enableRequests() {
        _repo.setPlaceholderStop();
        _repo.enablePositionHandling(method(:getStopCursor));
        _makeRequestsDelayed();
        _startRequestTimer();
    }

    function disableRequests() {
        _repo.disablePositionHandling();
        _repo.stopTimer();
    }

    private function _makeRequestsDelayed() {
        new Timer.Timer().start(method(:makeRequests), _REQUEST_TIME_DELAY, false);
    }

    private function _startRequestTimer() {
        _repo.startTimer(method(:makeRequests));
    }

    //! Make requests to SlApi neccessary for detail display.
    //! This needs to be public to be able to be called by timer.
    function makeRequests() {
        _repo.requestDepartures(stopCursor);
        //_repo.requestNearbyStops(); // TODO: temp
    }

    // read

    function getStopCursor() {
        return stopCursor;
    }

    function getSelectedStopString() {
        return _repo.getStopString(stopCursor, modeCursor);
    }

    function getSelectedStop() {
        return _repo.getStop(stopCursor);
    }

    function getSelectedDepartures() {
        return getSelectedStop().getDepartures(modeCursor);
    }

    function getSelectedDepartureCount() {
        return getSelectedStop().getDepartureCount(modeCursor);
    }

    function getStopCount() {
        return _repo.getStopCount();
    }

    function getModeCount() {
        return _repo.getModeCount(stopCursor);
    }

    function getStopCursorIncreased() {
        return _repo.getStopIndexRotated(stopCursor, 1);
    }

    function getStopCursorDecreased() {
        return _repo.getStopIndexRotated(stopCursor, -1);
    }

    // write

    function incModeCursor() {
        modeCursor = _repo.getModeIndexRotated(stopCursor, modeCursor);
        WatchUi.requestUpdate();
    }

}
