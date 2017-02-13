unit uPicView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, TB97Ctls, TB97, TB97Tlbr, PngImage, CustomUtils,
  StdCtrls, ActnList, ImgList, LtsType, ExtDlgs, ResGraphic;

type
  TfrmPrev = class(TForm)
    dckPrv: TDock97;
    tlbPrv: TToolbar97;
    btnZo: TToolbarButton97;
    sbar: TStatusBar;
    pnlCnt: TPanel;
    scbPrev: TScrollBox;
    pbPrev: TPaintBox;
    ToolbarSep971: TToolbarSep97;
    btnZi: TToolbarButton97;
    ToolbarButton973: TToolbarButton97;
    ToolbarButton974: TToolbarButton97;
    ToolbarSep972: TToolbarSep97;
    ToolbarButton975: TToolbarButton97;
    cbxBgnd: TComboBox;
    ToolbarButton976: TToolbarButton97;
    actPrv: TActionList;
    zmIn: TAction;
    zmOut: TAction;
    imgPrv: TImageList;
    tmrSo: TTimer;
    tmrSi: TTimer;
    imgEdit: TAction;
    imgImp: TAction;
    imgExp: TAction;
    imgInfo: TAction;
    odlgImpr: TOpenPictureDialog;
    sdlgExpr: TSavePictureDialog;
    procedure pbPrevPaint(Sender: TObject);
    procedure pnlCntResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxBgndSelect(Sender: TObject);
    procedure zmInExecute(Sender: TObject);
    procedure zmOutExecute(Sender: TObject);
    procedure btnZoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnZiMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrSoTimer(Sender: TObject);
    procedure btnZoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnZiMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrSiTimer(Sender: TObject);
    procedure imgEditExecute(Sender: TObject);
    procedure imgImpExecute(Sender: TObject);
    procedure imgExpExecute(Sender: TObject);
    procedure imgInfoExecute(Sender: TObject);
  private
    { Private declarations }

    PreviewPng: TPngImage;
    ZoomRatio: Real;
    RefFileIndex: Integer;

    procedure LocatePreview;

  public
    { Public declarations }

    PictureChanged: Boolean;

    procedure LoadPreview(const FileIndex: integer);

  end;

  function ShowImagePreview(const FileIndex: integer): Boolean;

var
  frmPrev: TfrmPrev;

implementation

uses uFinfo, uMain, uPicOpenDlg;

const PrevTlbGlyphCount = 6;

{$R *.dfm}
{$R '../icons/PrevGlyph.RES'}

function ShowImagePreview(const FileIndex: integer): Boolean;
var
  frm: TfrmPrev;
begin

  frm:= TfrmPrev.Create(Application);
  try
    frm.LoadPreview(FileIndex);
    frm.ShowModal;
    Result:= frm.PictureChanged;
  finally
    frm.Free;
  end;

end;

procedure TfrmPrev.cbxBgndSelect(Sender: TObject);
begin

  pbPrev.Invalidate;

end;

procedure TfrmPrev.FormCreate(Sender: TObject);
var
  zfra: integer;
  tlbg: TBitmap;
begin

  PictureChanged:= False;
  imgPrv.Clear;
  for zfra:= 0 to PrevTlbGlyphCount - 1 do
    AddPngGlyph(imgPrv, Format('ITLB_%.2d', [zfra]));

  tlbg:= MakeToolbarBackground(dckPrv.ClientHeight);
  try
    dckPrv.Background.Assign(tlbg);
  finally
    tlbg.Free;
  end;

end;

procedure TfrmPrev.FormDestroy(Sender: TObject);
begin

  if Assigned(PreviewPng) then
    PreviewPng.Free;

end;

procedure TfrmPrev.imgEditExecute(Sender: TObject);
var
  StInfo: StartupInfo;
  PrInfo: Process_Information;
  AppPath: string;
  AppCmd: string;
  TempFile: string;
  Tf: TThemeFile;
  Fs: TFileStream;
begin

  Tf:= frmMain.RescFiles[RefFileIndex];
  TempFile:= frmMain.AppTemporaryDir + ExtractFileName(Tf.Name);
  // ToDo: make diffrent editor here
  AppPath:= ExtractFilePath(ParamStr(0)) + 'fotografix\Fotografix.exe';
  AppCmd:= '"' + TempFile + '"';

  try

    Fs:= TFileStream.Create(TempFile, fmCreate, fmShareExclusive);
    try
      Fs.Position:= 0;
      Tf.Data.Position:= 0;
      Fs.CopyFrom(Tf.Data, Tf.Data.Size);
    finally
      Fs.Free;
    end;

    ZeroMemory(@StInfo, SizeOf(StInfo));
    ZeroMemory(@PrInfo, SizeOf(PrInfo));
    FillChar(StInfo, SizeOf(StInfo),0);
    StInfo.cb:= SizeOf(StInfo);

    if CreateProcess(nil, PChar('"' + AppPath + '" ' + AppCmd), nil, nil, TRUE,
                     0, nil, PChar(ExtractFilePath(ParamStr(0))), StInfo, PrInfo) then
      begin
      WaitForSingleObject(PrInfo.hProcess, INFINITE);
      Fs:= TFileStream.Create(TempFile, fmOpenRead, fmShareExclusive);
      try
        Tf.Data.Size:= 0;
        Tf.Data.Position:= 0;
        Fs.Position:= 0;
        Tf.Data.CopyFrom(Fs, Fs.Size);
      finally
        Fs.Free;
      end;
      PictureChanged:= True;
      LoadPreview(RefFileIndex);
    end;

  finally
    DeleteFile(TempFile);
  end;

