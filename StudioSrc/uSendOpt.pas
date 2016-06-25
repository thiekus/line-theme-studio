unit uSendOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, VirtualTrees, AdbExec, IniFiles;

type
  TThemeNode = record
    Name: string;
    Guid: TGUID;
  end;

type
  TfrmAdbSend = class(TForm)
    Label1: TLabel;
    vsDevs: TVirtualStringTree;
    btnRefs: TBitBtn;
    Label2: TLabel;
    lsThm: TListBox;
    Bevel1: TBevel;
    btnOk: TBitBtn;
    BitBtn2: TBitBtn;
    cbxSdc: TComboBox;
    btnConn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefsClick(Sender: TObject);
    procedure vsDevsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vsDevsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure cbxSdcChange(Sender: TObject);
    procedure lsThmClick(Sender: TObject);
    procedure vsDevsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btnConnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    Devs: PAdxDevices;
    CurPath: string;
    SelSerial: string;
    SelThPath: string;
    Ts: TStringList;
    LineAppName: string;

    procedure LoadThemeList;

  public
    { Public declarations }

    procedure RefreshDeviceList;
    procedure RefreshThemeList;

    function  GetTargetDevice(var Device, Path: string): boolean;

  end;

var
  frmAdbSend: TfrmAdbSend;

implementation

uses uConn;

{$R *.dfm}

{ TfrmAdbSend }

procedure TfrmAdbSend.btnConnClick(Sender: TObject);
begin
  if frmConn.ShowModal = mrOk then
    RefreshDeviceList;
end;

procedure TfrmAdbSend.btnRefsClick(Sender: TObject);
begin
  RefreshDeviceList;
end;

procedure TfrmAdbSend.cbxSdcChange(Sender: TObject);
begin
  RefreshThemeList;
end;

procedure TfrmAdbSend.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Devs <> nil then
    Adx_FreeAttachedDevicesList(Devs);
end;

procedure TfrmAdbSend.FormCreate(Sender: TObject);
begin
  Devs:= nil;
  Ts:= TStringList.Create;
  LoadThemeList;
end;

procedure TfrmAdbSend.FormDestroy(Sender: TObject);
begin
  Ts.Free;
end;

procedure TfrmAdbSend.FormShow(Sender: TObject);
begin
  cbxSdc.ItemIndex:= 0;
  RefreshDeviceList;
end;

function TfrmAdbSend.GetTargetDevice(var Device, Path: string): boolean;
begin

  if Self.ShowModal = mrOk then
    begin
    Device:= SelSerial;
    Path:= SelThPath;
    Result:= TRUE;
  end
  else
    Result:= FALSE;

end;

procedure TfrmAdbSend.LoadThemeList;
var
  ini: TIniFile;
begin

  ini:= TIniFile.Create(ExtractFilePath(ParamStr(0))+'ThemeLst.ini');
  try
    LineAppName:= ini.ReadString('ThemeList', 'AppName', 'jp.naver.line.android');
  finally
    ini.Free;
  end;

end;

procedure TfrmAdbSend.lsThmClick(Sender: TObject);
var
  PathBuild, ChildFile: string;
begin
  if lsThm.ItemIndex >= 0 then
    begin
    PathBuild:= CurPath + Ts[lsThm.ItemIndex];
    if Adx_ExecuteAndWait(SelSerial, Format('shell ls "%s"', [PathBuild]), ChildFile) then
      begin
      ChildFile:= Copy(ChildFile, 1, Pos(#13, ChildFile)-1);
      if ChildFile[1] <> '/' then
        begin
        SelThPath:= Format('%s/%s', [PathBuild, ChildFile]);
        btnOk.Enabled:= TRUE;
      end
      else
        MessageDlg('Sorry, but you must have downloaded theme file for this theme from LINE before you able to override!', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmAdbSend.RefreshDeviceList;
var
  node: PVirtualNode;
  devn: PAdxDevice;
  lp: integer;
begin

  if Devs <> nil then
    Adx_FreeAttachedDevicesList(Devs);
  Devs:= Adx_GetAttachedDevices();
  vsDevs.BeginUpdate;
  try
    vsDevs.Clear;
    if Devs <> nil then
      if Devs^.Nums > 0 then
        for lp:= 0 to Devs^.Nums - 1 do
          begin
          node:= vsDevs.AddChild(nil);
          devn:= vsDevs.GetNodeData(node);
          CopyMemory(devn, @Devs^.Devs[lp], Devs^.RecSize);
        end;
  finally
    vsDevs.EndUpdate;
  end;
  lsThm.Items.Clear;

end;

procedure TfrmAdbSend.RefreshThemeList;
var
  PathBuild: string;
  lsout: string;
  zfra: integer;
begin

  btnOk.Enabled:= FALSE;
  Ts.Clear;
  lsThm.Items.Clear;
  if cbxSdc.ItemIndex < 0 then
    Exit;

  if cbxSdc.ItemIndex > 0 then
    PathBuild:= Format('/storage/sdcard%d/Android/Data/%s/theme/', [cbxSdc.ItemIndex-1, 'jp.naver.line.android'])
  else
    PathBuild:= Format('/mnt/sdcard/Android/Data/%s/theme/', ['jp.naver.line.android']);
  if Adx_ExecuteAndWait(SelSerial, Format('shell ls "%s"', [PathBuild]), lsout) then
    begin
    CurPath:= PathBuild;
    Ts.Text:= lsout;
    for zfra:= 0 to Ts.Count div 2 do
      if Ts[zfra] = '' then
        Ts.Delete(zfra);
    for zfra:= 0 to Ts.Count - 1 do
      if Ts[zfra][1] <> '/' then
        lsThm.Items.Add(Format('%s - Unknown theme', [Ts[zfra]]))
      else
        begin
        Ts.Clear;
        lsThm.Items.Clear;
        Break;
      end;
  end;

end;

procedure TfrmAdbSend.vsDevsChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PAdxDevice;
begin

  Data:= vsDevs.GetNodeData(Node);
  if Data <> nil then
    begin
    cbxSdc.Enabled:= TRUE;
    lsThm.Enabled:= TRUE;
    SelSerial:= Data^.Serial;
    cbxSdc.ItemIndex:= 0;
    RefreshThemeList;
  end
  else
    begin
    cbxSdc.Enabled:= FALSE;
    lsThm.Enabled:= FALSE;
  end;
  btnOk.Enabled:= FALSE;

end;

procedure TfrmAdbSend.vsDevsGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin

  NodeDataSize:= Devs^.RecSize;

end;

procedure TfrmAdbSend.vsDevsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PAdxDevice;
begin

  Data:= vsDevs.GetNodeData(Node);
  case Column of
    0: case Data^.DevType of
         dtDevice: CellText:= 'Device';
         dtEmulator: CellText:= 'Emulator';
         dtOffline: CellText:= 'Offline';
       else
         CellText:= 'Unknown';
       end;
    1: CellText:= Data^.Product;
    2: CellText:= Data^.Model;
    3: CellText:= Data^.Device;
    4: CellText:= Data^.Serial;
  end;

end;

end.
