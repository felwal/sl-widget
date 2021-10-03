using Toybox.Application;

class App extends Application.AppBase {

    private var _container;

    // init

    function initialize() {
        AppBase.initialize();
    }

    // override AppBase

    //! onStart() is called on application start up
    function onStart(state) {
        _container = new Container();
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        var viewModel = _container.buildStopDetailViewModel(0, 0);
        var view = new StopDetailView(viewModel);
        var delegate = new StopDetailDelegate(_container, viewModel);

        return [ view, delegate ];
    }

    //! Return the initial glance view of your application here
    (:glance)
    function getGlanceView() {
        return [ new StopGlanceView(_container) ];
    }

}
