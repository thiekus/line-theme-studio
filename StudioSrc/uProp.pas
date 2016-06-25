unit uProp;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: TreeView Editor                                              *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TB97Ctls, TB97, TB97Tlbr, ComCtrls, Buttons,
  VirtualTrees, superobject, ImgList, JsonUtils, PngImage, CustomUtils, ActnList,
  SynGdiPlus;

const
  srcReset = $00000001;
  srcKey   = $00000002;
  srcValue = $00000004;
  srcMatch = $00000008;

type

  TFindOrder = (foNext, foPrev);

  TUndoData = record
    TreeStruct: TMemoryStream;
    NodeCount: Integer;
    NodeData: array of TJsonNode;
  end;
  PUndoData = ^TUndoData;

  TPropertyUndo = record
    Count: Integer;
    Index: Integer;
    List: array of TUndoData;
  end;
  PPropertyUndo = ^TPropertyUndo;

type
  TfmProp = class(TForm)
    dckProp: TDock97;
    tlbProp: TToolbar97;
    ToolbarButton971: TToolbarButton97;
    pnlItms: TPanel;
    pnlProp: TPanel;
    spl: TSplitter;
    Panel1: TPanel;
    pbxCap: TPaintBox;
    lblPropc: TLabel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    edtVal: TEdit;
    btnPcom: TBitBtn;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    cbxType: TComboBox;
    pgcEdit: TPageControl;
    tbColor: TTabSheet;
    edtClr: TEdit;
    Label3: TLabel;
    tbImage: TTabSheet;
    Label4: TLabel;
    vsProp: TVirtualStringTree;
    cbxAlp: TCheckBox;
    scrClalp: TScrollBar;
    lblClalp: TLabel;
    cdlg: TColorDialog;
    pnlClr: TPanel;
    pbClr: TPaintBox;
    imgPrp: TImageList;
    lblPdim: TLabel;
    pnlPprv: TPanel;
    pbxPprv: TPaintBox;
    cbxPbgn: TComboBox;
    tbPadd: TTabSheet;
    Label1: TLabel;
    edtPad1: TEdit;
    Label5: TLabel;
    edtPad2: TEdit;
    Label6: TLabel;
    edtPad3: TEdit;
    Label7: TLabel;
    edtPad4: TEdit;
    tbBool: TTabSheet;
    Label8: TLabel;
    cbxPBool: TComboBox;
    actPrp: TActionList;
    actCommit: TAction;
    ToolbarButton972: TToolbarButton97;
    ToolbarSep971: TToolbarSep97;
    ToolbarButton973: TToolbarButton97;
    ToolbarButton974: TToolbarButton97;
    ToolbarButton975: TToolbarButton97;
    ToolbarButton976: TToolbarButton97;
    ToolbarSep972: TToolbarSep97;
    imgTlb: TImageList;
    ToolbarSep973: TToolbarSep97;
    ToolbarButton977: TToolbarButton97;
    ToolbarButton978: TToolbarButton97;
    actRefr: TAction;
    actFind: TAction;
    actAddProp: TAction;
    actDelProp: TAction;
    actUndo: TAction;
    actRedo: TAction;
    actFindPrev: TAction;
    procedure cbxTypeChange(Sender: TObject);
    procedure vsPropResize(Sender: TObject);
    procedure vsPropCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vsPropGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vsPropFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure scrClalpChange(Sender: TObject);
    procedure edtClrChange(Sender: TObject);
    procedure pbClrClick(Sender: TObject);
    procedure pbClrPaint(Sender: TObject);
    procedure vsPropGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vsPropChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormCreate(Sender: TObject);
    procedure pbxPprvPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxPbgnChange(Sender: TObject);
    procedure pbxCapPaint(Sender: TObject);
    procedure cbxAlpClick(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure vsPropGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure actRefrExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actDelPropExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure pbxPprvClick(Sender: TObject);
    procedure cbxPBoolChange(Sender: TObject);
  private
    { Private declarations }

    PropStream: TStream;
    MainNode: PVirtualNode;
    SelNode:  PVirtualNode;
    LastNode: PJsonNode;
    PreviewPic: TPngImage;
    ColorProp: TColor;
    AlphaVal: Byte;
    IsAlphaColor: boolean;
    UndoList: TPropertyUndo;

    procedure SetValue(const Val: string);
    procedure SetColorVal;
    procedure SetEditMode(const Node: PJsonNode; const Idx: integer = -1);
    procedure ChangeEditItem(Const NodeItem: PJsonNode);
    procedure ParseRoot(Const Root: ISuperObject);
    procedure UpdateToolbars;
    procedure ResetUndo;
    procedure SetUndoSnapshot;
    procedure LoadUndoSnapshot(NewIndex: Integer);
    procedure FreeUndoSnapshot(Index: Integer);

  public
    { Public declarations }

    function  FindProperty(const FindStr: string; const Order: TFindOrder; const Opts: Cardinal): boolean;
    function  ParseThemeObject(ThemeProp: TStream): boolean;
    function  SaveJsonTree: boolean;

  end;

var
  fmProp: TfmProp;

implementation

uses uMain, uFindProp, uPicView;

resourcestring
  GenHdrBy = 'Theme properties re-generated by Line Theme Studio %s';
  GenHdrTm = 'On %s, %d %s %d - %s';

{$R *.dfm}
{$R '../icons/PropGlyph.RES'}
const PropGlyphCount = 8;
const PtlbGlyphCount = 9;

procedure TfmProp.actCommitExecute(Sender: TObject);
begin

  SetUndoSnapshot;
  LastNode^.Obj.Merge(edtVal.Text);
  LastNode^.Kind:= GetValueKind(LastNode^.Obj);
  UpdateToolbars;
  (* Bilang kalau sudah diupdate *)
  frmMain.SetChanged;
  vsProp.Invalidate;

end;

procedure TfmProp.actDelPropExecute(Sender: TObject);
var
  data: PJsonNode;
  delImg: Integer;
begin

  data:= vsProp.GetNodeData(SelNode);
  delImg:= -1;
  if data^.Kind = vlImage then
    case MessageDlg('Do you want to delete this key and it''s reference image?'+#13+#10+
                    '(Deleted image isn''t undoable!)', mtWarning, [mbYes, mbNo, mbCancel], 0) of
      mrYes: begin
               with frmMain do
                 delImg:= SearchStreamIndex(data^.Obj.AsString);
             end;
      mrCancel: Exit;
    end;

  SetUndoSnapshot;
  vsProp.Selected[SelNode]:= FALSE;
  vsProp.DeleteNode(SelNode, TRUE);
  (* Reset item editor - untuk mencegah exception ketika menggambar picture lain *)
  ChangeEditItem(PJsonNode(vsProp.GetNodeData(MainNode)));
  SelNode:= nil;
  UpdateToolbars;
  (* Hapus gambar belakangan *)
  if delImg >= 0 then
    frmMain.DeleteStreamFromList(delImg);
  (* Bilang kalau sudah diupdate *)
  frmMain.SetChanged();
  vsProp.Invalidate;

end;

procedure TfmProp.actFindExecute(Sender: TObject);
begin

  frmFindProp.Show;

end;

procedure TfmProp.actRedoExecute(Sender: TObject);
var
  index: Integer;
begin

  index:= UndoList.Index + 1;
  LoadUndoSnapshot(index);

end;

procedure TfmProp.actRefrExecute(Sender: TObject);
begin

  ParseThemeObject(PropStream);

end;

procedure TfmProp.actUndoExecute(Sender: TObject);
var
  index: Integer;
begin

  index:= UndoList.Index - 1;
  LoadUndoSnapshot(index);

end;

procedure TfmProp.cbxAlpClick(Sender: TObject);
begin

  IsAlphaColor:= cbxAlp.Checked;
  scrClalp.Position:= AlphaVal;
  scrClalp.Enabled:= IsAlphaColor;
  SetColorVal;

end;

procedure TfmProp.cbxPbgnChange(Sender: TObject);
begin

   pbxPprv.Invalidate;

end;

procedure TfmProp.cbxPBoolChange(Sender: TObject);
begin

   if cbxPBool.ItemIndex = 0 then
     edtVal.Text:= 'false'
   else
     edtVal.Text:= 'true';

end;

procedure TfmProp.cbxTypeChange(Sender: TObject);
begin

  SetEditMode(LastNode, cbxType.ItemIndex);

end;

procedure TfmProp.ChangeEditItem(const NodeItem: PJsonNode);
begin

  if ObjectGetType(NodeItem^.Obj) <> stObject then
    edtVal.Text:= NodeItem^.Obj.AsJSon(TRUE, FALSE)
  else
    edtVal.Text:= '';

  case NodeItem^.Kind of
    vlString  : SetEditMode(NodeItem, 0);
    vlInteger : SetEditMode(NodeItem, 1);
    vlFloat   : SetEditMode(NodeItem, 2);
    vlBool    : SetEditMode(NodeItem, 3);
    vlColor   : SetEditMode(NodeItem, 4);
    vlImage   : SetEditMode(NodeItem, 5);
  else
    SetEditMode(NodeItem);
  end;

  LastNode:= NodeItem;
  lblPropc.Caption:= Format('Edit "%s"', [NodeItem^.Name]);

end;

procedure TfmProp.edtClrChange(Sender: TObject);
begin

  ColorProp:= StrToInt('$'+edtClr.Text);
  SetColorVal;

end;

function TfmProp.FindProperty(const FindStr: string; const Order: TFindOrder; const Opts: Cardinal): boolean;
var
  cpos, ctmp: PVirtualNode;
  data: PJsonNode;
  get: boolean;
  tstr: string;
begin

  Result:= False;
  if Order = foNext then
    begin
    if Boolean(Opts and srcReset) then
      cpos:= vsProp.GetFirstNoInit()
    else
      cpos:= vsProp.GetNextNoInit(SelNode)
  end
  else
    begin
    if Boolean(Opts and srcReset) then (* iterasi sampai ke belakang *)
      begin
      ctmp:= vsProp.GetFirstNoInit();
      repeat
        cpos:= ctmp;
        ctmp:= vsProp.GetNextNoInit(cpos);
      until not Assigned(ctmp);
    end
    else
      cpos:= vsProp.GetPreviousNoInit(SelNode);
  end;
  if not Boolean(Opts and srcMatch) then
    tstr:= UpperCase(FindStr)
  else
    tstr:= FindStr;
  get:= False;
  while Assigned(cpos) and not get do
    begin
    data:= vsProp.GetNodeData(cpos);
    get:= False;
    if Boolean(Opts and srcKey) then
      if Boolean(Opts and srcMatch) then
        get:= (Pos(tstr, data^.Name) > 0) or get
      else
        get:= (Pos(tstr, UpperCase(data^.Name)) > 0) or get;
    if Boolean(Opts and srcValue) then
      if Boolean(Opts and srcMatch) then
        get:= (Pos(tstr, data^.Obj.AsString) > 0) or get
      else
        get:= (Pos(tstr, UpperCase(data^.Obj.AsString)) > 0) or get;
    if get then
      begin
      vsProp.Selected[SelNode]:= False;
      vsProp.Expanded[cpos]:= True;
      vsProp.Selected[cpos]:= True;
      Result:= True;
    end;
    if Order = foNext then
      cpos:= vsProp.GetNextNoInit(cpos)
    else
      cpos:= vsProp.GetPreviousNoInit(cpos);
  end;
  if not get then
    begin
    if MessageDlg(Format('"%s" not found, do you want to try again from begining?', [FindStr]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      FindProperty(FindStr, Order, Opts or srcReset);
  end;

end;

procedure TfmProp.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  ResetUndo;

end;

procedure TfmProp.FormCreate(Sender: TObject);
var
  zfra: integer;
  tlbg: TBitmap;
begin

  imgPrp.Clear;
  for zfra:= 0 to PropGlyphCount - 1 do
    AddPngGlyph(ImgPrp, Format('PROP_%.2d', [zfra]), clWindow);
  for zfra:= 0 to PtlbGlyphCount - 1 do
    AddPngGlyph(ImgTlb, Format('PTLB_%.2d', [zfra]), clWindow);

  tlbg:= MakeToolbarBackground(dckProp.ClientHeight);
  try
    dckProp.Background.Assign(tlbg);
  finally
    tlbg.Free;
  end;

  PreviewPic:= TPngImage.Create;
  pnlPprv.DoubleBuffered:= TRUE;
  cbxPbgn.ItemIndex:= 0;

  FillChar(UndoList, SizeOf(TPropertyUndo), 0);

end;

procedure TfmProp.FormDestroy(Sender: TObject);
begin

  PreviewPic.Free;

end;

procedure TfmProp.FreeUndoSnapshot(Index: Integer);
var
  lp: Integer;
begin

  with UndoList.List[Index] do
    begin
    for lp:= 0 to NodeCount - 1 do
      begin
      NodeData[lp].Name:= '';
      NodeData[lp].Obj:= nil;
    end;
    TreeStruct.Free;
    TreeStruct:= nil;
  end;

end;

procedure TfmProp.LoadUndoSnapshot(NewIndex: Integer);
var
  TraceNode: PVirtualNode;
  NodeDataPtr: PJsonNode;
  NodeIndex: Integer;
begin

  if (UndoList.Index = UndoList.Count) and (NewIndex < UndoList.Index) then
    SetUndoSnapshot;
  with UndoList.List[NewIndex] do
    begin
    TreeStruct.Position:= 0;
    vsProp.LoadFromStream(TreeStruct);
    NodeIndex:= 0;
    TraceNode:= vsProp.GetFirstNoInit();
    repeat
      NodeDataPtr:= vsProp.GetNodeData(TraceNode);
      NodeDataPtr^.Index:=  NodeData[NodeIndex].Index;
      NodeDataPtr^.Name:= NodeData[NodeIndex].Name;
      NodeDataPtr^.Kind:= NodeData[NodeIndex].Kind;
      (* Lagi2 harus dikloning karena node data selalu dibebaskan oleh vsProp *)
      NodeDataPtr^.Obj:= NodeData[NodeIndex].Obj.Clone;
      Inc(NodeIndex);
      TraceNode:= vsProp.GetNextNoInit(TraceNode);
    until TraceNode = nil;
  end;
  UndoList.Index:= NewIndex;
  UpdateToolbars;
  (* Bilang kalau sudah diupdate *)
  frmMain.SetChanged;
  vsProp.Invalidate;

end;

procedure TfmProp.ParseRoot(const Root: ISuperObject);

  procedure ProcessNode(Parent: PVirtualNode; const Node: ISuperObject;
                        const Text: string; ID: Integer = -1);
  var
    cnode: PVirtualNode;
    data: PJsonNode;
    i: Integer;
    iter: TSuperObjectIter;
  begin
    cnode:= vsProp.AddChild(Parent);
    data:= vsProp.GetNodeData(cnode);
    data.Name:= Text;
    data.Obj:= Node;
    data.Index:= ID;
    if Parent <> nil then
      data.Kind:= GetValueKind(data.obj)
    else
      begin
      MainNode:= cnode;
      data.Kind:= vlMainRoot;
    end;
    Include(cnode.States, vsInitialized);
    case ObjectGetType(Node) of
      stObject:
        begin
          include(cnode.States, vsExpanded);
          if ObjectFindFirst(Node, iter) then
            repeat
              ProcessNode(cnode, iter.val, iter.key, -1);
            until not ObjectFindNext(iter);
          ObjectFindClose(iter);
        end;
      stArray:
        begin
          Include(cnode.States, vsExpanded);
          for i:= 0 to node.AsArray.Length - 1 do
            ProcessNode(cnode, Node.AsArray[i], IntToStr(i), i);
        end;
    end;
    vsProp.Expanded[cnode]:= Parent = nil;
  end;

begin

  vsProp.BeginUpdate;
  try
    vsProp.Clear;
    MainNode:= nil;
    ProcessNode(nil, Root, '[Root]');
  finally
    vsProp.EndUpdate;
  end;

end;

function TfmProp.ParseThemeObject(ThemeProp: TStream): boolean;
var
  sobj: TSuperObject;
  main: PVirtualNode;
  data: PJsonNode;
begin

  if ThemeProp = nil then
    begin
    MessageDlg('Tidak bisa membaca file Theme.json!', mtError, [mbOK], 0);
    Result:= FALSE;
    Exit;
  end;

  sobj:= TSuperObject.Create();
  try
    ParseRoot(sobj.ParseStream(ThemeProp, FALSE));
    PropStream:= ThemeProp;
  finally
    sobj.Free;
  end;
  main:= vsProp.GetFirstNoInit();
  vsProp.Selected[main]:= TRUE;
  data:= vsProp.GetNodeData(main);
  ChangeEditItem(data);
  vsProp.SetFocus;
  Result:= TRUE;

end;

procedure TfmProp.pbClrClick(Sender: TObject);
begin

  cdlg.Color:= SwapRGBColor(ColorProp);
  if cdlg.Execute then
    begin
    ColorProp:= cdlg.Color;
    edtClr.Text:= IntToHex(SwapRGBColor(ColorProp), 6);
    SetColorVal;
  end;

end;

procedure TfmProp.pbClrPaint(Sender: TObject);
begin

  if IsAlphaColor then
    TransparentBase(pbClr.Canvas, pbClr.ClientRect);
  pbClr.Canvas.Brush.Color:= SwapRGBColor(ColorProp);
  pbClr.Canvas.Brush.Style:= bsSolid;
  pbClr.Canvas.Pen.Style:= psClear;
  pbClr.Canvas.Rectangle(pbClr.ClientRect);

end;

procedure TfmProp.pbxCapPaint(Sender: TObject);
begin

  with pbxCap do
    DrawGradient(clBtnFace, clWindow, Canvas, ClientRect, TRUE);

end;

procedure TfmProp.pbxPprvClick(Sender: TObject);
var
  idx: integer;
  fname: string;
begin

  fname:= 'IMAGES/' + LastNode^.Obj.AsString;
  idx:= frmMain.SearchStreamIndex(fname);
  ShowImagePreview(idx);

end;

procedure TfmProp.pbxPprvPaint(Sender: TObject);
var
  PrvRect: TRect;
begin

  with pbxPprv.Canvas do
    begin

    Brush.Style:= bsSolid;
    Pen.Style:= psClear;

    case cbxPbgn.ItemIndex of

      (* White *)
      1: begin
           Brush.Color:= clWhite;
           FillRect(pbxPprv.ClientRect);
         end;

      (* Black *)
      2: begin
           Brush.Color:= clBlack;
           FillRect(pbxPprv.ClientRect);
         end;

      (* Silver *)
      3: begin
           Brush.Color:= clSilver;
           FillRect(pbxPprv.ClientRect);
         end;

      (* Gray *)
      4: begin
           Brush.Color:= clGray;
           FillRect(pbxPprv.ClientRect);
         end;

    else

      TransparentBase(pbxPprv.Canvas, pbxPprv.ClientRect);

    end;

    if frmMain.SearchStream('IMAGES/' + LastNode^.Obj.AsString) <> nil then
      begin
      PrvRect.Right:= PreviewPic.Width;
      PrvRect.Bottom:= PreviewPic.Height;
      if (PrvRect.Right <= pbxPprv.ClientWidth) and (PrvRect.Bottom <= pbxPprv.ClientHeight) then
        Draw((pbxPprv.ClientWidth - PrvRect.Right) div 2,
             (pbxPprv.ClientHeight - PrvRect.Bottom) div 2,
             PreviewPic)
      else
        begin
        PrvRect:= AspectRatio(PrvRect.Right, PrvRect.Bottom, pbxPprv.ClientWidth, pbxPprv.ClientHeight);
        //StretchDraw(PrvRect, PreviewPic);
        Lock;
        try
          DrawAntiAliased(PreviewPic, pbxPprv.Canvas, PrvRect);
        finally
          Unlock;
        end;
      end;
    end;

  end;

end;

procedure TfmProp.ResetUndo;
var
  lp: Integer;
begin

  if UndoList.Count > 0 then
    for lp:= 0 to UndoList.Count - 1 do
      FreeUndoSnapshot(lp);
  UndoList.List:= nil;
  UndoList.Count:= 0;
  UndoList.Index:= 0;

end;

function TfmProp.SaveJsonTree: boolean;

  function Spc(Len: integer): string;
  var
    lp: integer;
  begin
    Result:= '';
    for lp:= 1 to Len do
      Result:= Result + ' ';
  end;

var
  jsondt: TStringList;
  skrang: TDateTime;
  iDay, iMonth, iYear: Word;
  hdr: string;
begin

  skrang:= Now;
  jsondt:= TStringList.Create;
  try
    jsondt.Clear;
    hdr:= Format(GenHdrBy, [GetAppVer]);
    jsondt.Add(HdrJsonComment(hdr));
    DecodeDate(skrang, iYear, iMonth, iDay);
    hdr:= Format(GenHdrTm, [LongDayNames[DayOfWeek(skrang)], iDay,
                            LongMonthNames[iMonth], iYear,
                            FormatDateTime('hh:mm:ss', now)]);
    jsondt.Add(HdrJsonComment(hdr));
    jsondt.Add('');
    try
      SaveTreeToJson(jsondt, vsProp);
    finally
      PropStream.Position:= 0;
      PropStream.Size:= 0;
      jsondt.SaveToStream(PropStream);
      Result:= TRUE;
    end;
  finally
    jsondt.Free;
  end;

end;

procedure TfmProp.scrClalpChange(Sender: TObject);
begin

  AlphaVal:= scrClalp.Position;
  SetColorVal;
  lblClalp.Caption:= Format('Alpha value: 0x%s', [IntToHex(AlphaVal, 2)]);

end;

procedure TfmProp.SetColorVal;
var
  cstr: string;
begin

  cstr:= IntToHex(ColorProp, 6);
  if IsAlphaColor then
    cstr:= IntToHex(AlphaVal, 2) + cstr;
  cstr:= '"#'+LowerCase(cstr)+'"';
  SetValue(cstr);
  pbClr.Invalidate;

end;

procedure TfmProp.SetEditMode(const Node: PJsonNode; const Idx: integer);
var
  eval: string;
  pngs: TMemoryStream;
  //pngi: Integer;
  eedit: boolean;
begin

  (* TabIndex harus diset -1 agar tidak terjadi bug "index out of bounds" *)
  pgcEdit.TabIndex:= -1;
  tbBool.TabVisible := FALSE;
  tbPadd.TabVisible := FALSE;
  tbBool.TabVisible := Idx = 3;
  tbColor.TabVisible:= Idx = 4;
  tbImage.TabVisible:= Idx = 5;
  //tbPadd.TabVisible := Idx = 6;

  case Idx of

    (* Boolean *) // Never used so dropped it :)
    3: begin
         cbxPBool.ItemIndex:= Integer(UpperCase(Node^.Obj.AsString) = 'TRUE');
         pgcEdit.Show;
         pgcEdit.ActivePage:= tbBool;
       end;

    (* Color edit *)
    4: begin
         try
           eval:= Node^.Obj.AsString;
           Assert(eval <> '');
           Assert(eval[1] = '#');
           eval:= Copy(eval, 2, Length(eval) - 1);
           IsAlphaColor:= Length(eval) > 6;
           if IsAlphaColor then
             AlphaVal:= StrToInt('$'+Copy(eval, 1, Length(eval)-6))
           else
             AlphaVal:= $FF;
           ColorProp:= StrToInt('$'+Copy(eval, Length(eval)-5, 6));
           edtClr.Text:= IntToHex(ColorProp, 6);
           cbxAlp.Checked:= IsAlphaColor;
           scrClalp.Position:= AlphaVal;
           scrClalp.Enabled:= IsAlphaColor;
           SetColorVal;
           pgcEdit.Show;
           pgcEdit.ActivePage:= tbColor;
         except
           MessageDlg('Value is not color type!', mtError, [mbOK], 0);
         end;
       end;
    (* Image edit *)
    5: begin
         try
           pngs:= frmMain.SearchStream('IMAGES/' + Node^.Obj.AsString);
         except
           pngs:= nil;
           MessageDlg(Format('Cannot load "%s" because is missing from resource list!', [Node^.Obj.AsString]), mtError, [mbOK], 0);
         end;
         if pngs <> nil then
           begin
           pngs.Position:= 0;
           with PreviewPic do
             begin
             LoadFromStream(pngs);
             lblPdim.Caption:= Format('Dimension: %dx%d px', [Width, Height]);
             pbxPprv.Invalidate;
           end;
         end;
         pgcEdit.Show;
         pgcEdit.ActivePage:= tbImage;
       end;

  else
    pgcEdit.Hide;
  end;

  eedit:= Idx >= 0;
  edtVal.Enabled := eedit;
  actCommit.Enabled:= eedit;
  cbxType.Enabled:= eedit;

  cbxType.ItemIndex:= Idx;

end;

procedure TfmProp.SetUndoSnapshot;
var
  lp, maxt: Integer;
  TraceNode: PVirtualNode;
  jdata: PJsonNode;
begin

  (* Mencegah blunder, redo dihapuskan jika setelah di undo ada perubahan *)
  if UndoList.Index < UndoList.Count-1 then
    begin
    maxt:= UndoList.Count-1;
    for lp:= UndoList.Index+1 to maxt do
      begin
      FreeUndoSnapshot(lp);
      Dec(UndoList.Count);
    end;
  end;
  SetLength(UndoList.List, UndoList.Count+1);
  with UndoList.List[UndoList.Count] do
    begin
    NodeCount:= 0;
    TraceNode:= vsProp.GetFirstNoInit();
    repeat
      jdata:= vsProp.GetNodeData(TraceNode);
      SetLength(NodeData, NodeCount+1);
      NodeData[NodeCount].Index:= jdata^.Index;
      NodeData[NodeCount].Name:= jdata^.Name;
      NodeData[NodeCount].Kind:= jdata^.Kind;
      (* Harus dikloning karena node data selalu dibebaskan oleh vsProp *)
      NodeData[NodeCount].Obj:= jdata^.Obj.Clone;
      Inc(NodeCount);
      TraceNode:= vsProp.GetNextNoInit(TraceNode);
    until TraceNode = nil;
    TreeStruct:= TMemoryStream.Create;
    TreeStruct.Position:= 0;
    vsProp.SaveToStream(TreeStruct);
  end;
  Inc(UndoList.Count);
  Inc(UndoList.Index);

end;

procedure TfmProp.SetValue(const Val: string);
begin

  edtVal.Text:= Val;

end;

procedure TfmProp.UpdateToolbars;
begin

  actUndo.Enabled:= (UndoList.Count > 0) and (UndoList.Index > 0);
  actRedo.Enabled:= (UndoList.Count > 0) and (UndoList.Index < UndoList.Count-1);
  actDelProp.Enabled:= (SelNode <> nil) and (SelNode <> MainNode);

end;

procedure TfmProp.vsPropChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  data: PJsonNode;
begin

  SelNode:= Node;
  UpdateToolbars;
  data:= vsProp.GetNodeData(Node);
  if data <> nil then
    ChangeEditItem(data);

end;

procedure TfmProp.vsPropCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  d1, d2, parent: PJsonNode;
begin

  case Column of
    0: begin
         d1:= vsProp.GetNodeData(Node1);
         parent := vsProp.GetNodeData(node1.Parent);
         if (parent <> nil) and ObjectIsType(parent.obj, stArray) then
           Result := node1.Index - node2.Index
         else
           begin
           d2:= vsProp.GetNodeData(Node2);
           Result:= CompareText(d1.name, d2.name);
         end;
       end;
  end;

end;

procedure TfmProp.vsPropFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  p: PJsonNode;
begin

  p:= PJsonNode(vsProp.GetNodeData(Node));
  p^.name:= '';
  p^.obj:= nil;

end;

procedure TfmProp.vsPropGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  data: PJsonNode;
begin

  data:= vsProp.GetNodeData(Node);

  case Column of

    0: begin
         if data^.Kind = vlMainRoot then
           begin
           ImageIndex:= 0;
         end
         else
           begin
           if Node.ChildCount > 0 then
             begin
             if Sender.Expanded[Node] then
               ImageIndex:= 2
             else
               ImageIndex:= 1;
           end
           else
             begin
             case data^.Kind of
               vlColor : ImageIndex:= 4;
               vlImage : ImageIndex:= 5;
               vlString: ImageIndex:= 6;
               vlInteger, vlFloat: ImageIndex:= 7;
             else
               ImageIndex:= 3;
             end;
           end;
         end;
       end;

  end;

end;

procedure TfmProp.vsPropGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin

  NodeDataSize:= SizeOf(TJsonNode);

end;

procedure TfmProp.vsPropGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  data: PJsonNode;
begin

  data:= vsProp.GetNodeData(Node);
  case Column of
    0: CellText:= data.Name;
    1: case ObjectGetType(data.Obj) of
         stObject: CellText:= '';
         stArray: CellText:= '';
         stNull: CellText:= 'null';
       else
         CellText:= data.obj.AsString;
       end;
  end;

end;

procedure TfmProp.vsPropResize(Sender: TObject);
var
  clw: integer;
begin

  if vsProp.ClientWidth >= 560 then
    clw:= vsProp.ClientWidth - 260
  else
    clw:= 300;
  vsProp.Header.Columns[0].Width:= clw;
  vsProp.Header.Columns[1].Width:= 260;

end;

end.
