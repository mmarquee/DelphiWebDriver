unit Commands.GetRect;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  TGetRectCommand = class(TRESTCommand)
  private
    function OKResponse(x, y, width, height: Integer): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.Controls,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON,
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
    comp := AOwner.FindComponent(self.Params[2]);

  // Needs to actually be proper rect
  if (ctrl <> nil) then
  begin
    if (ctrl is TEdit) then
    begin
      ResponseJSON((ctrl as TEdit).Text)
    end;
  end
  else if (comp <> nil) then
  begin
    if (comp is TSpeedButton) then
    begin
      ResponseJSON((comp as TSpeedButton).Caption);
    end;
  end
  else
  begin
    Error(404);
  end;
end;

function TGetRectCommand.OKResponse(x, y, width, height: Integer): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('x', IntToStr(x)));
  jsonObject.AddPair(TJSONPair.Create('y', IntToStr(y)));
  jsonObject.AddPair(TJSONPair.Create('width', IntToStr(width)));
  jsonObject.AddPair(TJSONPair.Create('height', IntToStr(height)));

  result := jsonObject.ToString;
end;


end.
