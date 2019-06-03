unit MyUtils;

interface

uses
  System.SysUtils, System.Classes, System.Variants, System.StrUtils, System.Types, Vcl.Forms, IniFiles;

type
  TIntegerArray = array of integer;
  TStringArray = array of string;
  TStringMatrix = array of TStringDynArray;

  TDataFlex = class
  strict private
    //Atributos
    StrList: TStringList;
    Rows: integer;
    Cols: integer;

    //String -> Array, separa os campos
    function Cut(Str: string): TStringDynArray;

  public
    constructor Create(StrList: TStringList);

    function GetRows: integer;
    function GetCols: integer;

    //Transforma a stringlist em uma matriz
    function ToMatrix: TStringMatrix;
  end;

  TConfigs = class
  public
    class function GetUserName: string;
    class function GetPassword: string;
    class function GetDatabase: string;
    class function GetTable: string;
    class procedure SetUserName(const Value: string);
    class procedure SetPassWord(const Value: string);
    class procedure SetDatabase(const Value: string);
    class procedure SetTable(const Value: string);

  end;

  TUtils = class
  public
    class function Iff(cond: boolean; v1, v2: variant): variant;

  end;

implementation

{ TDataFlex }

function TDataFlex.Cut(Str: string): TStringDynArray;
var
  StrSize: integer;
begin
  StrSize := Length(SplitString(Str, ';'));
  SetLength(Result, StrSize);
  Result := SplitString(Str, ';');
end;

constructor TDataFlex.Create(StrList: TStringList);
begin
  self.StrList := StrList;
  self.Rows := StrList.Count;
  self.Cols := Length(Cut(StrList[0]));
end;

function TDataFlex.GetRows: integer;
begin
  Result := self.Rows;
end;

function TDataFlex.GetCols: integer;
begin
  Result := self.Cols;
end;

function TDataFlex.ToMatrix: TStringMatrix;
var
  Cont: integer;
begin
  SetLength(Result, GetRows, GetCols);
  for Cont := 0 to GetRows - 1 do
  begin
    Result[Cont] := Cut(self.StrList[Cont]);
  end;
end;

{ TConfigs }

class function TConfigs.GetUserName: string;
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Result := Arq.ReadString('DB', 'UserName', 'SYSDBA');
  finally
    FreeAndNil(Arq);
  end;
end;

class function TConfigs.GetPassword: string;
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Result := Arq.ReadString('DB', 'Password', 'masterkey');
  finally
    FreeAndNil(Arq);
  end;
end;

class function TConfigs.GetDatabase: string;
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Result := Arq.ReadString('DB', 'Database', ExtractFilePath(Application.ExeName) + 'DB\NSC.FDB');
  finally
    FreeAndNil(Arq);
  end;
end;

class function TConfigs.GetTable: string;
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Result := Arq.ReadString('DB', 'Table', 'CLIENTES');
  finally
    FreeAndNil(Arq);
  end;
end;

class procedure TConfigs.SetUserName(const Value: string);
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Arq.WriteString('DB', 'UserName', Value);
  finally
    FreeAndNil(Arq);
  end;
end;

class procedure TConfigs.SetPassWord(const Value: string);
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Arq.WriteString('DB', 'Password', Value);
  finally
    FreeAndNil(Arq);
  end;
end;

class procedure TConfigs.SetDatabase(const Value: string);
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Arq.WriteString('DB', 'Database', Value);
  finally
    FreeAndNil(Arq);
  end;
end;

class procedure TConfigs.SetTable(const Value: string);
var
  Arq: TIniFile;
begin
  try
    Arq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config\Config.ini');
    Arq.WriteString('DB', 'Table', Value);
  finally
    FreeAndNil(Arq);
  end;
end;

{ TUtils }

class function TUtils.Iff(Cond: boolean; V1, V2: variant): variant;
begin
  if Cond then
  begin
    Result := V1;
  end
  else
  begin
    Result := V2;
  end;
end;

end.
