module sampsdk.amx;

extern(C)
{
	__gshared AmxFunctions* pAMXFunctions;

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

	enum int AMX_USERNUM = 4;
	enum int sEXPMAX = 19;
	enum int sNAMEMAX = 31;
	enum uint AMX_MAGIC = 0xF1E0;
	enum int AMX_EXEC_MAIN = -1;
	enum int AMX_EXEC_CONT = -2;

	alias AmxAlign16_fn = ushort* function(ushort* v);
	alias AmxAlign32_fn = uint* function(uint* v);
	alias AmxAlign64_fn = ulong* function(ulong* v);
	alias AmxAllot_fn = int function(ref Amx amx, int cells, cell* amx_addr, cell** phys_addr);
	alias AmxCallback_fn = int function(ref Amx amx, cell index, cell* result, cell* params);
	alias AmxCleanup_fn = int function(ref Amx amx);
	alias AmxClone_fn = int function(ref Amx amxClone, ref Amx amxSource, void* data);
	alias AmxExec_fn = int function(ref Amx amx, cell* retval, int index);
	alias AmxFindNative_fn = int function(ref Amx amx, const char* name, int* index);
	alias AmxFindPublic_fn = int function(ref Amx amx, const char* funcname, int* index);
	alias AmxFindPubVar_fn = int function(ref Amx amx, const char* varname, cell* amx_addr);
	alias AmxFindTagId_fn = int function(ref Amx amx, cell tag_id, char* tagname);
	alias AmxFlags_fn = int function(ref Amx amx, ushort* flags);
	alias AmxGetAddr_fn = int function(ref Amx amx, cell amx_addr, cell** phys_addr);
	alias AmxGetNative_fn = int function(ref Amx amx, int index, char* funcname);
	alias AmxGetPublic_fn = int function(ref Amx amx, int index, char* funcname);
	alias AmxGetPubVar_fn = int function(ref Amx amx, int index, char* varname, cell* amx_addr);
	alias AmxGetString_fn = int function(char* dest,const cell* source, int use_wchar, size_t size);
	alias AmxGetTag_fn = int function(ref Amx amx, int index, char* tagname, cell* tag_id);
	alias AmxGetUserData_fn = int function(ref Amx amx, long tag, void** ptr);
	alias AmxInit_fn = int function(ref Amx amx, void* program);
	alias AmxInitJIT_fn = int function(ref Amx amx, void* reloc_table, void* native_code);
	alias AmxMemInfo_fn = int function(ref Amx amx, long* codesize, long* datasize, long* stackheap);
	alias AmxNameLength_fn = int function(ref Amx amx, int* length);
	alias AmxNativeInfo_fn = AmxNativeInfo* function(const char* name, AmxNative_fn func);
	alias AmxNumNatives_fn = int function(ref Amx amx, int* number);
	alias AmxNumPublics_fn = int function(ref Amx amx, int* number);
	alias AmxNumPubVars_fn = int function(ref Amx amx, int* number);
	alias AmxNumTags_fn = int function(ref Amx amx, int* number);
	alias AmxPush_fn = int function(ref Amx amx, cell value);
	alias AmxPushArray_fn = int function(ref Amx amx, cell* amx_addr, cell** phys_addr, const cell array[], int numcells);
	alias AmxPushString_fn = int function(ref Amx amx, cell* amx_addr, cell** phys_addr, const char* str, int pack, int use_wchar);
	alias AmxRaiseError_fn = int function(ref Amx amx, int error);
	alias AmxRegister_fn = int function(ref Amx amx, const AmxNativeInfo* nativelist, int number);
	alias AmxRelease_fn = int function(ref Amx amx, cell amx_addr);
	alias AmxSetCallback_fn = int function(ref Amx amx, AmxCallback_fn callback);
	alias AmxSetDebugHook_fn = int function(ref Amx amx, AmxDebug_fn dbg);
	alias AmxSetString_fn = int function(cell* dest, const char* source, int pack, int use_wchar, size_t size);
	alias AmxSetUserData_fn = int function(ref Amx amx, long tag, void* ptr);
	alias AmxStrLen_fn = int function(const cell* cstring, int* length);
	alias AmxUTF8Check_fn = int function(const char* str, int* length);
	alias AmxUTF8Get_fn = int function(const char* str, const char** endptr, cell* value);
	alias AmxUTF8Len_fn = int function(const cell* cstr, int* length);
	alias AmxUTF8Put_fn = int function(char* str, char** endptr, int maxchars, cell value);

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
		long usertags[AMX_USERNUM];
		void* userdata[AMX_USERNUM];
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
		char name[sEXPMAX+1];
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

	enum AmxError
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

	enum AmxFlag
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
		return pAMXFunctions.Align16(v);
	}

	@trusted
	uint* AmxAlign32(uint* v)
	{
		return pAMXFunctions.Align32(v);
	}

	@trusted
	ulong* AmxAlign64(ulong* v)
	{
		return pAMXFunctions.Align64(v);
	}

	@trusted
	int AmxRegister(ref Amx amx, const AmxNativeInfo[] nativelist, int number)
	{
		return pAMXFunctions.Register(amx, nativelist.ptr, number);
	}

	@trusted
	string AmxStrParam(ref Amx amx, cell param)
	{
		cell* amx_cstr;
		int amx_length;

		pAMXFunctions.GetAddr(amx, param, &amx_cstr);
		pAMXFunctions.StrLen(amx_cstr, &amx_length);
		
		if(amx_length)
		{
			char[] buf = new char[](amx_length + 1);
			pAMXFunctions.GetString(buf.ptr, amx_cstr, false, amx_length + 1);

			return cast(immutable(char[]))buf;
		}

		return null;
	}
}
