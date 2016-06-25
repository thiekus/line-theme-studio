object fmEdit: TfmEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Text Editor'
  ClientHeight = 342
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dckEdit: TDock97
    Left = 0
    Top = 0
    Width = 484
    Height = 26
    AllowDrag = False
    object tbEdit: TToolbar97
      Left = 0
      Top = 0
      Caption = 'Editor Toolbar'
      DockPos = 0
      FullSize = True
      TabOrder = 0
      object ToolbarButton971: TToolbarButton97
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Action = actImp
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton972: TToolbarButton97
        Left = 23
        Top = 0
        Width = 23
        Height = 22
        Action = actExp
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton973: TToolbarButton97
        Left = 46
        Top = 0
        Width = 23
        Height = 22
        Action = actSave
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarSep971: TToolbarSep97
        Left = 69
        Top = 0
      end
      object ToolbarButton974: TToolbarButton97
        Left = 75
        Top = 0
        Width = 23
        Height = 22
        Action = actUndo
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton975: TToolbarButton97
        Left = 98
        Top = 0
        Width = 23
        Height = 22
        Action = actRedo
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarSep972: TToolbarSep97
        Left = 121
        Top = 0
      end
      object ToolbarButton976: TToolbarButton97
        Left = 127
        Top = 0
        Width = 23
        Height = 22
        Action = actCut
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton977: TToolbarButton97
        Left = 150
        Top = 0
        Width = 23
        Height = 22
        Action = actCopy
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton978: TToolbarButton97
        Left = 173
        Top = 0
        Width = 23
        Height = 22
        Action = actPaste
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarSep973: TToolbarSep97
        Left = 196
        Top = 0
      end
      object ToolbarButton979: TToolbarButton97
        Left = 202
        Top = 0
        Width = 23
        Height = 22
        Action = actFind
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton9710: TToolbarButton97
        Left = 225
        Top = 0
        Width = 23
        Height = 22
        Action = actFindPrev
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton9711: TToolbarButton97
        Left = 248
        Top = 0
        Width = 23
        Height = 22
        Action = actFindNext
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
      object ToolbarButton9712: TToolbarButton97
        Left = 271
        Top = 0
        Width = 23
        Height = 22
        Action = actRepl
        DisplayMode = dmGlyphOnly
        Images = imgEtlb
        Opaque = False
      end
    end
  end
  object edtEdit: TSynEdit
    Left = 0
    Top = 26
    Width = 484
    Height = 316
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    PopupMenu = pMenu
    TabOrder = 1
    Gutter.Color = clBtnText
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.ShowLineNumbers = True
    Gutter.Gradient = True
    Gutter.GradientStartColor = clBtnFace
    Gutter.GradientEndColor = clWindow
    Highlighter = jsHighlt
    OnChange = edtEditChange
    FontSmoothing = fsmNone
  end
  object jsHighlt: TSynJScriptSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    NumberAttri.Foreground = clNavy
    StringAttri.Foreground = clNavy
    SymbolAttri.Foreground = clMaroon
    SymbolAttri.Style = [fsBold]
    Left = 208
    Top = 168
  end
  object imgEtlb: TImageList
    Left = 240
    Top = 40
  end
  object actEdt: TActionList
    Images = imgEtlb
    Left = 280
    Top = 40
    object actImp: TAction
      Caption = '&Import from file'
      Hint = 'Import from file'
      ImageIndex = 0
      ShortCut = 16457
      OnExecute = actImpExecute
    end
    object actExp: TAction
      Caption = '&Export to file'
      Hint = 'Export to file'
      ImageIndex = 1
      ShortCut = 16453
      OnExecute = actExpExecute
    end
    object actSave: TAction
      Caption = '&Save changes'
      Hint = 'Save changes'
      ImageIndex = 2
      ShortCut = 49235
      OnExecute = actSaveExecute
    end
    object actUndo: TAction
      Caption = '&Undo'
      Hint = 'Undo'
      ImageIndex = 3
      ShortCut = 16474
      OnExecute = actUndoExecute
    end
    object actRedo: TAction
      Caption = '&Redo'
      Hint = 'Redo'
      ImageIndex = 4
      ShortCut = 16473
      OnExecute = actRedoExecute
    end
    object actCut: TAction
      Caption = '&Cut'
      Hint = 'Cut'
      ImageIndex = 5
      ShortCut = 16472
      OnExecute = actCutExecute
    end
    object actCopy: TAction
      Caption = '&Copy'
      Hint = 'Copy'
      ImageIndex = 6
      ShortCut = 16451
      OnExecute = actCopyExecute
    end
    object actPaste: TAction
      Caption = '&Paste'
      Hint = 'Paste'
      ImageIndex = 7
      ShortCut = 16470
      OnExecute = actPasteExecute
    end
    object actFind: TAction
      Caption = '&Find text'
      Hint = 'Find text'
      ImageIndex = 8
      OnExecute = actFindExecute
    end
    object actFindPrev: TAction
      Caption = 'Find &Previous'
      Hint = 'Find Previous'
      ImageIndex = 9
      OnExecute = actFindPrevExecute
    end
    object actFindNext: TAction
      Caption = 'Find &Next'
      Hint = 'Find Next'
      ImageIndex = 10
      OnExecute = actFindNextExecute
    end
    object actRepl: TAction
      Caption = '&Replace Text'
      Hint = 'Replace Text'
      ImageIndex = 11
      OnExecute = actReplExecute
    end
  end
  object eodlg: TOpenDialog
    Filter = 'Json File (*.json)|*.json'
    Left = 240
    Top = 96
  end
  object esdlg: TSaveDialog
    Filter = 'Json File (*.json)|*.json'
    Left = 280
    Top = 96
  end
  object pMenu: TPopupMenu
    Images = imgEtlb
    Left = 240
    Top = 168
    object Cut1: TMenuItem
      Action = actCut
    end
    object Copy1: TMenuItem
      Action = actCopy
    end
    object Paste1: TMenuItem
      Action = actPaste
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Undo1: TMenuItem
      Action = actUndo
    end
    object Redo1: TMenuItem
      Action = actRedo
    end
  end
  object SynEditRegexSearch: TSynEditRegexSearch
    Left = 80
    Top = 72
  end
  object SynEditSearch: TSynEditSearch
    Left = 80
    Top = 144
  end
end
