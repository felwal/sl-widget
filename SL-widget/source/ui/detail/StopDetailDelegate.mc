using Toybox.WatchUi;

class StopDetailDelegate extends WatchUi.BehaviorDelegate {

    private var _container;
    private var _viewModel;

    // init

    function initialize(container, viewModel) {
        BehaviorDelegate.initialize();

        _container = container;
        _viewModel = viewModel;
    }

    // override BehaviorDelegate

    //! "DOWN" / next stop
    function onNextPage() {
        var stopCursor = _viewModel.getStopCursorIncreased();
        var modeCursor = 0;

        // don't switch view if <= 1 stop
        if (stopCursor == _viewModel.stopCursor) {
            return true;
        }

        var viewModel = _container.buildStopDetailViewModel(stopCursor, modeCursor);
        var view = new StopDetailView(viewModel);
        var delegate = new StopDetailDelegate(_container, viewModel);

        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_UP);
        return true;
    }

    //! "UP" / previous stop
    function onPreviousPage() {
        var stopCursor = _viewModel.getStopCursorDecreased();
        var modeCursor = 0;

        // don't switch view if <= 1 stop
        if (stopCursor == _viewModel.stopCursor) {
            return true;
        }

        var viewModel = _container.buildStopDetailViewModel(stopCursor, modeCursor);
        var view = new StopDetailView(viewModel);
        var delegate = new StopDetailDelegate(_container, viewModel);

        WatchUi.switchToView(view, delegate,  WatchUi.SLIDE_DOWN);
        return true;
    }

    //! "START-STOP" / next mode
    function onSelect() {
        _viewModel.incModeCursor();
        return true;
    }

}
