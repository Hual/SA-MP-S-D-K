module sampsdk.exception;

enum AmxError : int
{
	NONE,
	EXIT,
	ASSERT,
	STACKERR,
	BOUNDS,
	MEMACCESS,
	INVINSTR,
	STACKLOW,
	HEAPLOW,
	CALLBACK,
	NATIVE,
	DIVIDE,
	SLEEP,
	INVSTATE,
	MEMORY = 16,
	FORMAT,
	VERSION,
	NOTFOUND,
	INDEX,
	DEBUG,
	INIT,
	USERDATA,
	INIT_JIT,
	PARAMS,
	DOMAIN,
	GENERAL,
};

string[] AmxErrorString = 
[
	AmxError.NONE : "Success",
	AmxError.EXIT : "Forced exit",
	AmxError.ASSERT : "Assertion failed",
	AmxError.STACKERR : "Stack/heap collision",
	AmxError.BOUNDS : "Index out of bounds",
	AmxError.MEMACCESS : "Invalid memory access",
	AmxError.INVINSTR : "Invalid instruction",
	AmxError.STACKLOW : "Stack underflow",
	AmxError.HEAPLOW : "Heap underflow",
	AmxError.CALLBACK : "No callback, or invalid callback",
	AmxError.NATIVE : "Native function failed",
	AmxError.DIVIDE : "Divide by zero",
	AmxError.SLEEP : "Go into sleepmode",
	AmxError.INVSTATE : "Invalid state for this access",
	AmxError.MEMORY : "Out of memory",
	AmxError.FORMAT : "Invalid file format",
	AmxError.VERSION : "File is for a newer version of the AMX",
	AmxError.NOTFOUND : "Function not found",
	AmxError.INDEX : "Bad entry point",
	AmxError.DEBUG : "Debugger cannot run",
	AmxError.INIT : "AMX not initialized",
	AmxError.USERDATA : "Unable to set user data field",
	AmxError.INIT_JIT : "Cannot initialize the JIT",
	AmxError.PARAMS : "Parameter error",
	AmxError.DOMAIN : "Domain error",
	AmxError.GENERAL : "General error"
];

class AmxException : Exception
{
	protected AmxError m_error;

	this(AmxError error, string file = __FILE__, size_t line = __LINE__, Throwable next = null)
	{
		super(AmxErrorString[error], file, line, next);
		m_error = error;
	}
		
	@trusted override const string toString()
    {
        return msg ? (cast()super).toString() : getErrorString();
    }

	@safe const string getErrorString()
	{
		return AmxErrorString[m_error];
	}

	@trusted const AmxError getError()
	{
		return m_error;
	}
}