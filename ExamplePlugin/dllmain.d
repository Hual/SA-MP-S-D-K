module dllmain;

import std.stdio;
import sampsdk.amx;
import sampsdk.plugin;
import sampsdk.exception;

extern(C)
{
	cell Test(ref Amx amx, cell* params)
	{
		int idxNative, idxPublic;
		cell cl;
		cell* addr;
		AmxNativeInfo* nativeInfo;
		AmxMemInfo memInfo;
		string param, tagName;

		try
		{
			param = AmxStrParam(amx, params[1]);

			LogPrintf("Test param: %s,%f", param.ptr, AmxCtof(params[2]));

			LogPrintf("findNative: %i", idxNative = AmxFindNative(amx, "CreateVehicle"));

			LogPrintf("findPublic: %i", idxPublic = AmxFindPublic(amx, "TestPublic"));

			LogPrintf("callback: %i", AmxCallback(amx, 0, &cl));

			LogPrintf("pushString: %i", cl = AmxPushString(amx, null, "push test", false, false));

			AmxPush(amx, 253);

			LogPrintf("exec: %i", cl = AmxExec(amx, idxPublic));

			LogPrintf("getFlags: %i", AmxGetFlags(amx));

			LogPrintf("getAddr result: %i", addr = AmxGetAddr(amx, params[1]));

			LogPrintf("getNative: %s", AmxGetNative(amx, idxNative, 128).ptr);

			LogPrintf("getPublic: %s", AmxGetPublic(amx, idxPublic, 128).ptr);

			//LogPrintf("findPubVar: %i", AmxFindPubVar(amx, "TestVar"));

			//LogPrintf("getPubVar: %s", AmxGetPubVar(amx, 0, cl, 128).ptr);

			LogPrintf("getString: %s", AmxGetString(addr, false, 128).ptr);

			tagName = AmxGetTag(amx, 0, cl, 128);
			LogPrintf("getTag: %s", tagName.ptr);
			LogPrintf("getTag id: %X", cl);

			LogPrintf("findTagId result: %s", AmxFindTagId(amx, cl, 128).ptr);

			memInfo = AmxGetMemInfo(amx);
			LogPrintf("memInfo: %i, %i, %i", memInfo.codesize, memInfo.datasize, memInfo.stackheap);

			LogPrintf("nameLength: %i", AmxNameLength(amx));

			LogPrintf("nativeInfo result: %i", (nativeInfo = AmxGetNativeInfo("TestFunction", &Test)));
			LogPrintf("nativeInfo: %s", nativeInfo.name);

			LogPrintf("numNatives: %i", AmxNumNatives(amx));
			LogPrintf("numPublics: %i", AmxNumPublics(amx));
			LogPrintf("numPubVars: %i", AmxNumPubVars(amx));
			LogPrintf("numTags: %i", AmxNumTags(amx));

			AmxSetString(AmxGetAddr(amx, params[3]), "set test", false, false, params[4]);

			LogPrintf("strLen: %i", AmxStrLen(params[3]));
		}
		catch(AmxException e)
		{
			LogPrintf("Exception in file %s (l:%i): %s", e.file.ptr, e.line, e.getErrorString().ptr);
		}

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
		InitializePlugin();
		LogPrintf = data.logPrintf;
		RawAmxFunctions = data.amxExports;
		LogPrintf("Load");
		return true;
	}

	void Unload()
	{
		LogPrintf("Unload");
		TerminatePlugin();
	}

	int AmxLoad(ref Amx amx)
	{
		LogPrintf("AmxLoad");
		try
		{
			AmxRegister(amx, PluginNatives, -1);
		}
		catch(AmxException e)
		{
			LogPrintf("Could not register natives with AMX: %s", e.getErrorString().ptr);
			return e.getError();
		}

		return AmxError.NONE;
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
