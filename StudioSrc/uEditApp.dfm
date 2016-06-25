object frmEditApp: TfrmEditApp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add/Edit External Editor'
  ClientHeight = 253
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Application Path'
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 112
    Height = 13
    Caption = 'Commandline argument'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 211
    Width = 346
    Height = 2
  end
  object edtPath: TEdit
    Left = 8
    Top = 27
    Width = 265
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 279
    Top = 25
    Width = 75
    Height = 25
    Caption = '&Browse'
    TabOrder = 1
  end
  object edtCmd: TEdit
    Left = 8
    Top = 73
    Width = 265
    Height = 21
    TabOrder = 2
  end
  object mmHelp: TMemo
    Left = 8
    Top = 100
    Width = 346
    Height = 105
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      
        'Here you can add your favorite image editor for easy editing fro' +
        'm '
      'image preview window.'
      'Set application path into your editing aplication program.'
      'For Command line, use %s to replace argument as file path that '
      'generated during editing session.'
      
        'Note that some application that use single instance scheme may c' +
        'ause '
      'problem (like Photoshop).')
    ReadOnly = True
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 204
    Top = 219
    Width = 75
    Height = 25
    Kind = bkOK
    TabOrder = 4
  end
  object BitBtn2: TBitBtn
    Left = 285
    Top = 219
    Width = 75
    Height = 25
    Kind = bkCancel
    TabOrder = 5
  end
end
