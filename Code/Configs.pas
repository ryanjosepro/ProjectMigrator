unit Configs;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, Vcl.Forms, IniFiles,
  MyUtils;

type

  TConfigs = class
  strict private
    class function Source: string;
    class procedure CreateFile(Path: string);
  public
    class function GetConfig(const Section, Name: string): string;
    class procedure SetConfig(const Section, Name, Value: string);

    class procedure GetGeneral(var Commit, Limit, TruncFB, Error: integer);
    class procedure SetGeneral(Commit, Limit, TruncFB, Error: integer);

    class procedure GetDB(var UserName, Password, Database: string);
    class procedure SetDB(UserName, Password, Database: string);
  end;

implementation

{ TConfigs }

//Caminho das configura��es
class function TConfigs.Source: string;
var
  Path: string;
begin
  Path := ExtractFilePath(Application.ExeName) + 'Config.ini';

  if FileExists(Path) then
  begin
    Result := Path;
  end
  else
  begin
    CreateFile(Path);
  end;
end;

//Cria o arquivo Config.ini
class procedure TConfigs.CreateFile(Path: string);
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(Path);
  try
    Arq.WriteString('SYSTEM', 'WindowState', '0');
    Arq.WriteString('GENERAL', 'Commit', '-1');
    Arq.WriteString('GENERAL', 'Limit', '-1');
    Arq.WriteString('GENERAL', 'TruncFB', '0');
    Arq.WriteString('GENERAL', 'Exception', '2');
    Arq.WriteString('DB', 'UserName', 'SYSDBA');
    Arq.WriteString('DB', 'Password', 'masterkey');
    Arq.WriteString('DB', 'Database', '');
    Arq.WriteString('DB', 'Table', '');
    Arq.WriteString('TEMP', 'FilePath', '');
  finally
    FreeAndNil(Arq);
  end;
end;

//Busca uma configura��o espec�fica
class function TConfigs.GetConfig(const Section, Name: string): string;
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(Source);
  try
    Result := Arq.ReadString(Section, Name, '');
  finally
    FreeAndNil(Arq);
  end;
end;

//Define uma configura��o espec�fica
class procedure TConfigs.SetConfig(const Section, Name, Value: string);
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(Source);
  try
    Arq.WriteString(Section, Name, Value);
  finally
    FreeAndNil(Arq);
  end;
end;

//Configura��es da se��o GENERAL
class procedure TConfigs.GetGeneral(var Commit, Limit, TruncFB, Error: integer);
begin
  Commit := TUtils.IfEmpty(TConfigs.GetConfig('GENERAL', 'Commit'), '-1').ToInteger;
  Limit := TUtils.IfEmpty(TConfigs.GetConfig('GENERAL', 'Limit'), '-1').ToInteger;
  TruncFB := TUtils.IfEmpty(TConfigs.GetConfig('GENERAL', 'TruncFB'), '0').ToInteger;
  Error := TUtils.IfEmpty(TConfigs.GetConfig('GENERAL', 'Error'), '2').ToInteger;
end;

class procedure TConfigs.SetGeneral(Commit, Limit, TruncFB, Error: integer);
begin
  TConfigs.SetConfig('GENERAL', 'Commit', Commit.ToString);
  TConfigs.SetConfig('GENERAL', 'Limit', Limit.ToString);
  TConfigs.SetConfig('GENERAL', 'TruncFB', TruncFB.ToString);
  TConfigs.SetConfig('GENERAL', 'Error', Error.ToString);
end;

//Configur���es da se��o DB
class procedure TConfigs.GetDB(var UserName, Password, Database: string);
begin
  UserName := TConfigs.GetConfig('DB', 'UserName');
  Password := TConfigs.GetConfig('DB', 'Password');
  Database := TConfigs.GetConfig('DB', 'Database');
end;

class procedure TConfigs.SetDB(UserName, Password, Database: string);
begin
  TConfigs.SetConfig('DB', 'UserName', UserName);
  TConfigs.SetConfig('DB', 'Password', Password);
  TConfigs.SetConfig('DB', 'Database', Database);
end;

end.
