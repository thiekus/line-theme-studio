object dlgOpenTheme: TdlgOpenTheme
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Membuka Tema'
  ClientHeight = 391
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dlOpen: TStDialogPanel
    Tag = 777
    Left = 179
    Top = 0
    Width = 495
    Height = 391
    AllowResize = True
    Filter = 'Line ThemeFile|*'
    FilterIndex = 0
    OpenButtonCaption = '&Open'
    Style = nsWinXP
    Align = alClient
    BevelOuter = bvNone
    FullRepaint = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object pnlSide: TPanel
    Left = 0
    Top = 0
    Width = 179
    Height = 391
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      179
      391)
    object Label1: TLabel
      Left = 16
      Top = 32
      Width = 56
      Height = 13
      Caption = 'Nama Tema'
    end
    object Label2: TLabel
      Left = 16
      Top = 75
      Width = 42
      Height = 13
      Caption = 'Pembuat'
    end
    object Label3: TLabel
      Left = 16
      Top = 118
      Width = 23
      Height = 13
      Caption = 'Versi'
    end
    object Label4: TLabel
      Left = 16
      Top = 160
      Width = 76
      Height = 13
      Caption = 'Tampilan Splash'
    end
    object Label5: TLabel
      Left = 16
      Top = 367
      Width = 145
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Tidak ada file terpilih!'
    end
    object edtTmName: TEdit
      Left = 16
      Top = 48
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = 'Cony'
    end
    object edtTmAuth: TEdit
      Left = 16
      Top = 91
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = 'Thiekus'
    end
    object edtTmVer: TEdit
      Left = 16
      Top = 134
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = 'Versi'
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 9
      Width = 145
      Height = 17
      Caption = 'Perlihatkan deskripsi tema'
      TabOrder = 0
    end
    object pnlPrev: TPanel
      Left = 16
      Top = 176
      Width = 145
      Height = 185
      Anchors = [akLeft, akTop, akBottom]
      BevelOuter = bvLowered
      TabOrder = 4
    end
  end
end
