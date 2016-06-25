unit uAdbTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdbExec, Grids;

type
  TfrmTest = class(TForm)
    pgcMain: TPageControl;
    tbList: TTabSheet;
    Label1: TLabel;
    Button1: TButton;
    mmLst: TMemo;
    Label2: TLabel;
    edtDev: TEdit;
    tbCust: TTabSheet;
    Label3: TLabel;
    edtCust: TEdit;
    Button2: TButton;
    mmOut: TMemo;
    cbxDev: TCheckBox;
    tbShell: TTabSheet;
    Label4: TLabel;
    mmShell: TMemo;
    lblStt: TLabel;
    btnShl: TButton;
    Label6: TLabel;
    edtCmd: TEdit;
    Button4: TButton;
    tmrShl: TTimer;
    sgdev: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrShlTimer(Sender: TObject);
    procedure btnShlClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure sgdevSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }

    ShellEi: TAdxExecInfo;
    ShellThreadHandle: THandle;

  end;

var
  frmTest: TfrmTest;
  MainCs: TRtlCriticalSection;

implementation

{$R *.dfm}

function ShellListenThread(Arg: PAdxExecInfo): integer;
var
  outStr: string;
  LastIdx: integer;
  zfra: integer;
begin
  repeat
    if Adx_StillActive(Arg^) then
      begin
      outStr:= '';
      if Adx_ReadStdOut(Arg^, outStr) then
        begin
        for zfra:= 1 to Length(outStr) do
          if outStr[zfra] = #07 then
            outStr[zfra]:= '>';
        EnterCriticalSection(MainCs);
        try
          LastIdx:= frmTest.mmShell.Lines.Count-1;
          frmTest.mmShell.Lines[LastIdx]:= frmTest.mmShell.Lines[LastIdx] + outStr;
        finally
          LeaveCriticalSection(MainCs);
        end;
      end;
    end;
  until not Adx_StillActive(Arg^);

  Result:= 0;
end;

procedure TfrmTest.Button1Click(Sender: TObject);
var
  buf, obj: string;
  Devs: PAdxDevices;
  lp: integer;
begin

  Devs:= Adx_GetAttachedDevices;
  try
    sgdev.RowCount:= 2;
    if Devs^.Nums > 0 then
      begin
      sgdev.RowCount:= Devs^.Nums+1;
      for lp:= 0 to Devs^.Nums-1 do
        begin
        case Devs^.Devs[lp].DevType of
         dtDevice: obj:= 'Device';
         dtEmulator: obj:= 'Emulator';
        else
          obj:= 'Unknown';
        end;
        sgdev.Cells[0, lp+1]:= obj;
        sgdev.Cells[1, lp+1]:= Devs^.Devs[lp].Product;
        sgdev.Cells[2, lp+1]:= Devs^.Devs[lp].Model;
        sgdev.Cells[3, lp+1]:= Devs^.Devs[lp].Device;
        sgdev.Cells[4, lp+1]:= Devs^.Devs[lp].Serial;
      end;
    end
    else
      begin
      sgdev.Cells[0, 1]:= '';
      sgdev.Cells[1, 1]:= '';
      sgdev.Cells[2, 1]:= '';
      sgdev.Cells[3, 1]:= '';
      sgdev.Cells[4, 1]:= '';
    end;
  finally
    Adx_FreeAttachedDevicesList(Devs);
  end;

  mmLst.Lines.Clear;
  Adx_ExecuteAndWait('', 'devices -l', buf);
  mmLst.Lines.Add(buf);

end;

procedure TfrmTest.FormCreate(Sender: TObject);
begin

  Adx_SetAdbProgram('adb.exe');
  Adx_StartServer;
  pgcMain.ActivePage:= tbList;

  sgdev.ColCount:= 5;
  sgdev.RowCount:= 2;
  sgdev.Cells[0, 0]:= 'Object type';
  sgdev.Cells[1, 0]:= 'Product name';
  sgdev.Cells[2, 0]:= 'Model';
  sgdev.Cells[3, 0]:= 'Device type';
  sgdev.Cells[4, 0]:= 'Serial';
  sgdev.FixedRows:= 1;

end;

procedure TfrmTest.FormDestroy(Sender: TObject);
begin

  Adx_KillServer;

end;

procedure TfrmTest.Button2Click(Sender: TObject);
var
  dev, buf: string;
  rs: boolean;
begin

  if cbxDev.Checked then
    dev:= edtDev.Text
  else
    dev:= '';
  rs:= Adx_ExecuteAndWait(dev, edtCust.Text, buf);
  mmOut.Lines.Add(buf);
  if rs then
    mmOut.Lines.Add('[Executed successfully!]')
  else
    mmOut.Lines.Add('[Executed with another error codes!]');

end;

procedure TfrmTest.tmrShlTimer(Sender: TObject);
begin

  if not Adx_StillActive(ShellEi) then
    begin
    WaitForSingleObject(ShellThreadHandle, INFINITE);
    CloseHandle(ShellThreadHandle);
    mmShell.Lines.Add('');
    mmShell.Lines.Add(Format('Shell listening thread terminated with exit code 0x%s', [IntToHex(Adx_GetLastExitCode(), 8)]));
    mmShell.Lines.Add('');
    btnShl.Enabled:= TRUE;
    edtCmd.Enabled:= FALSE;
    button4.Enabled:= FALSE;
    lblStt.Caption:= 'shell not launched!';
    tmrShl.Enabled:= FALSE;
  end;

end;

procedure TfrmTest.btnShlClick(Sender: TObject);
var
  ThrId: Cardinal;
begin

  if Adx_Execute(edtDev.Text, 'shell', TRUE, ShellEi) then
    begin
    tmrShl.Enabled:= TRUE;
    lblStt.Caption:= 'shell launched!';
    btnShl.Enabled:= FALSE;
    edtCmd.Enabled:= TRUE;
    button4.Enabled:= TRUE;
    ShellThreadHandle:= BeginThread(nil, 0, @ShellListenThread, @ShellEi, 0, ThrId);
    mmShell.Lines.Add(Format('Shell listening thread created with id %s', [IntToHex(ThrId, 4)]));
    mmShell.Lines.Add('');
  end;

end;

procedure TfrmTest.Button4Click(Sender: TObject);
begin

  Adx_WriteCommand(ShellEi, edtCmd.Text);

end;

procedure TfrmTest.sgdevSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  edtDev.Text:= sgdev.Cells[4, ARow];
end;

initialization

  InitializeCriticalSection(MainCs);

finalization

  DeleteCriticalSection(MainCs);

end.
