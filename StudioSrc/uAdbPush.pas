unit uAdbPush;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Adb Push progress dialog                                     *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdbExec;

type
  TfrmAdbp = class(TForm)
    lblNote: TLabel;
    lblSrc: TLabel;
    lblDest: TLabel;
    Bevel1: TBevel;
    tmrWait: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tmrWaitTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    PushIt, InPush: boolean;
    DeviceSerial, Source, Destination: string;
    SendExec: TAdxExecInfo;

    procedure ExecuteAdb;

  public
    { Public declarations }

    function PushFromAdb(const DevSerial, Src, Dest: string): boolean;

  end;

var
  frmAdbp: TfrmAdbp;

implementation

{$R *.dfm}

procedure TfrmAdbp.ExecuteAdb;
begin

  if Adx_Execute(DeviceSerial, Format('push "%s" %s"', [Source, Destination]), FALSE, SendExec) then
    InPush:= TRUE;

end;

procedure TfrmAdbp.FormActivate(Sender: TObject);
begin

  if PushIt then
    begin
    PushIt:= FALSE;
    ExecuteAdb;
    tmrWait.Enabled:= TRUE;
  end;

end;

procedure TfrmAdbp.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  tmrWait.Enabled:= FALSE;

end;

procedure TfrmAdbp.FormShow(Sender: TObject);
begin

  PushIt:= TRUE;
  InPush:= FALSE;

end;

function TfrmAdbp.PushFromAdb(const DevSerial, Src, Dest: string): boolean;
begin

  DeviceSerial:= DevSerial;
  Source:= Src;
  Destination:= Dest;
  lblSrc.Caption:= Format('Source File: %s', [Src]);
  lblDest.Caption:= Format('Destination: %s', [Dest]);
  Result:= Self.ShowModal = mrOk;
  
end;

procedure TfrmAdbp.tmrWaitTimer(Sender: TObject);
begin

  if InPush then
    begin
    if not Adx_StillActive(SendExec) then
      begin
      Adx_Close(SendExec);
      if Adx_GetLastExitCode = 0 then
        ModalResult:= mrOk
      else
        ModalResult:= mrCancel;
      CloseModal;
    end
  end
  else
    begin
    ModalResult:= mrCancel;
    CloseModal;
  end;

end;

end.
