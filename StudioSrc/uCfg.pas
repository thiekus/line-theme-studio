unit uCfg;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015 - 2016                                  *)
(*                                                                            *)
(* Section Desc: Application config module                                    *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, IniFiles, LtsType;

type
  TfrmCfg = class(TForm)
    GroupBox1: TGroupBox;
    trCmpr: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Bevel1: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cbxUpdt: TCheckBox;
    ListBox1: TListBox;
    btnEditApp: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    cbxWelc: TCheckBox;
    cbxAppSkin: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnEditAppClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCfg: TfrmCfg;

implementation

uses uEditApp;

{$R *.dfm}

const
  cfg = 'Config';
  ped = 'PictureEditor';

procedure TfrmCfg.btnOkClick(Sender: TObject);
var
  ini: TIniFile;
begin

  ini:= TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    ini.WriteInteger(cfg, 'CompressionLevel', trCmpr.Position);
    ini.WriteBool(cfg, 'CheckUpdate', cbxUpdt.Checked);
    ini.WriteBool(cfg, 'ShowWelcome', cbxWelc.Checked);
    ini.WriteBool(cfg, 'AppSkin', cbxAppSkin.Checked);
  finally
    ini.Free;
  end;

end;

procedure TfrmCfg.btnEditAppClick(Sender: TObject);
begin

  frmEditApp.ShowModal;

end;

procedure TfrmCfg.FormShow(Sender: TObject);
var
  ini: TIniFile;
begin

  ini:= TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    trCmpr.Position:= ini.ReadInteger(cfg, 'CompressionLevel', 3);
    cbxUpdt.Checked:= ini.ReadBool(cfg, 'CheckUpdate', TRUE);
    cbxWelc.Checked:= ini.ReadBool(cfg, 'ShowWelcome', TRUE);
    cbxAppSkin.Checked:= ini.ReadBool(cfg, 'AppSkin', TRUE);
  finally
    ini.Free;
  end;

end;

end.
