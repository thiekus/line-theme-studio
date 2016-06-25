unit uMain;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015 - 2016                                  *)
(*                                                                            *)
(* Section Desc: MainForm module                                              *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ActnList, Menus, AbZipper, AbBase, AbUtils,
  AbBrowse, AbZBrows, AbUnzper, StdCtrls, Buttons, VirtualTrees, NiceSideBar,
  CustomUtils, ImgList, PngImage, DCPsha256, AdbExec, DragDrop, DropTarget,
  DragDropFile, LtsType, UpdaterNotify, ShellAPI, IniFiles, madExceptVcl,
  Registry;

type
  TSectionPage = (spMain, spInfo, spProp, spEdit, spResc);

type
  TfrmMain = class(TForm)
    mmMenu: TMainMenu;
    File1: TMenuItem;
    actLst: TActionList;
    sbar: TStatusBar;
    pnlItem: TPanel;
    pnlEdit: TPanel;
    unzp: TAbUnZipper;
    zipr: TAbZipper;
    actOpen: TAction;
    actExit: TAction;
    odlg: TOpenDialog;
    sdlg: TSaveDialog;
    OpenThemefile1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    actSave: TAction;
    actSaveAs: TAction;
    N2: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    sdbar: TNiceSideBar;
    actClose: TAction;
    Close1: TMenuItem;
    Edit1: TMenuItem;
    actTreeVw: TAction;
    reeViewpropertyeditor1: TMenuItem;
    prgs: TProgressBar;
    actTextEdt: TAction;
    exteditor1: TMenuItem;
    actResc: TAction;
    Resourcesbrowser1: TMenuItem;
    View1: TMenuItem;
    actAbout: TAction;
    About1: TMenuItem;
    actNew: TAction;
    NewfromTheme1: TMenuItem;
    imgSdbar: TImageList;
    pbMain: TPaintBox;
    actShSdbar: TAction;
    ShowSidebar1: TMenuItem;
    actSendMail: TAction;
    Action1: TMenuItem;
    Sendtoemail1: TMenuItem;
    actSendAnd: TAction;
    SendtoAndroiddevice1: TMenuItem;
    imgLst: TImageList;
    drpTheme: TDropFileTarget;
    actPref: TAction;
    N3: TMenuItem;
    Preferences1: TMenuItem;
    actHelp: TAction;
    Helpcontents1: TMenuItem;
    N4: TMenuItem;
    actGotoWeb: TAction;
    KhayalanSoftwareWebsite1: TMenuItem;
    actMan: TAction;
    hemeInformation1: TMenuItem;
    MadExceptHnd: TMadExceptionHandler;
    procedure FormCreate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure sbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure sdbarSelect(Sender: TObject; Index, SubIndex: Integer;
      Caption: string);
    procedure actCloseExecute(Sender: TObject);
    procedure actTreeVwExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actTextEdtExecute(Sender: TObject);
    procedure actRescExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pbMainPaint(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actShSdbarExecute(Sender: TObject);
    procedure actSendMailExecute(Sender: TObject);
    procedure actSendAndExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure drpThemeDrop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure actPrefExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actGotoWebExecute(Sender: TObject);
    procedure actManExecute(Sender: TObject);
  private
    { Private declarations }

    InitStudio: boolean;

    CompressLevel: Integer;
    CanShowWelcome, CanCheckUpdate, AppUseSkin: Boolean;

    LastIdx, LastSubIdx: integer;
    CurrentPage: TSectionPage;
    AppLogo: TPngImage;

    procedure LoadAppConfig;
    procedure FreeAppConfig;
    procedure SetAppTempDir;
    procedure DelAppTempDir;

  public
    { Public declarations }

    ThemeOpened: boolean;
    ThemeChange: boolean;
    ThemePacked: Boolean;
    PropInit, EditInit, RescInit: boolean;
    ThemeOrigin: string;
    ThemePath: string;
    ThemeFnme: string;

    RescFileCnt: integer;
    RescFilePrc: integer;
    RescFiles: TThemeFiles;
    ThemeProp: TMemoryStream;
    PicEditors: array of TPicEditor;
    PicEditCnt: Integer;
    SaveCounter: Integer;

    AppTemporaryDir: string;

    function  OpenThemeEditor(ThemeFile: string; const Clone: boolean = FALSE): boolean;
    procedure BlankThemeEditor;
    function  SaveThemeFile(ThemeFile: string = ''): boolean;
    function  SaveEditChanges: boolean;
    function  AskModified: boolean;
    procedure DeleteStreamFromList(const Index: integer);
    procedure CleanStreamList;
    function  SearchStreamIndex(const StreamPath: string): Integer;
    function  SearchStream(const StreamPath: string): TMemoryStream;

    procedure ShowPage(Page: TSectionPage);
    procedure SetStatus(Status: string);
    procedure SetAppCaption(OpenFile: string = '');
    procedure SetChanged(Change: boolean = TRUE);
    procedure SetSidebarIndex(Index, SubIndex: integer);

  end;

var
  frmMain: TfrmMain;

implementation

uses
  uProp, uResc, uEdit, uAbout, uAdbPush, uSendOpt, uWelcome, uCfg,
  AbZipTyp, uManedit, uMedsos, uThemeOpenDlg;

{$R *.dfm}
{$R '../icons/SdbrGlyph.RES'}
const SdbarGlyphCount = 4;

{ TfrmMain }

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  About: TfrmAbout;
begin

  About:= TfrmAbout.Create(Application);
  try
    About.ShowModal;
  finally
    About.Free;
  end;

end;

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin

  if AskModified then
    BlankThemeEditor;

end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin

  Close;

end;

procedure TfrmMain.actGotoWebExecute(Sender: TObject);
begin

  ShellExecute(Handle, 'open', PChar('http://www.khayalan.id/'), nil, nil, SW_SHOW);

end;

procedure TfrmMain.actHelpExecute(Sender: TObject);
begin

  ShellExecute(Handle, 'open', PChar(ExtractFilePath(ParamStr(0)) + 'Help.chm'), nil, nil, SW_SHOW);

end;

procedure TfrmMain.actManExecute(Sender: TObject);
begin

  ShowPage(spInfo);

end;

procedure TfrmMain.actNewExecute(Sender: TObject);
var
  dl: TdlgOpenTheme;
begin

  dl:= TdlgOpenTheme.Create(Self);
  try
    dl.FixedDir:= True;
    dl.dlOpen.InitialDir:= ExtractFilePath(ParamStr(0)) + 'Template\';
    if dl.ShowModal = mrOk then
      OpenThemeEditor(dl.dlOpen.FileName, True);
  finally
    dl.Free;
  end;

  {if odlg.Execute then
    OpenThemeEditor(odlg.FileName, TRUE);}

end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
var
  dl: TdlgOpenTheme;
begin

  dl:= TdlgOpenTheme.Create(Self);
  try
    dl.FixedDir:= False;
    if dl.ShowModal = mrOk then
      OpenThemeEditor(dl.dlOpen.FileName);
  finally
    dl.Free;
  end;
  {odlg.InitialDir:= ExtractFilePath(ParamStr(0));
  if odlg.Execute then
    OpenThemeEditor(odlg.FileName);}

end;

procedure TfrmMain.actPrefExecute(Sender: TObject);
begin

  if frmCfg.ShowModal = mrOk then
    begin
    FreeAppConfig;
    LoadAppConfig;
  end;

end;

procedure TfrmMain.actRescExecute(Sender: TObject);
begin

  ShowPage(spResc);

end;

procedure TfrmMain.actSaveAsExecute(Sender: TObject);
begin

  sdlg.FileName:= ThemePath;
  if sdlg.Execute then
    SaveThemeFile(sdlg.FileName);

end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin

  if ThemePath = '' then
    begin
    if sdlg.Execute then
      SaveThemeFile(sdlg.FileName)
    else
      Exit;
  end
  else
    SaveThemeFile();

end;

procedure TfrmMain.actSendAndExecute(Sender: TObject);
var
  Dev, TPath: string;
  SendDlg: TfrmAdbSend;
  SendPush: TfrmAdbp;
begin

  SendDlg:= TfrmAdbSend.Create(Application);
  SendPush:= TfrmAdbp.Create(Application);
  try
    if SendDlg.GetTargetDevice(Dev, TPath) then
      if SendPush.PushFromAdb(Dev, ThemePath, TPath) then
        MessageDlg('Your theme was sucessfully delivered!', mtInformation, [mbOK], 0)
      else
        MessageDlg('Error while send your theme into selected device!', mtError, [mbOK], 0);
  finally
    SendDlg.Free;
    SendPush.Free;
  end;
end;

procedure TfrmMain.actSendMailExecute(Sender: TObject);
var
  mail, note: string;
  body: TStringList;
  fck: TFileStream;
  sha: TDCP_Sha256;
  digest: array[0..31] of byte;
  {$IF CompilerVersion >= 20}
  digstr: array[0..64] of char;
  {$ELSE}
  digstr: string[64];
  {$IFEND}
  lp: integer;
begin

  mail:= InputBox('Send via e-mail', 'Enter your destination email address', '');
  if mail <> '' then
    begin
    body:= TStringList.Create;
    try
      body.Clear;
      note:= InputBox('Add note to e-mail', 'Enter note to destination mail body', '');
      if note <> '' then
        begin
        body.Add(note);
        body.Add('');
      end;
      fck:= TFileStream.Create(ThemePath, fmOpenRead);
      try
        fck.Position:= 0;
        sha:= TDCP_Sha256.Create(Self);
        try
          sha.Init;
          sha.UpdateStream(fck, fck.Size);
          sha.Final(digest);
        finally
          sha.Free;
        end;
      finally
        fck.Free;
      end;
      digstr:= '';
      for lp:= 0 to 31 do
        {$IF CompilerVersion >= 20}
        StrCopy(@digstr[lp*2], PChar(IntToHex(digest[lp], 2)));
        {$ELSE}
        digstr:= digstr + IntToHex(digest[lp], 2);
        {$IFEND}
      {$IF CompilerVersion >= 20}
      digstr[64]:= #0;
      {$IFEND}
      body.Add('This theme was sent by Line Theme Studio.');
      body.Add(Format('SHA-256 checksum: %s', [digstr]));
      {$WARNINGS OFF}
      SendMail(Handle, 'Line ThemeFile received', body.Text, mail, [ThemePath]);
      {$WARNINGS ON}
    finally
      body.Free;
    end;
  end;

end;

procedure TfrmMain.actShSdbarExecute(Sender: TObject);
begin

  pnlItem.Visible:= not pnlItem.Visible;
  actShSdbar.Checked:= pnlItem.Visible;

end;

procedure TfrmMain.actTextEdtExecute(Sender: TObject);
begin

  ShowPage(spEdit);

end;

procedure TfrmMain.actTreeVwExecute(Sender: TObject);
begin

  ShowPage(spProp);

end;

function TfrmMain.AskModified: boolean;
begin

  if ThemeOpened and ThemeChange then
    begin
    case MessageDlg(Format('Do you want to save %s before closing?', [ThemeFnme]),
                  mtConfirmation, [mbYes, mbNo, mbCancel], 0) of

      mrYes: begin
               if ThemePath = '' then
                 begin
                 if sdlg.Execute then
                   begin
                   SaveThemeFile(sdlg.FileName);
                   Result:= TRUE;
                 end
                 else
                  Result:= FALSE;
                 end
               else
                 begin
                 SaveThemeFile();
                 Result:= TRUE;
               end;
             end;

      mrNo: Result:= TRUE;

    else
      Result:= FALSE;
    end;
  end
  else
    Result:= TRUE;

end;

procedure TfrmMain.BlankThemeEditor;
begin

  ThemePath:= '';
  ThemeFnme:= '';
  SetAppCaption();

  prgs.Position:= 0;
  prgs.Update;
  SetStatus('Drag to logo window or select from menu item to open themefile');

  (* Sisakan sidebar untuk New dan Open *)
  with sdbar.Items[0].Items do
    begin
    Clear;
    Add(RemoveAmp(actNew.Caption));
    Add(RemoveAmp(actOpen.Caption));
  end;

  (* Sembunyikan property dan resources *)
  sdbar.Items[1].Visible:= FALSE;
  sdbar.Items[2].Visible:= FALSE;
  LastIdx:= -1;
  LastSubIdx:= -1;

  (* Nonaktifkan fungsi *)
  actSave.Enabled:= FALSE;
  actSaveAs.Enabled:= FALSE;
  actClose.Enabled:= FALSE;

  actTreeVw.Enabled:= FALSE;
  actTextEdt.Enabled:= FALSE;
  actResc.Enabled:= FALSE;

  actSendAnd.Enabled:= FALSE;

  if ThemeOpened then
    begin
    ThemeOpened:= FALSE;
    CleanStreamList;
  end;

  (* Tutup page lainnya *)
  ShowPage(spMain);

end;

procedure TfrmMain.CleanStreamList;
var
  zfra: integer;
begin

  if (RescFiles <> nil) and (RescFilePrc > 0) then
    for zfra:= 0 to RescFilePrc - 1 do
      begin
      RescFiles[zfra].Name:= '';
      RescFiles[zfra].Path:= '';
      if RescFiles[zfra].Data <> nil then
        RescFiles[zfra].Data.Free;
      RescFiles[zfra].Data:= nil;
    end;

  RescFilePrc:= 0;
  RescFiles:= nil;
  ThemeProp:= nil;

end;

procedure TfrmMain.DelAppTempDir;
begin

  if DirectoryExists(AppTemporaryDir) then
    RemoveDirectory(PChar(AppTemporaryDir));

end;

procedure TfrmMain.DeleteStreamFromList(const Index: integer);
var
  lp: Integer;
begin

  RescFiles[Index].Name:= '';
  RescFiles[Index].Data.Free;
  if Index < RescFilePrc-1 then
    for lp:= Index to RescFilePrc-2 do
      begin
      RescFiles[Index]:= RescFiles[Index+1];
    end;
  Dec(RescFilePrc);
  Dec(RescFileCnt);
  SetLength(RescFiles, RescFilePrc);

end;

procedure TfrmMain.drpThemeDrop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
begin

  OpenThemeEditor(drpTheme.Files[0]);

end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  regcheck, regmake: TRegistry;
  medsos: Boolean;
begin

  if not InitStudio then
    begin

    BlankThemeEditor;
    InitStudio:= TRUE;

    regcheck:= TRegistry.Create(KEY_READ);
    medsos:= False;
    try
      try
        regcheck.RootKey:= HKEY_CURRENT_USER;
        try
          regcheck.OpenKeyReadOnly('\Software\Khayalan Software\Line Theme Studio');
          medsos:= regcheck.ReadBool('LikeOnSocialMedia');
          SaveCounter:= regcheck.ReadInteger('SaveCount');
        except
          regmake:= TRegistry.Create(KEY_CREATE_SUB_KEY or KEY_WRITE);
          try
            regmake.RootKey:= HKEY_CURRENT_USER;
            regmake.OpenKey('\Software\Khayalan Software\Line Theme Studio', TRUE);
            medsos:= False;
            SaveCounter:= 0;
            regmake.WriteBool('LikeOnSocialMedia', FALSE);
            regmake.WriteInteger('SaveCount', 0);
          finally
            regmake.CloseKey;
            regmake.Free;
          end;
        end;
      finally
        regcheck.CloseKey;
        regcheck.Free;
      end;
    except
      ShowMessage('Gagal mengkonfigurasi pengaturan aplikasi melalui registry!');
    end;

    if CanShowWelcome then
      begin
      if SaveCounter > 0 then
        frmWelcome.lblCount.Caption:= Format('Anda telah menyimpan tema LINE sebanyak %d kali.', [SaveCounter])
      else
        frmWelcome.lblCount.Caption:= 'Anda sama sekali belum pernah menyimpan tema!';
      frmWelcome.ShowModal;
    end;
    if (not medsos) and (SaveCounter >= 3)  then
      frmMedsos.ShowModal;

  end;

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  BlankThemeEditor;

end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  CanClose:= AskModified;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  pbs, zfra: integer;
  bmp: TBitmap;
  png: TPngImage;
  skres: TResourceStream;
begin

  (* Atur Lokasi ADB *)
  Adx_SetAdbProgram(ExtractFilePath(ParamStr(0)) + 'adb\adb.exe');

  (* Letakan progressbar di status bar *)
  sbar.DoubleBuffered:= TRUE;
  sbar.Panels[0].Style:= psOwnerDraw;
  prgs.Parent:= sbar;
  pbs:= GetWindowLong(sbar.Handle, GWL_EXSTYLE);
  pbs:= pbs - WS_EX_STATICEDGE;
  SetWindowLong(prgs.Parent.Handle, GWL_EXSTYLE, pbs);
  prgs.Position:= 0;

  (* Besar window default *)
  Width:= 960;
  Height:= 660;
  Position:= poDesktopCenter;

  imgSdbar.Clear;
  png:= TPngImage.Create;
  try
    for zfra:= 0 to SdbarGlyphCount - 1 do
      begin
      png.LoadFromResourceName(hInstance, Format('SDBR_%.2d', [zfra]));
      bmp:= TBitmap.Create;
      try
        bmp.PixelFormat:= pf32bit;
        bmp.SetSize(png.Width, png.Height);
        bmp.Canvas.Lock;
        try
          bmp.Canvas.Brush.Color:= ColorToRGB(clWindow);
          bmp.Canvas.Brush.Style:= bsSolid;
          bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
          bmp.Canvas.Draw(0, 0, png);
        finally
          bmp.Canvas.Unlock;
        end;
        imgSdbar.Add(bmp, bmp);
      finally
        bmp.Free;
      end;
      sdbar.Items[zfra].ImageIndex:= zfra;
    end;
  finally
    png.Free;
  end;

  AppLogo:= TPngImage.Create;
  AppLogo.LoadFromResourceName(hInstance, 'ABOUT_LOGO');

  LoadAppConfig;
  SetAppTempDir;

  InitStudio:= FALSE;

  if CanCheckUpdate then
    ProvideNotify(Self.Handle);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  FreeAppConfig;
  DelAppTempDir;
  AppLogo.Free;

end;

procedure TfrmMain.FreeAppConfig;
var
  x: Integer;
begin

  if PicEditCnt > 0 then
    begin
    for x:= 0 to PicEditCnt - 1 do
      with PicEditors[x] do
        begin
        AppName:= '';
        AppPath:= '';
        CommandLine:= '';
        WindowClass:= '';
        WindowName:= '';
      end;
    PicEditCnt:= 0;
    PicEditors:= nil;
  end;

end;

procedure TfrmMain.LoadAppConfig;
const
  cfg = 'Config';
  ped = 'PictureEditor';
var
  ini: TIniFile;
  loc: string;
  x, i: Integer;
begin

  loc:= ChangeFileExt(ParamStr(0), '.ini');
  if not FileExists(loc) then
    begin
    ini:= TIniFile.Create(loc);
    try
      ini.WriteInteger(cfg, 'CompressionLevel', 3);
      ini.WriteBool(cfg, 'CheckUpdate', TRUE);
      ini.WriteBool(cfg, 'ShowWelcome', TRUE);
      ini.WriteBool(cfg, 'AppSkin', TRUE);
      ini.WriteInteger(ped, 'EditorCount', 1);
      ini.WriteString(ped, 'AppName.1', 'Fotografix');
      ini.WriteString(ped, 'AppPath.1', 'fotografix\Fotografix.exe');
      ini.WriteString(ped, 'AppCmd.1', '%s');
      ini.WriteBool(ped, 'AdvancedDragDrop.1', TRUE);
      ini.WriteString(ped, 'AppWindowClass.1', 'MDIClient');
      ini.WriteString(ped, 'AppWindowName', '');
    finally
      ini.Free;
    end;
  end;

  ini:= TIniFile.Create(loc);
  try
    CompressLevel:= ini.ReadInteger(cfg, 'CompressionLevel', 3);
    CanCheckUpdate:= ini.ReadBool(cfg, 'CheckUpdate', TRUE);
    CanShowWelcome:= ini.ReadBool(cfg, 'ShowWelcome', TRUE);
    AppUseSkin:= ini.ReadBool(cfg, 'AppSkin', TRUE);
    PicEditCnt:= ini.ReadInteger(ped, 'EditorCount', 0);
    if PicEditCnt > 0 then
      begin
      SetLength(PicEditors, PicEditCnt);
      for x:= 0 to PicEditCnt - 1 do
        with PicEditors[x] do
          begin
          AppName:= ini.ReadString(ped, 'AppName.1', 'Fotografix');
          AppPath:= ini.ReadString(ped, 'AppPath.1', 'fotografix\Fotografix.exe');
          CommandLine:= ini.ReadString(ped, 'AppCmd.1', '%s');
          AdvancedDragDrop:= ini.ReadBool(ped, 'AdvancedDragDrop.1', TRUE);
          WindowClass:= ini.ReadString(ped, 'AppWindowClass.1', 'MDIClient');
          WindowName:= ini.ReadString(ped, 'AppWindowName', '');
        end;
    end;
  finally
    ini.Free;
  end;

  // Perubahan skin
  //sseng.Active:= AppUseSkin;

end;

function TfrmMain.OpenThemeEditor(ThemeFile: string; const Clone: boolean): boolean;
var
  zfra: integer;
  prcname: string;
  tjs: boolean;
begin

  (* Check ada file tema *)
  if not FileExists(ThemeFile) then
    begin
    MessageDlg(Format('File tema "%s" tidak ditemukan!', [ThemeFile]), mtError, [mbOK], 0);
    Result:= FALSE;
    Exit;
  end;

  (* Kalo yang lama masih terbuka *)
  if ThemeOpened then
    BlankThemeEditor;
  if not Clone then
    ThemePath:= ThemeFile
  else
    ThemePath:= ''; (* Tanpa path untuk save jika klonengan *)

  (* Buka arsip *)
  try
    unzp.OpenArchive(ThemeFile);
    RescFileCnt:= unzp.Count;
    if RescFileCnt = 0 then
      begin
      MessageDlg(Format('File tema "%s" tidak memuat file apapun!', [ThemeFile]), mtError, [mbOK], 0);
      unzp.CloseArchive;
      Result:= FALSE;
      Exit;
    end;
  except
    MessageDlg(Format('File tema "%s" memuat data yang tidak dikenal!', [ThemeFile]), mtError, [mbOK], 0);
    RescFileCnt:= 0;
    Result:= FALSE;
    Exit;
  end;

  (* Extract isi file ke memori *)
  pnlItem.Enabled:= FALSE;
  pnlEdit.Enabled:= FALSE;
  try
    tjs:= FALSE;
    SetLength(RescFiles, RescFileCnt);
    ZeroMemory(@RescFiles[0], RescFileCnt * SizeOf(TThemeFile));
    RescFilePrc:= 0;
    ThemeProp:= nil;
    for zfra:= 0 to RescFileCnt - 1 do
      begin
      prcname:= unzp.Items[zfra].FileName;
      SetStatus(Format('Extracting file: %s', [prcname]));
      RescFiles[zfra].Name:= AfterSlashName(PChar(prcname));
      RescFiles[zfra].Path:= prcname;
      RescFiles[zfra].Data:= TMemoryStream.Create;
      with RescFiles[zfra].Data do
        begin
        Size:= unzp.Items[zfra].UncompressedSize;
        Position:= 0;
      end;
      unzp.ExtractToStream(prcname, RescFiles[zfra].Data);
      if UpperCase(prcname) = 'THEME.JSON' then
        begin
        ThemeProp:= RescFiles[zfra].Data;
        tjs:= TRUE;
      end;
      Inc(RescFilePrc);
      prgs.Position:= Round((RescFilePrc / RescFileCnt) * 100);
      prgs.Update;
      Application.ProcessMessages;
    end;
  finally
    unzp.CloseArchive;
    pnlItem.Enabled:= TRUE;
    pnlEdit.Enabled:= TRUE;
  end;

  (* File 'theme.json' tidak ditemukan ? *)
  if not tjs then
    begin
    MessageDlg(Format('Themes.json tidak ditemukan di arsip thema "%s"!', [ThemeFile]), mtError, [mbOK], 0);
    CleanStreamList;
    Result:= FALSE;
    Exit;
  end;

  with sdbar.Items[0].Items do
    begin
    Clear;
    Add(RemoveAmp(actNew.Caption));
    Add(RemoveAmp(actOpen.Caption));
    Add(RemoveAmp(actSave.Caption));
    Add(RemoveAmp(actSaveAs.Caption));
    Add(RemoveAmp(actClose.Caption));
  end;

  (* Tampilkan editor *)
  sdbar.Items[1].Visible:= TRUE;
  sdbar.Items[2].Visible:= TRUE;

  (* Aktifkan berberapa fungsi *)
  actSave.Enabled:= TRUE;
  actSaveAs.Enabled:= TRUE;
  actClose.Enabled:= TRUE;

  actTreeVw.Enabled:= TRUE;
  actTextEdt.Enabled:= TRUE;
  actResc.Enabled:= TRUE;

  actSendAnd.Enabled:= TRUE;

  (* Selesai *)
  ThemeFnme:= ExtractFileName(ThemeFile);
  if Clone then
    ThemeFnme:= ThemeFnme + ' (Clone Mode)';
  SetStatus(Format('File "%s" opened successfully!', [ThemeFnme]));
  SetAppCaption(ThemeFnme);
  ThemeOpened:= TRUE;
  ThemeChange:= FALSE;
  PropInit:= FALSE;
  EditInit:= FALSE;
  RescInit:= FALSE;
  Result:= ThemeOpened;
  LastIdx:= 1;
  LastSubIdx:= 0;
  ShowPage(spProp);
  //ShowPage(spInfo);

end;

procedure TfrmMain.pbMainPaint(Sender: TObject);
const
  VersX = 242; VersY = 60;
var
  Lx, Ly: Integer;
begin

  with pbMain.Canvas do
    begin

    DrawGradient($FFFFFF, $B7E2CA, pbMain.Canvas, pbMain.ClientRect);

    Lx:= (pbMain.ClientWidth - AppLogo.Width) div 2;
    Ly:= (pbMain.ClientHeight - AppLogo.Height) div 2;
    Draw(Lx, Ly, AppLogo);
    Brush.Style:= bsClear;
    Font.Color:= clWindowText;
    Font.Name:= 'Tahoma';
    Font.Size:= 10;
    TextOut(Lx+VersX, Ly+VersY, GetAppVer);

  end;

end;

function TfrmMain.SaveEditChanges: boolean;
begin

  Result:= TRUE;
  if ThemeOpened then
    begin
    if fmProp.Showing and ThemeChange then
      PropInit:= not fmProp.SaveJsonTree;
    if fmEdit.Showing and fmEdit.EditorChange then
      Result:= fmEdit.EditorCloseWarn;
  end;

end;

function TfrmMain.SaveThemeFile(ThemeFile: string = ''): boolean;
var
  SaveLoc: string;
  zfra: integer;
  prc: integer;
  prcname: string;
  DefOpt: TAbZipDeflationOption;
  regcnt: TRegistry;
begin

  if ThemeFile = '' then
    SaveLoc:= ThemePath
  else
    SaveLoc:= ThemeFile;

  if FileExists(SaveLoc) then
    DeleteFile(SaveLoc);

  (* Beritahu kalau ada perubahan dan simpan ke memori sebelum dipacking *)
  if not SaveEditChanges then
    begin
    Result:= False;
    Exit;
  end;

  try
    zipr.ForceType:= TRUE;
    zipr.ArchiveType:= atZip;
    zipr.OpenArchive(SaveLoc);
    if (CompressLevel > 0) and (CompressLevel <= 4) then
      begin
      zipr.CompressionMethodToUse:= smDeflated;
      case CompressLevel of
        0: DefOpt:= doMaximum;
        1: DefOpt:= doSuperFast;
        2: DefOpt:= doFast;
      else
         DefOpt:= doNormal;
      end;
      zipr.DeflationOption:= DefOpt;
    end
    else
      begin
      zipr.CompressionMethodToUse:= smStored;
      zipr.DeflationOption:= doNormal;
    end;
  except
    MessageDlg(Format('Tidak dapat menyimpan tema ke file "%s"!', [SaveLoc]), mtError, [mbOK], 0);
    Result:= FALSE;
    Exit;
  end;

  pnlItem.Enabled:= FALSE;
  pnlEdit.Enabled:= FALSE;
  try
    prc:= 0;
    for zfra:= 0 to RescFileCnt - 1 do
      begin
      prcname:= RescFiles[zfra].Path;
      SetStatus(Format('Compressing file: %s', [prcname]));
      zipr.AddFromStream(prcname, RescFiles[zfra].Data);
      Inc(prc);
      prgs.Position:= Round((prc / RescFileCnt) * 100);
      prgs.Update;
      Application.ProcessMessages;
    end;
    SetStatus(Format('File "%s" saved successfully!', [ExtractFileName(SaveLoc)]));
    ThemePath:= SaveLoc;
    Result:= TRUE;
  finally
    zipr.CloseArchive;
    pnlItem.Enabled:= TRUE;
    pnlEdit.Enabled:= TRUE;
  end;

  ThemeFnme:= ExtractFileName(ThemePath);
  SetAppCaption(ThemeFnme);

  Inc(SaveCounter);
  regcnt:= TRegistry.Create(KEY_WRITE);
  try
    regcnt.RootKey:= HKEY_CURRENT_USER;
    regcnt.OpenKey('\Software\Khayalan Software\Line Theme Studio', TRUE);
    regcnt.WriteInteger('SaveCount', SaveCounter);
  finally
    regcnt.CloseKey;
    regcnt.Free;
  end;

end;

procedure TfrmMain.sbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin

  if Panel = sbar.Panels[0] then
    with prgs do
      begin
      Top:= Rect.Top;
      Left:= Rect.Left;
      Width:= Rect.Right - Rect.Left;
      Height:= Rect.Bottom - Rect.Top;
    end;

end;

procedure TfrmMain.sdbarSelect(Sender: TObject; Index, SubIndex: Integer;
  Caption: string);

  procedure OpenAction(const Act: TAction); inline;
  begin
    if Act.Enabled then
      Act.Execute;
  end;

begin

  case Index of

    (* Files *)
    0: begin
         (* Event properti "Files" *)
         case SubIndex of
           (* New *)
           0: OpenAction(actNew);
           (* Open *)
           1: OpenAction(actOpen);
           (* Save *)
           2: OpenAction(actSave);
           (* Save As *)
           3: OpenAction(actSaveAs);
           (* Close file *)
           4: OpenAction(actClose);
         end;
       end;

    (* Theme Properties *)
    1: begin
         (* Event properti "Theme Properties" *)
         case SubIndex of
           (* Manifest Editor *)
           //0: OpenAction(actMan);
           (* TreeView Editor *)
           0: OpenAction(actTreeVw);
           (* Text Editor *)
           1: OpenAction(actTextEdt);
           (* Resource browser *)
           2: OpenAction(actResc);
         end;

       end;

    2: begin
         (* Event Properti "Share" *)
         case SubIndex of
           (* Send android *)
           0: OpenAction(actSendAnd);
         end;

       end;

    3: begin
         (* Event properti "Help" *)
         case SubIndex of
           (* Show Help *)
           0: OpenAction(actHelp);
           (* About Appplication *)
           1: OpenAction(actAbout);
         end;
       end;

  end;

  if Index = 1 then
    begin
    LastIdx:= Index;
    LastSubIdx:= SubIndex;
  end
  else
    begin
    sdbar.ItemIndex:= LastIdx;
    sdbar.SubItemIndex:= LastSubIdx;
    LastIdx:= -1;
    LastSubIdx:= -1;
  end;

end;

function TfrmMain.SearchStream(const StreamPath: string): TMemoryStream;
begin

  Result:= RescFiles[SearchStreamIndex(StreamPath)].Data;

end;

function TfrmMain.SearchStreamIndex(const StreamPath: string): Integer;
var
  sn: string;
  zfra: integer;
begin

  sn:= UpperCase(StreamPath);
  Result:= -1;
  for zfra:= 0 to RescFileCnt - 1 do
    if sn = UpperCase(RescFiles[zfra].Path) then
      begin
      Result:= zfra;
      Break;
    end;

end;

procedure TfrmMain.SetAppCaption(OpenFile: string);
begin

  if OpenFile = '' then
    Self.Caption:= Format('Line Theme Studio %s', [GetAppVer])
  else
    Self.Caption:= Format('Line Theme Studio %s - %s', [GetAppVer, OpenFile]);

end;

procedure TfrmMain.SetAppTempDir;
var
  buf: array[0..255] of char;
  bf2: string;
  len: LongWord;
  prcid: Cardinal;
begin

  len:= GetTempPath(255, @buf);
  if buf[len] <> '\' then
    begin
    buf[len+1]:= '\';
    buf[len+2]:= #0;
  end;
  bf2:= buf;
  prcid:= GetCurrentProcessId();
  AppTemporaryDir:= Format('%sLineTS_%d\', [bf2, prcid]);
  if not DirectoryExists(AppTemporaryDir) then
    CreateDirectory(PChar(AppTemporaryDir), nil);

end;

procedure TfrmMain.SetChanged(Change: boolean);
begin

  ThemeChange:= Change;
  PropInit:= Change and (CurrentPage = spProp);
  EditInit:= Change and (CurrentPage = spEdit);
  RescInit:= Change and (CurrentPage = spResc);
  SetAppCaption(ThemeFnme+'*');

end;

procedure TfrmMain.SetSidebarIndex(Index, SubIndex: integer);
begin

  sdbar.ItemIndex:= Index;
  sdbar.SubItemIndex:= SubIndex;

end;

procedure TfrmMain.SetStatus(Status: string);
begin

  sbar.Panels[1].Text:= Status;
  sbar.Update;

end;

procedure TfrmMain.ShowPage(Page: TSectionPage);

  procedure SetFormAsPage(PageForm: TForm);
  begin
    PageForm.Parent:= pnlEdit;
    PageForm.Align:= alClient;
    PageForm.Show;
  end;

var
  idx, sidx: integer;
  ChgPage: boolean;
begin

  ChgPage:= SaveEditChanges;
  if fmManed.Showing then
    fmManed.Close;
  if fmProp.Showing then
    fmProp.Close;
  if fmEdit.Showing and ChgPage then
    fmEdit.Close;
  if fmResc.Showing then
    fmResc.Close;

  if ChgPage then
    begin
    idx:= 1;

    case Page of
      spInfo: begin
                SetFormAsPage(fmManed);
                sidx:= 0;
              end;
      spProp: begin
                SetFormAsPage(fmProp);
                if not PropInit then
                  fmProp.ParseThemeObject(ThemeProp);
                PropInit:= TRUE;
                sidx:= 1;
              end;
      spEdit: begin
                SetFormAsPage(fmEdit);
                if not EditInit then
                  fmEdit.EditorLoad(ThemeProp);
                EditInit:= TRUE;
                sidx:= 2;
              end;
      spResc: begin
                SetFormAsPage(fmResc);
                if not RescInit then
                  fmResc.RefreshResource('/')
                else
                  fmResc.MakeThumbnails;
                RescInit:= TRUE;
                sidx:= 3;
              end;
    else
      idx:= -1;
      sidx:= -1;
    end;

    CurrentPage:= Page;
    SetSidebarIndex(idx, sidx);

    actTreeVw.Checked:= sdbar.SubItemIndex = 0;
    actTextEdt.Checked:= sdbar.SubItemIndex = 1;
    actResc.Checked:= sdbar.SubItemIndex = 2;

  end
  else
    SetSidebarIndex(LastIdx, LastSubIdx);

end;

end.
