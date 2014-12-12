module sampsdk.amx;

import sampsdk.exception;

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
	alias AmxFindTagId_fn = AmxError function(ref Amx amx, cell tag_id, /*const*/ char* tagname);
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

	struct AmxMemInfo
	{
		long codesize;
		long datasize;
		long stackheap;
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
	void AmxRegister(ref Amx amx, const AmxNativeInfo[] nativelist, int number)
	{
		AmxError error = RawAmxFunctions.Register(amx, nativelist.ptr, number);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	string AmxStrParam(ref Amx amx, cell param)
	{
		cell* amx_cstr;
		int amx_length;
		AmxError error;

		if((error = RawAmxFunctions.GetAddr(amx, param, &amx_cstr)) != 0 || (error = RawAmxFunctions.StrLen(amx_cstr, &amx_length)) != 0)
			throw new AmxException(error);
		
		if(amx_length)
		{
			char[] buf = new char[](amx_length + 1);
			
			if((error = RawAmxFunctions.GetString(buf.ptr, amx_cstr, false, amx_length + 1)) != 0)
				throw new AmxException(error);

			return cast(immutable(char[]))buf;
		}

		return null;
	}

	@trusted
	void AmxRegisterFunc(ref Amx amx, string name, AmxNative_fn func)
	{
		AmxError error = RawAmxFunctions.Register(amx, RawAmxFunctions.NativeInfo(name.ptr, func), 1);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	int AmxFindNative(ref Amx amx, string name)
	{
		int index;
		AmxError error = RawAmxFunctions.FindNative(amx, name.ptr, &index);

		if(error)
			throw new AmxException(error);
		
		return index;
	}

	@trusted
	int AmxFindPublic(ref Amx amx, string name)
	{
		int index;
		AmxError error = RawAmxFunctions.FindPublic(amx, name.ptr, &index);

		if(error)
			throw new AmxException(error);

		return index;
	}

	@trusted
	cell AmxFindPubVar(ref Amx amx, string varname)
	{
		cell amx_addr;

		AmxError error = RawAmxFunctions.FindPubVar(amx, varname.ptr, &amx_addr);

		if(error)
			throw new AmxException(error);

		return amx_addr;
	}

	@trusted
	cell AmxCallback(ref Amx amx, cell index, cell* params)
	{
		cell result;
		AmxError error = RawAmxFunctions.Callback(amx, index, &result, params);

		if(error)
			throw new AmxException(error);

		return result;
	}

	@trusted
	void AmxCleanup(ref Amx amx)
	{
		AmxError error = RawAmxFunctions.Cleanup(amx);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxClone(ref Amx amxClone, ref Amx amxSource, void* data)
	{
		AmxError error = RawAmxFunctions.Clone(amxClone, amxSource, data);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	cell AmxExec(ref Amx amx, int index)
	{
		cell retval;
		AmxError error = RawAmxFunctions.Exec(amx, &retval, index);

		if(error)
			throw new AmxException(error);

		return retval;
	}

	@trusted
	string AmxFindTagId(ref Amx amx, cell tag_id, size_t len)
	{
		char[] str = new char[](len);
		AmxError error = RawAmxFunctions.FindTagId(amx, tag_id, str.ptr);

		if(error)
			throw new AmxException(error);

		return cast(string)str;
	}

	@trusted
	AmxFlags AmxGetFlags(ref Amx amx)
	{
		AmxFlags flags;
		AmxError error = RawAmxFunctions.Flags(amx, &flags);

		if(error)
			throw new AmxException(error);

		return flags;
	}

	@trusted
	cell* AmxGetAddr(ref Amx amx, cell amx_addr)
	{
		cell* phys_addr;
		AmxError error = RawAmxFunctions.GetAddr(amx, amx_addr, &phys_addr);

		if(error)
			throw new AmxException(error);

		return phys_addr;
	}

	@trusted
	string AmxGetNative(ref Amx amx, int index, size_t len)
	{
		char[] funcname = new char[](len);
		AmxError error = RawAmxFunctions.GetNative(amx, index, funcname.ptr);

		if(error)
			throw new AmxException(error);

		return cast(string)funcname;
	}

	@trusted
	string AmxGetPublic(ref Amx amx, int index, size_t len)
	{
		char[] funcname = new char[](len);
		AmxError error = RawAmxFunctions.GetPublic(amx, index, funcname.ptr);

		if(error)
			throw new AmxException(error);

		return cast(string)funcname;
	}

	@trusted
	string AmxGetPubVar(ref Amx amx, int index, out cell amx_addr, size_t len)
	{
		char[] varname = new char[](len);
		AmxError error = RawAmxFunctions.GetPubVar(amx, index, varname.ptr, &amx_addr);

		if(error)
			throw new AmxException(error);

		return cast(string)varname;
	}

	@trusted
	string AmxGetString(const cell* source, bool use_wchar, size_t size)
	{
		char[] dest = new char[](size);
		AmxError error = RawAmxFunctions.GetString(dest.ptr, source, use_wchar, size);

		if(error)
			throw new AmxException(error);

		return cast(string)dest;
	}

	@trusted
	string AmxGetTag(ref Amx amx, int index, out cell tag_id, size_t len)
	{
		char[] tagname = new char[](len);
		AmxError error = RawAmxFunctions.GetTag(amx, index, tagname.ptr, &tag_id);

		if(error)
			throw new AmxException(error);

		return cast(string)tagname;
	}

	@trusted
	void* AmxGetUserData(ref Amx amx, long tag)
	{
		void* ptr;
		AmxError error = RawAmxFunctions.GetUserData(amx, tag, &ptr);

		if(error)
			throw new AmxException(error);

		return ptr;
	}

	@trusted
	void AmxInit(ref Amx amx, void* program)
	{
		AmxError error = RawAmxFunctions.Init(amx, program);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxInitJIT(ref Amx amx, void* reloc_table, void* native_code)
	{
		AmxError error = RawAmxFunctions.InitJIT(amx, reloc_table, native_code);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	AmxMemInfo AmxGetMemInfo(ref Amx amx)
	{
		AmxMemInfo memInfo;
		AmxError error = RawAmxFunctions.MemInfo(amx, &(memInfo.codesize), &(memInfo.datasize), &(memInfo.stackheap));

		if(error)
			throw new AmxException(error);

		return memInfo;
	}

	@trusted
	int AmxNameLength(ref Amx amx)
	{
		int length;
		AmxError error = RawAmxFunctions.NameLength(amx, &length);

		if(error)
			throw new AmxException(error);

		return length;
	}

	@trusted
	AmxNativeInfo* AmxGetNativeInfo(string name, AmxNative_fn func)
	{
		return RawAmxFunctions.NativeInfo(name.ptr, func);
	}

	@trusted
	int AmxNumNatives(ref Amx amx)
	{
		int number;
		AmxError error = RawAmxFunctions.NumNatives(amx, &number);

		if(error)
			throw new AmxException(error);

		return number;
	}

	@trusted
	int AmxNumPublics(ref Amx amx)
	{
		int number;
		AmxError error = RawAmxFunctions.NumPublics(amx, &number);

		if(error)
			throw new AmxException(error);

		return number;
	}

	@trusted
	int AmxNumPubVars(ref Amx amx)
	{
		int number;
		AmxError error = RawAmxFunctions.NumPubVars(amx, &number);

		if(error)
			throw new AmxException(error);

		return number;
	}

	@trusted
	int AmxNumTags(ref Amx amx)
	{
		int number;
		AmxError error = RawAmxFunctions.NumTags(amx, &number);

		if(error)
			throw new AmxException(error);

		return number;
	}

	@trusted
	void AmxPush(ref Amx amx, cell value)
	{
		AmxError error = RawAmxFunctions.Push(amx, value);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	cell AmxPushString(ref Amx amx, cell** phys_addr, string str, bool pack, bool use_wchar)
	{
		cell amx_addr;
		AmxError error = RawAmxFunctions.PushString(amx, &amx_addr, phys_addr, str.ptr, pack, use_wchar);

		if(error)
			throw new AmxException(error);

		return amx_addr;
	}

	@trusted
	cell AmxPushArray(ref Amx amx, cell** phys_addr, const cell[] array, int numcells)
	{
		cell amx_addr;
		AmxError error = RawAmxFunctions.PushArray(amx, &amx_addr, phys_addr, array.ptr, numcells);

		if(error)
			throw new AmxException(error);

		return amx_addr;
	}

	@trusted
	void AmxRaiseError(ref Amx amx, int error_code)
	{
		AmxError error = RawAmxFunctions.RaiseError(amx, error_code);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxRelease(ref Amx amx, cell amx_addr)
	{
		AmxError error = RawAmxFunctions.Release(amx, amx_addr);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxSetCallback(ref Amx amx, AmxCallback_fn callback)
	{
		AmxError error = RawAmxFunctions.SetCallback(amx, callback);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxSetDebugHook(ref Amx amx, AmxDebug_fn dbg)
	{
		AmxError error = RawAmxFunctions.SetDebugHook(amx, dbg);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxSetString(cell* dest, string source, bool pack, bool use_wchar, size_t size)
	{
		AmxError error = RawAmxFunctions.SetString(dest, source.ptr, pack, use_wchar, size);

		if(error)
			throw new AmxException(error);

	}

	@trusted
	void AmxSetUserData(ref Amx amx, long tag, void* ptr)
	{
		AmxError error = RawAmxFunctions.SetUserData(amx, tag, ptr);

		if(error)
			throw new AmxException(error);

	}

	@trusted 
	int AmxStrLen(const ref cell cstring)
	{
		int length;
		AmxError error = RawAmxFunctions.StrLen(&cstring, &length);

		if(error)
			throw new AmxException(error);

		return length;
	}

	@trusted
	cell AmxAllot(ref Amx amx, int cells, cell** phys_addr)
	{
		cell amx_addr;
		AmxError error = RawAmxFunctions.Allot(amx, cells, &amx_addr, phys_addr);

		if(error)
			throw new AmxException(error);

		return amx_addr;
	}

	@trusted
	int AmxUTF8Check(string str)
	{
		int length;
		AmxError error = RawAmxFunctions.UTF8Check(str.ptr, &length);

		if(error)
			throw new AmxException(error);

		return length;
	}

	@trusted
	cell AmxUTF8Get(const char* str, const char** endptr)
	{
		cell value;
		AmxError error = RawAmxFunctions.UTF8Get(str, endptr, &value);

		if(error)
			throw new AmxException(error);

		return value;
	}

	@trusted
	int AmxUTF8Len(const ref cell cstr)
	{
		int length;
		AmxError error = RawAmxFunctions.UTF8Len(&cstr, &length);

		if(error)
			throw new AmxException(error);

		return length;
	}

	@trusted
	void AmxUTF8Put(char* str, char** endptr, int maxchars, cell value)
	{
		AmxError error = RawAmxFunctions.UTF8Put(str, endptr, maxchars, value);

		if(error)
			throw new AmxException(error);

	}
}
