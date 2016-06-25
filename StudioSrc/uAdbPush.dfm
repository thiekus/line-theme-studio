object frmAdbp: TfrmAdbp
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Transfer trough Adb'
  ClientHeight = 92
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblNote: TLabel
    Left = 8
    Top = 8
    Width = 354
    Height = 30
    AutoSize = False
    Caption = 'Please wait while application pushing file via adb...'
    Transparent = True
    WordWrap = True
  end
  object lblSrc: TLabel
    Left = 8
    Top = 54
    Width = 354
    Height = 13
    AutoSize = False
    Caption = 'Source File: XXXXXX.3GP'
    Transparent = True
  end
  object lblDest: TLabel
    Left = 8
    Top = 73
    Width = 354
    Height = 13
    AutoSize = False
    Caption = 'Destination: XXX/XXX/XXX'
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 46
    Width = 354
    Height = 2
  end
  object tmrWait: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrWaitTimer
    Left = 304
    Top = 16
  end
end
