unit Commands.PostElements;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TPostElementsCommand = class(TRestCommand)
  private
    procedure GetElementsByName(const value:String; AOwner: TForm);
    procedure GetElementsByCaption(const value:String; AOwner: TForm);
    procedure GetElementsByClassName(const value:String; AOwner: TForm);
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.controls,
  Vcl.stdctrls,
  System.Types,
  System.SysUtils,
  System.Classes,
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
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ComponentCount -1 do
        if (tForm(AOwner).Components[i] as TWinControl).ClassName = value then
        begin
          comp := tForm(AOwner).Components[i];
          break;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(inttostr((comp as TWinControl).Handle));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
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

end.
