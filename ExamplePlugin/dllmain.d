module dllmain;

import std.stdio;
import sampsdk.amx;
import sampsdk.plugin;

extern(C)
{
	cell Test(ref Amx amx, cell* params)
	{
		AmxFlags flags;
		int idxNative, idxPublic, idx, len;
		cell cl, dl;
		cell* addr;
		char chrs[256];
		long codesize, datasize, stackheap;
		AmxNativeInfo* ani;

		string param = AmxStrParam(amx, params[1]);
		LogPrintf("Test param: %s,%f", param.ptr, AmxCtof(params[2]));

		AmxFindNative(amx, "CreateVehicle", idxNative);
		LogPrintf("findNative: %i", idxNative);

		AmxFindPublic(amx, "TestPublic", idxPublic);
		LogPrintf("findPublic: %i", idxPublic);

		LogPrintf("findPubVar result: %i", AmxFindPubVar(amx, "TestVar", idx));
		LogPrintf("findPubVar: %i", cl);

		LogPrintf("pushString result: %i", AmxPushString(amx, dl, null, "push test", 0, 0));

		LogPrintf("push result: %i", AmxPush(amx, 253));

		LogPrintf("exec result: %i", AmxExec(amx, cl, idxPublic));
		LogPrintf("exec: %i", cl);

		LogPrintf("findTagId result: %i", AmxFindTagId(amx, 0, "TestTag"));
		
		LogPrintf("getFlags result: %i", AmxGetFlags(amx, flags));
		LogPrintf("getFlags: %i", flags);

		LogPrintf("getAddr result: %i", AmxGetAddr(amx, params[1], addr));
		LogPrintf("getAddr: %X", addr);

		LogPrintf("getNative result: %i", AmxGetNative(amx, idxNative, chrs));
		LogPrintf("getNative: %s", chrs.ptr);

		LogPrintf("getPublic result: %i", AmxGetPublic(amx, idxPublic, chrs));
		LogPrintf("getPublic: %s", chrs.ptr);

		LogPrintf("getPubVar result: %i", AmxGetPubVar(amx, 1, chrs, cl));
		LogPrintf("getPubVar: %X \"%s\"", cl, chrs.ptr);

		LogPrintf("getString result: %i", AmxGetString(chrs, addr, 0, chrs.length));
		LogPrintf("getString: %s", chrs.ptr);

		LogPrintf("getTag result: %i", AmxGetTag(amx, 0, chrs, cl));
		LogPrintf("getTag: %X \"%s\"", cl, chrs.ptr);

		LogPrintf("memInfo result: %i", AmxMemInfo(amx, codesize, datasize, stackheap));
		LogPrintf("memInfo: %i, %i, %i", codesize, datasize, stackheap);

		LogPrintf("nameLength result: %i", AmxNameLength(amx, len));
		LogPrintf("nameLength: %i", len);

		LogPrintf("nativeInfo result: %i", (ani = AmxGetNativeInfo("TestFunction", &Test)));
		LogPrintf("nativeInfo: %s", ani.name);

		LogPrintf("numNatives result: %i", AmxNumNatives(amx, idx));
		LogPrintf("numNatives: %i", idx);

		LogPrintf("numPublics result: %i", AmxNumPublics(amx, idx));
		LogPrintf("numPublics: %i", idx);

		LogPrintf("numPubVars result: %i", AmxNumPubVars(amx, idx));
		LogPrintf("numPubVars: %i", idx);

		LogPrintf("numTags result: %i", AmxNumTags(amx, idx));
		LogPrintf("numTags: %i", idx);

		LogPrintf("setString result: %i", AmxSetString(params[3], "test", 0, 0, params[4]));

		LogPrintf("strLen result: %i", AmxStrLen(params[3], len));
		LogPrintf("strLen: %i", len);

		return 16;
	}
}

auto PluginNatives =
[
	AmxNativeInfo("TestFunction", &Test),
	AmxNativeInfo(null, null)
];

extern(System)
{
	bool Load(ref PluginData data)
	{
		LogPrintf = data.logPrintf;
		RawAmxFunctions = data.amxExports;
		LogPrintf("Load");
		return true;
	}

	void Unload()
	{
		LogPrintf("Unload");
	}

	int AmxLoad(ref Amx amx)
	{
		LogPrintf("AmxLoad");
		return AmxRegister(amx, PluginNatives, -1);
	}

	int AmxUnload(ref Amx amx)
	{
		LogPrintf("AmxUnload");
		return AmxError.NONE;
	}

	uint Supports()
	{
		return SupportsFlags.VERSION | SupportsFlags.AMX_NATIVES;
	}
}