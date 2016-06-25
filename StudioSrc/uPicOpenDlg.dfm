object dlgOpenPict: TdlgOpenPict
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Import Picture'
  ClientHeight = 391
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
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
      Width = 74
      Height = 13
      Caption = 'Format Gambar'
    end
    object Label2: TLabel
      Left = 16
      Top = 75
      Width = 53
      Height = 13
      Caption = 'Ukuran File'
    end
    object Label3: TLabel
      Left = 16
      Top = 118
      Width = 36
      Height = 13
      Caption = 'Dimensi'
    end
    object Label4: TLabel
      Left = 16
      Top = 160
      Width = 38
      Height = 13
      Caption = 'Preview'
    end
    object lblStat: TLabel
      Left = 16
      Top = 367
      Width = 145
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Tidak ada file terpilih!'
    end
    object edtPicFmt: TEdit
      Left = 16
      Top = 48
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = 'Cony'
    end
    object edtPicSize: TEdit
      Left = 16
      Top = 91
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = 'Thiekus'
    end
    object edtPicDim: TEdit
      Left = 16
      Top = 134
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = 'Versi'
    end
    object cbxDesc: TCheckBox
      Left = 16
      Top = 9
      Width = 145
      Height = 17
      Caption = 'Perlihatkan deskripsi file'
      TabOrder = 0
      OnClick = cbxDescClick
    end
    object pnlPrev: TPanel
      Left = 16
      Top = 176
      Width = 145
      Height = 185
      Anchors = [akLeft, akTop, akBottom]
      BevelOuter = bvLowered
      TabOrder = 4
      object pbPrev: TPaintBox
        Left = 1
        Top = 1
        Width = 143
        Height = 183
        Align = alClient
        OnPaint = pbPrevPaint
        ExplicitLeft = 48
        ExplicitTop = 40
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
  object dlOpen: TStDialogPanel
    Left = 179
    Top = 0
    Width = 495
    Height = 391
    AllowResize = True
    FilterIndex = 0
    OpenButtonCaption = '&Open'
    Style = nsWinXP
    OnItemClick = dlOpenItemClick
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
end
