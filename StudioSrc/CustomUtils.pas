unit CustomUtils;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Misc. Utility                                                *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, ShellAPI, Mapi, SysUtils, Classes, Forms, Controls, Graphics, PngImage,
  SynGdiPlus, ShlObj;

  function  GetAppVer: string;
  function  RemoveAmp(const str: string): string;
  function  HdrJsonComment(const str: string): string;
  function  SendMail(const Handle: THandle; const Subj, Body, Recv: AnsiString; const Attachs: array of AnsiString): boolean;
  function  GetDocumentDir: string;
  function  AfterSlashName(const Before: PChar): PChar;
  function  AspectRatio(SourceW, SourceH, MaxW, MaxH: integer): TRect;
  function  SwapRGBColor(const Color: TColor): TColor;
  function  ExtractShellIcon(var BigIcon, SmallIcon: HIcon; Index: integer): boolean;
  function  GetIconBmp(const Icon: HIcon; var Bmp, Mask: HBitmap): boolean;
  procedure IconToBitmap(const Icon: HIcon; const bmp: TBitmap);
  procedure AddPngGlyph(const ImgLst: TImageList; const pngres: string; const BaseColor: TColor = clBtnFace);
  procedure TransparentBase(const Canv: TCanvas; Area: TRect);
  function  BlendRGB(const Color1, Color2: TColor; const Blend: Integer): TColor;
  procedure DrawGradient(Color1, Color2: TColor; Canv: TCanvas; RectArea: TRect; Vert: boolean = FALSE);
  function  MakeToolbarBackground(const Height: integer): TBitmap;
  procedure DrawAntiAliased(const Pic: TGraphic; const DestCanvas: TCanvas; const Rect: TRect);

implementation

type
  TAttachAccessArray = array[0..0] of TMapiFileDesc;
  PAttachAccessArray = ^TAttachAccessArray;

const
  GenHdrLn = 75;

function GetAppVer: string;
var
  Major, Minor, Rev, Build: Word;
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin

  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  try
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    if not VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
      Result := '(unknown build)'
    else
      with VerValue^ do
        begin
        Major := HiWord(dwFileVersionMS);
        Minor := LoWord(dwFileVersionMS);
        Rev   := HiWord(dwFileVersionLS);
        Build := LoWord(dwFileVersionLS);
        {$IFDEF DEBUG}
        Result := Format('%d.%d.%d (%s build %d)', [Major, Minor, Rev, 'Beta', Build]);
        {$ELSE}
        Result := Format('%d.%d.%d (build %d)', [Major, Minor, Rev, Build]);
        {$ENDIF}
      end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;

end;

function RemoveAmp(const str: string): string;
var
  zfra: integer;
begin

  Result:= '';
  for zfra:= 1 to Length(str) do
    if str[zfra] <> '&' then
      Result:= Result + str[zfra];

end;

function HdrJsonComment(const str: string): string;
var
  spc: string[GenHdrLn];
  lp: integer;
begin
  spc:= '';
  lp:= GenHdrLn-Length(str);
  while lp > 0 do
    begin
    spc:= spc+' ';
    Dec(lp);
  end;
  Result:= Format('/* %s%s*/', [str, spc]);
end;

{$IF CompilerVersion >= 20}
  {$WARNINGS OFF}
{$IFEND}
function SendMail(const Handle: THandle; const Subj, Body, Recv: AnsiString; const Attachs: array of AnsiString): boolean;
var
  hr: HRESULT;
  Ms: Cardinal;
  Mm: TMapiMessage;
  Recip: TMapiRecipDesc;
  AttachArr: PAttachAccessArray;
  AttachCnt: integer;
  lp: integer;
  WndLst: Pointer;