end;

procedure TfrmPrev.imgExpExecute(Sender: TObject);
var
  fs: TFileStream;
begin

  sdlgExpr.FileName:= frmMain.RescFiles[RefFileIndex].Name;
  if sdlgExpr.Execute then
    with frmMain.RescFiles[RefFileIndex] do
      begin
      fs:= TFileStream.Create(sdlgExpr.FileName, fmCreate, fmShareDenyWrite);
      try
        fs.Position:= 0;
        Data.Position:= 0;
        fs.CopyFrom(Data, Data.Size)
      finally
        fs.Free;
      end;
    end;

end;

procedure TfrmPrev.imgImpExecute(Sender: TObject);
var
  dl: TdlgOpenPict;
begin

  dl:= TdlgOpenPict.Create(Self);
  try
    if dl.ShowModal = mrOk then
      with frmMain.RescFiles[RefFileIndex] do
        if ImportPicture(TStream(Data), dl.dlOpen.FileName) then
          begin
          PictureChanged:= True;
          LoadPreview(RefFileIndex);
        end;
  finally
    dl.Free;
  end;

  {if odlgImpr.Execute then
    with frmMain.RescFiles[RefFileIndex] do
     begin
     if ImportPicture(TStream(Data), odlgImpr.FileName) then
       LoadPreview(RefFileIndex);
    end;}

end;

procedure TfrmPrev.imgInfoExecute(Sender: TObject);
begin

  ShowResourceInfoDialog(frmMain.RescFiles[RefFileIndex]);

end;

procedure TfrmPrev.LoadPreview(const FileIndex: integer);
var
  Tf: TThemeFile;
begin

  if Assigned(PreviewPng) then
    PreviewPng.Free;
  (**)
  PreviewPng:= TPngImage.Create;
  (**)
  RefFileIndex:= FileIndex;
  Tf:= frmMain.RescFiles[FileIndex];
  Tf.Data.Position:= 0;
  PreviewPng.LoadFromStream(Tf.Data);
  pbPrev.Width:= PreviewPng.Width;
  pbPrev.Height:= PreviewPng.Height;
  Caption:= Format('Image Preview - %s', [Tf.Name]);
  sbar.Panels[1].Text:= Format('Original dimension: %dx%d', [PreviewPng.Width, PreviewPng.Height]);
  sbar.Panels[2].Text:= Tf.Name;
  ZoomRatio:= 1.0;
  LocatePreview;

end;

procedure TfrmPrev.LocatePreview;
begin

  sbar.Panels[0].Text:= Format('Zoom Ratio: %.0f%%', [ZoomRatio * 100]);
  pbPrev.Width:= Round(PreviewPng.Width * ZoomRatio);
  pbPrev.Height:= Round(PreviewPng.Height * ZoomRatio);
  pbPrev.Left:= (scbPrev.ClientWidth - pbPrev.Width) div 2;
  pbPrev.Top:= (scbPrev.ClientHeight - pbPrev.Height) div 2;
  pbPrev.Invalidate;

end;

procedure TfrmPrev.pbPrevPaint(Sender: TObject);
begin

  with pbPrev.Canvas do
    begin
    Lock;
    try
      Brush.Style:= bsSolid;
      Pen.Style:= psClear;
      case cbxBgnd.ItemIndex of

        1: begin
             Brush.Color:= clWhite;
             FillRect(pbPrev.ClientRect);
           end;

        2: begin
             Brush.Color:= clBlack;
             FillRect(pbPrev.ClientRect);
           end;

        3: begin
             Brush.Color:= clSilver;
             FillRect(pbPrev.ClientRect);
           end;

        4: begin
             Brush.Color:= clGray;
             FillRect(pbPrev.ClientRect);
           end;

      else
        TransparentBase(pbPrev.Canvas, pbPrev.ClientRect);
      end;
      if ZoomRatio = 1.0 then
        Draw(0, 0, PreviewPng)
      else
        DrawAntiAliased(PreviewPng, pbPrev.Canvas, pbPrev.ClientRect);
    finally
      Unlock;
    end;
  end;

end;

procedure TfrmPrev.pnlCntResize(Sender: TObject);
begin

  LocatePreview;

end;

procedure TfrmPrev.tmrSiTimer(Sender: TObject);
begin
  zmIn.Execute;
end;

procedure TfrmPrev.tmrSoTimer(Sender: TObject);
begin
  zmOut.Execute;
end;

procedure TfrmPrev.btnZiMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tmrSi.Enabled:= True;
end;

procedure TfrmPrev.btnZiMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tmrSi.Enabled:= False;
end;

procedure TfrmPrev.btnZoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  tmrSo.Enabled:= True;
end;

procedure TfrmPrev.btnZoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tmrSo.Enabled:= False;
end;

procedure TfrmPrev.zmInExecute(Sender: TObject);
begin

  ZoomRatio:= ZoomRatio + 0.1;
  LocatePreview;
  pbPrev.Invalidate;

end;

procedure TfrmPrev.zmOutExecute(Sender: TObject);
begin

  ZoomRatio:= ZoomRatio - 0.1;
  if ZoomRatio <= 0 then
    ZoomRatio:= 0.1; //maximum
  LocatePreview;
  pbPrev.Invalidate;

end;

end.
