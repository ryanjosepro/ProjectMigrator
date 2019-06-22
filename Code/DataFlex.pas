unit DataFlex;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.StrUtils, Vcl.Forms,
  Arrays;

type

  TDataFlex = class
  strict private
    //Atributos
    StrList: TStringList;
    Rows: integer;
    Cols: integer;

  public
    //Constutor
    constructor Create(StrList: TStringList);

    //De String -> Array, separa os campos
    function Cut(Str, Separator: string): TStringArray;

    //Gets
    function GetRows: integer;
    function GetCols: integer;

    //Transforma a stringlist em uma matriz
    function ToMatrix: TStringMatrix;

end;

implementation

constructor TDataFlex.Create(StrList: TStringList);
begin
  self.StrList := StrList;
  self.Rows := StrList.Count;
  self.Cols := Length(Cut(StrList[0], ';'));
end;

function TDataFlex.Cut(Str, Separator: string): TStringArray;
var
  StrArray: TStringDynArray;
  Cont: integer;
begin
  SetLength(StrArray, Length(SplitString(Str, Separator)));
  StrArray := SplitString(Str, Separator);
  SetLength(Result, Length(StrArray));
  for Cont := 0 to Length(StrArray) - 1 do
  begin
    Result[Cont] := StrArray[Cont];
  end;
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
    Result[Cont] := Cut(self.StrList[Cont], ';');
  end;
end;

end.
