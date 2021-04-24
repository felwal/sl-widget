using Toybox.Application;

class SlWidgetApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new SlWidgetView() ];
    }

    // Return the initial glance view of your application here
    (:glance)
    function getGlanceView() {
        return [ new SlWidgetGlance() ];
    }

}
