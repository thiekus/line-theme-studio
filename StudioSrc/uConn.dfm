object frmConn: TfrmConn
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Connect to device'
  ClientHeight = 216
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 96
    Height = 13
    Caption = 'Device host location'
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object Label3: TLabel
    Left = 8
    Top = 103
    Width = 275
    Height = 58
    AutoSize = False
    Caption = 
      'Note: to connect to another Android emulator (e.g Bluestack, Gen' +
      'yMotion, Windroye, etc) fill host to localhost and port as descr' +
      'ibed on documentation (e.g 5555, 10001, 10002, etc).'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 176
    Width = 275
    Height = 2
    Shape = bsBottomLine
  end
  object edtHost: TEdit
    Left = 8
    Top = 24
    Width = 275
    Height = 21
    TabOrder = 0
    Text = 'localhost'
  end
  object spPort: TSpinEdit
    Left = 8
    Top = 67
    Width = 96
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 1
    Value = 5555
  end
  object btnOk: TBitBtn
    Left = 95
    Top = 184
    Width = 91
    Height = 25
    Kind = bkOK
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TBitBtn
    Left = 192
    Top = 184
    Width = 91
    Height = 25
    Kind = bkCancel
    TabOrder = 3
  end
end
