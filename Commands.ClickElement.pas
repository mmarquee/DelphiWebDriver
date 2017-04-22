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
  Utils,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  System.SysUtils,
  System.Classes;

procedure TClickElementCommand.Execute(AOwner: TForm);
var
  ctrl: TWinControl;
  comp: TComponent;
  handle: Integer;

begin
  ctrl := nil;
  comp := nil;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  end
  else
    comp := (AOwner.FindComponent(self.Params[2]));

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
