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

procedure TClickElementCommand.Execute(AOwner: TForm);
var
  ctrl: TWinControl;
  comp: TComponent;
  handle: Integer;
  name: String;

begin
  ctrl := nil;
  comp := nil;

  try
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  except
    comp := (self.Reg.FHost.FindComponent(self.Params[2]));
  end;


  if (comp <> nil) then
  begin
    // Something like this?
    if (comp is TButton) then
      (comp as TButton).click
  end
  else if (ctrl <> nil) then
  begin
 //   if (ctrl is TSpeedButton) then
      //(ctrl as TSpeedButton).click;
    (ctrl as TSpeedButton).click;
  end
  else
    Error(404);
end;

end.
