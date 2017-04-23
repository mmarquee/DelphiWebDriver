unit Commands.ClickElement;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  TClickElementCommand = class(TRESTCommand)
  private
    function OKResponse(const handle: String): String;
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
  System.JSON,
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
    begin
      (ctrl as TButton).click;
    end;

    ResponseJSON(self.OKResponse(self.Params[2]));
  end
  else if (comp <> nil) then
  begin
    if (comp is TSpeedButton) then
    begin
      (comp as TSpeedButton).click;

    end;

    ResponseJSON(self.OKResponse(self.Params[2]));
  end
  else
    Error(404);
end;

function TClickElementCommand.OKResponse(const handle: String): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('id', handle));

  result := jsonObject.ToString;
end;

end.
