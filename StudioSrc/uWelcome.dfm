object frmWelcome: TfrmWelcome
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Welcome to Line Theme Studio'
  ClientHeight = 411
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlWell: TPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 370
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitHeight = 233
    object rcWelcome: TRichEditURL
      Left = 2
      Top = 2
      Width = 461
      Height = 366
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'rcWelcome')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnURLClick = rcWelcomeURLClick
      ExplicitHeight = 229
    end
  end
  object pnlBwah: TPanel
    Left = 0
    Top = 370
    Width = 465
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitTop = 233
    object pbBwah: TPaintBox
      Left = 2
      Top = 2
      Width = 461
      Height = 37
      Align = alClient
      OnPaint = pbBwahPaint
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object lblCount: TLabel
      Left = 12
      Top = 12
      Width = 253
      Height = 13
      Caption = 'Anda telah menyimpan tema LINE sebanyak 999 kali.'
    end
    object BitBtn1: TBitBtn
      Left = 352
      Top = 6
      Width = 99
      Height = 25
      Kind = bkOK
      TabOrder = 0
    end
  end
end
