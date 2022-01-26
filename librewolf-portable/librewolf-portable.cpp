// librewolf-portable.cpp : Run librewolf.exe with -profile parameter.
//

#include <windows.h>

int 
fileExists(TCHAR* file)
{
  WIN32_FIND_DATA FindFileData;
  HANDLE handle = FindFirstFile(file, &FindFileData);
  int found = (handle != INVALID_HANDLE_VALUE);

  if (found)
    FindClose(handle);

  return found;
}


int APIENTRY 
wWinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
{
  //https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=cmd
  constexpr DWORD max_path = 32767;
  static TCHAR path[max_path], dir[max_path], exe[max_path], cmdline[max_path];

  GetModuleFileName(NULL, path, max_path);
  *wcsrchr(path,L'\\') = L'\0';
  
  wcscpy_s(dir, path);
  wcscat_s(dir, L"\\Profiles\\Default");

  wcscpy_s(exe, path);
  wcscat_s(exe, L"\\librewolf.exe");
  if (!fileExists(exe)) {
    wcscpy_s(exe, path);
    wcscat_s(exe, L"\\LibreWolf\\librewolf.exe");
    if (!fileExists(exe)) {
      MessageBox(NULL, L"Can\'t find librewolf.exe in the current or LibreWolf folder.", path, MB_OK);
      return 1;
    }
  }

  wsprintf(cmdline, L"\"%s\" -profile \"%s\" %s", exe, dir, lpCmdLine);

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

  CloseHandle(piProcessInfo.hProcess);
  CloseHandle(piProcessInfo.hThread);

  return 0;
}
