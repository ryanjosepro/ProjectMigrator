unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.ExtDlgs, ViewDB, ViewFields, MyUtils, DAO;

type
  TWindowMain = class(TForm)
    Title1: TLabel;
    Title2: TLabel;
    Title3: TLabel;
    TxtLog: TMemo;
    BtnStart: TSpeedButton;
    BtnOpenFile: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActOpenFile: TAction;
    BtnDatabase: TSpeedButton;
    ActConfigDB: TAction;
    BtnFields: TSpeedButton;
    ActConfigs: TAction;
    OpenFile: TFileOpenDialog;
    BtnDFDatas: TSpeedButton;
    ActDFDatas: TAction;
    procedure Log(Msg: string);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigDBExecute(Sender: TObject);
    procedure ActConfigsExecute(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure ActOpenFileHint(var HintStr: string; var CanShow: Boolean);
    procedure ActDFDatasExecute(Sender: TObject);
  end;

var
  WindowMain: TWindowMain;

implementation

{$R *.dfm}

procedure TWindowMain.ActOpenFileExecute(Sender: TObject);
begin
  OpenFile.Execute(Handle);
end;

procedure TWindowMain.ActOpenFileHint(var HintStr: string; var CanShow: Boolean);
begin
  ActOpenFile.Hint := OpenFile.FileName;
end;

procedure TWindowMain.BtnStartClick(Sender: TObject);
var
  ContRow: integer;
  ContCol: integer;
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  OutStr: string;
begin
  if OpenFile.FileName = '' then
  begin
    OpenFile.Execute;
  end;
  Rows := TStringList.Create;
  Rows.LoadFromFile(OpenFile.FileName);
  DataFlex := TDataFlex.Create(Rows);
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;
  try
    try
      for ContRow := 0 to DataFlex.GetRows do
      begin
        TDAO.Insert(Datas[ContRow], WindowFields.GetOrder);
        OutStr := '';
        for ContCol := 0 to DataFlex.GetCols - 1 do
        begin
          try
            OutStr := OutStr + Datas[ContRow][ContCol] + ' - ';
          except on E: Exception do
            Log(E.ToString);
          end;
        end;
        Log('Inserted' + OutStr);
      end;
    except on E: EFOpenError do
      ShowMessage('Selecione um arquivo!');
    end;
  finally
    FreeAndNil(Rows);
    FreeAndNil(DataFlex);
  end;
{
  Rows := TStringList.Create;
  Rows.LoadFromFile(OpenFile.FileName);
  DataFlex := TDataFlex.Create(Rows);
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;
  try
    try
      TxtLog.Clear;
      for ContRow := 0 to 50 do
      begin
        OutStr := '';
        for ContCol := 0 to DataFlex.GetCols - 1 do
        begin
          OutStr := OutStr + Datas[ContRow][ContCol] + ' - ';
        end;
        Log(OutStr);
      end;
    except on E: EFOpenError do
      ShowMessage('Selecione um arquivo!');
    end;
  finally
    FreeAndNil(Rows);
    FreeAndNil(DataFlex);
  end;
}
end;

procedure TWindowMain.ActConfigDBExecute(Sender: TObject);
begin
  WindowDB.ShowModal;
end;

procedure TWindowMain.ActConfigsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

procedure TWindowMain.ActDFDatasExecute(Sender: TObject);
begin
  //
end;

procedure TWindowMain.Log(Msg: string);
begin
  TxtLog.Lines.Add(Msg);
end;

end.
