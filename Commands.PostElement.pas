unit Commands.PostElement;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TPostElementCommand = class(TRestCommand )
  private
    procedure GetElementByName(const value:String; AOwner: TForm);
    procedure GetElementByCaption(const value:String; AOwner: TForm);
    procedure GetElementByClassName(const value:String; AOwner: TForm);
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

type
  TMyControl = class (TControl)
  protected
    property Caption;
  end;

procedure TPostElementCommand.GetElementByName(const value:String; AOwner: TForm);
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
        if tForm(AOwner).Components[i] is TControl then
          if (tForm(AOwner).Components[i] as TControl).Caption = value then
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

procedure TPostElementCommand.GetElementByClassName(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.ClassName = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ComponentCount -1 do
        if tForm(AOwner).Components[i] is TControl then
          if (tForm(AOwner).Components[i] as TMyControl).ClassName = value then
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

procedure TPostElementCommand.GetElementByCaption(const value:String; AOwner: TForm);
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
        if tForm(AOwner).Components[i] is TControl then
        begin
          if (tForm(AOwner).Components[i] as TMyControl).caption = value then
          begin
            comp := tForm(AOwner).Components[i];
            break;
          end;
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

procedure TPostElementCommand.Execute(AOwner: TForm);
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
    GetElementByCaption(value, AOwner)
  else if (using = 'name') then
    GetElementByName(value, AOwner)
  else if (using = 'class name') then
    GetElementByClassName(value, AOwner)
  // 'partial link text '
  // 'id'
end;


end.
