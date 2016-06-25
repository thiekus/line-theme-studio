object fmResc: TfmResc
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Resource Editor'
  ClientHeight = 408
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object spl: TSplitter
    Left = 379
    Top = 26
    Height = 382
    Align = alRight
    ExplicitLeft = 360
    ExplicitTop = 224
    ExplicitHeight = 100
  end
  object dckRsc: TDock97
    Left = 0
    Top = 0
    Width = 574
    Height = 26
    AllowDrag = False
    object tlbRsc: TToolbar97
      Left = 0
      Top = 0
      Caption = 'tlbRsc'
      DockPos = 0
      FullSize = True
      TabOrder = 0
      object ToolbarButton971: TToolbarButton97
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Action = actUp
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarButton972: TToolbarButton97
        Left = 23
        Top = 0
        Width = 23
        Height = 22
        Action = actRefs
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarSep971: TToolbarSep97
        Left = 46
        Top = 0
      end
      object ToolbarButton973: TToolbarButton97
        Left = 52
        Top = 0
        Width = 23
        Height = 22
        Action = actRepl
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarButton974: TToolbarButton97
        Left = 75
        Top = 0
        Width = 23
        Height = 22
        Action = actExpr
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarButton975: TToolbarButton97
        Left = 98
        Top = 0
        Width = 23
        Height = 22
        Action = actAddResc
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarSep972: TToolbarSep97
        Left = 144
        Top = 0
      end
      object ToolbarButton976: TToolbarButton97
        Left = 121
        Top = 0
        Width = 23
        Height = 22
        Action = actDelResc
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarButton977: TToolbarButton97
        Left = 150
        Top = 0
        Width = 23
        Height = 22
        Action = actPrev
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
      object ToolbarButton978: TToolbarButton97
        Left = 173
        Top = 0
        Width = 23
        Height = 22
        Action = actInfo
        DisplayMode = dmGlyphOnly
        Images = imgRtlb
        Opaque = False
      end
    end
  end
  object pnlData: TPanel
    Left = 0
    Top = 26
    Width = 379
    Height = 382
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    OnResize = pnlDataResize
    object lvResc: TListView
      Left = 1
      Top = 1
      Width = 377
      Height = 380
      Align = alClient
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'Name'
        end>
      Items.ItemData = {
        03540000000200000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
        00085400650073007400200031003200330000000000FFFFFFFFFFFFFFFF0000
        0000FFFFFFFF000000000854006500730074002000340035003600}
      LargeImages = RescLst
      ReadOnly = True
      PopupMenu = pmDir
      TabOrder = 0
      OnDblClick = lvRescDblClick
      OnKeyPress = lvRescKeyPress
      OnSelectItem = lvRescSelectItem
    end
  end
  object pnlDesc: TPanel
    Left = 382
    Top = 26
    Width = 192
    Height = 382
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Constraints.MinWidth = 192
    TabOrder = 2
    DesignSize = (
      192
      382)
    object pbRescPan: TPaintBox
      Left = 2
      Top = 2
      Width = 188
      Height = 378
      Align = alClient
      OnPaint = pbRescPanPaint
      ExplicitLeft = 16
      ExplicitTop = 296
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object lblRnm: TLabel
      Left = 2
      Top = 223
      Width = 187
      Height = 13
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = '<item name>.jpg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      ExplicitLeft = 6
    end
    object lblRsz: TLabel
      Left = 2
      Top = 242
      Width = 187
      Height = 13
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = 'Size: 999 Kb'
      Visible = False
      ExplicitLeft = 6
    end
    object lblRdm: TLabel
      Left = 2
      Top = 261
      Width = 187
      Height = 13
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = 'Dimension: 999x999 px'
      Visible = False
      ExplicitLeft = 6
    end
    object pnlImg: TPanel
      Left = 5
      Top = 33
      Width = 182
      Height = 182
      Anchors = [akTop]
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 1
      Visible = False
      object pbxRprv: TPaintBox
        Left = 1
        Top = 1
        Width = 180
        Height = 180
        Cursor = crHandPoint
        Align = alClient
        OnDblClick = pbxRprvDblClick
        OnPaint = pbxRprvPaint
        ExplicitTop = 0
      end
    end
    object cbxRbgn: TComboBox
      Left = 5
      Top = 6
      Width = 182
      Height = 21
      Style = csDropDownList
      Anchors = [akTop]
      ItemIndex = 0
      TabOrder = 0
      Text = 'Transparent'
      Visible = False
      OnChange = cbxRbgnChange
      Items.Strings = (
        'Transparent'
        'White'
        'Black'
        'Silver'
        'Gray')
    end
  end
  object RescLst: TImageList
    Height = 96
    Width = 96
    Left = 104
    Top = 176
  end
  object actResc: TActionList
    Images = imgRtlb
    Left = 16
    Top = 40
    object actUp: TAction
      Caption = '&Up Directory'
      Hint = 'Up Directory'
      ImageIndex = 0
      OnExecute = actUpExecute
    end
    object actRefs: TAction
      Caption = '&Refresh'
      Hint = 'Refresh'
      ImageIndex = 1
      OnExecute = actRefsExecute
    end
    object actRepl: TAction
      Caption = '&Replace file'
      Hint = 'Replace file'
      ImageIndex = 2
      OnExecute = actReplExecute
    end
    object actExpr: TAction
      Caption = '&Export file'
      Hint = 'Export File'
      ImageIndex = 3
      OnExecute = actExprExecute
    end
    object actPrev: TAction
      Caption = '&Preview picture'
      Hint = 'Preview Image'
      ImageIndex = 6
      OnExecute = actPrevExecute
    end
    object actAddResc: TAction
      Caption = '&Add Resource'
      Hint = 'Add resource'
      ImageIndex = 4
    end
    object actDelResc: TAction
      Caption = '&Delete resource'
      Hint = 'Delete resource'
      ImageIndex = 5
    end
    object actInfo: TAction
      Caption = 'File &information'
      Hint = 'File Information'
      ImageIndex = 7
      OnExecute = actInfoExecute
    end
  end
  object imgRtlb: TImageList
    Left = 64
    Top = 40
  end
  object odlgRepl: TOpenDialog
    Left = 120
    Top = 40
  end
  object pmDir: TPopupMenu
    Left = 184
    Top = 40
    object Opendirectory1: TMenuItem
      Caption = '&Open directory'
    end
  end
  object odlgReplPic: TOpenPictureDialog
    Left = 120
    Top = 96
  end
  object sdlgImpr: TSaveDialog
    Left = 40
    Top = 160
  end
  object pmFile: TPopupMenu
    Images = imgRtlb
    Left = 240
    Top = 40
    object Previewpicture1: TMenuItem
      Action = actPrev
      Default = True
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Replacefile1: TMenuItem
      Action = actRepl
    end
    object Importfile1: TMenuItem
      Action = actExpr
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object AddResource1: TMenuItem
      Action = actAddResc
    end
    object Deleteresource1: TMenuItem
      Action = actDelResc
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Action = actRefs
    end
    object UpDirectory1: TMenuItem
      Action = actUp
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Fileinformation1: TMenuItem
      Action = actInfo
    end
  end
  object tmrThDelay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrThDelayTimer
    Left = 200
    Top = 168
  end
end
