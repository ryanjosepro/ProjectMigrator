unit MyDialogs;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Dialogs;

type
  TMyDialogs = class
  public
    class function YesNo(Msg: string): integer;
    class function YesNoCancel(Msg: string): integer;
  end;

implementation

{ TMyDialogs }

class function TMyDialogs.YesNo(Msg: string): integer;
begin
  Result := MessageDlg(Msg, mtWarning, mbYesNo, 0, mbNo);
end;

class function TMyDialogs.YesNoCancel(Msg: string): integer;
begin
  Result := MessageDlg(Msg, mtConfirmation, mbYesNoCancel, 0, mbCancel);
end;

end.
