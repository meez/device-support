package meez.devicesupport;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.HashMap;
import java.util.Map;

/** Base-class for Android ANE */
public class BaseANE implements FREExtension
{
    // Definitions

    /** Context */
    public class Context extends FREContext
    {
        // Instance variables

        /** Functions */
        protected final Map<String,FREFunction> functions;

        // Public methods

        /** Create new Context */
        public Context(Map<String,FREFunction> functions)
        {
            this.functions=functions;
        }

        // FREContext implementation

        @Override
        public void dispose()
        {
            resetCtx();
        }

        @Override
        public Map<String, FREFunction> getFunctions()
        {
            return this.functions;
        }
    }

    /** BaseFREFunction */
    public abstract class BaseFREFunction implements FREFunction
    {
        // Instance vars

        /** Name */
        protected String name;

        /** Params */
        protected Class[] paramTypes;

        // Public methods

        /** Create a new BaseFREFunction */
        public BaseFREFunction(String name, Class[] paramTypes)
        {
            this.name=name;
            this.paramTypes=paramTypes;
        }

        // FREFunction implementation

        @Override
        public FREObject call(FREContext freContext, FREObject[] params)
        {
            try
            {
                validate(params);

                return execute(params);
            }
            catch (Throwable t)
            {
                Log.e(tag, "[" + this.name + "] Could not retrieve passed FREObject params", t);
                return  null;
            }
        }

        // Implementation

        /** Validate */
        protected void validate(FREObject[] params)
        {
            if (paramTypes.length!=params.length)
                throw new IllegalArgumentException("Parameter counter mis-match (expected="+paramTypes.length+",actual="+params.length+")");

            // TODO: Validate types
        }

        /** Execute */
        protected abstract FREObject execute(FREObject[] params) throws Exception;
    }

    // Instance variables

    /** Tag for logging */
    protected final String tag;

    /** Active Context */
    protected Context activeCtx;

    /** Functions */
    protected Map<String,FREFunction> functions;

    // Public methods

    /** Create new BaseANE */
    public BaseANE(String name)
    {
        this.tag="["+name+"]";
        this.functions=new HashMap<String,FREFunction>();
    }

    // FREExtension implementation

    /** Initialize */
    public void initialize()
    {
    }

    /** Dispose */
    public void dispose()
    {
    }

    /** Create Context */
    public FREContext createContext(String extId)
    {
        Log.d(tag,"Extension.createContext("+extId+")");

        this.activeCtx=new Context(this.functions);

        return this.activeCtx;
    }

    // Implementation

    /** Register function */
    protected void register(BaseFREFunction function)
    {
        Log.d(tag, "register("+function.name+")");

        this.functions.put(function.name,function);
    }

    /** Check active */
    protected boolean checkActive()
    {
        if (this.activeCtx==null)
        {
            Log.d(tag, "checkActive() failed");
            return false;
        }

        return true;
    }

    /** Reset active */
    protected void resetCtx()
    {
        Log.d(tag, "Reset context");

        this.activeCtx=null;
    }
}