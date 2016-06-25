unit uMedsos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Registry, ShellAPI;

type
  TfrmMedsos = class(TForm)
    lblMsg: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    cbxLike: TCheckBox;
    BitBtn1: TBitBtn;
    lblCnt: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }

    procedure BukaURL(URL: string);

  public
    { Public declarations }
  end;

const
  SCntMsg = 'Terima kasih telah menggunakan Line Theme Studio dengan banyak tema yang tersimpan sebanyak %d kali.';
  LikeMsg = 'Meskipun aplikasi ini 100% gratis dan kami tidak akan pernah '+
            'memungut biaya apapun dari aplikasi ini, tetapi apresiasi dari '+
            'anda dapat memberi semangat untuk terus mengembangkan aplikasi '+
            'yang lebih baik lagi. Untuk itu, jika berkenan, dimohon untuk '+
            'Like atau follow akun Media Sosial dari Khayalan Software sebagai berikut.';

var
  frmMedsos: TfrmMedsos;

implementation

uses uMain;

{$R *.dfm}

procedure TfrmMedsos.BitBtn1Click(Sender: TObject);
var
  reglike: TRegistry;
begin

  reglike:= TRegistry.Create(KEY_WRITE);
  try
    reglike.RootKey:= HKEY_CURRENT_USER;
    reglike.OpenKey('\Software\Khayalan Software\Line Theme Studio', TRUE);
    reglike.WriteBool('LikeOnSocialMedia', cbxLike.Checked);
  finally
    reglike.CloseKey;
    reglike.Free;
  end;

end;

procedure TfrmMedsos.BukaURL(URL: string);
begin

  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);

end;

procedure TfrmMedsos.FormShow(Sender: TObject);
begin

  lblCnt.Caption:= Format(SCntMsg, [frmMain.SaveCounter]);
  lblMsg.Caption:= LikeMsg;

end;

procedure TfrmMedsos.SpeedButton1Click(Sender: TObject);
begin

  BukaURL('https://www.facebook.com/khayalansoft/');

end;

procedure TfrmMedsos.SpeedButton2Click(Sender: TObject);
begin

  BukaURL('https://twitter.com/khayalansoft');

end;

procedure TfrmMedsos.SpeedButton3Click(Sender: TObject);
begin

  BukaURL('https://plus.google.com/communities/102503498886819467936');

end;

procedure TfrmMedsos.SpeedButton4Click(Sender: TObject);
begin

  BukaURL('http://line.me/ti/p/~@qzt2306c');

end;

end.
