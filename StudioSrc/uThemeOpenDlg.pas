unit uThemeOpenDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SsShlDlg, ComCtrls, IniFiles, CustomUtils;

type
  TdlgOpenTheme = class(TForm)
    dlOpen: TStDialogPanel;
    pnlSide: TPanel;
    Label1: TLabel;
    edtTmName: TEdit;
    Label2: TLabel;
    edtTmAuth: TEdit;
    Label3: TLabel;
    edtTmVer: TEdit;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    pnlPrev: TPanel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    FixedDir: Boolean;

  end;

var
  dlgOpenTheme: TdlgOpenTheme;

implementation

{$R *.dfm}

procedure TdlgOpenTheme.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if (not FixedDir) and (Self.ModalResult = mrOk) then
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
      try
        WriteString('LastPath', 'ThemeOpenDialog', ExtractFilePath(dlOpen.FileName));
      finally
        Free;
      end;

end;

procedure TdlgOpenTheme.FormCreate(Sender: TObject);
var
  LastPath: string;
begin

  dlOpen.DoubleBuffered:= True;
  dlOpen.ListView.ViewStyle:= vsReport;

  if not FixedDir then
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    try
      LastPath:= ReadString('LastPath', 'ThemeOpenDialog', '');
      if LastPath <> '' then
        dlOpen.InitialDir:= LastPath
      else
        dlOpen.InitialDir:= GetDocumentDir;
    finally
      Free;
    end;

  // not implemented yet
  pnlSide.Hide;

end;

end.
