unit MyUtils;

interface

uses
  System.SysUtils, System.Classes, System.Variants;

type
  TStringArray = array of string;
  TStringMatrix = array of array of string;

  TDataFlex = class
  private
    class function Cut(Str: string): TStringArray;

  public
    class function ToMatrix(StrList: TStringList): TStringMatrix;

  end;

implementation

{ TDataFlex }

class function TDataFlex.ToMatrix(StrList: TStringList): TStringMatrix;
var
  TotCols, TotRows: integer;
begin

end;

end.
