// librewolf-portable.cpp : Run librewolf.exe with -profile parameter.
//


#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>


int fileExists(TCHAR* file)
{
  WIN32_FIND_DATA FindFileData;
  HANDLE handle = FindFirstFile(file, &FindFileData);
  int found = handle != INVALID_HANDLE_VALUE;
  if (found)
  {
    //FindClose(&handle); this will crash
    FindClose(handle);
  }
  return found;
}


int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
  //https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=cmd
  //constexpr int max_path = _MAX_PATH+1;
  constexpr int max_path = 32767+1;  
  static wchar_t path[max_path], dir[max_path], exe[max_path], cmdline[max_path];

  

  GetModuleFileName(NULL, path, _MAX_PATH);
  *wcsrchr(path,L'\\') = L'\0';
  
  wcscpy(dir, path);
  wcscat(dir, L"\\Profiles\\Default");

  wcscpy(exe, path);
  wcscat(exe, L"\\librewolf.exe");
  if (!fileExists(exe)) {
    wcscpy(exe, path);
    wcscat(exe, L"\\LibreWolf\\librewolf.exe");
    if (!fileExists(exe)) {
      MessageBox(NULL, L"Can\'t find librewolf.exe in . or LibreWolf", path, MB_OK);
      return 1;
    }
  }
  
  wsprintf(cmdline, L"\"%s\" -profile \"%s\"", exe, dir);

  STARTUPINFOW siStartupInfo;
  PROCESS_INFORMATION piProcessInfo;
  memset(&siStartupInfo, 0, sizeof(siStartupInfo));
  memset(&piProcessInfo, 0, sizeof(piProcessInfo));
  siStartupInfo.cb = sizeof(siStartupInfo);

  if (!CreateProcess(exe, cmdline, NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS, NULL, NULL, &siStartupInfo, &piProcessInfo))
  {
    DWORD i = GetLastError();
    wsprintf(dir, L"CreateProcess() failed with error %i", i);
    MessageBox(NULL, dir, L"librewolf-portable", MB_OK);
    return 1;
  }

  return 0;
}
