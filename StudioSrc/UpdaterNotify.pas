unit UpdaterNotify;

{===============================================================================

   Khayalan File Splitter and Joinner Original Source
   Copyright © Khayalan Software 2010 - 2013
   All Right Reserved

   Coded by Faris Khowarizmi
   Project Started on 10 December 2011

===============================================================================}

interface

uses
  Windows, WinInet, Forms, SysUtils, IniFiles, ShellAPI;

const
  UpdURL = 'http://notify.khayalan.id/linets.ini';

  function GetUpdateNotification(var ver_str, urlred: string): boolean;
  procedure ProvideNotify(const Parent: THandle);

implementation

function NotifyThread(ParentParam: THandle): Integer;
var
  ver, urlredir: string;
begin

  if GetUpdateNotification(ver, urlredir) then
    if MessageBox(ParentParam, PChar(Format('New version %s update available!'#13#10'Do you want to download now?'#13#10#13#10'Note: for safety reason, always download from www.khayalan.id', [ver])), PChar('New Updates'), MB_ICONINFORMATION + MB_YESNO) = IDYES then
      ShellExecute(ParentParam, 'open', PChar(urlredir), nil, nil, SW_SHOW);

  Result:= 0;

end;

function IsConnected: Boolean;
const
  INTERNET_CONNECTION_MODEM = 1;
  INTERNET_CONNECTION_LAN = 2;
  INTERNET_CONNECTION_PROXY = 4;
  INTERNET_CONNECTION_MODEM_BUSY = 8;
var
  ConnectTypes: integer;
begin

  try
    ConnectTypes:= INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
    Result:= InternetGetConnectedState(@ConnectTypes, 0);
  except
    Result:= FALSE;
  end;

end;

// Source: http://delphi.about.com/od/internetintranet/a/get_file_net.htm
function GetInetFile(const fileURL, FileName: String): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
begin

  sAppName:= ExtractFileName(ParamStr(0)) ;
  hSession:= InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0) ;
  try
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, INTERNET_FLAG_RELOAD, 0) ;
    try
      try
        AssignFile(f, FileName) ;
        Rewrite(f, 1) ;
        repeat
          if InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) then
            BlockWrite(f, Buffer, BufferLen)
          else
            BufferLen:= 0;
        until BufferLen = 0;
        CloseFile(f);
        Result:= TRUE;
      except
        Result:= FALSE;
      end;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end;
end;

function GetUpdateNotification(var ver_str, urlred: string): boolean;
var
  tbuf: array[0..MAX_PATH-1] of char;
  ftmp: string;
  ini: TIniFile;
  cMajor, cMinor, cRev, cBuild: Word;
  uMajor, uMinor, uRev, uBuild: Word;
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  VerRecv: Boolean;
begin

  Result:= False;
  if IsConnected then
    begin
    GetTempPath(MAX_PATH, @tbuf);
    ftmp:= tbuf;
    if ftmp[Length(ftmp)] <> '\' then
      ftmp:= ftmp+'\';
    ftmp:= ftmp+'kfsj_uptd.tmp';
    if FileExists(ftmp) then
      DeleteFile(ftmp);
    VerRecv:= False;
    if GetInetFile(UpdURL, ftmp) then
      begin
      ini:= TIniFile.Create(ftmp);
      try
        urlred:= ini.ReadString('Update', 'UpdateLink', 'http://www.khayalan.web.id');
        uMajor:= ini.ReadInteger('Version', 'Major', 0);
        uMinor:= ini.ReadInteger('Version', 'Minor', 0);
        uRev:= ini.ReadInteger('Version', 'Revision', 0);
        uBuild:= ini.ReadInteger('Version', 'Build', 0);
        ver_str:= Format('%d.%d.%d.%d', [uMajor, uMinor, uRev, uBuild]);
        VerRecv:= True;
      finally
        ini.Free;
        DeleteFile(ftmp);
      end;
    end;

    if VerRecv then
      begin
      VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
      GetMem(VerInfo, VerInfoSize);
      try
        GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
        if not VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
          Result := FALSE
        else
          with VerValue^ do
            begin
            cMajor := HiWord(dwFileVersionMS);
            cMinor := LoWord(dwFileVersionMS);
            cRev   := HiWord(dwFileVersionLS);
            cBuild := LoWord(dwFileVersionLS);
            if (uMajor > cMajor) then
              Result:= TRUE
            else
            if (uMinor > cMinor) and (uMajor = cMajor) then
              Result:= TRUE
            else
            if (uRev > cRev) and (uMinor = cMinor) and (uMajor = cMajor) then
              Result:= TRUE
            else
            if (uBuild > cBuild) and (uRev = cRev) and (uMinor = cMinor) and (uMajor = cMajor) then
              Result:= TRUE;
          end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
    end;

  end;
end;

procedure ProvideNotify(const Parent: THandle);
var
  TrID: DWORD;
begin

  BeginThread(nil, 0, @NotifyThread, Pointer(Parent), 0, TrID);

end;

end.
