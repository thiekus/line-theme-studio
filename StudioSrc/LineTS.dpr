program LineTS;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Program EntryPoint                                           *)
(*                                                                            *)
(*============================================================================*)

uses
  FastMM4,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uResc in 'uResc.pas' {fmResc},
  uProp in 'uProp.pas' {fmProp},
  JsonUtils in 'JsonUtils.pas',
  uEdit in 'uEdit.pas' {fmEdit},
  dlgSearchText in 'SynEditDlg\dlgSearchText.pas',
  dlgReplaceText in 'SynEditDlg\dlgReplaceText.pas',
  dlgConfirmReplace in 'SynEditDlg\dlgConfirmReplace.pas',
  CustomUtils in 'CustomUtils.pas',
  uAbout in 'uAbout.pas' {frmAbout},
  uAdbPush in 'uAdbPush.pas' {frmAdbp},
  AdbExec in '..\AdbExec\AdbExec.pas',
  uSendOpt in 'uSendOpt.pas' {frmAdbSend},
  uFindProp in 'uFindProp.pas' {frmFindProp},
  uConn in 'uConn.pas' {frmConn},
  uPicView in 'uPicView.pas' {frmPrev},
  uWelcome in 'uWelcome.pas' {frmWelcome},
  uFinfo in 'uFinfo.pas' {frmFinfo},
  LtsType in 'LtsType.pas',
  uCfg in 'uCfg.pas' {frmCfg},
  ResGraphic in 'ResGraphic.pas',
  uEditApp in 'uEditApp.pas' {frmEditApp},
  uManedit in 'uManedit.pas' {fmManed},
  uMedsos in 'uMedsos.pas' {frmMedsos},
  uThemeOpenDlg in 'uThemeOpenDlg.pas' {dlgOpenTheme},
  uPicOpenDlg in 'uPicOpenDlg.pas' {dlgOpenPict};

{$R *.res}
{$R '../icons/MainLogo.RES'}
{$R '../icons/EmbedSkin.RES'}
{$R XP-THEME.RES}

begin

  Application.Initialize;
  Application.Title := 'Line Theme Studio';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfmProp, fmProp);
  Application.CreateForm(TfmEdit, fmEdit);
  Application.CreateForm(TfmResc, fmResc);
  Application.CreateForm(TfrmFindProp, frmFindProp);
  Application.CreateForm(TfrmConn, frmConn);
  Application.CreateForm(TfrmWelcome, frmWelcome);
  Application.CreateForm(TfrmCfg, frmCfg);
  Application.CreateForm(TfrmEditApp, frmEditApp);
  Application.CreateForm(TfmManed, fmManed);
  Application.CreateForm(TfrmMedsos, frmMedsos);
  Application.Run;

end.
