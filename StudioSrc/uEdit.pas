unit uEdit;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Raw text editor                                              *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TB97Ctls, TB97, TB97Tlbr, SynEditHighlighter, SynHighlighterJScript,
  SynEdit, PngImage, ImgList, ActnList, CustomUtils, Menus, SynEditMiscClasses,
  SynEditRegexSearch, SynEditSearch;

type
  TfmEdit = class(TForm)
    dckEdit: TDock97;
    tbEdit: TToolbar97;
    ToolbarButton971: TToolbarButton97;
    edtEdit: TSynEdit;
    jsHighlt: TSynJScriptSyn;
    imgEtlb: TImageList;
    ToolbarButton972: TToolbarButton97;
    ToolbarButton973: TToolbarButton97;
    ToolbarSep971: TToolbarSep97;
    ToolbarButton974: TToolbarButton97;
    ToolbarButton975: TToolbarButton97;
    ToolbarSep972: TToolbarSep97;
    ToolbarButton976: TToolbarButton97;
    ToolbarButton977: TToolbarButton97;
    ToolbarButton978: TToolbarButton97;
    ToolbarSep973: TToolbarSep97;
    ToolbarButton979: TToolbarButton97;
    ToolbarButton9710: TToolbarButton97;
    ToolbarButton9711: TToolbarButton97;
    ToolbarButton9712: TToolbarButton97;
    actEdt: TActionList;
    actImp: TAction;
    eodlg: TOpenDialog;
    esdlg: TSaveDialog;
    actExp: TAction;
    actSave: TAction;
    actUndo: TAction;
    actRedo: TAction;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    pMenu: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    SynEditRegexSearch: TSynEditRegexSearch;
    SynEditSearch: TSynEditSearch;
    actFind: TAction;
    actFindPrev: TAction;
    actFindNext: TAction;
    actRepl: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actImpExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actExpExecute(Sender: TObject);
    procedure edtEditChange(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindPrevExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actReplExecute(Sender: TObject);
  private
    { Private declarations }

    PropStream: TStream;

    (* SynEdit vars *)
    fSearchFromCaret: boolean;

    gbSearchBackwards: boolean;
    gbSearchCaseSensitive: boolean;
    gbSearchFromCaret: boolean;
    gbSearchSelectionOnly: boolean;
    gbSearchTextAtCaret: boolean;
    gbSearchWholeWords: boolean;
    gbSearchRegex: boolean;

    gsSearchText: string;
    gsSearchTextHistory: string;
    gsReplaceText: string;
    gsReplaceTextHistory: string;

    procedure CheckUndo;

    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure ShowSearchReplaceDialog(AReplace: boolean);

  public
    { Public declarations }

    EditorChange: Boolean;

    procedure EditorLoad(Stream: TStream);
    function  EditorCloseWarn: boolean;

  end;

var
  fmEdit: TfmEdit;

implementation

uses uMain,
     dlgSearchText, dlgReplaceText, dlgConfirmReplace,
     SynEditTypes, SynEditMiscProcs;

{$R *.dfm}
{$R '../icons/TxdtGlyph.RES'}
const EditTlbGlyphCount = 12;

resourcestring
  STextNotFound = 'Text not found';
  SNoSelectionAvailable = 'The is no selection available, search whole text?';

{ TfmEdit }

procedure TfmEdit.actCopyExecute(Sender: TObject);
begin

  edtEdit.CopyToClipboard;

end;

procedure TfmEdit.actCutExecute(Sender: TObject);
begin

  edtEdit.CutToClipboard;
  EditorChange:= TRUE;

end;

procedure TfmEdit.actExpExecute(Sender: TObject);
begin

  if esdlg.Execute then
    edtEdit.Lines.SaveToFile(esdlg.FileName);

end;

procedure TfmEdit.actFindExecute(Sender: TObject);
begin

  ShowSearchReplaceDialog(FALSE);

end;

procedure TfmEdit.actFindNextExecute(Sender: TObject);
begin

  DoSearchReplaceText(FALSE, FALSE);

end;

procedure TfmEdit.actFindPrevExecute(Sender: TObject);
begin

  DoSearchReplaceText(FALSE, TRUE);

end;

procedure TfmEdit.actImpExecute(Sender: TObject);
begin

  if eodlg.Execute then
    begin
    edtEdit.Lines.LoadFromFile(eodlg.FileName);
    edtEdit.ClearUndo;
  end;

end;

procedure TfmEdit.actPasteExecute(Sender: TObject);
begin

  edtEdit.PasteFromClipboard;
  EditorChange:= TRUE;

end;

procedure TfmEdit.actRedoExecute(Sender: TObject);
begin

  edtEdit.Redo;
  EditorChange:= TRUE;

end;

procedure TfmEdit.actReplExecute(Sender: TObject);
begin

  ShowSearchReplaceDialog(TRUE);

end;

procedure TfmEdit.actSaveExecute(Sender: TObject);
begin

  PropStream.Position:= 0;
  edtEdit.Lines.SaveToStream(PropStream);
  frmMain.SetChanged();

end;

procedure TfmEdit.actUndoExecute(Sender: TObject);
begin

  edtEdit.Undo;
  EditorChange:= TRUE;

end;

procedure TfmEdit.CheckUndo;
begin

  actUndo.Enabled:= edtEdit.UndoList.CanUndo;
  actRedo.Enabled:= edtEdit.RedoList.CanUndo;

end;

procedure TfmEdit.DoSearchReplaceText(AReplace, ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin

  (* From SynEdit sample *)
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
  begin
    if (not edtEdit.SelAvail) or SameText(edtEdit.SelText, gsSearchText) then
    begin
      if MessageDlg(SNoSelectionAvailable, mtWarning, [mbYes, mbNo], 0) = mrYes then
        gbSearchSelectionOnly := False
      else
        System.Exit;
    end
    else
      Include(Options, ssoSelectedOnly);
  end;
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if gbSearchRegex then
    edtEdit.SearchEngine := SynEditRegexSearch
  else
    edtEdit.SearchEngine := SynEditSearch;
  if edtEdit.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    ShowMessage(STextNotFound);
    if ssoBackwards in Options then
      edtEdit.BlockEnd := edtEdit.BlockBegin
    else
      edtEdit.BlockBegin := edtEdit.BlockEnd;
    edtEdit.CaretXY := edtEdit.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;

end;

function TfmEdit.EditorCloseWarn: boolean;
begin

  Result:= TRUE;
  if edtEdit.UndoList.CanUndo then
    case MessageDlg('Apakah anda ingin menyimpan perubahan dalam editor teks ini?', mtInformation, mbYesNoCancel, 0) of
      mrYes: begin
               EditorChange:= FALSE;
               actSave.Execute;
               Result:= TRUE;
             end;
      mrNo: begin
              EditorLoad(PropStream);
              Result:= TRUE;
            end;
    else
      Result:= FALSE;
    end;

end;

procedure TfmEdit.EditorLoad(Stream: TStream);
begin

  EditorChange:= FALSE;
  Stream.Position:= 0;
  edtEdit.Lines.LoadFromStream(Stream);
  edtEdit.ClearUndo;
  CheckUndo;
  PropStream:= Stream;

end;

procedure TfmEdit.edtEditChange(Sender: TObject);
begin

  CheckUndo;
  EditorChange:= TRUE;

end;

procedure TfmEdit.FormCreate(Sender: TObject);
var
  zfra: integer;
  tlbg: TBitmap;
begin

  imgEtlb.Clear;
  for zfra:= 0 to EditTlbGlyphCount - 1 do
    AddPngGlyph(imgEtlb, Format('TTLB_%.2d', [zfra]));

  tlbg:= MakeToolbarBackground(dckEdit.ClientHeight);
  try
    dckEdit.Background.Assign(tlbg);
  finally
    tlbg.Free;
  end;

end;

procedure TfmEdit.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin

  (* From SynEdit Example *)
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if edtEdit.SelAvail and (edtEdit.BlockBegin.Line = edtEdit.BlockEnd.Line)
      then
        SearchText := edtEdit.SelText
      else
        SearchText := edtEdit.GetWordAtRowCol(edtEdit.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
      ReplaceText := gsReplaceText;
      ReplaceTextHistory := gsReplaceTextHistory;
    end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchWholeWords := SearchWholeWords;
      gbSearchRegex := SearchRegularExpression;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
        gsReplaceText := ReplaceText;
        gsReplaceTextHistory := ReplaceTextHistory;
      end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;

end;

end.
