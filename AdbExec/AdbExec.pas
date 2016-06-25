{$IFDEF PROFILE} {$O-} {$WARNINGS OFF} {$ENDIF }
{$IFDEF PROFILE} {$IFDEF VER210} {$INLINE OFF} {$ENDIF } {$ENDIF }
unit AdbExec;

(*============================================================================*)
(*                                                                            *)
(* Adb Executor Helper for Delphi/Pascal                                      *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Part of SodaPoppers Project (Line Theme Studio)                            *)
(*                                                                            *)
(*============================================================================*)
(*                                                                            *)
(* Copyright (c) 2015 Faris Khowarzimi                                        *)
(*                                                                            *)
(* Permission is hereby granted, free of charge, to any person obtaining a    *)
(* copy of this software and associated documentation files (the "Software"), *)
(* to deal in the Software without restriction, including without limitation  *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,   *)
(* and/or sell copies of the Software, and to permit persons to whom the      *)
(* Software is furnished to do so, subject to the following conditions:       *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be included in *)
(* all copies or substantial portions of the Software.                        *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *)
(* DEALINGS IN THE SOFTWARE.                                                  *)
(*                                                                            *)
(*============================================================================*)

(* Last revision: 23 July 2015 *)

(* Referensi MSDN untuk redirect Standard I/O    *)
(* https://support.microsoft.com/en-us/kb/190351 *)

interface

uses
  Windows, SysUtils, Classes{$IFNDEF PROFILE};{$ELSE}{},Profint;{$ENDIF}

const
  AdxDefaultBuffer = 4096;

type

  TAdxExecInfo = record
    PrcInfo    : TProcessInformation;
    StdIo      : boolean;
    InputWrite : THandle;
    OutputRead : THandle;
  end;
  PAdxExecInfo = ^TAdxExecInfo;

  TAdxDevType = (dtUnknown, dtDevice, dtEmulator, dtOffline);
  PAdxDevType = ^TAdxDevType;

  TAdxDevice = record
    DevType: TAdxDevType;
    Serial : PChar;
    Product: PChar;
    Model  : PChar;
    Device : PChar;
  end;
  PAdxDevice = ^TAdxDevice;

  TAdxDeviceList = array[0..$FF] of TAdxDevice;
  PAdxDeviceList = ^TAdxDeviceList;

  TAdxDevices = record
    Nums   : integer;
    RecSize: integer;
    Devs   : PAdxDeviceList;
  end;
  PAdxDevices = ^TAdxDevices;

  procedure Adx_SetAdbProgram(const AdbExePath: string);
  function  Adx_GetAdbProgram: string;
  function  Adx_MakeCmdString(const Device, Command: string): string;

  function  Adx_Execute(const Device, Command: string; const StdIo: boolean; var ExecInfo: TAdxExecInfo): boolean;
  function  Adx_ExecuteAndWait(const Device, Command: string): boolean; overload;
  function  Adx_ExecuteAndWait(const Device, Command: string; var StdOut: string): boolean; overload;
  function  Adx_Close(var ExecInfo: TAdxExecInfo): boolean;
  function  Adx_GetLastExitCode: LongWord;
  function  Adx_StillActive(const ExecInfo: TAdxExecInfo): boolean;

  function  Adx_ReadStdOut(const ExecInfo: TAdxExecInfo; var StdOut: string): boolean;
  function  Adx_WriteStdIn(const ExecInfo: TAdxExecInfo; const StdIn: string): boolean;
  function  Adx_WriteCommand(const ExecInfo: TAdxExecInfo; const Command: string): boolean;

  function  Adx_StartServer: boolean;
  function  Adx_KillServer: boolean;

  function  Adx_GetAttachedDevices: PAdxDevices;
  procedure Adx_FreeAttachedDevicesList(var List: PAdxDevices);

implementation

resourcestring
  AdbDefaultExe = 'adb.exe';

type
  TBufferArr = array[0..AdxDefaultBuffer] of AnsiChar;
  PBufferArr = ^TBufferArr;

var
  AdbExe: string;
  LastExitCode: LongWord;

procedure Adx_SetAdbProgram(const AdbExePath: string);
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(482); try;{$ENDIF}
  AdbExe:= AdbExePath;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(482); end; {$ENDIF}
end;

function Adx_GetAdbProgram: string;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(483); try;{$ENDIF}
  Result:= AdbExe;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(483); end; {$ENDIF}
end;

function Adx_MakeCmdString(const Device, Command: string): string;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(484); try;{$ENDIF}

  if Device <> '' then
    Result:= Format('"%s" -s %s %s', [AdbExe, Device, Command])
  else
    Result:= Format('"%s" %s', [AdbExe, Command]);

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(484); end; {$ENDIF}
end;

function Adx_Execute(const Device, Command: string; const StdIo: boolean; var ExecInfo: TAdxExecInfo): boolean;
var
  Sa: TSecurityAttributes;
  Si: TStartupInfo;
  Ow, Ir: THandle;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(485); try;{$ENDIF}

  ZeroMemory(@ExecInfo, SizeOf(TAdxExecInfo));
  Sa.nLength:= SizeOf(TSecurityAttributes);
  Sa.lpSecurityDescriptor:= nil;
  Sa.bInheritHandle:= TRUE;

  try

    ExecInfo.StdIo:= StdIo;
    if StdIo then
      begin
      Assert(CreatePipe(ExecInfo.OutputRead, Ow, @Sa, 0));
      Assert(SetHandleInformation(ExecInfo.OutputRead, HANDLE_FLAG_INHERIT, 0));
      Assert(CreatePipe(Ir, ExecInfo.InputWrite, @Sa, 0));
      Assert(SetHandleInformation(ExecInfo.InputWrite, HANDLE_FLAG_INHERIT, 0));
    end;

    ZeroMemory(@Si, SizeOf(TStartupInfo));
    Si.cb:= SizeOf(TStartupInfo);
    if StdIo then
      begin
      Si.hStdInput:= Ir;
      Si.hStdOutput:= Ow;
      Si.hStdError:= Ow;
      Si.dwFlags:= STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    end
    else
      Si.dwFlags:= STARTF_USESHOWWINDOW;
    Si.wShowWindow:= SW_HIDE;
    Assert(CreateProcess(nil, PChar(Adx_MakeCmdString(Device, Command)),
           nil, nil, TRUE, NORMAL_PRIORITY_CLASS, nil, nil, Si, ExecInfo.PrcInfo));
    if StdIo then
      begin
      Assert(CloseHandle(Ir));
      Assert(CloseHandle(Ow));
    end;
    Result:= TRUE;

  except

    Result:= FALSE;

  end;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(485); end; {$ENDIF}
end;

function Adx_ExecuteAndWait(const Device, Command: string): boolean; overload
var
  Ei: TAdxExecInfo;
  Ec: Cardinal;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(486); try;{$ENDIF}

  Result:= FALSE;
  if Adx_Execute(Device, Command, FALSE, Ei) then
  try
    WaitForSingleObject(Ei.PrcInfo.hProcess, INFINITE);
    Ec:= 0;
    GetExitCodeProcess(Ei.PrcInfo.hProcess, Ec);
    Result:= Ec = 0;
  finally
    Adx_Close(Ei);
  end;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(486); end; {$ENDIF}
end;

function Adx_ExecuteAndWait(const Device, Command: string; var StdOut: string): boolean;
var
  Buf: string;
  Ei: TAdxExecInfo;
  Ec, Es: Cardinal;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(487); try;{$ENDIF}

  Result:= FALSE;
  StdOut:= '';

  if Adx_Execute(Device, Command, TRUE, Ei) then
  try
    repeat
      Es:= WaitForSingleObject(Ei.PrcInfo.hProcess, 100);
      Adx_ReadStdOut(Ei, Buf);
      StdOut:= StdOut + Buf;
    until Es <> WAIT_TIMEOUT;
    Ec:= 0;
    GetExitCodeProcess(Ei.PrcInfo.hProcess, Ec);
    Result:= Ec = 0;
  finally
    Adx_Close(Ei);
  end;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(487); end; {$ENDIF}
end;

function Adx_Close(var ExecInfo: TAdxExecInfo): boolean;
var
  Ec: Cardinal;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(488); try;{$ENDIF}

  try

    Ec:= 0;
    GetExitCodeProcess(ExecInfo.PrcInfo.hProcess, Ec);
    LastExitCode:= Ec;
    Assert(Ec <> STILL_ACTIVE, 'Process must terminated first!');

    if ExecInfo.StdIo then
      begin
      Assert(CloseHandle(ExecInfo.InputWrite));
      Assert(CloseHandle(ExecInfo.OutputRead));
    end;
    Assert(CloseHandle(ExecInfo.PrcInfo.hProcess));
    Assert(CloseHandle(ExecInfo.PrcInfo.hThread));

    Result:= TRUE;
    ZeroMemory(@ExecInfo, SizeOf(TAdxExecInfo));

  except

    Result:= FALSE;

  end;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(488); end; {$ENDIF}
end;

function Adx_GetLastExitCode: LongWord;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(489); try;{$ENDIF}
  Result:= LastExitCode;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(489); end; {$ENDIF}
end;

function Adx_StillActive(const ExecInfo: TAdxExecInfo): boolean;
var
  Ec: Cardinal;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(490); try;{$ENDIF}
  Ec:= 0;
  GetExitCodeProcess(ExecInfo.PrcInfo.hProcess, Ec);
  Result:= Ec = STILL_ACTIVE;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(490); end; {$ENDIF}
end;

function Adx_ReadStdOut(const ExecInfo: TAdxExecInfo; var StdOut: string): boolean;
var
  Buf: PBufferArr;
  Re: Cardinal;
  Rs, Rd: boolean;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(491); try;{$ENDIF}
  StdOut:= '';
  Rd:= FALSE;
  GetMem(Buf, SizeOf(TBufferArr));
  try
    repeat
      Re:= 0;
      Rs:= ReadFile(ExecInfo.OutputRead, Buf^[0], AdxDefaultBuffer, Re, nil);
      if (Rs) and (Re > 0) then
        begin
        Buf^[Re]:= #0;
        OemToAnsi(Buf^, Buf^);
        StdOut:= StdOut + String(Buf^);
        Rd:= TRUE;
      end;
    until (Re < AdxDefaultBuffer) or (not Rs);
  finally
    FreeMem(Buf);
  end;
  Result:= Rd;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(491); end; {$ENDIF}
end;

function Adx_WriteStdIn(const ExecInfo: TAdxExecInfo; const StdIn: string): boolean;
var
  Buf: PBufferArr;
  bsize, We: Cardinal;
  Src: PChar;
  slen: integer;
  Wr, Ws: boolean;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(492); try;{$ENDIF}
  slen:= Length(StdIn)+1;
  Wr:= FALSE;
  if slen < SizeOf(TBufferArr) then
    bsize:= slen
  else
    bsize:= SizeOf(TBufferArr);
  GetMem(Buf, bsize);
  try
    Src:= @StdIn[1];
    repeat
      if slen < SizeOf(TBufferArr) then
        bsize:= slen;
      CopyMemory(Buf, Src, bsize);
      //AnsiToOem(Buf^, Buf^);
      We:= 0;
      Ws:= WriteFile(ExecInfo.InputWrite, Buf^[0], bsize, We, nil);
      if (Ws) and (We > 0) then
        Wr:= TRUE;
      Src:= Pointer(Cardinal(Src)+bsize);
      Dec(slen, bsize);
    until (slen = 0) or (not Ws);
  finally
    FreeMem(Buf);
  end;
  Result:= Wr;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(492); end; {$ENDIF}
end;

function Adx_WriteCommand(const ExecInfo: TAdxExecInfo; const Command: string): boolean;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(493); try;{$ENDIF}
  Result:= Adx_WriteStdIn(ExecInfo, Command+#13#10);
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(493); end; {$ENDIF}
end;

function Adx_StartServer: boolean;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(494); try;{$ENDIF}
  Result:= Adx_ExecuteAndWait('', 'start-server');
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(494); end; {$ENDIF}
end;

function Adx_KillServer: boolean;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(495); try;{$ENDIF}
  Result:= Adx_ExecuteAndWait('', 'kill-server');
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(495); end; {$ENDIF}
end;

function Adx_GetAttachedDevices: PAdxDevices;
var
  Devs: PAdxDevices;
  Dlst: array of TAdxDevice;
  Ls: TStringList;
  bf, cst, dbgobj: string;
  msize: LongWord;
  zfra, cnt, fe, cd: integer; (* untuk Looping, Count, FirstEntry & CurrentDevice *)
  trcs, stcr, len: integer;   (* lanjut... TraceSpace, StringCursor & panjang string *)
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(496); try;{$ENDIF}

  GetMem(Devs, SizeOf(TAdxDevices));
  try
    Devs^.Nums:= 0;
    Devs^.RecSize:= SizeOf(TAdxDevice);
    Dlst:= nil;
    Assert(Adx_ExecuteAndWait('', 'devices -l', bf), 'Cannot execute adb device list!');
    Ls:= TStringList.Create;
    try
      Ls.Clear;
      Ls.Text:= bf;
      cnt:= Ls.Count;
      fe:= 0;
      cd:= 0;
      for zfra:= 0 to cnt-1 do
        begin
        if fe > 0 then
          begin
          cst:= Trim(Ls[zfra]);
          if cst <> '' then
            begin
            SetLength(dlst, cd+1);
            stcr:= 1;
            len:= Length(cst);
            (* Part 1 - dapatkan serial *)
            for trcs:= stcr to len do
              if cst[trcs] = ' ' then
                begin
                dlst[cd].Serial:= StrNew(PChar(Copy(cst, stcr, trcs-1)));
                stcr:= trcs;
                break;
              end;
            for trcs:= stcr to len do
              if cst[trcs] <> ' ' then
                begin
                stcr:= trcs;
                break;
              end;
            (* Part 2 - dapatkan jenis objek debug *)
            dbgobj:= '';
            for trcs:= stcr to len do
              if cst[trcs] = ' ' then
                begin
                dbgobj:= UpperCase(Copy(cst, stcr, trcs-stcr));
                stcr:= trcs;
                break;
              end;
            for trcs:= stcr to len do
              if cst[trcs] = ':' then
                begin
                stcr:= trcs+1;
                break;
              end;
            (* Part 3 - dapatkan nama produk *)
            for trcs:= stcr to len do
              if cst[trcs] = ' ' then
                begin
                Dlst[cd].Product:= StrNew(PChar(Copy(cst, stcr, trcs-stcr)));
                stcr:= trcs;
                break;
              end;
            for trcs:= stcr to len do
              if cst[trcs] = ':' then
                begin
                stcr:= trcs+1;
                break;
              end;
            (* Part 4 - dapatkan nama model hp *)
            for trcs:= stcr to len do
              if cst[trcs] = ' ' then
                begin
                Dlst[cd].Model:= StrNew(PChar(Copy(cst, stcr, trcs-stcr)));
                stcr:= trcs;
                break;
              end;
            for trcs:= stcr to len do
              if cst[trcs] = ':' then
                begin
                stcr:= trcs+1;
                break;
              end;
            (* Part 5 - dapatkan nama perangkat *)
            Dlst[cd].Device:= StrNew(PChar(Copy(cst, stcr, len-stcr+1)));
            (* Selesai, tinggal finalisasi *)
            if dbgobj = 'DEVICE' then
              Dlst[cd].DevType:= dtDevice
            else
            if dbgobj = 'EMULATOR' then
              Dlst[cd].DevType:= dtEmulator
            else
            if dbgobj = 'OFFLINE' then
              Dlst[cd].DevType:= dtOffline
            else
              Dlst[cd].DevType:= dtUnknown;
            Inc(cd);
            Devs^.Nums:= cd;
          end;
        end
        else
          begin
          if Ls[zfra][1] <> '*' then
            fe:= zfra + 1;
        end;
      end;
      if cd > 0 then
        begin
        msize:= cd * SizeOf(TAdxDevice);
        GetMem(Devs^.Devs, msize);
        CopyMemory(Devs^.Devs, Dlst, msize);
      end;
    finally
      Ls.Free;
      Dlst:= nil;
    end;
    Result:= Devs;
  except
    FreeMem(Devs);
    Result:= nil;
  end;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(496); end; {$ENDIF}
end;

procedure Adx_FreeAttachedDevicesList(var List: PAdxDevices);
var
  zfra: Integer;
begin
{$IFDEF PROFILE}try; Profint.PomoEnter(497); try;{$ENDIF}
  if List^.Nums > 0 then
    begin
    for zfra:= 0 to List^.Nums - 1 do
      begin
      StrDispose(List^.Devs[zfra].Serial);
      StrDispose(List^.Devs[zfra].Product);
      StrDispose(List^.Devs[zfra].Model);
      StrDispose(List^.Devs[zfra].Device);
    end;
    FreeMem(List^.Devs, List^.Nums * List^.RecSize);
  end;
  FreeMem(List);
  List:= nil;
{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(497); end; {$ENDIF}
end;

initialization

{$IFDEF PROFILE}try; Profint.PomoEnter(498); try;{$ENDIF}
  Adx_SetAdbProgram(AdbDefaultExe);
  LastExitCode:= 0;

{$IFDEF PROFILE}except else Profint.PomoExce; end; finally; Profint.PomoExit(498); end; {$ENDIF}
end.
