module sampsdk.amx;

extern(C)
{
	__gshared AmxFunctions* RawAmxFunctions;

	enum uint PAWN_CELL_SIZE = 32;

	static if(PAWN_CELL_SIZE == 16)
	{
		alias ucell = ushort;
		alias cell = short;
		alias AmxAlignCell = AmxAlign16;
	}
	else static if(PAWN_CELL_SIZE == 32)
	{
		alias ucell = uint;
		alias cell = int;
		alias AmxAlignCell = AmxAlign32;
	}
	else static if(PAWN_CELL_SIZE == 64)
	{
		alias ucell = ulong;
		alias cell = long;
		alias AmxAlignCell = AmxAlign64;
	}

	enum AmxData
	{
		USERNUM = 4,
		EXPMAX = 19,
		NAMEMAX = 31,
		MAGIC = 0xF1E0,
		EXEC_MAIN = -1,
		EXEC_CONT = -2
	}

	alias AmxAlign16_fn = ushort* function(ushort* v);
	alias AmxAlign32_fn = uint* function(uint* v);    
	alias AmxAlign64_fn = ulong* function(ulong* v);  
	alias AmxAllot_fn = AmxError function(ref Amx amx, int cells, cell* amx_addr, cell** phys_addr);
	alias AmxCallback_fn = AmxError function(ref Amx amx, cell index, cell* result, cell* params);
	alias AmxCleanup_fn = AmxError function(ref Amx amx);
	alias AmxClone_fn = AmxError function(ref Amx amxClone, ref Amx amxSource, void* data);
	alias AmxExec_fn = AmxError function(ref Amx amx, cell* retval, int index);
	alias AmxFindNative_fn = AmxError function(ref Amx amx, const char* name, int* index);
	alias AmxFindPublic_fn = AmxError function(ref Amx amx, const char* funcname, int* index);
	alias AmxFindPubVar_fn = AmxError function(ref Amx amx, const char* varname, cell* amx_addr);
	alias AmxFindTagId_fn = AmxError function(ref Amx amx, cell tag_id, immutable(char*) tagname);
	alias AmxFlags_fn = AmxError function(ref Amx amx, AmxFlags* flags);
	alias AmxGetAddr_fn = AmxError function(ref Amx amx, cell amx_addr, cell** phys_addr);
	alias AmxGetNative_fn = AmxError function(ref Amx amx, int index, char* funcname);
	alias AmxGetPublic_fn = AmxError function(ref Amx amx, int index, char* funcname);
	alias AmxGetPubVar_fn = AmxError function(ref Amx amx, int index, char* varname, cell* amx_addr);
	alias AmxGetString_fn = AmxError function(char* dest,const cell* source, int use_wchar, size_t size);
	alias AmxGetTag_fn = AmxError function(ref Amx amx, int index, char* tagname, cell* tag_id);
	alias AmxGetUserData_fn = AmxError function(ref Amx amx, long tag, void** ptr);
	alias AmxInit_fn = AmxError function(ref Amx amx, void* program);
	alias AmxInitJIT_fn = AmxError function(ref Amx amx, void* reloc_table, void* native_code);
	alias AmxMemInfo_fn = AmxError function(ref Amx amx, long* codesize, long* datasize, long* stackheap);
	alias AmxNameLength_fn = AmxError function(ref Amx amx, int* length);
	alias AmxNativeInfo_fn = AmxNativeInfo* function(const char* name, AmxNative_fn func);
	alias AmxNumNatives_fn = AmxError function(ref Amx amx, int* number);
	alias AmxNumPublics_fn = AmxError function(ref Amx amx, int* number);
	alias AmxNumPubVars_fn = AmxError function(ref Amx amx, int* number);
	alias AmxNumTags_fn = AmxError function(ref Amx amx, int* number);
	alias AmxPush_fn = AmxError function(ref Amx amx, cell value);
	alias AmxPushArray_fn = AmxError function(ref Amx amx, cell* amx_addr, cell** phys_addr, const cell* array, int numcells);
	alias AmxPushString_fn = AmxError function(ref Amx amx, cell* amx_addr, cell** phys_addr, const char* str, int pack, int use_wchar);
	alias AmxRaiseError_fn = AmxError function(ref Amx amx, int error);
	alias AmxRegister_fn = AmxError function(ref Amx amx, const AmxNativeInfo* nativelist, int number);
	alias AmxRelease_fn = AmxError function(ref Amx amx, cell amx_addr);
	alias AmxSetCallback_fn = AmxError function(ref Amx amx, AmxCallback_fn callback);
	alias AmxSetDebugHook_fn = AmxError function(ref Amx amx, AmxDebug_fn dbg);
	alias AmxSetString_fn = AmxError function(cell* dest, const char* source, int pack, int use_wchar, size_t size);
	alias AmxSetUserData_fn = AmxError function(ref Amx amx, long tag, void* ptr);
	alias AmxStrLen_fn = AmxError function(const cell* cstring, int* length);
	alias AmxUTF8Check_fn = AmxError function(const char* str, int* length);
	alias AmxUTF8Get_fn = AmxError function(const char* str, const char** endptr, cell* value);
	alias AmxUTF8Len_fn = AmxError function(const cell* cstr, int* length);
	alias AmxUTF8Put_fn = AmxError function(char* str, char** endptr, int maxchars, cell value);

	align(1)
	struct AmxFunctions
	{
		AmxAlign16_fn Align16;
		AmxAlign32_fn Align32;
		AmxAlign64_fn Align64;
		AmxAllot_fn Allot;
		AmxCallback_fn Callback;
		AmxCleanup_fn Cleanup;
		AmxClone_fn Clone;
		AmxExec_fn Exec;
		AmxFindNative_fn FindNative;
		AmxFindPublic_fn FindPublic;
		AmxFindPubVar_fn FindPubVar;
		AmxFindTagId_fn FindTagId;
		AmxFlags_fn Flags;
		AmxGetAddr_fn GetAddr;
		AmxGetNative_fn GetNative;
		AmxGetPublic_fn GetPublic;
		AmxGetPubVar_fn GetPubVar;
		AmxGetString_fn GetString;
		AmxGetTag_fn GetTag;
		AmxGetUserData_fn GetUserData;
		AmxInit_fn Init;
		AmxInitJIT_fn InitJIT;
		AmxMemInfo_fn MemInfo;
		AmxNameLength_fn NameLength;
		AmxNativeInfo_fn NativeInfo;
		AmxNumNatives_fn NumNatives;
		AmxNumPublics_fn NumPublics;
		AmxNumPubVars_fn NumPubVars;
		AmxNumTags_fn NumTags;
		AmxPush_fn Push;
		AmxPushArray_fn PushArray;
		AmxPushString_fn PushString;
		AmxRaiseError_fn RaiseError;
		AmxRegister_fn Register;
		AmxRelease_fn Release;
		AmxSetCallback_fn SetCallback;
		AmxSetDebugHook_fn SetDebugHook;
		AmxSetString_fn SetString;
		AmxSetUserData_fn SetUserData;
		AmxStrLen_fn StrLen;
		AmxUTF8Check_fn UTF8Check;
		AmxUTF8Get_fn UTF8Get;
		AmxUTF8Len_fn UTF8Len;
		AmxUTF8Put_fn UTF8Put;
	}

	alias AmxDebug_fn = int function(ref Amx amx);
	alias AmxNative_fn = cell function(ref Amx amx, cell* params);

	struct Amx
	{
		ubyte* base;
		ubyte* data;
		AmxCallback_fn callback;
		AmxDebug_fn dbg;
		cell cip;
		cell frm;
		cell hea;
		cell hlw;
		cell stk;
		cell stp;
		int flags;
		long usertags[AmxData.USERNUM];
		void* userdata[AmxData.USERNUM];
		int error;
		int paramcount;
		cell pri;
		cell alt;
		cell reset_stk;
		cell reset_hea;
		cell sysreq_d;
	}

	struct AmxNativeInfo
	{
		immutable(char*) name;
		AmxNative_fn func;
	}

	struct AmxFuncStub
	{
		ucell address;
		char name[AmxData.EXPMAX+1];
	}

	struct AmxFuncStubNT
	{
		ucell address;
		int nameofs;
	}

	struct AmxHeader
	{
		int size;
		ushort magic;
		char file_version;
		char amx_version;
		short flags;
		short defsize;
		int cod;
		int dat;
		int hea;
		int stp;
		int cip;
		int publics;
		int natives;
		int libraries;
		int pubvars;
		int tags;
		int nametable;
	}

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

	enum AmxFlags : short
	{
		DEBUG = 0x02,
		COMPACT = 0x04,
		BYTEOPC = 0x08,
		NOCHECKS = 0x10,
		NTVREG = 0x1000,
		JITC = 0x2000,
		BROWSE = 0x4000,
		RELOC = 8000
	}

	@trusted
	cell AmxFtoc(float fl)
	{
		return *(cast(cell*)&fl);
	}

	@trusted
	float AmxCtof(cell cl)
	{
		static if(PAWN_CELL_SIZE == 32)
		{
			return *(cast(float*)&cl);
		}
		else static if(PAWN_CELL_SIZE == 64)
		{
			return *(cast(double*)&cl);
		}
	}

	@trusted
	ushort* AmxAlign16(ushort* v)
	{
		return RawAmxFunctions.Align16(v);
	}

	@trusted
	uint* AmxAlign32(uint* v)
	{
		return RawAmxFunctions.Align32(v);
	}

	@trusted
	ulong* AmxAlign64(ulong* v)
	{
		return RawAmxFunctions.Align64(v);
	}

	@trusted
	AmxError AmxRegister(ref Amx amx, const AmxNativeInfo[] nativelist, int number)
	{
		return RawAmxFunctions.Register(amx, nativelist.ptr, number);
	}

	@trusted
	string AmxStrParam(ref Amx amx, cell param)
	{
		cell* amx_cstr;
		int amx_length;

		RawAmxFunctions.GetAddr(amx, param, &amx_cstr);
		RawAmxFunctions.StrLen(amx_cstr, &amx_length);
		
		if(amx_length)
		{
			char[] buf = new char[](amx_length + 1);
			RawAmxFunctions.GetString(buf.ptr, amx_cstr, false, amx_length + 1);

			return cast(immutable(char[]))buf;
		}

		return null;
	}

	@trusted
	AmxError AmxRegisterFunc(ref Amx amx, string name, AmxNative_fn func)
	{
		return RawAmxFunctions.Register(amx, RawAmxFunctions.NativeInfo(name.ptr, func), 1);
	}

	@trusted
	AmxError AmxFindNative(ref Amx amx, string name, out int index)
	{
		return RawAmxFunctions.FindNative(amx, name.ptr, &index);
	}

	@trusted
	AmxError AmxFindPublic(ref Amx amx, string name, out int index)
	{
		return RawAmxFunctions.FindPublic(amx, name.ptr, &index);
	}

	@trusted
	AmxError AmxFindPubVar(ref Amx amx, string varname, out cell amx_addr)
	{
		return RawAmxFunctions.FindPubVar(amx, varname.ptr, &amx_addr);
	}

	@trusted
	AmxError AmxCallback(ref Amx amx, cell index, out cell result, cell* params)
	{
		return RawAmxFunctions.Callback(amx, index, &result, params);
	}

	@trusted
	AmxError AmxCleanup(ref Amx amx)
	{
		return RawAmxFunctions.Cleanup(amx);
	}

	@trusted
	AmxError AmxClone(ref Amx amxClone, ref Amx amxSource, void* data)
	{
		return RawAmxFunctions.Clone(amxClone, amxSource, data);
	}

	@trusted
	AmxError AmxExec(ref Amx amx, out cell retval, int index)
	{
		return RawAmxFunctions.Exec(amx, &retval, index);
	}

	@trusted
	AmxError AmxFindTagId(ref Amx amx, cell tag_id, string tagname)
	{
		return RawAmxFunctions.FindTagId(amx, tag_id, tagname.ptr);
	}

	@trusted
	AmxError AmxGetFlags(ref Amx amx, out AmxFlags flags)
	{
		return RawAmxFunctions.Flags(amx, &flags);
	}

	@trusted
	AmxError AmxGetAddr(ref Amx amx, cell amx_addr, out cell* phys_addr)
	{
		return RawAmxFunctions.GetAddr(amx, amx_addr, &phys_addr);
	}

	@trusted
	AmxError AmxGetNative(ref Amx amx, int index, char[] funcname)
	{
		return RawAmxFunctions.GetNative(amx, index, funcname.ptr);
	}

	@trusted
	AmxError AmxGetPublic(ref Amx amx, int index, char[] funcname)
	{
		return RawAmxFunctions.GetPublic(amx, index, funcname.ptr);
	}

	@trusted
	AmxError AmxGetPubVar(ref Amx amx, int index, char[] varname, out cell amx_addr)
	{
		return RawAmxFunctions.GetPubVar(amx, index, varname.ptr, &amx_addr);
	}

	@trusted
	AmxError AmxGetString(char[] dest, const cell* source, int use_wchar, size_t size)
	{
		return RawAmxFunctions.GetString(dest.ptr, source, use_wchar, size);
	}

	@trusted
	AmxError AmxGetTag(ref Amx amx, int index, char[] tagname, out cell tag_id)
	{
		return RawAmxFunctions.GetTag(amx, index, tagname.ptr, &tag_id);
	}

	@trusted
	AmxError AmxGetUserData(ref Amx amx, long tag, out void* ptr)
	{
		return RawAmxFunctions.GetUserData(amx, tag, &ptr);
	}

	@trusted
	AmxError AmxInit(ref Amx amx, void* program)
	{
		return RawAmxFunctions.Init(amx, program);
	}

	@trusted
	AmxError AmxInitJIT(ref Amx amx, void* reloc_table, void* native_code)
	{
		return RawAmxFunctions.InitJIT(amx, reloc_table, native_code);
	}

	@trusted
	AmxError AmxMemInfo(ref Amx amx, out long codesize, out long datasize, out long stackheap)
	{
		return RawAmxFunctions.MemInfo(amx, &codesize, &datasize, &stackheap);
	}

	@trusted
	AmxError AmxNameLength(ref Amx amx, out int length)
	{
		return RawAmxFunctions.NameLength(amx, &length);
	}

	@trusted
	AmxNativeInfo* AmxGetNativeInfo(string name, AmxNative_fn func)
	{
		return RawAmxFunctions.NativeInfo(name.ptr, func);
	}

	@trusted
	AmxError AmxNumNatives(ref Amx amx, ref int number)
	{
		return RawAmxFunctions.NumNatives(amx, &number);
	}

	@trusted
	AmxError AmxNumPublics(ref Amx amx, ref int number)
	{
		return RawAmxFunctions.NumPublics(amx, &number);
	}

	@trusted
	AmxError AmxNumPubVars(ref Amx amx, ref int number)
	{
		return RawAmxFunctions.NumPubVars(amx, &number);
	}

	@trusted
	AmxError AmxNumTags(ref Amx amx, ref int number)
	{
		return RawAmxFunctions.NumTags(amx, &number);
	}

	@trusted
	AmxError AmxPush(ref Amx amx, cell value)
	{
		return RawAmxFunctions.Push(amx, value);
	}

	@trusted
	AmxError AmxPushString(ref Amx amx, ref cell amx_addr, cell** phys_addr, string str, int pack, int use_wchar)
	{
		return RawAmxFunctions.PushString(amx, &amx_addr, phys_addr, str.ptr, pack, use_wchar);
	}

	@trusted
	AmxError AmxPushArray(ref Amx amx, ref cell amx_addr, cell** phys_addr, const cell[] array, int numcells)
	{
		return RawAmxFunctions.PushArray(amx, &amx_addr, phys_addr, array.ptr, numcells);
	}

	@trusted
	AmxError AmxRaiseError(ref Amx amx, int error)
	{
		return RawAmxFunctions.RaiseError(amx, error);
	}

	@trusted
	AmxError AmxRelease(ref Amx amx, cell amx_addr)
	{
		return RawAmxFunctions.Release(amx, amx_addr);
	}

	@trusted
	AmxError AmxSetCallback(ref Amx amx, AmxCallback_fn callback)
	{
		return RawAmxFunctions.SetCallback(amx, callback);
	}

	@trusted
	AmxError AmxSetDebugHook(ref Amx amx, AmxDebug_fn dbg)
	{
		return RawAmxFunctions.SetDebugHook(amx, dbg);
	}

	@trusted
	AmxError AmxSetString(ref cell dest, string source, int pack, int use_wchar, size_t size)
	{
		return RawAmxFunctions.SetString(&dest, source.ptr, pack, use_wchar, size);
	}

	@trusted
	AmxError AmxSetUserData(ref Amx amx, long tag, void* ptr)
	{
		return RawAmxFunctions.SetUserData(amx, tag, ptr);
	}

	@trusted 
	AmxError AmxStrLen(const ref cell cstring, out int length)
	{
		return RawAmxFunctions.StrLen(&cstring, &length);
	}

	@trusted
	AmxError AmxAllot(ref Amx amx, int cells, out cell amx_addr, cell** phys_addr)
	{
		return RawAmxFunctions.Allot(amx, cells, &amx_addr, phys_addr);
	}

	@trusted
	AmxError AmxUTF8Check(string str, out int length)
	{
		return RawAmxFunctions.UTF8Check(str.ptr, &length);
	}

	@trusted
	AmxError AmxUTF8Get(const char* str, const char** endptr, out cell value)
	{
		return RawAmxFunctions.UTF8Get(str, endptr, &value);
	}

	@trusted
	AmxError AmxUTF8Len(const ref cell cstr, out int length)
	{
		return RawAmxFunctions.UTF8Len(&cstr, &length);
	}

	@trusted
	AmxError AmxUTF8Put(char* str, char** endptr, int maxchars, cell value)
	{
		return RawAmxFunctions.UTF8Put(str, endptr, maxchars, value);
	}
}
