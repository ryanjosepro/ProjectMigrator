unit MyDialogs;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls;

type
  TDialogs = class
  public
    class function YesNo(Msg: string; BtnDefault: TMsgDlgBtn = mbNo): integer;
    class function YesNoCancel(Msg: string; BtnDefault: TMsgDlgBtn = mbCancel): integer;
    class function MyMessageDlg(CONST Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
    Caption: ARRAY OF string; dlgcaption: string): Integer;
  end;

implementation

{ TMyDialogs }

class function TDialogs.YesNo(Msg: string; BtnDefault: TMsgDlgBtn): integer;
begin
  Result := MessageDlg(Msg, mtWarning, mbYesNo, 0, BtnDefault);
end;

class function TDialogs.YesNoCancel(Msg: string; BtnDefault: TMsgDlgBtn): integer;
begin
  Result := MessageDlg(Msg, mtConfirmation, mbYesNoCancel, 0, BtnDefault);
end;

class function TDialogs.MyMessageDlg(CONST Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
  Caption: ARRAY OF string; dlgcaption: string): Integer;
var
  aMsgdlg: TForm;
  i: Integer;
  Dlgbutton: TButton;
  Captionindex: Integer;
begin
  aMsgdlg := createMessageDialog(Msg, DlgTypt, button);
  aMsgdlg.Caption := dlgcaption;
  aMsgdlg.BiDiMode := bdRightToLeft;
  Captionindex := 0;
  for i := 0 to aMsgdlg.componentcount - 1 Do
  begin
    if (aMsgdlg.components[i] is Tbutton) then
    Begin
      Dlgbutton := Tbutton(aMsgdlg.components[i]);
      if Captionindex <= High(Caption) then
        Dlgbutton.Caption := Caption[Captionindex];
      inc(Captionindex);
    end;
  end;
  Result := aMsgdlg.Showmodal;
end;

end.
