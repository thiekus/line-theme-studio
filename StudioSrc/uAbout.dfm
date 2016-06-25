object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'About Line Theme Studio'
  ClientHeight = 415
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pAbt: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 374
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object pbxAbt: TPaintBox
      Left = 2
      Top = 2
      Width = 413
      Height = 370
      Align = alClient
      OnPaint = pbxAbtPaint
      ExplicitLeft = 8
      ExplicitTop = 192
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object rcAbout: TRichEditURL
      Tag = 777
      Left = 16
      Top = 200
      Width = 385
      Height = 153
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'rcAbout')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnURLClick = rcAboutURLClick
    end
  end
  object pBtm: TPanel
    Left = 0
    Top = 374
    Width = 417
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object pbBwah: TPaintBox
      Left = 2
      Top = 2
      Width = 413
      Height = 37
      Align = alClient
      OnPaint = pbBwahPaint
      ExplicitLeft = 0
      ExplicitTop = 16
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object BitBtn1: TBitBtn
      Left = 303
      Top = 6
      Width = 105
      Height = 25
      Kind = bkOK
      TabOrder = 0
    end
    object btnTst: TButton
      Left = 16
      Top = 6
      Width = 105
      Height = 25
      Caption = 'Exception test'
      TabOrder = 1
      Visible = False
      OnClick = btnTstClick
    end
  end
end
