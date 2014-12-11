module dllmain;

import std.stdio;
import sampsdk.amx;
import sampsdk.plugin;

extern(C)
{
	cell Test(ref Amx amx, cell* params)
	{
		string param = AmxStrParam(amx, params[1]);
		LogPrintf("Test param: %s,%f", param.ptr, AmxCtof(params[2]));
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
		LogPrintf = data.fnLogPrintf;
		pAMXFunctions = data.amxExports;
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