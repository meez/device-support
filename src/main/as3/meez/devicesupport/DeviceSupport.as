package meez.devicesupport
{

/** EXAMPLE API */
public interface DeviceSupport
{
    /** Return a (best-effort) unique device-id */
    function getDeviceId():String;

    /** Return height of status bar
     *
     * IOS specific
     *
     **/
    function getStatusBarHeight():Number;

    /** Refresh view
     *
     * Android issue
     *
     **/
    function refreshView():void;

    // Android Specific

    /** Return API level
     *
     * @returns Android API level on android
     *
     */
    function getAPILevel():Number;

    /** Navigate Back
     *
     * Triggers an Android back action that will back out of the current Air activity
     *
     */
    function navigateBack():void;
}

}

