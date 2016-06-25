object fmManed: TfmManed
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Manifest Editor'
  ClientHeight = 412
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    579
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object lblMainfo: TLabel
    Left = 16
    Top = 16
    Width = 545
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Disini anda bisa mengatur deskripsi tema secara cepat yang akan ' +
      'disimpan ke entitas Manifest.'#13#10'Perhatian: Informasi hanya disimp' +
      'an dalam file tema ini saja, dan tidak akan mempengaruhi nama da' +
      'n deskirpsi tema yang akan ditimpa.'
    WordWrap = True
  end
  object lbl1: TLabel
    Left = 16
    Top = 80
    Width = 56
    Height = 13
    Caption = 'Nama Tema'
  end
  object lbl2: TLabel
    Left = 16
    Top = 107
    Width = 67
    Height = 13
    Caption = 'Platform tema'
  end
  object lbl3: TLabel
    Left = 16
    Top = 134
    Width = 72
    Height = 13
    Caption = 'Nama Pembuat'
  end
  object lbl4: TLabel
    Left = 16
    Top = 161
    Width = 64
    Height = 13
    Caption = 'URL Pembuat'
  end
  object lbl5: TLabel
    Left = 16
    Top = 188
    Width = 52
    Height = 13
    Caption = 'Versi Tema'
  end
  object lbl6: TLabel
    Left = 16
    Top = 215
    Width = 42
    Height = 13
    Caption = 'Revisi ke'
  end
  object lbl7: TLabel
    Left = 16
    Top = 242
    Width = 57
    Height = 13
    Caption = 'Versi Skema'
  end
  object lbl8: TLabel
    Left = 16
    Top = 269
    Width = 66
    Height = 13
    Caption = 'Kualitas Tema'
  end
  object lbl9: TLabel
    Left = 232
    Top = 309
    Width = 123
    Height = 13
    Caption = 'Data telah tersimpan!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object edt1: TEdit
    Left = 112
    Top = 77
    Width = 225
    Height = 21
    TabOrder = 0
    Text = 'edt1'
  end
  object edt2: TEdit
    Left = 112
    Top = 104
    Width = 225
    Height = 21
    TabOrder = 1
    Text = 'edt2'
  end
  object edt3: TEdit
    Left = 112
    Top = 131
    Width = 225
    Height = 21
    TabOrder = 2
    Text = 'edt3'
  end
  object edt4: TEdit
    Left = 112
    Top = 158
    Width = 225
    Height = 21
    TabOrder = 3
    Text = 'edt4'
  end
  object edt5: TEdit
    Left = 112
    Top = 185
    Width = 225
    Height = 21
    TabOrder = 4
    Text = 'edt5'
  end
  object edt6: TEdit
    Left = 112
    Top = 212
    Width = 225
    Height = 21
    TabOrder = 5
    Text = 'edt6'
  end
  object edt7: TEdit
    Left = 112
    Top = 239
    Width = 225
    Height = 21
    TabOrder = 6
    Text = 'edt7'
  end
  object edt8: TEdit
    Left = 112
    Top = 266
    Width = 225
    Height = 21
    TabOrder = 7
    Text = 'edt8'
  end
  object btn1: TBitBtn
    Left = 112
    Top = 304
    Width = 105
    Height = 25
    Caption = '&Simpan Data'
    Default = True
    TabOrder = 8
  end
end
