package meez.devicesupport
{

/** DeviceSupport Default Implementation */
public class DeviceSupportDefaultImpl implements DeviceSupport
{
    // DeviceSupport implementation

    /** Return a (best-effort) unique device id */
    public function getDeviceId():String
    {
        var fakeId:String="TBD";

        trace("[DeviceSupport.Default] getDeviceId()="+fakeId);

        return fakeId;
    }

    /** Return status bar height */
    public function getStatusBarHeight():Number
    {
        return 0;
    }

    /** Return API Level */
    public function getAPILevel():Number
    {
        // Faking Android 4.0.1 Level 14
        return 14;
    }

    /** Refresh view */
    public function refreshView():void
    {
        trace("[DeviceSupport.Default] refreshView() stubbed");
    }

    /** Native Back */
    public function nativeBack():void
    {
        trace("[DeviceSupport.Default] nativeBack() stubbed");
    }
}

}