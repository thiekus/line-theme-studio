unit uFindProp;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Find Property dialog                                         *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmFindProp = class(TForm)
    Label1: TLabel;
    edtPropFnd: TEdit;
    cbxPrpNm: TCheckBox;
    cbxPrpVal: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    cbxMatch: TCheckBox;
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFindProp: TfrmFindProp;

implementation

uses uProp;

{$R *.dfm}

procedure TfrmFindProp.BitBtn1Click(Sender: TObject);
var
  opts: Cardinal;
begin

  opts:= 0;
  if cbxPrpNm.Checked then
    opts:= opts or srcKey;
  if cbxPrpVal.Checked then
    opts:= opts or srcValue;
  if cbxMatch.Checked then
    opts:= opts or srcMatch;
  fmProp.FindProperty(edtPropFnd.Text, foPrev, opts);

end;

procedure TfrmFindProp.BitBtn2Click(Sender: TObject);
var
  opts: Cardinal;
begin

  opts:= 0;
  if cbxPrpNm.Checked then
    opts:= opts or srcKey;
  if cbxPrpVal.Checked then
    opts:= opts or srcValue;
  if cbxMatch.Checked then
    opts:= opts or srcMatch;
  fmProp.FindProperty(edtPropFnd.Text, foNext, opts);

end;

procedure TfrmFindProp.BitBtn3Click(Sender: TObject);
begin

  Close;

end;

end.
