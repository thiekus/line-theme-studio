object frmFindProp: TfrmFindProp
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Find Theme Property'
  ClientHeight = 132
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Find for text'
  end
  object edtPropFnd: TEdit
    Left = 8
    Top = 27
    Width = 299
    Height = 21
    TabOrder = 0
  end
  object cbxPrpNm: TCheckBox
    Left = 8
    Top = 54
    Width = 137
    Height = 17
    Caption = 'Find for Property Key'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object cbxPrpVal: TCheckBox
    Left = 8
    Top = 77
    Width = 137
    Height = 17
    Caption = 'Find for Property Value'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 100
    Width = 81
    Height = 25
    Caption = '&Back'
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 95
    Top = 100
    Width = 81
    Height = 25
    Caption = '&Next'
    Default = True
    TabOrder = 5
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 210
    Top = 100
    Width = 97
    Height = 25
    Kind = bkClose
    TabOrder = 6
    OnClick = BitBtn3Click
  end
  object cbxMatch: TCheckBox
    Left = 151
    Top = 54
    Width = 156
    Height = 17
    Caption = 'Match Case'
    TabOrder = 3
  end
end
