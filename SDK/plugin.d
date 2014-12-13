module sampsdk.plugin;

import sampsdk.amx;
import sampsdk.exception;

enum uint PLUGIN_VERSION = 0x200;

version(Posix)
{
	import core.runtime;
}
else version(Windows)
{
	import std.c.windows.windows;
	import core.sys.windows.dll;

	extern(Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
	{
		switch(ulReason)
		{
			case DLL_PROCESS_ATTACH:
				dll_process_attach(hInstance, true);
				break;

			case DLL_PROCESS_DETACH:
				dll_process_detach(hInstance, true);
				break;

			case DLL_THREAD_ATTACH:
				dll_thread_attach(true, true);
				break;

			case DLL_THREAD_DETACH:
				dll_thread_detach(true, true);
				break;

			default:
		}

		return true;
	}
}

extern(C)
{
	enum SupportsFlags
	{
		VERSION	= PLUGIN_VERSION,
		VERSION_MASK = 0xFFFF,
		AMX_NATIVES	= 0x10000,
		PROCESS_TICK = 0x20000
	};

	alias LogPrintf_fn = void function(immutable(char*) format, ...);

	align(1)
	struct PluginData
	{
		LogPrintf_fn logPrintf;
		void* lpUnknown[15];
		AmxFunctions* amxExports;
		void* fnCallPublicFS;
		void* fnCallPublicGM;
	}
}

class PluginInterface
{
	static if(PAWN_CELL_SIZE == 16)
		alias amxAlignCell = PluginInterface.AmxAlign16;

	else static if(PAWN_CELL_SIZE == 32)
		alias amxAlignCell = PluginInterface.amxAlign32;

	else static if(PAWN_CELL_SIZE == 64)
		alias amxAlignCell = PluginInterface.AmxAlign64;

	extern(C)
	{
		public const(LogPrintf_fn) print;
		private const(AmxFunctions*) m_rawAmxFunctions;
	}

	static PluginInterface Generate(ref PluginData data)
	{
		initializeRuntime();
		return new PluginInterface(data);
	}

	this(ref PluginData data)
	{
		print = data.logPrintf;
		m_rawAmxFunctions = data.amxExports;
	}

	~this()
	{
		terminateRuntime();
	}

	@property
	public const(AmxFunctions*) rawAmxFunctions()
	{
		return m_rawAmxFunctions;
	}

	private static void initializeRuntime()
	{
		version(Posix)
		{
			Runtime.initialize();
		}
	}

	private static void terminateRuntime()
	{
		version(Posix)
		{
			Runtime.terminate();
		}
	}

	extern(C)
	{
		@trusted
		public ushort* amxAlign16(ushort* v)
		{
			return m_rawAmxFunctions.Align16(v);
		}

		@trusted
		public uint* amxAlign32(uint* v)
		{
			return m_rawAmxFunctions.Align32(v);
		}

		@trusted
		public ulong* amxAlign64(ulong* v)
		{
			return m_rawAmxFunctions.Align64(v);
		}

		@trusted
		public void amxRegister(ref Amx amx, const AmxNativeInfo[] nativelist, int number)
		{
			AmxNativeInfo[] nativelist_safe = nativelist.dup;
			nativelist_safe ~= AmxNativeInfo(null, null);
			AmxError error = m_rawAmxFunctions.Register(amx, nativelist_safe.ptr, number);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public string amxStrParam(ref Amx amx, cell param)
		{
			cell* amx_cstr;
			int amx_length;
			AmxError error;

			if((error = m_rawAmxFunctions.GetAddr(amx, param, &amx_cstr)) != 0 || (error = m_rawAmxFunctions.StrLen(amx_cstr, &amx_length)) != 0)
				throw new AmxException(error);

			if(amx_length)
			{
				char[] buf = new char[](amx_length + 1);

				if((error = m_rawAmxFunctions.GetString(buf.ptr, amx_cstr, false, amx_length + 1)) != 0)
					throw new AmxException(error);

				return cast(immutable(char[]))buf;
			}

			return null;
		}

		@trusted
		public void amxRegisterFunc(ref Amx amx, string name, AmxNative_fn func)
		{
			AmxError error = m_rawAmxFunctions.Register(amx, m_rawAmxFunctions.NativeInfo(name.ptr, func), 1);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public int amxFindNative(ref Amx amx, string name)
		{
			int index;
			AmxError error = m_rawAmxFunctions.FindNative(amx, name.ptr, &index);

			if(error)
				throw new AmxException(error);

			return index;
		}

		@trusted
		public int amxFindPublic(ref Amx amx, string name)
		{
			int index;
			AmxError error = m_rawAmxFunctions.FindPublic(amx, name.ptr, &index);

			if(error)
				throw new AmxException(error);

			return index;
		}

		@trusted
		public cell amxFindPubVar(ref Amx amx, string varname)
		{
			cell amx_addr;

			AmxError error = m_rawAmxFunctions.FindPubVar(amx, varname.ptr, &amx_addr);

			if(error)
				throw new AmxException(error);

			return amx_addr;
		}

		@trusted
		public cell amxCallback(ref Amx amx, cell index, cell* params)
		{
			cell result;
			AmxError error = m_rawAmxFunctions.Callback(amx, index, &result, params);

			if(error)
				throw new AmxException(error);

			return result;
		}

		@trusted
		public void amxCleanup(ref Amx amx)
		{
			AmxError error = m_rawAmxFunctions.Cleanup(amx);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxClone(ref Amx amxClone, ref Amx amxSource, void* data)
		{
			AmxError error = m_rawAmxFunctions.Clone(amxClone, amxSource, data);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public cell amxExec(ref Amx amx, int index)
		{
			cell retval;
			AmxError error = m_rawAmxFunctions.Exec(amx, &retval, index);

			if(error)
				throw new AmxException(error);

			return retval;
		}

		@trusted
		public string amxFindTagId(ref Amx amx, cell tag_id, size_t len)
		{
			char[] str = new char[](len);
			AmxError error = m_rawAmxFunctions.FindTagId(amx, tag_id, str.ptr);

			if(error)
				throw new AmxException(error);

			return cast(string)str;
		}

		@trusted
		public AmxFlags amxGetFlags(ref Amx amx)
		{
			AmxFlags flags;
			AmxError error = m_rawAmxFunctions.Flags(amx, &flags);

			if(error)
				throw new AmxException(error);

			return flags;
		}

		@trusted
		public cell* amxGetAddr(ref Amx amx, cell amx_addr)
		{
			cell* phys_addr;
			AmxError error = m_rawAmxFunctions.GetAddr(amx, amx_addr, &phys_addr);

			if(error)
				throw new AmxException(error);

			return phys_addr;
		}

		@trusted
		public string amxGetNative(ref Amx amx, int index, size_t len)
		{
			char[] funcname = new char[](len);
			AmxError error = m_rawAmxFunctions.GetNative(amx, index, funcname.ptr);

			if(error)
				throw new AmxException(error);

			return cast(string)funcname;
		}

		@trusted
		public string amxGetPublic(ref Amx amx, int index, size_t len)
		{
			char[] funcname = new char[](len);
			AmxError error = m_rawAmxFunctions.GetPublic(amx, index, funcname.ptr);

			if(error)
				throw new AmxException(error);

			return cast(string)funcname;
		}

		@trusted
		public string amxGetPubVar(ref Amx amx, int index, out cell amx_addr, size_t len)
		{
			char[] varname = new char[](len);
			AmxError error = m_rawAmxFunctions.GetPubVar(amx, index, varname.ptr, &amx_addr);

			if(error)
				throw new AmxException(error);

			return cast(string)varname;
		}

		@trusted
		public string amxGetString(const cell* source, bool use_wchar, size_t size)
		{
			char[] dest = new char[](size);
			AmxError error = m_rawAmxFunctions.GetString(dest.ptr, source, use_wchar, size);

			if(error)
				throw new AmxException(error);

			return cast(string)dest;
		}

		@trusted
		public AmxTagInfo amxGetTag(ref Amx amx, int index, size_t len)
		{
			cell tag_id;
			char[] tagname = new char[](len);
			AmxError error = m_rawAmxFunctions.GetTag(amx, index, tagname.ptr, &tag_id);

			if(error)
				throw new AmxException(error);

			return AmxTagInfo(cast(string)tagname, tag_id);
		}

		@trusted
		public void* amxGetUserData(ref Amx amx, long tag)
		{
			void* ptr;
			AmxError error = m_rawAmxFunctions.GetUserData(amx, tag, &ptr);

			if(error)
				throw new AmxException(error);

			return ptr;
		}

		@trusted
		public void amxInit(ref Amx amx, void* program)
		{
			AmxError error = m_rawAmxFunctions.Init(amx, program);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxInitJIT(ref Amx amx, void* reloc_table, void* native_code)
		{
			AmxError error = m_rawAmxFunctions.InitJIT(amx, reloc_table, native_code);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public AmxMemInfo amxGetMemInfo(ref Amx amx)
		{
			AmxMemInfo memInfo;
			AmxError error = m_rawAmxFunctions.MemInfo(amx, &(memInfo.codesize), &(memInfo.datasize), &(memInfo.stackheap));

			if(error)
				throw new AmxException(error);

			return memInfo;
		}

		@trusted
		public int amxNameLength(ref Amx amx)
		{
			int length;
			AmxError error = m_rawAmxFunctions.NameLength(amx, &length);

			if(error)
				throw new AmxException(error);

			return length;
		}

		@trusted
		public AmxNativeInfo* amxGetNativeInfo(string name, AmxNative_fn func)
		{
			return m_rawAmxFunctions.NativeInfo(name.ptr, func);
		}

		@trusted
		public int amxNumNatives(ref Amx amx)
		{
			int number;
			AmxError error = m_rawAmxFunctions.NumNatives(amx, &number);

			if(error)
				throw new AmxException(error);

			return number;
		}

		@trusted
		public int amxNumPublics(ref Amx amx)
		{
			int number;
			AmxError error = m_rawAmxFunctions.NumPublics(amx, &number);

			if(error)
				throw new AmxException(error);

			return number;
		}

		@trusted
		public int amxNumPubVars(ref Amx amx)
		{
			int number;
			AmxError error = m_rawAmxFunctions.NumPubVars(amx, &number);

			if(error)
				throw new AmxException(error);

			return number;
		}

		@trusted
		public int amxNumTags(ref Amx amx)
		{
			int number;
			AmxError error = m_rawAmxFunctions.NumTags(amx, &number);

			if(error)
				throw new AmxException(error);

			return number;
		}

		@trusted
		public void amxPush(ref Amx amx, cell value)
		{
			AmxError error = m_rawAmxFunctions.Push(amx, value);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public cell amxPushString(ref Amx amx, cell** phys_addr, string str, bool pack, bool use_wchar)
		{
			cell amx_addr;
			AmxError error = m_rawAmxFunctions.PushString(amx, &amx_addr, phys_addr, str.ptr, pack, use_wchar);

			if(error)
				throw new AmxException(error);

			return amx_addr;
		}

		@trusted
		public cell amxPushArray(ref Amx amx, cell** phys_addr, const cell[] array, int numcells)
		{
			cell amx_addr;
			AmxError error = m_rawAmxFunctions.PushArray(amx, &amx_addr, phys_addr, array.ptr, numcells);

			if(error)
				throw new AmxException(error);

			return amx_addr;
		}

		@trusted
		public void amxRaiseError(ref Amx amx, int error_code)
		{
			AmxError error = m_rawAmxFunctions.RaiseError(amx, error_code);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxRelease(ref Amx amx, cell amx_addr)
		{
			AmxError error = m_rawAmxFunctions.Release(amx, amx_addr);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxSetCallback(ref Amx amx, AmxCallback_fn callback)
		{
			AmxError error = m_rawAmxFunctions.SetCallback(amx, callback);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxSetDebugHook(ref Amx amx, AmxDebug_fn dbg)
		{
			AmxError error = m_rawAmxFunctions.SetDebugHook(amx, dbg);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxSetString(cell* dest, string source, bool pack, bool use_wchar, size_t size)
		{
			AmxError error = m_rawAmxFunctions.SetString(dest, source.ptr, pack, use_wchar, size);

			if(error)
				throw new AmxException(error);

		}

		@trusted
		public void amxSetUserData(ref Amx amx, long tag, void* ptr)
		{
			AmxError error = m_rawAmxFunctions.SetUserData(amx, tag, ptr);

			if(error)
				throw new AmxException(error);

		}

		@trusted 
		public int amxStrLen(const ref cell cstring)
		{
			int length;
			AmxError error = m_rawAmxFunctions.StrLen(&cstring, &length);

			if(error)
				throw new AmxException(error);

			return length;
		}

		@trusted
		public cell amxAllot(ref Amx amx, int cells, cell** phys_addr)
		{
			cell amx_addr;
			AmxError error = m_rawAmxFunctions.Allot(amx, cells, &amx_addr, phys_addr);

			if(error)
				throw new AmxException(error);

			return amx_addr;
		}

		@trusted
		public int amxUTF8Check(string str)
		{
			int length;
			AmxError error = m_rawAmxFunctions.UTF8Check(str.ptr, &length);

			if(error)
				throw new AmxException(error);

			return length;
		}

		@trusted
		public cell amxUTF8Get(const char* str, const char** endptr)
		{
			cell value;
			AmxError error = m_rawAmxFunctions.UTF8Get(str, endptr, &value);

			if(error)
				throw new AmxException(error);

			return value;
		}

		@trusted
		public int amxUTF8Len(const ref cell cstr)
		{
			int length;
			AmxError error = m_rawAmxFunctions.UTF8Len(&cstr, &length);

			if(error)
				throw new AmxException(error);

			return length;
		}

		@trusted
		public void amxUTF8Put(char* str, char** endptr, int maxchars, cell value)
		{
			AmxError error = m_rawAmxFunctions.UTF8Put(str, endptr, maxchars, value);

			if(error)
				throw new AmxException(error);

		}
	}
}