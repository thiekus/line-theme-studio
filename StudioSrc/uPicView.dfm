object frmPrev: TfrmPrev
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Preview'
  ClientHeight = 481
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dckPrv: TDock97
    Left = 0
    Top = 0
    Width = 704
    Height = 26
    AllowDrag = False
    object tlbPrv: TToolbar97
      Left = 0
      Top = 0
      Caption = 'Preview'
      DockPos = 0
      FullSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object btnZo: TToolbarButton97
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Action = zmOut
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
        OnMouseDown = btnZoMouseDown
        OnMouseUp = btnZoMouseUp
      end
      object ToolbarSep971: TToolbarSep97
        Left = 46
        Top = 0
      end
      object btnZi: TToolbarButton97
        Left = 23
        Top = 0
        Width = 23
        Height = 22
        Action = zmIn
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
        OnMouseDown = btnZiMouseDown
        OnMouseUp = btnZiMouseUp
      end
      object ToolbarButton973: TToolbarButton97
        Left = 52
        Top = 0
        Width = 23
        Height = 22
        Action = imgEdit
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
      end
      object ToolbarButton974: TToolbarButton97
        Left = 75
        Top = 0
        Width = 23
        Height = 22
        Action = imgImp
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
      end
      object ToolbarSep972: TToolbarSep97
        Left = 144
        Top = 0
      end
      object ToolbarButton975: TToolbarButton97
        Left = 98
        Top = 0
        Width = 23
        Height = 22
        Action = imgExp
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
      end
      object ToolbarButton976: TToolbarButton97
        Left = 121
        Top = 0
        Width = 23
        Height = 22
        Action = imgInfo
        DisplayMode = dmGlyphOnly
        Images = imgPrv
        Opaque = False
      end
      object cbxBgnd: TComboBox
        Left = 150
        Top = 0
        Width = 162
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Transparent'
        OnSelect = cbxBgndSelect
        Items.Strings = (
          'Transparent'
          'White'
          'Black'
          'Silver'
          'Gray')
      end
    end
  end
  object sbar: TStatusBar
    Left = 0
    Top = 462
    Width = 704
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Zoom Ratio: 100%'
        Width = 150
      end
      item
        Alignment = taCenter
        Text = 'Original Dimension: 999x999'
        Width = 200
      end
      item
        Alignment = taCenter
        Text = '<file name goes here>'
        Width = 50
      end>
  end
  object pnlCnt: TPanel
    Left = 0
    Top = 26
    Width = 704
    Height = 436
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    OnResize = pnlCntResize
    object scbPrev: TScrollBox
      Left = 2
      Top = 2
      Width = 700
      Height = 432
      Align = alClient
      BorderStyle = bsNone
      Color = clAppWorkSpace
      ParentColor = False
      TabOrder = 0
      object pbPrev: TPaintBox
        Left = 0
        Top = 0
        Width = 105
        Height = 105
        OnPaint = pbPrevPaint
      end
    end
  end
  object actPrv: TActionList
    Images = imgPrv
    Left = 144
    Top = 80
    object zmIn: TAction
      Caption = 'Zoom &In'
      Hint = 'Zoom In'
      ImageIndex = 1
      OnExecute = zmInExecute
    end
    object zmOut: TAction
      Caption = 'Zoom &Out'
      Hint = 'Zoom Out'
      ImageIndex = 0
      OnExecute = zmOutExecute
    end
    object imgEdit: TAction
      Caption = '&Edit Image'
      Hint = 'Edit Image'
      ImageIndex = 2
      OnExecute = imgEditExecute
    end
    object imgImp: TAction
      Caption = '&Import Image'
      Hint = 'Import Image'
      ImageIndex = 3
      OnExecute = imgImpExecute
    end
    object imgExp: TAction
      Caption = 'E&xport Image'
      Hint = 'Export Image'
      ImageIndex = 4
      OnExecute = imgExpExecute
    end
    object imgInfo: TAction
      Caption = 'Image In&formation'
      Hint = 'Image Information'
      ImageIndex = 5
      OnExecute = imgInfoExecute
    end
  end
  object imgPrv: TImageList
    Left = 200
    Top = 80
  end
  object tmrSo: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrSoTimer
    Left = 16
    Top = 32
  end
  object tmrSi: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrSiTimer
    Left = 64
    Top = 32
  end
  object odlgImpr: TOpenPictureDialog
    Left = 144
    Top = 144
  end
  object sdlgExpr: TSavePictureDialog
    Left = 200
    Top = 144
  end
end
