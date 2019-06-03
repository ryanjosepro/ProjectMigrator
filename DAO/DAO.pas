unit DAO;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Types, FireDAC.Comp.Client, ConnectionFactory, ViewDB, Vcl.Dialogs,
  MyUtils;

type

  TDAO = class
  public
    class function QueryTable: TFDQuery;
    class function QuerySQL: TFDQuery;

    class function Table: string;

    class procedure Insert(DataFlex: TStringDynArray; Order: TIntegerArray);

    class function GetFieldsNames: TStringArray;

    class function Count: integer;

  end;

implementation

{ TDAO }

class function TDAO.QueryTable: TFDQuery;
begin
  Result := ConnFactory.QueryTable;
end;

class function TDAO.QuerySQL: TFDQuery;
begin
  Result := ConnFactory.QuerySQL;
end;

class function TDAO.Table: string;
begin
  Result := TConfigs.GetTable;
end;

class function TDAO.GetFieldsNames: TStringArray;
var
  Cont: integer;
begin
  QueryTable.Close;
  QueryTable.ParamByName('TABLE_NAME').AsString := Table;
  QueryTable.Open;
  if Count <> 0 then
  begin
    SetLength(Result, Count);
    QueryTable.First;
    for Cont := 0 to Count - 1 do
    begin
      Result[Cont] := QueryTable.FieldByName('FIELD_NAME').AsString;
      QueryTable.Next;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := '';
  end;
end;

class procedure TDAO.Insert(DataFlex: TStringDynArray; Order: TIntegerArray);
var
  Cont: Integer;
  Fields: TStringArray;
begin
  SetLength(Fields, Count);
  Fields := GetFieldsNames;
  QuerySQL.SQL.Clear;
  QuerySQL.Open('select * from ' + Table);
  QuerySQL.Insert;
  for Cont := 0 to Count - 1 do
  begin
    if (Order[Cont] = -1) or (Order[Cont] -1 = -1) then
    begin
      continue
    end;
    //O grande problema - TIPOS
    QuerySQL.FieldByName(Fields[Cont]).AsVariant := DataFlex[Order[Cont] - 1];
    //The big problem - TYPES
  end;
  QuerySQL.Post;
end;

class function TDAO.Count: integer;
begin
  QueryTable.Close;
  QueryTable.ParamByName('TABLE_NAME').AsString := Table;
  QueryTable.Open;
  Result := QueryTable.RowsAffected;
end;

end.
