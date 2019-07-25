unit ViewFields;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, Winapi.Windows, Winapi.Messages, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Data.DB, Vcl.DBGrids,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, shlObj,
  Arrays, MyUtils, MyDialogs, Configs, DAO;

type
  TWindowFields = class(TForm)
    LblTitle1: TLabel;
    GridFields: TStringGrid;
    LblTable: TLabel;
    LblTitle2: TLabel;
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
    BtnOrdFields: TSpeedButton;
    BtnClearFields: TSpeedButton;
    ActCleanFields: TAction;
    BtnTruncFB: TSpeedButton;
    ActTruncFB: TAction;
    BtnConfigTable: TSpeedButton;
    ActConfigTable: TAction;
    procedure FormActivate(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActOrdFieldsExecute(Sender: TObject);
    procedure ActCleanFieldsExecute(Sender: TObject);
    procedure ActTruncFBExecute(Sender: TObject);
    procedure ActConfigTableExecute(Sender: TObject);

  private
    procedure GridTitles;
    procedure CleanGrid;
    procedure FillGrid;

  public
    function GetOrder: TIntegerArray;
    function GetDefauts: TStringArray;
    function IsClean: boolean;

  end;

var
  WindowFields: TWindowFields;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowFields.FormActivate(Sender: TObject);
begin
  GridFields.ColWidths[1] := 100;
  GridFields.ColWidths[2] := 50;
  GridFields.ColWidths[3] := 100;
  GridFields.ColWidths[4] := 100;
  GridTitles;
  FillGrid;
end;

//Exporta as configura��es em um .txt
procedure TWindowFields.ActExportExecute(Sender: TObject);
var
  Arq: TextFile;
  Cont: integer;
begin
  SaveFile.FileName := 'Campos' + TConfigs.GetConfig('DB', 'Table');
  if SaveFile.Execute then
  begin
    AssignFile(Arq, SaveFile.FileName);
    Rewrite(Arq);
    for Cont := 1 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[3, Cont]);
    end;
    Writeln(Arq, '{$DEFAULTS$}');
    for Cont := 1 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[4, Cont]);
    end;
    CloseFile(Arq);
  end;
end;

//Importa configura��es de um .txt
procedure TWindowFields.ActImportExecute(Sender: TObject);
var
  Arq: TStringList;
  Rows: TStringList;
  Cont: integer;
begin
  Arq := TStringList.Create;
  Rows := TStringList.Create;
  try
    if OpenFile.Execute then
    begin
      Arq.LoadFromFile(OpenFile.FileName);

      Rows := TUtils.Extract(Arq, 0, '{$DEFAULTS$}');
      GridFields.Cols[3].Clear;
      GridFields.Cells[3, 0] := 'N� Campo Dataflex';
      for  Cont := 0 to TUtils.IfLess(Rows.Count, GridFields.RowCount - 1) - 1 do
      begin
        GridFields.Cells[3, Cont + 1] := Rows[Cont];
      end;

      Rows := TUtils.Extract(Arq, '{$DEFAULTS$}', Arq.Count - 1);
      GridFields.Cols[4].Clear;
      GridFields.Cells[4, 0] := 'Valor Padr�o';
      for  Cont := 0 to TUtils.IfLess(Rows.Count, GridFields.RowCount - 1) - 1 do
      begin
        GridFields.Cells[4, Cont + 1] := Rows[Cont];
      end;
    end;
  finally
    FreeAndNil(Rows);
  end;
end;

//Odena os campos data flex por ordem crescente
procedure TWindowFields.ActOrdFieldsExecute(Sender: TObject);
var
  Cont: integer;
begin
  for Cont := 1 to GridFields.RowCount do
  begin
    GridFields.Cells[3, Cont] := IntToStr(Cont);
  end;
end;

//Limpa os campos dataflex e os defaults definidos
procedure TWindowFields.ActCleanFieldsExecute(Sender: TObject);
begin
  GridFields.Cols[3].Clear;
  GridFields.Cols[4].Clear;
  GridTitles;
end;

//Define a tabela que ser� usada
procedure TWindowFields.ActConfigTableExecute(Sender: TObject);
var
  Table: string;
