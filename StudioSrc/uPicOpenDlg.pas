unit uPicOpenDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SsShlDlg, Imaging, ImagingTypes, ImagingComponents,
  CustomUtils, IniFiles, ComCtrls;

type
  TdlgOpenPict = class(TForm)
    pnlSide: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblStat: TLabel;
    edtPicFmt: TEdit;
    edtPicSize: TEdit;
    edtPicDim: TEdit;
    cbxDesc: TCheckBox;
    pnlPrev: TPanel;
    dlOpen: TStDialogPanel;
    pbPrev: TPaintBox;
    procedure pbPrevPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dlOpenItemClick(Sender: TObject; var DefaultAction: Boolean);
    procedure cbxDescClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    PreImg: TImagingGraphic;

    procedure BlankDesc;
    procedure GetDesc;

  public
    { Public declarations }
  end;

var
  dlgOpenPict: TdlgOpenPict;

implementation

{$R *.dfm}

procedure TdlgOpenPict.BlankDesc;
begin

  edtPicFmt.Text:= '';
  edtPicSize.Text:= '';
  edtPicDim.Text:= '';
  PreImg.Width:= 0;
  PreImg.Height:= 0;
  pbPrev.Invalidate;

end;

procedure TdlgOpenPict.cbxDescClick(Sender: TObject);
begin

  if cbxDesc.Checked then
    GetDesc
  else
    begin
    BlankDesc;
    lblStat.Caption:= 'Deskripsi dimatikan!';
  end;

end;

procedure TdlgOpenPict.dlOpenItemClick(Sender: TObject;
  var DefaultAction: Boolean);
begin

  if cbxDesc.Checked then
    GetDesc;
  DefaultAction:= True;

end;

procedure TdlgOpenPict.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if Self.ModalResult = mrOk then
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
      try
        WriteString('LastPath', 'PictureOpenDialog', ExtractFilePath(dlOpen.FileName));
      finally
        Free;
      end;

end;

procedure TdlgOpenPict.FormCreate(Sender: TObject);
var
  LastPath: string;
begin

  dlOpen.DoubleBuffered:= True;
  dlOpen.ListView.ViewStyle:= vsReport;
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  try
    LastPath:= ReadString('LastPath', 'PictureOpenDialog', '');
    if LastPath <> '' then
      dlOpen.InitialDir:= LastPath
    else
      dlOpen.InitialDir:= GetDocumentDir;
  finally
    Free;
  end;

  PreImg:= TImagingGraphic.Create;
  cbxDesc.Checked:= True;
  BlankDesc;
  lblStat.Caption:= 'Silahkan pilih file...';

end;

procedure TdlgOpenPict.FormDestroy(Sender: TObject);
begin

  PreImg.Free;

end;

procedure TdlgOpenPict.GetDesc;
var
  fPath: string;
  picFmt: string;
  fd: File;
  fs: LongWord;
begin

  try

    if not Assigned(dlOpen.ListView) then
      Exit;

    fPath:= dlOpen.ListView.SelectedItem.Path;
    picFmt:= DetermineFileFormat(fPath);
    if picFmt <> '' then
      begin

      AssignFile(fd, fPath);
      try
        Reset(fd);
        fs:= FileSize(fd);
      finally
        CloseFile(fd);
      end;
      PreImg.PixelFormat:= pf32bit;
      PreImg.LoadFromFile(fPath);

      edtPicFmt.Text:= UpperCase(picFmt);
      edtPicSize.Text:= Format('%.2f kb', [fs / 1024]);
      edtPicDim.Text:= Format('%dx%d px', [PreImg.Width, PreImg.Height]);
      pbPrev.Invalidate;
      lblStat.Caption:= 'Gambar ini valid!';

    end
    else
      begin
      BlankDesc;
      lblStat.Caption:= 'Bukan file gambar!';
    end;

  except

    BlankDesc;
    lblStat.Caption:= 'Gagal mengambil deskripsi!';

  end;

end;

procedure TdlgOpenPict.pbPrevPaint(Sender: TObject);
var
  iRect: TRect;
begin

  if PreImg.Empty then
    begin
    pbPrev.Canvas.Brush.Color:= clBlack;
    pbPrev.Canvas.Brush.Style:= bsSolid;
    pbPrev.Canvas.FillRect(pbPrev.ClientRect);
  end
  else
    begin
    pbPrev.Canvas.Pen.Style:= psClear;
    TransparentBase(pbPrev.Canvas, pbPrev.ClientRect);
    iRect:= AspectRatio(PreImg.Width, PreImg.Height, pbPrev.Width, pbPrev.Height);
    pbPrev.Canvas.StretchDraw(iRect, PreImg);
  end;

end;

end.
