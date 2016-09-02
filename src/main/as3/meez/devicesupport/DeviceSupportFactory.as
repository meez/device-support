package meez.devicesupport
{

import flash.utils.getDefinitionByName;

/** DeviceSupportFactory */
public class DeviceSupportFactory
{
    // Static

    /** Singleton reference */
    protected static var _singleton:DeviceSupport=null;

    // Public methods

    /** Create new instance */
    public static function get():DeviceSupport
    {
        if (_singleton==null)
        {

            var impl:Class = getDefinitionByName(CONFIG::IMPL) as Class;
            _singleton=new impl() as DeviceSupport;
        }

        return _singleton;
    }
}

}