package meez.devicesupport;

import android.annotation.TargetApi;
import android.os.Build;
import android.provider.Settings.Secure;

import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import com.adobe.fre.FREObject;

/** Extension */
@TargetApi(Build.VERSION_CODES.DONUT)
public class Extension extends BaseANE
{
    // Public methods

    /** Create new Extension */
    public Extension()
    {
        super("DeviceSupport");
    }

    /** Initialize */
    @Override public void initialize()
    {
        // Register FREFunction wrapper
        // PMCD: We can do this via reflection, but leaving the stock implementation for clarity
        //       and because it might impact runtime performance
        register(new BaseFREFunction("getStatusBarHeight",new Class[] {}) {
            public FREObject execute(FREObject[] params) throws Exception
            {
                return FREObject.newObject(getStatusBarHeight());
            }
        });
        register(new BaseFREFunction("getAPILevel",new Class[] {}) {
            public FREObject execute(FREObject[] params) throws Exception
            {
                return FREObject.newObject(getAPILevel());
            }
        });
        register(new BaseFREFunction("refreshView",new Class[] {}) {
            public FREObject execute(FREObject[] params) throws Exception
            {
                refreshView();

                return null;
            }
        });
        register(new BaseFREFunction("getDeviceId",new Class[] {}) {
            public FREObject execute(FREObject[] params) throws Exception
            {
                return FREObject.newObject(getDeviceId());
            }
        });
    }

    // Methods

    /** Get StatusBar Height */
    public int getStatusBarHeight()
    {
        return 0;
    }

    /** Return API Level */
    public int getAPILevel()
    {
        int apiLevel=Build.VERSION.SDK_INT;

        Log.d(tag, "getAPILevel()=" + apiLevel);

        return 0;
    }

    /** Refresh view */
    public void refreshView()
    {
        Log.d(tag, "refreshView requested");

        ViewGroup parentLayout=getAIRParentLayout();
        if (parentLayout==null)
        {
            Log.w(tag,"Could not find AIR FrameLayout container!");
            return;
        }

        // Hide & Show the parent layout
        setSurfaceViewsVisibility(parentLayout, View.INVISIBLE);
        setSurfaceViewsVisibility(parentLayout, View.VISIBLE);

        Log.d(tag, "refreshView complete");
    }

    /** Return device id */
    public String getDeviceId()
    {
        // Use Secure Android Id
        String id=Secure.getString(this.activeCtx.getActivity().getContentResolver(), Secure.ANDROID_ID);

        Log.d(tag, "getDevice() "+((id!=null)?"secure-id located":"secure-id missing"));

        return id;
    }

    // Implementation

    /** Get FrameLayout (as ViewGroup) AIR uses to house all its SurfaceView instances */
    private ViewGroup getAIRParentLayout()
    {
        ViewGroup contentViewGroup=(ViewGroup)this.activeCtx.getActivity().findViewById(android.R.id.content);
        if (contentViewGroup==null)
            return null;

        return (ViewGroup)contentViewGroup.getChildAt(0);
    }

    /** Set visibility for all SurfaceViews contained in parent */
    private void setSurfaceViewsVisibility(ViewGroup parent, int state)
    {
        for (int i=0; i < parent.getChildCount(); i++)
        {
            View child = parent.getChildAt(i);
            if (child instanceof SurfaceView)
            {
                child.setVisibility(state);
            }
        }
    }
}
