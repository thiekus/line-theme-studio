unit uWelcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CustomUtils, RichEditURL,
  ShellAPI;

type
  TfrmWelcome = class(TForm)
    pnlWell: TPanel;
    pnlBwah: TPanel;
    rcWelcome: TRichEditURL;
    lblCount: TLabel;
    BitBtn1: TBitBtn;
    pbBwah: TPaintBox;
    procedure pbBwahPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rcWelcomeURLClick(Sender: TObject; const URL: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcome: TfrmWelcome;

implementation

{$R *.dfm}
{$R ../icons/Intro.RES}

procedure TfrmWelcome.FormShow(Sender: TObject);
var
  Rs: TResourceStream;
begin

  Rs:= TResourceStream.Create(HInstance, 'INTRO_TEXT', RT_RCDATA);
  try
    rcWelcome.Lines.LoadFromStream(Rs);
  finally
    Rs.Free;
  end;

end;

procedure TfrmWelcome.pbBwahPaint(Sender: TObject);
begin

  with pbBwah do
    DrawGradient(clWindow, clBtnFace, Canvas, ClientRect, TRUE);

end;

procedure TfrmWelcome.rcWelcomeURLClick(Sender: TObject; const URL: string);
begin

  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);

end;

end.