begin

  hr:= MapiLogon(Handle, nil, nil, MAPI_LOGON_UI or MAPI_NEW_SESSION, 0, @Ms);
  if not Succeeded(hr) then
    raise Exception.CreateFmt('Mapi Logon error %d!', [hr]);

  AttachArr:= nil;
  AttachCnt:= High(Attachs) - Low(Attachs) + 1;

  try

    ZeroMemory(@Recip, SizeOf(TMapiRecipDesc));
    Recip.ulReserved:= 0;
    Recip.ulRecipClass:= MAPI_TO;
    Recip.lpszName:= StrNew(PAnsiChar(Recv));
    Recip.lpszAddress:= StrNew(PAnsiChar(string(Format('SMTP:%s', [Recv]))));
    Recip.ulEIDSize:= 0;

    ZeroMemory(@Mm, SizeOf(TMapiMessage));
    Mm.nRecipCount:= 1;
    Mm.lpRecips:= @Recip;
    Mm.lpszSubject:= StrNew(PAnsiChar(Subj));
    Mm.lpszNoteText:= StrNew(PAnsiChar(Body));

    if AttachCnt > 0 then
      begin
      GetMem(AttachArr, AttachCnt * SizeOf(TMapiFileDesc));
      for lp:= Low(Attachs) to High(Attachs) do
        with AttachArr^[lp] do
          begin
          ulReserved:= 0;
          flFlags:= 0;
          nPosition:= 0;
          lpszFileName:= StrNew(PAnsiChar(string(ExtractFilePath(Attachs[lp]))));
          lpszPathName:= StrNew(PAnsiChar(string(Attachs[lp])));
        end;
      Mm.nFileCount:= AttachCnt;
      Mm.lpFiles:= @AttachArr^;
    end;

    WndLst:= DisableTaskWindows(0);
    try
      Result:= Succeeded(MapiSendMail(Ms, Handle, Mm, MAPI_DIALOG, 0));
    finally
      EnableTaskWindows(WndLst);
    end;

  finally
    MapiLogOff(Ms, Handle, 0, 0);
    if Assigned(Recip.lpszName) then
      StrDispose(Recip.lpszName);
    if Assigned(Recip.lpszAddress) then
      StrDispose(Recip.lpszAddress);
    if Assigned(Mm.lpszSubject) then
      StrDispose(Mm.lpszSubject);
    if Assigned(Mm.lpszNoteText) then
      StrDispose(Mm.lpszNoteText);
    if AttachCnt > 0 then
      begin
      for lp:= Low(Attachs) to High(Attachs) do
        begin
        StrDispose(AttachArr^[lp].lpszFileName);
        StrDispose(AttachArr^[lp].lpszPathName);
      end;
      FreeMem(AttachArr);
    end;
  end;

end;
{$IF CompilerVersion >= 20}
  {$WARNINGS ON}
{$IFEND}

function GetDocumentDir: string;
var
  pidl: PItemIDList;
  path: array[0..MAX_PATH] of char;
begin

  Result:= '';
  if SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, pidl) = S_OK then
    if SHGetPathFromIDList(pidl, @path) then
      Result:= path;

end;

function AfterSlashName(const Before: PChar): PChar;
var
  x, len: LongWord;
begin
  len:= Length(Before);
  for x:= len downto 1 do
    begin
    if Before[x] = '/' then
      Break;
  end;
  Result:= PWideChar(LongWord(Before) + (x+1)*2);
end;

function AspectRatio(SourceW, SourceH, MaxW, MaxH: integer): TRect;
// Based on
// http://www.efg2.com/Lab/ImageProcessing/AspectRatio.htm
var
  Half: integer;
  WH: integer;
begin

  if (SourceW <= 0) or (SourceH <= 0) or (MaxW <= 0) or (MaxH <= 0) then
    Exit;

  if (SourceW / SourceH) < (MaxW / MaxH) then
    begin

    // Stretch Height to match.
    Result.Top    := 0;
    Result.Bottom := MaxH;

    // Adjust and center Width.
    WH := MulDiv(MaxH, SourceW, SourceH);
    Half:= (MaxW - WH) div 2;

    Result.Left  := Half;
    Result.Right := Result.Left + WH;

  end
  else
    begin

    // Stretch Width to match.
    Result.Left    := 0;
    Result.Right   := MaxW;

    // Adjust and center Height.
    WH := MulDiv(MaxW, SourceH, SourceW);
    Half := (MaxH - WH) div 2;

    Result.Top    := Half;
    Result.Bottom := Result.Top + WH;

  end;

end;

