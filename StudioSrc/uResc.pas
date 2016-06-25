unit uResc;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Resources browser                                            *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, TB97Ctls, TB97, TB97Tlbr, ImgList,
  PngImage, CustomUtils, ActnList, Menus, LtsType, ExtDlgs, ResGraphic;

type
  TThumbThrData = record
    AbortExec: boolean;
    IsRun: Boolean;
    Exited: boolean;
    FromIndex: integer;
    FirstData: PFileResc;
    Count: integer;
    Cs: TRtlCriticalSection;
    ImgLst: TImageList;
  end;
  PThumbThrData = ^TThumbThrData;

type
  TfmResc = class(TForm)
    dckRsc: TDock97;
    tlbRsc: TToolbar97;
    ToolbarButton971: TToolbarButton97;
    pnlData: TPanel;
    pnlDesc: TPanel;
    spl: TSplitter;
    pnlImg: TPanel;
    lblRnm: TLabel;
    lblRsz: TLabel;
    lblRdm: TLabel;
    lvResc: TListView;
    RescLst: TImageList;
    cbxRbgn: TComboBox;
    pbxRprv: TPaintBox;
    actResc: TActionList;
    imgRtlb: TImageList;
    actUp: TAction;
    actRefs: TAction;
    ToolbarButton972: TToolbarButton97;
    ToolbarSep971: TToolbarSep97;
    ToolbarButton973: TToolbarButton97;
    ToolbarButton974: TToolbarButton97;
    ToolbarButton975: TToolbarButton97;
    ToolbarSep972: TToolbarSep97;
    ToolbarButton976: TToolbarButton97;
    ToolbarButton977: TToolbarButton97;
    pbRescPan: TPaintBox;
    actRepl: TAction;
    odlgRepl: TOpenDialog;
    ToolbarButton978: TToolbarButton97;
    actPrev: TAction;
    pmDir: TPopupMenu;
    Opendirectory1: TMenuItem;
    actAddResc: TAction;
    actDelResc: TAction;
    actInfo: TAction;
    odlgReplPic: TOpenPictureDialog;
    sdlgImpr: TSaveDialog;
    actExpr: TAction;
    pmFile: TPopupMenu;
    Previewpicture1: TMenuItem;
    N1: TMenuItem;
    Replacefile1: TMenuItem;
    Importfile1: TMenuItem;
    N2: TMenuItem;
    AddResource1: TMenuItem;
    Deleteresource1: TMenuItem;
    Fileinformation1: TMenuItem;
    N3: TMenuItem;
    Refresh1: TMenuItem;
    N4: TMenuItem;
    UpDirectory1: TMenuItem;
    tmrThDelay: TTimer;
    procedure pnlDataResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbxRprvPaint(Sender: TObject);
    procedure lvRescSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure cbxRbgnChange(Sender: TObject);
    procedure lvRescDblClick(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure actRefsExecute(Sender: TObject);
    procedure lvRescKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbRescPanPaint(Sender: TObject);
    procedure actReplExecute(Sender: TObject);
    procedure actPrevExecute(Sender: TObject);
    procedure pbxRprvDblClick(Sender: TObject);
    procedure actInfoExecute(Sender: TObject);
    procedure actExprExecute(Sender: TObject);
    procedure tmrThDelayTimer(Sender: TObject);
  private
    { Private declarations }

    MainCs: TRtlCriticalSection;
    ThumbThrDt: TThumbThrData;
    ThreadHnd: THandle;
    ViewPic: TPngImage;
    LastIdx: integer;
    DelayedThumbnailGen: Boolean;

    procedure AbortMakeThumbnails;
    procedure ProcessItem(Index: integer);

  public
    { Public declarations }

    IndexDir: string;

    IndexLst: array of TFileResc;
    IndexCnt: integer;

    procedure MakeThumbnails;
    procedure RebuildThumbnails;
    procedure RefreshResource(Dir: string); overload;
    procedure RefreshResource; overload;
    procedure ParentDir;

  end;

var
  fmResc: TfmResc;

implementation

uses uMain, uPicView, uFinfo, uPicOpenDlg;

{$R *.dfm}
{$R '../icons/RescGlyph.RES'}
const RescTlbGlyphCount = 8;

{ TfmResc }

procedure GenerateSystemIcon(Index: integer; Bmp: TBitmap; W, H: integer);
var
  bmr: TRect;
  ico: TIcon;
  hbig, hsmall: HIcon;
begin

  Bmp.Width:= W;
  Bmp.Height:= H;
  bmr:= Rect(0, 0, W, H);
  Bmp.Canvas.Lock;
  try

    with bmp.Canvas do
      begin
      Brush.Color:= clWindow;
      Brush.Style:= bsSolid;
      Pen.Style:= psClear;
      FillRect(bmr);
    end;

    if ExtractShellIcon(hbig, hsmall, Index) then
      begin
      ico:= TIcon.Create;
      try
        ico.Handle:= hbig;
        bmp.Canvas.Draw((bmp.Width - ico.Width) div 2,
                        (bmp.Height - ico.Height) div 2,
                         ico);
      finally
        ico.Free;
        DestroyIcon(hbig);
        DestroyIcon(hsmall);
      end;
    end;

  finally
    Bmp.Canvas.Unlock;
  end;

end;

procedure GenerateImageThumbnail(Data: TStream; Bmp: TBitmap; W, H: integer);
var
  bmr, pmr: TRect;
  png: TPngImage;
begin

  Bmp.Width:= W;
  Bmp.Height:= H;
  bmr:= Rect(0, 0, W, H);
  Bmp.Canvas.Lock;
  try

    with Bmp.Canvas do
      begin
      Brush.Color:= clSilver;
      Brush.Style:= bsSolid;
      Pen.Style:= psClear;
      FillRect(bmr);
    end;

    try

      png:= TPngImage.Create;
      try
        Data.Position:= 0;
        png.LoadFromStream(Data);
        pmr.Right:= png.Width - 1;
        pmr.Bottom:= png.Height - 1;
        if (pmr.Right <= bmr.Right-2) and (pmr.Bottom <= bmr.Bottom-2) then
          Bmp.Canvas.Draw((bmr.Right - pmr.Right) div 2,
                          (bmr.Bottom - pmr.Bottom) div 2,
                           png)
        else
          begin
          pmr:= AspectRatio(pmr.Right, pmr.Bottom, bmr.Right-2, bmr.Bottom-2);
          Inc(pmr.Left);
          Inc(pmr.Top);
          Bmp.Canvas.StretchDraw(pmr, png);
          //DrawAntiAliased(png, Bmp.Canvas, pmr);
        end;
      finally
        png.Free;
      end;

    except
      (* Terjadi exception? Kosongkan gambar *)
      with Bmp.Canvas do
        begin
        Brush.Color:= clWindow;
        Brush.Style:= bsSolid;
        Pen.Style:= psClear;
        FillRect(bmr);
      end;
    end;

    with Bmp.Canvas do
      begin
      Brush.Style:= bsClear;
      Pen.Color:= clBlack;
      Pen.Style:= psSolid;
      Rectangle(bmr);
    end;

  finally
    Bmp.Canvas.Unlock;
  end;

end;

function ImageThumbThread(arg: PThumbThrData): integer;
var
  cnt, idx: integer;
  FEntry: PFileResc;
  bmp: TBitmap;
begin

  EnterCriticalSection(arg^.Cs);
  try
    arg^.IsRun:= True;
  finally
    LeaveCriticalSection(arg^.Cs);
  end;
  idx:= arg^.FromIndex;
  cnt:= arg^.Count;
  FEntry:= arg^.FirstData;
  while (idx < cnt) and (not arg^.AbortExec) do
    begin
    if FEntry^.Kind = rkFile then
      begin
      bmp:= TBitmap.Create;
      try
        GenerateImageThumbnail(FEntry^.Data, bmp, 96, 96);
        EnterCriticalSection(arg^.Cs);
        try
          arg^.ImgLst.Add(bmp, nil);
        finally
          LeaveCriticalSection(arg^.Cs);
        end;
      finally
        bmp.Free;
      end;
    end
    else (* selain file *)
      begin
      bmp:= TBitmap.Create;
      try
        GenerateSystemIcon(4, bmp, 96, 96);
        EnterCriticalSection(arg^.Cs);
        try
          arg^.ImgLst.Add(bmp, nil);
        finally
          LeaveCriticalSection(arg^.Cs);
        end;
      finally
        bmp.Free;
      end;
    end;
    (* Lanjut ke item selanjutnya *)
    FEntry:= Pointer(Integer(FEntry)+SizeOf(TFileResc));
    Inc(idx);
  end;

  EnterCriticalSection(arg^.Cs);
  try
    arg^.IsRun:= False;
    arg^.Exited:= TRUE;
  finally
    LeaveCriticalSection(arg^.Cs);
  end;
  Result:= 0;

end;

procedure TfmResc.RefreshResource(Dir: string);
var
  zfra, maxt, dhea, risa: integer;
  ktmp: TItemRescKind;
  DirNl, FiNl: integer;
  UpName, DecName: string;
  SameDir, IsDir: boolean;
  fldcnt: integer;
  relbuf: TFileResc;
begin

  if (Dir <> '') and (Dir <> '/') then
    Dir:= UpperCase(Dir)
  else
    Dir:= 'IMAGES/';
  actUp.Enabled:= Dir <> 'IMAGES/';
  if Dir[Length(Dir)] <> '/' then
    Dir:= Dir + '/';

  (* Set direktori yang di indeks *)
  IndexDir:= LowerCase(Dir);
  DirNl:= Length(Dir);
  IndexCnt:= 0;
  IndexLst:= nil;
  maxt:= frmMain.RescFilePrc;
  (* Loop semua item tema yang didecompress *)
  for zfra:= 0 to maxt - 1 do
    begin
    UpName:= UpperCase(frmMain.RescFiles[zfra].Path);
    FiNl:= Length(UpName);
    if (FiNl > DirNl) and (Pos(Dir, UpName) = 1) then
      begin
      (* Potong prefix direktori sebelumnya *)
      DecName:= Copy(frmMain.RescFiles[zfra].Path, DirNl+1, FiNl-DirNl);
      ktmp:= rkFile;
      dhea:= 1;
      risa:= Length(DecName);
      IsDir:= FALSE;
      (* Buat ngecheck file ada di direktori anak2 *)
      repeat
        if DecName[dhea] = '/' then
          begin
          ktmp:= rkDir;
          DecName:= Copy(DecName, 1, dhea-1);
          IsDir:= TRUE;
        end;
        Inc(dhea);
      until (dhea >= risa) or IsDir;
      (* File di root direktori terindeks? Masukan! *)
      if ktmp = rkFile then
        begin
        SetLength(IndexLst, IndexCnt+1);
        with IndexLst[IndexCnt] do
          begin
          IndexLst[IndexCnt].Name:= frmMain.RescFiles[zfra].Name;
          IndexLst[IndexCnt].Path:= frmMain.RescFiles[zfra].Path;
          Data:= frmMain.RescFiles[zfra].Data;
          Kind:= rkFile;
        end;
        Inc(IndexCnt);
      end
      else
        (* Buat direktori anak2 *)
        begin
        SameDir:= FALSE;
        UpName:= UpperCase(DecName);
        dhea:= 0;
        risa:= IndexCnt;
        while (dhea < risa) and (not SameDir) do
          begin
          SameDir:= UpperCase(IndexLst[dhea].Path) = UpName;
          Inc(dhea);
        end;
        (* Direktori udah dimasukin belom? *)
        if not SameDir then
          begin
          SetLength(IndexLst, IndexCnt+1);
          with IndexLst[IndexCnt] do
            begin
            IndexLst[IndexCnt].Name:= DecName;
            IndexLst[IndexCnt].Path:= DecName;
            Kind:= rkDir;
            Data:= nil;
          end;
          Inc(IndexCnt);
        end;
      end;
    end;
  end;

  (* Sekarang, sort direktori ke list paling atas *)
  fldcnt:= 0;
  for zfra:= 0 to IndexCnt - 1 do
    begin
    if IndexLst[zfra].Kind = rkDir then
      begin
      relbuf:= IndexLst[zfra];
      for dhea:= zfra downto fldcnt+1 do
        IndexLst[zfra]:= IndexLst[zfra-1];
      IndexLst[fldcnt]:= relbuf;
      Inc(fldcnt);
    end;
  end;

  (* Mulai masukan semua item ke list *)
  lvResc.Items.Clear;
  RescLst.Clear;
  lvResc.Update;
  for zfra:= 0 to IndexCnt-1 do
    begin
    lvResc.Items.Add;
    lvResc.Items[zfra].Caption:= IndexLst[zfra].Name;
    lvResc.Items[zfra].ImageIndex:= zfra;
  end;
  lvResc.Update;

  (* Susun thumbnails di thread baru *)
  LastIdx:= -1;
  RebuildThumbnails;

end;

procedure TfmResc.AbortMakeThumbnails;
begin

  ThumbThrDt.AbortExec:= TRUE;
  tmrThDelay.Enabled:= True;
  //TerminateThread(ThreadHnd, 0);
  //while not ThumbThrDt.Exited do
  //  Application.ProcessMessages;

end;

procedure TfmResc.actExprExecute(Sender: TObject);
var
  fs: TFileStream;
begin

  sdlgImpr.FileName:= IndexLst[LastIdx].Name;
  if sdlgImpr.Execute then
    with IndexLst[LastIdx] do
      begin
      fs:= TFileStream.Create(sdlgImpr.FileName, fmCreate, fmShareDenyWrite);
      try
        fs.Position:= 0;
        Data.Position:= 0;
        fs.CopyFrom(Data, Data.Size)
      finally
        fs.Free;
      end;
    end;

end;

procedure TfmResc.actInfoExecute(Sender: TObject);
begin

  ShowResourceInfoDialog(frmMain.RescFiles[frmMain.SearchStreamIndex(IndexLst[LastIdx].Path)]);

end;

procedure TfmResc.actPrevExecute(Sender: TObject);
begin

  if LastIdx >= 0 then
    ShowImagePreview(frmMain.SearchStreamIndex(IndexLst[LastIdx].Path));

end;

procedure TfmResc.actRefsExecute(Sender: TObject);
begin

  RefreshResource();

end;

procedure TfmResc.actReplExecute(Sender: TObject);
var
  idx: Integer;
  //fs: TFileStream;
  dl: TdlgOpenPict;
begin

  idx:= lvResc.ItemIndex;
  dl:= TdlgOpenPict.Create(Self);
  try
    //dl.dlOpen.InitialDir:= ExtractFilePath(ParamStr(0));
    if dl.ShowModal = mrOk then
      begin
      ImportPicture(IndexLst[idx].Data, dl.dlOpen.FileName);
      frmMain.SetChanged();
      RebuildThumbnails;
    end;
  finally
    dl.Free;
  end;

  {if UpperCase(ExtractFileExt(IndexLst[idx].Name)) = '.PNG' then
    begin
    if odlgReplPic.Execute then
      begin
      ImportPicture(IndexLst[idx].Data, odlgReplPic.FileName);
      frmMain.SetChanged();
      RebuildThumbnails;
    end;
  end
  else
  if odlgRepl.Execute then
    with IndexLst[idx].Data do
      begin
      Position:= 0;
      fs:= TFileStream.Create(odlgRepl.FileName, fmOpenRead, fmShareDenyWrite);
      try
        fs.Position:= 0;
        CopyFrom(fs, fs.Size);
      finally
        fs.Free;
      end;
      frmMain.SetChanged();
      RebuildThumbnails;
    end;}

end;

procedure TfmResc.actUpExecute(Sender: TObject);
begin

  ParentDir;

end;

procedure TfmResc.cbxRbgnChange(Sender: TObject);
begin

  pbxRprv.Invalidate;

end;

procedure TfmResc.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  AbortMakeThumbnails;

end;

procedure TfmResc.FormCreate(Sender: TObject);
var
  zfra: integer;
  tlbg: TBitmap;
begin

  InitializeCriticalSection(MainCs);
  lvResc.DoubleBuffered:= TRUE;
  pnlImg.DoubleBuffered:= TRUE;
  LastIdx:= -1;
  ViewPic:= TPngImage.Create;
  cbxRbgn.ItemIndex:= 0;

  imgRtlb.Clear;
  for zfra:= 0 to RescTlbGlyphCount - 1 do
    AddPngGlyph(imgRtlb, Format('RTLB_%.2d', [zfra]));

  tlbg:= MakeToolbarBackground(dckRsc.ClientHeight);
  try
    dckRsc.Background.Assign(tlbg);
  finally
    tlbg.Free;
  end;

  with ThumbThrDt do
    begin
    AbortExec:= FALSE;
    IsRun:= False;
    Exited:= FALSE;
  end;

end;

procedure TfmResc.FormDestroy(Sender: TObject);
begin

  lvResc.Items.Clear;
  RescLst.Clear;
  IndexLst:= nil;
  IndexCnt:= 0;
  DeleteCriticalSection(MainCs);
  ViewPic.Free;

end;

procedure TfmResc.lvRescDblClick(Sender: TObject);
begin

  if IndexLst[LastIdx].Kind = rkFile then
    actPrev.Execute
  else
    ProcessItem(lvResc.ItemIndex);

end;

procedure TfmResc.lvRescKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
    ProcessItem(lvResc.ItemIndex);

end;

procedure TfmResc.lvRescSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  idx: integer;
  IsFile: Boolean;
begin

  idx:= lvResc.ItemIndex;
  LastIdx:= idx;
  if idx > -1 then
    begin
    if IndexLst[idx].Kind = rkFile then
      begin
      lvResc.PopupMenu:= pmFile;
      if ExtractFileExt(UpperCase(Item.Caption)) = '.PNG' then
        begin
        IndexLst[idx].Data.Position:= 0;
        ViewPic.LoadFromStream(IndexLst[idx].Data);
        lblRdm.Caption:= Format('Dimension: %dx%d px', [ViewPic.Width, ViewPic.Height]);
        if not lblRdm.Visible then
          lblRdm.Show;
      end
      else
        lblRdm.Hide;
      lblRnm.Caption:= Item.Caption;
      lblRsz.Caption:= Format('Size: %.2f Kb', [IndexLst[idx].Data.Size / 1024]);
    end
    else
      lvResc.PopupMenu:= pmDir;
    pbxRprv.Invalidate;
  end;

  IsFile:= IndexLst[idx].Kind = rkFile;
  (* Picture viewer *)
  cbxRbgn.Visible:= IsFile;
  pnlImg.Visible:= IsFile;
  lblRnm.Visible:= IsFile;
  lblRsz.Visible:= IsFile;
  lblRdm.Visible:= IsFile;
  (* Toolbar items *)
  actRepl.Enabled:= IsFile;
  actExpr.Enabled:= IsFile;
  actPrev.Enabled:= IsFile;
  actInfo.Enabled:= IsFile;

end;

procedure TfmResc.MakeThumbnails;
var
  TrId: Cardinal;
  fidx: integer;
begin

  if (not ThumbThrDt.Exited) and (ThumbThrDt.IsRun) then
    begin
    DelayedThumbnailGen:= TRUE;
    AbortMakeThumbnails;
    Exit;
  end;

  fidx:= RescLst.Count;
  with ThumbThrDt do
    begin
    AbortExec:= FALSE;
    Exited:= FALSE;
    FromIndex:= fidx;
    FirstData:= @IndexLst[fidx];
    Count:= IndexCnt;
    Cs:= MainCs;
    ImgLst:= RescLst;
  end;
  ThreadHnd:= BeginThread(nil, 0, @ImageThumbThread, @Self.ThumbThrDt, 0, TrId);
  lvResc.ItemIndex:= LastIdx;
  lvResc.SetFocus;

end;

procedure TfmResc.ParentDir;
var
  lp, from: integer;
  par: string;
begin

  from:= Length(IndexDir);
  if IndexDir[from] = '/' then
    Dec(from);
  for lp:= from downto 1 do
    if IndexDir[lp] = '/' then
      begin
      par:= Copy(IndexDir, 1, lp);
      RefreshResource(par);
      Break;
    end;

end;

procedure TfmResc.pbRescPanPaint(Sender: TObject);
begin

  with pbRescPan do
    DrawGradient(clWindow, clBtnFace, Canvas, ClientRect, FALSE);

end;

procedure TfmResc.pbxRprvDblClick(Sender: TObject);
begin

  if actPrev.Enabled then
    actPrev.Execute;

end;

procedure TfmResc.pbxRprvPaint(Sender: TObject);
var
  PrvRect: TRect;
begin

  with pbxRprv.Canvas do
    begin

    Brush.Style:= bsSolid;
    Pen.Style:= psClear;

    case cbxRbgn.ItemIndex of

      (* White *)
      1: begin
           Brush.Color:= clWhite;
           FillRect(pbxRprv.ClientRect);
         end;

      (* Black *)
      2: begin
           Brush.Color:= clBlack;
           FillRect(pbxRprv.ClientRect);
         end;

      (* Silver *)
      3: begin
           Brush.Color:= clSilver;
           FillRect(pbxRprv.ClientRect);
         end;

      (* Gray *)
      4: begin
           Brush.Color:= clGray;
           FillRect(pbxRprv.ClientRect);
         end;

    else

      TransparentBase(pbxRprv.Canvas, pbxRprv.ClientRect);

    end;

    PrvRect.Right:= ViewPic.Width;
    PrvRect.Bottom:= ViewPic.Height;
    if (PrvRect.Right <= pbxRprv.ClientWidth) and (PrvRect.Bottom <= pbxRprv.ClientHeight) then
      Draw((pbxRprv.ClientWidth - PrvRect.Right) div 2,
           (pbxRprv.ClientHeight - PrvRect.Bottom) div 2,
           ViewPic)
    else
      begin
      PrvRect:= AspectRatio(PrvRect.Right, PrvRect.Bottom, pbxRprv.ClientWidth, pbxRprv.ClientHeight);
      //StretchDraw(PrvRect, ViewPic);
      Lock;
      try
        DrawAntiAliased(ViewPic, pbxRprv.Canvas, PrvRect);
      finally
        Unlock;
      end;
    end;

  end;

end;

procedure TfmResc.pnlDataResize(Sender: TObject);
begin

  lvResc.Arrange(arAlignLeft);

end;

procedure TfmResc.ProcessItem(Index: integer);
begin

  if Index > -1 then
    begin
    case IndexLst[Index].Kind of
      rkDir: RefreshResource(IndexDir + IndexLst[Index].Name);
    end;
  end;

end;

procedure TfmResc.RebuildThumbnails;
begin

  RescLst.Clear;
  DelayedThumbnailGen:= False;
  MakeThumbnails;

end;

procedure TfmResc.RefreshResource;
begin

  RefreshResource(IndexDir);

end;

procedure TfmResc.tmrThDelayTimer(Sender: TObject);
begin

  if ThumbThrDt.Exited then
    begin
    tmrThDelay.Enabled:= False;
    if DelayedThumbnailGen then
      MakeThumbnails;
    DelayedThumbnailGen:= False;
  end;

end;

end.
