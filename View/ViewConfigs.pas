unit ViewConfigs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, System.Actions, Vcl.ActnList,
  MyUtils, MyDialogs, Configs;

type
  TWindowConfigs = class(TForm)
    TxtLimitStarts: TEdit;
    PageConfigs: TPageControl;
    TabMigration: TTabSheet;
    TabFirebird: TTabSheet;
    CheckTruncFB: TCheckBox;
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
    procedure ActDiscardExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GroupCommitClick(Sender: TObject);
    procedure GroupLimitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SomeChange(Sender: TObject);

  private
    procedure LoadConfigs;
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
  DidChange := false;
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
    DidChange := false;
  end;
end;

//Quando algo no GroupCommit � alterado
procedure TWindowConfigs.GroupCommitClick(Sender: TObject);
begin
  DidChange := true;
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
  DidChange := true;
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

//Quando o CheckTruncFB � alterado
procedure TWindowConfigs.SomeChange(Sender: TObject);
begin
  DidChange := true;
end;

//Salva todas as configura��es
procedure TWindowConfigs.ActSaveExecute(Sender: TObject);
var
  LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TruncFB, ErrorHdlg: integer;
begin
  LogActions := TUtils.Iff(CheckLogActions.Checked, 1, 0);
  LogDatas := TUtils.Iff(CheckLogDatas.Checked, 1, 0);
  Commit := TUtils.IffEmpty(GroupCommit.ItemIndex = 0, '-1', TxtCommit.Text).ToInteger;
  LimitStarts := TUtils.IffEmpty(GroupLimit.ItemIndex = 0, '-1', TxtLimitStarts.Text).ToInteger;
  if LimitStarts = 0 then LimitStarts := -1;
  LimitEnds := TUtils.IffEmpty(GroupLimit.ItemIndex = 0, '-1', TxtLimitEnds.Text).ToInteger;
  if LimitEnds = 0 then LimitEnds := -1;
  TruncFB := TUtils.Iff(CheckTruncFB.Checked, 1, 0);
  ErrorHdlg := GroupException.ItemIndex;

  TConfigs.SetGeneral(LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TruncFB, ErrorHdlg);

  DidChange := false;

  Close;
end;

//Descarta todas as configura��es
procedure TWindowConfigs.ActDiscardExecute(Sender: TObject);
begin
  DidChange := false;
  Close;
end;

//Carregas as configura��es definidas
procedure TWindowConfigs.LoadConfigs;
var
  LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TruncFB, ErrorHdlg: integer;
begin
  TConfigs.GetGeneral(LogActions, LogDatas, Commit, LimitStarts, LimitEnds, TruncFB, ErrorHdlg);

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
    TxtLimitStarts.Text := TUtils.Iff(LimitStarts = -1, '', LimitStarts.ToString);
    TxtLimitEnds.Text := TUtils.Iff(LimitEnds = -1, '', LimitEnds.ToString);
  end;

  //Exce��es
  GroupException.ItemIndex := ErrorHdlg;

  //Firebird
  CheckTruncFB.Checked := (TruncFB = 1);

  PageConfigs.TabIndex := 0;
end;

end.
