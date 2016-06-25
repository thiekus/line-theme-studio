unit uManedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmManed = class(TForm)
    lblMainfo: TLabel;
    lbl1: TLabel;
    edt1: TEdit;
    lbl2: TLabel;
    edt2: TEdit;
    lbl3: TLabel;
    edt3: TEdit;
    lbl4: TLabel;
    edt4: TEdit;
    lbl5: TLabel;
    edt5: TEdit;
    lbl6: TLabel;
    edt6: TEdit;
    lbl7: TLabel;
    edt7: TEdit;
    edt8: TEdit;
    lbl8: TLabel;
    btn1: TBitBtn;
    lbl9: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmManed: TfmManed;

implementation

{$R *.dfm}

procedure TfmManed.FormShow(Sender: TObject);
begin

  //

end;

end.
