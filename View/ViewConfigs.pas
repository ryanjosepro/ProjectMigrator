unit ViewConfigs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  System.Actions, Vcl.ActnList,
  MyUtils, MyDialogs, Config;

type
  TWindowConfigs = class(TForm)
    TxtLimitStarts: TEdit;
    TabMigration: TTabSheet;
    TabFirebird: TTabSheet;
    BtnDiscard: TSpeedButton;
    BtnSave: TSpeedButton;
    Actions: TActionList;
    ActSave: TAction;
    ActDiscard: TAction;
    TxtCommit: TEdit;
    GroupCommit: TRadioGroup;
    GroupLimit: TRadioGroup;
    TabExceptions: TTabSheet;
    GroupException: TRadioGroup;
    TxtLimitEnds: TEdit;
    LblUntil: TLabel;
    LblFrom: TLabel;
    CheckLogDatas: TCheckBox;
    CheckLogActions: TCheckBox;
    GroupLog: TGroupBox;
    ActEsc: TAction;
    GroupTable: TRadioGroup;
    PageConfigs: TPageControl;
    procedure ActDiscardExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GroupCommitClick(Sender: TObject);
    procedure GroupLimitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SomeChange(Sender: TObject);
    procedure ActEscExecute(Sender: TObject);

  private
    procedure LoadConfigs;
    procedure Altered;
    procedure Done;
  end;

var
  WindowConfigs: TWindowConfigs;
  DidChange: boolean;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowConfigs.FormActivate(Sender: TObject);
begin
  LoadConfigs;
  Done;
end;

//Quando a janela � fechada
procedure TWindowConfigs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DidChange then
  begin
    case TDialogs.YesNoCancel('Deseja salvar as altera��es?') of
    mrYes:
      ActSaveExecute(BtnSave);
    mrCancel:
      Action := TCloseAction.caNone;
    end;
  end
  else
  begin
    Done;
  end;
end;

//Quando algo no GroupCommit � alterado
procedure TWindowConfigs.GroupCommitClick(Sender: TObject);
begin
  Altered;
  if GroupCommit.ItemIndex = 0 then
  begin
    TxtCommit.Enabled := false;
  end
  else
  begin
    TxtCommit.Enabled := true;
    TxtCommit.SetFocus;
  end;
end;

//QUanddo algo no GroupLimit � alterado
procedure TWindowConfigs.GroupLimitClick(Sender: TObject);
begin
  Altered;
  if GroupLimit.ItemIndex = 0 then
  begin
    TxtLimitStarts.Enabled := false;
    TxtLimitEnds.Enabled := false;
  end
  else
  begin
    TxtLimitStarts.Enabled := true;
    TxtLimitEnds.Enabled := true;
    TxtLimitStarts.SetFocus;
  end;
end;

//Quando os checks s�o alterados
procedure TWindowConfigs.SomeChange(Sender: TObject);
begin
  Altered;
end;

//Salva todas as configura��es
procedure TWindowConfigs.ActSaveExecute(Sender: TObject);
var
  LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TableAction, ErrorHdlg: integer;
begin
  LogActions := TUtils.Iif(CheckLogActions.Checked, 1, 0);
  LogDatas := TUtils.Iif(CheckLogDatas.Checked, 1, 0);
  Commit := TUtils.IifEmpty(GroupCommit.ItemIndex = 0, '-1', TxtCommit.Text).ToInteger;
  LimitStarts := TUtils.IifEmpty(GroupLimit.ItemIndex = 0, '-1', TxtLimitStarts.Text).ToInteger;
  if LimitStarts = 0 then LimitStarts := -1;
  LimitEnds := TUtils.IifEmpty(GroupLimit.ItemIndex = 0, '-1', TxtLimitEnds.Text).ToInteger;
  if LimitEnds = 0 then LimitEnds := -1;
  TableAction := GroupTable.ItemIndex;
  ErrorHdlg := GroupException.ItemIndex;

  TConfig.SetGeneral(LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TableAction, ErrorHdlg);

  Done;
end;

//Descarta todas as configura��es
procedure TWindowConfigs.ActDiscardExecute(Sender: TObject);
begin
  LoadConfigs;
  Done;
end;

//Carregas as configura��es definidas
procedure TWindowConfigs.LoadConfigs;
var
  LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TableAction, ErrorHdlg: integer;
begin
  TConfig.GetGeneral(LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TableAction, ErrorHdlg);

  //Migra��o
  CheckLogActions.Checked := (LogActions = 1);

  CheckLogDatas.Checked := (LogDatas = 1);

  if Commit = -1 then
  begin
    GroupCommit.ItemIndex := 0;
  end
  else
  begin
    GroupCommit.ItemIndex := 1;
    TxtCommit.Text := Commit.ToString;
  end;

  if (LimitStarts = -1) and (LimitEnds = -1) then
  begin
    GroupLimit.ItemIndex := 0;
  end
  else
  begin
    GroupLimit.ItemIndex := 1;
    TxtLimitStarts.Text := TUtils.Iif(LimitStarts = -1, '', LimitStarts.ToString);
    TxtLimitEnds.Text := TUtils.Iif(LimitEnds = -1, '', LimitEnds.ToString);
  end;

  //Exce��es
  GroupException.ItemIndex := ErrorHdlg;

  //Firebird
  GroupTable.ItemIndex := TableAction;

  PageConfigs.TabIndex := 0;
end;

//Quando algo � editado
procedure TWindowConfigs.Altered;
begin
  DidChange := true;
  ActSave.Enabled := true;
  ActDiscard.Enabled := true;
end;

//Quando as altera��es s�o salvas ou descartadas
procedure TWindowConfigs.Done;
begin
  DidChange := false;
  ActSave.Enabled := false;
  ActDiscard.Enabled := false;
end;

//Quando a tecla Esc � pressionada
procedure TWindowConfigs.ActEscExecute(Sender: TObject);
begin
  if DidChange then
  begin
    ActDiscard.Execute;
  end
  else
  begin
    Close;
  end;
end;

end.
