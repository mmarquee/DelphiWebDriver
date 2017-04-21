unit Commands.PostElement;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TPostElementCommand = class(TRestCommand)
  private
    procedure GetElementByName(const value:String; AOwner: TForm);
    procedure GetElementByCaption(const value:String; AOwner: TForm);
    procedure GetElementByClassName(const value:String; AOwner: TForm);
    procedure GetElementByPartialCaption(const value:String; AOwner: TForm);

    function OKResponse(const sessionId, handle: String): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Types,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

procedure TPostElementCommand.GetElementByName(const value:String; AOwner: TForm);
var
  comp: TComponent;

begin
  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
      comp := AOwner.FindComponent(value);

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)));

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
      for i := 0 to tForm(AOwner).ControlCount -1 do
        if tForm(AOwner).Controls[i].ClassName = value then
        begin
          comp := tForm(AOwner).Controls[i];
          break;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.GetElementByPartialCaption(const value:String; AOwner: TForm);
begin
  Error(404);
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
      for i := 0 to tForm(AOwner).ControlCount -1 do

        // Vcl.ExtCtrls ..
        // TButtonedEdit
        // THeader
        // TPanel

        // Vcl.StdCtrls ..
        // TButton - done
        // TCheckBox
        // TComboBox
        // TEdit
        // TLabel
        // TListBox
        // TRadioButton
        // TStaticText
        // TMemo

        // Specifically from the test host
        // TTreeView
        // TRichEdit
        // TToolbar
        // TToolbarButton
        // TPageControl
        // TTabSheet
        // TStatusBar
        // TMainMenu
        // TMenuItem
        // TPopupMenu
        // TStringGrid
        // TMaskedEdit
        // TLinkLabel

        // TSpeedButton - no window here, need to 'fake' one

        // Need to get each type of control and check the caption / text
        if (tForm(AOwner).Controls[i] is TButton) then
        begin
          if (tForm(AOwner).Controls[i] as TButton).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end
        else if (tForm(AOwner).Controls[i] is TPanel) then
        begin
          if (tForm(AOwner).Controls[i] as TPanel).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end
        else if (tForm(AOwner).Controls[i] is TEdit) then
        begin
          if (tForm(AOwner).Controls[i] as TEdit).Text = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(self.OKResponse(self.Params[1], IntToStr((comp as TWinControl).Handle)));

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
  else if (using = 'partial link text') then
    GetElementByPartialCaption(value, AOwner)
  // 'id' (automation id)
end;

function TPostElementCommand.OKResponse(const sessionId, handle: String): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  // Construct reply
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionID', sessionId)
      .Add('status', 0)
      .BeginObject('value')
        .Add('ELEMENT', handle)
      .EndObject
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
