module sampsdk.amx;

import sampsdk.exception;

enum uint PAWN_CELL_SIZE = 32;

extern(C)
{
	static if(PAWN_CELL_SIZE == 16)
	{
		alias ucell = ushort;
		alias cell = short;
	}
	else static if(PAWN_CELL_SIZE == 32)
	{
		alias ucell = uint;
		alias cell = int;
	}
	else static if(PAWN_CELL_SIZE == 64)
	{
		alias ucell = ulong;
		alias cell = long;
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

	struct AmxTagInfo
	{
		string name;
		cell id;
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

	extern(C)
	{
		@trusted
		cell ftoc(float fl)
		{
			return *(cast(cell*)&fl);
		}

		@trusted
		float ctof(cell cl)
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
	}
}
