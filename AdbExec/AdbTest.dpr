program AdbTest;

uses
  Forms,
  uAdbTest in 'uAdbTest.pas' {frmTest},
  AdbExec in 'AdbExec.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