begin
  Table := InputBox('Configurar Tabela', 'Insira o nome da tabela', TConfigs.GetConfig('DB', 'Table')).Trim;
  TConfigs.SetConfig('DB', 'Table', Table);
  FillGrid;
  if TDAO.Count <= 0 then
  begin
    ShowMessage('Selecione uma tabela v�lida!');
  end;
end;

//Apaga todos os dados da tabela Firebird
procedure TWindowFields.ActTruncFBExecute(Sender: TObject);
var
  Answer: integer;
begin
  Answer :=  TDialogs.YesNo('Deseja apagar todos os dados da tabela ' + TConfigs.GetConfig('DB', 'Table') + '?');
  if Answer = mrYes then
  begin
    TDAO.Truncate;
    TDAO.Commit;
  end;
end;

//Coloca os titulos na Grid
procedure TWindowFields.GridTitles;
begin
  GridFields.Cells[0, 0] := 'Campo Firebird';
  GridFields.Cells[1, 0] := 'Tipo Do Campo';
  GridFields.Cells[2, 0] := 'Not Nulls';
  GridFields.Cells[3, 0] := 'N� Campo Dataflex';
  GridFields.Cells[4, 0] := 'Valor Padr�o';
end;

//Insere os dados na tabela
procedure TWindowFields.FillGrid;
var
  Cont: integer;
  Fields, Types: TStringArray;
  NotNulls: TIntegerArray;
begin
  try
    try
      if TDAO.Count <> 0 then
      begin
        LblTable.Caption := TConfigs.GetConfig('DB', 'Table');
        SetLength(Fields, TDAO.Count);
        Fields := TDAO.GetFieldsNames;
        SetLength(Types, TDAO.Count);
        Types := TDAO.GetFieldsTypes;
        SetLength(NotNulls, TDAO.Count);
        NotNulls := TDAO.GetFieldsNotNulls;
        GridFields.RowCount := TDAO.Count + 1;
        for Cont := 0 to GridFields.RowCount - 2 do
        begin
          GridFields.Cells[0, Cont + 1] := Fields[Cont];
          GridFields.Cells[1, Cont + 1] := Types[Cont];
          GridFields.Cells[2, Cont + 1] := TUtils.Iff(NotNulls[Cont] = 1, 'Not Null', '');
        end;
      end
      else
      begin
        CleanGrid;
      end;
    Except
      CleanGrid;
    end;
  finally
    LblTotFields.Caption := 'Total Campos Firebird: ' + TDAO.Count.ToString;
  end;
end;

//Limpas todos os campos da tabela
procedure TWindowFields.CleanGrid;
begin
  GridFields.RowCount := 2;
  GridFields.Rows[1].Clear;
end;

//Retorna a ordem de campos dataflex definida na Grid
function TWindowFields.GetOrder: TIntegerArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to GridFields.RowCount - 2 do
  begin
    if (GridFields.Cells[3, Cont + 1].IsEmpty) or (StrToInt(GridFields.Cells[3, Cont + 1]) <= 0) then
    begin
      Result[Cont] := -1;
    end
    else
    begin
      Result[Cont] := GridFields.Cells[3, Cont + 1].ToInteger;
    end;
  end;
end;

//Retorna os defaults definidos na Grid
function TWindowFields.GetDefauts: TStringArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to GridFields.RowCount - 2 do
  begin
    if GridFields.Cells[4, Cont + 1].IsEmpty then
    begin
      Result[Cont] := '';
    end
    else
    begin
      Result[Cont] := GridFields.Cells[4, Cont + 1];
    end;
  end;
end;

//Verifica se os campos dataflex e os defaults est�o vazios
function TWindowFields.IsClean: boolean;
var
  Cont: integer;
  Clean: boolean;
begin
  Clean := true;
  for Cont := 1 to GridFields.RowCount - 1 do
  begin
    Clean := Clean and GridFields.Cells[3, Cont].IsEmpty;
  end;
  for Cont := 1 to GridFields.RowCount - 1 do
  begin
    Clean := Clean and GridFields.Cells[4, Cont].IsEmpty;
  end;
  Result := Clean;
end;

end.
