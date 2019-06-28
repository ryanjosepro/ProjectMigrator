unit ViewDatas;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  ViewFields, Arrays, MyUtils, MyDialogs, Configs, DataFlex;

type
  TWindowDatas = class(TForm)
    LblFileName: TLabel;
    GridDatas: TStringGrid;
    LblTotRows: TLabel;
    LblTotCols: TLabel;
    BtnFields: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActConfigFields: TAction;
    BtnSelect: TSpeedButton;
    ActSelect: TAction;
    PanelSearch: TPanel;
    TxtRowsLimit: TEdit;
    LblRowsLimit: TLabel;
    ActOpenFile: TAction;
    BtnOpenFile: TSpeedButton;
    OpenFile: TFileOpenDialog;
    BtnAlter: TSpeedButton;
    ActAlter: TAction;
    ActAddCell: TAction;
    ActAddRow: TAction;
    ActAddCol: TAction;
    ActDelCell: TAction;
    ActDelRow: TAction;
    ActDelCol: TAction;
    BtnActCell: TSpeedButton;
    BtnDelCell: TSpeedButton;
    BtnAddRow: TSpeedButton;
    BtnDelRow: TSpeedButton;
    BtnAddCol: TSpeedButton;
    BtnDelCol: TSpeedButton;
    BtnCancel: TSpeedButton;
    ActCancel: TAction;
    BtnSave: TSpeedButton;
    ActSave: TAction;
    ActSaveAs: TAction;
    BtnSaveAs: TSpeedButton;
    SaveFile: TFileSaveDialog;
    TxtFileName: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActSelectExecute(Sender: TObject);
    procedure TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActAlterExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActAddCellExecute(Sender: TObject);
    procedure ActAddRowExecute(Sender: TObject);
    procedure ActAddColExecute(Sender: TObject);
    procedure ActDelCellExecute(Sender: TObject);
    procedure ActDelRowExecute(Sender: TObject);
    procedure ActDelColExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);

  private
    procedure FillGrid;
    procedure CleanGrid;
    function GridToStrList: TStringList;
    procedure DisableMode;
    procedure SelectMode;
    procedure NormalMode;
    procedure AlterMode;
    procedure UpdateGrid;
    procedure Mudou;
    procedure Done;

  end;

var
  WindowDatas: TWindowDatas;
  DidChange: boolean = false;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowDatas.FormActivate(Sender: TObject);
var
  FilePath: string;
begin
  FilePath := TConfigs.GetConfig('TEMP', 'FilePath');
  if FilePath <> '' then
  begin
    if FilePath <> TxtFileName.Caption then
    begin
      CleanGrid;
      SelectMode;
    end
    else
    begin
      NormalMode;
      UpdateGrid;
    end;
  end
  else
  begin
    DisableMode;
  end;
  Done;
end;

//Quando a janela � fechada
procedure TWindowDatas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DidChange then
  begin
    case TMyDialogs.YesNoCancel('Deseja salvar as altera��es?') of
    mrYes:
      ActSaveExecute(BtnSave);
    mrNo:
      ActCancelExecute(BtnCancel);
    mrCancel:
      Action := caNone;
    end;
  end;
end;

//Abre o arquivo Dataflex
procedure TWindowDatas.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    TConfigs.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
    SelectMode;
    CleanGrid;
  end;
end;

//Abre a configura��o de campos
procedure TWindowDatas.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

//Joga os dados Dataflex na tabela
procedure TWindowDatas.ActSelectExecute(Sender: TObject);
begin
  UpdateGrid;
  FillGrid;
  NormalMode;
  Done;
end;

//Quando o enter � pressionado no TxtRowsLimit
procedure TWindowDatas.TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key.ToString = '13' then
  begin
    ActSelectExecute(BtnSelect);
  end;
end;

//Quando uma Cell da Grid � editada
procedure TWindowDatas.GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  Mudou;
end;

//Ativa o modo de edi��o da Grid
procedure TWindowDatas.ActAlterExecute(Sender: TObject);
begin
  AlterMode;
end;

//Salva as altera��es feitas no aquivo
procedure TWindowDatas.ActSaveExecute(Sender: TObject);
begin
  GridToStrList.SaveToFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  UpdateGrid;
  NormalMode;
  Done;
end;

//Salva as altera��es feitas em um novo arquivo
procedure TWindowDatas.ActSaveAsExecute(Sender: TObject);
begin
  SaveFile.FileName := 'NewFile';
  if SaveFile.Execute then
  begin
    GridToStrList.SaveToFile(SaveFile.FileName);
  end;
end;

