unit uConn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, AdbExec;

type
  TfrmConn = class(TForm)
    Label1: TLabel;
    edtHost: TEdit;
    Label2: TLabel;
    spPort: TSpinEdit;
    Label3: TLabel;
    Bevel1: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConn: TfrmConn;

implementation

{$R *.dfm}

procedure TfrmConn.btnOkClick(Sender: TObject);
begin

  Adx_ExecuteAndWait('', Format('connect %s:%d', [edtHost.Text, spPort.Value]));

end;

procedure TfrmConn.FormCreate(Sender: TObject);
begin

  spPort.Button.Hide;

end;

end.
