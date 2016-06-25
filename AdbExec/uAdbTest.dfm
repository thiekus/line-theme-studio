object frmTest: TfrmTest
  Left = 293
  Top = 116
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AdbExec test'
  ClientHeight = 515
  ClientWidth = 795
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 795
    Height = 515
    ActivePage = tbList
    Align = alClient
    TabOrder = 0
    object tbList: TTabSheet
      Caption = 'Devicel List'
      object Label1: TLabel
        Left = 8
        Top = 3
        Width = 102
        Height = 13
        Caption = 'Get attached devices'
      end
      object Label2: TLabel
        Left = 8
        Top = 440
        Width = 78
        Height = 13
        Caption = 'Set device serial'
      end
      object Button1: TButton
        Left = 11
        Top = 22
        Width = 75
        Height = 25
        Caption = 'Get'
        Default = True
        TabOrder = 0
        OnClick = Button1Click
      end
      object mmLst: TMemo
        Left = 8
        Top = 320
        Width = 761
        Height = 113
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object edtDev: TEdit
        Left = 8
        Top = 456
        Width = 209
        Height = 21
        TabOrder = 3
      end
      object sgdev: TStringGrid
        Left = 8
        Top = 56
        Width = 761
        Height = 249
        DefaultColWidth = 140
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 1
        OnSelectCell = sgdevSelectCell
      end
    end
    object tbCust: TTabSheet
      Caption = 'Custom command'
      ImageIndex = 1
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 47
        Height = 13
        Caption = 'Command'
      end
      object edtCust: TEdit
        Left = 8
        Top = 24
        Width = 697
        Height = 21
        TabOrder = 0
      end
      object Button2: TButton
        Left = 8
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Execute'
        Default = True
        TabOrder = 1
        OnClick = Button2Click
      end
      object mmOut: TMemo
        Left = 8
        Top = 80
        Width = 769
        Height = 401
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object cbxDev: TCheckBox
        Left = 96
        Top = 51
        Width = 145
        Height = 17
        Caption = 'Use defined device id'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
    end
    object tbShell: TTabSheet
      Caption = 'Shell test'
      ImageIndex = 2
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 96
        Height = 13
        Caption = 'Shell console output'
      end
      object lblStt: TLabel
        Left = 8
        Top = 440
        Width = 90
        Height = 13
        Caption = 'shell not launched!'
      end
      object Label6: TLabel
        Left = 120
        Top = 440
        Width = 74
        Height = 13
        Caption = 'shell commands'
      end
      object mmShell: TMemo
        Left = 8
        Top = 24
        Width = 769
        Height = 409
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object btnShl: TButton
        Left = 8
        Top = 459
        Width = 75
        Height = 25
        Caption = 'Launch!'
        TabOrder = 1
        OnClick = btnShlClick
      end
      object edtCmd: TEdit
        Left = 120
        Top = 456
        Width = 569
        Height = 21
        Enabled = False
        TabOrder = 2
      end
      object Button4: TButton
        Left = 696
        Top = 456
        Width = 75
        Height = 25
        Caption = 'Enter!'
        Default = True
        Enabled = False
        TabOrder = 3
        OnClick = Button4Click
      end
    end
  end
  object tmrShl: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrShlTimer
    Left = 104
    Top = 312
  end
end