//Cancela as altera��es
procedure TWindowDatas.ActCancelExecute(Sender: TObject);
begin
  NormalMode;
  if DidChange = true then
  begin
    UpdateGrid;
    FillGrid;
    Done;
  end;
end;

//Adiciona uma nova c�lula na Grid
procedure TWindowDatas.ActAddCellExecute(Sender: TObject);
begin
  //
end;

//Remove a c�lula selecionada na Grid
procedure TWindowDatas.ActDelCellExecute(Sender: TObject);
begin
  //
end;

//Adiona uma nova linha na Grid
procedure TWindowDatas.ActAddRowExecute(Sender: TObject);
begin
  //
end;

//Remove a linha selecionada na Grid
procedure TWindowDatas.ActDelRowExecute(Sender: TObject);
begin
  //
end;

//Adiciona uma nova coluna na Grid
procedure TWindowDatas.ActAddColExecute(Sender: TObject);
begin
  //
end;

//Remove a coluna selecionada na Grid
procedure TWindowDatas.ActDelColExecute(Sender: TObject);
begin
  //
end;

//Insere os dados do arquivo Dataflex na Grid
procedure TWindowDatas.FillGrid;
var
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol, TotRows: integer;
begin
  Rows := TStringList.Create;
  Rows.LoadFromFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  DataFlex := TDataFlex.Create(Rows, ';');
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;

  if Trim(TxtRowsLimit.Text) = '' then
  begin
    TotRows := 0;
  end
  else
  begin
    TotRows := StrToInt(TxtRowsLimit.Text);
  end;

  if (TotRows > DataFlex.GetRows) or (TotRows = 0) then
  begin
    TotRows := DataFlex.GetRows;
    TxtRowsLimit.Text := DataFlex.GetRows.ToString;
  end;

  GridDatas.RowCount := TotRows + 1;
  GridDatas.ColCount := DataFlex.GetCols + 1;
  LblTotRows.Caption := 'Dados: ' + DataFlex.GetRows.ToString;
  LblTotCols.Caption := 'Campos: ' + DataFlex.GetCols.ToString;

  for ContRow := 1 to TotRows do
  begin
    GridDatas.Cells[0, ContRow] := 'Dado ' + ContRow.ToString;
  end;

  for ContCol := 1 to DataFlex.GetCols do
  begin
    GridDatas.Cells[ContCol, 0] := 'Campo ' + ContCol.ToString;
  end;

  for ContRow := 1 to TotRows do
  begin
    for ContCol := 1 to DataFlex.GetCols do
    begin
      GridDatas.Cells[ContCol, ContRow] := Datas[ContRow - 1, ContCol - 1];
    end;
  end;
end;

//Limpa os dados da Grid
procedure TWindowDatas.CleanGrid;
begin
  GridDatas.RowCount := 2;
  GridDatas.ColCount := 2;
  GridDatas.Rows[0].Clear;
  GridDatas.Cols[0].Clear;
  GridDatas.Cols[1].Clear;
end;

//Retorna os dados da Grid em linhas numa StringList
function TWindowDatas.GridToStrList: TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  for Cont := 1 to GridDatas.RowCount - 1 do
  begin
    Result.Add(TUtils.ArrayToStr(GridDatas.Rows[Cont].ToStringArray, 1, ';', ''));
  end;
end;

//Modo Buttons desabilitados
procedure TWindowDatas.DisableMode;
begin
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
end;

//Modo Button Select ativado
procedure TWindowDatas.SelectMode;
begin
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
end;

//Modo Buttons normais
procedure TWindowDatas.NormalMode;
begin
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := true;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := true;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
end;

//Modo Buttons em altera��o
procedure TWindowDatas.AlterMode;
begin
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := true;
  ActCancel.Enabled := true;
  ActAddCell.Enabled := true;
  ActDelCell.Enabled := true;
  ActAddRow.Enabled := true;
  ActDelRow.Enabled := true;
  ActAddCol.Enabled := true;
  ActDelCol.Enabled := true;
  GridDatas.Options := GridDatas.Options + [goEditing];
end;

//Muda a Cell selecionada na Grid para atualiz�-la
procedure TWindowDatas.UpdateGrid;
begin
  GridDatas.Row := GridDatas.RowCount - 1;
  GridDatas.Col := GridDatas.ColCount - 1;
  GridDatas.Row := 1;
  GridDatas.Col := 1;
  GridDatas.Refresh;
end;

//Quando a Grid � editada
procedure TWindowDatas.Mudou;
begin
  DidChange := true;
  ActSave.Enabled := true;
end;

//Quando as alter���es s�o salvas ou descartadas
procedure TWindowDatas.Done;
begin
  DidChange := false;
  ActSave.Enabled := false;
end;

end.
