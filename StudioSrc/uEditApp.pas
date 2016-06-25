unit uEditApp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TfrmEditApp = class(TForm)
    Label1: TLabel;
    edtPath: TEdit;
    Button1: TButton;
    Label2: TLabel;
    edtCmd: TEdit;
    mmHelp: TMemo;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditApp: TfrmEditApp;

implementation

{$R *.dfm}

end.
