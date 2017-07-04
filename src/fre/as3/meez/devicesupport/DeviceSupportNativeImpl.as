package meez.devicesupport
{

import flash.external.ExtensionContext;
import flash.system.Capabilities;

/** DeviceSupport Native Implementation */
public class DeviceSupportNativeImpl implements DeviceSupport
{
    // Instance variables

    /** Extension context */
    private var _context:ExtensionContext;

    // Public methods

    /** Create new DeviceSupportNativeImpl */
    public function DeviceSupportNativeImpl():void
    {
        this._context=ExtensionContext.createExtensionContext("com.meez.DeviceSupport", null);
    }

    // DeviceSupport implementation

    /** Return a (best-effort) unique device id */
    public function getDeviceId():String
    {
        var deviceId:String=this._context.call("getDeviceId") as String;

        // Provide fallback in case where device cannot provide a unique id
        if (deviceId==null)
        {
            // TBD: IMPLEMENTME: PMCD:
        }

        return deviceId;
    }

    /** Return status bar height */
    public function getStatusBarHeight():Number
    {
        return this._context.call("getStatusBarHeight") as Number;
    }

    /** Return API Level */
    public function getAPILevel():Number
    {
        return this._context.call("getAPILevel") as Number;
    }

    /** Refresh view */
    public function refreshView():void
    {
        this._context.call("refreshView");
    }

    /** Navigate Back */
    public function navigateBack():void
    {
        // only relevant on android
        if(Capabilities.manufacturer.indexOf("Android")==-1)
            return;

        this._context.call("navigateBack");
    }
}

}