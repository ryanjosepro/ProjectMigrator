unit ViewConfigs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, System.Actions, Vcl.ActnList,
  MyUtils, MyDialogs, Configs;

type
  TWindowConfigs = class(TForm)
    TxtLimit: TEdit;
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
    procedure ActDiscardExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GroupCommitClick(Sender: TObject);
    procedure GroupLimitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CheckTruncFBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

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
    case TMyDialogs.YesNoCancel('Deseja salvar as altera��es?') of
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
    TxtLimit.Enabled := false;
  end
  else
  begin
    TxtLimit.Enabled := true;
    TxtLimit.SetFocus;
  end;
end;

//Quando o CheckTruncFB � alterado
procedure TWindowConfigs.CheckTruncFBClick(Sender: TObject);
begin
  DidChange := true;
end;

//Salva todas as configura��es
procedure TWindowConfigs.ActSaveExecute(Sender: TObject);
var
  Commit, Limit, TruncFB: integer;
begin
  Commit := TUtils.Iff(GroupCommit.ItemIndex = 0, -1, TUtils.IfEmpty(TxtCommit.Text, '-1').ToInteger);
  Limit := TUtils.Iff(GroupLimit.ItemIndex = 0, -1, TUtils.IfEmpty(TxtLimit.Text, '-1').ToInteger);
  TruncFB := TUtils.Iff(CheckTruncFB.Checked, 1, 0);

  TConfigs.SetGeneral(Commit, Limit, TruncFB);

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
  Commit, Limit, TruncFB: integer;
begin
  TConfigs.GetGeneral(Commit, Limit, TruncFB);

  if Commit = -1 then
  begin
    GroupCommit.ItemIndex := 0;
  end
  else
  begin
    GroupCommit.ItemIndex := 1;
    TxtCommit.Text := Commit.ToString;
  end;

  if Limit = -1 then
  begin
    GroupLimit.ItemIndex := 0;
  end
  else
  begin
    GroupLimit.ItemIndex := 1;
    TxtLimit.Text := Limit.ToString;
  end;

  CheckTruncFB.Checked := (TruncFB = 1);

  PageConfigs.TabIndex := 0;
end;

end.
