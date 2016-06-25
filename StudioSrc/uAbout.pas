unit uAbout;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: About Dialog                                                 *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, PngImage, CustomUtils,
  RichEdit, RichEditURL, ShellAPI;

type
  TfrmAbout = class(TForm)
    pAbt: TPanel;
    pBtm: TPanel;
    BitBtn1: TBitBtn;
    pbxAbt: TPaintBox;
    rcAbout: TRichEditURL;
    btnTst: TButton;
    pbBwah: TPaintBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbxAbtPaint(Sender: TObject);
    procedure btnTstClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbBwahPaint(Sender: TObject);
    procedure rcAboutURLClick(Sender: TObject; const URL: string);
  private
    { Private declarations }

    AboutLogo: TPngImage;

    procedure ThisBrokenHeartTest(Pass: Integer);

  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

const
  LogoX = 8;         LogoY = 8;
  VersX = 242+LogoX; VersY = 60+LogoY;

procedure TfrmAbout.btnTstClick(Sender: TObject);
begin

  ThisBrokenHeartTest(0);

end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  AboutLogo.Free;

end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin

  {$IFDEF DEBUG}
  //btnTst.Show;
  {$ENDIF}

end;

procedure TfrmAbout.FormShow(Sender: TObject);
var
  Rs: TResourceStream;
begin

  AboutLogo:= TPngImage.Create;
  AboutLogo.LoadFromResourceName(hInstance, 'ABOUT_LOGO');
  Rs:= TResourceStream.Create(HInstance, 'ABOUT_TEXT', RT_RCDATA);
  try
    rcAbout.Lines.LoadFromStream(Rs);
  finally
    Rs.Free;
  end;

end;

procedure TfrmAbout.pbBwahPaint(Sender: TObject);
begin

  with pbBwah do
    DrawGradient(clWindow, clBtnFace, Canvas, ClientRect, TRUE);

end;

procedure TfrmAbout.pbxAbtPaint(Sender: TObject);
begin

  with pbxAbt.Canvas do
    begin

    DrawGradient($FFFFFF, $B7E2CA, pbxAbt.Canvas, pbxAbt.ClientRect, TRUE);

    Draw(LogoX, LogoY, AboutLogo);

    Brush.Style:= bsClear;
    Font.Color:= clWindowText;
    Font.Name:= 'Tahoma';
    Font.Size:= 10;
    TextOut(VersX, VersY, GetAppVer);

  end;

end;

procedure TfrmAbout.rcAboutURLClick(Sender: TObject; const URL: string);
begin

  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);

end;

procedure TfrmAbout.ThisBrokenHeartTest(Pass: Integer);
begin

  Assert(Pass < 16, Format('Passing recursive call no. %d, for someone who I miss :'')', [Pass]));
  ThisBrokenHeartTest(Pass + 1);

end;

end.
