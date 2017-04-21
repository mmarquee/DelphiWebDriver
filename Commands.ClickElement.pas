unit Commands.ClickElement;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  TClickElementCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  System.SysUtils,
  System.Classes;

function isNumber(const s: String): boolean;
var
  iValue, iCode: Integer;
begin
  val(s, iValue, iCode);
  result := (iCode = 0)
end;

procedure TClickElementCommand.Execute(AOwner: TForm);
var
  ctrl: TWinControl;
  comp: TComponent;
  handle: Integer;
  name: String;

begin
  ctrl := nil;
  comp := nil;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  end
  else
    // Access violation here
    comp := (self.Reg.FHost.FindComponent(self.Params[2]));

  if (ctrl <> nil) then
  begin
    if (ctrl is TButton) then
      (ctrl as TButton).click
  end
  else if (comp <> nil) then
  begin
    if (comp is TSpeedButton) then
      (comp as TSpeedButton).click;
  end
  else
    Error(404);
end;

end.
