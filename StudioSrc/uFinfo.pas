unit uFinfo;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015 - 2016                                  *)
(*                                                                            *)
(* Section Desc: File information module                                      *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, pngimage, LtsType;

type
  TfrmFinfo = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    Image1: TImage;
    lblFnme: TLabel;
    lblFmt: TLabel;
    lblSize: TLabel;
    grpInfo: TGroupBox;
    mmInfo: TMemo;
  private
    { Private declarations }

    procedure InfoType_Unknown(const FileInfo: TThemeFile);
    procedure InfoType_PNG(const FileInfo: TThemeFile);
    procedure SetTypeDesc(const TypeStr: string);

  public
    { Public declarations }

    procedure ShowFileInfo(const FileInfo: TThemeFile);

  end;

  procedure ShowResourceInfoDialog(const FileInfo: TThemeFile);

var
  frmFinfo: TfrmFinfo;

implementation

{$R *.dfm}

{ TfrmFinfo }

procedure ShowResourceInfoDialog(const FileInfo: TThemeFile);
var
  frm: TfrmFinfo;
begin
  frm:= TfrmFinfo.Create(Application);
  try
    frm.ShowFileInfo(FileInfo);
  finally
    frm.Free;
  end;
end;

procedure TfrmFinfo.InfoType_PNG(const FileInfo: TThemeFile);
var
  pngd: TPngImage;
begin

  SetTypeDesc('PNG Image');
  mmInfo.Clear;

  pngd:= TPngImage.Create;
  try
    FileInfo.Data.Position:= 0;
    pngd.LoadFromStream(FileInfo.Data);
    (* Buat keterangan informasi file png *)
    mmInfo.Lines.Add(Format('Dimension: %dx%d', [pngd.Width, pngd.Height]));
  finally
    pngd.Free;
  end;

end;

procedure TfrmFinfo.InfoType_Unknown(const FileInfo: TThemeFile);
begin

  SetTypeDesc(Format('%s file', [UpperCase(ExtractFileExt(FileInfo.Name))]));
  mmInfo.Clear;

end;

procedure TfrmFinfo.SetTypeDesc(const TypeStr: string);
begin

  lblFmt.Caption:= Format('Format: %s', [TypeStr]);

end;

procedure TfrmFinfo.ShowFileInfo(const FileInfo: TThemeFile);
var
  ext: string;
begin

  lblFnme.Caption:= Format('Filename: %s', [FileInfo.Name]);

  (* Beri informasi spesifik pada file tertentu *)
  ext:= UpperCase(ExtractFileExt(FileInfo.Name));
  if ext = '.PNG' then
    InfoType_PNG(FileInfo)
  else
    InfoType_Unknown(FileInfo);

  lblSize.Caption:= Format('Size: %.2fKB', [FileInfo.Data.Size / 1024]);
  Self.ShowModal;

end;

end.
