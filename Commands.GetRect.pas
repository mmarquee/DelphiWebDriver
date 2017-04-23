unit Commands.GetRect;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  TGetRectCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.Controls,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.Buttons,
  Vcl.StdCtrls,
  utils;

procedure TGetRectCommand.Execute(AOwner: TForm);
var
  comp: TComponent;
  ctrl: TWinControl;
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
  begin
    comp := AOwner.FindComponent(self.Params[2]);

    if (ctrl <> nil) then
    begin
      if (ctrl is TEdit) then
         ResponseJSON((ctrl as TEdit))
    end
    else if (comp <> nil) then
    begin
      if (comp is TSpeedButton) then
        ResponseJSON((comp as TSpeedButton).Caption)
    end;
  end
//  else
//    Error(404);
end;


end.
