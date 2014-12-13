module dllmain;

import std.stdio;
import sampsdk.amx;
import sampsdk.plugin;
import sampsdk.exception;

__gshared PluginInterface p;

extern(C)
{
	cell Test(ref Amx amx, cell* params)
	{
		int idxNative, idxPublic;
		cell cl;
		cell* addr;
		AmxNativeInfo* nativeInfo;
		AmxMemInfo memInfo;
		AmxTagInfo tagInfo;
		string param, tagName;

		try
		{
			param = p.amxStrParam(amx, params[1]);
			p.print("Test param: %s,%f", param.ptr, ctof(params[2]));
			p.print("findNative: %i", idxNative = p.amxFindNative(amx, "CreateVehicle"));
			p.print("findPublic: %i", idxPublic = p.amxFindPublic(amx, "TestPublic"));
			p.print("callback: %i", p.amxCallback(amx, 0, &cl));
			p.print("pushString: %i", cl = p.amxPushString(amx, null, "push test", false, false));
			p.amxPush(amx, 253);
			p.print("exec: %i", cl = p.amxExec(amx, idxPublic));
			p.print("getFlags: %i", p.amxGetFlags(amx));
			p.print("getAddr result: %i", addr = p.amxGetAddr(amx, params[1]));
			p.print("getNative: %s", p.amxGetNative(amx, idxNative, 128).ptr);
			p.print("getPublic: %s", p.amxGetPublic(amx, idxPublic, 128).ptr);
			//p.print("findPubVar: %i", p.amxFindPubVar(amx, "TestVar"));
			//p.print("getPubVar: %s", p.amxGetPubVar(amx, 0, cl, 128).ptr);
			p.print("getString: %s", p.amxGetString(addr, false, 128).ptr);
			tagInfo = p.amxGetTag(amx, 0, 128);
			p.print("getTag: %s", tagInfo.name.ptr);
			p.print("getTag id: %X", tagInfo.id);
			p.print("findTagId result: %s", p.amxFindTagId(amx, tagInfo.id, 128).ptr);
			memInfo = p.amxGetMemInfo(amx);
			p.print("memInfo: %i, %i, %i", memInfo.codesize, memInfo.datasize, memInfo.stackheap);
			p.print("nameLength: %i", p.amxNameLength(amx));
			p.print("nativeInfo result: %i", (nativeInfo = p.amxGetNativeInfo("TestFunction", &Test)));
			p.print("nativeInfo: %s", nativeInfo.name);
			p.print("numNatives: %i", p.amxNumNatives(amx));
			p.print("numPublics: %i", p.amxNumPublics(amx));
			p.print("numPubVars: %i", p.amxNumPubVars(amx));
			p.print("numTags: %i", p.amxNumTags(amx));
			p.amxSetString(p.amxGetAddr(amx, params[3]), "set test", false, false, params[4]);
			p.print("strLen: %i", p.amxStrLen(params[3]));
		}
		catch(AmxException e)
		{
			p.print("Exception in file %s (l:%i): %s", e.file.ptr, e.line, e.getErrorString().ptr);
		}

		return 16;
	}
}

auto PluginNatives =
[
	AmxNativeInfo("TestFunction", &Test)
];

extern(System)
{
	bool Load(ref PluginData data)
	{
		p = PluginInterface.Generate(data);
		p.print("Load");
		return true;
	}

	void Unload()
	{
		p.print("Unload");
		p.destroy();
	}

	int AmxLoad(ref Amx amx)
	{
		p.print("AmxLoad");
		try
		{
			p.amxRegister(amx, PluginNatives, -1);
		}
		catch(AmxException e)
		{
			p.print("Could not register natives with AMX: %s", e.getErrorString().ptr);
			return e.getError();
		}

		return AmxError.NONE;
	}

	int AmxUnload(ref Amx amx)
	{
		p.print("AmxUnload");
		return AmxError.NONE;
	}

	uint Supports()
	{
		return SupportsFlags.VERSION | SupportsFlags.AMX_NATIVES;
	}
}
