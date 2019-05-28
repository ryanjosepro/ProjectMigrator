unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.ExtDlgs, ViewDB, MyUtils;

type
  TWindowMain = class(TForm)
    Title1: TLabel;
    Title2: TLabel;
    Title3: TLabel;
    TxtLog: TMemo;
    BtnStart: TSpeedButton;
    OpenFile: TOpenTextFileDialog;
    BtnOpenFile: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActOpenFile: TAction;
    BtnDatabase: TSpeedButton;
    ActConfigDB: TAction;
    BtnFields: TSpeedButton;
    ActConfigs: TAction;
    procedure Log(Msg: string);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigDBExecute(Sender: TObject);
    procedure ActConfigsExecute(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WindowMain: TWindowMain;
  Cont:

implementation

{$R *.dfm}

uses ViewFields;

procedure TWindowMain.ActOpenFileExecute(Sender: TObject);
begin
  OpenFile.Execute(Handle);
end;

procedure TWindowMain.BtnStartClick(Sender: TObject);
var
  ContRow: integer;
  ContCol: integer;
  StrList: TStringList;
  DataFlex: TDataFlex;
  Dados: TStringMatrix;
  Together: string;
begin
  StrList := TStringList.Create;
  StrList.LoadFromFile(OpenFile.FileName);
  DataFlex := TDataFlex.Create(StrList);
  SetLength(Dados, DataFlex.GetRows, DataFlex.GetCols);
  Dados := DataFlex.ToMatrix;
  for ContRow := 0 to 1 do
  begin
    for ContCol := 0 to DataFlex.GetCols - 1 do
    begin
      Together := Together + Dados[ContRow][ContCol] + ' - ';
    end;
    Log(Together);
  end;
end;

procedure TWindowMain.ActConfigDBExecute(Sender: TObject);
begin
  WindowDB.ShowModal;
end;

procedure TWindowMain.ActConfigsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

procedure TWindowMain.Log(Msg: string);
begin
  TxtLog.Lines.Add(Msg);
end;

end.
