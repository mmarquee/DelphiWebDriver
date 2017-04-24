unit Commands.PostElementElementsCommand;

interface

uses
  Vcl.Forms,
  System.Classes,
  generics.collections,
  CommandRegistry,
  HttpServerCommand;

Type
  TPostElementElementsCommand = class(TRestCommand)
  private
    function OKResponse(const sessionId: String; elements: TStringList): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.Grids,
  Vcl.controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  utils;

procedure TPostElementElementsCommand.Execute(AOwner: TForm);
var
  ctrl: TWinControl;
  comp: TComponent;
  handle: Integer;
  i: integer;
  comps: TStringList;

begin
  ctrl := nil;
  comp := nil;

  comps := TStringList.Create;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  end
  else
    comp := (AOwner.FindComponent(self.Params[2]));

  if (ctrl <> nil) then
  begin
    if (ctrl is TStringGrid) then
    begin
      for i := 0 to (ctrl as TStringGrid).RowCount -1 do
      begin
        // Needs a name as it doesn't have a handle
        // Add each line as an offset????
        comps.Add(ctrl.name + IntToStr(i));
      end;
    end
    else if (ctrl is TListBox) then
    begin
      for i := 0 to (ctrl as TListBox).Count -1 do
      begin
        // Needs a name as it doesn't have a handle
        // Add each line as an offset????
        comps.Add(ctrl.name + IntToStr(i));
      end;
    end;

    if comps = nil then
      raise Exception.Create('Control(s) not found');

    ResponseJSON(self.OKResponse(self.Params[1], comps));
  end
  else
    Error(404);
end;

function TPostElementElementsCommand.OKResponse(const sessionId: String; elements: TStringList): String;
var
  i: Integer;
  jsonPair: TJSONPair;
  jsonObject, arrayObject: TJSONObject;
  jsonArray: TJSONArray;

begin
  jsonArray := TJSONArray.Create;
  jsonObject := TJSONObject.Create;
  jsonPair := TJSONPair.Create('value', jsonArray);

  jsonObject.AddPair(TJSONPair.Create('sessionID', sessionId));
  jsonObject.AddPair(TJSONPair.Create('status', '0'));

  for i := 0 to elements.count -1 do
  begin
    arrayObject := TJSONObject.Create;

    arrayObject.AddPair(TJSONPair.Create('ELEMENT', elements[i]));

    jsonArray.AddElement(arrayObject);
  end;

  jsonObject.AddPair(jsonPair);

  result := jsonObject.ToString;
end;

end.
