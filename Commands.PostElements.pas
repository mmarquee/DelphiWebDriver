unit Commands.PostElements;

interface

uses
  generics.collections,
  Vcl.Forms,
  Vcl.controls,
  System.Classes,
  CommandRegistry,
  HttpServerCommand;

type
  TPostElementsCommand = class(TRestCommand)
  private
    procedure GetElementsByName(const value:String; AOwner: TForm);
    procedure GetElementsByCaption(const value:String; AOwner: TForm);
    procedure GetElementsByClassName(const value:String; AOwner: TForm);

    function OKResponse(const sessionId: String; elements: TObjectList<TComponent>): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.stdctrls,
  System.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

procedure TPostElementsCommand.GetElementsByName(const value:String; AOwner: TForm);
begin

end;

procedure TPostElementsCommand.GetElementsByCaption(const value:String; AOwner: TForm);
begin

end;

procedure TPostElementsCommand.GetElementsByClassName(const value:String; AOwner: TForm);
var
  comps: TObjectList<TComponent>;
  i: Integer;

begin
  comps:= TObjectList<TComponent>.create;

  try
    try
      if (AOwner.ClassName = value) then
        comps.Add(AOwner)
      else
      begin
        for i := 0 to tForm(AOwner).ControlCount -1 do
        begin
          if tForm(AOwner).Controls[i].ClassName = value then
          begin
            comps.Add(AOwner.Controls[i]);
          end;
        end;
      end;

      if comps.count = 0 then
        raise Exception.Create('Control(s) not found');

      ResponseJSON(self.OKResponse(self.Params[1], comps));

    except on e: Exception do
      // Probably should give a different reply
      Error(401);
    end;
  finally
    comps.free;
  end;
end;

procedure TPostElementsCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  using: String;
  value: String;

begin
  // Decode request
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('using', using);
    (jsonObj as TJsonObject).TryGetValue<String>('value', value);
  finally
    jsonObj.Free;
  end;

  if (using = 'link text') then
    GetElementsByCaption(value, AOwner)
  else if (using = 'name') then
    GetElementsByName(value, AOwner)
  else if (using = 'class name') then
    GetElementsByClassName(value, AOwner)
  // 'partial link text '
end;

function TPostElementsCommand.OKResponse(const sessionId: String; elements: TObjectList<TComponent>): String;
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
    arrayObject.AddPair(TJSONPair.Create('ELEMENT', IntToStr((elements[i] as TWinControl).Handle)));
    jsonArray.AddElement(arrayObject);
  end;

  jsonObject.AddPair(jsonPair);

  result := jsonObject.ToString;
end;

end.
