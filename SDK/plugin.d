module sampsdk.plugin;

import sampsdk.amx;

enum uint PLUGIN_VERSION = 0x200;

version(Posix)
{
	import core.runtime;
}

version(Windows)
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
	@system LogPrintf_fn LogPrintf;

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

void InitializePlugin()
{
	version(Posix)
	{
		Runtime.initialize();
	}
}

void TerminatePlugin()
{
	version(Posix)
	{
		Runtime.terminate();
	}
}
