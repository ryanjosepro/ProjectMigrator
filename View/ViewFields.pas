unit ViewFields;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, DAO, Data.DB, Vcl.DBGrids,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, MyUtils;

type
  TWindowFields = class(TForm)
    Title1: TLabel;
    GridFields: TStringGrid;
    LblCamposFB: TLabel;
    LblNCampos: TLabel;
    Title2: TLabel;
    LblTotFields: TLabel;
    Actions: TActionList;
    Images: TImageList;
    BtnExport: TSpeedButton;
    ActExport: TAction;
    BtnImport: TSpeedButton;
    ActImport: TAction;
    SaveFile: TFileSaveDialog;
    OpenFile: TFileOpenDialog;
    ActOrdFields: TAction;
    SpeedButton1: TSpeedButton;
    BtnClearFields: TSpeedButton;
    ActClearFields: TAction;
    procedure FormActivate(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActOrdFieldsExecute(Sender: TObject);
    procedure ActClearFieldsExecute(Sender: TObject);

  public
    function GetOrder: TIntegerArray;

  end;

var
  WindowFields: TWindowFields;

implementation

{$R *.dfm}

procedure TWindowFields.ActClearFieldsExecute(Sender: TObject);
begin
  GridFields.Cols[1].Clear;
end;

procedure TWindowFields.ActExportExecute(Sender: TObject);
var
  Arq: TextFile;
  Cont: integer;
begin
  if SaveFile.Execute then
  begin
    AssignFile(Arq, SaveFile.FileName);
    Rewrite(Arq);
    for Cont := 0 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[1, Cont]);
    end;
    CloseFile(Arq);
  end;
end;

procedure TWindowFields.ActImportExecute(Sender: TObject);
var
  Rows: TStringList;
  Cont: integer;
begin
  Rows := TStringList.Create;
  try
    if OpenFile.Execute then
    begin
      Rows.LoadFromFile(OpenFile.FileName);
      GridFields.Cols[1].Clear;
      for Cont := 0 to TUtils.Iff(Rows.Count > GridFields.RowCount, GridFields.RowCount, Rows.Count) - 1 do
      begin
        GridFields.Cells[1, Cont] := Rows[Cont];
      end;
    end;
  finally
    FreeAndNil(Rows);
  end;
end;

procedure TWindowFields.ActOrdFieldsExecute(Sender: TObject);
var
  Cont: integer;
begin
  for Cont := 0 to GridFields.RowCount - 1 do
  begin
    GridFields.Cells[1, Cont] := IntToStr(Cont + 1);
  end;
end;

procedure TWindowFields.FormActivate(Sender: TObject);
var
  Cont: integer;
  Campos: TStringArray;
begin
  try
    GridFields.ColWidths[1] := 88;
    if TDAO.Count <> 0 then
    begin
      LblCamposFB.Caption := 'Campos Firebird - ' + TDAO.Table;
      SetLength(Campos, TDAO.Count);
      Campos := TDAO.GetFieldsNames;
      GridFields.RowCount := TDAO.Count;
      for Cont := 0 to TDAO.Count - 1 do
      begin
        GridFields.Cells[0, Cont] := (Campos[Cont]);
      end;
    end
    else
    begin
      ShowMessage('Selecione uma tabela!');
    end;
  finally
    LblTotFields.Caption := 'Total Campos Firebird: ' + TDAO.Count.ToString;
  end;
end;

function TWindowFields.GetOrder: TIntegerArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to TDAO.Count - 1 do
    begin
      if GridFields.Cells[1, Cont].IsEmpty then
      begin
        Result[Cont] := -1;
      end
      else
      begin
        Result[Cont] := GridFields.Cells[1, Cont].ToInteger;
      end;
    end;
end;

end.