function SwapRGBColor(const Color: TColor): TColor; register; assembler;
// Tukar RGB ke BGR menggunakan metode bit swapping
asm
  push ebx
  xor ebx, ebx
  mov bh, al
  mov bl, ah
  shr eax, 16
  shl ebx, 8
  or  eax, ebx
  pop ebx
end;

function ExtractShellIcon(var BigIcon, SmallIcon: HIcon; Index: integer): boolean;
var
  sysdir: Array[0..255] of char;
  shlmod: string;
begin
  GetSystemDirectory(@sysdir, SizeOf(sysdir));
  shlmod:= sysdir + '\Shell32.dll';
  Result:= ExtractIconEx(PChar(shlmod), Index, BigIcon, SmallIcon, 1) <> LongWord(-1);
end;

function GetIconBmp(const Icon: HIcon; var Bmp, Mask: HBitmap): boolean;
var
  Inf: TIconInfo;
begin
  Result:= FALSE;
  if GetIconInfo(Icon, Inf) then
    begin
    Bmp:= Inf.hbmColor;
    Mask:= Inf.hbmMask;
    Result:= TRUE;
  end;
end;

procedure IconToBitmap(const Icon: HIcon; const bmp: TBitmap);
var
  Ico: TIcon;
begin
  Ico:= TIcon.Create;
  try
    Ico.Handle:= Icon;
    bmp.Assign(Ico);
  finally
    Ico.Free;
  end;
end;

procedure AddPngGlyph(const ImgLst: TImageList; const pngres: string; const BaseColor: TColor);
var
  png: TPngImage;
  bmp, bmk: TBitmap;
  x, y: integer;
  //alp: PByteArray;
  brg: PRGBQuad;
begin

  png:= TPngImage.Create;
  try
    png.LoadFromResourceName(hInstance, pngres);
    bmp:= TBitmap.Create;
    try
      bmp.PixelFormat:= pf24Bit;
      bmp.SetSize(png.Width, png.Height);
      bmp.Canvas.Lock;
      try
        bmp.Canvas.Brush.Style:= bsSolid;
        bmp.Canvas.Brush.Color:= clBtnFace;
        bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
        bmp.Canvas.Draw(0, 0, png);
      finally
        bmp.Canvas.Unlock;
      end;
      bmk:= png.ToBitmap;
      try
        if bmk.PixelFormat = pf32bit then
          begin
          for y:= 0 to bmk.Height - 1 do
            begin
            brg:= bmk.ScanLine[y];
            for x:= 0 to bmk.Width - 1 do
              begin
              FillChar(brg^, SizeOf(TRgbTriple), not brg^.rgbReserved);
              Inc(Integer(brg), 4);
            end;
          end;
        end;
        bmk.PixelFormat:= pf24bit;
        ImgLst.Add(bmp, bmk);
      finally
        bmk.Free;
      end;
    finally
      bmp.Free;
    end;
  finally
    png.Free;
  end;

end;

procedure TransparentBase(const Canv: TCanvas; Area: TRect);
var
  xrc, yrc: integer;
  xlp, ylp: integer;
  xlc, ylc: integer;
begin

  xrc:= (Area.Right - Area.Left) div 8;
  yrc:= (Area.Bottom - Area.Top) div 8;
  for xlp:= 0 to xrc do
    for ylp:= 0 to yrc do
      with Canv do
        begin
        if (xlp mod 2) = (ylp mod 2) then
          Brush.Color:= clGray
        else
          Brush.Color:= clWhite;
        xlc:= Area.Left+(xlp*8); ylc:= Area.Top+(ylp*8);
        Rectangle(xlc, ylc, xlc+8, ylc+8);
      end;

end;

function BlendRGB(const Color1, Color2: TColor; const Blend: Integer): TColor;
{ Buat ColorBlend dengan paduan Warna1 dan Warna2 supaya bisa nge-buat form
  ColorBlend. Blend warna harus diantara 0 dan 63; 0 = semua Warna1,
  63 = semua Warna2. }
type
  TColorBytes = array[0..3] of Byte;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to 2 do
    TColorBytes(Result)[I] := Integer(TColorBytes(Color1)[I] +
      ((TColorBytes(Color2)[I] - TColorBytes(Color1)[I]) * Blend) div 63);
