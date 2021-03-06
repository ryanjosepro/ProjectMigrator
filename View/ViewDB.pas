unit ViewDB;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms,Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  MyUtils, MyDialogs, Config, DAO;

type
  TWindowDB = class(TForm)
    ImageTitle: TImage;
    LblUserName: TLabel;
    TxtUserName: TEdit;
    LblPassword: TLabel;
    TxtPassword: TEdit;
    LblDatabase: TLabel;
    TxtDatabase: TEdit;
    BtnSave: TSpeedButton;
    BtnTestConn: TSpeedButton;
    OpenFile: TFileOpenDialog;
    Actions: TActionList;
    Images: TImageList;
    ActDBFile: TAction;
    BtnDBFile: TSpeedButton;
    ActSave: TAction;
    ActTest: TAction;
    BtnDiscard: TSpeedButton;
    ActDiscard: TAction;
    ActEsc: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TxtChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActDBFileExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActTestExecute(Sender: TObject);
    procedure ActDiscardExecute(Sender: TObject);
    procedure ActDBFileHint(var HintStr: string; var CanShow: Boolean);
    procedure ActEscExecute(Sender: TObject);

  private
    procedure LoadConfigs;
    procedure Altered;
    procedure Done;
  end;

var
  WindowDB: TWindowDB;
  DidChange: boolean;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowDB.FormActivate(Sender: TObject);
begin
  LoadConfigs;
  Done;
end;

//Quando a janela � fechada
procedure TWindowDB.FormClose(Sender: TObject; var Action: TCloseAction);
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

//Busca o arquivo do banco de dados
procedure TWindowDB.ActDBFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    TxtDatabase.Text := OpenFile.FileName;
  end;
end;

//Quando o hint � mostrado
procedure TWindowDB.ActDBFileHint(var HintStr: string; var CanShow: Boolean);
begin
  HintStr := TUtils.IfEmpty(TConfig.GetConfig('DB', 'Database'), 'Banco de Dados');
end;

//Descarta as altera��es
procedure TWindowDB.ActDiscardExecute(Sender: TObject);
begin
  LoadConfigs;
  Done;
end;

//Salva as altera��es
procedure TWindowDB.ActSaveExecute(Sender: TObject);
begin
    TConfig.SetDB(TxtUserName.Text, TxtPassword.Text, TxtDatabase.Text);

    TDAO.SetParams(TxtUserName.Text, TxtPassword.Text, TxtDatabase.Text);

    Done;
end;

//Testa a conex�o
procedure TWindowDB.ActTestExecute(Sender: TObject);
var
  CurrUserName, CurrPassword, CurrDatabase: string;
begin
  TDAO.GetParams(CurrUserName, CurrPassword, CurrDatabase);

  TDAO.SetParams(TxtUserName.Text, TxtPassword.Text, TxtDatabase.Text);
  try
    try
      TDAO.TestConn;
      ShowMessage('Conex�o Ok!');
    except on E: Exception do
      ShowMessage('Erro de conex�o: ' + E.ToString);
    end;
  finally
    TDAO.SetParams(CurrUserName, CurrPassword, CurrDatabase);
  end;
end;

//Quando alguma coisa � alterada
procedure TWindowDB.TxtChange(Sender: TObject);
begin
  Altered;
end;

//Carrega as configura��es definidas
procedure TWindowDB.LoadConfigs;
var
  UserName, Password, Database: string;
begin
  TConfig.GetDB(UserName, Password, Database);
  TxtUserName.Text := UserName;
  TxtPassword.Text := Password;
  TxtDatabase.Text := Database;
end;

//Quando algo � editado
procedure TWindowDB.Altered;
begin
  DidChange := true;
  ActSave.Enabled := true;
  ActDiscard.Enabled := true;
end;

//Quando as altera��es s�o salvas ou descartadas
procedure TWindowDB.Done;
begin
  DidChange := false;
  ActSave.Enabled := false;
  ActDiscard.Enabled := false;
end;

//Quando a tecla Esc � pressionada
procedure TWindowDB.ActEscExecute(Sender: TObject);
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