end;

procedure DrawGradient(Color1, Color2: TColor; Canv: TCanvas; RectArea: TRect; Vert: boolean);
var
  Z: integer;
  CS: TPoint;
begin

  for Z := 0 to 63 do
    begin

    Canv:= Canv;
    CS:= RectArea.BottomRight;
    Canv.Pen.Width:= 0;
    Canv.Brush.Style:= bsSolid;
    Canv.Brush.Color:= BlendRGB(ColorToRGB(Color1), ColorToRGB(Color2), Z);
    Canv.Pen.Color:= Canv.Brush.Color;

    if Vert then
      Canv.Rectangle(RectArea.Left, RectArea.Top + MulDiv(CS.Y, Z, 63), CS.X, MulDiv(CS.Y, Z+1, 63))
    else
      Canv.Rectangle(RectArea.Left + MulDiv(CS.X, Z, 63), RectArea.Top, MulDiv(CS.X, Z+1, 63), CS.Y);

  end;

end;

function MakeToolbarBackground(const Height: integer): TBitmap;
var
  bmp: TBitmap;
begin
  bmp:= TBitmap.Create;
  bmp.SetSize(8, Height);
  bmp.Canvas.Lock;
  try
    DrawGradient(clBtnFace, clWindow, bmp.Canvas, Rect(0, 0, 8, Height), TRUE);
  finally
    bmp.Canvas.Unlock;
  end;
  Result:= bmp;
end;

procedure DrawAntiAliased(const Pic: TGraphic; const DestCanvas: TCanvas; const Rect: TRect);
var
  Mf: TMetaFile;
  Mc: TMetafileCanvas;
  BaseBg, ImgBm: TBitmap;
  CopyRc: TRect;
  DC: HDC;
  w, h: integer;
begin
  w:= Pic.Width;
  h:= Pic.Height;
  DC:= GetDC(0);
  Mf:= TMetaFile.Create;
  try
    Mf.Enhanced:= TRUE;
    Mf.Width:= w;
    Mf.Height:= h;
    Mc:= TMetafileCanvas.Create(Mf, DC);
    try
      ImgBm:= TBitmap.Create;
      try
        ImgBm.PixelFormat:= pf24Bit;
        ImgBm.Width:= w;
        ImgBm.Height:= h;
        BaseBg:= TBitmap.Create;
        try
          BaseBg.PixelFormat:= pf24Bit;
          BaseBg.Width:= Rect.Right - Rect.Left;
          BaseBg.Height:= Rect.Bottom - Rect.Top;
          BaseBg.Canvas.Lock;
          try
            BitBlt(BaseBg.Canvas.Handle, 0, 0, BaseBg.Width, BaseBg.Height, DestCanvas.Handle, Rect.Left, Rect.Top, SRCCOPY);
          finally
            BaseBg.Canvas.Unlock;
          end;
          CopyRc.Top:= 0;
          CopyRc.Left:= 0;
          CopyRc.Right:= w;
          CopyRc.Bottom:= h;
          ImgBm.Canvas.Lock;
          try
            ImgBm.Canvas.StretchDraw(CopyRc, BaseBg);
          finally
            ImgBm.Canvas.Unlock;
          end;
        finally
          BaseBg.Free;
        end;
        ImgBm.Canvas.Lock;
        try
          ImgBm.Canvas.Draw(0, 0, Pic);
        finally
          ImgBm.Canvas.Unlock;
        end;
        Mc.Lock;
        try
          Mc.Draw(0, 0, ImgBm);
        finally
          Mc.Unlock;
        end;
      finally
        ImgBm.Free;
      end;
    finally
      Mc.Free;
    end;
    Gdip.DrawAntiAliased(Mf, DestCanvas.Handle, Rect);
  finally
    Mf.Free;
    ReleaseDC(0, DC);
  end;
end;

initialization

{$IFNDEF DEBUG}
  Gdip:= TGdiPlusFull.Create(ExtractFilePath(ParamStr(0)) + 'gdiplus.dll');
{$ENDIF}

end.
